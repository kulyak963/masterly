#!/usr/bin/env node
// Применяет один из наших .sql файлов через service_role ключ — без
// ручного похода в Supabase SQL Editor. НЕ универсальный SQL-движок:
// supabase-js вообще не умеет выполнять произвольный SQL текст (это
// REST-клиент, не подключение к Postgres) — этот скрипт вручную
// разбирает `insert into universities/programs` и `update programs`
// операторы, которые мы сами генерируем в известном, единообразном
// формате, и превращает их в обычные вызовы supabase-js.
// begin/commit пропускаются (REST не поддерживает транзакции) — при
// сбое части операции могут примениться, а часть нет; insert в
// universities использует on conflict/upsert-семантику, так что
// повторный запуск безопасен.
//
// По умолчанию — DRY RUN (ничего не пишет, только показывает, что было
// бы сделано). Добавь --apply, чтобы реально записать.
//
// Использование:
//   node scripts/run-sql.mjs sql/2026-08-28-hungary-top10-batch.sql
//   node scripts/run-sql.mjs sql/2026-08-28-hungary-top10-batch.sql --apply

import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'

const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText.split('\n').filter((l) => l.includes('=')).map((l) => { const i = l.indexOf('='); return [l.slice(0, i), l.slice(i + 1)] })
)

const filePath = process.argv[2]
const APPLY = process.argv.includes('--apply')
if (!filePath) {
  console.error('Использование: node scripts/run-sql.mjs <путь-к-sql-файлу> [--apply]')
  process.exit(1)
}

const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

// ---- Разбиение текста на операторы (учитывая кавычки — ';' внутри
// '...' не считается концом оператора) ----
function splitStatements(sql) {
  // убрать построчные комментарии, не трогая содержимое строк в кавычках
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
  let current = ''
  let inStr = false
  for (let i = 0; i < cleaned.length; i++) {
    const ch = cleaned[i]
    current += ch
    if (ch === "'") inStr = !inStr
    if (ch === ';' && !inStr) {
      statements.push(current.slice(0, -1).trim()) // отрезаем сам ';', который вызвал разбиение
      current = ''
    }
  }
  if (current.trim()) statements.push(current.trim())
  return statements.filter((s) => s && !/^begin$/i.test(s) && !/^commit$/i.test(s))
}

// ---- Разбить строку по запятым верхнего уровня (не внутри '...' или (), []) ----
function splitTopLevel(str, sep = ',') {
  const parts = []
  let depth = 0
  let inStr = false
  let current = ''
  for (let i = 0; i < str.length; i++) {
    const ch = str[i]
    if (ch === "'" ) inStr = !inStr
    if (!inStr) {
      if (ch === '(' || ch === '[') depth++
      if (ch === ')' || ch === ']') depth--
    }
    if (ch === sep && depth === 0 && !inStr) {
      parts.push(current)
      current = ''
    } else {
      current += ch
    }
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
    // Найти СОБСТВЕННУЮ закрывающую скобку array[...], а не lastIndexOf(']') —
    // тот ошибочно захватывал ']' из хвостового приведения типа '::text[]'
    // у пустых массивов (array[]::text[]), что портило данные "]::text[".
    const openIdx = token.indexOf('[')
    let depth = 0
    let closeIdx = -1
    for (let i = openIdx; i < token.length; i++) {
      if (token[i] === '[') depth++
      else if (token[i] === ']') {
        depth--
        if (depth === 0) { closeIdx = i; break }
      }
    }
    const inner = token.slice(openIdx + 1, closeIdx)
    if (!inner.trim()) return []
    return splitTopLevel(inner, ',').map((s) => parseSqlValue(s))
  }
  if (token.startsWith("'") && token.endsWith("'")) {
    return token.slice(1, -1).replace(/''/g, "'")
  }
  if (/^-?\d+(\.\d+)?$/.test(token)) return Number(token)
  return token
}

// find matching top-level parenthesised groups in a string, e.g. for
// "(a, b), (c, d)" returns ["a, b", "c, d"]
function findParenGroups(str) {
  const groups = []
  let depth = 0
  let inStr = false
  let current = ''
  let capturing = false
  for (let i = 0; i < str.length; i++) {
    const ch = str[i]
    if (ch === "'") inStr = !inStr
    if (!inStr && ch === '(') {
      depth++
      if (depth === 1) { capturing = true; current = ''; continue }
    }
    if (!inStr && ch === ')') {
      depth--
      if (depth === 0 && capturing) { groups.push(current); capturing = false; continue }
    }
    if (capturing) current += ch
  }
  return groups
}

