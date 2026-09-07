'use client'
import Roadmap from './Roadmap'
import { useState, useEffect, useRef, useMemo } from 'react'
import { supabase } from '../../lib/supabase'
import GanttTimeline from './GanttTimeline'
import { bg0, bg1, line, t1, t2, t3, gold, blue, red, grn, purp, amb, sans, serif, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'
import VerifiedBadge from '@/components/VerifiedBadge'
import HungaryGuide from './HungaryGuide'
import ItalyGuide from './ItalyGuide'
import GermanyReality from './GermanyReality'
import NetherlandsReality from './NetherlandsReality'
import { MASTER_FIELDS, FIELD_TO_DB } from '@/lib/masterFields'
import { resolveAdmissionYear } from '@/lib/admissionYear'
import { startCheckout } from '@/lib/checkout'
import { hasGuideCoverage, GUIDE_COUNTRIES, GUIDE_COUNTRY_NAMES } from '@/lib/legal'
import { tuitionLabel, budgetState, type BudgetState } from '@/lib/tuition'
import { isDeadLink } from '@/lib/linkHealth'
import { readinessScore } from '@/lib/readiness'

/* ── country names ── */
const CNAME: Record<string,string> = {
  de:'Германия', nl:'Нидерланды', se:'Швеция',
  ch:'Швейцария', fi:'Финляндия', fr:'Франция',
  cz:'Чехия', at:'Австрия', hu:'Венгрия', it:'Италия',
  dk:'Дания', no:'Норвегия', be:'Бельгия', es:'Испания',
  ee:'Эстония', pl:'Польша', ie:'Ирландия',
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

// Скор — оценка шанса на поступление именно в эту программу, не общий
// рейтинг "насколько программа хороша". Переписан на логистическую модель
// (2026-09-03) вместо аддитивной с жёстким клампом: раньше сильный
// профиль легко пробивал 100 и слабый легко проваливался в 0 задолго до
// того, как реально кончались факторы — щипцы просто срезали хвосты,
// не давая честной картины "насколько именно уверенно". Логистическая
// кривая (100 / (1+e^-z)) сама насыщается на краях, поэтому даже очень
// сильный кандидат в очень слабую программу не покажет буквально 100% —
// как и в реальности, стопроцентных гарантий не бывает.
//
// Считаем "логит" z из независимых сигналов (каждый — вклад в log-odds),
// затем сжимаем в проценты:
// - IELTS: разрыв с минимумом программы, не бинарно "хватает/не хватает".
// - Бюджет: p.tuition_eur против реального лимита профиля — с усиленным
//   штрафом, если профиль явно требует именно стипендию (budget==='zero'),
//   а программа платная — это не "стретч", это структурно другой сценарий.
// - Селективность — раньше бралась только из QS-рейтинга вуза. Теперь,
//   если у программы есть свой acceptance_rate (колонка в БД, изредка
//   заполнена реальным поиском), используется он — это прямой сигнал
//   именно про ЭТУ программу, точнее, чем рейтинг всего вуза. QS — только
//   запасной вариант, когда acceptance_rate не собран.
// - GPA программы (`gpa_min`) сознательно НЕ используется — собранные
//   цифры разных стран на разных шкалах (немецкая 1.0-лучшая, американская
//   4.0-лучшая, часто вообще "3" как дефолт-заглушка модели при сборе,
//   не реальное требование) без явного поля шкалы сравнивать с profile.gpa
//   (российская шкала 3–5) значит сравнивать несравнимое и звать это
//   точностью. GPA студента вместо этого — независимый сигнал "насколько
//   сильный кандидат вообще", отдельно от порога конкретной программы.
// - Совпадение направления (master_direction) теперь ослабляется/усиливается
//   в зависимости от селективности — сменить направление почти не мешает
//   в непроходной программе, но реально бьёт по шансам в топовой.
// - Опыт работы — раньше вообще не учитывался в этом скоре (хотя собирается
//   в анкете). Для Business Analytics (это и MBA/Executive-программы тоже)
//   опыт весит заметно больше, чем для чисто академических технических
//   направлений, где решают оценки и портфолио, не стаж.
function calcScore(p: any, profile: any): number {
  let z = 0

  const gpa = profile.gpa ?? 4.0
  z += gpa >= 4.7 ? 2.0 : gpa >= 4.3 ? 1.2 : gpa >= 4.0 ? 0.5 : gpa >= 3.5 ? -0.5 : -1.5

  const ieltsMin = p.ielts_min || 6.5
  z += Math.max(-2, Math.min(2, profile.ielts - ieltsMin)) * 0.9

  const budgetLimit = BUDGET_LIMIT[profile.budget] ?? 15000
  // tuition_eur === null значит "неизвестно", не "бесплатно" (см.
  // lib/tuition.ts) — раньше непроверенная цена тихо приравнивалась к
  // нулю через нестрогое сравнение и получала бонус как за free-программу.
  // Неизвестность — это неопределённость, а не хорошая новость, так что
  // никакого бонуса, только небольшой минус за риск сюрприза с ценой.
  if (p.tuition_eur == null) z -= profile.budget === 'zero' ? 0.6 : 0.2
  else if (p.tuition_eur === 0) z += profile.budget === 'zero' ? 1.6 : 1.0
  else if (profile.budget === 'zero') z -= 2.2
  else if (p.tuition_eur <= budgetLimit) z += 0.4
  else if (p.tuition_eur <= budgetLimit * 1.3) z -= 0.7
  else z -= 1.7

  const qs = p.university?.ranking_qs
  const accRate = typeof p.acceptance_rate === 'number' ? p.acceptance_rate : null
  const sel = accRate !== null
    ? (accRate / 100 - 0.5) * 6
    : qs ? (qs <= 50 ? -4.0 : qs <= 150 ? -2.0 : qs <= 300 ? -0.6 : 0.8) : 0.3
  z += sel
  const selective = sel < -1.0

  if (profile.master_direction === 'change') z -= selective ? 1.6 : 0.9
  else if (profile.master_direction === 'related') z -= selective ? 0.5 : 0.25
  else if (profile.master_direction === 'same') z += 0.3

  if (p.field === 'Business Analytics') {
    z += profile.work === 'yes' ? 0.5 : profile.work === 'some' ? 0.2 : -0.1
  } else {
    z += profile.work === 'yes' ? 0.15 : 0
  }

  // При максимально сильном профиле z доходит до ~7, сигмоида на этом
  // участке уже практически 1 — округление показывало студенту "99%" или
  // "98%" шанс поступления, что читается как обещание гарантии, которую
  // ни один вуз никогда не даёт. Верхняя граница 90 — это честный "очень
  // сильный кандидат", а не "поступление предрешено".
  return Math.min(90, Math.max(4, Math.round(100 / (1 + Math.exp(-z)))))
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
// Полноэкранная заглушка для Pro-фич целиком (не частичный блюр, как
// ScholarshipLock — здесь скрывать нечего, просто фича недоступна на
// бесплатном тарифе). Платежа всё ещё нет — честно говорим об этом.
function ProUpsell({title,desc,countries}:{title:string,desc:string,countries?:string[]}) {
  const [buying,setBuying] = useState(false)
  const [error,setError] = useState<string|null>(null)
  // Страновые гайды — главная ценность Pro, но существуют они пока по
  // четырём странам. Если ни одна из выбранных не покрыта, честно
  // говорим об этом ДО оплаты: несостоявшаяся продажа дешевле возврата
  // и отзыва «обещали по каждой стране, а там пусто».
  const covered = hasGuideCoverage(countries)
  const onBuy = async () => {
    setBuying(true)
    setError(null)
    const res = await startCheckout()
    if (res.error) { setError(res.error); setBuying(false) }
    // при успехе — редирект на Lava.top
  }
  return (
    <div style={{flex:1,display:'flex',alignItems:'center',justifyContent:'center',padding:40}}>
      <div style={{maxWidth:420,textAlign:'center',padding:'36px 32px',borderRadius:12,
        background:bg1,border:`1px solid ${line}`,boxShadow:'0 20px 48px rgba(0,0,0,.35)'}}>
        <div style={{fontFamily:mono,fontSize:24,marginBottom:14}}>🔒</div>
        <div style={{fontFamily:displayFont.style.fontFamily,fontSize:20,fontWeight:800,color:t1,marginBottom:10,letterSpacing:'-.01em'}}>{title}</div>
        <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.6,marginBottom:16}}>{desc}</p>
        {!covered&&countries&&countries.length>0&&(
          <div style={{padding:'11px 13px',marginBottom:16,borderRadius:8,textAlign:'left',
            background:`${gold}12`,border:`1px solid ${gold}45`}}>
            <p style={{fontFamily:sans,fontSize:11.5,color:gold,lineHeight:1.55,margin:0}}>
              Подробные разборы визы, оплаты и документов есть пока по 4 странам:{' '}
              {GUIDE_COUNTRIES.map(c=>GUIDE_COUNTRY_NAMES[c]).join(', ')}. Твоих стран
              среди них нет — оплатив, ты получишь безлимитное избранное, таймлайн и
              ИИ-анализ, но не страновой гайд.
            </p>
          </div>
        )}
        <div style={{fontFamily:sans,fontSize:22,fontWeight:700,color:t1,marginBottom:2}}>2 990 ₽</div>
        <p style={{fontFamily:sans,fontSize:11,color:t2,marginBottom:18}}>разово, без подписки</p>
        <button onClick={onBuy} disabled={buying} style={{width:'100%',padding:'13px',borderRadius:8,border:'none',
          background:gold,color:bg0,fontFamily:sans,fontSize:13,fontWeight:600,cursor:buying?'not-allowed':'pointer',
          letterSpacing:'-.01em',marginBottom:error?10:0,opacity:buying?0.7:1}}>
          {buying?'Открываем оплату…':'Разблокировать Pro'}
        </button>
        {error&&(
          <p style={{fontFamily:sans,fontSize:11,color:red,lineHeight:1.5}}>
            {error}
          </p>
        )}
      </div>
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
const [verdictLocked, setVerdictLocked] = useState(false)
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

  // Supabase/PostgREST молча обрезает любой .select() без .range() на 1000
  // строк, даже без явного .limit() в коде — при 1420 программах в базе
  // это тихо прятало из дашборда почти все свежесобранные страны (Дания,
  // Ирландия, Испания и т.д.), никак не сигнализируя об ошибке. Пагинируем.
  ;(async () => {
    const all: any[] = []
    for (let from = 0; ; from += 1000) {
      const { data } = await supabase
        .from('programs')
        .select('*, university:universities(*)')
        .range(from, from + 999)
      if (!data?.length) break
      all.push(...data)
      if (data.length < 1000) break
    }
    // 'other:...' — свободный текст с шага "Другое" в анкете (см. app/page.tsx,
    // аудит 2026-09-07): направления нет в базе, поэтому фильтр по полю
    // отключаем совсем, как и для честно пустого master_field, а не
    // сравниваем с текстом буквально (иначе совпадений не будет никогда).
    const masterField = profile.master_field?.startsWith('other:') ? '' : (profile.master_field || '')
    const filtered = all.filter(p =>
      p.university &&
      countries.includes(p.university.country) &&
      (!masterField || p.field === masterField)
    )
    setPrograms(filtered)
  })()
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

// Хуки нельзя вызывать после условного return (loading/!profile ниже) —
// иначе React видит разное число хуков между рендерами ("Rendered more
// hooks than during the previous render"). Раньше это было ниже условных
// return, пересчитывалось на каждый рендер и было безопасно только потому,
// что не было хуком; став useMemo, обязано стоять до них. Пока profile
// ещё null, programs всегда [] (см. useEffect выше), так что calcScore
// здесь ни разу не вызывается с profile=null.
// COLORS/daysUntil подняты сюда же (были объявлены через const ниже
// условных return) — иначе useMemo обращался бы к ним раньше инициализации
// (temporal dead zone) и падал бы с ReferenceError на каждом рендере.
const COLORS = ['#6B8CFF','#3FB950','#C8A256','#A78BFA','#5AC8FA','#E8795A','#D4843A','#E5534B']
const daysUntil = (month: number, day: number) => {
  const now = new Date()
  const d = new Date(now.getFullYear(), month - 1, day)
  if (d < now) d.setFullYear(d.getFullYear() + 1)
  return Math.ceil((d.getTime() - now.getTime()) / 86400000)
}
// MBA/Executive-программы почти всегда требуют реального стажа (обычно
// 3+ года) — раньше показывались всем наравне с обычной магистратурой,
// и Executive MBA за €105 000 мог оказаться первой строкой у выпускника
// бакалавриата без единого дня опыта (см. аудит продукта 2026-09-07).
// requires_work_years проставлен точечно для 20 MBA/Executive программ
// (см. CLAUDE.md) — "some" (стажировки/проекты) всё ещё не считается
// достаточным для формата, рассчитанного на practicing managers.
const qualifiesForExperienceGated = (p: any, profile: any) =>
  p.requires_work_years == null || profile.work === 'yes'

const unis = useMemo(() => diversifyByCountry(programs.filter((p:any) => qualifiesForExperienceGated(p, profile)).map((p: any, i: number) => {
  const score = calcScore(p, profile)
  // Раньше программа дороже заявленного бюджета просто получала более
  // низкий скор — студент, сказавший "нужно бесплатно", не видел НИКАКОГО
  // прямого сигнала, что показанный вариант вообще не подходит под его
  // ограничение, только менее заметное отличие в цифре скора.
  const budgetLimit = BUDGET_LIMIT[profile.budget] ?? 15000
  return {
    ...p,
    _n: p.university?.name || '',
    _p: p.name,
    _days: daysUntil(p.deadline_month, p.deadline_day),
    _cost: tuitionLabel(p),
    _budgetState: budgetState(p, budgetLimit) as BudgetState,
    _rank: p.university?.ranking_qs ? `#${p.university.ranking_qs} QS` : '—',
    _c: COLORS[i % COLORS.length],
    _country: p.university?.country || '',
    _score: score,
    _bucket: getBucket(score),
  }
})), [programs, profile])

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
// Раньше был просто .sort() по скору — при нескольких выбранных странах
// это на практике давало длинные однородные блоки ("сначала все немецкие,
// потом все итальянские"), потому что скор внутри одной страны склонен
// кучковаться (похожая стоимость/селективность вузов). Список от этого
// читался как "подборки по странам", а не как единый ранжированный шорт-
// лист. Диверсификация ниже сохраняет сортировку по скору ВНУТРИ каждой
// страны, но подмешивает страны друг в друга при выдаче: на каждом шаге
// берём лучший ещё не показанный вариант среди стран, отличных от той,
// что была на предыдущем месте (если такая ещё осталась) — соседние
// карточки почти никогда не совпадают по стране, а порядок всё равно
// в целом идёт от сильных к слабым, а не вперемешку случайно.
function diversifyByCountry<T extends { _country: string; _score: number }>(items: T[]): T[] {
  const byCountry = new Map<string, T[]>()
  for (const it of items) {
    if (!byCountry.has(it._country)) byCountry.set(it._country, [])
    byCountry.get(it._country)!.push(it)
  }
  for (const arr of byCountry.values()) arr.sort((a, b) => b._score - a._score)
  const countries = [...byCountry.keys()]
  const result: T[] = []
  let lastCountry: string | null = null
  while (result.length < items.length) {
    let bestCountry: string | null = null
    let bestScore = -Infinity
    const hasOther = countries.some(c => c !== lastCountry && byCountry.get(c)!.length > 0)
    for (const c of countries) {
      const arr = byCountry.get(c)!
      if (!arr.length) continue
      if (hasOther && c === lastCountry) continue
      if (arr[0]._score > bestScore) { bestScore = arr[0]._score; bestCountry = c }
    }
    if (bestCountry === null) bestCountry = countries.find(c => byCountry.get(c)!.length > 0)!
    result.push(byCountry.get(bestCountry)!.shift()!)
    lastCountry = bestCountry
  }
  return result
}


// Программы для таймлайна/Journey — ТОЛЬКО реальное избранное. Раньше при
// пустом избранном сюда тихо подставлялся один случайный топ-матч на
// страну — Journey и Таймлайн называли конкретные вузы и считали дни до
// их дедлайнов так, будто это осознанный выбор студента, хотя он ещё
// ничего не добавил (см. аудит продукта 2026-09-07). Пустой список —
// честное состояние, оба компонента сами показывают "добавь программы".
// (Не useMemo — просто выражение, как и раньше: unis уже useMemo выше,
// а сам фильтр здесь после ранних return'ов, где хуки звать нельзя.)
const timelinePrograms = unis.filter((u: any) => favorites.has(u.id))
const haptic = (ms=8) => {
  if(typeof navigator !== 'undefined' && navigator.vibrate) navigator.vibrate(ms)
}

// Бесплатный тариф — 1 программа в избранном (см. память проекта:
// "Free forever — ... 1 favorite"). Раньше лимита не было вообще —
// вся ценность Pro-тарифа ("unlimited favorites") доставалась бесплатно.
// Проверка на клиенте — это лимит на удобство, а не защита секретных
// данных (в отличие от гайдов), так что этого достаточно.
const FREE_FAVORITES_LIMIT = 1
const toggleFavorite = async (programId: string, e: React.MouseEvent) => {
  e.stopPropagation()
  const isFav = favorites.has(programId)
  if (!isFav && !profile.is_pro && favorites.size >= FREE_FAVORITES_LIMIT) {
    // Текст говорил "оплата пока не подключена" — устарело с 2026-09-07,
    // Lava.top подключён. Это худшее место для такой опечатки: человек
    // упёрся в лимит, то есть уже хочет заплатить, а мы ему сообщаем,
    // что не можем взять деньги. Ведём в чек-аут.
    if (confirm(`На бесплатном тарифе можно сохранить ${FREE_FAVORITES_LIMIT} программу в избранное.\n\nБезлимитное избранное, сравнение, таймлайн и ИИ-анализ — в Pro за 2 990 ₽ разово.\n\nОткрыть оплату?`)) {
      const { error } = await startCheckout()
      if (error) alert(error)
    }
    return
  }
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
  setVerdictLocked(false)
  setVerdictLoading(true)
  // Без таймаута зависший прокси/AI-запрос вешал кнопку "Анализируем..."
  // на неопределённое время. Живой прогон показал большой разброс:
  // прямой вызов без клиентского вмешательства занял 12s, но браузерные
  // прогоны стабильно упирались в таймаут 25s и затем 45s — реальная
  // задержка прокси местами превышает даже это. 60s — компромисс между
  // "не ждать вечно" и "не рвать медленный, но живой ответ".
  const abort = new AbortController()
  const timer = setTimeout(() => abort.abort(), 60000)
  try {
    const { data: { session } } = await supabase.auth.getSession()
    const res = await fetch('/api/verdict', {
      method: 'POST',
      headers: {
        'Content-Type':'application/json',
        ...(session ? { Authorization: `Bearer ${session.access_token}` } : {}),
      },
      body: JSON.stringify({
        program: { ...p, university_name: p.university?.name },
        profile,
      }),
      signal: abort.signal,
    })
    const data = await res.json()
    if (res.status === 403 && data?.locked) {
      setVerdictError('Персональный анализ — платная функция Pro.')
      setVerdictLocked(true)
    } else if (!res.ok) {
      setVerdictError('Не получилось получить анализ — попробуй позже')
    } else {
      setVerdict(data)
    }
  } catch (e) {
    console.error(e)
    setVerdictError('Не получилось получить анализ — попробуй позже')
  } finally {
    clearTimeout(timer)
  }
  setVerdictLoading(false)
}

    // Теперь общая с лендингом (app/page.tsx) — см. lib/readiness.ts,
    // раньше это была отдельная копия формулы, из-за чего один и тот же
    // профиль показывал разные проценты на лендинге и в кабинете.
    const score = readinessScore(profile)
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
  // Раньше вкладка появлялась только у выбравших Венгрию или Италию —
  // остальные (в том числе большинство, кто идёт в Германию/Нидерланды)
  // вообще не видели, что в Pro есть русский слой (виза/оплата/документы),
  // не только гайды по стипендиям (см. аудит продукта 2026-09-07).
  {id:'reality', l:'Реальность · PRO'},
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
                {countries.map((c:string)=>c.toUpperCase()).join(' · ')} · {profile.field} · {resolveAdmissionYear(profile.timeline)}
              </Mono>
            </div>

            {/* KPI */}
            <div style={{display:'grid',gridTemplateColumns:'repeat(4,1fr)',borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:28}}>
              {[
                {l:'ГОТОВНОСТЬ',       v:`${score}%`},
                {l:'ПРОГРАММ',         v:`${unis.length}`},
                {l:'GPA',              v:`${profile.gpa} / 5`},
                {l:'ЯЗЫК',             v: profile.ielts ? `${profile.ielts}` : 'нет', warn:profile.ielts<6.5},
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
                  {profile.ielts ? `Языковой балл ${profile.ielts} — ниже минимума 6.5.` : 'Сертификата ещё нет.'} Без результата 6.5+ ни один вуз не примет заявку. TOEFL/Duolingo сдаются онлайн из России, если программа их принимает — уточни в требованиях; другие языковые экзамены обычно доступны только за пределами РФ, от ~$200.
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
                  {done:profile.ielts>=6.5,t:'Сдать языковой экзамен на 6.5+',u:profile.ielts<6.5},
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

            {/* баннер вкладки "Реальность" — единственный вход на мобиле, т.к. в
                нижнем нав-баре мобилы всего 5 иконок и своей вкладки там нет.
                Теперь видна всем странам, не только HU/IT (см. выше). */}
            <button onClick={()=>setTab('reality')} style={{
              display:'flex',alignItems:'center',justifyContent:'space-between',gap:14,
              width:'100%',marginTop:16,padding:'16px 18px',borderRadius:8,
              border:`1px solid ${gold}40`,background:`${gold}0D`,cursor:'pointer',
              textAlign:'left',fontFamily:'inherit'}}>
              <div>
                <Mono style={{display:'block',color:gold,marginBottom:4}}>РЕАЛЬНОСТЬ · PRO</Mono>
                <div style={{fontFamily:sans,fontSize:13,color:t1,fontWeight:500}}>
                  Виза, оплата и документы для гражданина РФ по твоим странам
                </div>
              </div>
              <span style={{fontFamily:sans,fontSize:18,color:gold,flexShrink:0}}>→</span>
            </button>
          </div>
        )}

        {/* ══ JOURNEY ══ */}
        {tab==='journey'&&(
  <div style={{height:'100%',display:'flex',flexDirection:'column'}}>
   <Roadmap profile={profile} programs={timelinePrograms} taskDone={taskDone} onToggle={toggleTask}/>
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
    {(() => {
      // Честный счётчик наверху — раньше бюджет спрашивали в анкете и
      // почти не использовали: сортировка была только по шансу поступить,
      // "⚠ дороже бюджета" стояло почти на каждой платной строке и
      // переставало что-либо сообщать (см. аудит продукта 2026-09-07).
      const order: Record<BudgetState,number> = { fits:0, scholarship:1, over:2 }
      const fitsN = unis.filter((u:any)=>u._budgetState==='fits').length
      const scholarshipN = unis.filter((u:any)=>u._budgetState==='scholarship').length
      const overN = unis.filter((u:any)=>u._budgetState==='over').length
      if (!unis.length) return null
      return (
        <div style={{marginBottom:20,padding:'12px 16px',borderRadius:8,background:'rgba(255,255,255,.03)',border:`1px solid ${line}`,display:'flex',gap:18,flexWrap:'wrap',fontFamily:sans,fontSize:12}}>
          <span style={{color:t1}}><b style={{color:grn}}>{fitsN}</b> в бюджет</span>
          {scholarshipN>0 && <span style={{color:t2}}><b style={{color:gold}}>{scholarshipN}</b> — нужна стипендия или цена уточняется</span>}
          {overN>0 && <span style={{color:t2}}><b style={{color:red}}>{overN}</b> — не по бюджету</span>}
        </div>
      )
    })()}
    {(['reach','target','safety'] as const).map(bucket => {
      const items = unis.filter((u:any) => u._bucket === bucket)
        .sort((a:any,b:any)=>{
          const order: Record<BudgetState,number> = { fits:0, scholarship:1, over:2 }
          return order[a._budgetState as BudgetState] - order[b._budgetState as BudgetState]
        })
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
                    {/* Про мёртвую ссылку честнее предупредить прямо в
                        списке, а не только внутри карточки — иначе про
                        неё узнаёшь, уже кликнув (см. isDeadLink). */}
                    {isDeadLink(u.url_status)&&(
                      <span title="Официальная страница программы не открылась при последней проверке"
                        style={{fontFamily:mono,fontSize:9,fontWeight:700,color:gold,
                          border:`1px solid ${gold}55`,borderRadius:3,padding:'1px 4px',
                          letterSpacing:'.04em',whiteSpace:'nowrap'}}>⚠ ССЫЛКА</span>
                    )}
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
                <Mono style={{color:u._budgetState==='over'?red:u._budgetState==='scholarship'?gold:t2}}>
                  {u._budgetState==='over'?'⚠ ':u._budgetState==='scholarship'?'🎓 ':''}{u._cost}
                </Mono>
                <div style={{fontFamily:displayFont.style.fontFamily,fontWeight:800,fontSize:18,color:cfg.color}}>{u._score}</div>
                <Mono style={{color:u._days<30?red:t2}}>{u._days} дн.</Mono>
              </div>
            ))}
          </div>
        </div>
      )
    })}
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
                      {l:'Язык, мин.', fn:(u:any)=>u.ielts_min||'6.5'},
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

    {/* языковой балл */}
    <div style={{marginBottom:28}}>
      <div style={{display:'flex',justifyContent:'space-between',marginBottom:12}}>
        <Mono>ЯЗЫКОВОЙ ЭКЗАМЕН</Mono>
        <Mono style={{color:profile.ielts>=6.5?grn:red}}>{profile.ielts ? profile.ielts.toFixed(1) : 'нет'}</Mono>
      </div>
      {/* Раньше пустой балл (никогда не сдавал) молча показывался как 6.5 —
          ровно проходной порог, будто экзамен уже сдан (см. аудит продукта
          2026-09-07). Теперь пустое значение — это 4.0, низ шкалы, а не
          подарок в виде готового результата. */}
      <input type="range" min="4.0" max="9.0" step="0.5"
        value={profile.ielts||4.0}
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

    {/* Направление магистратуры — раньше это спрашивалось только один раз
        при заполнении анкеты и больше нигде не редактировалось. С тех пор
        как это поле стало реально влиять на подбор программ и скор (см.
        calcScore выше), у существующих пользователей должна быть
        возможность его поправить — например, если авто-подстановка при
        регистрации угадала неточно, или человек передумал про направление. */}
    <div style={{marginBottom:28}}>
      <Mono style={{display:'block',marginBottom:12}}>НАПРАВЛЕНИЕ МАГИСТРАТУРЫ</Mono>
      <div style={{display:'flex',flexDirection:'column',gap:4,marginBottom:14}}>
        {[
          {v:'same',   l:'Продолжаю в той же сфере'},
          {v:'related',l:'Смежная область'},
          {v:'change', l:'Кардинально другое направление'},
        ].map(o=>(
          <div key={o.v} onClick={()=>{
            setProfile((p:any)=>{
              const next = {...p, master_direction:o.v}
              if(o.v==='same' && !p.master_field) next.master_field = FIELD_TO_DB[p.field] || ''
              return next
            })
          }} style={{display:'flex',alignItems:'center',gap:12,padding:'12px 14px',borderRadius:6,
            background:profile.master_direction===o.v?'rgba(255,255,255,.06)':'transparent',
            borderLeft:`2px solid ${profile.master_direction===o.v?t1:'transparent'}`,
            cursor:'pointer',transition:'all .15s'}}>
            <div style={{width:14,height:14,borderRadius:'50%',flexShrink:0,
              border:`1.5px solid ${profile.master_direction===o.v?t1:t3}`,
              background:profile.master_direction===o.v?t1:'transparent'}}>
              {profile.master_direction===o.v&&<div style={{width:6,height:6,background:bg0,borderRadius:'50%',margin:'3px auto'}}/>}
            </div>
            <span style={{fontFamily:sans,fontSize:13,color:profile.master_direction===o.v?t1:t2}}>{o.l}</span>
          </div>
        ))}
      </div>
      <div style={{fontFamily:sans,fontSize:12,color:t3,marginBottom:10,lineHeight:1.5}}>
        Точное направление — от этого зависит, какие программы тебе показывают:
      </div>
      <div style={{display:'flex',flexWrap:'wrap',gap:6}}>
        {MASTER_FIELDS.map(f=>(
          <button key={f.v} onClick={()=>setProfile((p:any)=>({...p,master_field:f.v}))}
            style={{fontFamily:sans,fontSize:12,padding:'6px 12px',borderRadius:4,
              border:`1px solid ${profile.master_field===f.v?'rgba(255,255,255,.35)':line}`,
              background:profile.master_field===f.v?'rgba(255,255,255,.08)':'transparent',
              color:profile.master_field===f.v?t1:t2,cursor:'pointer',transition:'all .15s'}}>
            {f.l}
          </button>
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
          // Порядок совпадает с анкетой (COUNTRIES_MAIN/MORE в
          // app/page.tsx) — сначала страны с самым полным каталогом и
          // русскоязычным гайдом, потом остальные. Держать синхронно:
          // если меняешь порядок там, поменяй и здесь.
          {c:'de',l:'Германия'},{c:'it',l:'Италия'},{c:'nl',l:'Нидерланды'},
          {c:'hu',l:'Венгрия'},{c:'fr',l:'Франция'},{c:'es',l:'Испания'},
          {c:'at',l:'Австрия'},{c:'cz',l:'Чехия'},{c:'se',l:'Швеция'},
          {c:'ie',l:'Ирландия'},{c:'dk',l:'Дания'},{c:'ch',l:'Швейцария'},
          {c:'fi',l:'Финляндия'},{c:'be',l:'Бельгия'},{c:'ee',l:'Эстония'},
          {c:'no',l:'Норвегия'},{c:'pl',l:'Польша'},
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
        master_field: profile.master_field,
        master_direction: profile.master_direction,
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
  profile.is_pro
    ? <GanttTimeline profile={profile} programs={timelinePrograms}/>
    : <ProUpsell title="Таймлайн — функция Pro"
        countries={countries}
        desc="Полный план-график от сегодня до переезда со всеми дедлайнами и экспортом в календарь (Google/Apple) — часть платного тарифа."/>
)}
{tab==='reality'&&(() => {
  // Раньше эта вкладка показывала только гайды по стипендиям HU/IT и была
  // не видна вообще, если ни одна из этих двух стран не выбрана — то есть
  // для большинства студентов (Германия/Нидерланды) русского слоя не было
  // ни в каком виде (см. аудит продукта 2026-09-07). Собираем блоки по
  // тем странам, что реально выбраны, с разделителем между ними.
  const blocks: React.ReactNode[] = []
  if (countries.includes('de')) blocks.push(<GermanyReality key="de" isPro={!!profile.is_pro}/>)
  if (countries.includes('nl')) blocks.push(<NetherlandsReality key="nl" isPro={!!profile.is_pro}/>)
  if (countries.includes('hu')) blocks.push(<HungaryGuide key="hu" programs={programs} isPro={!!profile.is_pro}/>)
  if (countries.includes('it')) blocks.push(<ItalyGuide key="it" programs={programs} isPro={!!profile.is_pro}/>)
  return (
    <div style={{padding:'36px 40px'}}>
      {blocks.length === 0 ? (
        <div style={{maxWidth:520}}>
          <Mono style={{display:'block',marginBottom:10}}>РЕАЛЬНОСТЬ · PRO</Mono>
          <div style={{fontFamily:displayFont.style.fontFamily,fontSize:24,color:t1,fontWeight:800,marginBottom:10}}>
            Пока не готово для твоих стран
          </div>
          <p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.6}}>
            Разбор визы, оплаты и документов для не-ЕС студентов сейчас есть по Германии, Нидерландам,
            Венгрии и Италии. По остальным странам добавляем постепенно — если это критично для тебя,
            напиши нам, что в первую очередь.
          </p>
        </div>
      ) : blocks.map((b, i) => (
        <div key={i}>
          {i > 0 && <div style={{height:1,background:line,margin:'40px 0'}}/>}
          {b}
        </div>
      ))}
    </div>
  )
})()}
      </main>
      {/* Раньше эта модалка жила внутри {tab==='unis'&&(...)} — открыть
          программу можно было только со вкладки «Вузы»; клик на карточку
          в «Избранном», «Заявках» и т.д. молча ничего не делал (selectedProgram
          обновлялся, но модалка не была смонтирована в дереве для этих вкладок).
          Вынесено на уровень выше — рендерится независимо от активной вкладки. */}
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
                    Оценка — грубая прикидка по языковому баллу/бюджету/рейтингу, не гарантия поступления.
                  </p>
                </div>
                <button onClick={()=>setSelectedProgram(null)}
                  style={{background:'none',border:'none',color:t3,cursor:'pointer',fontSize:20,padding:'0 0 0 16px',flexShrink:0}}>×</button>
              </div>
              <div style={{display:'grid',gridTemplateColumns:'repeat(3,1fr)',borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:24}}>
                {[
                  {l:'РЕЙТИНГ',v:selectedProgram._rank,color:t1},
                  {l:'СТОИМОСТЬ',v:selectedProgram._cost,color:selectedProgram._budgetState==='over'?red:selectedProgram._budgetState==='scholarship'?gold:t1},
                  {l:'ДЕДЛАЙН',v:`${selectedProgram._days} дн.`,color:selectedProgram._days<30?red:t1},
                ].map((m,i)=>(
                  <div key={i} style={{padding:'12px 14px',borderRight:`1px solid ${line}`,borderBottom:`1px solid ${line}`}}>
                    <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:4}}>{m.l}</div>
                    <div style={{fontFamily:sans,fontSize:13,color:m.color}}>{m.v}</div>
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
                  letterSpacing:'-.01em',marginBottom:verdictLoading?4:10,transition:'all .2s'}}>
                {verdictLoading ? 'Анализируем...' : 'Персональный анализ'}
              </button>
              {verdictLoading&&(
                // ИИ-анализ иногда реально занимает 20-40+ секунд (нестабильный
                // прокси) — без этой подсказки долгое ожидание читалось как
                // "зависло/сломалось", хотя запрос просто ещё выполняется.
                <p style={{fontFamily:sans,fontSize:11,color:t3,textAlign:'center',marginBottom:10}}>
                  Иногда занимает до минуты — не закрывай окно
                </p>
              )}
              {(() => {
                // Ссылка, о которой уже известно, что она мёртвая (404/410
                // или запрос не дошёл — см. isDeadLink в lib/linkHealth.ts;
                // 403 НЕ считается мёртвой, это защита сайта от ботов),
                // не лучше отсутствующей — гугл-поиск по названию хотя бы
                // куда-то приведёт, а не гарантированно на пустую страницу.
                const linkBroken = isDeadLink(selectedProgram.url_status)
                const googleFallback = `https://www.google.com/search?q=${encodeURIComponent(selectedProgram._p+' '+selectedProgram._n+' master admission')}`
                const href = (selectedProgram.url && !linkBroken) ? selectedProgram.url : googleFallback
                const label = linkBroken
                  ? '⚠ Ссылка устарела — найти на сайте вуза →'
                  : selectedProgram.verified ? 'Страница программы →' : '⚠ Проверить точные данные на сайте вуза →'
                return (
                  <a href={href} target="_blank" rel="noopener"
                    style={(selectedProgram.verified && !linkBroken) ? {
                      display:'block',textAlign:'center',padding:'11px',borderRadius:8,
                      border:`1px solid ${line}`,fontFamily:sans,fontSize:12,color:t2,textDecoration:'none',
                    } : {
                      display:'block',textAlign:'center',padding:'13px',borderRadius:8,
                      border:`1.5px solid ${gold}50`,background:`${gold}0F`,
                      fontFamily:sans,fontSize:13,fontWeight:500,color:gold,textDecoration:'none',
                    }}>
                    {label}
                  </a>
                )
              })()}
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
                  {verdictLocked&&(
                    <button onClick={async()=>{const r=await startCheckout();if(r.error)setVerdictError(r.error)}}
                      style={{display:'block',width:'100%',marginTop:10,padding:'10px',borderRadius:6,border:'none',
                        background:gold,color:bg0,fontFamily:sans,fontSize:12,fontWeight:600,cursor:'pointer'}}>
                      Разблокировать Pro
                    </button>
                  )}
                </div>
              )}
              {verdict&&(
                <div style={{marginTop:20,animation:'slideUp .4s ease both'}}>
                  <div style={{height:1,background:line,marginBottom:20}}/>
                  <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:t3,marginBottom:12}}>ПЕРСОНАЛЬНЫЙ АНАЛИЗ</div>
                  {!selectedProgram.verified&&(
                    <div style={{display:'flex',gap:10,alignItems:'flex-start',padding:'10px 12px',
                      marginBottom:16,borderRadius:8,background:`${gold}0F`,border:`1px solid ${gold}35`}}>
                      <span style={{fontFamily:mono,fontSize:12,color:gold,flexShrink:0}}>⚠</span>
                      <span style={{fontFamily:sans,fontSize:12,color:t2,lineHeight:1.5}}>
                        Этот анализ рассуждает поверх данных программы, которые ещё не проверены человеком —
                        стоимость, дедлайн и требования могли собрать неточно. Перепроверь на сайте вуза
                        перед тем, как принимать решение по нему.
                      </span>
                    </div>
                  )}
                  <p style={{fontFamily:sans,fontSize:15,color:t1,lineHeight:1.6,marginBottom:16,fontWeight:400}}>«{verdict.verdict}»</p>
                  {verdict.fit?.map((f:string,i:number)=>(
                    <div key={i} style={{display:'flex',gap:12,marginBottom:8}}>
                      <span style={{color:t3,flexShrink:0}}>—</span>
                      <span style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.5}}>{f}</span>
                    </div>
                  ))}
                  {verdict.warnings?.length>0&&(
                    <div style={{marginTop:16,paddingTop:16,borderTop:`1px solid ${line}`}}>
                      <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',color:amb,marginBottom:10}}>НА ЧТО ОБРАТИТЬ ВНИМАНИЕ</div>
                      {verdict.warnings.map((w:string,i:number)=>(
                        <div key={i} style={{display:'flex',gap:12,marginBottom:8}}>
                          <span style={{color:amb,flexShrink:0}}>⚠</span>
                          <span style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.5}}>{w}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
      )}
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
