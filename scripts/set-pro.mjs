// Проставляет profiles.is_pro = true для одного профиля по email.
// Требует, чтобы колонка is_pro уже была создана (см.
// sql/2026-08-31-add-is-pro-column.sql — применяется вручную в Supabase
// SQL Editor, supabase-js не умеет DDL).
//
// Использование: node scripts/set-pro.mjs <email>
import { createClient } from '@supabase/supabase-js'
import { readFileSync } from 'fs'

const env = Object.fromEntries(
  readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
    .split('\n').filter((l) => l.includes('=')).map((l) => { const i = l.indexOf('='); return [l.slice(0, i), l.slice(i + 1)] })
)
const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY)

const email = process.argv[2]
if (!email) { console.error('Использование: node scripts/set-pro.mjs <email>'); process.exit(1) }

const { data: authUser, error: authErr } = await admin.auth.admin.listUsers()
if (authErr) { console.error(authErr.message); process.exit(1) }
const user = authUser.users.find((u) => u.email === email)
if (!user) { console.error(`Не найден пользователь с email ${email}`); process.exit(1) }

const { data, error } = await admin.from('profiles').update({ is_pro: true }).eq('user_id', user.id).select('id,name,is_pro')
if (error) { console.error(error.message); process.exit(1) }
console.log(data.length ? `Готово: ${JSON.stringify(data)}` : 'Профиль не найден по user_id')
