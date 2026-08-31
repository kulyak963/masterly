'use client'
import Roadmap from './Roadmap'
import { useState, useEffect, useRef } from 'react'
import { supabase } from '../../lib/supabase'
import Timeline from './Timeline'
import GanttTimeline from './GanttTimeline'
import { bg0, bg1, line, t1, t2, t3, gold, blue, red, grn, purp, amb, sans, serif, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'
import VerifiedBadge from '@/components/VerifiedBadge'
import HungaryGuide from './HungaryGuide'
import ItalyGuide from './ItalyGuide'

/* ── country names ── */
const CNAME: Record<string,string> = {
  de:'Германия', nl:'Нидерланды', se:'Швеция',
  ch:'Швейцария', fi:'Финляндия', fr:'Франция',
  cz:'Чехия', at:'Австрия', hu:'Венгрия', it:'Италия'
}
/* Флаги — SVG, не эмодзи: Windows/Chrome не рисует флаг-эмодзи цветной
   картинкой, показывает буквы кода страны как текст (проверено на скрине
   пользователя). Полосы/цвета упрощены — на бейдже 16-18px мелкие детали
   вроде герба Португалии или треугольника Чехии всё равно неразличимы. */
function Flag({ code, size=18 }: { code?: string; size?: number }) {
  const w = size, h = Math.round(size*2/3)
  const bands = (colors: string[], dir: 'h'|'v') => colors.map((c,i)=>{
    const n = colors.length
    return dir==='h'
      ? <rect key={i} x={0} y={h*i/n} width={w} height={h/n} fill={c}/>
      : <rect key={i} x={w*i/n} y={0} width={w/n} height={h} fill={c}/>
  })
  const nordicCross = (field: string, cross: string) => (
    <>
      <rect width={w} height={h} fill={field}/>
      <rect x={w*0.32} width={w*0.16} height={h} fill={cross}/>
      <rect y={h*0.4} width={w} height={h*0.2} fill={cross}/>
    </>
  )
  let content: React.ReactNode
  switch (code) {
    case 'de': content = bands(['#000000','#DD0000','#FFCE00'],'h'); break
    case 'nl': content = bands(['#AE1C28','#FFFFFF','#21468B'],'h'); break
    case 'fr': content = bands(['#0055A4','#FFFFFF','#EF4135'],'v'); break
    case 'at': content = bands(['#ED2939','#FFFFFF','#ED2939'],'h'); break
    case 'be': content = bands(['#000000','#FAE042','#ED2939'],'v'); break
    case 'ie': content = bands(['#169B62','#FFFFFF','#FF883E'],'v'); break
    case 'it': content = bands(['#008C45','#F4F5F0','#CD212A'],'v'); break
    case 'es': content = bands(['#AA151B','#F1BF00','#AA151B'],'h'); break
    case 'pt': content = bands(['#046A38','#DA291C'],'v'); break
    case 'pl': content = bands(['#FFFFFF','#DC143C'],'h'); break
    case 'hu': content = bands(['#CE2939','#FFFFFF','#477050'],'h'); break
    case 'cz': content = bands(['#FFFFFF','#D7141A'],'h'); break
    case 'ee': content = bands(['#0072CE','#000000','#FFFFFF'],'h'); break
    case 'lt': content = bands(['#FDB913','#006A44','#C1272D'],'h'); break
    case 'lv': content = bands(['#9E3039','#FFFFFF','#9E3039'],'h'); break
    case 'se': content = nordicCross('#005BAA','#FECC02'); break
    case 'fi': content = nordicCross('#FFFFFF','#003580'); break
    case 'no': content = nordicCross('#EF2B2D','#FFFFFF'); break
    case 'dk': content = nordicCross('#C60C30','#FFFFFF'); break
    case 'ch': content = (
      <>
        <rect width={w} height={h} fill="#D52B1E"/>
        <rect x={w*0.42} y={h*0.2} width={w*0.16} height={h*0.6} fill="#FFFFFF"/>
        <rect x={w*0.28} y={h*0.4} width={w*0.44} height={h*0.2} fill="#FFFFFF"/>
      </>
    ); break
    default: return <span style={{fontFamily:mono,fontSize:size*0.55,color:t2}}>{code?.toUpperCase()}</span>
  }
  return (
    <svg width={w} height={h} viewBox={`0 0 ${w} ${h}`}
      style={{borderRadius:2,display:'block',flexShrink:0,outline:`1px solid ${line}`,outlineOffset:-0.5}}>
      {content}
    </svg>
  )
}
const BUDGET_LIMIT: Record<string,number> = {
  zero:0, low:5000, mid:15000, high:999999
}

function calcScore(p: any, profile: any): number {
  let s = 50
  const ieltsMin = p.ielts_min || 6.5
  if (profile.ielts >= ieltsMin + 1) s += 20
  else if (profile.ielts >= ieltsMin) s += 10
  else if (profile.ielts < ieltsMin - 0.5) s -= 25
  else s -= 5

  const budget = BUDGET_LIMIT[profile.budget] ?? 15000
  if (p.tuition_eur === 0) s += profile.budget === 'zero' ? 25 : 15
  else if (p.tuition_eur <= budget) s += 10
  else s -= profile.budget === 'zero' ? 30 : 15

  const qs = p.university?.ranking_qs
  if (qs) { if (qs <= 50) s -= 20; else if (qs <= 100) s -= 10; else if (qs > 300) s += 10 }
  else s += 5

  return Math.max(0, Math.min(100, s))
}

function getBucket(score: number) {
  if (score >= 70) return 'safety'
  if (score >= 40) return 'target'
  return 'reach'
}

const BUCKET_CFG = {
  reach:  { label:'Амбиция',  sub:'Сложно, но мечта',      color:purp },
  target: { label:'Таргет',   sub:'Реальный шанс',          color:blue },
  safety: { label:'Запасная', sub:'Высокий шанс оффера',    color:grn },
}

type ApplicationStatus = 'not_applied'|'applied'|'interview'|'offer'|'rejected'
const STATUS_CFG: Record<ApplicationStatus,{label:string;color:string}> = {
  not_applied: { label:'Не подано',      color:t3 },
  applied:     { label:'Подано',         color:blue },
  interview:   { label:'Собеседование',  color:gold },
  offer:       { label:'Оффер',          color:grn },
  rejected:    { label:'Отказ',          color:red },
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
      id:'docs', n:4, color:amb,
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
        <h1 style={{fontFamily:serif,fontStyle:'normal',fontSize:32,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:12}}>
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
                        background:done?`${grn}0D`:'rgba(255,255,255,.02)',
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
  const [profileMissing, setProfileMissing] = useState(false)
  const [loading, setLoading] = useState(true)
  const [tab, setTab] = useState('overview')
  const [taskDone, setTaskDone] = useState<Record<string,boolean>>({})
const [saving, setSaving] = useState(false)
const [programs, setPrograms] = useState<any[]>([])
const [selectedProgram, setSelectedProgram] = useState<any>(null)
const [verdict, setVerdict] = useState<any>(null)
const [verdictLoading, setVerdictLoading] = useState(false)
const [verdictError, setVerdictError] = useState<string|null>(null)
const [favorites, setFavorites] = useState<Map<string,{status:ApplicationStatus;status_updated_at:string}>>(new Map())
const [compareList, setCompareList] = useState<string[]>([])

const [isMobile, setIsMobile] = useState(false)
const [dragY, setDragY] = useState(0)
const [dragging, setDragging] = useState(false)
const dragStart = useRef(0)
 useEffect(()=>{
  const check = () => setIsMobile(window.innerWidth < 768)
  check()
  window.addEventListener('resize', check)
  return () => window.removeEventListener('resize', check)
},[]) 
useEffect(() => {
  const loadProfile = async (session: any) => {
    try {
      const saved = localStorage.getItem('masterly_profile')
      if (saved) {
        const savedProfile = JSON.parse(saved)
        await supabase.from('profiles').upsert({
          ...savedProfile,
          user_id: session.user.id,
        }, { onConflict: 'user_id' })
        localStorage.removeItem('masterly_profile')
      }

      const abort = new AbortController()
      const timer = setTimeout(() => abort.abort(), 8000)

      let { data, error } = await supabase
        .from('profiles')
        .select('*')
        .eq('user_id', session.user.id)
        .order('created_at', { ascending: false })
        .limit(1)
        .abortSignal(abort.signal)
        .single()

      clearTimeout(timer)

      // Магическая ссылка часто открывается на другом устройстве (например,
      // почта на телефоне), где localStorage пустой — тогда ищем анкету,
      // которую сохранили по email на шаге отправки ссылки.
      if ((error || !data) && session.user.email) {
        const { data: pending } = await supabase
          .from('pending_profiles')
          .select('data')
          .eq('email', session.user.email)
          .maybeSingle()

        if (pending?.data) {
          const { data: migrated, error: upsertError } = await supabase
            .from('profiles')
            .upsert({ ...pending.data, user_id: session.user.id }, { onConflict: 'user_id' })
            .select('*')
            .single()
          if (!upsertError && migrated) {
            data = migrated
            error = null
            await supabase.from('pending_profiles').delete().eq('email', session.user.email)
          }
        }
      }

      if (error || !data) {
        // Не редиректим автоматически на "/" — если там сессия есть, а анкеты
        // нет, "/" тут же кидает обратно на "/dashboard" и получается
        // бесконечная перезагрузка. Показываем экран с ручной кнопкой.
        setLoading(false)
        setProfileMissing(true)
        return
      }
      setProfile(data)
      if (data?.tasks_done) setTaskDone(data.tasks_done)
      setLoading(false)
    } catch {
      window.location.href = '/login'
    }
  }

  const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
    if (event === 'INITIAL_SESSION' || event === 'SIGNED_IN') {
      if (!session) {
        window.location.href = '/login'
        return
      }
      loadProfile(session)
    }
  })

  return () => subscription.unsubscribe()
}, [])
 
