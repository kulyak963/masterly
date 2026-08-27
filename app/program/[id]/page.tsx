import { notFound } from 'next/navigation'
import Link from 'next/link'
import type { Metadata } from 'next'
import { supabase } from '../../../lib/supabase'
import { bg0, line, t1, t2, t3, gold, sans, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'
import VerifiedBadge from '@/components/VerifiedBadge'

export const revalidate = 3600

const CNAME: Record<string, string> = {
  de: 'Германия', nl: 'Нидерланды', se: 'Швеция', ch: 'Швейцария',
  fi: 'Финляндия', fr: 'Франция', cz: 'Чехия', at: 'Австрия',
  dk: 'Дания', be: 'Бельгия', ie: 'Ирландия', it: 'Италия',
  es: 'Испания', pt: 'Португалия', no: 'Норвегия', pl: 'Польша',
  hu: 'Венгрия', ee: 'Эстония', lt: 'Литва', lv: 'Латвия',
}

async function getProgram(id: string) {
  const { data } = await supabase
    .from('programs')
    .select('*, university:universities(*)')
    .eq('id', id)
    .single()
  return data
}

export async function generateStaticParams() {
  const { data } = await supabase.from('programs').select('id').limit(1000)
  return (data || []).map((p) => ({ id: p.id }))
}

type Props = { params: Promise<{ id: string }> }

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { id } = await params
  const program = await getProgram(id)
  if (!program) return { title: 'Программа не найдена — Mastersly' }

  const uniName = program.university?.name || ''
  const countryName = CNAME[program.university?.country] || ''
  const title = `${program.name} в ${uniName} — Mastersly`
  const description = program.summary
    ? program.summary.slice(0, 155)
    : `${program.name} — программа магистратуры в ${uniName}${countryName ? `, ${countryName}` : ''}. Дедлайны, стоимость, требования — на Mastersly.`

  return {
    title,
    description,
    alternates: { canonical: `/program/${id}` },
    openGraph: { title, description, type: 'website' },
    twitter: { card: 'summary_large_image', title, description },
  }
}

