'use client'
import { useState, useEffect } from 'react'
import { bg1, line, t1, t2, t3, gold, blue, red, grn, sans, mono } from '@/lib/theme'
import { supabase } from '@/lib/supabase'
import ScholarshipLock from './ScholarshipLock'
import type { HUNGARY_GUIDE_GATED } from '@/lib/guides/hungary'

/**
 * Платная фича «Гайд: Stipendium Hungaricum» — появляется во вкладке
 * «Стипендии · PRO», если у пользователя в profile.countries есть 'hu'.
 *
 * 2026-09-06: гейтед-контент (требования/документы/таймлайн/ошибки/
 * правила/источники) больше НЕ хранится в этом файле — он лежит в
 * lib/guides/hungary.ts (серверный модуль) и приходит через
 * /api/guide/hu, который сам проверяет profiles.is_pro по токену
 * пользователя. Раньше контент лежал прямо тут как константы, и
 * ScholarshipLock только блюрил уже отрисованный DOM — весь текст
 * читался НЕ-Pro пользователем простым копированием текста страницы.
 * См. ScholarshipLock.tsx и app/api/guide/[country]/route.ts.
 *
 * Написано максимально просто (по просьбе Дениса, 2026-08-31) — как для
 * человека, который вообще первый раз в жизни собирает документы для
 * подачи за границу: у каждого документа явно расписано, ЧТО это, ГДЕ
 * получить в России и ЧТО делать дальше (перевод/апостиль), а не только
 * официальное название.
 *
 * Фактура и источники — see docs/stipendium-hungaricum.md (полный
 * ресёрч, собран 2026-08-29 вручную через WebSearch/WebFetch).
 */

type GatedContent = typeof HUNGARY_GUIDE_GATED

function Mono({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return <span style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.11em', color: t3, ...style }}>{children}</span>
}

function SectionTitle({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ fontFamily: sans, fontSize: 16, fontWeight: 600, color: t1, marginBottom: 12, letterSpacing: '-.01em' }}>
      {children}
    </div>
  )
}

function Card({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return (
    <div style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: 20, marginBottom: 16, ...style }}>
      {children}
    </div>
  )
}

interface DocStep { name: string; what: string; where: string; next?: string; cost?: string }

function DocCard({ step, n }: { step: DocStep; n: number }) {
  return (
    <div style={{ display: 'flex', gap: 12, marginBottom: 18, paddingBottom: 18, borderBottom: `1px solid ${line}` }}>
      <div style={{
        width: 24, height: 24, borderRadius: '50%', background: `${gold}18`, border: `1px solid ${gold}40`,
        color: gold, fontFamily: mono, fontSize: 11, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>{n}</div>
      <div>
        <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 5 }}>{step.name}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 6 }}>{step.what}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.next ? 4 : 0 }}>
          <span style={{ color: blue, fontWeight: 600 }}>Где получить: </span>{step.where}
        </div>
        {step.next && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.cost ? 4 : 0 }}>
            <span style={{ color: gold, fontWeight: 600 }}>Что дальше: </span>{step.next}
          </div>
        )}
        {step.cost && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t3, lineHeight: 1.6 }}>
            <span style={{ color: grn, fontWeight: 600 }}>Сколько стоит и ждать: </span>{step.cost}
          </div>
        )}
      </div>
    </div>
  )
}

// Свободная часть — крючок, показывается всем независимо от Pro.
const STAT_CHIPS = [
  { l: 'КВОТА ДЛЯ РОССИИ', v: '200', sub: 'мест / год' },
  { l: 'ПРОХОДНОЙ БАЛЛ', v: '56/100', sub: 'вступительный экзамен' },
  { l: 'СТИПЕНДИЯ', v: '43 700', sub: 'HUF / мес' },
  { l: 'ОБУЧЕНИЕ', v: '100%', sub: 'покрывается' },
]

const FINANCE_ROWS = [
  { l: 'Обучение', v: '100% — вуз получает оплату напрямую от Tempus, студент не платит' },
  { l: 'Стипендия (bachelor/master)', v: '43 700 HUF/мес' },
  { l: 'Стипендия (doctoral)', v: '140 000–163 000 HUF/мес, зависит от года обучения' },
  { l: 'Проживание', v: 'место в общежитии бесплатно, либо доплата ≈40 000 HUF/мес' },
  { l: 'Медстраховка', v: 'полная, на весь период обучения' },
]

