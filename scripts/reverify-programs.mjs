#!/usr/bin/env node
// Ночной прогон 2026-09-11 по просьбе Дениса: "пробить программы, чтобы
// стали верифицированными, проверить ссылки/дедлайны/стоимость/QS".
//
// В отличие от scripts/research-programs.mjs (который ИЩЕТ НОВЫЕ программы
// по стране и только INSERT'ит) — этот скрипт берёт программы, УЖЕ
// существующие в базе, и делает по ним прямой UPDATE:
//   - если ссылка мертва (url_status по правилам lib/linkHealth.ts
//     isDeadLink — 404/410/таймаут/DNS) — ищет актуальную страницу;
//   - если ещё не verified=true — пытается подтвердить тюишн/дедлайн/язык
//     на официальной странице по тому же строгому правилу, что и весь
//     остальной сбор данных за сессию (verified=true только когда все три
//     подтверждены ВМЕСТЕ на ОДНОЙ официальной странице для не-ЕС).
//
// Пишет напрямую в БД через service-role ключ (не готовит SQL-файл — это
// ночной автономный прогон, часы работы, писать нужно по ходу, не одним
// SQL в конце — тот же урок, что и в research-programs.mjs про
// потерянные результаты при падении процесса).
//
// Порядок очереди (см. priority ниже) — сначала то, что даёт больше
// пользы за один и тот же вызов: мёртвые ссылки в странах с платным
// гайдом (DE/NL/HU/IT, см. lib/legal.ts GUIDE_COUNTRIES — их видят
// платящие пользователи), затем мёртвые ссылки везде, затем обычная
// повторная верификация неverified-программ (тоже гайд-страны сначала).
// Уже verified=true И живые программы пропускаются целиком — там нечего
// улучшать.
//
// 2026-09-11, ВАЖНАЯ НАХОДКА перед первым реальным прогоном: сегодня
// прокси api.apihost.one перестал реально исполнять серверный инструмент
// web_search (и web_search_20250305, и web_search_20260209) — модель
// возвращает пустой tool_use с input:{} и на этом всё, ни одного реального
// поиска не происходит (stop_reason=tool_use вместо ожидаемого текста).
// Обычные текстовые вызовы (без web_search) при этом работают нормально —
// проблема именно и только в этом конкретном инструменте на этом прокси
// прямо сейчас, не в балансе/ключе/остальном API. Пока это не починится
// (скорее всего на стороне прокси — стоит проверить баланс/статус именно
// функции поиска в личном кабинете api.apihost.one), этот скрипт будет
// падать на каждом вызове с ошибкой "нет JSON в ответе. stop_reason=tool_use".
// Код скрипта при этом уже готов и ждёт — как только поиск починится,
// просто запустить.
//
// Использование:
//   node scripts/reverify-programs.mjs --dry-run --limit 5    # тест, без записи
//   node scripts/reverify-programs.mjs --limit 20              # реальная запись, малая партия
//   node scripts/reverify-programs.mjs                         # полный ночной прогон

import Anthropic from '@anthropic-ai/sdk'
import { createClient } from '@supabase/supabase-js'
import { readFileSync, appendFileSync, mkdirSync } from 'fs'

const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText.split('\n').map((l) => l.trim()).filter((l) => l && !l.startsWith('#') && l.includes('='))
    .map((l) => { const i = l.indexOf('='); return [l.slice(0, i).trim(), l.slice(i + 1).trim()] })
)

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, arr) => {
    if (a.startsWith('--')) acc.push([a.slice(2), arr[i + 1] && !arr[i + 1].startsWith('--') ? arr[i + 1] : true])
    return acc
  }, [])
)
const DRY_RUN = !!args['dry-run']
const LIMIT = args.limit ? Number(args.limit) : Infinity
const CONCURRENCY = Number(args.concurrency ?? 3)
const MODEL = args.model ?? 'claude-sonnet-5'

// см. lib/legal.ts GUIDE_COUNTRIES — платный гайд покрывает эти 4 страны,
// их программы видят реальные платящие пользователи в первую очередь.
const GUIDE_COUNTRIES = new Set(['de', 'nl', 'hu', 'it'])

const anthropic = new Anthropic({ apiKey: env.ANTHROPIC_API_KEY, baseURL: env.ANTHROPIC_BASE_URL })
const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

function isDeadLink(status) {
  if (status == null) return false
  if (status <= 0) return true
  return status === 404 || status === 410
}

async function withRetry(fn, attempts = 3) {
  let lastErr
  for (let i = 1; i <= attempts; i++) {
    try { return await fn() } catch (e) {
      lastErr = e
      if (i < attempts) await sleep(3000 * i)
    }
  }
  throw lastErr
}

