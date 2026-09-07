'use client'
import { useState, useEffect } from 'react'
import { bg1, line, t1, t2, t3, gold, blue, red, grn, purp, sans, mono } from '@/lib/theme'
import { supabase } from '@/lib/supabase'
import ScholarshipLock from './ScholarshipLock'
import type { ITALY_GUIDE_GATED } from '@/lib/guides/italy'

/**
 * Платная фича «Гайд: стипендии и льготы в Италии» — появляется во вкладке
 * «Стипендии · PRO», если у пользователя в profile.countries есть 'it'.
 *
 * 2026-09-06: гейтед-контент теперь в lib/guides/italy.ts (серверный
 * модуль), приходит через /api/guide/it после проверки profiles.is_pro на
 * сервере — см. подробное объяснение в HungaryGuide.tsx и
 * app/api/guide/[country]/route.ts.
 *
 * Написано максимально подробно, разжёвывая каждый термин (ISEE, CAF,
 * No-Tax Area и т.д.) — по просьбе Дениса, 2026-08-31. В отличие от
 * Венгрии, в Италии поступление в вуз и заявка на льготы/стипендию — два
 * ПОЛНОСТЬЮ отдельных процесса (обычные документы для поступления —
 * диплом/языковой экзамен/CV — уже покрыты в общем плане Mastersly, не дублируются
 * здесь). Этот гайд — только про деньги: как получить скидку/стипендию
 * через итальянскую систему ISEE и региональные DSU-агентства.
 *
 * Фактура и источники — see docs/italy-scholarships.md (полный ресёрч,
 * собран 2026-08-31 вручную через WebSearch/WebFetch).
 */

type GatedContent = typeof ITALY_GUIDE_GATED

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
            <span style={{ color: grn, fontWeight: 600 }}>Сколько ждать: </span>{step.cost}
          </div>
        )}
      </div>
    </div>
  )
}

const STAT_CHIPS = [
  { l: 'NO-TAX AREA', v: '€22 000', sub: 'ISEE и ниже = обучение бесплатно' },
  { l: 'MAECI', v: '€10 800', sub: 'госстипендия, 9 месяцев' },
  { l: 'DSU ПОРОГ', v: '€25–28к', sub: 'ISEE, зависит от региона' },
  { l: 'РЕГИОНОВ', v: '8', sub: 'у наших вузов — своё агентство' },
]

const LEVELS = [
  { l: '1. Национальный уровень', v: 'Государственные программы Италии — не привязаны к вузу или региону. Главные: MAECI (стипендия МИД Италии) и Invest Your Talent (только для избранных стран — Россия не входит).' },
  { l: '2. Региональный уровень — DSU', v: 'Diritto allo Studio Universitario — «право на образование». Это не стипендия одного вуза, а система соцподдержки по месту учёбы: стипендия + общежитие + питание + освобождение от налога, на основе дохода семьи (ISEE).' },
  { l: '3. Университетский уровень', v: '«No-Tax Area» — обязательное по закону освобождение от платы за обучение при низком ISEE (у каждого вуза свой порог, не ниже национального минимума), плюс собственные программы конкретных вузов.' },
]

