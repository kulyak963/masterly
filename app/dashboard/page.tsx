'use client'
import Roadmap from './Roadmap'
import { useState, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import Timeline from './Timeline'
import GanttTimeline from './GanttTimeline'

/* ── tokens ── */
const bg0 = '#0A0A0C'
const bg1 = '#111115'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const gold = '#C8A256'
const blue = '#6B8CFF'
const red = '#E5534B'
const grn = '#3FB950'
const purp = '#A78BFA'
const sans = "'Geist', sans-serif"
const serif = "'Instrument Serif', serif"
const mono = "'Geist Mono', monospace"

/* ── country names ── */
const CNAME: Record<string,string> = {
  de:'Германия', nl:'Нидерланды', se:'Швеция',
  ch:'Швейцария', fi:'Финляндия', fr:'Франция',
  cz:'Чехия', at:'Австрия'
}

/* ── journey phases ── */
function makePhases(profile: any) {
  const ni = profile.ielts < 6.5
  const sf = profile.budget === 'zero'
  return [
    {
      id:'ielts', n:1, color: ni ? red : grn,
      title: ni ? 'Сдать IELTS' : 'IELTS готов',
      when: 'Прямо сейчас',
      status: ni ? 'blocker' : 'done',
      why: ni
        ? `Текущий балл ${profile.ielts} — ниже минимума 6.5. Без IELTS ни один вуз не примет заявку.`
        : `IELTS ${profile.ielts} принят всеми вузами шортлиста.`,
      tasks: ni ? [
        {t:'Зарегистрироваться на IELTS Academic — British Council или IDP', urgent:true},
        {t:'Пройти бесплатный mock test на Cambridge One'},
        {t:'Готовиться по Cambridge IELTS 14–17, минимум 8 недель'},
        {t:'Целевой балл 7.0 — запас на всякий случай'},
      ] : [{t:`IELTS ${profile.ielts} — зачтено`, done:true}],
    },
    {
      id:'profile', n:2, color:purp,
      title:'Усилить профиль', when:'1–2 месяца',
      status: ni ? 'upcoming' : 'active',
      why:`GPA ${profile.gpa} — ${profile.gpa>=4.0?'выше среднего для европейских вузов':'достаточно для большинства программ'}. ${profile.work==='no'?'Добавь проекты на GitHub.':'Опыт нужно описать в academic формате.'}`,
      tasks:[
        {t:'Academic CV — формат Europass или Harvard, не LinkedIn'},
        {t:'GitHub: читаемый код, описание проектов на английском'},
        {t:'Онлайн-курс от целевого вуза на Coursera или edX'},
        {t: profile.work==='no' ? 'Найти стажировку или research project' : 'Описать опыт в academic формате'},
      ],
    },
    {
      id:'schol', n:3, color:gold,
      title:'Подать на стипендии', when:'Окт — Нояб',
      status: sf ? 'active' : 'upcoming',
      why: sf
        ? 'DAAD закрывается 14 января — раньше вузовских дедлайнов. Motivation Letter — отдельный документ, не SoP!'
        : 'Стипендии подаются параллельно с вузами. Пропустишь дедлайн — ждать год.',
      tasks:[
        {t:'Motivation Letter для DAAD — не SoP!', urgent:sf},
        {t:'Подать на DAAD через portal.daad.de — 14 января', urgent:sf},
        {t:'SI Scholarship если Швеция в шортлисте — 15 фев'},
        {t:'Проверить Erasmus Mundus и Holland Scholarship'},
      ],
    },
    {
      id:'docs', n:4, color:'#D4843A',
      title:'Собрать документы', when:'2–4 месяца',
      status:'upcoming',
      why:'SoP пишется отдельно для каждого вуза. Рекомендации нужно запросить за 2+ месяца до дедлайна.',
      tasks:[
        {t:'Запросить рекомендации у 2–3 профессоров — прямо сейчас!', urgent:true},
        {t:'Statement of Purpose для каждого вуза — упоминай конкретную лабораторию'},
        {t:'Перевести транскрипт и диплом у нотариуса'},
        {t:'Проверить требования каждого вуза по форматам файлов'},
      ],
    },
    {
      id:'apply', n:5, color:blue,
      title:'Подать заявки', when:'Декабрь — Февраль',
      status:'future',
      why:'Подавай последовательно — начни с менее приоритетных для практики. Каждая заявка: 2–4 часа.',
      tasks: (profile.countries?.split(',').filter(Boolean) || []).map((c: string) => ({
  t: `Подать заявку — ${CNAME[c] || c.toUpperCase()}`
})),
},
    {
      id:'results', n:6, color:grn,
      title:'Оффер и переезд', when:'Март — Сентябрь',
      status:'future',
      why:'Решения приходят через 6–12 недель. Сразу после оффера — виза и жильё.',
      tasks:[
        {t:'Принять оффер в течение 4–6 недель'},
        {t:'Подать на студенческую визу сразу после оффера'},
        {t:'Найти жильё: Wohnungssuche / Kamernet / Spotahome'},
        {t:`Начало учёбы — сентябрь ${profile.timeline}`},
      ],
    },
  ]
}

/* ── atoms ── */
function Bar({v=0,color=t1,h=2}:{v:number,color?:string,h?:number}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,borderRadius:1,
        animation:'barGrow .8s ease both',transformOrigin:'left'}}/>
    </div>
  )
}
function Mono({children,style={}}:{children:React.ReactNode,style?:React.CSSProperties}) {
  return <span style={{fontFamily:mono,fontSize:10,letterSpacing:'0.11em',color:t3,...style}}>{children}</span>
}
function StatusPill({status,color}:{status:string,color:string}) {
  const cfg: Record<string,{l:string,c:string}> = {
    blocker:{l:'БЛОКЕР',c:red}, done:{l:'ГОТОВО',c:grn},
    active:{l:'СЕЙЧАС',c:color}, upcoming:{l:'СКОРО',c:t2}, future:{l:'ПОЗЖЕ',c:t3},
  }
  const s = cfg[status] || {l:'—',c:t3}
  return (
    <span style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',
      padding:'3px 8px',borderRadius:3,
      background:`${s.c}18`,border:`1px solid ${s.c}40`,color:s.c,
      animation:status==='blocker'?'pulse 2s infinite':'none'}}>
      {s.l}
    </span>
  )
}

