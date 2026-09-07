'use client'
import { useState, useEffect } from 'react'
import { bg1, line, t1, t2, t3, gold, blue, red, grn, sans, mono } from '@/lib/theme'
import { supabase } from '@/lib/supabase'
import ScholarshipLock from './ScholarshipLock'
import type { GERMANY_REALITY_GATED } from '@/lib/guides/germany'

/**
 * "Реальность · Германия" — русский слой поверх обычного подбора программ:
 * виза, блокированный счёт, реальная оплата обучения из России. Раньше
 * этого не было вообще ни для одной страны кроме Венгрии/Италии, хотя
 * именно в Германию и Нидерланды продукт ведёт большинство студентов
 * (см. аудит продукта 2026-09-07). Гейтинг — тот же паттерн, что в
 * HungaryGuide.tsx: контент лежит в lib/guides/germany.ts (сервер-онли),
 * приходит через /api/guide/de только при подтверждённом is_pro.
 */
type GatedContent = typeof GERMANY_REALITY_GATED

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

export default function GermanyReality({ isPro = false }: { isPro?: boolean }) {
  const [content, setContent] = useState<GatedContent | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    ;(async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) { if (!cancelled) setLoading(false); return }
      try {
        const res = await fetch('/api/guide/de', { headers: { Authorization: `Bearer ${session.access_token}` } })
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
        <Mono style={{ display: 'block', marginBottom: 10 }}>РЕАЛЬНОСТЬ · ГЕРМАНИЯ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Виза, счёт и оплата — для гражданина РФ
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          Германия в основном бесплатна по обучению, но получение визы и денежный вопрос — отдельная задача,
          специфичная именно для не-ЕС студентов. Ниже — как это устроено на практике.
        </p>
      </div>

      {/* free hook — светофор визы, без деталей */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 10, marginBottom: 24 }}>
        {[
          { l: 'ВИЗА', v: 'Через VisaMetric', sub: 'национальная виза типа D' },
          { l: 'БЛОКИРОВАННЫЙ СЧЁТ', v: '€11 904 / год', sub: 'Fintiba или Expatrio' },
          { l: 'ОПЛАТА ИЗ РФ', v: 'SWIFT ограничен', sub: 'есть рабочие пути' },
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
              <SectionTitle>Блокированный счёт (Sperrkonto)</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 14 }}>
                Сумма: <b style={{ color: t1 }}>{content.blockedAccount.amount}</b><br/>
                Провайдеры: <b style={{ color: t1 }}>{content.blockedAccount.providers.join(', ')}</b>
              </p>
              {content.blockedAccount.steps.map(s => <StepRow key={s.t} t={s.t} d={s.d} />)}
              <div style={{ marginTop: 8, padding: '12px 14px', background: `${gold}0D`, borderLeft: `3px solid ${gold}`, borderRadius: '0 6px 6px 0' }}>
                <div style={{ fontFamily: sans, fontSize: 11, fontWeight: 600, color: gold, marginBottom: 4 }}>⚠ Ситуация может измениться</div>
                <p style={{ fontFamily: sans, fontSize: 11, color: t2, lineHeight: 1.6 }}>{content.blockedAccount.caveat}</p>
              </div>
            </Card>

            <Card>
              <SectionTitle>Как оплатить обучение и депозит из России</SectionTitle>
              {content.paymentMethods.map(s => <StepRow key={s.t} t={s.t} d={s.d} />)}
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
