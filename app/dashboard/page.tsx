 'use client'
import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'

export default function Dashboard() {
  const [profile, setProfile] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchProfile = async () => {
      const { data } = await supabase
        .from('profiles')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(1)
        .single()
      
      setProfile(data)
      setLoading(false)
    }
    fetchProfile()
  }, [])

  if(loading) return (
    <div style={{minHeight:'100vh',background:'#0A0A0C',display:'flex',alignItems:'center',justifyContent:'center'}}>
      <div style={{fontFamily:"'Geist Mono',monospace",fontSize:11,color:'#4A4845',letterSpacing:'0.1em'}}>
        ЗАГРУЗКА...
      </div>
    </div>
  )

  if(!profile) return (
    <div style={{minHeight:'100vh',background:'#0A0A0C',display:'flex',alignItems:'center',justifyContent:'center'}}>
      <div style={{textAlign:'center'}}>
        <div style={{fontFamily:"'Instrument Serif',serif",fontStyle:'italic',fontSize:24,color:'#F2EFE9',marginBottom:12}}>
          Профиль не найден
        </div>
        <a href="/" style={{fontFamily:"'Geist',sans-serif",fontSize:13,color:'#8A8780'}}>
          Пройти онбординг →
        </a>
      </div>
    </div>
  )

  const score = Math.min(97, Math.round(
    (profile.gpa>=4.5?28:profile.gpa>=4.0?20:12)+
    (profile.ielts>=6.5?22:8)+
    (profile.work==='yes'?18:profile.work==='some'?10:4)+
    10+15
  ))

  return (
    <div style={{minHeight:'100vh',background:'#0A0A0C',fontFamily:"'Geist',sans-serif",color:'#F2EFE9'}}>
      {/* header */}
      <div style={{padding:'24px 40px',borderBottom:'1px solid rgba(255,255,255,0.08)',display:'flex',justifyContent:'space-between',alignItems:'center'}}>
        <div style={{fontFamily:"'Instrument Serif',serif",fontStyle:'italic',fontSize:20,color:'#F2EFE9'}}>
          Masterly
        </div>
        <div style={{fontFamily:"'Geist Mono',monospace",fontSize:10,color:'#4A4845',letterSpacing:'0.1em'}}>
          {profile.name?.toUpperCase()}
        </div>
      </div>

      <div style={{padding:'40px'}}>
        {/* приветствие */}
        <div style={{marginBottom:32}}>
          <h1 style={{fontFamily:"'Instrument Serif',serif",fontStyle:'italic',fontSize:36,color:'#F2EFE9',fontWeight:400,letterSpacing:'-.02em',marginBottom:6}}>
            Привет, {profile.name?.split(' ')[0]}
          </h1>
          <div style={{fontFamily:"'Geist Mono',monospace",fontSize:10,color:'#4A4845',letterSpacing:'0.1em'}}>
            {profile.field} · {profile.university} · ПОСТУПЛЕНИЕ {profile.timeline?.toUpperCase()}
          </div>
        </div>

        {/* KPI */}
        <div style={{display:'grid',gridTemplateColumns:'repeat(4,1fr)',borderTop:'1px solid rgba(255,255,255,0.08)',borderLeft:'1px solid rgba(255,255,255,0.08)',marginBottom:32}}>
          {[
            {l:'ГОТОВНОСТЬ',   v:`${score}%`},
            {l:'СТРАНЫ',       v:profile.countries?.split(',').join(' · ')||'—'},
            {l:'GPA',          v:`${profile.gpa} / 5`},
            {l:'IELTS',        v:`${profile.ielts}`,warn:profile.ielts<6.5},
          ].map((s,i)=>(
            <div key={i} style={{padding:'20px 18px',borderRight:'1px solid rgba(255,255,255,0.08)',borderBottom:'1px solid rgba(255,255,255,0.08)'}}>
              <div style={{fontFamily:"'Geist Mono',monospace",fontSize:9,color:'#4A4845',letterSpacing:'0.1em',marginBottom:10}}>
                {s.l}
              </div>
              <div style={{fontFamily:"'Instrument Serif',serif",fontStyle:'italic',fontSize:28,color:s.warn?'#E5534B':'#F2EFE9',fontWeight:400,letterSpacing:'-.02em'}}>
                {s.v}
              </div>
            </div>
          ))}
        </div>

        {/* первые шаги */}
        <div style={{fontFamily:"'Geist Mono',monospace",fontSize:9,color:'#4A4845',letterSpacing:'0.1em',marginBottom:14}}>
          ПЕРВЫЕ ШАГИ
        </div>
        {[
          profile.ielts<6.5  && {t:'Записаться на IELTS Academic — это блокер №1', c:'#E5534B'},
          profile.budget==='zero' && {t:'DAAD дедлайн 14 января — начни Motivation Letter сегодня', c:'#D4A853'},
          {t:`Составить шортлист программ в ${profile.countries?.split(',').slice(0,2).join(' и ')||'выбранных странах'}`, c:'#F2EFE9'},
          {t:'Academic CV в Europass формате', c:'#8A8780'},
        ].filter(Boolean).slice(0,3).map((s:any,i:number)=>(
          <div key={i} style={{display:'flex',gap:12,alignItems:'baseline',padding:'12px 0',borderBottom:'1px solid rgba(255,255,255,0.08)'}}>
            <span style={{fontFamily:"'Geist Mono',monospace",fontSize:10,color:'#4A4845',minWidth:20}}>
              {`0${i+1}`}
            </span>
            <span style={{fontFamily:"'Geist',sans-serif",fontSize:13,color:s.c,letterSpacing:'-.01em'}}>
              {s.t}
            </span>
          </div>
        ))}
      </div>
    </div>
  )
}