export default async function ProgramPage({ params }: Props) {
  const { id } = await params
  const program = await getProgram(id)
  if (!program) notFound()

  const uni = program.university
  const countryName = CNAME[uni?.country] || uni?.country?.toUpperCase() || ''
  const cost = program.tuition_eur === 0 ? 'Бесплатно' : `€${Number(program.tuition_eur).toLocaleString('ru-RU')}/год`
  const deadline = program.deadline_month && program.deadline_day
    ? `${String(program.deadline_day).padStart(2, '0')}.${String(program.deadline_month).padStart(2, '0')}`
    : null

  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'EducationalOccupationalProgram',
    name: program.name,
    description: program.summary || undefined,
    provider: uni ? {
      '@type': 'CollegeOrUniversity',
      name: uni.name,
      address: countryName || undefined,
      url: uni.website || undefined,
    } : undefined,
    educationalProgramMode: 'full-time',
    programType: 'Master',
    timeToComplete: program.duration_months ? `P${program.duration_months}M` : undefined,
  }

  return (
    <div style={{ minHeight: '100vh', background: bg0, fontFamily: sans, color: t1, padding: '0 20px 80px' }}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }} />

      <div style={{ maxWidth: 680, margin: '0 auto', paddingTop: 40 }}>
        <Link href="/" style={{ fontFamily: sans, fontWeight: 800, fontSize: 15, color: t1, textDecoration: 'none' }}>
          ← MASTERSLY
        </Link>

        <div style={{ marginTop: 32, marginBottom: 8 }}>
          <VerifiedBadge verified={program.verified} />
        </div>

        <h1 style={{ fontFamily: displayFont.style.fontFamily, fontWeight: 800, fontSize: 32,
          color: t1, letterSpacing: '-.02em', lineHeight: 1.08, marginBottom: 10 }}>
          {program.name}
        </h1>
        <p style={{ fontFamily: sans, fontSize: 15, color: t2, marginBottom: 28 }}>
          {uni?.name}{uni?.city ? `, ${uni.city}` : ''}{countryName ? ` · ${countryName}` : ''}
        </p>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)',
          border: `1px solid ${line}`, borderRadius: 8, overflow: 'hidden', marginBottom: 28 }}>
          {[
            { l: 'СТОИМОСТЬ', v: cost },
            { l: 'IELTS МИНИМУМ', v: program.ielts_min ?? '—' },
            { l: 'РЕЙТИНГ QS', v: uni?.ranking_qs ? `#${uni.ranking_qs}` : '—' },
            { l: 'ДЕДЛАЙН ПОДАЧИ', v: deadline ?? '—' },
            { l: 'ДЛИТЕЛЬНОСТЬ', v: program.duration_months ? `${program.duration_months} мес` : '—' },
            { l: 'ЯЗЫК', v: program.language || 'English' },
          ].map((s, i) => (
            <div key={i} style={{ padding: '14px', borderRight: `1px solid ${line}`, borderBottom: `1px solid ${line}` }}>
              <div style={{ fontFamily: mono, fontSize: 9, letterSpacing: '0.08em', color: t3, marginBottom: 5 }}>{s.l}</div>
              <div style={{ fontFamily: sans, fontSize: 14, color: t1 }}>{s.v}</div>
            </div>
          ))}
        </div>

        {!program.verified && (
          <div style={{ display: 'flex', gap: 10, alignItems: 'center', padding: '12px 16px',
            marginBottom: 28, borderRadius: 8, background: `${gold}0D`, border: `1px solid ${gold}30` }}>
            <span style={{ color: gold, fontSize: 13 }}>⚠</span>
            <span style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>
              Данные собраны ИИ и не проверены человеком — перед подачей документов сверь
              дедлайн и требования на официальном сайте вуза.
            </span>
          </div>
        )}

        {program.summary && (
          <p style={{ fontFamily: sans, fontSize: 14, color: t2, lineHeight: 1.75, fontWeight: 300, marginBottom: 24 }}>
            {program.summary}
          </p>
        )}

        {program.pros?.length > 0 && (
          <div style={{ marginBottom: 20 }}>
            <div style={{ fontFamily: mono, fontSize: 9, letterSpacing: '0.1em', color: t3, marginBottom: 10 }}>ПЛЮСЫ</div>
            {program.pros.map((p: string, i: number) => (
              <div key={i} style={{ display: 'flex', gap: 10, marginBottom: 6 }}>
                <span style={{ color: t3, fontSize: 12, flexShrink: 0 }}>—</span>
                <span style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.5 }}>{p}</span>
              </div>
            ))}
          </div>
        )}

        {program.cons?.length > 0 && (
          <div style={{ marginBottom: 28 }}>
            <div style={{ fontFamily: mono, fontSize: 9, letterSpacing: '0.1em', color: t3, marginBottom: 10 }}>МИНУСЫ</div>
            {program.cons.map((c: string, i: number) => (
              <div key={i} style={{ display: 'flex', gap: 10, marginBottom: 6 }}>
                <span style={{ color: t3, fontSize: 12, flexShrink: 0 }}>—</span>
                <span style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.5 }}>{c}</span>
              </div>
            ))}
          </div>
        )}

        {program.scholarships?.length > 0 && (
          <div style={{ marginBottom: 32 }}>
            <div style={{ fontFamily: mono, fontSize: 9, letterSpacing: '0.1em', color: t3, marginBottom: 10 }}>СТИПЕНДИИ</div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6 }}>
              {program.scholarships.map((s: string, i: number) => (
                <span key={i} style={{ fontFamily: mono, fontSize: 9, padding: '4px 10px', borderRadius: 3,
                  border: `1px solid ${line}`, color: t2 }}>{s}</span>
              ))}
            </div>
          </div>
        )}

        <div style={{ height: 1, background: line, marginBottom: 28 }} />

        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {program.url && (
            <a href={program.url} target="_blank" rel="noopener" style={{
              display: 'block', textAlign: 'center', padding: '13px', borderRadius: 8,
              border: `1px solid ${line}`, fontFamily: sans, fontSize: 13, color: t2, textDecoration: 'none' }}>
              Страница программы на сайте вуза →
            </a>
          )}
          <Link href="/" style={{ display: 'block', textAlign: 'center', padding: '15px', borderRadius: 4,
            border: 'none', background: gold, color: bg0, fontFamily: sans, fontSize: 14, fontWeight: 700,
            textDecoration: 'none', letterSpacing: '-.01em' }}>
            Построить свой план поступления →
          </Link>
        </div>
      </div>
    </div>
  )
}