/* ── Journey component ── */
function Journey({profile,taskDone,onToggle}:{profile:any,taskDone:Record<string,boolean>,onToggle:(k:string)=>void}) {
  const phases = makePhases(profile)
  const fa = phases.find(p=>p.status==='blocker'||p.status==='active')
  const [active, setActive] = useState(fa?.id || phases[0].id)
  const totalT = phases.reduce((s,p)=>s+p.tasks.length,0)
  const doneT  = phases.reduce((s,p)=>s+p.tasks.filter((t:any,ti:number)=>t.done||!!taskDone[`${p.id}-${ti}`]).length,0)

  return (
    <div style={{padding:'32px 40px'}}>
      <div style={{marginBottom:24}}>
        <Mono style={{display:'block',marginBottom:10}}>ТВОЙ ПУТЬ К ПОСТУПЛЕНИЮ</Mono>
        <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:32,color:t1,fontWeight:400,letterSpacing:'-.02em',marginBottom:12}}>
          Journey Map
        </h1>
        <div style={{display:'flex',alignItems:'center',gap:14}}>
          <div style={{flex:1}}><Bar v={Math.round(doneT/totalT*100)||0} color={t1} h={3}/></div>
          <Mono style={{flexShrink:0,color:t2}}>{doneT} / {totalT} задач</Mono>
        </div>
      </div>

      {/* phase tabs */}
      <div style={{display:'flex',gap:0,marginBottom:24,borderBottom:`1px solid ${line}`,overflowX:'auto'}}>
        {phases.map(ph=>{
          const isA = active===ph.id
          const isFut = ph.status==='future'
          const phD = ph.tasks.filter((t:any,ti:number)=>t.done||!!taskDone[`${ph.id}-${ti}`]).length
          return (
            <button key={ph.id} onClick={()=>setActive(ph.id)} style={{
              flexShrink:0,padding:'10px 18px 12px',background:'none',border:'none',
              borderBottom:`2px solid ${isA?ph.color:'transparent'}`,
              cursor:'pointer',textAlign:'left',transition:'border-color .2s',marginBottom:-1}}>
              <div style={{display:'flex',alignItems:'center',gap:6,marginBottom:5}}>
                <Mono style={{color:isA?ph.color:t3}}>{String(ph.n).padStart(2,'0')}</Mono>
                {ph.status==='done'&&<span style={{fontFamily:mono,fontSize:9,color:grn}}>✓</span>}
                {ph.status==='blocker'&&<span style={{width:5,height:5,borderRadius:'50%',background:red,display:'inline-block',animation:'pulse 1.5s infinite'}}/>}
              </div>
              <div style={{fontFamily:sans,fontSize:12,fontWeight:isA?500:400,color:isA?t1:isFut?t3:t2,letterSpacing:'-.01em',whiteSpace:'nowrap'}}>
                {ph.title}
              </div>
              <div style={{height:2,background:'rgba(255,255,255,.06)',borderRadius:1,overflow:'hidden',marginTop:6,width:50}}>
                <div style={{height:'100%',width:`${ph.tasks.length?Math.round(phD/ph.tasks.length*100):0}%`,background:ph.color,borderRadius:1}}/>
              </div>
            </button>
          )
        })}
      </div>

      {/* active phase */}
      {phases.filter(ph=>ph.id===active).map(ph=>{
        const phD = ph.tasks.filter((t:any,ti:number)=>t.done||!!taskDone[`${ph.id}-${ti}`]).length
        const pct = ph.tasks.length?Math.round(phD/ph.tasks.length*100):0
        return (
          <div key={ph.id} style={{animation:'slideUp .35s cubic-bezier(.22,.68,0,1.1) both'}}>
            {/* hero */}
            <div style={{padding:'22px 24px',borderRadius:8,marginBottom:16,
              background:`linear-gradient(135deg,${ph.color}0A 0%,rgba(255,255,255,.02) 100%)`,
              border:`1px solid ${ph.color}28`}}>
              <div style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between',gap:20,marginBottom:14}}>
                <div>
                  <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:10}}>
                    <StatusPill status={ph.status} color={ph.color}/>
                    <Mono style={{color:t2}}>Шаг {ph.n} из {phases.length}</Mono>
                  </div>
                  <h2 style={{fontFamily:serif,fontStyle:'italic',fontSize:24,color:t1,fontWeight:400,letterSpacing:'-.015em',lineHeight:1.1,marginBottom:5}}>
                    {ph.title}
                  </h2>
                  <Mono style={{color:ph.status==='future'?t3:ph.color}}>{ph.when.toUpperCase()}</Mono>
                </div>
                <div style={{flexShrink:0,width:56,height:56,borderRadius:'50%',background:bg0,
                  border:`1.5px solid ${pct===100?grn:ph.color}30`,
                  display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center'}}>
                  <div style={{fontFamily:serif,fontStyle:'italic',fontSize:16,color:pct===100?grn:ph.color,lineHeight:1}}>
                    {pct}<span style={{fontSize:9,opacity:.4}}>%</span>
                  </div>
                </div>
              </div>
              <Bar v={pct} color={ph.color} h={3}/>
            </div>

            {/* why */}
            <div style={{padding:'14px 18px',marginBottom:14,borderRadius:6,
              background:'rgba(255,255,255,.02)',border:`1px solid ${line}`,
              borderLeft:`3px solid ${ph.color}45`}}>
              <Mono style={{display:'block',marginBottom:6,color:ph.color}}>ПОЧЕМУ ЭТО ВАЖНО</Mono>
              <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.7,fontWeight:300}}>{ph.why}</p>
            </div>

            {/* tasks */}
            <div style={{marginBottom:16}}>
              <div style={{display:'flex',justifyContent:'space-between',marginBottom:10}}>
                <Mono>ЗАДАЧИ</Mono>
                <Mono style={{color:t2}}>{phD} / {ph.tasks.length}</Mono>
              </div>
              <div style={{display:'flex',flexDirection:'column',gap:6}}>
                {ph.tasks.map((task:any,ti:number)=>{
                  const key = `${ph.id}-${ti}`
                  const done = task.done||!!taskDone[key]
                  return (
                    <div key={ti} onClick={()=>!task.done&&onToggle(key)}
                      style={{display:'flex',alignItems:'flex-start',gap:14,padding:'13px 16px',borderRadius:8,
                        background:done?'rgba(63,185,80,.05)':'rgba(255,255,255,.02)',
                        border:`1px solid ${done?`${grn}25`:task.urgent?`${red}28`:line}`,
                        borderLeft:`2px solid ${done?grn:task.urgent?red:'transparent'}`,
                        cursor:task.done?'default':'pointer',transition:'all .15s'}}>
                      <div style={{width:17,height:17,borderRadius:'50%',flexShrink:0,marginTop:1,
                        border:`1.5px solid ${done?grn:task.urgent?red:t3}`,
                        background:done?grn:'transparent',
                        display:'flex',alignItems:'center',justifyContent:'center',transition:'all .18s',
                        boxShadow:done?`0 0 7px ${grn}35`:'none'}}>
                        {done&&<span style={{color:bg0,fontSize:9,fontWeight:700}}>✓</span>}
                      </div>
                      <div style={{flex:1}}>
                        <div style={{fontFamily:sans,fontSize:13,fontWeight:500,
                          color:done?t2:t1,textDecoration:done?'line-through':'none',
                          letterSpacing:'-.01em',lineHeight:1.4,marginBottom:task.urgent&&!done?4:0}}>
                          {task.t}
                        </div>
                        {task.urgent&&!done&&(
                          <Mono style={{color:red,animation:'pulse 2s infinite'}}>СРОЧНО</Mono>
                        )}
                      </div>
                      {done&&<Mono style={{color:grn,flexShrink:0,paddingTop:2}}>ГОТОВО</Mono>}
                    </div>
                  )
                })}
              </div>
            </div>

            {/* next phase */}
            {ph.n<phases.length&&(
              <div onClick={()=>setActive(phases[ph.n].id)}
                style={{display:'flex',alignItems:'center',justifyContent:'space-between',
                  padding:'13px 16px',borderRadius:8,border:`1px solid ${line}`,
                  background:'rgba(255,255,255,.02)',cursor:'pointer',transition:'border-color .15s'}}
                onMouseEnter={e=>(e.currentTarget as HTMLElement).style.borderColor='rgba(255,255,255,.14)'}
                onMouseLeave={e=>(e.currentTarget as HTMLElement).style.borderColor=line}>
                <div>
                  <Mono style={{display:'block',marginBottom:3}}>СЛЕДУЮЩИЙ ШАГ</Mono>
                  <span style={{fontFamily:sans,fontSize:13,color:t2,letterSpacing:'-.01em'}}>
                    {phases[ph.n].title}<span style={{color:t3}}> · {phases[ph.n].when}</span>
                  </span>
                </div>
                <span style={{fontFamily:mono,fontSize:14,color:t3}}>→</span>
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}

/* ══════════════════════════════════════════════════════
   MAIN DASHBOARD
══════════════════════════════════════════════════════ */
export default function Dashboard() {
  const [profile, setProfile] = useState<any>(null)
  const [loading, setLoading] = useState(true)
  const [tab, setTab] = useState('overview')
  const [taskDone, setTaskDone] = useState<Record<string,boolean>>({})
const [saving, setSaving] = useState(false)
const [programs, setPrograms] = useState<any[]>([])

  useEffect(() => {
  const init = async () => {
    // ждём пока Supabase обработает хэш из URL
await new Promise(r => setTimeout(r, 100))
const { data: { session } } = await supabase.auth.getSession()
    if (!session) {
      window.location.href = '/login'
      return
    }
    // если есть сохранённый профиль из онбординга — записываем с user_id
const saved = localStorage.getItem('masterly_profile')
if(saved) {
  const profile = JSON.parse(saved)
  await supabase.from('profiles').upsert({
  ...profile,
  user_id: session.user.id,
}, { onConflict: 'user_id' })
  localStorage.removeItem('masterly_profile')
}
    const { data } = await supabase
  .from('profiles')
  .select('*')
  .eq('user_id', session.user.id)
  .order('created_at', { ascending: false })
  .limit(1)
  .single()
   if(!data) {
  const saved = localStorage.getItem('masterly_profile')
  if(!saved) {
    window.location.href = '/'
  }
  return
}
setProfile(data)
    if (data?.tasks_done) setTaskDone(data.tasks_done)
    setLoading(false)
  }
  init()
}, [])
 
useEffect(() => {
  if (!profile) return
  const countries = profile.countries?.split(',').filter(Boolean) || []

  supabase
    .from('programs')
    .select('*, university:universities(*)')
    .then(({ data }) => {
      if (data) {
        const filtered = data.filter(p =>
          p.university && countries.includes(p.university.country)
        )
        setPrograms(filtered)
      }
    })
}, [profile])

  useEffect(()=>{
    const style = document.createElement('style')
    style.textContent = `
      @import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600&family=Geist+Mono:wght@400;500&display=swap');
      *{box-sizing:border-box;margin:0;padding:0}
      html,body{background:#0A0A0C;height:100%;-webkit-font-smoothing:antialiased}
      ::-webkit-scrollbar{width:4px}
      ::-webkit-scrollbar-thumb{background:rgba(255,255,255,.07);border-radius:2px}
      @keyframes barGrow{from{transform:scaleX(0)}to{transform:scaleX(1)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      @keyframes slideUp{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
      @keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
      .nb{transition:color .15s,background .15s;cursor:pointer}
      .nb:hover{color:#F2EFE9!important}
      .hr{transition:background .12s;cursor:pointer}
      .hr:hover{background:rgba(255,255,255,.035)!important}
      .hc{transition:border-color .15s}
      .hc:hover{border-color:rgba(255,255,255,.16)!important;cursor:pointer}
      .fu{animation:fadeUp .45s cubic-bezier(.22,.68,0,1.1) both}
    `
    document.head.appendChild(style)
    return ()=>style.remove()
  },[])

  if(loading) return (
    <div style={{minHeight:'100vh',background:bg0,display:'flex',alignItems:'center',justifyContent:'center'}}>
      <Mono>ЗАГРУЗКА...</Mono>
    </div>
  )

  if(!profile) return (
    <div style={{minHeight:'100vh',background:bg0,display:'flex',alignItems:'center',justifyContent:'center'}}>
      <div style={{textAlign:'center'}}>
        <div style={{fontFamily:serif,fontStyle:'italic',fontSize:24,color:t1,marginBottom:12}}>Профиль не найден</div>
        <a href="/" style={{fontFamily:sans,fontSize:13,color:t2,textDecoration:'none'}}>Пройти онбординг →</a>
      </div>
    </div>
  )

  const name = profile.name?.split(' ')[0] || ''
  const countries = profile.countries?.split(',').filter(Boolean) || []
 const COLORS = ['#6B8CFF','#3FB950','#C8A256','#A78BFA','#5AC8FA','#E8795A','#D4843A','#E5534B']
const daysUntil = (month: number, day: number) => {
  const now = new Date()
  const d = new Date(now.getFullYear(), month - 1, day)
  if (d < now) d.setFullYear(d.getFullYear() + 1)
  return Math.ceil((d.getTime() - now.getTime()) / 86400000)
}
const unis = programs.map((p: any, i: number) => ({
  n: p.university?.name || '',
  p: p.name,
  days: daysUntil(p.deadline_month, p.deadline_day),
  pct: p.acceptance_rate || 50,
  cost: p.tuition_eur === 0 ? 'Бесплатно' : `€${p.tuition_eur.toLocaleString()}/год`,
  rank: p.university?.ranking_qs ? `#${p.university.ranking_qs} QS` : '—',
  c: COLORS[i % COLORS.length],
  country: p.university?.country || '',
})).sort((a: any, b: any) => a.days - b.days)
    const score = Math.min(97,Math.round((profile.gpa>=4.5?28:profile.gpa>=4.0?20:12)+
    (profile.ielts>=6.5?22:8)+
    (profile.work==='yes'?18:profile.work==='some'?10:4)+10+15
  ))
  const toggleTask = async (key:string) => {
  const newDone = { ...taskDone, [key]: !taskDone[key] }
  setTaskDone(newDone)
  setSaving(true)
  await supabase
    .from('profiles')
    .update({ tasks_done: newDone })
    .eq('id', profile.id)
  setSaving(false)
}

  const NAV = [
    {id:'overview', l:'Обзор'},
    {id:'journey',  l:'Journey'},
    {id:'unis',     l:'Программы'},
    {id:'timeline', l:'Таймлайн'},
  ]

  return (
    <div style={{display:'flex',height:'100vh',background:bg0,fontFamily:sans,color:t1,overflow:'hidden'}}>

      {/* grain */}
      <div style={{position:'fixed',inset:0,pointerEvents:'none',zIndex:0,
        backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,
        backgroundRepeat:'repeat',backgroundSize:'128px',opacity:.6}}/>

      {/* sidebar */}
      <aside style={{width:200,borderRight:`1px solid ${line}`,display:'flex',flexDirection:'column',flexShrink:0,background:bg1,zIndex:10}}>
        <div style={{padding:'22px 18px 18px',borderBottom:`1px solid ${line}`}}>
          <div style={{fontFamily:serif,fontStyle:'italic',fontSize:19,color:t1,letterSpacing:'-.01em',marginBottom:3}}>Masterly</div>
          <Mono>ПАНЕЛЬ УПРАВЛЕНИЯ</Mono>
        </div>
        <div style={{padding:'10px',flex:1}}>
          {NAV.map(n=>(
            <button key={n.id} onClick={()=>setTab(n.id)} className="nb" style={{
              display:'flex',alignItems:'center',width:'100%',padding:'9px 10px',
              borderRadius:5,border:'none',marginBottom:2,
              background:tab===n.id?'rgba(255,255,255,.07)':'transparent',
              color:tab===n.id?t1:t2,fontFamily:sans,fontSize:13,
              fontWeight:tab===n.id?500:400,letterSpacing:'-.01em',
              textAlign:'left',cursor:'pointer',
              borderLeft:`2px solid ${tab===n.id?t1:'transparent'}`,
            }}>{n.l}</button>
          ))}
        </div>
        <div style={{padding:'16px',borderTop:`1px solid ${line}`}}>
          <Mono style={{display:'block',marginBottom:10}}>ПРОФИЛЬ</Mono>
          <div style={{fontFamily:sans,fontSize:13,color:t1,marginBottom:1}}>{profile.name}</div>
          <div style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:12}}>{profile.university}</div>
          <div style={{display:'flex',justifyContent:'space-between',marginBottom:5}}>
            <Mono>ГОТОВНОСТЬ</Mono><Mono style={{color:t1}}>{score}%</Mono>
          </div>
          <Bar v={score} color={t1} h={2}/>
        </div>
        <button onClick={async()=>{
  await supabase.auth.signOut()
  window.location.href='/login'
}} style={{
  marginTop:8,width:'100%',padding:'8px',
  borderRadius:6,border:`1px solid ${line}`,
  background:'transparent',color:t3,
  fontFamily:sans,fontSize:12,cursor:'pointer',
  letterSpacing:'-.01em',
}}>
  Выйти
</button>
      </aside>

      {/* main */}
      <main key={tab} style={{flex:1,overflowY:'auto',zIndex:5}} className="fu">

        {/* ══ ОБЗОР ══ */}
        {tab==='overview'&&(
          <div style={{padding:'36px 40px'}}>
            <div style={{marginBottom:28}}>
              <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:34,color:t1,fontWeight:400,letterSpacing:'-.02em',marginBottom:6}}>
                Привет, {name}
              </h1>
              <Mono style={{color:t2}}>
                {countries.map((c:string)=>c.toUpperCase()).join(' · ')} · {profile.field} · {profile.timeline}
              </Mono>
            </div>

            {/* KPI */}
            <div style={{display:'grid',gridTemplateColumns:'repeat(4,1fr)',borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:28}}>
              {[
                {l:'ГОТОВНОСТЬ',       v:`${score}%`},
                {l:'ПРОГРАММ',         v:`${unis.length}`},
                {l:'GPA',              v:`${profile.gpa} / 5`},
                {l:'IELTS',            v:`${profile.ielts}`, warn:profile.ielts<6.5},
              ].map((s,i)=>(
                <div key={i} style={{padding:'18px',borderRight:`1px solid ${line}`,borderBottom:`1px solid ${line}`}}>
                  <Mono style={{display:'block',marginBottom:8}}>{s.l}</Mono>
                  <div style={{fontFamily:serif,fontStyle:'italic',fontSize:28,color:s.warn?red:t1,fontWeight:400,letterSpacing:'-.02em'}}>
                    {s.v}
                  </div>
                </div>
              ))}
            </div>

            {/* blocker */}
            {profile.ielts<6.5&&(
              <div style={{padding:'14px 18px',marginBottom:24,borderRadius:8,background:`${red}0D`,borderLeft:`3px solid ${red}`}}>
                <Mono style={{display:'block',color:red,marginBottom:6,animation:'pulse 2s infinite'}}>БЛОКЕР</Mono>
                <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.65,fontWeight:300}}>
                  IELTS {profile.ielts} — ниже минимума 6.5. Без этого ни один вуз не примет заявку. Запись: British Council, ≈ $215.
                </p>
              </div>
            )}

            {/* два блока */}
            <div style={{display:'grid',gridTemplateColumns:'1fr 1fr',border:`1px solid ${line}`,borderRadius:8,overflow:'hidden'}}>
              <div style={{padding:'22px',borderRight:`1px solid ${line}`}}>
                <Mono style={{display:'block',marginBottom:18}}>ПРОГРЕСС</Mono>
                {[
                  {l:'Английский',v:profile.ielts>=6.5?100:30,c:grn},
                  {l:'Документы', v:profile.work==='yes'?45:20,c:blue},
                  {l:'Заявки',    v:0,c:gold},
                  {l:'Стипендии', v:0,c:purp},
                ].map((p,i)=>(
                  <div key={i} style={{marginBottom:14}}>
                    <div style={{display:'flex',justifyContent:'space-between',marginBottom:5}}>
                      <span style={{fontFamily:sans,fontSize:12,color:t2}}>{p.l}</span>
                      <span style={{fontFamily:mono,fontSize:11,color:p.c}}>{p.v}%</span>
                    </div>
                    <Bar v={p.v} color={p.c} h={2}/>
                  </div>
                ))}
              </div>
              <div style={{padding:'22px'}}>
                <Mono style={{display:'block',marginBottom:18}}>БЛИЖАЙШИЕ ЗАДАЧИ</Mono>
                {[
                  {done:profile.ielts>=6.5,t:'Сдать IELTS 6.5+',u:profile.ielts<6.5},
                  {done:false,t:'Academic CV',u:false},
                  {done:false,t:'Statement of Purpose',u:false},
                  {done:false,t:'Рекомендательные письма',u:false},
                  {done:false,t:'Подать на стипендию',u:profile.budget==='zero'},
                ].map((task,i)=>(
                  <div key={i} style={{display:'flex',gap:10,alignItems:'center',padding:'9px 0',borderBottom:`1px solid ${line}`}}>
                    <div style={{width:13,height:13,borderRadius:'50%',flexShrink:0,
                      border:`1.5px solid ${task.done?grn:task.u?red:t3}`,
                      background:task.done?grn:'transparent',
                      display:'flex',alignItems:'center',justifyContent:'center'}}>
                      {task.done&&<span style={{color:bg0,fontSize:8,fontWeight:700}}>✓</span>}
                    </div>
                    <span style={{fontFamily:sans,fontSize:12,flex:1,color:task.done?t2:task.u?red:t2,
                      textDecoration:task.done?'line-through':'none',letterSpacing:'-.01em'}}>{task.t}</span>
                    {task.u&&!task.done&&<Mono style={{color:red,animation:'pulse 2s infinite'}}>СРОЧНО</Mono>}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ══ JOURNEY ══ */}
        {tab==='journey'&&(
  <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
   <Roadmap profile={profile} taskDone={taskDone} onToggle={toggleTask}/>
  </div>
)}

        {/* ══ ПРОГРАММЫ ══ */}
        {tab==='unis'&&(
          <div style={{padding:'36px 40px'}}>
            <Mono style={{display:'block',marginBottom:12}}>{unis.length} ПРОГРАММ · ПОДОБРАНО ПОД ТВОЙ ПРОФИЛЬ</Mono>
            <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:32,color:t1,fontWeight:400,letterSpacing:'-.02em',marginBottom:24}}>Программы</h1>

            {profile.ielts<6.5&&(
              <div style={{padding:'11px 16px',marginBottom:20,borderRadius:6,background:`${red}0D`,borderLeft:`3px solid ${red}`}}>
                <span style={{fontFamily:sans,fontSize:12,color:red}}>IELTS {profile.ielts} — ниже минимума. Подача заблокирована до сдачи.</span>
              </div>
            )}

            <div style={{border:`1px solid ${line}`,borderRadius:8,overflow:'hidden'}}>
              <div style={{display:'grid',gridTemplateColumns:'1fr 55px 110px 70px 80px',
                padding:'10px 20px',background:bg1,borderBottom:`1px solid ${line}`}}>
                {['Программа','Страна','Стоимость','Шанс','Дней'].map((h,i)=>(
                  <Mono key={i}>{h.toUpperCase()}</Mono>
                ))}
              </div>
              {unis.map((u:any,i:number)=>(
                <div key={i} className="hc" style={{display:'grid',gridTemplateColumns:'1fr 55px 110px 70px 80px',
                  padding:'16px 20px',alignItems:'center',
                  borderBottom:i<unis.length-1?`1px solid ${line}`:'none',
                  border:`1px solid transparent`,transition:'border-color .15s'}}>
                  <div>
                    <div style={{fontFamily:sans,fontSize:13,fontWeight:500,color:t1,letterSpacing:'-.01em',marginBottom:4}}>{u.n}</div>
                    <div style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:7}}>{u.p}</div>
                    <div style={{width:120}}><Bar v={u.pct} color={u.c} h={2}/></div>
                  </div>
                  <span style={{fontFamily:mono,fontSize:9,color:t2,padding:'2px 6px',border:`1px solid ${line}`,borderRadius:3}}>
                    {u.country?.toUpperCase()}
                  <Mono style={{color:t2}}>{u.cost}</Mono>
                  <div style={{fontFamily:serif,fontStyle:'italic',fontSize:20,color:u.c}}>{u.pct}%</div>
                  <Mono style={{color:u.days<30?red:t2}}>{u.days} дн.</Mono>
                </div>
              ))}
            </div>
          </div>
        )}

{tab==='timeline'&&(
  <GanttTimeline profile={profile}/>
)}
      </main>
    </div>
  )
}