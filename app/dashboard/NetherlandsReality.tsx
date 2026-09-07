'use client'
import { useState, useEffect } from 'react'
import { bg1, line, t1, t2, t3, gold, blue, sans, mono } from '@/lib/theme'
import { supabase } from '@/lib/supabase'
import ScholarshipLock from './ScholarshipLock'
import type { NETHERLANDS_REALITY_GATED } from '@/lib/guides/netherlands'

/** "Реальность · Нидерланды" — тот же принцип, что GermanyReality.tsx. */
type GatedContent = typeof NETHERLANDS_REALITY_GATED

function Mono({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return <span style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.11em', color: t3, ...style }}>{children}</span>
}
function SectionTitle({ children }: { children: React.ReactNode }) {
  return <div style={{ fontFamily: sans, fontSize: 16, fontWeight: 600, color: t1, marginBottom: 12, letterSpacing: '-.01em' }}>{children}</div>
}
function Card({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return <div style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: 20, marginBottom: 16, ...style }}>{children}</div>
}
function StepRow({ t, d }: { t: string; d: string }) {
  return (
    <div style={{ marginBottom: 14 }}>
      <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{t}</div>
      <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{d}</div>
    </div>
  )
}

export default function NetherlandsReality({ isPro = false }: { isPro?: boolean }) {
  const [content, setContent] = useState<GatedContent | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    ;(async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) { if (!cancelled) setLoading(false); return }
      try {
        const res = await fetch('/api/guide/nl', { headers: { Authorization: `Bearer ${session.access_token}` } })
        const data = await res.json()
        if (!cancelled && !data.locked) setContent(data.content)
      } finally {
        if (!cancelled) setLoading(false)
      }
    })()
    return () => { cancelled = true }
  }, [isPro])

  return (
    <div style={{ maxWidth: 880 }}>
      <div style={{ marginBottom: 24 }}>
        <Mono style={{ display: 'block', marginBottom: 10 }}>РЕАЛЬНОСТЬ · НИДЕРЛАНДЫ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Виза и оплата — для гражданина РФ
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          В Нидерландах визовый процесс ведёт сам вуз, а не студент напрямую — но платить нужно раньше,
          чем начнётся сама виза. Ниже — как это устроено на практике.
        </p>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2,1fr)', gap: 10, marginBottom: 24 }}>
        {[
          { l: 'ВИЗА (MVV)', v: 'Подаёт вуз', sub: 'заберёшь сам(а) в VFS Global, Москва' },
          { l: 'ФИНАНСЫ', v: '≈€13 570 / год', sub: 'норма IND на 2026' },
        ].map(c => (
          <div key={c.l} style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: '14px 12px' }}>
            <Mono style={{ display: 'block', marginBottom: 6 }}>{c.l}</Mono>
            <div style={{ fontFamily: sans, fontSize: 16, fontWeight: 700, color: t1, letterSpacing: '-.01em' }}>{c.v}</div>
            <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{c.sub}</div>
          </div>
        ))}
      </div>

      <ScholarshipLock unlocked={!!content} loading={loading}>
        {content && (
          <>
            <Card>
              <SectionTitle>Виза — шаг за шагом</SectionTitle>
              {content.visaSteps.map(s => <StepRow key={s.t} t={s.t} d={s.d} />)}
            </Card>
            <Card>
              <SectionTitle>Оплата депозита и обучения из России</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{content.paymentNote}</p>
            </Card>
            <Card style={{ marginBottom: 0 }}>
              <SectionTitle>Источники</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                {content.sources.map(s => (
                  <a key={s.u} href={s.u} target="_blank" rel="noopener noreferrer" style={{ fontFamily: sans, fontSize: 12, color: blue, textDecoration: 'none' }}>{s.n}</a>
                ))}
              </div>
            </Card>
          </>
        )}
      </ScholarshipLock>
    </div>
  )
}