useEffect(() => {
  if (!profile) return
  const countries = profile.countries?.split(',').filter(Boolean) || []

  supabase
    .from('programs')
    .select('*, university:universities(*)')
    .then(({ data }) => {
      if (data) {
    const masterField = profile.master_field || ''
const filtered = data.filter(p =>
  p.university &&
  countries.includes(p.university.country) &&
  (!masterField || p.field === masterField)
)
        setPrograms(filtered)
      }
    })
}, [profile])
useEffect(() => {
  if (!profile) return
  supabase.from('favorites').select('program_id, status, status_updated_at')
    .eq('user_id', profile.user_id)
    .then(({ data }) => {
      if (data) setFavorites(new Map(data.map((f:any) => [f.program_id, {
        status: (f.status ?? 'not_applied') as ApplicationStatus,
        status_updated_at: f.status_updated_at,
      }])))
    })
}, [profile])

useEffect(()=>{
  const style = document.createElement('style')
  style.textContent = `
    *{box-sizing:border-box;margin:0;padding:0}
    html,body{background:${bg0};height:100%;-webkit-font-smoothing:antialiased;-webkit-tap-highlight-color:transparent;overscroll-behavior:none}
    button,a{-webkit-tap-highlight-color:transparent}
    ::-webkit-scrollbar{width:4px}
    ::-webkit-scrollbar-thumb{background:rgba(255,255,255,.07);border-radius:2px}

    @keyframes barGrow{from{transform:scaleX(0)}to{transform:scaleX(1)}}
    @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
    @keyframes slideUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
    @keyframes slideUpFull{from{opacity:0;transform:translateY(100%)}to{opacity:1;transform:translateY(0)}}
    @keyframes fadeUp{from{opacity:0;transform:translateY(16px)}to{opacity:1;transform:translateY(0)}}
    @keyframes spring{0%{opacity:0;transform:translateY(20px) scale(.96)}60%{transform:translateY(-2px) scale(1.01)}100%{opacity:1;transform:translateY(0) scale(1)}}
    @keyframes shimmer{0%{background-position:-200% 0}100%{background-position:200% 0}}
    @keyframes countUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    @keyframes glow{0%,100%{box-shadow:0 0 0 rgba(255,255,255,0)}50%{box-shadow:0 0 24px rgba(255,255,255,.06)}}

    .nb{transition:color .15s,background .15s;cursor:pointer}
    .nb:hover{color:${t1}!important}
    .hc{transition:all .2s}
    .hc:hover{background:rgba(255,255,255,.04)!important}

    .fu{animation:fadeUp .35s cubic-bezier(.22,.68,0,1.1) both}
    .spring-in{animation:spring .5s cubic-bezier(.34,1.56,.64,1) both}

    .tactile{transition:transform .12s cubic-bezier(.34,1.56,.64,1);user-select:none;-webkit-user-select:none}
    .tactile:active{transform:scale(.96)}

    .card-tactile{transition:all .25s cubic-bezier(.22,1,.36,1);user-select:none;-webkit-user-select:none}
    .card-tactile:active{transform:scale(.985);background:rgba(255,255,255,.06)!important}

    .stagger-1{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .04s both}
    .stagger-2{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .08s both}
    .stagger-3{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .12s both}
    .stagger-4{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .16s both}
    .stagger-5{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .20s both}
    .stagger-6{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .24s both}
    .stagger-7{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .28s both}
    .stagger-8{animation:spring .5s cubic-bezier(.34,1.56,.64,1) .32s both}

    .hero-num{background:linear-gradient(180deg,${t1} 0%,#A8A39B 100%);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text}

    input[type="range"]::-webkit-slider-thumb{
      appearance:none;width:22px;height:22px;border-radius:50%;
      background:${t1};cursor:pointer;
      box-shadow:0 4px 12px rgba(0,0,0,.5),0 0 0 4px rgba(236,234,226,.08);
      transition:transform .15s
    }
    input[type="range"]::-webkit-slider-thumb:active{transform:scale(1.15)}
    input[type="range"]::-moz-range-thumb{
      width:22px;height:22px;border-radius:50%;border:none;
      background:${t1};cursor:pointer;
      box-shadow:0 4px 12px rgba(0,0,0,.5)
    }
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
      <div style={{textAlign:'center',maxWidth:360,padding:'0 20px'}}>
        <div style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:22,color:t1,marginBottom:12}}>Анкета не найдена</div>
        <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.6,marginBottom:20}}>
          {profileMissing
            ? 'Вход подтверждён, но не нашли твою анкету на этом устройстве. Если ты заполнял её на компьютере — просто вернись туда, вход должен произойти сам.'
            : 'Похоже, анкета ещё не заполнена.'}
        </p>
        <div style={{display:'flex',flexDirection:'column',gap:10}}>
          <a href="/" style={{fontFamily:sans,fontSize:13,color:t1,textDecoration:'underline'}}>Пройти опрос заново →</a>
          <button onClick={async()=>{await supabase.auth.signOut();window.location.href='/login'}} style={{
            background:'none',border:'none',fontFamily:sans,fontSize:12,color:t3,cursor:'pointer'}}>
            Выйти
          </button>
        </div>
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
  ...p,
  _n: p.university?.name || '',
  _p: p.name,
  _days: daysUntil(p.deadline_month, p.deadline_day),
  _cost: p.tuition_eur === 0 ? 'Бесплатно' : `€${p.tuition_eur.toLocaleString()}/год`,
  _rank: p.university?.ranking_qs ? `#${p.university.ranking_qs} QS` : '—',
  _c: COLORS[i % COLORS.length],
  _country: p.university?.country || '',
  _score: calcScore(p, profile),
  _bucket: getBucket(calcScore(p, profile)),
})).sort((a: any, b: any) => b._score - a._score)

