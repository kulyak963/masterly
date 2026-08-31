'use client'
import Link from 'next/link'
import { useEffect } from 'react'
import { bg0, line, t1, t2, t3, gold, sans, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'

const CSS = `
*,*::before,*::after{box-sizing:border-box}
html,body{background:${bg0};-webkit-font-smoothing:antialiased}
`

function Section({n, title, children}: {n:string, title:string, children:React.ReactNode}) {
  return (
    <div style={{marginBottom:32}}>
      <div style={{display:'flex',alignItems:'baseline',gap:12,marginBottom:10}}>
        <span style={{fontFamily:mono,fontSize:11,color:t3}}>{n}</span>
        <h2 style={{fontFamily:sans,fontWeight:700,fontSize:19,color:t1,letterSpacing:'-.01em'}}>{title}</h2>
      </div>
      <div style={{fontFamily:sans,fontSize:14,color:t2,lineHeight:1.75,fontWeight:300}}>{children}</div>
    </div>
  )
}

export default function PrivacyPage() {
  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)
    return () => { s.remove() }
  }, [])

  return (
    <div style={{minHeight:'100vh', background:bg0, fontFamily:sans, color:t1, padding:'0 20px 80px'}}>
      <div style={{maxWidth:640, margin:'0 auto', paddingTop:48}}>
        <Link href="/" style={{fontFamily:sans, fontWeight:700, fontSize:18, color:t1, textDecoration:'none'}}>
          ← Mastersly
        </Link>

        <div style={{marginTop:32, marginBottom:40}}>
          <div style={{fontFamily:mono, fontSize:10, letterSpacing:'0.12em', color:t3, marginBottom:10}}>
            ОБНОВЛЕНО 24 АВГУСТА 2026
          </div>
          <h1 style={{fontFamily:displayFont.style.fontFamily, fontWeight:800, fontSize:30, color:t1, letterSpacing:'-.02em'}}>
            Политика конфиденциальности
          </h1>
        </div>

        <div style={{padding:'14px 18px', marginBottom:36, borderRadius:8,
          background:`${gold}14`, border:`1px solid ${gold}4D`}}>
          <span style={{fontFamily:sans, fontSize:13, color:gold, lineHeight:1.6}}>
            Это честное и понятное описание того, как устроен сервис — но не юридический
            документ, составленный юристом. Если вы хотите использовать Mastersly в
            коммерческих масштабах, до реального запуска стоит показать эту страницу юристу,
            особенно из-за GDPR (сервис работает с данными о поступлении в вузы ЕС).
          </span>
        </div>

        <Section n="01" title="Что мы собираем">
          Имя, email, страну и вуз обучения, направление, страны для поступления,
          сроки, бюджет, GPA, языковой балл, опыт работы — всё, что вы указываете при
          прохождении опроса. Это сохраняется в вашем профиле в Supabase (сервис баз
          данных, на котором построен Mastersly).
        </Section>

        <Section n="02" title="Зачем это нужно">
          Чтобы подобрать программы под ваш профиль и построить план поступления —
          без этих данных сервис не сможет ничего порекомендовать. Данные не
          продаются и не передаются рекламным сетям.
        </Section>

        <Section n="03" title="Где хранятся данные">
          В базе данных Supabase. Вход через Google OAuth или ссылку на email
          обрабатывается тем же сервисом. Пароли самого Mastersly не существует —
          мы никогда их не видим и не храним.
        </Section>

        <Section n="04" title="Роль искусственного интеллекта">
          Часть контента на сайте (описания программ, дедлайны, стоимость,
          персональный анализ) сгенерирована языковой моделью (Claude от Anthropic),
          а не проверена вручную сотрудником. Это может содержать ошибки —
          рекомендуем перепроверять важные детали (особенно даты) на официальном
          сайте вуза перед подачей документов. Программы, где это уже сделано,
          помечены значком «Проверено».
        </Section>

        <Section n="05" title="Cookies и локальное хранилище">
          Черновик анкеты до входа хранится в localStorage вашего браузера — это
          происходит только на вашем устройстве и не передаётся на сервер, пока вы
          не войдёте.
        </Section>

        <Section n="06" title="Удаление данных">
          Написать на почту, указанную в разделе «Контакты» ниже, с просьбой удалить
          профиль — мы удалим запись из базы данных.
        </Section>

        <Section n="07" title="Контакты">
          По вопросам о данных — <a href="mailto:ddenis846@yahoo.com" style={{color:t1}}>ddenis846@yahoo.com</a>.
        </Section>

        <div style={{marginTop:48, paddingTop:24, borderTop:`1px solid ${line}`}}>
          <Link href="/terms" style={{fontFamily:sans, fontSize:13, color:t2, textDecoration:'underline'}}>
            Условия использования →
          </Link>
        </div>
      </div>
    </div>
  )
}
