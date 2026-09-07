// Убирает упоминания DAAD из пользовательских текстов в базе.
//
// Почему: 23.01.2026 Генпрокуратура признала деятельность Германской
// службы академических обменов (DAAD) нежелательной на территории РФ,
// 10.02.2026 Минюст внёс её в реестр, служба закрыла четыре офиса и
// ушла из России. Для нашей аудитории это тот же случай, что был с
// British Council (см. CLAUDE.md): советовать подаваться — подводить
// человека под ст. 284.1 УК РФ / ст. 20.33 КоАП.
//
// Что делаем:
//   1. scholarships — запись про DAAD убираем целиком. Исключение:
//      строки, где DAAD склеен с Deutschlandstipendium. Это отдельная
//      федеральная программа, которую администрируют сами вузы, а не
//      DAAD, — её терять не за что, просто вычищаем упоминание.
//   2. summary/pros/cons — точечные замены по полному совпадению
//      строки. Никаких регулярок по всей базе: на сотнях записей это
//      уже однажды чуть не испортило формулировки (см. CLAUDE.md).
//
// Запуск: node scripts/remove-daad.mjs           (dry run, ничего не пишет)
//         node scripts/remove-daad.mjs --apply   (реальная запись)

import { readFileSync } from 'node:fs'
import { createClient } from '@supabase/supabase-js'

const APPLY = process.argv.includes('--apply')

const env = {}
for (const line of readFileSync(new URL('../.env.local', import.meta.url), 'utf8').split(/\r?\n/)) {
  const m = line.match(/^([A-Z0-9_]+)=(.*)$/)
  if (m) env[m[1]] = m[2]
}
const sb = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

// Строки из pros/cons/summary, где DAAD упомянут — и чем их заменить.
// null = удалить строку целиком (весь смысл строки был в DAAD).
const TEXT_FIXES = new Map([
  // — рекомендации подаваться —
  ['Доступны Deutschlandstipendium и стипендии DAAD для иностранцев',
   'Доступен Deutschlandstipendium — стипендия, которую распределяет сам вуз'],
  ['Возможность получения стипендий (Deutschlandstipendium, DAAD)',
   'Возможность получения стипендии Deutschlandstipendium через вуз'],
  ['Доступны стипендии DAAD и Deutschlandstipendium',
   'Доступна стипендия Deutschlandstipendium через вуз'],
  ['Престижная программа на английском с возможностью DAAD-стипендии Helmut-Schmidt',
   'Престижная программа на английском языке'],
  ['Доступна стипендия DAAD для студентов из развивающихся стран', null],
  ['Возможность получения стипендии DAAD EPOS, которая покрывает проживание, перелёт и страховку', null],
  ['Хорошо известная программа с сильной сетью выпускников и поддержкой DAAD',
   'Хорошо известная программа с сильной сетью выпускников'],
  ['Дедлайн 15 июля — для не-EU студентов, желающих поступить без DAAD, окно очень узкое (DAAD EPOS имеет отдельный более ранний дедлайн ~30 ноября)',
   'Дедлайн 15 июля для не-EU студентов — окно узкое, документы стоит готовить заранее'],

  // — DAAD как источник данных: смысл сохраняем, источник обезличиваем —
  ['Минимальный балл IELTS 5.5 (по DAAD) кажется низким — на практике конкурс высокий, конкурентоспособные кандидаты имеют 7.0+; проверьте актуальные требования на сайте факультета',
   'Указанный минимальный языковой балл 5.5 кажется низким — на практике конкурс высокий, конкурентоспособные кандидаты имеют 7.0+; проверьте актуальные требования на сайте факультета'],
  ['Дедлайн для не-ЕС на DAAD-странице помечен как "Please enquire"; дата 15 июня указана на сайте кафедры (LIPP) и относится к ближайшему циклу 2026',
   'В справочниках дедлайн для не-ЕС помечен как "Please enquire"; дата 15 июня указана на сайте кафедры (LIPP) и относится к ближайшему циклу 2026'],
  ['Единая ставка tuition для всех стран (DAAD подтверждает flat fee без надбавки для non-EU)',
   'Единая ставка tuition для всех стран — без отдельной надбавки для non-EU'],
  ['Дедлайн варьируется по источникам: официальный сайт WHU указывает 31 мая, DAAD/mastersportal — 30 апреля',
   'Дедлайн варьируется по источникам: официальный сайт WHU указывает 31 мая, агрегаторы — 30 апреля'],
  ['IELTS 7.0 и TOEFL 100 — стандартные и задокументированные требования (DAAD)',
   'Языковые требования (IELTS 7.0 / TOEFL 100) стандартные и задокументированные'],
  ['Данные собраны с нескольких страниц KIT и DAAD, единая страница программы напрямую не подтвердила все три параметра одновременно',
   'Данные собраны с нескольких страниц KIT и внешних справочников, единая страница программы напрямую не подтвердила все три параметра одновременно'],
  ['Дедлайн для не-ЕС по DAAD указан как «1 April to 31[…]» (источник обрезан); 30 апреля — наиболее вероятная дата, но подтвердите на tu-dresden.de',
   'Дедлайн для не-ЕС в справочнике указан как «1 April to 31[…]» (источник обрезан); 30 апреля — наиболее вероятная дата, но подтвердите на tu-dresden.de'],
  ['Бюджет на проживание ~850 EUR/мес по данным DAAD — нужно учитывать при планировании',
   'Бюджет на проживание ~850 EUR/мес — нужно учитывать при планировании'],
  ['Нет tuition fees для не-EU студентов по данным DAAD — только обязательный семестровый взнос ~360 EUR (итого ~1440 EUR за 2 года)',
   'Нет платы за обучение для не-EU студентов — только обязательный семестровый взнос ~360 EUR (итого ~1440 EUR за 2 года)'],
])