// Тот же UA/таймаут/семантика статусов, что и scripts/check-links.mjs —
// один и тот же столбец url_status используется обоими инструментами,
// коды должны значить одно и то же (-1 таймаут, -2 DNS/сеть).
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'
async function checkUrl(url) {
  const ctrl = new AbortController()
  const t = setTimeout(() => ctrl.abort(), 8000)
  try {
    const res = await fetch(url, { method: 'GET', redirect: 'follow', signal: ctrl.signal, headers: { 'User-Agent': UA } })
    return res.status
  } catch (e) {
    return e.name === 'AbortError' ? -1 : -2
  } finally {
    clearTimeout(t)
  }
}

// Тот же проверенный паттерн, что callWithSearchExpectArray в
// research-programs.mjs (продолжение хода на pause_turn, жёсткий таймаут
// с abort — прокси иногда виснет без ответа и без ошибки).
async function callWithSearch(prompt, { maxTokens = 16000, maxUses = 5 } = {}) {
  let messages = [{ role: 'user', content: prompt }]
  let response
  for (let i = 0; i < 6; i++) {
    const stream = anthropic.messages.stream({
      model: MODEL,
      max_tokens: maxTokens,
      tools: [{ type: 'web_search_20260209', name: 'web_search', max_uses: maxUses }],
      messages,
    })
    response = await Promise.race([
      stream.finalMessage(),
      new Promise((_, reject) => setTimeout(() => { stream.abort(); reject(new Error('timeout: прокси не ответил за 90с')) }, 90000)),
    ])
    if (response.stop_reason !== 'pause_turn') break
    messages = [...messages, { role: 'assistant', content: response.content }]
  }
  const fullText = response.content.filter((b) => b.type === 'text').map((b) => b.text).join('\n')
  const start = fullText.indexOf('[')
  const end = fullText.lastIndexOf(']')
  if (start === -1 || end === -1) {
    const blockSummary = response?.content?.map((b) => b.type).join(', ') ?? '?'
    throw new Error(`нет JSON в ответе. stop_reason=${response?.stop_reason}, blocks=[${blockSummary}]. Text: ${fullText.slice(0, 300) || '(пусто)'}`)
  }
  return JSON.parse(fullText.slice(start, end + 1))
}

