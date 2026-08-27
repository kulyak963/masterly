'use client'
import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import { useTurnstile } from '../../lib/useTurnstile'
import { bg0, bg1, line, t1, t2, t3, grn, gold, red, sans, serif, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'

const CSS = `
@import url('https://fonts.googleapis.com/css2?family=Overpass:ital,wght@0,400;0,500;0,600;0,700;0,800;0,900;1,400;1,500;1,600;1,700&family=Overpass+Mono:wght@400;500;600;700&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{background:${bg0};height:100%;-webkit-font-smoothing:antialiased}
@keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
.up{animation:fadeUp .5s cubic-bezier(.22,.68,0,1.1) both}
.btn{transition:all .18s;cursor:pointer}
.btn:hover{opacity:.85;transform:translateY(-1px)}
.btn:active{transform:scale(.97)}
input[type=email],input[type=password]{
  font-family:${sans};font-size:15px;
  color:${t1};caret-color:${t1};
  background:rgba(255,255,255,.06);
  border:1px solid rgba(255,255,255,.14);
  border-radius:4px;padding:13px 16px;width:100%;
  outline:none;transition:border-color .2s;letter-spacing:-.01em;
}
input:focus{border-color:rgba(255,255,255,.35)}
input::placeholder{color:rgba(236,234,226,.25)}
`

type PwMode = 'signin'|'signup'|'forgot'

export default function LoginPage() {
  const [tab, setTab] = useState<'magic'|'password'>('magic')
  const [pwMode, setPwMode] = useState<PwMode>('signin')

  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm] = useState('')

  const [sent, setSent] = useState(false)
  const [signupPending, setSignupPending] = useState(false)
  const [otpCode, setOtpCode] = useState('')
  const [otpVerifying, setOtpVerifying] = useState(false)
  const [otpError, setOtpError] = useState('')
  const [resetSent, setResetSent] = useState(false)

  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')

  const turnstile = useTurnstile()

  useEffect(() => {
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)

    // если уже залогинен — редирект на дашборд
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) { window.location.href = '/dashboard'; return }
      // Восстанавливаем экран «подтверди почту» после обновления страницы —
      // без этого рефреш терял signupPending/password (обычный useState).
      const pending = sessionStorage.getItem('masterly_pending_signup')
      if (pending) {
        try {
          const { email: pe, password: pw } = JSON.parse(pending)
          if (pe && pw) { setEmail(pe); setPassword(pw); setTab('password'); setPwMode('signup'); setSignupPending(true) }
        } catch {}
      }
    })

    return () => s.remove()
  }, [])

  // Пока ждём подтверждения почты — пробуем войти паролем каждые 4с. Пароль
  // уже известен этому устройству, а подтверждают обычно на телефоне — вход
  // происходит сам там, где начали регистрацию, без лишних кликов.
  useEffect(()=>{
    if (!signupPending) return
    const em = email.trim()
    if (!em || !password) return
    let cancelled = false
    const tryLogin = async () => {
      const { data } = await supabase.auth.signInWithPassword({ email: em, password })
      if (!cancelled && data.session) {
        sessionStorage.removeItem('masterly_pending_signup')
        window.location.href = '/dashboard'
      }
    }
    const id = setInterval(tryLogin, 4000)
    return () => { cancelled = true; clearInterval(id) }
  },[signupPending])

  const captchaOpt = () => turnstile.enabled ? { captchaToken: turnstile.token || undefined } : {}

  const loginWithGoogle = async () => {
    setLoading(true)
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${window.location.origin}/dashboard` },
    })
    if (error) { setError(error.message); setLoading(false) }
  }

  const loginWithEmail = async () => {
    if (!email.trim()) return
    if (turnstile.enabled && !turnstile.token) { setError('Подтверди, что ты не робот'); return }
    setLoading(true)
    setError('')
    const { error } = await supabase.auth.signInWithOtp({
      email: email.trim(),
      options: { emailRedirectTo: `${window.location.origin}/dashboard`, ...captchaOpt() },
    })
    turnstile.reset()
    if (error) { setError(error.message); setLoading(false) }
    else { setSent(true); setLoading(false) }
  }

  // Ссылку часто открывают на телефоне, а продолжить хотят на компьютере —
  // ссылка «привязывается» к тому браузеру, где её открыли, поэтому вместо
  // неё можно ввести 6-значный код из того же письма прямо здесь.
  const verifyOtpCode = async () => {
    const em = email.trim()
    const token = otpCode.trim()
    if (!em || !token || otpVerifying) return
    setOtpVerifying(true)
    setOtpError('')
    const { data, error } = await supabase.auth.verifyOtp({ email: em, token, type: 'email' })
    if (error) { setOtpError('Код не подошёл — проверь письмо или запроси ссылку заново'); setOtpVerifying(false); return }
    if (data.session) window.location.href = '/dashboard'
    else setOtpVerifying(false)
  }

  const signInWithPassword = async () => {
    if (!email.trim() || !password) return
    if (turnstile.enabled && !turnstile.token) { setError('Подтверди, что ты не робот'); return }
    setLoading(true)
    setError('')
    const { error } = await supabase.auth.signInWithPassword({
      email: email.trim(), password, options: captchaOpt(),
    })
    turnstile.reset()
    if (error) { setError(error.message === 'Invalid login credentials' ? 'Неверный email или пароль' : error.message); setLoading(false); return }
    window.location.href = '/dashboard'
  }

  const signUpWithPassword = async () => {
    if (!email.trim() || !password) return
    if (password.length < 8) { setError('Пароль должен быть не короче 8 символов'); return }
    if (password !== confirm) { setError('Пароли не совпадают'); return }
    if (turnstile.enabled && !turnstile.token) { setError('Подтверди, что ты не робот'); return }
    setLoading(true)
    setError('')
    const { data, error } = await supabase.auth.signUp({
      email: email.trim(), password,
      options: { emailRedirectTo: `${window.location.origin}/dashboard`, ...captchaOpt() },
    })
    turnstile.reset()
    if (error) { setError(error.message); setLoading(false); return }
    setLoading(false)
    if (data.session) window.location.href = '/dashboard'
    else {
      // Переживает обновление страницы — см. восстановление в useEffect выше.
      sessionStorage.setItem('masterly_pending_signup', JSON.stringify({ email: email.trim(), password }))
      setSignupPending(true)
    }
  }

  const sendResetLink = async () => {
    if (!email.trim()) return
    if (turnstile.enabled && !turnstile.token) { setError('Подтверди, что ты не робот'); return }
    setLoading(true)
    setError('')
    const { error } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo: `${window.location.origin}/reset-password`,
      ...captchaOpt(),
    })
    turnstile.reset()
    if (error) { setError(error.message); setLoading(false); return }
    setResetSent(true)
    setLoading(false)
  }

  const showTurnstile = turnstile.enabled && (tab === 'password' || tab === 'magic') && !sent && !signupPending && !resetSent

  const card = (children: React.ReactNode) => (
    <div style={{ background:bg1, border:`1px solid ${line}`,
      borderRadius:4, overflow:'hidden' }}>
      {children}
    </div>
  )

  return (
    <div style={{ minHeight:'100vh', background:bg0,
      display:'flex', flexDirection:'column',
      alignItems:'center', justifyContent:'center',
      padding:'40px 20px', position:'relative', overflow:'hidden',
      fontFamily:sans,
    }}>
      <div style={{ width:'100%', maxWidth:400, zIndex:1 }} className="up">

        <div style={{ textAlign:'center', marginBottom:40 }}>
          <div style={{ fontFamily:displayFont.style.fontFamily, fontWeight:800, fontSize:32,
            color:t1, letterSpacing:'-.02em', marginBottom:8 }}>
            MASTERSLY
          </div>
          <p style={{ fontFamily:sans, fontSize:14, color:t2,
            fontWeight:400, lineHeight:1.6 }}>
            Персональный план поступления<br/>в европейскую магистратуру
          </p>
        </div>

        {sent ? card(
          <div style={{ padding:'36px 28px', textAlign:'center' }}>
            <div style={{ width:52, height:52, borderRadius:'50%',
              background:`${grn}15`, border:`1.5px solid ${grn}40`,
              display:'flex', alignItems:'center', justifyContent:'center',
              margin:'0 auto 16px' }}>
              <span style={{ fontSize:20 }}>✉️</span>
            </div>
            <h2 style={{ fontFamily:serif, fontStyle:'normal', fontSize:24,
              color:t1, fontWeight:700, marginBottom:8 }}>
              Проверь почту
            </h2>
            <p style={{ fontFamily:sans, fontSize:13, color:t2,
              lineHeight:1.65, fontWeight:300, marginBottom:16 }}>
              Отправили ссылку для входа на<br/>
              <strong style={{ color:t1 }}>{email}</strong>
            </p>
            <p style={{ fontFamily:sans, fontSize:12, color:t2, lineHeight:1.6, marginBottom:12 }}>
              Письмо открыто на телефоне? Введи код из него здесь:
            </p>
            <div style={{ display:'flex', gap:8 }}>
              <input type="text" inputMode="numeric" maxLength={6} placeholder="Код из письма"
                value={otpCode} onChange={e=>{ setOtpCode(e.target.value.replace(/\D/g,'')); setOtpError('') }}
                onKeyDown={e=>{ if (e.key==='Enter') verifyOtpCode() }}
                style={{ flex:1, textAlign:'center', letterSpacing:'0.3em', fontFamily:mono }}/>
              <button onClick={verifyOtpCode} disabled={otpCode.length<6||otpVerifying}
                style={{ padding:'0 18px', borderRadius:8, border:'none',
                background:otpCode.length>=6?grn:'rgba(255,255,255,.06)',
                color:otpCode.length>=6?bg0:t3, fontFamily:sans, fontSize:13, fontWeight:600,
                cursor:otpCode.length>=6&&!otpVerifying?'pointer':'not-allowed' }}>
                {otpVerifying?'...':'OK'}
              </button>
            </div>
            {otpError && <p style={{ fontFamily:sans, fontSize:11, color:red, marginTop:8 }}>{otpError}</p>}
            <p style={{ fontFamily:mono, fontSize:10, color:t3, letterSpacing:'0.08em', marginTop:16 }}>
              ССЫЛКА ДЕЙСТВУЕТ 24 ЧАСА
            </p>
            <button onClick={() => { setSent(false); setOtpCode(''); setOtpError('') }} style={{ marginTop:20, background:'none',
              border:'none', fontFamily:sans, fontSize:13, color:t2, cursor:'pointer',
              textDecoration:'underline' }}>
              Назад
            </button>
          </div>
        ) : signupPending ? card(
          <div style={{ padding:'36px 28px', textAlign:'center' }}>
            <div style={{ width:52, height:52, borderRadius:'50%',
              background:`${grn}15`, border:`1.5px solid ${grn}40`,
              display:'flex', alignItems:'center', justifyContent:'center',
              margin:'0 auto 16px' }}>
              <span style={{ fontSize:20 }}>✉️</span>
            </div>
            <h2 style={{ fontFamily:serif, fontStyle:'normal', fontSize:24,
              color:t1, fontWeight:700, marginBottom:8 }}>
              Подтверди почту
            </h2>
            <p style={{ fontFamily:sans, fontSize:13, color:t2,
              lineHeight:1.65, fontWeight:300 }}>
              Отправили письмо с подтверждением на<br/>
              <strong style={{ color:t1 }}>{email}</strong><br/>
              Перейди по ссылке хоть с телефона — эта вкладка сама войдёт, когда подтвердишь. Не закрывай её.
            </p>
            <button onClick={() => { sessionStorage.removeItem('masterly_pending_signup'); setSignupPending(false); setPwMode('signin') }} style={{
              marginTop:20, background:'none', border:'none', fontFamily:sans, fontSize:13,
              color:t2, cursor:'pointer', textDecoration:'underline' }}>
              Назад
            </button>
          </div>
        ) : resetSent ? card(
          <div style={{ padding:'36px 28px', textAlign:'center' }}>
            <div style={{ width:52, height:52, borderRadius:'50%',
              background:`${grn}15`, border:`1.5px solid ${grn}40`,
              display:'flex', alignItems:'center', justifyContent:'center',
              margin:'0 auto 16px' }}>
              <span style={{ fontSize:20 }}>✉️</span>
            </div>
            <h2 style={{ fontFamily:serif, fontStyle:'normal', fontSize:24,
              color:t1, fontWeight:700, marginBottom:8 }}>
              Проверь почту
            </h2>
            <p style={{ fontFamily:sans, fontSize:13, color:t2,
              lineHeight:1.65, fontWeight:300 }}>
              Прислали ссылку для сброса пароля на<br/><strong style={{ color:t1 }}>{email}</strong>
            </p>
            <button onClick={() => { setResetSent(false); setPwMode('signin') }} style={{
              marginTop:20, background:'none', border:'none', fontFamily:sans, fontSize:13,
              color:t2, cursor:'pointer', textDecoration:'underline' }}>
              Назад
            </button>
          </div>
        ) : card(
          <>
            <div style={{ padding:'24px 28px 20px', borderBottom:`1px solid ${line}` }}>
              <div style={{ fontFamily:mono, fontSize:9, fontWeight:700, color:gold,
                letterSpacing:'0.1em', marginBottom:10 }}>ВОЙТИ ИЛИ ЗАРЕГИСТРИРОВАТЬСЯ</div>
              <h2 style={{ fontFamily:serif, fontStyle:'normal', fontSize:24,
                color:t1, fontWeight:700, letterSpacing:'-.02em' }}>
                Добро пожаловать
              </h2>
            </div>

            <div style={{ padding:'24px 28px', display:'flex', flexDirection:'column', gap:12 }}>

              <button onClick={loginWithGoogle} disabled={loading} className="btn"
                style={{ width:'100%', padding:'13px 16px', borderRadius:8, border:`1px solid ${line}`,
                  background:'rgba(255,255,255,.05)', display:'flex', alignItems:'center',
                  justifyContent:'center', gap:10, fontFamily:sans, fontSize:14, fontWeight:500,
                  color:t1, letterSpacing:'-.01em', cursor:'pointer' }}>
                <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
                  <path d="M17.64 9.205c0-.639-.057-1.252-.164-1.841H9v3.481h4.844a4.14 4.14 0 01-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.615z" fill="#4285F4"/>
                  <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 009 18z" fill="#34A853"/>
                  <path d="M3.964 10.71A5.41 5.41 0 013.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 000 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
                  <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 00.957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
                </svg>
                Войти через Google
              </button>

              <div style={{ display:'flex', alignItems:'center', gap:12 }}>
                <div style={{ flex:1, height:1, background:line }}/>
                <span style={{ fontFamily:mono, fontSize:9, color:t3, letterSpacing:'0.1em' }}>ИЛИ</span>
                <div style={{ flex:1, height:1, background:line }}/>
              </div>

              {/* переключатель метода */}
              <div style={{ display:'flex', gap:4, padding:4, borderRadius:8,
                background:'rgba(255,255,255,.04)', border:`1px solid ${line}` }}>
                {[['magic','Ссылка на почту'],['password','Пароль']].map(([v,l])=>(
                  <button key={v} onClick={()=>{ setTab(v as any); setError('') }} style={{
                    flex:1, padding:'8px', borderRadius:6, border:'none',
                    background: tab===v ? 'rgba(255,255,255,.08)' : 'transparent',
                    color: tab===v ? t1 : t3, fontFamily:sans, fontSize:12,
                    fontWeight: tab===v ? 500 : 400, cursor:'pointer', transition:'all .15s' }}>
                    {l}
                  </button>
                ))}
              </div>

              <input type="email" placeholder="твой@email.com" value={email}
                onChange={e => setEmail(e.target.value)}
                onKeyDown={e => e.key === 'Enter' && (tab==='magic' ? loginWithEmail() : pwMode==='signin' ? signInWithPassword() : pwMode==='signup' ? signUpWithPassword() : sendResetLink())}/>

              {tab === 'magic' ? (
                <button onClick={loginWithEmail} disabled={loading || !email.trim()} className="btn"
                  style={{ width:'100%', padding:'13px', borderRadius:8, border:'none',
                    background: email.trim() ? t1 : 'rgba(255,255,255,.06)',
                    color: email.trim() ? bg0 : t3, fontFamily:sans, fontSize:14, fontWeight:500,
                    letterSpacing:'-.01em', cursor: email.trim() ? 'pointer' : 'not-allowed' }}>
                  {loading ? 'Отправляем...' : 'Отправить ссылку для входа'}
                </button>
              ) : (
                <>
                  {pwMode !== 'forgot' && (
                    <input type="password" placeholder="Пароль" value={password}
                      onChange={e=>setPassword(e.target.value)}
                      onKeyDown={e => e.key === 'Enter' && (pwMode==='signin' ? signInWithPassword() : signUpWithPassword())}/>
                  )}
                  {pwMode === 'signup' && (
                    <input type="password" placeholder="Повтори пароль" value={confirm}
                      onChange={e=>setConfirm(e.target.value)}
                      onKeyDown={e => e.key === 'Enter' && signUpWithPassword()}/>
                  )}

                  {pwMode === 'signin' && (
                    <button onClick={signInWithPassword} disabled={loading || !email.trim() || !password} className="btn"
                      style={{ width:'100%', padding:'13px', borderRadius:8, border:'none',
                        background: email.trim()&&password ? t1 : 'rgba(255,255,255,.06)',
                        color: email.trim()&&password ? bg0 : t3, fontFamily:sans, fontSize:14,
                        fontWeight:500, cursor: email.trim()&&password ? 'pointer' : 'not-allowed' }}>
                      {loading ? 'Входим...' : 'Войти'}
                    </button>
                  )}
                  {pwMode === 'signup' && (
                    <button onClick={signUpWithPassword} disabled={loading || !email.trim() || !password || !confirm} className="btn"
                      style={{ width:'100%', padding:'13px', borderRadius:8, border:'none',
                        background: email.trim()&&password&&confirm ? t1 : 'rgba(255,255,255,.06)',
                        color: email.trim()&&password&&confirm ? bg0 : t3, fontFamily:sans, fontSize:14,
                        fontWeight:500, cursor: email.trim()&&password&&confirm ? 'pointer' : 'not-allowed' }}>
                      {loading ? 'Создаём...' : 'Зарегистрироваться'}
                    </button>
                  )}
                  {pwMode === 'forgot' && (
                    <button onClick={sendResetLink} disabled={loading || !email.trim()} className="btn"
                      style={{ width:'100%', padding:'13px', borderRadius:8, border:'none',
                        background: email.trim() ? t1 : 'rgba(255,255,255,.06)',
                        color: email.trim() ? bg0 : t3, fontFamily:sans, fontSize:14,
                        fontWeight:500, cursor: email.trim() ? 'pointer' : 'not-allowed' }}>
                      {loading ? 'Отправляем...' : 'Прислать ссылку для сброса'}
                    </button>
                  )}

                  <div style={{ display:'flex', justifyContent:'space-between', fontFamily:sans, fontSize:12 }}>
                    {pwMode === 'signin' ? (
                      <>
                        <button onClick={()=>{setPwMode('signup');setError('')}} style={{ background:'none', border:'none', color:t2, cursor:'pointer', textDecoration:'underline' }}>
                          Нет аккаунта? Регистрация
                        </button>
                        <button onClick={()=>{setPwMode('forgot');setError('')}} style={{ background:'none', border:'none', color:t2, cursor:'pointer', textDecoration:'underline' }}>
                          Забыли пароль?
                        </button>
                      </>
                    ) : (
                      <button onClick={()=>{setPwMode('signin');setError('')}} style={{ background:'none', border:'none', color:t2, cursor:'pointer', textDecoration:'underline' }}>
                        ← Уже есть аккаунт
                      </button>
                    )}
                  </div>
                </>
              )}

              {showTurnstile && <div ref={turnstile.containerRef} style={{ margin:'4px auto 0' }}/>}

              {error && (
                <p style={{ fontFamily:sans, fontSize:12, color:red, textAlign:'center' }}>{error}</p>
              )}

              <p style={{ fontFamily:sans, fontSize:12, color:t3, textAlign:'center', lineHeight:1.6 }}>
                Нажимая кнопку, ты соглашаешься с{' '}
                <a href="/privacy" style={{color:t2,textDecoration:'underline'}}>обработкой данных</a>
                {' '}и{' '}
                <a href="/terms" style={{color:t2,textDecoration:'underline'}}>условиями использования</a>
              </p>
            </div>
          </>
        )}
      </div>
    </div>
  )
}
