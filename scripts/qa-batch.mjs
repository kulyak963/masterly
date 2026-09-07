#!/usr/bin/env node
// Фаза 3, задача 3.4 (план после аудита продукта 2026-09-07).
//
// Проверяет один из наших .sql файлов (сгенерированных research-
// programs.mjs) на признаки той же болезни, что уже нашли и починили в
// существующей базе — ДО того, как run-sql.mjs --apply запишет что-то
// в продакшн. Не блокирует запись сам (это отдельная команда) — просто
// печатает предупреждения, решение остаётся за человеком.
//
// Проверки:
// - tuition_eur = 0 без tuition_status = 'verified' (см. 0.1/0.3 —
//   именно так появились ложные "Бесплатно")
// - одна и та же цена у подозрительно большой доли записей партии
//   (признак того, что цифра не найдена, а угадана/скопирована)
// - gpa_min выглядит как старый дефолт-заглушка (ровно 3 у большинства)
// - url — не пустой и похож на настоящий адрес (не placeholder)
// - дедлайны не все свалены в один месяц (кроме случаев, когда это и
//   есть один реальный дедлайн-цикл — проверка мягкая, просто предупреждает)
//
// Использование:
//   node scripts/qa-batch.mjs sql/2026-09-08-de-law-medicine.sql

import { readFileSync } from 'node:fs'

const filePath = process.argv[2]
if (!filePath) {
  console.error('Использование: node scripts/qa-batch.mjs <путь-к-sql-файлу>')
  process.exit(1)
}

function splitTopLevel(str, sep = ',') {
  const parts = []
  let depth = 0, inStr = false, current = ''
  for (let i = 0; i < str.length; i++) {
    const ch = str[i]
    if (ch === "'") inStr = !inStr
    if (!inStr) { if (ch === '(' || ch === '[') depth++; if (ch === ')' || ch === ']') depth-- }
    if (ch === sep && depth === 0 && !inStr) { parts.push(current); current = '' } else current += ch
  }
  if (current.trim() !== '' || parts.length) parts.push(current)
  return parts.map((p) => p.trim()).filter((p) => p !== '')
}

