import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../../lib/supabaseAdmin'

// Принимает вебхук от Lava.top об оплате Mastersly PRO и включает
// profiles.is_pro для купившего пользователя — автоматика взамен
// ручного scripts/set-pro.mjs (см. CLAUDE.md, 2026-09-07).
//
// Формат payload и способ аутентификации подтверждены разбором
// неофициального lava-top-sdk (github.com/azamatjamaliev/
// lava_public_api_sdk_node) — официальная Swagger-документация
// (gate.lava.top/docs) рендерится через JS и недоступна для чтения
// напрямую. При первом реальном платеже стоит свериться с фактическим
// payload через "Интеграции → Public API → Webhook History" в личном
// кабинете Lava.top и поправить при расхождении.
//
// Аутентификация — НЕ криптографическая подпись (HMAC), а прямое
// сравнение значения из заголовка X-Api-Key с ключом, который был
// выбран при настройке вебхука в личном кабинете ("тип аутентификации:
// API key"). Тот же ключ, что используется для исходящих вызовов API
// (создание счёта, см. app/api/checkout/route.ts).
interface LavaWebhookPayload {
  eventType: 'payment.success' | 'payment.failed' | string
  contractId?: string
  product?: { id?: string; title?: string }
  buyer?: { email?: string }
  amount?: number
  currency?: string
  status?: string
}

function timingSafeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) return false
  let diff = 0
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i)
  return diff === 0
}

export async function POST(req: NextRequest) {
  const secret = process.env.LAVA_TOP_WEBHOOK_SECRET
  if (!secret) {
    console.error('LAVA_TOP_WEBHOOK_SECRET не настроен')
    return NextResponse.json({ error: 'not configured' }, { status: 500 })
  }

  const provided = req.headers.get('x-api-key') ?? ''
  if (!timingSafeEqual(provided, secret)) {
    return NextResponse.json({ error: 'invalid signature' }, { status: 401 })
  }

  const raw = await req.text()
  let payload: LavaWebhookPayload
  try {
    payload = JSON.parse(raw)
  } catch {
    return NextResponse.json({ error: 'invalid json' }, { status: 400 })
  }

  const db = getSupabaseAdmin()
  const email = payload.buyer?.email?.trim().toLowerCase() ?? null

  let matchedUserId: string | null = null
  if (payload.eventType === 'payment.success' && email) {
    const { data: users } = await db.auth.admin.listUsers()
    const user = users?.users.find((u) => u.email?.toLowerCase() === email)
    if (user) {
      matchedUserId = user.id
      await db.from('profiles').update({ is_pro: true }).eq('user_id', user.id)
    } else {
      console.warn(`Lava.top payment.success для email без аккаунта Mastersly: ${email}`)
    }
  }

  // Журнал — не блокирует ответ вебхуку, если запись не удалась.
  await db.from('payment_events').insert({
    provider: 'lava_top',
    event_type: payload.eventType,
    contract_id: payload.contractId ?? null,
    buyer_email: email,
    amount: payload.amount ?? null,
    currency: payload.currency ?? null,
    status: payload.status ?? null,
    matched_user_id: matchedUserId,
    raw_payload: payload,
  }).then(({ error }) => { if (error) console.error('payment_events insert failed:', error.message) })

  return NextResponse.json({ ok: true })
}
