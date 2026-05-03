'use client'
import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'

const bg0 = '#0A0A0C'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const blue = '#6B8CFF'
const grn = '#3FB950'
const sans = "'Geist', sans-serif"
const serif = "'Instrument Serif', serif"
const mono = "'Geist Mono', monospace"

const CSS = `
@import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600&family=Geist+Mono:wght@400;500&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{background:#0A0A0C;height:100%;-webkit-font-smoothing:antialiased}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
@keyframes grain{0%,100%{transform:translate(0,0)}50%{transform:translate(-1%,.5%)}}
.up{animation:fadeUp .5s cubic-bezier(.22,.68,0,1.1) both}
.btn{transition:all .18s;cursor:pointer}
.btn:hover{opacity:.85;transform:translateY(-1px)}
.btn:active{transform:scale(.97)}
input[type=email]{
  font-family:'Geist',sans-serif;font-size:15px;
  color:#F2EFE9;caret-color:#F2EFE9;
  background:rgba(255,255,255,.04);
  border:1px solid rgba(255,255,255,.1);
  border-radius:8px;padding:13px 16px;width:100%;
  outline:none;transition:border-color .2s;letter-spacing:-.01em;
}
input:focus{border-color:rgba(255,255,255,.3)}
input::placeholder{color:rgba(242,239,233,.2)}
`

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [sent, setSent] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)

    // если уже залогинен — редирект на дашборд
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) window.location.href = '/dashboard'
    })

    return () => s.remove()
  }, [])

  const loginWithGoogle = async () => {
    setLoading(true)
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: `https://masterly-topaz.vercel.app/dashboard`,
      },
    })
    if (error) { setError(error.message); setLoading(false) }
  }

  const loginWithEmail = async () => {
    if (!email.trim()) return
    setLoading(true)
    setError('')
    const { error } = await supabase.auth.signInWithOtp({
      email: email.trim(),
      options: {
        emailRedirectTo: 'https://masterly-topaz.vercel.app/dashboard',
      },
    })
    if (error) { setError(error.message); setLoading(false) }
    else { setSent(true); setLoading(false) }
  }

  return (
    <div style={{ minHeight:'100vh', background:bg0,
      display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center',
      padding:'40px 20px', position:'relative', overflow:'hidden',
      fontFamily:sans,
    }}>
      {/* grain */}
      <div style={{ position:'fixed', inset:0, pointerEvents:'none', zIndex:0,
        backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,
        backgroundRepeat:'repeat', backgroundSize:'128px',
        animation:'grain 8s steps(1) infinite', opacity:.6 }}/>

      <div style={{ width:'100%', maxWidth:400, zIndex:1 }} className="up">

        {/* logo */}
        <div style={{ textAlign:'center', marginBottom:40 }}>
          <div style={{ fontFamily:serif, fontStyle:'italic', fontSize:32,
            color:t1, letterSpacing:'-.02em', marginBottom:8 }}>
            Masterly
          </div>
          <p style={{ fontFamily:sans, fontSize:14, color:t2,
            fontWeight:300, lineHeight:1.6 }}>
            Персональный план поступления<br/>в европейскую магистратуру
          </p>
        </div>

        {!sent ? (
          <div style={{ background:'#111115', border:`1px solid ${line}`,
            borderRadius:12, overflow:'hidden' }}>

            {/* header */}
            <div style={{ padding:'24px 28px 20px',
              borderBottom:`1px solid ${line}` }}>
              <div style={{ fontFamily:mono, fontSize:10, color:t3,
                letterSpacing:'0.1em', marginBottom:8 }}>ВОЙТИ ИЛИ ЗАРЕГИСТРИРОВАТЬСЯ</div>
              <h2 style={{ fontFamily:serif, fontStyle:'italic', fontSize:22,
                color:t1, fontWeight:400, letterSpacing:'-.015em' }}>
                Добро пожаловать
              </h2>
            </div>

            <div style={{ padding:'24px 28px', display:'flex',
              flexDirection:'column', gap:12 }}>

              {/* Google */}
              <button onClick={loginWithGoogle} disabled={loading}
                className="btn"
                style={{ width:'100%', padding:'13px 16px',
                  borderRadius:8, border:`1px solid ${line}`,
                  background:'rgba(255,255,255,.05)',
                  display:'flex', alignItems:'center',
                  justifyContent:'center', gap:10,
                  fontFamily:sans, fontSize:14, fontWeight:500,
                  color:t1, letterSpacing:'-.01em',
                  cursor:'pointer' }}>
                {/* Google icon */}
                <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                  <path d="M17.64 9.205c0-.639-.057-1.252-.164-1.841H9v3.481h4.844a4.14 4.14 0 01-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.615z" fill="#4285F4"/>
                  <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 009 18z" fill="#34A853"/>
                  <path d="M3.964 10.71A5.41 5.41 0 013.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 000 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
                  <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 00.957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
                </svg>
                Войти через Google
              </button>

              {/* divider */}
              <div style={{ display:'flex', alignItems:'center', gap:12 }}>
                <div style={{ flex:1, height:1, background:line }}/>
                <span style={{ fontFamily:mono, fontSize:9, color:t3,
                  letterSpacing:'0.1em' }}>ИЛИ</span>
                <div style={{ flex:1, height:1, background:line }}/>
              </div>

              {/* email */}
              <div>
                <input
                  type="email"
                  placeholder="твой@email.com"
                  value={email}
                  onChange={e => setEmail(e.target.value)}
                  onKeyDown={e => e.key === 'Enter' && loginWithEmail()}
                />
              </div>

              <button onClick={loginWithEmail}
                disabled={loading || !email.trim()}
                className="btn"
                style={{ width:'100%', padding:'13px',
                  borderRadius:8, border:'none',
                  background: email.trim() ? t1 : 'rgba(255,255,255,.06)',
                  color: email.trim() ? bg0 : t3,
                  fontFamily:sans, fontSize:14, fontWeight:500,
                  letterSpacing:'-.01em',
                  cursor: email.trim() ? 'pointer' : 'not-allowed' }}>
                {loading ? 'Отправляем...' : 'Отправить ссылку для входа'}
              </button>

              {error && (
                <p style={{ fontFamily:sans, fontSize:12, color:'#E5534B',
                  textAlign:'center' }}>{error}</p>
              )}

              <p style={{ fontFamily:sans, fontSize:12, color:t3,
                textAlign:'center', lineHeight:1.6 }}>
                Нажимая кнопку, ты соглашаешься с обработкой данных
              </p>
            </div>
          </div>
        ) : (
          /* sent screen */
          <div style={{ background:'#111115', border:`1px solid ${line}`,
            borderRadius:12, padding:'36px 28px', textAlign:'center' }}>
            <div style={{ width:52, height:52, borderRadius:'50%',
              background:`${grn}15`, border:`1.5px solid ${grn}40`,
              display:'flex', alignItems:'center', justifyContent:'center',
              margin:'0 auto 16px' }}>
              <span style={{ fontSize:20 }}>✉️</span>
            </div>
            <h2 style={{ fontFamily:serif, fontStyle:'italic', fontSize:22,
              color:t1, fontWeight:400, marginBottom:8 }}>
              Проверь почту
            </h2>
            <p style={{ fontFamily:sans, fontSize:13, color:t2,
              lineHeight:1.65, fontWeight:300, marginBottom:20 }}>
              Отправили ссылку для входа на<br/>
              <strong style={{ color:t1 }}>{email}</strong>
            </p>
            <p style={{ fontFamily:mono, fontSize:10, color:t3,
              letterSpacing:'0.08em' }}>
              ССЫЛКА ДЕЙСТВУЕТ 24 ЧАСА
            </p>
            <button onClick={() => setSent(false)}
              style={{ marginTop:20, background:'none', border:'none',
                fontFamily:sans, fontSize:13, color:t2, cursor:'pointer',
                textDecoration:'underline' }}>
              Ввести другой email
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
