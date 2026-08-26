'use client'
import { useEffect } from 'react'

// Срабатывает только если упал сам корневой layout — поэтому здесь свой
// <html>/<body> и никаких next/font-переменных (они приходят из layout,
// которого сейчас нет). Шрифты — с фолбэком на системные, без импорта извне.

export default function GlobalError({ error, reset }: { error: Error & { digest?: string }, reset: () => void }) {
  useEffect(() => {
    console.error(error)
  }, [error])

  return (
    <html lang="ru">
      <body style={{ margin:0, background:'#0A0A0C', minHeight:'100vh',
        display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center',
        padding:'40px 20px', fontFamily:"'Manrope','Segoe UI',sans-serif" }}>
        <div style={{ textAlign:'center', maxWidth:420 }}>
          <div style={{ width:56, height:56, borderRadius:'50%', background:'rgba(229,83,75,.15)',
            border:'1.5px solid rgba(229,83,75,.4)', display:'flex', alignItems:'center',
            justifyContent:'center', margin:'0 auto 20px' }}>
            <span style={{ color:'#E5534B', fontSize:22 }}>⚠</span>
          </div>
          <h1 style={{ fontFamily:"Georgia,'Times New Roman',serif", fontStyle:'italic',
            fontWeight:700, fontSize:24, color:'#F2EFE9', letterSpacing:'-.01em', marginBottom:10 }}>
            Сайт временно недоступен
          </h1>
          <p style={{ fontSize:14, color:'#7A7670', lineHeight:1.65, fontWeight:300, marginBottom:28 }}>
            Мы уже знаем о проблеме. Попробуй обновить страницу через минуту.
          </p>
          <button onClick={() => reset()} style={{ padding:'13px 24px', borderRadius:100,
            border:'none', background:'#F2EFE9', color:'#0A0A0C', fontFamily:'inherit',
            fontSize:14, fontWeight:600, letterSpacing:'-.01em', cursor:'pointer' }}>
            Попробовать снова
          </button>
          {error.digest && (
            <div style={{ marginTop:20, fontFamily:'monospace', fontSize:9,
              color:'#3D3B38', letterSpacing:'0.06em' }}>
              КОД ОШИБКИ: {error.digest}
            </div>
          )}
        </div>
      </body>
    </html>
  )
}
