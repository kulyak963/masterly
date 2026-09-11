#!/usr/bin/env node
// Точечная задача (2026-09-11, ночной прогон по просьбе Дениса "проверить
// рейтинг QS"): 46 из 131 вузов в базе не имеют universities.ranking_qs
// вообще (никогда не заполнялось для вузов, добавленных вне первой волны
// сбора). Отдельно от scripts/research-programs.mjs — это простой
// фактический лукап (один номер + источник), не тюишн/дедлайн/язык, не
// нужен весь трёхшаговый comprehensive-конвейер.
//
// Каждый вуз — один web_search-вызов (один раунд, см. известную находку
// про прокси api.apihost.one в CLAUDE.md). Если QS публикует точный ранг —
// пишем как есть. Если только диапазон (например "801-1000", так QS
// показывает вузы за пределами топ-500) — пишем нижнюю границу диапазона
// (консервативнее, чем середина) и объясняем в source_note. Если вуз в
// последнем QS World University Rankings не участвует вообще — null, не
// выдумываем номер.
//
// Пишет напрямую в БД через service-role ключ (не готовит SQL-файл — это
// быстрая точечная задача на 46 строк, ручной SQL Editor тут не нужен).
//
// Использование:
//   node scripts/fill-qs-rankings.mjs --dry-run     # только показать, не писать
//   node scripts/fill-qs-rankings.mjs               # реальная запись

import Anthropic from '@anthropic-ai/sdk'
import { createClient } from '@supabase/supabase-js'
import { readFileSync, appendFileSync } from 'fs'

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
const MODEL = args.model ?? 'claude-sonnet-5'
const LIMIT = args.limit ? Number(args.limit) : Infinity

const anthropic = new Anthropic({ apiKey: env.ANTHROPIC_API_KEY, baseURL: env.ANTHROPIC_BASE_URL })
const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

async function withRetry(fn, attempts = 3) {
  let lastErr
  for (let i = 1; i <= attempts; i++) {
    try { return await fn() } catch (e) {
      lastErr = e
      if (i < attempts) { console.log(`  (попытка ${i} не удалась: ${e.message}, повтор)`); await sleep(3000 * i) }
    }
  }
  throw lastErr
}

function buildPrompt(uni) {
  return `What is "${uni.name}" (${uni.city}, ${uni.country}${uni.website ? `, ${uni.website}` : ''})'s rank in the QS World University Rankings (most recent edition, 2026 or 2025 if 2026 isn't out yet)?

## How to search — ONE round only, hard platform limit
Issue your search queries as PARALLEL calls in a single round (e.g. "\\"${uni.name}\\" QS World University Rankings 2026" plus a couple variants). Do not search again after seeing results — a second round silently discards the whole response on this platform.

## Output rules
- If QS gives an exact numeric rank (e.g. 247), use that exact number.
- If QS only gives a band for this university (common outside the top ~500, e.g. "801-1000" or "1201+"), use the LOWER bound of the band as the number (e.g. 801 for "801-1000"), and say the real band in source_note_ru.
- If the university is not ranked by QS at all in the most recent edition, set rank to null — do not invent a plausible-sounding number.
- If you are not confident which edition your source is (QS rankings change yearly and old cached pages are common), say so in source_note_ru and still give your best answer.

## Output — ONLY this JSON array with exactly one object, no markdown fences, no other text:
[{"rank": 247, "edition": "QS World University Rankings 2026", "source_note_ru": "что нашли и откуда, по-русски"}]
Use literal null for "rank" if genuinely not ranked.`
}

// Тот же проверенный паттерн, что и callWithSearchExpectArray в
// research-programs.mjs (см. комментарий там про баг прокси с повторным
// раундом поиска — пустой ответ без ошибки, известное и уже решённое
// поведение через продолжение хода при stop_reason=pause_turn).
async function callWithSearch(prompt) {
  let messages = [{ role: 'user', content: prompt }]
  let response
  for (let i = 0; i < 6; i++) {
    const stream = anthropic.messages.stream({
      model: MODEL,
      max_tokens: 16000,
      tools: [{ type: 'web_search_20260209', name: 'web_search', max_uses: 4 }],
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

async function fetchRank(uni) {
  const [result] = await withRetry(() => callWithSearch(buildPrompt(uni)), 3)
  return result
}

async function main() {
  const { data: allUnis, error } = await admin.from('universities').select('id,name,city,website,country').is('ranking_qs', null).order('country')
  if (error) throw error
  const unis = allUnis.slice(0, LIMIT)
  console.log(`${unis.length} из ${allUnis.length} вузов без QS-рейтинга. ${DRY_RUN ? '(DRY RUN — без записи в БД)' : 'Пишу напрямую в БД.'}\n`)

  const logPath = new URL(`../scripts/logs/qs-rankings-${new Date().toISOString().slice(0, 10)}.log`, import.meta.url)
  let done = 0, found = 0, nullCount = 0, errCount = 0

  for (const uni of unis) {
    process.stdout.write(`${uni.country} ${uni.name}... `)
    try {
      const result = await fetchRank(uni)
      const line = `${uni.name} (${uni.country}) -> rank=${result.rank} [${result.edition}] ${result.source_note_ru}\n`
      appendFileSync(logPath, line, 'utf8')
      if (result.rank == null) {
        console.log('не ранжирован (честный null)')
        nullCount++
      } else {
        console.log(`#${result.rank}`)
        found++
        if (!DRY_RUN) {
          const { error: updErr } = await admin.from('universities').update({ ranking_qs: result.rank }).eq('id', uni.id)
          if (updErr) { console.log(`   ОШИБКА ЗАПИСИ: ${updErr.message}`); errCount++ }
        }
      }
    } catch (e) {
      console.log(`ОШИБКА: ${e.message}`)
      appendFileSync(logPath, `${uni.name} (${uni.country}) -> ОШИБКА: ${e.message}\n`, 'utf8')
      errCount++
    }
    done++
    await sleep(1500)
  }

  console.log(`\nГотово: ${done} обработано, ${found} рейтингов найдено и записано, ${nullCount} честно не ранжированы, ${errCount} ошибок.`)
  console.log(`Лог: ${logPath.pathname.replace(/^\//, '')}`)
}

main().catch((e) => { console.error('Фатальная ошибка:', e); process.exit(1) })