// Программы для таймлайна/календаря — избранное, а если его нет, топ-матч по каждой стране.
// Раньше даты были одна на всю страну и не зависели от выбора студента.
const timelinePrograms = (() => {
  const favs = unis.filter((u: any) => favorites.has(u.id))
  if (favs.length) return favs
  const seen = new Set<string>()
  const picked: any[] = []
  for (const u of unis) {
    if (!seen.has(u._country)) { seen.add(u._country); picked.push(u) }
  }
  return picked
})()
const haptic = (ms=8) => {
  if(typeof navigator !== 'undefined' && navigator.vibrate) navigator.vibrate(ms)
}

const toggleFavorite = async (programId: string, e: React.MouseEvent) => {
  e.stopPropagation()
  const isFav = favorites.has(programId)
  const next = new Map(favorites)
  if (isFav) {
    next.delete(programId)
    await supabase.from('favorites').delete()
      .eq('user_id', profile.user_id).eq('program_id', programId)
  } else {
    next.set(programId, { status:'not_applied', status_updated_at: new Date().toISOString() })
    await supabase.from('favorites').insert({ user_id: profile.user_id, program_id: programId })
  }
  setFavorites(next)
}

const updateApplicationStatus = async (programId: string, status: ApplicationStatus, e: React.SyntheticEvent) => {
  e.stopPropagation()
  const status_updated_at = new Date().toISOString()
  const next = new Map(favorites)
  next.set(programId, { status, status_updated_at })
  setFavorites(next)
  await supabase.from('favorites').update({ status, status_updated_at })
    .eq('user_id', profile.user_id).eq('program_id', programId)
}

