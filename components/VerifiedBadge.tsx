import { mono, gold, grn } from '@/lib/theme'

/**
 * Бейдж «данные проверены человеком» / «оценка ИИ, не проверено».
 *
 * Раньше был продублирован дважды с чуть разной версткой: один раз в
 * `app/dashboard/page.tsx`, второй раз вручную инлайн в
 * `app/program/[id]/page.tsx`. Теперь один вариант, используется в обоих
 * местах — иначе бейдж «доверия к данным» на публичной странице программы
 * и в личном кабинете мог незаметно разъехаться в оформлении.
 */
export default function VerifiedBadge({ verified }: { verified?: boolean }) {
  return verified ? (
    <span
      style={{
        fontFamily: mono, fontSize: 8, fontWeight: 700, letterSpacing: '0.06em',
        padding: '2px 6px', borderRadius: 3, flexShrink: 0,
        background: `${grn}18`, border: `1px solid ${grn}40`, color: grn,
      }}
    >
      ✓ ПРОВЕРЕНО
    </span>
  ) : (
    <span
      style={{
        fontFamily: mono, fontSize: 8, fontWeight: 700, letterSpacing: '0.06em',
        padding: '2px 6px', borderRadius: 3, flexShrink: 0,
        background: `${gold}15`, border: `1px solid ${gold}35`, color: gold,
      }}
    >
      ⚠ ОЦЕНКА ИИ
    </span>
  )
}
