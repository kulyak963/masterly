import { supabase } from './supabase'

// Общий вызов для всех кнопок "Разблокировать Pro" — создаёт счёт через
// /api/checkout (email берётся сервером из сессии, не отсюда) и уводит
// на страницу оплаты Lava.top. Один общий хелпер вместо копипасты в
// ScholarshipLock.tsx / ProUpsell, чтобы поведение не разъезжалось.
export async function startCheckout(): Promise<{ error?: string }> {
  const { data: { session } } = await supabase.auth.getSession()
  if (!session) return { error: 'Сначала войди в аккаунт' }

  try {
    const res = await fetch('/api/checkout', {
      method: 'POST',
      headers: { Authorization: `Bearer ${session.access_token}` },
    })
    const data = await res.json()
    if (!res.ok || !data.paymentUrl) {
      return { error: data.error ?? 'Не получилось начать оплату — попробуй позже' }
    }
    window.location.href = data.paymentUrl
    return {}
  } catch {
    return { error: 'Не получилось начать оплату — попробуй позже' }
  }
}