const toggleCompare = (programId: string, e: React.MouseEvent) => {
  e.stopPropagation()
  setCompareList(prev =>
    prev.includes(programId)
      ? prev.filter(id => id !== programId)
      : prev.length < 3 ? [...prev, programId] : prev
  )
}
const getVerdict = async (p: any) => {
  setVerdict(null)
  setVerdictError(null)
  setVerdictLoading(true)
  try {
    const res = await fetch('/api/verdict', {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({
        program: { ...p, university_name: p.university?.name },
        profile,
      })
    })
    const data = await res.json()
    if (!res.ok) {
      setVerdictError('Не получилось получить анализ — попробуй позже')
    } else {
      setVerdict(data)
    }
  } catch (e) {
    console.error(e)
    setVerdictError('Не получилось получить анализ — попробуй позже')
  }
  setVerdictLoading(false)
}

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
  {id:'saved',    l:'Избранное'},
  {id:'applications', l:'Заявки'},
  {id:'timeline', l:'Таймлайн'},
  ...((countries.includes('hu')||countries.includes('it')) ? [{id:'scholarship-guide', l:'Стипендии · PRO'}] : []),
  {id:'settings', l:'Настройки'},
]

  return (
    <div style={{display:'flex',height:'100vh',background:bg0,fontFamily:sans,color:t1,overflow:'hidden'}}>

      {/* grain */}
      <div style={{position:'fixed',inset:0,pointerEvents:'none',zIndex:0,
        backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,
        backgroundRepeat:'repeat',backgroundSize:'128px',opacity:.6}}/>

      {/* sidebar */}
      <aside style={{width:200,borderRight:`1px solid ${line}`,display:isMobile?'none':'flex',flexDirection:'column',flexShrink:0,background:bg1,zIndex:10}}>
        <div style={{padding:'22px 18px 18px',borderBottom:`1px solid ${line}`}}>
          <div style={{fontFamily:serif,fontStyle:'normal',fontWeight:700,fontSize:19,color:t1,letterSpacing:'-.01em',marginBottom:3}}>Mastersly</div>
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
    <main key={tab} style={{flex:1,overflowY:'auto',zIndex:5,paddingBottom:isMobile?80:0}} className="fu">
  {isMobile&&(
  <div style={{position:'sticky',top:0,zIndex:20,background:bg0,
    borderBottom:`1px solid ${line}`,padding:'14px 20px',
    display:'flex',alignItems:'center',justifyContent:'space-between'}}>
    <div style={{fontFamily:serif,fontStyle:'normal',fontWeight:700,fontSize:18,color:t1}}>Mastersly</div>
    <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em'}}>{score}% ГОТОВНОСТЬ</div>
  </div>
)}
        {/* ══ ОБЗОР ══ */}
        {tab==='overview'&&(
          <div style={{padding:'36px 40px'}}>
            <div style={{marginBottom:28}}>
              <h1 style={{fontFamily:displayFont.style.fontFamily,fontSize:34,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:6}}>
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
                  <div style={{fontFamily:displayFont.style.fontFamily,fontSize:26,color:s.warn?red:t1,fontWeight:800,letterSpacing:'-.01em'}}>
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

            {/* баннер гайда по стипендиям — единственный вход на мобиле, т.к. в
                нижнем нав-баре мобилы всего 5 иконок и своей вкладки там нет */}
            {(countries.includes('hu')||countries.includes('it'))&&(
              <button onClick={()=>setTab('scholarship-guide')} style={{
                display:'flex',alignItems:'center',justifyContent:'space-between',gap:14,
                width:'100%',marginTop:16,padding:'16px 18px',borderRadius:8,
                border:`1px solid ${gold}40`,background:`${gold}0D`,cursor:'pointer',
                textAlign:'left',fontFamily:'inherit'}}>
                <div>
                  <Mono style={{display:'block',color:gold,marginBottom:4}}>СТИПЕНДИИ · PRO</Mono>
                  <div style={{fontFamily:sans,fontSize:13,color:t1,fontWeight:500}}>
                    {countries.includes('hu')&&countries.includes('it')
                      ? 'Гайды по Stipendium Hungaricum и льготам в Италии'
                      : countries.includes('hu') ? 'Полный гайд по Stipendium Hungaricum'
                      : 'Полный гайд по стипендиям и льготам в Италии'}
                  </div>
                </div>
                <span style={{fontFamily:sans,fontSize:18,color:gold,flexShrink:0}}>→</span>
              </button>
            )}
          </div>
        )}

        {/* ══ JOURNEY ══ */}
        {tab==='journey'&&(
  <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
   <Roadmap profile={profile} taskDone={taskDone} onToggle={toggleTask}/>
  </div>
)}

        {/* ══ ПРОГРАММЫ ══ */}
 {/* ══ ПРОГРАММЫ ══ */}
{tab==='unis'&&(
  <div style={{padding:'36px 40px'}}>
    <Mono style={{display:'block',marginBottom:12}}>{unis.length} ПРОГРАММ · ПОДОБРАНО ПОД ТВОЙ ПРОФИЛЬ</Mono>
    <h1 style={{fontFamily:displayFont.style.fontFamily,fontSize:32,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:28}}>Программы</h1>
    {unis.length===0&&(
      <div style={{padding:'32px',textAlign:'center',border:`1px solid ${line}`,borderRadius:8}}>
        <div style={{fontFamily:serif,fontSize:18,color:t2,marginBottom:8}}>
          Под твои страны и направление пока ничего не нашлось
        </div>
        <div style={{fontFamily:sans,fontSize:13,color:t3,marginBottom:16}}>
          Попробуй добавить ещё стран или сменить направление в настройках
        </div>
        <button onClick={()=>setTab('settings')} style={{
          padding:'10px 20px',borderRadius:8,border:`1px solid ${line}`,
          background:'rgba(255,255,255,.05)',color:t1,fontFamily:sans,
          fontSize:13,fontWeight:500,cursor:'pointer'}}>
          Открыть настройки
        </button>
      </div>
    )}
    {(['reach','target','safety'] as const).map(bucket => {
      const items = unis.filter((u:any) => u._bucket === bucket)
      if (!items.length) return null
      const cfg = BUCKET_CFG[bucket]
      return (
        <div key={bucket} style={{marginBottom:32,paddingLeft:12,borderLeft:`2px solid ${cfg.color}40`,boxShadow:`-2px 0 12px ${cfg.color}15`}}>
          <div style={{display:'flex',alignItems:'baseline',gap:10,marginBottom:14}}>
            <span style={{fontFamily:mono,fontSize:10,letterSpacing:'0.14em',color:t2}}>{cfg.label.toUpperCase()}</span>
            <span style={{fontFamily:sans,fontSize:12,color:t3}}>{cfg.sub}</span>
            <Mono style={{color:t3,marginLeft:'auto'}}>{items.length} программ</Mono>
          </div>
          <div style={{border:`1px solid ${line}`,borderRadius:8,overflow:'hidden'}}>
            {items.map((u:any,i:number)=>(
              <div key={u.id} onClick={()=>{setSelectedProgram(u);setVerdict(null)}}
                className="hc" style={{display:'grid',gridTemplateColumns:'1fr 40px 60px 110px 60px 70px',
padding:'16px 20px',alignItems:'center',cursor:'pointer',
                borderBottom:i<items.length-1?`1px solid ${line}`:'none',
                background:selectedProgram?.id===u.id?'rgba(255,255,255,.04)':'transparent',
                borderLeft:`2px solid ${selectedProgram?.id===u.id?cfg.color:'transparent'}`,
                transition:'all .15s'}}>
                <div>
                  <div style={{display:'flex',alignItems:'center',gap:8,marginBottom:3}}>
                    <div style={{fontFamily:sans,fontSize:13,fontWeight:500,color:t1,letterSpacing:'-.01em'}}>{u._n}</div>
                    <VerifiedBadge verified={u.verified}/>
                  </div>
                  <div style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:6}}>{u._p}</div>
                  <div style={{width:100}}><Bar v={u._score} color={cfg.color} h={2}/></div>
                  <button onClick={(e)=>toggleFavorite(u.id,e)}
  style={{background:'none',border:'none',cursor:'pointer',padding:'4px',
   color:favorites.has(u.id)?gold:'rgba(255,255,255,.25)',fontSize:16,transition:'color .15s',
    justifySelf:'center'}}>
  {favorites.has(u.id)?'♥':'♡'}
</button>
                </div>
                <span style={{justifySelf:'center'}} title={CNAME[u._country]||u._country}>
                  <Flag code={u._country}/>
                </span>
                <Mono style={{color:t2}}>{u._cost}</Mono>
                <div style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:18,color:cfg.color}}>{u._score}</div>
                <Mono style={{color:u._days<30?red:t2}}>{u._days} дн.</Mono>
              </div>
            ))}
          </div>
        </div>
      )
    })}
    {selectedProgram&&(
      <div onClick={()=>setSelectedProgram(null)}
        style={{position:'fixed',inset:0,background:'rgba(0,0,0,.7)',
          zIndex:100,display:'flex',alignItems:'center',justifyContent:'center',
          padding:24,backdropFilter:'blur(4px)'}}>
        <div onClick={e=>e.stopPropagation()}
        onTouchStart={e=>{dragStart.current=e.touches[0].clientY;setDragging(true)}}
onTouchMove={e=>{const dy=e.touches[0].clientY-dragStart.current;if(dy>0)setDragY(dy)}}
onTouchEnd={()=>{if(dragY>120){setSelectedProgram(null);setDragY(0)}else setDragY(0);setDragging(false)}}
          style={{width:'100%',maxWidth:isMobile?'100%':520,maxHeight:isMobile?'92vh':'85vh',overflowY:'auto',
background:bg1,borderRadius:isMobile?'20px 20px 0 0':12,border:`1px solid ${line}`,
animation:isMobile?'slideUpFull .35s cubic-bezier(.22,.68,0,1.1) both':'slideUp .3s ease both',
transform:dragY>0?`translateY(${dragY}px)`:'none',
transition:dragging?'none':'transform .3s cubic-bezier(.22,.68,0,1.1)'}}>
          <div style={{padding:'28px 32px'}}>
            <div style={{display:'flex',justifyContent:'space-between',alignItems:'flex-start',marginBottom:24}}>
              <div>
                <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.14em',color:t3,marginBottom:8}}>
                  {BUCKET_CFG[selectedProgram._bucket as keyof typeof BUCKET_CFG].label.toUpperCase()} · ПРИМЕРНАЯ ОЦЕНКА {selectedProgram._score}
                </div>
                <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:4}}>
                  <h2 style={{fontFamily:displayFont.style.fontFamily,fontSize:22,color:t1,fontWeight:800,letterSpacing:'-.01em',lineHeight:1.2}}>
                    {selectedProgram._p}
                  </h2>
                  <VerifiedBadge verified={selectedProgram.verified}/>
                </div>
                <div style={{fontFamily:sans,fontSize:13,color:t2,marginBottom:4}}>{selectedProgram._n}</div>
                <p style={{fontFamily:sans,fontSize:11,color:t3,lineHeight:1.5}}>
                  Оценка — грубая прикидка по IELTS/бюджету/рейтингу, не гарантия поступления.
                </p>
              </div>
              <button onClick={()=>setSelectedProgram(null)}
                style={{background:'none',border:'none',color:t3,cursor:'pointer',fontSize:20,padding:'0 0 0 16px',flexShrink:0}}>×</button>
            </div>
            <div style={{display:'grid',gridTemplateColumns:'repeat(3,1fr)',borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:24}}>
              {[
                {l:'РЕЙТИНГ',v:selectedProgram._rank},
                {l:'СТОИМОСТЬ',v:selectedProgram._cost},
                {l:'ДЕДЛАЙН',v:`${selectedProgram._days} дн.`,warn:selectedProgram._days<30},
              ].map((m,i)=>(
                <div key={i} style={{padding:'12px 14px',borderRight:`1px solid ${line}`,borderBottom:`1px solid ${line}`}}>
                  <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:4}}>{m.l}</div>
                  <div style={{fontFamily:sans,fontSize:13,color:m.warn?red:t1}}>{m.v}</div>
                </div>
              ))}
            </div>
            {selectedProgram.summary&&(
              <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.7,marginBottom:24,fontWeight:300}}>{selectedProgram.summary}</p>
            )}
            <div style={{height:1,background:line,marginBottom:20}}/>
            {selectedProgram.pros?.length>0&&(
              <div style={{marginBottom:20}}>
                <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:12}}>ПЛЮСЫ</div>
                {selectedProgram.pros.map((p:string,i:number)=>(
                  <div key={i} style={{display:'flex',gap:12,marginBottom:8,alignItems:'flex-start'}}>
                    <span style={{color:t3,fontSize:11,marginTop:2,flexShrink:0}}>—</span>
                    <span style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.5}}>{p}</span>
                  </div>
                ))}
              </div>
            )}
            {selectedProgram.cons?.length>0&&(
              <div style={{marginBottom:20}}>
                <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:12}}>МИНУСЫ</div>
                {selectedProgram.cons.map((c:string,i:number)=>(
                  <div key={i} style={{display:'flex',gap:12,marginBottom:8,alignItems:'flex-start'}}>
                    <span style={{color:t3,fontSize:11,marginTop:2,flexShrink:0}}>—</span>
                    <span style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.5}}>{c}</span>
                  </div>
                ))}
              </div>
            )}
            {selectedProgram.scholarships?.length>0&&(
              <div style={{marginBottom:24}}>
                <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:12}}>СТИПЕНДИИ</div>
                <div style={{display:'flex',flexWrap:'wrap',gap:6}}>
                  {selectedProgram.scholarships.map((s:string,i:number)=>(
                    <span key={i} style={{fontFamily:mono,fontSize:9,padding:'4px 10px',borderRadius:3,border:`1px solid ${line}`,color:t2}}>{s}</span>
                  ))}
                </div>
              </div>
            )}
            <button onClick={()=>getVerdict(selectedProgram)} disabled={verdictLoading}
              style={{width:'100%',padding:'13px',borderRadius:8,border:'none',
                background:verdictLoading?'rgba(255,255,255,.04)':t1,
                color:verdictLoading?t3:bg0,fontFamily:sans,fontSize:13,
                fontWeight:500,cursor:verdictLoading?'not-allowed':'pointer',
                letterSpacing:'-.01em',marginBottom:10,transition:'all .2s'}}>
              {verdictLoading ? 'Анализируем...' : 'Персональный анализ'}
            </button>
            <a href={selectedProgram.url || `https://www.google.com/search?q=${encodeURIComponent(selectedProgram._p+' '+selectedProgram._n+' master admission')}`}
              target="_blank" rel="noopener"
              style={selectedProgram.verified ? {
                display:'block',textAlign:'center',padding:'11px',borderRadius:8,
                border:`1px solid ${line}`,fontFamily:sans,fontSize:12,color:t2,textDecoration:'none',
              } : {
                display:'block',textAlign:'center',padding:'13px',borderRadius:8,
                border:`1.5px solid ${gold}50`,background:`${gold}0F`,
                fontFamily:sans,fontSize:13,fontWeight:500,color:gold,textDecoration:'none',
              }}>
              {selectedProgram.verified ? 'Страница программы →' : '⚠ Проверить точные данные на сайте вуза →'}
            </a>
            <a href={`/program/${selectedProgram.id}`} target="_blank" rel="noopener"
              style={{display:'block',textAlign:'center',padding:'9px',fontFamily:sans,fontSize:11,
                color:t3,textDecoration:'underline'}}>
              Публичная страница этой программы (можно поделиться)
            </a>
            {isMobile&&(
  <button onClick={()=>setSelectedProgram(null)}
    style={{position:'sticky',bottom:0,left:0,right:0,
      width:'100%',marginTop:20,padding:'16px',
      background:`linear-gradient(to top, ${bg1} 80%, transparent)`,
      border:'none',borderTop:`1px solid ${line}`,
      color:t2,fontFamily:sans,fontSize:14,cursor:'pointer',
      letterSpacing:'-.01em'}}>
    Закрыть
  </button>
)}
            {verdictError&&(
              <div style={{marginTop:20,padding:'14px 16px',borderRadius:8,
                background:`${red}0D`,border:`1px solid ${red}30`}}>
                <span style={{fontFamily:sans,fontSize:13,color:red}}>{verdictError}</span>
              </div>
            )}
            {verdict&&(
              <div style={{marginTop:20,animation:'slideUp .4s ease both'}}>
                <div style={{height:1,background:line,marginBottom:20}}/>
                <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:12}}>ПЕРСОНАЛЬНЫЙ АНАЛИЗ</div>
                <p style={{fontFamily:sans,fontSize:15,color:t1,lineHeight:1.6,marginBottom:16,fontWeight:400}}>«{verdict.verdict}»</p>
                {verdict.fit?.map((f:string,i:number)=>(
                  <div key={i} style={{display:'flex',gap:12,marginBottom:8}}>
                    <span style={{color:t3,flexShrink:0}}>—</span>
                    <span style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.5}}>{f}</span>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    )}
  </div>
)}
{tab==='saved'&&(
  <div style={{padding:'36px 40px'}}>
    <Mono style={{display:'block',marginBottom:12}}>{favorites.size} ПРОГРАММ В ИЗБРАННОМ</Mono>
    <h1 style={{fontFamily:displayFont.style.fontFamily,fontSize:32,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:8}}>Избранное</h1>

    {compareList.length>=2&&(
      <div style={{display:'flex',alignItems:'center',gap:12,marginBottom:24,
        padding:'12px 16px',borderRadius:8,background:`${gold}0A`,border:`1px solid ${gold}30`}}>
        <span style={{fontFamily:sans,fontSize:13,color:t2,flex:1}}>
          Выбрано {compareList.length} программы для сравнения
        </span>
        <button onClick={()=>setCompareList([])}
          style={{background:'none',border:'none',color:t3,cursor:'pointer',fontSize:12,fontFamily:sans}}>
          Сбросить
        </button>
      </div>
    )}

    {favorites.size===0?(
      <div style={{padding:'40px 0',textAlign:'center'}}>
        <div style={{fontFamily:sans,fontWeight:600,fontSize:18,color:t3,marginBottom:8}}>Пусто</div>
        <div style={{fontFamily:sans,fontSize:13,color:t3}}>Добавляй программы через ♡ в списке</div>
      </div>
    ):(
      <>
        <div style={{border:`1px solid ${line}`,borderRadius:8,overflow:'hidden',marginBottom:24}}>
          {unis.filter((u:any)=>favorites.has(u.id)).map((u:any,i:number,arr:any[])=>(
            <div key={u.id} className="hc"
              style={{display:'grid',gridTemplateColumns:'1fr 40px 60px 110px 60px 140px 70px',
              padding:'16px 20px',alignItems:'center',cursor:'pointer',
              borderBottom:i<arr.length-1?`1px solid ${line}`:'none',
              background:compareList.includes(u.id)?'rgba(255,255,255,.04)':'transparent',
              transition:'all .15s'}}
              onClick={()=>{setSelectedProgram(u);setVerdict(null)}}>
              <div>
                <div style={{display:'flex',alignItems:'center',gap:8,marginBottom:3}}>
                  <div style={{fontFamily:sans,fontSize:13,fontWeight:500,color:t1,letterSpacing:'-.01em'}}>{u._n}</div>
                  <VerifiedBadge verified={u.verified}/>
                </div>
                <div style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:6}}>{u._p}</div>
                <div style={{display:'flex',alignItems:'center',gap:8}}>
                  <span style={{fontFamily:mono,fontSize:9,color:BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].color}}>
                    {BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].label.toUpperCase()}
                  </span>
                </div>
              </div>
              <button onClick={(e)=>toggleCompare(u.id,e)}
                style={{background:'none',border:`1px solid ${compareList.includes(u.id)?gold:line}`,
                  borderRadius:4,cursor:'pointer',padding:'4px 6px',
                  color:compareList.includes(u.id)?gold:t3,fontSize:9,fontFamily:mono,
                  transition:'all .15s',justifySelf:'center'}}>
                {compareList.includes(u.id)?'✓':'сравн'}
              </button>
              <span style={{justifySelf:'center'}} title={CNAME[u._country]||u._country}>
                <Flag code={u._country}/>
              </span>
              <Mono style={{color:t2}}>{u._cost}</Mono>
              <div style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:18,color:BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].color}}>{u._score}</div>
              <select
                value={favorites.get(u.id)?.status ?? 'not_applied'}
                onClick={(e)=>e.stopPropagation()}
                onChange={(e)=>updateApplicationStatus(u.id, e.target.value as ApplicationStatus, e)}
                style={{background:bg1,border:`1px solid ${line}`,borderRadius:4,cursor:'pointer',
                  padding:'4px 6px',fontSize:10,fontFamily:mono,justifySelf:'center',width:'100%',
                  color:STATUS_CFG[favorites.get(u.id)?.status ?? 'not_applied'].color}}>
                {(Object.keys(STATUS_CFG) as ApplicationStatus[]).map(s=>(
                  <option key={s} value={s} style={{color:t1,background:bg1}}>{STATUS_CFG[s].label}</option>
                ))}
              </select>
              <button onClick={(e)=>toggleFavorite(u.id,e)}
                style={{background:'none',border:'none',cursor:'pointer',color:gold,fontSize:16,padding:'4px'}}>♥</button>
            </div>
          ))}
        </div>

        {compareList.length>=2&&(()=>{
          const compared = unis.filter((u:any)=>compareList.includes(u.id))
          return (
            <div>
              <Mono style={{display:'block',marginBottom:16}}>СРАВНЕНИЕ</Mono>
              <div style={{overflowX:'auto'}}>
                <table style={{width:'100%',borderCollapse:'collapse'}}>
                  <thead>
                    <tr>
                      <td style={{padding:'10px 16px',fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',borderBottom:`1px solid ${line}`}}>КРИТЕРИЙ</td>
                      {compared.map((u:any)=>(
                        <td key={u.id} style={{padding:'10px 16px',fontFamily:sans,fontSize:12,color:t1,fontWeight:500,borderBottom:`1px solid ${line}`,borderLeft:`1px solid ${line}`}}>
                          {u._n}<br/><span style={{color:t3,fontSize:11,fontWeight:400}}>{u._p}</span>
                        </td>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {[
                      {l:'Примерная оценка', fn:(u:any)=><span style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:16,color:BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].color}}>{u._score}</span>},
                      {l:'Данные', fn:(u:any)=><VerifiedBadge verified={u.verified}/>},
                      {l:'Корзина',     fn:(u:any)=>BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].label},
                      {l:'Стоимость',   fn:(u:any)=>u._cost},
                      {l:'Рейтинг QS', fn:(u:any)=>u._rank},
                      {l:'IELTS min',  fn:(u:any)=>u.ielts_min||'6.5'},
                      {l:'Дедлайн',    fn:(u:any)=><span style={{color:u._days<30?red:t2}}>{u._days} дн.</span>},
                      {l:'Страна',     fn:(u:any)=><Flag code={u._country}/>},
                    ].map((row,ri)=>(
                      <tr key={ri}>
                        <td style={{padding:'12px 16px',fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em',borderBottom:`1px solid ${line}`}}>{row.l}</td>
                        {compared.map((u:any)=>(
                          <td key={u.id} style={{padding:'12px 16px',fontFamily:sans,fontSize:13,color:t2,borderBottom:`1px solid ${line}`,borderLeft:`1px solid ${line}`}}>
                            {row.fn(u)}
                          </td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )
        })()}
      </>
    )}
  </div>
)}
{tab==='applications'&&(()=>{
  const APP_COLUMNS: ApplicationStatus[] = ['applied','interview','offer','rejected']
  const appliedUnis = unis.filter((u:any)=>{
    const s = favorites.get(u.id)?.status
    return s && s!=='not_applied'
  })
  return (
    <div style={{padding:'36px 40px'}}>
      <Mono style={{display:'block',marginBottom:12}}>{appliedUnis.length} АКТИВНЫХ ЗАЯВОК</Mono>
      <h1 style={{fontFamily:displayFont.style.fontFamily,fontSize:32,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:24}}>Заявки</h1>

      {appliedUnis.length===0?(
        <div style={{padding:'40px 0',textAlign:'center'}}>
          <div style={{fontFamily:sans,fontWeight:600,fontSize:18,color:t3,marginBottom:8}}>Пока пусто</div>
          <div style={{fontFamily:sans,fontSize:13,color:t3}}>Смени статус программы на «Подано» во вкладке «Избранное», когда отправишь заявку</div>
        </div>
      ):(
        <div style={{overflowX:'auto'}}>
          <div style={{display:'grid',gridTemplateColumns:'repeat(4,minmax(220px,1fr))',gap:16,alignItems:'start',minWidth:900}}>
            {APP_COLUMNS.map(col=>{
              const items = unis.filter((u:any)=>favorites.get(u.id)?.status===col)
              return (
                <div key={col}>
                  <div style={{display:'flex',alignItems:'center',gap:8,marginBottom:12,paddingBottom:8,borderBottom:`2px solid ${STATUS_CFG[col].color}`}}>
                    <span style={{fontFamily:mono,fontSize:10,letterSpacing:'.06em',color:STATUS_CFG[col].color}}>{STATUS_CFG[col].label.toUpperCase()}</span>
                    <span style={{fontFamily:mono,fontSize:10,color:t3}}>{items.length}</span>
                  </div>
                  <div style={{display:'flex',flexDirection:'column',gap:10}}>
                    {items.map((u:any)=>{
                      const fav = favorites.get(u.id)!
                      const days = Math.floor((Date.now()-new Date(fav.status_updated_at).getTime())/86400000)
                      return (
                        <div key={u.id} onClick={()=>{setSelectedProgram(u);setVerdict(null)}}
                          className="hc"
                          style={{border:`1px solid ${line}`,borderRadius:8,padding:'12px 14px',cursor:'pointer',background:bg1}}>
                          <div style={{display:'flex',alignItems:'center',gap:6,marginBottom:4}}>
                            <div style={{fontFamily:sans,fontSize:12,fontWeight:500,color:t1,letterSpacing:'-.01em'}}>{u._n}</div>
                            <VerifiedBadge verified={u.verified}/>
                          </div>
                          <div style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:8}}>{u._p}</div>
                          <div style={{display:'flex',alignItems:'center',gap:6,marginBottom:8,flexWrap:'wrap'}}>
                            <span title={CNAME[u._country]||u._country}><Flag code={u._country} size={16}/></span>
                            <Mono style={{color:t2}}>{u._cost}</Mono>
                            <span style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:14,color:BUCKET_CFG[u._bucket as keyof typeof BUCKET_CFG].color}}>{u._score}</span>
                          </div>
                          <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',gap:8}}>
                            <span style={{fontFamily:mono,fontSize:9,color:t3}}>{days<=0?'сегодня':`${days} дн. в статусе`}</span>
                            <select
                              value={col}
                              onClick={(e)=>e.stopPropagation()}
                              onChange={(e)=>updateApplicationStatus(u.id, e.target.value as ApplicationStatus, e)}
                              style={{background:bg0,border:`1px solid ${line}`,borderRadius:4,cursor:'pointer',
                                padding:'3px 5px',fontSize:9,fontFamily:mono,color:STATUS_CFG[col].color}}>
                              {(Object.keys(STATUS_CFG) as ApplicationStatus[]).map(s=>(
                                <option key={s} value={s} style={{color:t1,background:bg0}}>{STATUS_CFG[s].label}</option>
                              ))}
                            </select>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                </div>
              )
            })}
          </div>
        </div>
      )}
    </div>
  )
})()}
{tab==='settings'&&(
  <div style={{padding:'36px 40px',maxWidth:560}}>
    <Mono style={{display:'block',marginBottom:12}}>НАСТРОЙКИ</Mono>
    <h1 style={{fontFamily:displayFont.style.fontFamily,fontSize:32,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:32}}>Профиль</h1>

    {/* GPA */}
    <div style={{marginBottom:28}}>
      <div style={{display:'flex',justifyContent:'space-between',marginBottom:12}}>
        <Mono>GPA</Mono>
        <Mono style={{color:t1}}>{profile.gpa?.toFixed(1)} / 5</Mono>
      </div>
      <input type="range" min="2.5" max="5.0" step="0.1"
        value={profile.gpa||4.0}
        onChange={e=>setProfile((p:any)=>({...p,gpa:parseFloat(e.target.value)}))}
        style={{width:'100%',height:2,background:'rgba(255,255,255,.1)',borderRadius:1,outline:'none',cursor:'pointer',appearance:'none',WebkitAppearance:'none'}}/>
    </div>

    <div style={{height:1,background:line,marginBottom:28}}/>

    {/* IELTS */}
    <div style={{marginBottom:28}}>
      <div style={{display:'flex',justifyContent:'space-between',marginBottom:12}}>
        <Mono>IELTS</Mono>
        <Mono style={{color:profile.ielts>=6.5?grn:red}}>{profile.ielts?.toFixed(1)}</Mono>
      </div>
      <input type="range" min="4.0" max="9.0" step="0.5"
        value={profile.ielts||6.5}
        onChange={e=>setProfile((p:any)=>({...p,ielts:parseFloat(e.target.value)}))}
        style={{width:'100%',height:2,background:'rgba(255,255,255,.1)',borderRadius:1,outline:'none',cursor:'pointer',appearance:'none',WebkitAppearance:'none'}}/>
    </div>

    <div style={{height:1,background:line,marginBottom:28}}/>

    {/* Опыт работы */}
    <div style={{marginBottom:28}}>
      <Mono style={{display:'block',marginBottom:12}}>ОПЫТ РАБОТЫ</Mono>
      <div style={{display:'flex',flexDirection:'column',gap:4}}>
        {[
          {v:'no',  l:'Нет'},
          {v:'some',l:'Немного — стажировка, проекты'},
          {v:'yes', l:'Есть — 1+ год'},
        ].map(o=>(
          <div key={o.v} onClick={()=>setProfile((p:any)=>({...p,work:o.v}))}
            style={{display:'flex',alignItems:'center',gap:12,padding:'12px 14px',borderRadius:6,
              background:profile.work===o.v?'rgba(255,255,255,.06)':'transparent',
              borderLeft:`2px solid ${profile.work===o.v?t1:'transparent'}`,
              cursor:'pointer',transition:'all .15s'}}>
            <div style={{width:14,height:14,borderRadius:'50%',flexShrink:0,
              border:`1.5px solid ${profile.work===o.v?t1:t3}`,
              background:profile.work===o.v?t1:'transparent'}}>
              {profile.work===o.v&&<div style={{width:6,height:6,background:bg0,borderRadius:'50%',margin:'3px auto'}}/>}
            </div>
            <span style={{fontFamily:sans,fontSize:13,color:profile.work===o.v?t1:t2}}>{o.l}</span>
          </div>
        ))}
      </div>
    </div>

    <div style={{height:1,background:line,marginBottom:28}}/>

    {/* Бюджет */}
    <div style={{marginBottom:28}}>
      <Mono style={{display:'block',marginBottom:12}}>БЮДЖЕТ</Mono>
      <div style={{display:'flex',flexDirection:'column',gap:4}}>
        {[
          {v:'zero',l:'Только стипендия'},
          {v:'low', l:'До €5 000 / год'},
          {v:'mid', l:'До €15 000 / год'},
          {v:'high',l:'Бюджет не проблема'},
        ].map(o=>(
          <div key={o.v} onClick={()=>setProfile((p:any)=>({...p,budget:o.v}))}
            style={{display:'flex',alignItems:'center',gap:12,padding:'12px 14px',borderRadius:6,
              background:profile.budget===o.v?'rgba(255,255,255,.06)':'transparent',
              borderLeft:`2px solid ${profile.budget===o.v?t1:'transparent'}`,
              cursor:'pointer',transition:'all .15s'}}>
            <div style={{width:14,height:14,borderRadius:'50%',flexShrink:0,
              border:`1.5px solid ${profile.budget===o.v?t1:t3}`,
              background:profile.budget===o.v?t1:'transparent'}}>
              {profile.budget===o.v&&<div style={{width:6,height:6,background:bg0,borderRadius:'50%',margin:'3px auto'}}/>}
            </div>
            <span style={{fontFamily:sans,fontSize:13,color:profile.budget===o.v?t1:t2}}>{o.l}</span>
          </div>
        ))}
      </div>
    </div>

    <div style={{height:1,background:line,marginBottom:28}}/>

    {/* Страны */}
    <div style={{marginBottom:28}}>
      <Mono style={{display:'block',marginBottom:12}}>СТРАНЫ</Mono>
      <div style={{display:'flex',flexWrap:'wrap',gap:6}}>
        {[
          {c:'de',l:'Германия'},{c:'nl',l:'Нидерланды'},{c:'se',l:'Швеция'},
          {c:'fi',l:'Финляндия'},{c:'ch',l:'Швейцария'},{c:'fr',l:'Франция'},
          {c:'at',l:'Австрия'},{c:'cz',l:'Чехия'},{c:'dk',l:'Дания'},
          {c:'be',l:'Бельгия'},{c:'ie',l:'Ирландия'},{c:'it',l:'Италия'},
          {c:'es',l:'Испания'},{c:'no',l:'Норвегия'},{c:'pl',l:'Польша'},
          {c:'hu',l:'Венгрия'},
        ].map(({c,l})=>{
          const sel = (profile.countries||'').split(',').includes(c)
          return (
            <button key={c} onClick={()=>{
              const curr = (profile.countries||'').split(',').filter(Boolean)
              const next = sel ? curr.filter((x:string)=>x!==c) : [...curr,c]
              setProfile((p:any)=>({...p,countries:next.join(',')}))
            }} style={{fontFamily:sans,fontSize:12,padding:'6px 12px',borderRadius:4,
              border:`1px solid ${sel?'rgba(255,255,255,.35)':line}`,
              background:sel?'rgba(255,255,255,.08)':'transparent',
              color:sel?t1:t2,cursor:'pointer',transition:'all .15s'}}>
              {l}
            </button>
          )
        })}
      </div>
    </div>

    {/* Сохранить */}
    <button onClick={async()=>{
      await supabase.from('profiles').update({
        gpa: profile.gpa,
        ielts: profile.ielts,
        work: profile.work,
        budget: profile.budget,
        countries: profile.countries,
      }).eq('user_id', profile.user_id)
      alert('Сохранено!')
    }} style={{width:'100%',padding:'13px',borderRadius:8,border:'none',
      background:t1,color:bg0,fontFamily:sans,fontSize:13,
      fontWeight:500,cursor:'pointer',letterSpacing:'-.01em'}}>
      Сохранить изменения
    </button>
  </div>
)}
{tab==='timeline'&&(
  <GanttTimeline profile={profile} programs={timelinePrograms}/>
)}
{tab==='scholarship-guide'&&(
  <div style={{padding:'36px 40px'}}>
    {countries.includes('hu')&&<HungaryGuide programs={programs} isPro={!!profile.is_pro}/>}
    {countries.includes('hu')&&countries.includes('it')&&(
      <div style={{height:1,background:line,margin:'40px 0'}}/>
    )}
    {countries.includes('it')&&<ItalyGuide programs={programs} isPro={!!profile.is_pro}/>}
  </div>
)}
      </main>
      {isMobile&&(
  <nav style={{position:'fixed',bottom:0,left:0,right:0,zIndex:50,
    background:'rgba(13,13,15,0.92)',backdropFilter:'blur(24px)',
    WebkitBackdropFilter:'blur(24px)',
    borderTop:`1px solid ${line}`,
    display:'flex',alignItems:'center',justifyContent:'space-around',
    padding:'10px 0 calc(12px + env(safe-area-inset-bottom))',
    boxShadow:'0 -1px 0 rgba(255,255,255,.04),0 -20px 40px rgba(0,0,0,.6)'}}>
    {[
      {id:'overview', label:'Обзор',    icon:<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/></svg>},
      {id:'unis',     label:'Программы',icon:<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><path d="M12 3L2 9l10 6 10-6-10-6z"/><path d="M2 17l10 6 10-6"/><path d="M2 13l10 6 10-6"/></svg>},
      {id:'journey',  label:'Journey',  icon:<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>},
      {id:'saved',    label:'Избранное',icon:<svg width="22" height="22" viewBox="0 0 24 24" fill={tab==='saved'||favorites.size>0?gold:"none"} stroke={favorites.size>0?gold:"currentColor"} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>},
      {id:'settings', label:'Профиль',  icon:<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>},
    ].map((n,idx)=>{
      const isActive = tab===n.id
      return (
        <button key={n.id} onClick={()=>{haptic();setTab(n.id)}}
          className="tactile"
          style={{display:'flex',flexDirection:'column',alignItems:'center',gap:4,
            background:'none',border:'none',cursor:'pointer',
            padding:'6px 14px',borderRadius:12,minWidth:60,
            color:isActive?t1:'rgba(255,255,255,.3)',
            transition:'color .2s'}}>
          <div style={{
            width:44,height:32,borderRadius:10,
            display:'flex',alignItems:'center',justifyContent:'center',
            background:isActive?'rgba(255,255,255,.1)':'transparent',
            transition:'all .25s cubic-bezier(.34,1.56,.64,1)',
            transform:isActive?'scale(1.05)':'scale(1)'}}>
            {n.icon}
          </div>
          <span style={{fontFamily:mono,fontSize:9,letterSpacing:'0.04em',
            color:isActive?t1:'rgba(255,255,255,.3)',
            fontWeight:isActive?500:400,
            transition:'all .2s'}}>
            {n.label}
          </span>
        </button>
      )
    })}
  </nav>
)}   </div>
  )
}
