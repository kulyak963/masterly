import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../lib/supabaseAdmin'

// Создаёт счёт на оплату Mastersly PRO через Lava.top и возвращает ссылку
// на чек-аут — вызывается кнопкой "Разблокировать Pro" в дашборде.
// email берётся из аутентифицированной сессии (не из тела запроса), чтобы
// вебхук потом мог однозначно сматчить оплату с профилем (см.
// app/api/webhooks/lava-top/route.ts) — присланный клиентом email нельзя
// было бы доверять.
//
// Эндпоинт создания счёта и структура ответа подтверждены разбором
// неофициального lava-top-sdk — официальная Swagger-документация
// (gate.lava.top/docs) рендерится через JS и недоступна для чтения
// напрямую. Поле с ссылкой на оплату называется paymentUrl с умеренной
// уверенностью — при первом реальном тесте проверить фактический ответ
// (он логируется ниже при ошибке/неожиданной форме) и поправить при
// расхождении.
export async function POST(req: NextRequest) {
  const apiKey = process.env.LAVA_TOP_API_KEY
  const offerId = process.env.LAVA_TOP_OFFER_ID
  if (!apiKey || !offerId) {
    return NextResponse.json({ error: 'Оплата ещё не настроена' }, { status: 500 })
  }

  const authHeader = req.headers.get('authorization') ?? ''
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null
  if (!token) return NextResponse.json({ error: 'Требуется вход' }, { status: 401 })

  const db = getSupabaseAdmin()
  const { data: userRes } = await db.auth.getUser(token)
  if (!userRes?.user?.email) return NextResponse.json({ error: 'Требуется вход' }, { status: 401 })

  try {
    const res = await fetch('https://gate.lava.top/api/v2/invoice', {
      method: 'POST',
      headers: { 'X-Api-Key': apiKey, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: userRes.user.email,
        offerId,
        currency: 'RUB',
        periodicity: 'ONE_TIME',
      }),
    })
    const data = await res.json()
    if (!res.ok) {
      console.error('Lava.top createInvoice failed:', res.status, data)
      return NextResponse.json({ error: 'Не получилось создать счёт' }, { status: 502 })
    }
    const paymentUrl = data.paymentUrl ?? data.url ?? data.redirectUrl
    if (!paymentUrl) {
      console.error('Lava.top createInvoice: не нашли ссылку на оплату в ответе:', data)
      return NextResponse.json({ error: 'Не получилось создать счёт' }, { status: 502 })
    }
    return NextResponse.json({ paymentUrl })
  } catch (e: any) {
    console.error('Lava.top createInvoice error:', e)
    return NextResponse.json({ error: 'Не получилось создать счёт' }, { status: 502 })
  }
}
