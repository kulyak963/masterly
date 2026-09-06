'use client'
import { useState } from 'react'
import { bg0, bg1, bg2, line, t1, t2, gold, sans, mono } from '@/lib/theme'

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
 * Платежа в проекте всё ещё нет — кнопка честно говорит об этом, не
 * делает вид, что что-то происходит.
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
  const [unlockMsg, setUnlockMsg] = useState(false)
  if (unlocked) return <>{children}</>

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
