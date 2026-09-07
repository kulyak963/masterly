import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../lib/supabaseAdmin'

// "Здесь ошибка" на карточке программы (задача 4.3, план после аудита
// продукта 2026-09-07) — публичный эндпоинт без авторизации (сообщить
// об ошибке должен мочь и незалогиненный посетитель /program/[id]),
// пишет через admin-клиент, т.к. RLS-политику для анонимной записи
// отдельно настраивать не нужно — это не персональные данные пользователя,
// просто текст жалобы плюс необязательный email для ответа.
export async function POST(req: NextRequest) {
  const { programId, message, email } = await req.json()
  if (!message || typeof message !== 'string' || message.trim().length < 3) {
    return NextResponse.json({ error: 'Напиши, что именно не так' }, { status: 400 })
  }
  if (message.length > 2000) {
    return NextResponse.json({ error: 'Слишком длинное сообщение' }, { status: 400 })
  }

  const db = getSupabaseAdmin()
  const { error } = await db.from('data_reports').insert({
    program_id: programId || null,
    message: message.trim(),
    reporter_email: email?.trim() || null,
  })
  if (error) {
    console.error('data_reports insert failed:', error.message)
    return NextResponse.json({ error: 'Не получилось отправить — попробуй позже' }, { status: 502 })
  }
  return NextResponse.json({ ok: true })
}