async function handleInsertUniversities(stmt) {
  const colsMatch = stmt.match(/insert into universities\s*\(([\s\S]*?)\)\s*values/i)
  const cols = splitTopLevel(colsMatch[1], ',').map((c) => c.trim())
  const afterValues = stmt.slice(stmt.search(/values/i) + 6)
  const beforeOnConflict = afterValues.split(/on conflict/i)[0]
  const groups = findParenGroups(beforeOnConflict)
  const rows = groups.map((g) => {
    const vals = splitTopLevel(g, ',').map(parseSqlValue)
    return Object.fromEntries(cols.map((c, i) => [c, vals[i]]))
  })
  return { table: 'universities', op: 'upsert', rows }
}

async function handleInsertPrograms(stmt) {
  const colsMatch = stmt.match(/insert into programs\s*\(([\s\S]*?)\)\s*values/i)
  const cols = splitTopLevel(colsMatch[1], ',').map((c) => c.trim())
  const afterValues = stmt.slice(stmt.search(/values/i) + 6)
  const groups = findParenGroups(afterValues)
  const rows = groups.map((g) => {
    const vals = splitTopLevel(g, ',').map(parseSqlValue)
    return Object.fromEntries(cols.map((c, i) => [c, vals[i]]))
  })
  return { table: 'programs', op: 'insert', rows }
}

function handleUpdatePrograms(stmt) {
  const setMatch = stmt.match(/update programs\s+set\s+([\s\S]*?)\s+where\s+([\s\S]*)/i)
  const setClause = setMatch[1]
  const whereClause = setMatch[2].trim()

  const setPairs = splitTopLevel(setClause, ',')
  const setObj = {}
  for (const pair of setPairs) {
    const eqIdx = pair.indexOf('=')
    const key = pair.slice(0, eqIdx).trim()
    const val = parseSqlValue(pair.slice(eqIdx + 1))
    setObj[key] = val
  }

  const whereConds = whereClause.split(/\s+and\s+/i)
  const eqFilters = whereConds.map((c) => {
    const eqIdx = c.indexOf('=')
    const key = c.slice(0, eqIdx).trim()
    const val = parseSqlValue(c.slice(eqIdx + 1))
    return [key, val]
  })

  return { table: 'programs', op: 'update', setObj, eqFilters }
}

async function main() {
  const sql = readFileSync(filePath, 'utf8')
  const statements = splitStatements(sql)
  console.log(`Найдено операторов: ${statements.length}${APPLY ? ' (РЕАЛЬНАЯ ЗАПИСЬ)' : ' (dry run — ничего не пишу)'}\n`)

  for (const stmt of statements) {
    if (/^insert into universities/i.test(stmt)) {
      const { rows } = await handleInsertUniversities(stmt)
      console.log(`insert into universities: ${rows.length} строк (${rows.map((r) => r.name).join(', ')})`)
      if (APPLY) {
        const { error } = await admin.from('universities').upsert(rows, { onConflict: 'id', ignoreDuplicates: true })
        if (error) console.error('  ОШИБКА:', error.message)
        else console.log('  -> записано')
      }
    } else if (/^insert into programs/i.test(stmt)) {
      const { rows } = await handleInsertPrograms(stmt)
      console.log(`insert into programs: "${rows[0]?.name}"`)
      if (APPLY) {
        // Идемпотентность: пропускаем, если такая программа (тот же
        // вуз + то же название) уже есть — на случай повторного запуска
        // после частично неудавшегося прогона (напр. FK-ошибка).
        const { data: existing } = await admin
          .from('programs')
          .select('id')
          .eq('university_id', rows[0].university_id)
          .eq('name', rows[0].name)
          .maybeSingle()
        if (existing) {
          console.log('  -> пропущено (уже есть в базе)')
        } else {
          const { error } = await admin.from('programs').insert(rows)
          if (error) console.error('  ОШИБКА:', error.message)
          else console.log('  -> записано')
        }
      }
    } else if (/^update programs/i.test(stmt)) {
      const { setObj, eqFilters } = handleUpdatePrograms(stmt)
      console.log(`update programs set {${Object.keys(setObj).join(', ')}} where ${eqFilters.map(([k, v]) => `${k}=${v}`).join(' and ')}`)
      if (APPLY) {
        let q = admin.from('programs').update(setObj)
        for (const [k, v] of eqFilters) q = q.eq(k, v)
        const { data, error } = await q.select('id')
        if (error) console.error('  ОШИБКА:', error.message)
        else if (!data?.length) console.log('  -> ВНИМАНИЕ: ни одна строка не подошла под условие (0 обновлено)')
        else console.log(`  -> обновлено строк: ${data.length}`)
      }
    } else {
      console.log('ПРОПУЩЕНО (неизвестный тип оператора):', stmt.slice(0, 80).replace(/\n/g, ' '))
    }
  }

  if (!APPLY) console.log('\nЭто был dry run. Проверь вывод выше — если всё верно, запусти с --apply.')
}

main().catch((e) => {
  console.error('Фатальная ошибка:', e)
  process.exit(1)
})