// Записи scholarships, где DAAD склеен с Deutschlandstipendium:
// сохраняем программу вуза, убираем упоминание службы.
const SCHOLARSHIP_REWRITES = new Map([
  ['Deutschlandstipendium (DAAD/University funded)', 'Deutschlandstipendium (финансируется вузом)'],
  ['Deutschlandstipendium (DAAD/FU Berlin, 300 EUR/month)', 'Deutschlandstipendium (FU Berlin, 300 EUR/month)'],
  ['Deutschlandstipendium (DAAD / TU Dresden merit scholarship)', 'Deutschlandstipendium (TU Dresden merit scholarship)'],
  ['Deutschlandstipendium (€300/month), DAAD scholarships, FU Berlin-specific international scholarships',
   'Deutschlandstipendium (€300/month), FU Berlin-specific international scholarships'],
])

const hasDaad = (s) => /daad/i.test(s)

let all = [], from = 0
while (true) {
  const { data, error } = await sb.from('programs')
    .select('id,name,scholarships,summary,pros,cons').range(from, from + 999)
  if (error) throw error
  if (!data?.length) break
  all.push(...data)
  if (data.length < 1000) break
  from += 1000
}
console.log(`Просмотрено программ: ${all.length}${APPLY ? '' : '  (DRY RUN — ничего не пишем)'}\n`)

let touched = 0, droppedSch = 0, rewroteSch = 0, changedText = 0
const unknown = new Set()

for (const p of all) {
  const patch = {}

  if (p.scholarships?.some(hasDaad)) {
    const next = []
    for (const s of p.scholarships) {
      if (!hasDaad(s)) { next.push(s); continue }
      if (SCHOLARSHIP_REWRITES.has(s)) { next.push(SCHOLARSHIP_REWRITES.get(s)); rewroteSch++; continue }
      droppedSch++
    }
    patch.scholarships = next
  }

  for (const field of ['pros', 'cons']) {
    if (!p[field]?.some(hasDaad)) continue
    const next = []
    for (const line of p[field]) {
      if (!hasDaad(line)) { next.push(line); continue }
      if (!TEXT_FIXES.has(line)) { unknown.add(`[${field}] ${p.name}: ${line}`); next.push(line); continue }
      const rep = TEXT_FIXES.get(line)
      if (rep !== null) next.push(rep)
      changedText++
    }
    patch[field] = next
  }

  if (p.summary && hasDaad(p.summary)) unknown.add(`[summary] ${p.name}: ${p.summary.slice(0, 120)}`)

  if (!Object.keys(patch).length) continue
  touched++
  if (APPLY) {
    const { error } = await sb.from('programs').update(patch).eq('id', p.id)
    if (error) { console.error('ОШИБКА', p.name, error.message); process.exitCode = 1 }
  }
}

console.log(`Программ затронуто:            ${touched}`)
console.log(`Записей стипендий удалено:     ${droppedSch}`)
console.log(`Записей стипендий переписано:  ${rewroteSch}`)
console.log(`Строк в pros/cons изменено:    ${changedText}`)

if (unknown.size) {
  console.log(`\nНЕ РАЗОБРАНО (${unknown.size}) — упоминание есть, точного правила нет, оставлено как было:`)
  for (const u of unknown) console.log('  -', u)
}
if (!APPLY) console.log('\nЭто был dry run. Для реальной записи: node scripts/remove-daad.mjs --apply')
