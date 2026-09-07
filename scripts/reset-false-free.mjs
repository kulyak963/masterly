#!/usr/bin/env node
// Фаза 0, задача 0.3 (см. аудит продукта 2026-09-07 и план исправлений).
//
// Снимает недоказанные "Бесплатно" (tuition_eur=0), которые появились
// из-за бага генератора (`p.tuition_eur ?? 0`, исправлено в 0.1) —
// переводит их в null + tuition_status='unknown', с пояснением почему.
//
// Требует sql/2026-09-08-tuition-truth.sql (задача 0.2, применяется
// вручную через Supabase SQL Editor — run-sql.mjs не умеет ALTER TABLE).
//
// Страны, где не-ЕС студенты платят — проверено веб-поиском 2026-09-07,
// не по памяти (источники — university.edu / study.eu / thepienews.com):
// - Норвегия: плата для не-ЕС/ЕЭЗ введена с осени 2023 (UiO, NTNU
//   подтверждают, есть исключение для поступивших до 2023).
// - Швеция и Дания: платят давно, широкий диапазон по программам
//   (€8 000-19 000 и €6 000-16 000 в год соответственно).
// - Австрия: фиксированный семестровый взнос с не-ЕС студентов в
//   государственных вузах (~€726/семестр + членский взнос).
// Для всех четырёх — снимаем ноль в null, без попытки угадать точную
// цифру за программу (это отдельная, более точная работа — задача 0.5).
const NATIONAL_POLICY_COUNTRIES = {
  se: 'Швеция взимает плату за обучение с не-ЕС/ЕЭЗ студентов на уровне магистратуры (обычно €8 000–19 000/год, варьируется по вузу и программе) — 0 в базе был ошибкой генератора, а не фактом.',
  dk: 'Дания взимает плату за обучение с не-ЕС/ЕЭЗ студентов (обычно €6 000–16 000/год) — 0 в базе был ошибкой генератора, а не фактом.',
  no: 'Норвегия ввела плату за обучение для не-ЕС/ЕЭЗ студентов с осени 2023 (кроме поступивших раньше) — 0 в базе был ошибкой генератора и относился к старой, уже неактуальной политике.',
  at: 'Австрия взимает с не-ЕС студентов в гос. вузах семестровый взнос (~€726/семестр + членский взнос) — не ноль. 0 в базе был ошибкой генератора.',
}

// Германия — НЕ занулять скопом: большинство немецких вузов правда
// бесплатны даже для не-ЕС. Проверено точечно (thepienews.com,
// migaku.com, gradgermany.com, 2026-09-07):
// - TUM ввёл плату для не-ЕС с зимы 2024/25 (€8 000–12 000/год) —
//   единственный вуз Баварии с такой платой, LMU и остальная Бавария
//   остаются бесплатными.
// - Земля Баден-Вюртемberg взимает ~€3 000/год со всех не-ЕС студентов
//   независимо от вуза — Штутгарт, Маннгейм, KIT, Фрайбург.
// Список неполный (см. задачу 0.5 — систематическая проверка по всем
// 131 вузам); это только то, что подтверждено сейчас.
const DE_UNIVERSITIES_THAT_CHARGE = {
  'Technical University of Munich': 'TUM ввёл плату за обучение для не-ЕС студентов с зимы 2024/25 (€8 000–12 000/год, зависит от программы) — 0 в базе был ошибкой генератора и относился к старой, уже неактуальной политике.',
  'University of Stuttgart': 'Штутгарт — в земле Баден-Вюртемберг, которая взимает ~€3 000/год со всех не-ЕС студентов независимо от вуза — 0 в базе был ошибкой генератора.',
  'University of Mannheim': 'Маннгейм — в земле Баден-Вюртемберг, которая взимает ~€3 000/год со всех не-ЕС студентов независимо от вуза — 0 в базе был ошибкой генератора.',
  'Karlsruhe Institute of Technology': 'KIT — в земле Баден-Вюртемберг, которая взимает ~€3 000/год со всех не-ЕС студентов независимо от вуза — 0 в базе был ошибкой генератора.',
  'University of Freiburg': 'Фрайбург — в земле Баден-Вюртемберг, которая взимает ~€3 000/год со всех не-ЕС студентов независимо от вуза — 0 в базе был ошибкой генератора.',
  // Найдено при систематической проверке 0.5 (2026-09-08, не в первой
  // партии) — точечное решение отдельного вуза внутри "бесплатной" в
  // остальном Баварии, как и TUM, а не общая политика земли.
  'Friedrich-Alexander-Universität Erlangen-Nürnberg': 'FAU вводит плату для НОВЫХ не-ЕС студентов с летнего семестра 2027 (подтверждено на €4 000/семестр для Medical Engineering, возможно и другие программы) — уже поступившие до этого не затронуты, но для целевой аудитории продукта (поступление 2027+) это актуальная плата, не 0.',
}

