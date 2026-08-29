#!/usr/bin/env node
// Собирает реальные отзывы студентов о конкретных магистерских программах
// (Reddit/форумы + сайты-агрегаторы отзывов вроде StudentCrowd/WhatUni) и
// прогоняет через ИИ-синтез в короткое честное саммари по-русски.
//
// Это ОТДЕЛЬНО от pros/cons программы (те — официальные факты с сайта
// вуза, см. scripts/research-programs.mjs). Здесь — субъективное мнение
// реальных студентов, если оно вообще нашлось. Пишет в новые колонки
// programs.student_sentiment / student_sentiment_sources /
// student_sentiment_updated_at — сначала нужно применить миграцию
// sql/2026-08-28-add-student-sentiment-column.sql в Supabase.
//
// Как и research-programs.mjs, этот скрипт сам не пишет в базу — готовит
// SQL с UPDATE-командами. Применить: `node scripts/run-sql.mjs sql/<файл>.sql
// --apply` (нужен SUPABASE_SERVICE_ROLE_KEY в .env.local, есть с 2026-08-28).
//
// Тот же баг прокси api.apihost.one, что и в research-programs.mjs: ОДИН
// раунд параллельных поисковых запросов — работает; второй раунд —
// теряет финальный ответ без ошибки. Промпт ниже это учитывает.
//
// Использование:
//   node scripts/research-reviews.mjs --country de --limit 5
//   node scripts/research-reviews.mjs --program-id <uuid>
//   node scripts/research-reviews.mjs --university-id <uuid> --limit 20

import Anthropic from '@anthropic-ai/sdk'
import { createClient } from '@supabase/supabase-js'
import { readFileSync, writeFileSync, mkdirSync } from 'fs'
import { jsonrepair } from 'jsonrepair'

const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText
    .split('\n')
    .map((l) => l.trim())
    .filter((l) => l && !l.startsWith('#') && l.includes('='))
    .map((l) => {
      const idx = l.indexOf('=')
      return [l.slice(0, idx).trim(), l.slice(idx + 1).trim()]
    })
)

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, arr) => {
    if (a.startsWith('--')) acc.push([a.slice(2), arr[i + 1] && !arr[i + 1].startsWith('--') ? arr[i + 1] : true])
    return acc
  }, [])
)

// claude-opus-5 empirically failed 12/12 on this proxy for this exact
// prompt shape (2026-08-28: returned client-side tool_use blocks instead
// of executing web_search server-side, or answered in plain text without
// the required JSON) — claude-sonnet-5 works reliably for the same task.
// Not a cost-based downgrade; a proxy-compatibility finding. Re-test
// opus-5 here before switching back if this matters later.
const MODEL = args.model ?? 'claude-sonnet-5'
const LIMIT = Number(args.limit ?? 10)
const SLEEP_MS = Number(args.sleep ?? 2000)
const ONLY_MISSING = args['only-missing'] !== 'false' // по умолчанию — пропускать уже собранные

const anthropic = new Anthropic({ apiKey: env.ANTHROPIC_API_KEY, baseURL: env.ANTHROPIC_BASE_URL })
const supabase = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_ANON_KEY)

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

async function fetchTargets() {
  if (args['program-id']) {
    const { data, error } = await supabase
      .from('programs')
      .select('id, name, university:universities(name, country)')
      .eq('id', args['program-id'])
      .single()
    if (error) throw error
    return [data]
  }

  const selectCols = ONLY_MISSING
    ? 'id, name, student_sentiment, university:universities!inner(name, country)'
    : 'id, name, university:universities!inner(name, country)'
  let query = supabase.from('programs').select(selectCols).limit(LIMIT)
  if (args.country) query = query.eq('university.country', args.country)
  if (args['university-id']) query = query.eq('university_id', args['university-id'])
  const { data, error } = await query
  if (error) {
    if (error.code === '42703') {
      throw new Error(
        `Колонка student_sentiment ещё не создана — сначала примени sql/2026-08-28-add-student-sentiment-column.sql в Supabase. ` +
        `Либо для теста без миграции запусти с --only-missing=false.`
      )
    }
    throw error
  }
  return ONLY_MISSING ? data.filter((p) => !p.student_sentiment) : data
}

function buildPrompt(universityName, programName) {
  return `You are researching what REAL STUDENTS say about a specific master's program — for a study-abroad app helping non-EU (mostly Russian/CIS) students decide where to apply. This is different from official program facts (tuition/deadlines, which we already have) — we want genuine student sentiment: what do people who actually studied there say?

Program: "${programName}" at ${universityName}

IMPORTANT — how to search: you get exactly ONE round of web searches. Issue several PARALLEL queries in that single round covering different kinds of sources, e.g.:
- site:reddit.com ${universityName} ${programName}
- "${universityName}" "${programName}" review
- "${universityName}" "${programName}" experience OR forum
- ${universityName} ${programName} studentcrowd OR whatuni

Do not do a second round of searching after seeing the first round's results — a second round silently loses the final answer on this platform. After that one batch comes back, immediately write your final answer.

## Be honest about absence of data
Many specific programs (as opposed to the university overall) simply have no real online discussion. If your searches turn up nothing specific to THIS program — no Reddit threads, no forum posts, no review-site entries, nothing beyond the university's own marketing copy — say so honestly: set "student_sentiment_ru" to null and "confidence" to "none". Do NOT invent plausible-sounding sentiment, and do NOT just paraphrase the university's official program page as if it were a student opinion — that's not a real review, and passing it off as one would mislead applicants.

If you do find genuine student commentary, summarize it in 2-4 sentences in Russian, specific and concrete (e.g. "студенты хвалят практическую часть, но жалуются на переполненные группы на первом курсе" — not vague praise). Cite the actual URLs you found it at.

Output ONLY this JSON (no markdown fences, no other text):
{
  "student_sentiment_ru": "2-4 sentences in Russian, or null if nothing substantive found",
  "sources": ["url1", "url2"],
  "confidence": "none" | "low" | "medium" | "high"
}`
}

