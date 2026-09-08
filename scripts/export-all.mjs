// Полная выгрузка базы перед переездом на российский сервер.
//
// Зачем: 152-ФЗ требует, чтобы база с персональными данными граждан РФ
// находилась в России, а 406-ФЗ запрещает авторизацию через иностранные
// сервисы. И то и другое означает переезд — а переезд без свежей
// выгрузки делать нельзя.
//
// Куда пишет: ./backup/<дата-время>/*.json
// Папка backup/ в .gitignore — в выгрузке лежат имена, почты и анкеты
// живых людей, в репозиторий это попадать не должно никогда.
//
// ВАЖНО про пароли: хеши паролей лежат в служебной таблице auth.users и
// через клиентскую библиотеку недоступны — выгружаются только адреса,
// идентификаторы и способ входа. Перенести хеши можно лишь прямым
// подключением к Postgres. Пока пользователей единицы, проще не
// переносить их вовсе: пусть зарегистрируются заново на новом сервере.
// Это ещё один довод переезжать сейчас, а не на тысяче аккаунтов.
//
// Запуск: node scripts/export-all.mjs

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs'
import { createClient } from '@supabase/supabase-js'

const env = {}
for (const line of readFileSync(new URL('../.env.local', import.meta.url), 'utf8').split(/\r?\n/)) {
  const m = line.match(/^([A-Z0-9_]+)=(.*)$/)
  if (m) env[m[1]] = m[2]
}
if (!env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error('Нет SUPABASE_SERVICE_ROLE_KEY в .env.local — без него не выгрузить пользователей.')
  process.exit(1)
}
const sb = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

// Каталог — обезличенные справочные данные. Личное — всё остальное.
const CATALOG = ['universities', 'programs']
const PERSONAL = ['profiles', 'pending_profiles', 'favorites', 'payment_events', 'data_reports']

const stamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
const dir = new URL(`../backup/${stamp}/`, import.meta.url)
mkdirSync(dir, { recursive: true })

async function dump(table) {
  const rows = []
  for (let from = 0; ; from += 1000) {
    const { data, error } = await sb.from(table).select('*').range(from, from + 999)
    if (error) return { table, error: error.message }
    if (!data?.length) break
    rows.push(...data)
    if (data.length < 1000) break
  }
  writeFileSync(new URL(`${table}.json`, dir), JSON.stringify(rows, null, 2), 'utf8')
  return { table, rows: rows.length }
}

console.log(`Выгрузка в backup/${stamp}/\n`)

console.log('Каталог (обезличенный):')
for (const t of CATALOG) {
  const r = await dump(t)
  console.log('  ' + t.padEnd(18), r.error ? 'ОШИБКА: ' + r.error : r.rows + ' строк')
}

console.log('\nПерсональные данные:')
for (const t of PERSONAL) {
  const r = await dump(t)
  console.log('  ' + t.padEnd(18), r.error ? 'ОШИБКА: ' + r.error : r.rows + ' строк')
}

// Пользователи — отдельным вызовом, обычным select их не достать.
const { data: userData, error: userErr } = await sb.auth.admin.listUsers({ perPage: 1000 })
if (userErr) {
  console.log('\n  auth.users        ОШИБКА: ' + userErr.message)
} else {
  const users = (userData?.users ?? []).map(u => ({
    id: u.id,
    email: u.email,
    phone: u.phone,
    created_at: u.created_at,
    last_sign_in_at: u.last_sign_in_at,
    email_confirmed_at: u.email_confirmed_at,
    // Каким способом человек входил — это прямо влияет на переезд:
    // тех, кто заходил через Google, придётся пересаживать на
    // российский сервис авторизации (406-ФЗ).
    providers: u.app_metadata?.providers ?? [],
  }))
  writeFileSync(new URL('auth_users.json', dir), JSON.stringify(users, null, 2), 'utf8')
  console.log('\n  auth.users        ' + users.length + ' записей (без хешей паролей — см. шапку файла)')

  const byProvider = {}
  for (const u of users) for (const p of (u.providers.length ? u.providers : ['unknown'])) byProvider[p] = (byProvider[p] || 0) + 1
  console.log('\nСпособы входа у существующих пользователей:')
  for (const [p, n] of Object.entries(byProvider)) {
    const banned = p === 'google' || p === 'apple' || p === 'github'
    console.log(`  ${p.padEnd(12)} ${n}${banned ? '   ← запрещён 406-ФЗ, нужна замена' : ''}`)
  }
}

console.log(`\nГотово. Папка backup/ добавлена в .gitignore — не коммить её.`)