function buildPrompt(p) {
  const dead = isDeadLink(p.url_status)
  return `You're re-checking ONE specific real master's program already in our database, for a study-abroad app serving non-EU (mostly Russian/CIS) students.

Program: "${p.name}" at ${p.university} (${p.city}, ${p.country})
Known URL: ${p.url}${dead ? ' — THIS URL IS CURRENTLY BROKEN (confirmed dead by a fresh HTTP check tonight).' : ''}

${dead ? `## Priority 1: find the current page\nUniversity sites restructure often. Search for the program by name at this university to find its CURRENT official admissions page. If you genuinely cannot find any trace of this program continuing (discontinued, merged into another program beyond recognition) — set still_offered=false and url to null, and explain what you found instead.\n` : ''}
## Priority ${dead ? '2' : '1'}: confirm tuition, deadline, language requirement
Specifically for NON-EU/international students (our audience) — many European universities show a lower EU/EEA rate on the same page as a higher non-EU rate. Actively look for the distinction.

## How to search — ONE round only, hard platform limit
Issue a few PARALLEL search queries in a single round. Do not search again after seeing results — a second round silently discards the whole response on this platform.

## Never fabricate
verified=true only when tuition+deadline+language are ALL confirmed for non-EU students on the SAME official page cited in "url". If a real figure can't be found, use your best-sourced estimate and set verified=false, explaining what's missing in cons_ru. If you found NOTHING usable, set that field to null rather than inventing a plausible-sounding number — a labeled "unknown" beats a confident-looking guess. Never invent a URL — only use one that literally appeared in search results.

## Output — ONLY this JSON array with exactly one object, no markdown fences, no other text:
[{
  "still_offered": true,
  "url": "https://real-url-you-confirmed-or-found",
  "tuition_eur": 6400,
  "deadline_month": 4,
  "deadline_day": 30,
  "ielts_min": 6.0,
  "gpa_min": null,
  "verified": true,
  "cons_note_ru": "если verified=false — что именно не подтвердилось",
  "source_note_ru": "что подтверждено и почему verified true/false, по-русски"
}]
Use still_offered=false and url=null only if the program is genuinely gone — never as a substitute for "couldn't find pricing".`
}

async function processOne(p, logPath) {
  const result = await withRetry(() => callWithSearch(buildPrompt(p)), 3)
  const r = result[0]
  if (!r) throw new Error('пустой результат от модели')

  const update = { tuition_checked_at: new Date().toISOString() }
  let action = 'no-op'

  if (r.still_offered === false) {
    update.url_status = p.url_status // не трогаем — уже честно помечено как мёртвое
    action = 'discontinued'
  } else {
    if (r.url && r.url !== p.url) {
      const freshStatus = await checkUrl(r.url)
      if (freshStatus >= 200 && freshStatus < 400) {
        update.url = r.url
        update.url_status = freshStatus
        update.url_checked_at = new Date().toISOString()
        action = 'url-fixed'
      }
    } else if (isDeadLink(p.url_status)) {
      // Не нашли новую ссылку для мёртвой программы — перепроверим старую
      // на всякий случай (могла отойти), но не трогаем данные.
      const freshStatus = await checkUrl(p.url)
      update.url_status = freshStatus
      update.url_checked_at = new Date().toISOString()
    }

    if (r.tuition_eur != null) update.tuition_eur = r.tuition_eur
    if (r.deadline_month != null) update.deadline_month = r.deadline_month
    if (r.deadline_day != null) update.deadline_day = r.deadline_day
    if (r.ielts_min != null) update.ielts_min = r.ielts_min
    if (r.gpa_min != null) update.gpa_min = r.gpa_min

    if (r.verified) {
      update.verified = true
      update.verified_at = new Date().toISOString()
      update.tuition_status = 'verified'
      action = action === 'url-fixed' ? 'url-fixed+verified' : 'verified'
    } else if (!p.verified) {
      // Никогда не понижаем уже verified=true программу молча — если модель
      // сегодня не смогла переподтвердить все три факта на новой странице,
      // это ЯВНО логируется как downgrade-кандидат, не тихая правка.
      update.tuition_status = r.tuition_eur != null ? 'ai' : p.tuition_status
      if (action === 'no-op') action = 'ai-refreshed'
    } else {
      action = 'DOWNGRADE-CANDIDATE (был verified=true, сегодня не переподтвердилось)'
    }
  }

  const logLine = JSON.stringify({ id: p.id, name: p.name, university: p.university, action, before: { url: p.url, url_status: p.url_status, verified: p.verified }, update, note: r.source_note_ru }) + '\n'
  appendFileSync(logPath, logLine, 'utf8')

  if (!DRY_RUN && action !== 'DOWNGRADE-CANDIDATE (был verified=true, сегодня не переподтвердилось)') {
    const { error } = await admin.from('programs').update(update).eq('id', p.id)
    if (error) throw new Error(`ошибка записи в БД: ${error.message}`)
  }
  return action
}

async function buildQueue() {
  const { data: unis } = await admin.from('universities').select('id,name,city,website,country')
  const idToUni = new Map(unis.map((u) => [u.id, u]))
  let all = []
  let from = 0
  while (true) {
    const { data, error } = await admin.from('programs').select('*').range(from, from + 999)
    if (error) throw error
    all = all.concat(data)
    if (data.length < 1000) break
    from += 1000
  }
  const enriched = all.map((p) => ({ ...p, university: idToUni.get(p.university_id)?.name, city: idToUni.get(p.university_id)?.city, website: idToUni.get(p.university_id)?.website, country: idToUni.get(p.university_id)?.country }))

  const dead = enriched.filter((p) => isDeadLink(p.url_status))
  const deadIds = new Set(dead.map((p) => p.id))
  const needsVerify = enriched.filter((p) => !p.verified && !deadIds.has(p.id))

  const byGuideFirst = (a, b) => (GUIDE_COUNTRIES.has(b.country) ? 1 : 0) - (GUIDE_COUNTRIES.has(a.country) ? 1 : 0)
  dead.sort(byGuideFirst)
  needsVerify.sort(byGuideFirst)

  return [...dead, ...needsVerify]
}

async function main() {
  console.log('Собираю очередь...')
  const queue = (await buildQueue()).slice(0, LIMIT)
  console.log(`В очереди: ${queue.length} программ (мёртвые ссылки + неверифицированные, гайд-страны DE/NL/HU/IT первыми). ${DRY_RUN ? 'DRY RUN — без записи в БД.' : 'Пишу напрямую в БД по ходу.'}\n`)

  mkdirSync(new URL('../scripts/logs', import.meta.url), { recursive: true })
  const logPath = new URL(`../scripts/logs/reverify-${new Date().toISOString().slice(0, 10)}.jsonl`, import.meta.url)

  const stats = {}
  let done = 0
  let i = 0
  async function worker() {
    while (i < queue.length) {
      const p = queue[i++]
      process.stdout.write(`[${done + 1}/${queue.length}] ${p.country} ${p.university} — "${p.name}"... `)
      try {
        const action = await processOne(p, logPath)
        stats[action] = (stats[action] || 0) + 1
        console.log(action)
      } catch (e) {
        stats.error = (stats.error || 0) + 1
        console.log(`ОШИБКА: ${e.message}`)
        appendFileSync(logPath, JSON.stringify({ id: p.id, name: p.name, error: e.message }) + '\n', 'utf8')
      }
      done++
      await sleep(1500)
    }
  }
  await Promise.all(Array.from({ length: CONCURRENCY }, worker))

  console.log(`\nГотово: ${done} обработано.`)
  console.log(JSON.stringify(stats, null, 1))
  console.log(`Лог (по одной строке JSON на программу): ${logPath.pathname.replace(/^\//, '')}`)
}

main().catch((e) => { console.error('Фатальная ошибка:', e); process.exit(1) })
