'use client'
import { useState } from 'react'
import { bg0, bg2, line, t1, t2, gold, sans, mono } from '@/lib/theme'

/**
 * Общий "замок" для платного контента гайдов по стипендиям (Венгрия,
 * Италия, и любая следующая страна). Вынесен из HungaryGuide.tsx, чтобы не
 * дублировать одну и ту же разметку блюра/кнопки в каждом новом гайде.
 * Платежа в проекте всё ещё нет — кнопка честно говорит об этом, не
 * делает вид, что что-то происходит.
 *
 * `isPro` (2026-08-31) — читается из `profiles.is_pro`, ручной/админский
 * флаг (см. sql/2026-08-31-add-is-pro-column.sql и scripts/set-pro.mjs) —
 * включается вручную через Supabase, никакого платежа за ним пока нет.
 * Когда isPro=true — рендерим детей как есть, без блюра и кнопки.
 */
export default function ScholarshipLock({ children, isPro = false }: { children: React.ReactNode; isPro?: boolean }) {
  const [unlockMsg, setUnlockMsg] = useState(false)
  if (isPro) return <>{children}</>
  return (
    <div style={{ position: 'relative' }}>
      <div style={{ filter: 'blur(5px)', userSelect: 'none', pointerEvents: 'none', maxHeight: 620, overflow: 'hidden' }}>
        {children}
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
          <button onClick={() => setUnlockMsg(true)} style={{
            width: '100%', padding: '11px', borderRadius: 8, border: 'none',
            background: gold, color: bg0, fontFamily: sans, fontSize: 13, fontWeight: 600,
            cursor: 'pointer', letterSpacing: '-.01em', marginBottom: unlockMsg ? 10 : 0,
          }}>
            Разблокировать
          </button>
          {unlockMsg && (
            <p style={{ fontFamily: sans, fontSize: 11, color: t2, lineHeight: 1.5 }}>
              Оплата пока не подключена — эта часть продукта в разработке. Скоро можно будет
              разблокировать гайд разовым платежом.
            </p>
          )}
        </div>
      </div>
    </div>
  )
}