// Не страновая и не земельная политика — просто конкретный вуз с реальной
// (не нулевой) ценой, ошибочно попавший в 0 тем же багом генератора.
const SPECIFIC_UNIVERSITIES_THAT_CHARGE = {
  "Sant'Anna School of Advanced Studies": "У Sant'Anna Pisa есть плата за обучение (около €7 500 за программу по данным официального сайта) — не бесплатно, 0 в базе был ошибкой генератора. Точную цифру для конкретной программы стоит перепроверить на официальной странице.",
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
  const { data: unis, error: uniErr } = await db.from('universities').select('id,name,country')
  if (uniErr) { console.error('Не удалось прочитать universities:', uniErr.message); process.exit(1) }
  const uniById = Object.fromEntries(unis.map((u) => [u.id, u]))

  let all = []
  for (let from = 0; from < 3000; from += 1000) {
    const { data, error } = await db.from('programs').select('id,name,university_id,tuition_eur').range(from, from + 999)
    if (error) { console.error('Не удалось прочитать programs:', error.message); process.exit(1) }
    if (!data?.length) break
    all = all.concat(data)
    if (data.length < 1000) break
  }

  const targets = []
  for (const p of all) {
    if (p.tuition_eur !== 0) continue
    const uni = uniById[p.university_id]
    if (!uni) continue
    if (NATIONAL_POLICY_COUNTRIES[uni.country]) {
      targets.push({ p, uni, note: NATIONAL_POLICY_COUNTRIES[uni.country] })
    } else if (uni.country === 'de' && DE_UNIVERSITIES_THAT_CHARGE[uni.name]) {
      targets.push({ p, uni, note: DE_UNIVERSITIES_THAT_CHARGE[uni.name] })
    } else if (SPECIFIC_UNIVERSITIES_THAT_CHARGE[uni.name]) {
      targets.push({ p, uni, note: SPECIFIC_UNIVERSITIES_THAT_CHARGE[uni.name] })
    }
  }

  console.log(`Найдено ложных "Бесплатно": ${targets.length}${APPLY ? ' — ИСПРАВЛЯЮ' : ' (dry run — ничего не пишу)'}\n`)
  const byCountry = {}
  for (const t of targets) {
    byCountry[t.uni.country] = (byCountry[t.uni.country] ?? 0) + 1
    console.log(`  ${t.uni.country.toUpperCase()} | ${t.uni.name} | ${t.p.name}`)
  }
  console.log('\nПо странам:', Object.entries(byCountry).map(([k, v]) => `${k}:${v}`).join(', '))

  if (!APPLY) {
    console.log('\nЭто был dry run. Проверь список выше — если всё верно, запусти с --apply.')
    return
  }

  let ok = 0, fail = 0
  for (const t of targets) {
    const { error } = await db.from('programs').update({
      tuition_eur: null,
      tuition_status: 'unknown',
      tuition_note: t.note,
      tuition_checked_at: new Date().toISOString(),
    }).eq('id', t.p.id)
    if (error) { console.error(`  ОШИБКА (${t.p.name}):`, error.message); fail++ } else ok++
  }
  console.log(`\nГотово: исправлено ${ok}, ошибок ${fail}.`)
}

main().catch((e) => { console.error('Фатальная ошибка:', e); process.exit(1) })
