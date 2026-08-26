'use client'
import Link from 'next/link'
import { useEffect } from 'react'

const bg0 = '#0A0A0C'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#9A968E'
const t3 = '#5A564F'
const sans = "'Manrope', sans-serif"
const serif = "'Fraunces', serif"
const mono = "'Space Mono', monospace"

const CSS = `
*,*::before,*::after{box-sizing:border-box}
html,body{background:#0A0A0C;-webkit-font-smoothing:antialiased}
`

function Section({n, title, children}: {n:string, title:string, children:React.ReactNode}) {
  return (
    <div style={{marginBottom:32}}>
      <div style={{display:'flex',alignItems:'baseline',gap:12,marginBottom:10}}>
        <span style={{fontFamily:mono,fontSize:11,color:t3}}>{n}</span>
        <h2 style={{fontFamily:serif,fontStyle:'normal',fontWeight:700,fontSize:19,color:t1,letterSpacing:'-.01em'}}>{title}</h2>
      </div>
      <div style={{fontFamily:sans,fontSize:14,color:t2,lineHeight:1.75,fontWeight:300}}>{children}</div>
    </div>
  )
}

export default function TermsPage() {
  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)
    return () => { s.remove() }
  }, [])

  return (
    <div style={{minHeight:'100vh', background:bg0, fontFamily:sans, color:t1, padding:'0 20px 80px'}}>
      <div style={{maxWidth:640, margin:'0 auto', paddingTop:48}}>
        <Link href="/" style={{fontFamily:serif, fontWeight:700, fontSize:18, color:t1, textDecoration:'none'}}>
          ← Mastersly
        </Link>

        <div style={{marginTop:32, marginBottom:40}}>
          <div style={{fontFamily:mono, fontSize:10, letterSpacing:'0.12em', color:t3, marginBottom:10}}>
            ОБНОВЛЕНО 24 АВГУСТА 2026
          </div>
          <h1 style={{fontFamily:serif, fontStyle:'normal', fontWeight:800, fontSize:32, color:t1, letterSpacing:'-.02em'}}>
            Условия использования
          </h1>
        </div>

        <div style={{padding:'14px 18px', marginBottom:36, borderRadius:8,
          background:'rgba(200,162,86,0.08)', border:'1px solid rgba(200,162,86,0.3)'}}>
          <span style={{fontFamily:sans, fontSize:13, color:'#D4A853', lineHeight:1.6}}>
            Написано понятным языком, а не юридическим — это не заменяет консультацию
            с юристом перед публичным запуском сервиса.
          </span>
        </div>

        <Section n="01" title="Что такое Mastersly">
          Персональный помощник для подготовки к поступлению в европейскую
          магистратуру: подбор программ, план действий, дедлайны и напоминания.
          Это инструмент для организации процесса — не гарантия поступления и не
          официальный источник информации о вузах.
        </Section>

        <Section n="02" title="Данные могут быть неточными">
          Часть информации о программах (дедлайны, стоимость, требования)
          сгенерирована искусственным интеллектом и не проверена человеком, если
          рядом с программой нет значка «✓ Проверено». Mastersly не несёт
          ответственности за решения, принятые только на основе этих данных —
          перед подачей документов всегда проверяйте актуальную информацию на
          официальном сайте вуза.
        </Section>

        <Section n="03" title="Оценка соответствия («примерная оценка»)">
          Проценты и категории «Амбиция / Таргет / Запасная» — это грубый расчёт по
          вашим GPA, IELTS и бюджету, а не научный прогноз поступления. Решение о
          зачислении принимает только сам вуз.
        </Section>

        <Section n="04" title="Аккаунт">
          Вход через Google или ссылку на email. Вы можете выйти из аккаунта в любой
          момент кнопкой «Выйти» в боковом меню.
        </Section>

        <Section n="05" title="Стоимость">
          Сервис бесплатен на текущем этапе. Если это изменится — условия будут
          обновлены на этой странице заранее.
        </Section>

        <Section n="06" title="Изменения условий">
          Мы можем обновлять эту страницу по мере развития сервиса. Дата в шапке
          страницы всегда показывает последнее обновление.
        </Section>

        <Section n="07" title="Контакты">
          Вопросы — <a href="mailto:ddenis846@yahoo.com" style={{color:t1}}>ddenis846@yahoo.com</a>.
        </Section>

        <div style={{marginTop:48, paddingTop:24, borderTop:`1px solid ${line}`}}>
          <Link href="/privacy" style={{fontFamily:sans, fontSize:13, color:t2, textDecoration:'underline'}}>
            Политика конфиденциальности →
          </Link>
        </div>
      </div>
    </div>
  )
}
