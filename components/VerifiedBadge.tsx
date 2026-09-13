import { mono, grn } from '@/lib/theme'

/**
 * Бейдж «данные проверены человеком». Раньше был продублирован дважды с
 * чуть разной версткой: один раз в `app/dashboard/page.tsx`, второй раз
 * вручную инлайн в `app/program/[id]/page.tsx`. Теперь один вариант,
 * используется в обоих местах.
 *
 * 2026-09-13, по просьбе Дениса: непроверенные программы больше не
 * получают отдельную плашку «⚠ Оценка ИИ» — только verified=true
 * показывает бейдж, остальные — ничего (не привлекать внимание к тому,
 * что не проверено, только подчёркивать то, что проверено).
 */
export default function VerifiedBadge({ verified }: { verified?: boolean }) {
  if (!verified) return null
  return (
    <span
      style={{
        fontFamily: mono, fontSize: 8, fontWeight: 700, letterSpacing: '0.06em',
        padding: '2px 6px', borderRadius: 3, flexShrink: 0,
        background: `${grn}18`, border: `1px solid ${grn}40`, color: grn,
      }}
    >
      ✓ ПРОВЕРЕНО
    </span>
  )
}
