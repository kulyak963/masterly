import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../lib/supabaseAdmin'

// Создаёт счёт на оплату Mastersly PRO через Lava.top и возвращает ссылку
// на чек-аут — вызывается кнопкой "Разблокировать Pro" в дашборде.
// email берётся из аутентифицированной сессии (не из тела запроса), чтобы
// вебхук потом мог однозначно сматчить оплату с профилем (см.
// app/api/webhooks/lava-top/route.ts) — присланный клиентом email нельзя
// было бы доверять.
//
// Эндпоинт создания счёта и структура ответа (включая поле paymentUrl)
// подтверждены живым вызовом с реальным ключом 2026-09-07 — ответ
// содержал настоящую рабочую ссылку на чек-аут (проверено визуально).
//
// offerId — это НЕ id самого продукта из его URL в личном кабинете
// (app.lava.top/products/<productId>), а id вложенного "оффера" внутри
// продукта (у продукта может быть несколько офферов с разными ценами).
// Получить его можно вызовом GET https://gate.lava.top/api/v2/products
// с заголовком X-Api-Key — в ответе offers[0].id.
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