async function researchOne(universityName, programName) {
  const stream = anthropic.messages.stream({
    model: MODEL,
    max_tokens: 16000,
    tools: [{ type: 'web_search_20260209', name: 'web_search', max_uses: 6 }],
    messages: [{ role: 'user', content: buildPrompt(universityName, programName) }],
  })
  const response = await stream.finalMessage()

  const textBlocks = response.content.filter((b) => b.type === 'text')
  const fullText = textBlocks.map((b) => b.text).join('\n')
  const start = fullText.indexOf('{')
  const end = fullText.lastIndexOf('}')
  if (start === -1 || end === -1) {
    const blockSummary = response.content.map((b) => b.type).join(', ')
    throw new Error(`No JSON object found. stop_reason=${response.stop_reason}, blocks=[${blockSummary}]`)
  }
  const raw = fullText.slice(start, end + 1)
  let parsed
  try {
    parsed = JSON.parse(raw)
  } catch {
    parsed = JSON.parse(jsonrepair(raw))
  }
  return { result: parsed, usage: response.usage }
}

function sqlEscape(str) {
  return String(str ?? '').replace(/'/g, "''")
}
function sqlArray(arr) {
  if (!arr || !arr.length) return 'array[]::text[]'
  return `array[${arr.map((s) => `'${sqlEscape(s)}'`).join(', ')}]`
}

async function main() {
  const targets = await fetchTargets()
  console.log(`Программ для сбора отзывов: ${targets.length} (модель: ${MODEL})\n`)

  const updates = []
  const errors = []
  let totalUsage = { input_tokens: 0, output_tokens: 0 }

  for (const p of targets) {
    const uniName = p.university?.name ?? '(unknown)'
    process.stdout.write(`  ${uniName} — ${p.name}... `)
    try {
      const { result, usage } = await researchOne(uniName, p.name)
      totalUsage.input_tokens += usage.input_tokens ?? 0
      totalUsage.output_tokens += usage.output_tokens ?? 0
      console.log(result.confidence === 'none' ? 'ничего не найдено' : `найдено (${result.confidence})`)
      updates.push({ id: p.id, ...result })
    } catch (e) {
      console.log('ОШИБКА')
      errors.push(`${uniName} — ${p.name}: ${e.message}`)
    }
    await sleep(SLEEP_MS)
  }

  const today = new Date().toISOString().slice(0, 10)
  let sql = `-- Автоматически собрано инструментом scripts/research-reviews.mjs
-- Дата: ${today}, модель: ${MODEL}
--
-- Отзывы реальных студентов (Reddit/форумы + сайты-агрегаторы), НЕ
-- официальные факты с сайта вуза. student_sentiment=null означает, что
-- по этой конкретной программе не нашлось ничего существенного — это
-- честный результат, не ошибка сбора.
--
-- Требует, чтобы миграция sql/2026-08-28-add-student-sentiment-column.sql
-- уже была применена. НЕ запущено в Supabase — выполнить вручную.
${errors.length ? `--\n-- Ошибки при сборе:\n${errors.map((e) => `-- - ${e}`).join('\n')}\n` : ''}
begin;
`

  for (const u of updates) {
    const foundNote = u.confidence === 'none'
      ? '-- Ничего существенного не найдено — student_sentiment оставлен null, а не выдуман.'
      : `-- Уверенность: ${u.confidence}. Источники: ${(u.sources || []).join(', ')}`
    sql += `\n${foundNote}\n`
    sql += `update programs set
  student_sentiment = ${u.student_sentiment_ru ? `'${sqlEscape(u.student_sentiment_ru)}'` : 'null'},
  student_sentiment_sources = ${sqlArray(u.sources)},
  student_sentiment_updated_at = current_date
where id = '${u.id}';\n`
  }

  sql += `\ncommit;\n`

  mkdirSync(new URL('../sql', import.meta.url), { recursive: true })
  const outPath = new URL(`../sql/${today}-student-reviews.sql`, import.meta.url)
  writeFileSync(outPath, sql, 'utf8')

  const foundCount = updates.filter((u) => u.confidence !== 'none').length
  console.log(`\nГотово: ${updates.length} программ обработано, у ${foundCount} нашлись реальные отзывы.`)
  console.log(`Токенов потрачено: ${totalUsage.input_tokens} input / ${totalUsage.output_tokens} output`)
  console.log(`Файл: ${outPath.pathname.replace(/^\//, '')}`)
  if (errors.length) console.log(`\nОшибки (${errors.length}):`, errors)
}

main().catch((e) => {
  console.error('Фатальная ошибка:', e)
  process.exit(1)
})
