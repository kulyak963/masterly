// Загрузка выгрузки (scripts/export-all.mjs) в НОВУЮ базу — например, в
// свой Supabase, поднятый на российском сервере (см. MIGRATION.md).
//
// Куда писать, берётся из отдельных переменных, а НЕ из основных:
//   TARGET_SUPABASE_URL=...
//   TARGET_SUPABASE_SERVICE_ROLE_KEY=...
// Так исключается самый обидный сценарий — случайно залить выгрузку
// обратно в боевую базу, перепутав адрес.
//
// Запуск:
//   node scripts/import-all.mjs backup/2026-09-08T09-57-07           (проверка)
//   node scripts/import-all.mjs backup/2026-09-08T09-57-07 --apply   (запись)
//
// Про пользователей: файл auth_users.json содержит адреса и способы
// входа, но НЕ хеши паролей — их через клиентскую библиотеку не достать.
// Скрипт заводит пользователей заново через админский API без пароля;
// человек задаёт пароль сам через «забыли пароль» либо входит новым
// способом. Пока аккаунтов единицы, это дешевле любой возни с хешами.

import { readFileSync, existsSync } from 'node:fs'
import { createClient } from '@supabase/supabase-js'

const dirArg = process.argv[2]
const APPLY = process.argv.includes('--apply')
if (!dirArg) {
  console.error('Укажи папку выгрузки: node scripts/import-all.mjs backup/<дата> [--apply]')
  process.exit(1)
}

const env = {}
for (const line of readFileSync(new URL('../.env.local', import.meta.url), 'utf8').split(/\r?\n/)) {
  const m = line.match(/^([A-Z0-9_]+)=(.*)$/)
  if (m) env[m[1]] = m[2]
}

const url = process.env.TARGET_SUPABASE_URL || env.TARGET_SUPABASE_URL
const key = process.env.TARGET_SUPABASE_SERVICE_ROLE_KEY || env.TARGET_SUPABASE_SERVICE_ROLE_KEY
if (!url || !key) {
  console.error('Не заданы TARGET_SUPABASE_URL и TARGET_SUPABASE_SERVICE_ROLE_KEY.')
  console.error('Это адрес и ключ НОВОЙ базы. Основные переменные намеренно не используются.')
  process.exit(1)
}
if (url === env.NEXT_PUBLIC_SUPABASE_URL) {
  console.error('TARGET совпадает с текущей боевой базой. Отказываюсь: так данные не переносят, а затирают.')
  process.exit(1)
}

const sb = createClient(url, key)
const base = new URL(`../${dirArg.replace(/\/+$/, '')}/`, import.meta.url)

// Порядок важен: сначала то, на что ссылаются. Вузы → программы,
// профили → избранное (оно ссылается и на профиль, и на программу).
const ORDER = [
  'universities', 'programs',
  'profiles', 'pending_profiles', 'favorites', 'payment_events', 'data_reports',
]

const read = (name) => {
  const f = new URL(`${name}.json`, base)
  if (!existsSync(f)) return null
  return JSON.parse(readFileSync(f, 'utf8'))
}

console.log(`Источник: ${dirArg}`)
console.log(`Цель:     ${url}`)
console.log(APPLY ? 'Режим:    РЕАЛЬНАЯ ЗАПИСЬ\n' : 'Режим:    проверка, ничего не пишем\n')

for (const table of ORDER) {
  const rows = read(table)
  if (rows === null) { console.log(`  ${table.padEnd(18)} файла нет, пропуск`); continue }
  if (!rows.length) { console.log(`  ${table.padEnd(18)} пусто`); continue }

  if (!APPLY) { console.log(`  ${table.padEnd(18)} ${rows.length} строк готово к записи`); continue }

  // Пишем частями: одним запросом на полторы тысячи строк упираемся в
  // лимиты, а по одной — слишком долго.
  let done = 0, failed = 0
  for (let i = 0; i < rows.length; i += 200) {
    const chunk = rows.slice(i, i + 200)
    const { error } = await sb.from(table).upsert(chunk, { onConflict: 'id' })
    if (error) { failed += chunk.length; console.log(`     ошибка на строках ${i}–${i + chunk.length}: ${error.message}`) }
    else done += chunk.length
  }
  console.log(`  ${table.padEnd(18)} записано ${done}${failed ? `, не удалось ${failed}` : ''}`)
}

// Пользователи — отдельно, обычной вставкой их не создать.
const users = read('auth_users')
if (users?.length) {
  console.log(`\nПользователи: ${users.length}`)
  if (!APPLY) {
    for (const u of users) {
      const banned = (u.providers || []).some(p => ['google', 'apple', 'github'].includes(p))
      console.log(`  ${(u.email || u.phone || u.id).padEnd(34)} вход: ${(u.providers || []).join(', ') || '—'}${banned ? '  ← способ запрещён 406-ФЗ' : ''}`)
    }
    console.log('\n  Будут созданы заново, без пароля: человек задаёт его сам либо входит новым способом.')
  } else {
    for (const u of users) {
      if (!u.email) { console.log(`  ${u.id} — без адреса, пропуск`); continue }
      const { error } = await sb.auth.admin.createUser({
        email: u.email,
        email_confirm: !!u.email_confirmed_at,
        user_metadata: { migrated_from: u.id },
      })
      console.log(`  ${u.email.padEnd(34)} ${error ? 'ОШИБКА: ' + error.message : 'создан'}`)
    }
    console.log('\n  ВНИМАНИЕ: идентификаторы пользователей изменились. Если в profiles/favorites')
    console.log('  остались ссылки на старые user_id, их нужно перепривязать по адресу почты.')
  }
}

if (!APPLY) console.log('\nЭто была проверка. Для записи добавь --apply')
