#!/usr/bin/env node
// Фаза 3, задача 3.2 (план после аудита продукта 2026-09-07).
//
// Раньше "Business Analytics" был единственной широкой категорией для
// всего бизнес-образования — 609 из 1414 программ (43% базы) на момент
// аудита. lib/masterFields.ts и scripts/research-programs.mjs теперь
// различают Economics/Finance/Management/Marketing/Business Analytics
// (см. коммит "Phase 3.1") — эта задача применяет ту же классификацию
// НЕ к новым программам, а к уже собранным, у которых field ещё старый.
//
// Правила классификации — ТА ЖЕ копия FIELD_KEYWORD_RULES из
// research-programs.mjs (тот файл не экспортирует их — это CLI-скрипт
// с побочными эффектами на верхнем уровне модуля, импортировать оттуда
// небезопасно). Если правила там меняются, эту копию нужно обновить
// вручную — оба файла ссылаются друг на друга в комментариях.
//
// По умолчанию — dry run (только отчёт). --apply — реально пишет.
//
// Использование:
//   node scripts/reclassify-fields.mjs
//   node scripts/reclassify-fields.mjs --apply

const BUSINESS_SUBFIELD_RULES = [
  { field: 'Finance', re: /\b(finance|financial|banking|insurance|accounting|actuarial|investment)\b/i },
  { field: 'Marketing', re: /\b(marketing|brand management|advertising|digital marketing)\b/i },
  { field: 'Management', re: /\b(management(?! technology)|entrepreneur|sport management|hr\b|human resources?|supply chain|logistics|hospitality|tourism|mba\b|business leadership|organi[sz]ational (behaviou?r|development))\b/i },
  { field: 'Economics', re: /\b(economic|econom(y|ics)|international trade|development economics|econometrics)\b/i },
  // Совпадение с "business analytics/intelligence/administration" или
  // ничего из вышеперечисленного — остаётся Business Analytics, это не
  // ошибка классификации, а честный "не подошло ни под одну более
  // узкую категорию".
]

function reclassify(name) {
  for (const rule of BUSINESS_SUBFIELD_RULES) {
    if (rule.re.test(name)) return rule.field
  }
  return 'Business Analytics'
}

import { readFileSync } from 'node:fs'
import { createClient } from '@supabase/supabase-js'

const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText.split('\n').filter((l) => l.includes('=')).map((l) => { const i = l.indexOf('='); return [l.slice(0, i), l.slice(i + 1)] })
)
const APPLY = process.argv.includes('--apply')
const db = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

async function main() {
  let all = []
  for (let from = 0; from < 3000; from += 1000) {
    const { data, error } = await db.from('programs').select('id,name').eq('field', 'Business Analytics').range(from, from + 999)
    if (error) { console.error('Не удалось прочитать programs:', error.message); process.exit(1) }
    if (!data?.length) break
    all = all.concat(data)
    if (data.length < 1000) break
  }

  const counts = {}
  const moves = []
  for (const p of all) {
    const newField = reclassify(p.name)
    counts[newField] = (counts[newField] ?? 0) + 1
    if (newField !== 'Business Analytics') moves.push({ p, newField })
  }

  console.log(`Всего программ в старом "Business Analytics": ${all.length}${APPLY ? ' — ПЕРЕКЛАССИФИЦИРУЮ' : ' (dry run)'}\n`)
  console.log('Новое распределение:')
  for (const [field, n] of Object.entries(counts).sort((a, b) => b[1] - a[1])) {
    console.log(`  ${field}: ${n}`)
  }

  if (!APPLY) {
    console.log('\nПримеры переносов (первые 15):')
    for (const { p, newField } of moves.slice(0, 15)) console.log(`  "${p.name}" -> ${newField}`)
    console.log('\nЭто был dry run. Проверь распределение выше — если всё верно, запусти с --apply.')
    return
  }

  let ok = 0, fail = 0
  for (const { p, newField } of moves) {
    const { error } = await db.from('programs').update({ field: newField }).eq('id', p.id)
    if (error) { console.error(`  ОШИБКА (${p.name}):`, error.message); fail++ } else ok++
  }
  console.log(`\nГотово: перенесено ${ok}, ошибок ${fail}. Осталось в Business Analytics: ${counts['Business Analytics'] ?? 0}.`)
}

main().catch((e) => { console.error('Фатальная ошибка:', e); process.exit(1) })
