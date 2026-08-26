'use client'
import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'

const bg0 = '#0A0A0C'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const red = '#E5534B'
const grn = '#3FB950'
const gold = '#C8A256'
const sans = "'Manrope', sans-serif"
const serif = "'Fraunces', serif"
const mono = "'Space Mono', monospace"

const CSS = `
@import url('https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300..900;1,9..144,300..900&family=Manrope:wght@300;400;500;600;700&family=Space+Mono:wght@400;700&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{background:#0A0A0C;height:100%;-webkit-font-smoothing:antialiased}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.up{animation:fadeUp .5s cubic-bezier(.22,.68,0,1.1) both}
.btn{transition:all .18s;cursor:pointer}
.btn:hover{opacity:.85;transform:translateY(-1px)}
.btn:active{transform:scale(.97)}
input[type=password]{
  font-family:'Manrope',sans-serif;font-size:15px;
  color:#F2EFE9;caret-color:#F2EFE9;
  background:rgba(255,255,255,.06);
  border:1px solid rgba(255,255,255,.14);
  border-radius:8px;padding:13px 16px;width:100%;
  outline:none;transition:border-color .2s;letter-spacing:-.01em;
}
input:focus{border-color:rgba(255,255,255,.35)}
input::placeholder{color:rgba(242,239,233,.25)}
`

export default function ResetPasswordPage() {
  const [ready, setReady] = useState(false)
  const [validLink, setValidLink] = useState(false)
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [done, setDone] = useState(false)

  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)

    const { data: { subscription } } = supabase.auth.onAuthStateChange((event) => {
      if (event === 'PASSWORD_RECOVERY') {
        setValidLink(true)
        setReady(true)
      }
    })

    // если ссылка уже была обработана до монтирования — сессия уже есть
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) setValidLink(true)
      setReady(true)
    })

    return () => { s.remove(); subscription.unsubscribe() }
  }, [])

  const submit = async () => {
    setError('')
    if (password.length < 8) { setError('Пароль должен быть не короче 8 символов'); return }
    if (password !== confirm) { setError('Пароли не совпадают'); return }
    setLoading(true)
    const { error } = await supabase.auth.updateUser({ password })
    setLoading(false)
    if (error) { setError(error.message); return }
    setDone(true)
    setTimeout(() => { window.location.href = '/dashboard' }, 1800)
  }

  return (
    <div style={{ minHeight:'100vh', background:bg0, display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center', padding:'40px 20px', fontFamily:sans }}>
      <div style={{ width:'100%', maxWidth:400 }} className="up">
        <div style={{ textAlign:'center', marginBottom:32 }}>
          <div style={{ fontFamily:serif, fontStyle:'normal', fontWeight:800, fontSize:28,
            color:t1, letterSpacing:'-.02em' }}>Mastersly</div>
        </div>

        <div style={{ background:'#111115', border:`1px solid ${line}`, borderRadius:12,
          padding:'28px', textAlign: done || !ready || !validLink ? 'center' : 'left' }}>

          {!ready ? (
            <div style={{ fontFamily:mono, fontSize:11, color:t3 }}>ЗАГРУЗКА...</div>
          ) : done ? (
            <>
              <div style={{ width:48, height:48, borderRadius:'50%', background:`${grn}15`,
                border:`1.5px solid ${grn}40`, display:'flex', alignItems:'center',
                justifyContent:'center', margin:'0 auto 14px' }}>
                <span style={{ color:grn, fontSize:20 }}>✓</span>
              </div>
              <div style={{ fontFamily:serif, fontWeight:700, fontSize:19, color:t1, marginBottom:6 }}>
                Пароль обновлён
              </div>
              <div style={{ fontFamily:sans, fontSize:13, color:t2 }}>Переходим в личный кабинет...</div>
            </>
          ) : !validLink ? (
            <>
              <div style={{ fontFamily:serif, fontWeight:700, fontSize:19, color:t1, marginBottom:8 }}>
                Ссылка недействительна
              </div>
              <p style={{ fontFamily:sans, fontSize:13, color:t2, lineHeight:1.6, marginBottom:16 }}>
                Она уже использована или устарела. Запроси новую на странице входа.
              </p>
              <a href="/login" style={{ fontFamily:sans, fontSize:13, color:gold, textDecoration:'underline' }}>
                На страницу входа →
              </a>
            </>
          ) : (
            <>
              <div style={{ fontFamily:mono, fontSize:9, fontWeight:700, color:gold,
                letterSpacing:'0.1em', marginBottom:8 }}>НОВЫЙ ПАРОЛЬ</div>
              <div style={{ fontFamily:serif, fontWeight:700, fontSize:20, color:t1, marginBottom:18 }}>
                Придумай новый пароль
              </div>
              <div style={{ display:'flex', flexDirection:'column', gap:12 }}>
                <input type="password" placeholder="Новый пароль (мин. 8 символов)"
                  value={password} onChange={e=>setPassword(e.target.value)}
                  onKeyDown={e=>e.key==='Enter' && submit()}/>
                <input type="password" placeholder="Повтори пароль"
                  value={confirm} onChange={e=>setConfirm(e.target.value)}
                  onKeyDown={e=>e.key==='Enter' && submit()}/>
                {error && <p style={{ fontFamily:sans, fontSize:12, color:red }}>{error}</p>}
                <button onClick={submit} disabled={loading} className="btn" style={{
                  width:'100%', padding:'13px', borderRadius:8, border:'none',
                  background:t1, color:bg0, fontFamily:sans, fontSize:14, fontWeight:500,
                  cursor:loading?'not-allowed':'pointer' }}>
                  {loading ? 'Сохраняем...' : 'Сохранить пароль'}
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
