'use client'
import Link from 'next/link'
import { useEffect } from 'react'
import { bg0, line, t1, t2, t3, gold, sans, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'

// Общий каркас для юридических страниц (оферта, политика
// конфиденциальности, условия использования, cookie). До этого каждая
// страница объявляла свою копию вёрстки и своего <Section> — ровно та
// история, из-за которой когда-то разъехались цвета по всему проекту
// (см. lib/theme.ts). Новые юридические страницы делать только отсюда.

const CSS = `
*,*::before,*::after{box-sizing:border-box}
html,body{background:${bg0};-webkit-font-smoothing:antialiased}
.legal a{color:${gold};text-decoration:underline}
.legal li{margin-bottom:6px}
.legal ul,.legal ol{padding-left:20px;margin:10px 0}
`

export function Section({ n, title, children }: { n: string; title: string; children: React.ReactNode }) {
  return (
    <div style={{ marginBottom: 32 }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 12, marginBottom: 10 }}>
        <span style={{ fontFamily: mono, fontSize: 11, color: t3 }}>{n}</span>
        <h2 style={{ fontFamily: sans, fontWeight: 700, fontSize: 19, color: t1, letterSpacing: '-.01em' }}>{title}</h2>
      </div>
      <div className="legal" style={{ fontFamily: sans, fontSize: 14, color: t2, lineHeight: 1.75, fontWeight: 300 }}>
        {children}
      </div>
    </div>
  )
}

/** Врезка для того, что пользователь должен заметить обязательно. */
export function Callout({ children, tone = 'gold' }: { children: React.ReactNode; tone?: 'gold' | 'plain' }) {
  return (
    <div style={{
      padding: '14px 18px', marginBottom: 28, borderRadius: 8,
      background: tone === 'gold' ? `${gold}14` : 'rgba(255,255,255,.03)',
      border: tone === 'gold' ? `1px solid ${gold}4D` : `1px solid ${line}`,
    }}>
      <span className="legal" style={{
        fontFamily: sans, fontSize: 13, lineHeight: 1.65,
        color: tone === 'gold' ? gold : t2, display: 'block',
      }}>{children}</span>
    </div>
  )
}

/** Строка «поле — значение» для реквизитов. */
export function Field({ k, v }: { k: string; v: React.ReactNode }) {
  return (
    <div style={{ display: 'flex', gap: 12, padding: '7px 0', borderBottom: `1px solid ${line}`, flexWrap: 'wrap' }}>
      <span style={{ fontFamily: mono, fontSize: 10, color: t3, letterSpacing: '.06em', minWidth: 190, textTransform: 'uppercase' }}>{k}</span>
      <span style={{ fontFamily: sans, fontSize: 13.5, color: t1, flex: 1, minWidth: 200 }}>{v}</span>
    </div>
  )
}

export default function LegalPage({
  updated, title, intro, children,
}: {
  updated: string
  title: string
  intro?: React.ReactNode
  children: React.ReactNode
}) {
  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)
    return () => { s.remove() }
  }, [])

  return (
    <div style={{ minHeight: '100vh', background: bg0, fontFamily: sans, color: t1, padding: '0 20px 80px' }}>
      <div style={{ maxWidth: 680, margin: '0 auto', paddingTop: 48 }}>
        <Link href="/" style={{ fontFamily: sans, fontWeight: 700, fontSize: 18, color: t1, textDecoration: 'none' }}>
          ← Mastersly
        </Link>

        <div style={{ marginTop: 32, marginBottom: 32 }}>
          <div style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.12em', color: t3, marginBottom: 10 }}>
            {updated}
          </div>
          <h1 style={{ fontFamily: displayFont.style.fontFamily, fontWeight: 800, fontSize: 30, color: t1, letterSpacing: '-.02em', lineHeight: 1.15 }}>
            {title}
          </h1>
        </div>

        {intro}
        {children}

        <div style={{ marginTop: 48, paddingTop: 24, borderTop: `1px solid ${line}`, display: 'flex', gap: 18, flexWrap: 'wrap' }}>
          {[
            { href: '/offer', l: 'Оферта' },
            { href: '/terms', l: 'Условия использования' },
            { href: '/privacy', l: 'Конфиденциальность' },
            { href: '/cookies', l: 'Cookie и хранилище' },
          ].map(x => (
            <Link key={x.href} href={x.href} style={{ fontFamily: mono, fontSize: 10, letterSpacing: '.08em', color: t3, textDecoration: 'none', textTransform: 'uppercase' }}>
              {x.l}
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
