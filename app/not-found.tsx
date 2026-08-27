import Link from 'next/link'
import { bg0, line, t1, t2, gold, sans, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'

export default function NotFound() {
  return (
    <div style={{ minHeight:'100vh', background:bg0, display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center', padding:'40px 20px', fontFamily:sans }}>
      <div style={{ textAlign:'center', maxWidth:420 }}>
        <div style={{ fontFamily:mono, fontSize:10, fontWeight:700, color:gold,
          letterSpacing:'0.14em', marginBottom:18 }}>ОШИБКА 404</div>

        <h1 style={{ fontFamily:displayFont.style.fontFamily, fontWeight:800, fontSize:96,
          color:t1, letterSpacing:'-.04em', lineHeight:1, marginBottom:12 }}>
          404
        </h1>

        <h2 style={{ fontFamily:sans, fontWeight:700, fontSize:20,
          color:t1, letterSpacing:'-.01em', marginBottom:10 }}>
          Такой страницы нет
        </h2>

        <p style={{ fontFamily:sans, fontSize:14, color:t2, lineHeight:1.65,
          fontWeight:400, marginBottom:32 }}>
          Ссылка устарела, или адрес набран неточно — программы и вузы отсюда
          не пропадают, просто эта конкретная страница не существует.
        </p>

        <div style={{ display:'flex', gap:10, justifyContent:'center', flexWrap:'wrap' }}>
          <Link href="/" style={{ padding:'13px 24px', borderRadius:4, border:'none',
            background:gold, color:bg0, fontFamily:sans, fontSize:14, fontWeight:700,
            textDecoration:'none', letterSpacing:'-.01em' }}>
            На главную
          </Link>
          <Link href="/dashboard" style={{ padding:'13px 24px', borderRadius:4,
            border:`1px solid ${line}`, color:t1, fontFamily:sans, fontSize:14,
            fontWeight:500, textDecoration:'none', letterSpacing:'-.01em' }}>
            В личный кабинет
          </Link>
        </div>
      </div>
    </div>
  )
}
