'use client'
import { useState } from 'react'
import { bg0, bg1, bg2, line, t1, t2, gold, red, sans, mono } from '@/lib/theme'
import { startCheckout } from '@/lib/checkout'

/**
 * Общий "замок" для платного контента гайдов по стипендиям (Венгрия,
 * Италия, и любая следующая страна).
 *
 * 2026-09-06: раньше принимал реальный контент как children и просто
 * накладывал CSS-блюр — сам текст всё равно уходил в HTML/JS клиенту,
 * блюр защищал только от взгляда, не от чтения. Теперь для НЕ-Pro
 * пользователя реальный контент серверу вообще не запрашивается (см.
 * app/api/guide/[country]/route.ts) — сюда приходит либо реальные дети
 * (когда unlocked=true), либо ничего, и компонент сам рисует общий
 * скелетон-плейсхолдер вместо попытки "заблюрить" несуществующий текст.
 *
 * 2026-09-07: кнопка ведёт на реальный чек-аут Lava.top (см.
 * lib/checkout.ts) — раньше честно говорила "оплата не подключена".
 */
function SkeletonLines({ n = 3 }: { n?: number }) {
  const widths = ['92%', '78%', '85%', '65%', '90%']
  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
      {Array.from({ length: n }).map((_, i) => (
        <div key={i} style={{ height: 11, borderRadius: 4, background: 'rgba(255,255,255,.06)', width: widths[i % widths.length] }} />
      ))}
    </div>
  )
}

function SkeletonCard() {
  return (
    <div style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: 20, marginBottom: 16 }}>
      <div style={{ height: 14, width: '40%', borderRadius: 4, background: 'rgba(255,255,255,.09)', marginBottom: 16 }} />
      <SkeletonLines n={3} />
    </div>
  )
}

export default function ScholarshipLock({ children, unlocked = false, loading = false }: { children: React.ReactNode; unlocked?: boolean; loading?: boolean }) {
  const [buying, setBuying] = useState(false)
  const [error, setError] = useState<string | null>(null)
  if (unlocked) return <>{children}</>

  const onBuy = async () => {
    setBuying(true)
    setError(null)
    const res = await startCheckout()
    if (res.error) { setError(res.error); setBuying(false) }
    // при успехе — редирект на Lava.top, компонент размонтируется сам
  }

  return (
    <div style={{ position: 'relative' }}>
      <div style={{ pointerEvents: 'none', userSelect: 'none', maxHeight: 620, overflow: 'hidden', opacity: loading ? 0.5 : 1 }}>
        <SkeletonCard />
        <SkeletonCard />
        <SkeletonCard />
      </div>
      <div style={{
        position: 'absolute', inset: 0, top: 40,
        background: `linear-gradient(180deg, transparent 0%, ${bg0} 70%)`,
        display: 'flex', alignItems: 'flex-end', justifyContent: 'center', paddingBottom: 20,
      }}>
        <div style={{
          background: bg2, border: `1px solid ${line}`, borderRadius: 10, padding: '24px 28px',
          textAlign: 'center', maxWidth: 380, boxShadow: '0 20px 48px rgba(0,0,0,.55)',
        }}>
          <div style={{ fontFamily: mono, fontSize: 20, marginBottom: 10 }}>🔒</div>
          <div style={{ fontFamily: sans, fontSize: 15, fontWeight: 600, color: t1, marginBottom: 6 }}>
            Полный гайд — платная фича
          </div>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5, marginBottom: 16 }}>
            Требования, документы, дедлайны и частые ошибки — разово, без подписки.
          </p>
          {/* Раньше цену было видно только на странице Lava.top после
              клика — для аудитории, которая считает каждую тысячу, это
              читалось как подвох (см. аудит продукта 2026-09-07). */}
          <div style={{ fontFamily: sans, fontSize: 20, fontWeight: 700, color: t1, marginBottom: 4 }}>
            2 990 ₽
          </div>
          <p style={{ fontFamily: sans, fontSize: 11, color: t2, marginBottom: 16 }}>
            разово — русский слой по визе и оплате, полные гайды по всем странам, безлимитное избранное, таймлайн, ИИ-анализ
          </p>
          <button onClick={onBuy} disabled={buying} style={{
            width: '100%', padding: '11px', borderRadius: 8, border: 'none',
            background: gold, color: bg0, fontFamily: sans, fontSize: 13, fontWeight: 600,
            cursor: buying ? 'not-allowed' : 'pointer', letterSpacing: '-.01em',
            marginBottom: error ? 10 : 0, opacity: buying ? 0.7 : 1,
          }}>
            {buying ? 'Открываем оплату…' : 'Разблокировать'}
          </button>
          {error && (
            <p style={{ fontFamily: sans, fontSize: 11, color: red, lineHeight: 1.5 }}>
              {error}
            </p>
          )}
        </div>
      </div>
    </div>
  )
}