export default function HungaryGuide({ programs = [], isPro = false }: { programs?: any[]; isPro?: boolean }) {
  const huPrograms = programs.filter(p => p.university?.country === 'hu')
  const shPrograms = huPrograms.filter(p => (p.scholarships || []).some((s: string) => s.includes('Stipendium')))

  const [content, setContent] = useState<GatedContent | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    ;(async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) { if (!cancelled) setLoading(false); return }
      try {
        const res = await fetch('/api/guide/hu', { headers: { Authorization: `Bearer ${session.access_token}` } })
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
      {/* hero */}
      <div style={{ marginBottom: 24 }}>
        <Mono style={{ display: 'block', marginBottom: 10 }}>ГАЙД · ВЕНГРИЯ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Stipendium Hungaricum от А до Я
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          Полное пошаговое руководство по главной стипендии для учёбы в Венгрии: кто и как подаёт,
          какие документы нужны и где их получить, дедлайны, частые ошибки и правила во время учёбы.
          {shPrograms.length > 0 && <> В нашей базе сейчас {shPrograms.length} программ в Венгрии с этой стипендией.</>}
        </p>
      </div>

      {/* free stat chips */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 10, marginBottom: 24 }}>
        {STAT_CHIPS.map(c => (
          <div key={c.l} style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: '14px 12px' }}>
            <Mono style={{ display: 'block', marginBottom: 6 }}>{c.l}</Mono>
            <div style={{ fontFamily: sans, fontSize: 20, fontWeight: 700, color: t1, letterSpacing: '-.02em' }}>{c.v}</div>
            <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{c.sub}</div>
          </div>
        ))}
      </div>

      {/* русский слой — свободный крючок про визу/оплату, тот же паттерн,
          что в GermanyReality/NetherlandsReality (см. аудит 2026-09-07) */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3,1fr)', gap: 10, marginBottom: 24 }}>
        {[
          { l: 'ВИЗА', v: 'Без спецограничений', sub: 'D-виза через VFS Global' },
          { l: 'ОПЛАТА ИЗ РФ', v: 'OTP Bank', sub: 'внутригрупповой канал' },
          { l: 'СРОК РАССМОТРЕНИЯ', v: 'Недели', sub: 'закладывай запас' },
        ].map(c => (
          <div key={c.l} style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: '14px 12px' }}>
            <Mono style={{ display: 'block', marginBottom: 6 }}>{c.l}</Mono>
            <div style={{ fontFamily: sans, fontSize: 16, fontWeight: 700, color: t1, letterSpacing: '-.01em' }}>{c.v}</div>
            <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{c.sub}</div>
          </div>
        ))}
      </div>

      {/* free section — hook */}
      <Card>
        <SectionTitle>Что покрывает стипендия</SectionTitle>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {FINANCE_ROWS.map(r => (
            <div key={r.l} style={{ display: 'flex', gap: 14, paddingBottom: 10, borderBottom: `1px solid ${line}` }}>
              <div style={{ fontFamily: sans, fontSize: 12, color: t2, width: 190, flexShrink: 0 }}>{r.l}</div>
              <div style={{ fontFamily: sans, fontSize: 13, color: t1 }}>{r.v}</div>
            </div>
          ))}
        </div>
      </Card>

      <ScholarshipLock unlocked={!!content} loading={loading}>
        {content && (
          <>
            <Card>
              <SectionTitle>Виза — шаг за шагом</SectionTitle>
              {content.visaSteps.map(s => (
                <div key={s.t} style={{ marginBottom: 14 }}>
                  <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{s.t}</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{s.d}</div>
                </div>
              ))}
            </Card>

            <Card>
              <SectionTitle>Как оплатить обучение из России</SectionTitle>
              {content.paymentMethods.map(s => (
                <div key={s.t} style={{ marginBottom: 14 }}>
                  <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{s.t}</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{s.d}</div>
                </div>
              ))}
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6, marginTop: 8 }}>
                {content.realitySources.map((s: any) => (
                  <a key={s.u} href={s.u} target="_blank" rel="noopener noreferrer" style={{ fontFamily: sans, fontSize: 11, color: blue, textDecoration: 'none' }}>{s.n}</a>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Требования к кандидату</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                {content.requirements.map(r => (
                  <div key={r.t}>
                    <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{r.t}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{r.d}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Документы: что нужно и где получить</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 18 }}>
                Нужно собрать документы для <b style={{ color: t1 }}>двух</b> независимых треков подачи
                — это не ошибка и не дублирование, а особенность именно для России: одни и те же (в основном)
                документы отправляются в две разные организации, обе части обязательны.
              </p>
              <Mono style={{ display: 'block', marginBottom: 4, color: blue }}>ТРЕК А · TEMPUS (DREAMAPPLY)</Mono>
              <p style={{ fontFamily: sans, fontSize: 11, color: t3, lineHeight: 1.5, marginBottom: 16 }}>
                Венгерская сторона — сайт-портал, куда загружаются все документы онлайн.
              </p>
              {content.docsTrackA.map((d, i) => <DocCard key={d.name} step={d} n={i + 1} />)}
              <Mono style={{ display: 'block', marginBottom: 4, marginTop: 4, color: gold }}>ТРЕК Б · МИНОБРНАУКИ РФ</Mono>
              <p style={{ fontFamily: sans, fontSize: 11, color: t3, lineHeight: 1.5, marginBottom: 16 }}>
                Российская сторона — без её одобрения заявка в Tempus не рассматривается вообще.
              </p>
              {content.docsTrackB.map((d, i) => <DocCard key={d.name} step={d} n={i + 1} />)}
            </Card>

            <Card>
              <SectionTitle>Таймлайн подачи</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                {content.timeline.map((row, i) => (
                  <div key={row.m} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < content.timeline.length - 1 ? `1px solid ${line}` : 'none' }}>
                    <div style={{ fontFamily: mono, fontSize: 11, color: gold, width: 140, flexShrink: 0 }}>{row.m}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2 }}>{row.t}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Частые ошибки</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {content.mistakes.map((m, i) => (
                  <div key={i} style={{ display: 'flex', gap: 10 }}>
                    <div style={{ color: red, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>✕</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Правила во время обучения</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {content.studyRules.map((m, i) => (
                  <div key={i} style={{ display: 'flex', gap: 10 }}>
                    <div style={{ color: grn, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>→</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Работа во время учёбы</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{content.workRulesText}</p>
            </Card>

            <Card style={{ marginBottom: 0 }}>
              <SectionTitle>Источники</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
                {content.sources.map(s => (
                  <a key={s.u} href={s.u} target="_blank" rel="noopener noreferrer"
                    style={{ fontFamily: sans, fontSize: 12, color: blue, textDecoration: 'none' }}>
                    {s.n}
                  </a>
                ))}
              </div>
            </Card>
          </>
        )}
      </ScholarshipLock>
    </div>
  )
}
