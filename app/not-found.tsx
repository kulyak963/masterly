import Link from 'next/link'

const bg0 = '#0A0A0C'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const gold = '#C8A256'
const sans = "'Manrope', sans-serif"
const serif = "'Fraunces', serif"
const mono = "'Space Mono', monospace"

export default function NotFound() {
  return (
    <div style={{ minHeight:'100vh', background:bg0, display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center', padding:'40px 20px', fontFamily:sans,
      position:'relative', overflow:'hidden' }}>
      <div style={{ position:'fixed', inset:0, pointerEvents:'none', zIndex:0,
        backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,
        backgroundRepeat:'repeat', backgroundSize:'128px', opacity:.6 }}/>

      <div style={{ textAlign:'center', maxWidth:420, zIndex:1 }}>
        <div style={{ fontFamily:mono, fontSize:10, fontWeight:700, color:gold,
          letterSpacing:'0.14em', marginBottom:18 }}>ОШИБКА 404</div>

        <h1 style={{ fontFamily:serif, fontStyle:'normal', fontWeight:800, fontSize:96,
          color:t1, letterSpacing:'-.04em', lineHeight:1, marginBottom:12 }}>
          404
        </h1>

        <h2 style={{ fontFamily:serif, fontStyle:'normal', fontWeight:700, fontSize:22,
          color:t1, letterSpacing:'-.01em', marginBottom:10 }}>
          Такой страницы нет
        </h2>

        <p style={{ fontFamily:sans, fontSize:14, color:t2, lineHeight:1.65,
          fontWeight:300, marginBottom:32 }}>
          Ссылка устарела, или адрес набран неточно — программы и вузы отсюда
          не пропадают, просто эта конкретная страница не существует.
        </p>

        <div style={{ display:'flex', gap:10, justifyContent:'center', flexWrap:'wrap' }}>
          <Link href="/" style={{ padding:'13px 24px', borderRadius:100, border:'none',
            background:t1, color:bg0, fontFamily:sans, fontSize:14, fontWeight:600,
            textDecoration:'none', letterSpacing:'-.01em' }}>
            На главную
          </Link>
          <Link href="/dashboard" style={{ padding:'13px 24px', borderRadius:100,
            border:`1px solid ${line}`, color:t1, fontFamily:sans, fontSize:14,
            fontWeight:500, textDecoration:'none', letterSpacing:'-.01em' }}>
            В личный кабинет
          </Link>
        </div>
      </div>
    </div>
  )
}