function parseSqlValue(token) {
  token = token.trim()
  if (/^null$/i.test(token)) return null
  if (/^true$/i.test(token)) return true
  if (/^false$/i.test(token)) return false
  if (/^current_date$/i.test(token)) return new Date().toISOString().slice(0, 10)
  if (/^array\[/i.test(token)) {
    const openIdx = token.indexOf('[')
    let depth = 0, closeIdx = -1
    for (let i = openIdx; i < token.length; i++) {
      if (token[i] === '[') depth++
      else if (token[i] === ']') { depth--; if (depth === 0) { closeIdx = i; break } }
    }
    const inner = token.slice(openIdx + 1, closeIdx)
    if (!inner.trim()) return []
    return splitTopLevel(inner, ',').map((s) => parseSqlValue(s))
  }
  if (token.startsWith("'") && token.endsWith("'")) return token.slice(1, -1).replace(/''/g, "'")
  if (/^-?\d+(\.\d+)?$/.test(token)) return Number(token)
  return token
}

function findParenGroups(str) {
  const groups = []
  let depth = 0, inStr = false, current = '', capturing = false
  for (let i = 0; i < str.length; i++) {
    const ch = str[i]
    if (ch === "'") inStr = !inStr
    if (!inStr && ch === '(') { depth++; if (depth === 1) { capturing = true; current = ''; continue } }
    if (!inStr && ch === ')') { depth--; if (depth === 0 && capturing) { groups.push(current); capturing = false; continue } }
    if (capturing) current += ch
  }
  return groups
}

// Раньше здесь разбивали на операторы по первому ';' через regex — текст
// полей (summary/pros/cons) часто настоящий русский текст с собственной
// пунктуацией, и точка с запятой ВНУТРИ строкового значения обрубала
// оператор посередине, из-за чего часть программ терялась молча (см.
// живой пример: 10 реальных insert в файле, регэксп-версия находила 5).
// Тот же посимвольный разбор, что уже используется в run-sql.mjs —
// учитывает, находимся ли мы внутри '...'.
function splitStatements(sql) {
  const lines = sql.split('\n').map((line) => {
    let inStr = false
    for (let i = 0; i < line.length; i++) {
      if (line[i] === "'") inStr = !inStr
      if (!inStr && line[i] === '-' && line[i + 1] === '-') return line.slice(0, i)
    }
    return line
  })
  const cleaned = lines.join('\n')
  const statements = []
  let current = '', inStr = false
  for (let i = 0; i < cleaned.length; i++) {
    const ch = cleaned[i]
    current += ch
    if (ch === "'") inStr = !inStr
    if (ch === ';' && !inStr) { statements.push(current.slice(0, -1).trim()); current = '' }
  }
  if (current.trim()) statements.push(current.trim())
  return statements
}

function parseInsertPrograms(sql) {
  const rows = []
  for (const stmt of splitStatements(sql)) {
    if (!/^insert into programs/i.test(stmt)) continue
    const colsMatch = stmt.match(/insert into programs\s*\(([\s\S]*?)\)\s*values/i)
    if (!colsMatch) continue
    const cols = splitTopLevel(colsMatch[1], ',').map((c) => c.trim())
    const afterValues = stmt.slice(stmt.search(/values/i) + 6)
    const groups = findParenGroups(afterValues)
    for (const g of groups) {
      const vals = splitTopLevel(g, ',').map(parseSqlValue)
      rows.push(Object.fromEntries(cols.map((c, i) => [c, vals[i]])))
    }
  }
  return rows
}

const sql = readFileSync(filePath, 'utf8')
const rows = parseInsertPrograms(sql)

if (!rows.length) {
  console.log('Не нашёл ни одной программы для проверки (нет insert into programs в файле).')
  process.exit(0)
}

console.log(`Проверяю ${rows.length} программ из ${filePath}\n`)
const warnings = []

// 1. tuition_eur = 0 без verified
const falseFree = rows.filter((r) => r.tuition_eur === 0 && r.tuition_status !== 'verified')
if (falseFree.length) {
  warnings.push(`⚠ ${falseFree.length} программ с tuition_eur=0, но tuition_status≠'verified' — это ровно та ошибка, из-за которой появились ложные "Бесплатно" (см. 0.1/0.3). Если бесплатность не подтверждена на странице вуза, tuition_eur должен быть null, а не 0.`)
}

// 2. подозрительно одинаковая цена
const priceCounts = {}
for (const r of rows) if (r.tuition_eur != null) priceCounts[r.tuition_eur] = (priceCounts[r.tuition_eur] ?? 0) + 1
for (const [price, n] of Object.entries(priceCounts)) {
  if (n >= 5 && n / rows.length > 0.3) {
    warnings.push(`⚠ ${n} из ${rows.length} программ (${Math.round(n / rows.length * 100)}%) имеют одинаковую цену €${price}/год — стоит перепроверить, не скопирована ли цифра между разными вузами вместо реального поиска.`)
  }
}

// 3. gpa_min выглядит как старый дефолт-заглушка
const gpaThree = rows.filter((r) => r.gpa_min === 3).length
if (gpaThree > 0 && gpaThree / rows.length > 0.5) {
  warnings.push(`⚠ ${gpaThree} из ${rows.length} программ имеют gpa_min=3 — это была старая заглушка-дефолт (см. 0.1). Проверь, что это реально найденное требование, а не осталось от старого промпта.`)
}

// 4. url отсутствует или похож на заглушку
const badUrl = rows.filter((r) => !r.url || !/^https?:\/\//i.test(r.url))
if (badUrl.length) {
  warnings.push(`⚠ ${badUrl.length} программ без нормальной ссылки (пусто или не начинается с http): ${badUrl.slice(0, 5).map((r) => r.name).join(', ')}`)
}

// 5. дедлайны все в одном месяце
const monthCounts = {}
for (const r of rows) if (r.deadline_month != null) monthCounts[r.deadline_month] = (monthCounts[r.deadline_month] ?? 0) + 1
const distinctMonths = Object.keys(monthCounts).length
if (rows.length >= 8 && distinctMonths === 1) {
  warnings.push(`⚠ Все ${rows.length} программ с дедлайном в одном и том же месяце — возможно, дедлайн не искали по каждой программе отдельно, а поставили один "типичный" месяц всем. Мягкое предупреждение — иногда это и правда совпадение.`)
}

// 6. verified=true без tuition_checked_at/verified_at
const verifiedNoDate = rows.filter((r) => r.verified === true && !r.verified_at)
if (verifiedNoDate.length) {
  warnings.push(`⚠ ${verifiedNoDate.length} программ помечены verified=true без verified_at — проверь, что дата подтверждения проставляется.`)
}

if (!warnings.length) {
  console.log('Аномалий не найдено — партия выглядит чисто.')
} else {
  console.log(`Найдено ${warnings.length} предупреждений:\n`)
  for (const w of warnings) console.log(w + '\n')
  console.log('Это не блокирует запись — просмотри партию перед run-sql.mjs --apply.')
}
