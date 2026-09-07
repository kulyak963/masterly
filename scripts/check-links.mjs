#!/usr/bin/env node
// Фаза 0, задача 0.6 (см. аудит продукта 2026-09-07 и план исправлений).
//
// Проверяет url каждой программы настоящим HTTP-запросом и пишет
// результат в url_status/url_checked_at (см. sql/2026-09-08-tuition-truth.sql).
// По умолчанию — dry run (только отчёт). --apply пишет в базу.
// --dead-only в отчёте показывает только проблемные (по умолчанию и так
// печатаются только проблемные — используй --all для полного списка).
//
// Использование:
//   node scripts/check-links.mjs                 (проверить все, отчёт)
//   node scripts/check-links.mjs --apply          (проверить и записать статус)
//   node scripts/check-links.mjs --country de     (только одна страна)
//   node scripts/check-links.mjs --concurrency 8  (по умолчанию 6)

import { readFileSync } from 'node:fs'
import { createClient } from '@supabase/supabase-js'

const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText.split('\n').filter((l) => l.includes('=')).map((l) => { const i = l.indexOf('='); return [l.slice(0, i), l.slice(i + 1)] })
)
const args = process.argv.slice(2)
const APPLY = args.includes('--apply')
const onlyCountry = args.includes('--country') ? args[args.indexOf('--country') + 1] : null
const CONCURRENCY = args.includes('--concurrency') ? Number(args[args.indexOf('--concurrency') + 1]) : 6
const TIMEOUT_MS = 8000
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'

const db = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

async function checkUrl(url) {
  const ctrl = new AbortController()
  const t = setTimeout(() => ctrl.abort(), TIMEOUT_MS)
  try {
    let res = await fetch(url, { method: 'GET', redirect: 'follow', signal: ctrl.signal, headers: { 'User-Agent': UA } })
    return res.status
  } catch (e) {
    return e.name === 'AbortError' ? -1 : -2 // -1 timeout, -2 DNS/network/other
  } finally {
    clearTimeout(t)
  }
}

async function mapLimit(items, limit, fn) {
  const results = new Array(items.length)
  let i = 0
  async function worker() {
    while (i < items.length) {
      const idx = i++
      results[idx] = await fn(items[idx], idx)
    }
  }
  await Promise.all(Array.from({ length: limit }, worker))
  return results
}

async function main() {
  const { data: unis } = await db.from('universities').select('id,name,country')
  const uniById = Object.fromEntries(unis.map((u) => [u.id, u]))

  let all = []
  for (let from = 0; from < 5000; from += 1000) {
    const { data, error } = await db.from('programs').select('id,name,url,university_id').range(from, from + 999)
    if (error) { console.error('Не удалось прочитать programs:', error.message); process.exit(1) }
    if (!data?.length) break
    all = all.concat(data)
    if (data.length < 1000) break
  }

  let targets = all.filter((p) => p.url)
  if (onlyCountry) targets = targets.filter((p) => uniById[p.university_id]?.country === onlyCountry)

  console.log(`Проверяю ${targets.length} ссылок (concurrency=${CONCURRENCY})...\n`)

  let done = 0
  const results = await mapLimit(targets, CONCURRENCY, async (p) => {
    const status = await checkUrl(p.url)
    done++
    if (done % 50 === 0) process.stderr.write(`  ...${done}/${targets.length}\n`)
    return { p, status }
  })

  const dead = results.filter((r) => r.status === 0 || r.status === -1 || r.status === -2 || r.status >= 400)
  const ok = results.length - dead.length

  console.log(`\nЖивых: ${ok} | Проблемных: ${dead.length}\n`)
  for (const { p, status } of dead) {
    const uni = uniById[p.university_id]
    const label = status === -1 ? 'ТАЙМАУТ' : status === -2 ? 'DNS/СЕТЬ' : status
    console.log(`  ${label} | ${uni?.country?.toUpperCase() ?? '?'} | ${uni?.name} | ${p.name} | ${p.url}`)
  }

  if (!APPLY) {
    console.log('\nЭто был dry run. Запусти с --apply, чтобы записать url_status/url_checked_at в базу.')
    return
  }

  const now = new Date().toISOString()
  let written = 0
  // Раньше писали строго по одной (await в for-цикле на 1405 записей) —
  // укладывалось не всегда: первый прогон оборвался на 344/1405 по
  // таймауту процесса, так и не дойдя до конца последовательной записи.
  // Параллелим тем же mapLimit, что и сама проверка ссылок.
  await mapLimit(results, CONCURRENCY, async ({ p, status }) => {
    const { error } = await db.from('programs').update({ url_status: status, url_checked_at: now }).eq('id', p.id)
    if (error) console.error(`  ОШИБКА записи (${p.name}):`, error.message)
    else written++
  })
  console.log(`\nЗаписано url_status для ${written} программ.`)
}

main().catch((e) => { console.error('Фатальная ошибка:', e); process.exit(1) })
