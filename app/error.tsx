'use client'
import { useEffect } from 'react'

const bg0 = '#0A0A0C'
const bg1 = '#111115'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const red = '#E5534B'
const gold = '#C8A256'
const sans = "'Manrope', sans-serif"
const serif = "'Fraunces', serif"
const mono = "'Space Mono', monospace"

export default function Error({ error, reset }: { error: Error & { digest?: string }, reset: () => void }) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <div style={{ minHeight:'100vh', background:bg0, display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center', padding:'40px 20px', fontFamily:sans }}>
      <div style={{ textAlign:'center', maxWidth:420 }}>
        <div style={{ width:56, height:56, borderRadius:'50%', background:`${red}15`,
          border:`1.5px solid ${red}40`, display:'flex', alignItems:'center',
          justifyContent:'center', margin:'0 auto 20px' }}>
          <span style={{ color:red, fontSize:22 }}>⚠</span>
        </div>

        <div style={{ fontFamily:mono, fontSize:10, fontWeight:700, color:red,
          letterSpacing:'0.14em', marginBottom:14 }}>ЧТО-ТО СЛОМАЛОСЬ</div>

        <h1 style={{ fontFamily:serif, fontStyle:'normal', fontWeight:700, fontSize:24,
          color:t1, letterSpacing:'-.01em', marginBottom:10 }}>
          Не получилось загрузить страницу
        </h1>

        <p style={{ fontFamily:sans, fontSize:14, color:t2, lineHeight:1.65,
          fontWeight:300, marginBottom:28 }}>
          Это ошибка на нашей стороне, не потерялись ни твоя анкета, ни программы.
          Попробуй ещё раз — обычно помогает.
        </p>

        <div style={{ display:'flex', gap:10, justifyContent:'center', flexWrap:'wrap', marginBottom:20 }}>
          <button onClick={() => reset()} style={{ padding:'13px 24px', borderRadius:100,
            border:'none', background:t1, color:bg0, fontFamily:sans, fontSize:14,
            fontWeight:600, letterSpacing:'-.01em', cursor:'pointer' }}>
            Попробовать снова
          </button>
          <a href="/dashboard" style={{ padding:'13px 24px', borderRadius:100,
            border:`1px solid ${line}`, color:t1, fontFamily:sans, fontSize:14,
            fontWeight:500, textDecoration:'none', letterSpacing:'-.01em' }}>
            В личный кабинет
          </a>
        </div>

        {error.digest && (
          <div style={{ fontFamily:mono, fontSize:9, color:t3, letterSpacing:'0.06em' }}>
            КОД ОШИБКИ: {error.digest}
          </div>
        )}
      </div>
    </div>
  )
}