export default function ItalyGuide({ programs = [], isPro = false }: { programs?: any[]; isPro?: boolean }) {
  const itPrograms = programs.filter(p => p.university?.country === 'it')

  const [content, setContent] = useState<GatedContent | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let cancelled = false
    ;(async () => {
      const { data: { session } } = await supabase.auth.getSession()
      if (!session) { if (!cancelled) setLoading(false); return }
      try {
        const res = await fetch('/api/guide/it', { headers: { Authorization: `Bearer ${session.access_token}` } })
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
        <Mono style={{ display: 'block', marginBottom: 10 }}>ГАЙД · ИТАЛИЯ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Стипендии и льготы в Италии от А до Я
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          В Италии нет одной «стипендии для всех» — есть три независимых системы (страна, регион,
          вуз), которые можно и нужно комбинировать. Полный разбор: что такое ISEE и как его
          получить, где какое региональное агентство, какие программы реально доступны из России.
          {itPrograms.length > 0 && <> В нашей базе сейчас {itPrograms.length} программ в Италии.</>}
        </p>
      </div>

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
          { l: 'ВИЗА', v: 'Только биометрический паспорт', sub: 'через визовые центры' },
          { l: 'СРОК РАССМОТРЕНИЯ', v: 'До 3-4 месяцев', sub: 'начинай заранее' },
          { l: 'ОПЛАТА ИЗ РФ', v: 'Poste Italiane, BNL', sub: 'ещё принимают переводы' },
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
        <SectionTitle>Три уровня льгот — и как они складываются</SectionTitle>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          {LEVELS.map(l => (
            <div key={l.l}>
              <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{l.l}</div>
              <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{l.v}</div>
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
              <SectionTitle>Что такое ISEE — ключ ко всей системе</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 12 }}>
                <b style={{ color: t1 }}>ISEE</b> (Indicatore della Situazione Economica Equivalente) —
                официальный итальянский показатель благосостояния семьи. Почти все льготы и стипендии в
                Италии рассчитываются именно от него — чем он ниже, тем больше скидок и выплат.
              </p>
              <div style={{ background: `${gold}0D`, border: `1px solid ${gold}30`, borderRadius: 6, padding: 14, marginBottom: 12, fontFamily: mono, fontSize: 12, color: t1, textAlign: 'center' }}>
                {content.iseeIntro.formula}
              </div>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 8 }}>
                Коэффициент растёт с числом членов семьи (значит, при том же доходе итоговый ISEE у
                большой семьи ниже, чем у маленькой):
              </p>
              <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 12 }}>
                {content.iseeIntro.coefficients.map(([n, v]) => (
                  <div key={n} style={{ padding: '6px 10px', borderRadius: 6, border: `1px solid ${line}`, fontFamily: mono, fontSize: 11 }}>
                    <span style={{ color: t3 }}>{n}: </span><span style={{ color: t1 }}>{v}</span>
                  </div>
                ))}
              </div>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>
                Если семья студента живёт и получает доход <b style={{ color: t1 }}>не в Италии</b> (обычный
                случай для России) — обычный ISEE оформить нельзя. Вместо него нужна специальная версия —{' '}
                <b style={{ color: t1 }}>ISEE Parificato</b> («приравненный ISEE») — считается по той же
                формуле, но доходы и имущество за рубежом пересчитываются в евро.
              </p>
            </Card>

            <Card>
              <SectionTitle>Документы для ISEE Parificato — что нужно и где получить</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 18 }}>
                Это отдельные документы от тех, что нужны для самого поступления (диплом, языковой экзамен, CV —
                это уже покрыто в общем плане поступления) — здесь речь только про документы,
                подтверждающие доход и имущество семьи, нужные для расчёта скидки/стипендии.
              </p>
              {content.iseeDocs.map((d, i) => <DocCard key={d.name} step={d} n={i + 1} />)}
            </Card>

            <Card>
              <SectionTitle>No-Tax Area — освобождение от платы за обучение</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 14 }}>
                По итальянскому закону вузы ОБЯЗАНЫ полностью освобождать от платы за обучение студентов
                с ISEE ниже национального минимума (€22 000 на 2026/27). Каждый вуз вправе поднять свой
                порог выше — многие так и делают:
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                {content.noTaxArea.map((r, i) => (
                  <div key={r.u} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < content.noTaxArea.length - 1 ? `1px solid ${line}` : 'none' }}>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t1, width: 170, flexShrink: 0 }}>{r.u}</div>
                    <div style={{ fontFamily: mono, fontSize: 12, color: grn, width: 130, flexShrink: 0 }}>{r.v}</div>
                    <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{r.note}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>DSU по регионам — где какой вуз и какое агентство</SectionTitle>
              <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 14 }}>
                Пороги — на цикл 2026/27, для будущих циклов нужно перепроверять.
              </p>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                {content.dsuTable.map((r, i) => (
                  <div key={r.region} style={{ padding: '12px 0', borderBottom: i < content.dsuTable.length - 1 ? `1px solid ${line}` : 'none' }}>
                    <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 3 }}>
                      <span style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1 }}>{r.region}</span>
                      <span style={{ fontFamily: mono, fontSize: 11, color: gold }}>{r.agency}</span>
                    </div>
                    <div style={{ fontFamily: sans, fontSize: 11, color: t3, marginBottom: 3 }}>{r.unis}</div>
                    <div style={{ fontFamily: sans, fontSize: 11, color: t2 }}>
                      ISEE-порог: <span style={{ color: grn }}>{r.isee}</span> · стипендия: <span style={{ color: grn }}>{r.amount}</span>
                    </div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Таймлайн подачи</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                {content.timeline.map((row, i) => (
                  <div key={row.m} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < content.timeline.length - 1 ? `1px solid ${line}` : 'none' }}>
                    <div style={{ fontFamily: mono, fontSize: 11, color: gold, width: 170, flexShrink: 0 }}>{row.m}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2 }}>{row.t}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Национальные программы</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
                {content.national.map(n => (
                  <div key={n.title}>
                    <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 4 }}>{n.title}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 6 }}>{n.body}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: n.positive ? grn : red, lineHeight: 1.6, fontWeight: 500 }}>{n.note}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Особые программы конкретных вузов</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
                {content.uniSpecial.map(u => (
                  <div key={u.u}>
                    <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: purp, marginBottom: 3 }}>{u.u}</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{u.v}</div>
                  </div>
                ))}
              </div>
            </Card>

            <Card>
              <SectionTitle>Что перепроверить перед подачей</SectionTitle>
              <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
                {content.caveats.map((m, i) => (
                  <div key={i} style={{ display: 'flex', gap: 10 }}>
                    <div style={{ color: red, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>⚠</div>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
                  </div>
                ))}
              </div>
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
