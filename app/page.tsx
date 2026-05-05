'use client'
import { supabase } from '../lib/supabase'
import { useState, useEffect } from 'react'

const CSS = `
@import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600&family=Geist+Mono:wght@400;500&display=swap');
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html,body{background:#0A0A0C;height:100%;-webkit-font-smoothing:antialiased}
::-webkit-scrollbar{width:4px}
::-webkit-scrollbar-thumb{background:rgba(255,255,255,.08);border-radius:2px}
@keyframes up{from{opacity:0;transform:translateY(22px)}to{opacity:1;transform:translateY(0)}}
@keyframes in{from{opacity:0}to{opacity:1}}
@keyframes bar{from{transform:scaleX(0)}to{transform:scaleX(1)}}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.35}}
.up{animation:up .5s cubic-bezier(.22,.68,0,1.1) both}
.in{animation:in .4s ease both}
.row{transition:background .15s;cursor:pointer}
.row:hover{background:rgba(255,255,255,.04)!important}
.chip{transition:all .15s;cursor:pointer}
.chip:hover{border-color:rgba(255,255,255,.25)!important}
.btn{transition:opacity .15s,transform .15s;cursor:pointer}
.btn:hover{opacity:.88}
.btn:active{transform:scale(.98)}
input[type=range]{-webkit-appearance:none;width:100%;height:2px;background:rgba(255,255,255,.1);border-radius:1px;outline:none;cursor:pointer}
input[type=range]::-webkit-slider-thumb{-webkit-appearance:none;width:16px;height:16px;background:#F2EFE9;border-radius:50%;cursor:pointer;box-shadow:0 0 0 3px rgba(242,239,233,.15)}
input[type=text],input[type=email]{font-family:'Geist',sans-serif;font-size:15px;color:#F2EFE9;caret-color:#F2EFE9;background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.1);border-radius:8px;padding:13px 16px;width:100%;outline:none;transition:border-color .2s;letter-spacing:-.01em}
input:focus{border-color:rgba(255,255,255,.3)}
input::placeholder{color:rgba(242,239,233,.2)}
`

const bg0 = '#0A0A0C'
const bg1 = '#111115'
const line = 'rgba(255,255,255,0.08)'
const t1 = '#F2EFE9'
const t2 = '#8A8780'
const t3 = '#4A4845'
const gold = '#D4A853'
const blue = '#6B8CFF'
const red = '#E5534B'
const grn = '#3FB950'
const sans = "'Geist', sans-serif"
const serif = "'Instrument Serif', serif"
const mono = "'Geist Mono', monospace"

const COUNTRIES_MAIN = [
  {c:'de',f:'DE',n:'Германия',   tag:'Бесплатно · DAAD'},
  {c:'nl',f:'NL',n:'Нидерланды', tag:'Holland Scholarship'},
  {c:'se',f:'SE',n:'Швеция',     tag:'SI Grant · Free'},
  {c:'ch',f:'CH',n:'Швейцария',  tag:'ETH · EPFL'},
  {c:'fi',f:'FI',n:'Финляндия',  tag:'Aalto · Free'},
  {c:'fr',f:'FR',n:'Франция',    tag:'Eiffel Excellence'},
  {c:'cz',f:'CZ',n:'Чехия',      tag:'Бесплатно на чешском'},
  {c:'at',f:'AT',n:'Австрия',    tag:'TU Wien · WU'},
]

const COUNTRIES_MORE = [
  {c:'it',f:'IT',n:'Италия',     tag:'Politecnico · Bologna'},
  {c:'dk',f:'DK',n:'Дания',      tag:'DTU · Copenhagen'},
  {c:'no',f:'NO',n:'Норвегия',   tag:'NTNU · Бесплатно'},
  {c:'be',f:'BE',n:'Бельгия',    tag:'KU Leuven · UCL'},
  {c:'es',f:'ES',n:'Испания',    tag:'Barcelona · Madrid'},
  {c:'ee',f:'EE',n:'Эстония',    tag:'Tallinn · Startup'},
  {c:'pl',f:'PL',n:'Польша',     tag:'Warsaw · Wrocław'},
  {c:'hu',f:'HU',n:'Венгрия',    tag:'Стипендия Stipendium'},
]
const UNIS = ['МГТУ им. Баумана','МГУ','СПбГУ','НИУ ВШЭ','МФТИ','ИТМО','УрФУ','Другой']
const FIELDS = ['Компьютерные науки / ИИ','Инженерия','Экономика','Физика / Математика','Биотех','Дизайн','Социальные науки','Другое']
const BUDGETS = [
  {id:'zero',l:'Только стипендия',   s:'Финансирование — обязательное условие'},
  {id:'low', l:'До €5 000 / год',    s:'Подработка или частичная помощь'},
  {id:'mid', l:'До €15 000 / год',   s:'Могу частично финансировать'},
  {id:'high',l:'Бюджет не проблема', s:'Фокус только на качестве программы'},
]
const PAINS = [
  {id:'lost',   l:'Не знаю с чего начать',     s:'Слишком много информации, теряюсь'},
  {id:'country',l:'Не знаю куда хочу ехать',   s:'Не понимаю чем страны отличаются'},
  {id:'profile',l:'Боюсь что профиль слабый',  s:'GPA / IELTS / опыт недостаточны'},
  {id:'money',  l:'Не понимаю про стипендии',  s:'Реально ли учиться бесплатно'},
  {id:'docs',   l:'Документы пугают',           s:'SoP, рекомендации — это сложно'},
  {id:'worth',  l:'Не уверен что оно того стоит',s:'Сомневаюсь в правильности выбора'},
]

const tog = (a: string[], v: string) => a.includes(v) ? a.filter(x => x !== v) : [...a, v]

function Divider() {
  return <div style={{height:1,background:line,margin:'24px 0'}}/>
}

function Bar({v=0,color=t1,h=2}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,animation:'bar .9s ease both',transformOrigin:'left',borderRadius:1}}/>
    </div>
  )
}

function SelectRow({selected,onClick,label,sub,right}: {selected:boolean,onClick:()=>void,label:string,sub?:string,right?:React.ReactNode}) {
  return (
    <div onClick={onClick} className="row" style={{display:'flex',alignItems:'center',gap:14,padding:'14px 16px',borderRadius:6,background:selected?'rgba(255,255,255,.06)':'transparent',borderLeft:`2px solid ${selected?t1:'transparent'}`}}>
      <div style={{flex:1}}>
        <div style={{fontFamily:sans,fontSize:14,color:selected?t1:t2,fontWeight:selected?500:400,letterSpacing:'-.01em'}}>{label}</div>
        {sub&&<div style={{fontFamily:sans,fontSize:12,color:t3,marginTop:2}}>{sub}</div>}
      </div>
      {right&&<div style={{fontFamily:mono,fontSize:11,color:t3}}>{right}</div>}
      <div style={{width:16,height:16,borderRadius:'50%',flexShrink:0,border:`1.5px solid ${selected?t1:t3}`,background:selected?t1:'transparent',display:'flex',alignItems:'center',justifyContent:'center'}}>
        {selected&&<div style={{width:6,height:6,background:bg0,borderRadius:'50%'}}/>}
      </div>
    </div>
  )
}

function Chip({selected,onClick,children}: {selected:boolean,onClick:()=>void,children:React.ReactNode}) {
  return (
    <button onClick={onClick} className="chip" style={{fontFamily:sans,fontSize:13,fontWeight:400,letterSpacing:'-.01em',padding:'7px 14px',borderRadius:4,border:`1px solid ${selected?'rgba(255,255,255,.35)':line}`,background:selected?'rgba(255,255,255,.08)':'transparent',color:selected?t1:t2,cursor:'pointer'}}>
      {children}
    </button>
  )
}

function Dots({total,cur}: {total:number,cur:number}) {
  return (
    <div style={{display:'flex',gap:5,justifyContent:'center',marginTop:28}}>
      {Array.from({length:total}).map((_,i)=>(
        <div key={i} style={{height:3,borderRadius:2,width:i===cur?20:6,background:i<=cur?t1:t3,transition:'all .3s'}}/>
      ))}
    </div>
  )
}

function NavBtns({step,onBack,onNext,label='Продолжить',can=true}: {step:number,onBack:()=>void,onNext:()=>void,label?:string,can?:boolean}) {
  return (
    <div style={{display:'flex',gap:10,marginTop:28}}>
      {step>1&&(
        <button onClick={onBack} style={{fontFamily:sans,fontSize:13,fontWeight:500,padding:'12px 20px',borderRadius:6,background:'transparent',border:`1px solid ${line}`,color:t2,cursor:'pointer',letterSpacing:'-.01em'}}>
          Назад
        </button>
      )}
      <button onClick={onNext} disabled={!can} className="btn" style={{flex:1,fontFamily:sans,fontSize:14,fontWeight:500,letterSpacing:'-.01em',padding:'13px',borderRadius:6,border:'none',background:can?t1:'rgba(255,255,255,.06)',color:can?bg0:t3,cursor:can?'pointer':'not-allowed'}}>
        {label}
      </button>
    </div>
  )
}

function SH({n,total,title,sub}: {n:number,total:number,title:string,sub?:string}) {
  return (
    <div style={{marginBottom:28}}>
      <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.14em',color:t3,marginBottom:16}}>
        {String(n).padStart(2,'0')} / {String(total).padStart(2,'0')}
      </div>
      <h2 style={{fontFamily:serif,fontSize:28,color:t1,fontWeight:400,lineHeight:1.15,letterSpacing:'-.01em',marginBottom:8,fontStyle:'italic'}}>
        {title}
      </h2>
      {sub&&<p style={{fontFamily:sans,fontSize:13,color:t2,lineHeight:1.55}}>{sub}</p>}
    </div>
  )
}

function Shell({children,step,total}: {children:React.ReactNode,step:number,total:number}) {
  return (
    <div style={{minHeight:'100vh',background:bg0,display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'flex-start',padding:'80px 20px 40px',position:'relative',overflow:'auto'}}>
      <div style={{position:'fixed',inset:0,pointerEvents:'none',zIndex:0,backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,backgroundRepeat:'repeat',backgroundSize:'128px',opacity:.6}}/>
      <div style={{position:'absolute',top:28,left:'50%',transform:'translateX(-50%)',fontFamily:serif,fontStyle:'italic',fontSize:18,color:t2,zIndex:1,letterSpacing:'-.01em'}}>
        Masterly
      </div>
      <div style={{width:'100%',maxWidth:460,zIndex:1}} className="up">
        {children}
      </div>
      {step>0&&step<=total&&<Dots total={total} cur={step-1}/>}
    </div>
  )
}

export default function Home() {
  const [step, setStep] = useState(0)
  const [a, setA] = useState({
    name:'', email:'', mode:'', pain:'',
    field:'', university:'',
    countries:[] as string[],
    timeline:'', budget:'',
    gpa:4.0, ielts:6.5, work:'', quiz_cost:'', quiz_stay:'', quiz_lang:'', quiz_vibe:'',
  })
  const [showMoreCountries, setShowMoreCountries] = useState(false)
  const [quizMode, setQuizMode] = useState(false)

  useEffect(()=>{
    const s = document.createElement('style')
    s.textContent = CSS
    document.head.appendChild(s)
    return () => s.remove()
  },[])

  const set = (k: string, v: unknown) => setA(x => ({...x,[k]:v}))
  const TOTAL = 8

  const goNext = async () => {
  if(step === 7) {
  // сохраняем в localStorage до логина
  localStorage.setItem('masterly_profile', JSON.stringify({
    name: a.name, email: a.email, mode: a.mode, pain: a.pain,
    university: a.university, field: a.field,
    countries: a.countries.join(','),
    timeline: a.timeline, budget: a.budget,
    gpa: a.gpa, ielts: a.ielts, work: a.work, score: score,
  }))
  setStep(99)
  return
}
setStep((s:any)=> s+1)
}
  const goBack = () => setStep((s:any)=> Math.max(0,s-1))

  const score = Math.min(97, Math.round(
    (a.gpa>=4.5?28:a.gpa>=4.0?20:12)+
    (a.ielts>=6.5?22:8)+
    (a.work==='yes'?18:a.work==='some'?10:4)+
    (a.countries.length>=2?10:5)+15
  ))

  const name = a.name.split(' ')[0] || 'друг'

  // STEP 0 — WELCOME
  if(step===0) return (
    <Shell step={0} total={TOTAL}>
     <div style={{textAlign:'center'}}>

  <div style={{fontFamily:mono,fontSize:9,color:t3,
    letterSpacing:'0.14em',marginBottom:28}}>
    УЖЕ 2 400 СТУДЕНТОВ СТРОЯТ ПЛАН
  </div>

  <h1 style={{fontFamily:serif,fontStyle:'italic',
    fontSize:54,color:t1,fontWeight:400,
    letterSpacing:'-.03em',lineHeight:.95,marginBottom:20}}>
    Магистратура в Европе.<br/>
    <span style={{color:t2}}>Твой план за 3 минуты.</span>
  </h1>

  <p style={{fontFamily:sans,fontSize:15,color:t2,
    lineHeight:1.65,maxWidth:340,margin:'0 auto 40px',fontWeight:300}}>
    Персональный roadmap, дедлайны стипендий и список вузов —
    без гугления по 20 вкладкам.
  </p>

  <button className="btn" onClick={goNext} style={{
    width:'100%',padding:'16px',borderRadius:8,border:'none',
    background:t1,color:bg0,fontFamily:sans,fontSize:15,
    fontWeight:600,letterSpacing:'-.01em',cursor:'pointer'}}>
    Начать — это бесплатно
  </button>

  <p style={{fontFamily:mono,fontSize:9,color:t3,
    marginTop:14,letterSpacing:'0.08em'}}>
    БЕЗ РЕГИСТРАЦИИ · 8 ВОПРОСОВ
  </p>

</div> 
    </Shell>
  )

  // STEP 1 — MODE
  if(step===1) return (
    <Shell step={1} total={TOTAL}>
      <SH n={1} total={TOTAL} title="Как ты себя описываешь?" sub="Честный ответ — и мы подберём нужный формат плана"/>
      <div style={{display:'flex',flexDirection:'column',gap:2}}>
        {[
          {v:'zero', l:'Полный ноль',        s:'Думаю о Европе, но не знаю с чего начать и куда вообще хочу'},
          {v:'path', l:'Есть направление',   s:'Знаю примерно что хочу, но не понимаю как реализовать'},
          {v:'ready',l:'Уже готов подавать', s:'Знаю куда хочу, нужен чёткий план и чеклист документов'},
        ].map(o=>(
          <SelectRow key={o.v} label={o.l} sub={o.s} selected={a.mode===o.v} onClick={()=>set('mode',o.v)}/>
        ))}
      </div>
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={!!a.mode}/>
    </Shell>
  )

  // STEP 2 — NAME
  if(step===2) return (
    <Shell step={step} total={TOTAL}>
      <SH n={2} total={TOTAL} title="Как тебя зовут?" sub="Персонализируем план под тебя"/>
      <div style={{display:'flex',flexDirection:'column',gap:8,marginBottom:4}}>
        <input type="text" placeholder="Имя" value={a.name} onChange={e=>set('name',e.target.value)} onKeyDown={e=>e.key==='Enter'&&a.name.trim().length>1&&goNext()}/>
  
      </div>
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={a.name.trim().length>1}/>
    </Shell>
  )

  // STEP 3 — PAIN
  if(step===3) return (
    <Shell step={step} total={TOTAL}>
      <SH n={3} total={TOTAL} title={`${name}, что мешает больше всего?`} sub="Один главный ответ — мы начнём именно с этого"/>
      {a.mode==='zero'&&(
        <div style={{padding:'10px 14px',marginBottom:16,background:`${gold}10`,borderLeft:`2px solid ${gold}`,borderRadius:'0 4px 4px 0'}} className="in">
          <span style={{fontFamily:sans,fontSize:12,color:gold}}>Ты не один — 67% студентов начинают с этого же ощущения.</span>
        </div>
      )}
      <div style={{display:'flex',flexDirection:'column',gap:2}}>
        {PAINS.map(p=>(
          <SelectRow key={p.id} label={p.l} sub={p.s} selected={a.pain===p.id} onClick={()=>set('pain',p.id)}/>
        ))}
      </div>
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={!!a.pain}/>
    </Shell>
  )

  // STEP 4 — UNIVERSITY + FIELD
  if(step===4) return (
    <Shell step={step} total={TOTAL}>
      <SH n={4} total={TOTAL} title="Где и что изучаешь?" sub="Влияет на конвертацию GPA и подбор программ"/>
      <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>ТЕКУЩИЙ ВУЗ</div>
      <div style={{display:'flex',flexDirection:'column',gap:2,marginBottom:4}}>
        {UNIS.map(u=>(
          <SelectRow key={u} label={u} selected={a.university===u} onClick={()=>set('university',u)}/>
        ))}
      </div>
      {a.university&&(
        <div className="in">
          <Divider/>
          <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>НАПРАВЛЕНИЕ</div>
          <div style={{display:'flex',flexWrap:'wrap',gap:6}}>
            {FIELDS.map(f=>(
              <Chip key={f} selected={a.field===f} onClick={()=>set('field',f)}>{f}</Chip>
            ))}
          </div>
        </div>
      )}
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={!!a.university&&!!a.field}/>
    </Shell>
  )

  // STEP 5 — COUNTRIES
  if(step===5) return (
    <Shell step={step} total={TOTAL}>
      <SH n={5} total={TOTAL} title="Куда хочешь поехать?" sub="Можно несколько стран — подберём программы в каждой"/>
      {/* основные страны */}
{/* кнопка запуска квиза */}
{!quizMode&&a.countries.length===0&&(
  <div onClick={()=>setQuizMode(true)}
    style={{display:'flex',alignItems:'center',gap:14,
      padding:'16px 18px',marginBottom:16,borderRadius:8,
      background:`rgba(200,162,86,0.08)`,
      border:`1px solid rgba(200,162,86,0.3)`,
      cursor:'pointer',transition:'all .15s'}}
    onMouseEnter={e=>(e.currentTarget as HTMLElement).style.borderColor='rgba(200,162,86,0.6)'}
    onMouseLeave={e=>(e.currentTarget as HTMLElement).style.borderColor='rgba(200,162,86,0.3)'}>
    <div style={{flex:1}}>
      <div style={{fontFamily:sans,fontSize:14,color:gold,
        fontWeight:500,letterSpacing:'-.01em',marginBottom:3}}>
        Не знаю куда хочу — помоги выбрать
      </div>
      <div style={{fontFamily:sans,fontSize:12,color:t3}}>
        4 быстрых вопроса о твоих приоритетах
      </div>
    </div>
    <span style={{fontFamily:mono,fontSize:14,color:gold}}>→</span>
  </div>
)}
{quizMode&&(
  <div className="in">
    {[
      {id:'cost',q:'Что важнее по деньгам?',opts:[
        {v:'free', l:'Учёба должна быть бесплатной',s:'Германия, Финляндия, Чехия'},
        {v:'schol',l:'Готов платить если дадут стипендию',s:'DAAD, SI покроют расходы'},
        {v:'any',  l:'Деньги не ключевой фактор',s:'Фокус на качестве программы'},
      ]},
      {id:'stay',q:'Планируешь остаться в Европе после учёбы?',opts:[
        {v:'yes',  l:'Да, хочу остаться',s:'Нидерланды, Германия, Швеция'},
        {v:'maybe',l:'Посмотрю по ситуации',s:'Оставим варианты открытыми'},
        {v:'no',   l:'Нет, вернусь домой',s:'Фокус на диплом и нетворк'},
      ]},
      {id:'lang',q:'Язык обучения?',opts:[
        {v:'en', l:'Только английский',s:'Нидерланды, Швеция, Финляндия'},
        {v:'de', l:'Готов учить немецкий',s:'Бесплатные программы Германии'},
        {v:'any',l:'Не важно',s:'Рассмотрим все варианты'},
      ]},
      {id:'vibe',q:'Какая среда важнее?',opts:[
        {v:'research',l:'Сильная научная среда',s:'ETH, TU Munich, KTH'},
        {v:'startup', l:'Предпринимательская экосистема',s:'Нидерланды, Финляндия'},
        {v:'life',    l:'Качество жизни',s:'Германия, Австрия, Швейцария'},
      ]},
    ].filter(q=>!({cost:1,stay:1,lang:1,vibe:1} as any)[q.id] || true).map((quiz,qi)=>{
      const answered = (a as any)[`quiz_${quiz.id}`]
      if(qi>0&&!(a as any)[`quiz_${['cost','stay','lang'][qi-1]}`]) return null
      return(
        <div key={quiz.id} style={{marginBottom:16}}>
          <div style={{fontFamily:sans,fontSize:14,color:t1,fontWeight:500,
            marginBottom:10,letterSpacing:'-.01em'}}>{quiz.q}</div>
          <div style={{display:'flex',flexDirection:'column',gap:2}}>
            {quiz.opts.map(o=>(
              <SelectRow key={o.v} label={o.l} sub={o.s}
                selected={answered===o.v}
                onClick={()=>{
                  set(`quiz_${quiz.id}` as any, o.v)
                  // если последний вопрос — считаем результат
                  if(quiz.id==='vibe') {
                    const qa = {
                      cost:(a as any).quiz_cost||'',
                      stay:(a as any).quiz_stay||'',
                      lang:(a as any).quiz_lang||'',
                      vibe:o.v,
                    }
                    const scores: Record<string,number>={de:0,nl:0,se:0,ch:0,fi:0,fr:0,cz:0,at:0}
                    if(qa.cost==='free')    {scores.de+=3;scores.fi+=3;scores.cz+=3;scores.se+=2}
                    if(qa.cost==='schol')   {scores.de+=2;scores.se+=2;scores.fr+=2;scores.nl+=1}
                    if(qa.cost==='any')     {scores.ch+=2;scores.nl+=2}
                    if(qa.stay==='yes')     {scores.nl+=3;scores.de+=2;scores.se+=2;scores.fi+=1}
                    if(qa.stay==='no')      {scores.cz+=2;scores.at+=1}
                    if(qa.lang==='en')      {scores.nl+=2;scores.se+=2;scores.fi+=2}
                    if(qa.lang==='de')      {scores.de+=3;scores.at+=2;scores.ch+=1}
                    if(qa.vibe==='research'){scores.ch+=3;scores.de+=2;scores.se+=2}
                    if(qa.vibe==='startup') {scores.nl+=3;scores.fi+=2}
                    if(qa.vibe==='life')    {scores.de+=2;scores.at+=2;scores.fr+=1}
                    const top3 = Object.entries(scores).sort((a,b)=>b[1]-a[1]).slice(0,3).map(([c])=>c)
                    set('countries', top3)
                    setQuizMode(false)
                  }
                }}/>
            ))}
          </div>
        </div>
      )
    })}
    <div style={{padding:'10px 12px',background:`rgba(200,162,86,.08)`,
      borderLeft:`2px solid ${gold}`,borderRadius:'0 4px 4px 0',marginTop:8}}>
      <span style={{fontFamily:sans,fontSize:12,color:gold}}>
        После ответов мы подберём 3 лучших страны под твои приоритеты
      </span>
    </div>
    <button onClick={()=>setQuizMode(false)} style={{
      marginTop:12,background:'none',border:'none',
      fontFamily:sans,fontSize:12,color:t3,cursor:'pointer',textDecoration:'underline'}}>
      Выбрать страну самому
    </button>
  </div>
)}
<div style={{display:'grid',gridTemplateColumns:'repeat(4,1fr)',gap:6,marginBottom:8}}>
  {COUNTRIES_MAIN.map(c=>{
    const sel=a.countries.includes(c.c)
    return(
      <div key={c.c} onClick={()=>set('countries',tog(a.countries,c.c))}
        className="chip"
        style={{padding:'12px 8px',borderRadius:6,textAlign:'center',cursor:'pointer',
          background:sel?'rgba(255,255,255,.07)':'rgba(255,255,255,.02)',
          border:`1px solid ${sel?'rgba(255,255,255,.25)':line}`}}>
        <div style={{fontFamily:mono,fontSize:11,color:sel?t1:t2,
          marginBottom:3,letterSpacing:'0.04em'}}>{c.f}</div>
        <div style={{fontFamily:sans,fontSize:11,fontWeight:500,
          color:sel?t1:t2,letterSpacing:'-.01em',marginBottom:2}}>{c.n}</div>
        <div style={{fontFamily:mono,fontSize:8,color:t3}}>{c.tag}</div>
      </div>
    )
  })}
</div>

{/* кнопка показать ещё */}
<div onClick={()=>setShowMoreCountries(s=>!s)}
  style={{display:'flex',alignItems:'center',justifyContent:'center',gap:8,
    padding:'10px',borderRadius:6,border:`1px solid ${line}`,
    cursor:'pointer',marginBottom:8,transition:'all .15s'}}
  onMouseEnter={e=>(e.currentTarget as HTMLElement).style.borderColor='rgba(255,255,255,.2)'}
  onMouseLeave={e=>(e.currentTarget as HTMLElement).style.borderColor=line}>
  <span style={{fontFamily:mono,fontSize:9,color:t2,letterSpacing:'0.1em'}}>
    {showMoreCountries?'СКРЫТЬ':'ЕЩЁ 8 СТРАН — Италия, Дания, Норвегия...'}
  </span>
  <span style={{fontFamily:mono,fontSize:11,color:t2}}>
    {showMoreCountries?'↑':'↓'}
  </span>
</div>

{/* дополнительные страны */}
{showMoreCountries&&(
  <div style={{display:'grid',gridTemplateColumns:'repeat(4,1fr)',gap:6,marginBottom:8}}
    className="in">
    {COUNTRIES_MORE.map(c=>{
      const sel=a.countries.includes(c.c)
      return(
        <div key={c.c} onClick={()=>set('countries',tog(a.countries,c.c))}
          className="chip"
          style={{padding:'12px 8px',borderRadius:6,textAlign:'center',cursor:'pointer',
            background:sel?'rgba(255,255,255,.07)':'rgba(255,255,255,.02)',
            border:`1px solid ${sel?'rgba(255,255,255,.25)':line}`}}>
          <div style={{fontFamily:mono,fontSize:11,color:sel?t1:t2,
            marginBottom:3,letterSpacing:'0.04em'}}>{c.f}</div>
          <div style={{fontFamily:sans,fontSize:11,fontWeight:500,
            color:sel?t1:t2,letterSpacing:'-.01em',marginBottom:2}}>{c.n}</div>
          <div style={{fontFamily:mono,fontSize:8,color:t3}}>{c.tag}</div>
        </div>
      )
    })}
  </div>
)}
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={a.countries.length>0}/>
    </Shell>
  )

  // STEP 6 — TIMELINE + BUDGET
  if(step===6) return (
    <Shell step={step} total={TOTAL}>
      <SH n={6} total={TOTAL} title="Сроки и бюджет" sub="Определяет интенсивность подготовки и стипендии"/>
      <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>КОГДА ПЛАНИРУЕШЬ НАЧАТЬ</div>
      <div style={{display:'flex',flexDirection:'column',gap:2,marginBottom:4}}>
        {[
          {v:'2025',l:'Уже в 2025',  s:'Дедлайны близко — нужно действовать сейчас'},
          {v:'2026',l:'Осень 2026',  s:'Оптимально — время есть'},
          {v:'2027',l:'Осень 2027',  s:'Максимум времени для сильного профиля'},
          {v:'later',l:'Пока не решил',s:'Разберёмся вместе с таймингом'},
        ].map(o=>(
          <SelectRow key={o.v} label={o.l} sub={o.s} selected={a.timeline===o.v} onClick={()=>set('timeline',o.v)}/>
        ))}
      </div>
      {a.timeline&&(
        <div className="in">
          <Divider/>
          <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>ФИНАНСОВЫЙ ВОПРОС</div>
          {a.pain==='money'&&(
            <div style={{padding:'10px 14px',marginBottom:16,background:`${grn}10`,borderLeft:`2px solid ${grn}`,borderRadius:'0 4px 4px 0'}}>
              <span style={{fontFamily:sans,fontSize:12,color:grn}}>Германия, Финляндия, Чехия — бесплатное обучение. DAAD покрывает проживание. Это реально.</span>
            </div>
          )}
          <div style={{display:'flex',flexDirection:'column',gap:2}}>
            {BUDGETS.map(b=>(
              <SelectRow key={b.id} label={b.l} sub={b.s} selected={a.budget===b.id} onClick={()=>set('budget',b.id)}/>
            ))}
          </div>
        </div>
      )}
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={!!a.timeline&&!!a.budget}/>
    </Shell>
  )

  // STEP 7 — ACADEMIC
  if(step===7) return (
    <Shell step={step} total={TOTAL}>
      <SH n={7} total={TOTAL} title="Академический профиль" sub={a.pain==='profile'?'Честно покажем где ты стоишь и что улучшить':'Приблизительно — потом уточним'}/>

      <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>СРЕДНИЙ БАЛЛ (GPA)</div>
      <div style={{display:'flex',justifyContent:'space-between',alignItems:'baseline',marginBottom:12}}>
        <span style={{fontFamily:sans,fontSize:13,color:t2}}>
          {a.gpa>=4.5?'Отлично — топ 10%':a.gpa>=4.0?'Хорошо — выше среднего':a.gpa>=3.5?'Достаточно для большинства вузов':'Потребует сильного SoP'}
        </span>
        <span style={{fontFamily:mono,fontSize:22,color:t1}}>{a.gpa.toFixed(1)}<span style={{fontSize:12,color:t3}}> / 5</span></span>
      </div>
      <input type="range" min="2.5" max="5.0" step="0.1" value={a.gpa} onChange={e=>set('gpa',parseFloat(e.target.value))}/>
      <div style={{display:'flex',justifyContent:'space-between',fontFamily:mono,fontSize:10,color:t3,marginTop:6,marginBottom:24}}>
        <span>2.5</span><span>4.0</span><span>5.0</span>
      </div>

      <Divider/>

      <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>IELTS / TOEFL</div>
      <div style={{display:'flex',justifyContent:'space-between',alignItems:'baseline',marginBottom:12}}>
        <span style={{fontFamily:sans,fontSize:13,color:a.ielts>=6.5?grn:a.ielts>=6.0?gold:red}}>
          {a.ielts>=7.0?'Отлично — подходит для ETH':a.ielts>=6.5?'Достаточно для всех программ':a.ielts>=6.0?'Чуть не хватает до 6.5':'Блокер — сдать в первую очередь'}
        </span>
        <span style={{fontFamily:mono,fontSize:22,color:a.ielts>=6.5?grn:red}}>{a.ielts.toFixed(1)}<span style={{fontSize:12,color:t3}}> IELTS</span></span>
      </div>
      <input type="range" min="4.0" max="9.0" step="0.5" value={a.ielts} onChange={e=>set('ielts',parseFloat(e.target.value))}/>
      <div style={{display:'flex',justifyContent:'space-between',fontFamily:mono,fontSize:10,color:t3,marginTop:6,marginBottom:6}}>
        <span>4.0</span><span style={{color:a.ielts<6.5?red:t3}}>6.5 min</span><span>9.0</span>
      </div>
      {a.ielts<6.5&&(
        <div style={{padding:'9px 12px',background:`${red}12`,borderRadius:5,borderLeft:`2px solid ${red}`,marginBottom:4}} className="in">
          <span style={{fontFamily:sans,fontSize:12,color:red}}>Нужно улучшить — включим в roadmap как первый шаг</span>
        </div>
      )}

      <Divider/>

      <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>ОПЫТ РАБОТЫ</div>
      <div style={{display:'flex',flexDirection:'column',gap:2}}>
        {[{v:'no',l:'Нет'},{v:'some',l:'Немного — стажировка, проекты'},{v:'yes',l:'Есть — 1+ год'}].map(o=>(
          <SelectRow key={o.v} label={o.l} selected={a.work===o.v} onClick={()=>set('work',o.v)}/>
        ))}
      </div>
      <NavBtns step={step} onBack={goBack} onNext={goNext} can={!!a.work}/>
    </Shell>
  )

  // STEP 8 — RESULT
  if(step>=8 && step !== 99) {
    const flags: Record<string,string> = {de:'DE',nl:'NL',se:'SE',ch:'CH',fi:'FI',fr:'FR',cz:'CZ',at:'AT'}
    const countryNames: Record<string,string> = {de:'Германия',nl:'Нидерланды',se:'Швеция',ch:'Швейцария',fi:'Финляндия',fr:'Франция',cz:'Чехия',at:'Австрия'}
    const selectedFlags = a.countries.map(c=>flags[c]).join(' · ')
    const firstSteps = [
      a.ielts<6.5  && {t:'Записаться на IELTS — это первый шаг', c:red},
      a.budget==='zero' && {t:'DAAD дедлайн 14 января — начни Motivation Letter сегодня', c:gold},
      {t:`Изучить программы в ${a.countries.map(c=>countryNames[c]).slice(0,2).join(' и ')||'выбранных странах'}`, c:t1},
      {t:'Составить Academic CV в Europass формате', c:t2},
    ].filter(Boolean).slice(0,3) as {t:string,c:string}[]

    return (
      <div style={{minHeight:'100vh',background:bg0,display:'flex',flexDirection:'column',alignItems:'center',justifyContent:'center',padding:'40px 20px',position:'relative'}}>
        <div style={{position:'fixed',inset:0,pointerEvents:'none',zIndex:0,backgroundImage:`url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.04'/%3E%3C/svg%3E")`,backgroundRepeat:'repeat',backgroundSize:'128px',opacity:.6}}/>
        <div style={{width:'100%',maxWidth:460,zIndex:1}} className="up">

          <div style={{marginBottom:28,textAlign:'center'}}>
            <div style={{fontFamily:mono,fontSize:10,color:t3,letterSpacing:'0.14em',marginBottom:14}}>ПРОФИЛЬ ГОТОВ</div>
            <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:72,color:t1,fontWeight:400,letterSpacing:'-.04em',lineHeight:1,marginBottom:4}}>
              {score}<span style={{fontSize:28,opacity:.4}}>%</span>
            </h1>
            <div style={{fontFamily:serif,fontStyle:'italic',fontSize:20,color:t2,marginBottom:14}}>готовности к поступлению</div>
            <div style={{height:2,background:'rgba(255,255,255,.08)',borderRadius:1,overflow:'hidden',marginBottom:10}}>
              <div style={{height:'100%',width:`${score}%`,background:t1,animation:'bar .9s ease both',transformOrigin:'left'}}/>
            </div>
            <span style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300}}>
              {score>=70?'Отличная база — подаём уже в этом цикле':score>=50?'Хорошая основа — несколько ключевых шагов':'С нуля до поступления — у нас есть план'}
            </span>
          </div>

          <div style={{height:1,background:line,margin:'24px 0'}}/>

          <div style={{display:'grid',gridTemplateColumns:'repeat(3,1fr)',borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:4}}>
            {[
              {l:'СТРАНЫ',v:selectedFlags||'—',c:t1},
              {l:'GPA',   v:`${a.gpa.toFixed(1)} / 5`,c:a.gpa>=4.0?blue:t1},
              {l:'IELTS', v:a.ielts.toFixed(1),c:a.ielts>=6.5?grn:red},
            ].map((s,i)=>(
              <div key={i} style={{padding:'14px',textAlign:'center',borderRight:`1px solid ${line}`,borderBottom:`1px solid ${line}`}}>
                <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:6}}>{s.l}</div>
                <div style={{fontFamily:mono,fontSize:16,color:s.c}}>{s.v}</div>
              </div>
            ))}
          </div>

          <div style={{height:1,background:line,margin:'24px 0'}}/>

          <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>ПЕРВЫЕ ШАГИ</div>
          {firstSteps.map((s,i)=>(
            <div key={i} style={{display:'flex',gap:12,alignItems:'baseline',padding:'12px 0',borderBottom:`1px solid ${line}`}}>
              <span style={{fontFamily:mono,fontSize:10,color:t3,minWidth:20}}>{`0${i+1}`}</span>
              <span style={{fontFamily:sans,fontSize:13,color:s.c,letterSpacing:'-.01em'}}>{s.t}</span>
            </div>
          ))}

         <div style={{marginTop:28,display:'flex',flexDirection:'column',gap:10}}>
  {/* что получишь */}
<div style={{marginTop:24,marginBottom:8,
  border:`1px solid ${line}`,borderRadius:8,overflow:'hidden'}}>
  {[
    {icon:'◈', text:'Персональный Journey Map — все шаги до оффера', color:blue},
    {icon:'◉', text:'Дедлайны вузов и стипендий в одном месте', color:gold},
    {icon:'*', text:'Программы подобраны под твои страны и бюджет', color:'#A78BFA'},
    {icon:'◎', text:'Таймлайн от сегодня до переезда с экспортом в календарь', color:'#3FB950'},
  ].map((f,i,arr)=>(
    <div key={i} style={{display:'flex',alignItems:'center',gap:12,
      padding:'12px 16px',
      borderBottom:i<arr.length-1?`1px solid ${line}`:'none',
      background:'rgba(255,255,255,.02)'}}>
      <span style={{fontFamily:mono,fontSize:13,color:f.color,flexShrink:0}}>{f.icon}</span>
      <span style={{fontFamily:sans,fontSize:13,color:t2,letterSpacing:'-.01em'}}>{f.text}</span>
    </div>
  ))}
</div>
  <div style={{fontFamily:mono,fontSize:10,color:t3,
    letterSpacing:'0.1em',textAlign:'center',marginBottom:4}}>
    СОХРАНИТЬ МОЙ ПЛАН
  </div>
  <button onClick={async()=>{
    const {error} = await supabase.auth.signInWithOAuth({
      provider:'google',
      options:{redirectTo:`${window.location.origin}/dashboard`}
    })
  }} style={{
    width:'100%',padding:'13px',borderRadius:8,
    border:`1px solid ${line}`,
    background:'rgba(255,255,255,.05)',
    display:'flex',alignItems:'center',justifyContent:'center',gap:10,
    fontFamily:sans,fontSize:14,fontWeight:500,color:t1,cursor:'pointer',
  }}>
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none">
      <path d="M17.64 9.205c0-.639-.057-1.252-.164-1.841H9v3.481h4.844a4.14 4.14 0 01-1.796 2.716v2.259h2.908c1.702-1.567 2.684-3.875 2.684-6.615z" fill="#4285F4"/>
      <path d="M9 18c2.43 0 4.467-.806 5.956-2.18l-2.908-2.259c-.806.54-1.837.86-3.048.86-2.344 0-4.328-1.584-5.036-3.711H.957v2.332A8.997 8.997 0 009 18z" fill="#34A853"/>
      <path d="M3.964 10.71A5.41 5.41 0 013.682 9c0-.593.102-1.17.282-1.71V4.958H.957A8.996 8.996 0 000 9c0 1.452.348 2.827.957 4.042l3.007-2.332z" fill="#FBBC05"/>
      <path d="M9 3.58c1.321 0 2.508.454 3.44 1.345l2.582-2.58C13.463.891 11.426 0 9 0A8.997 8.997 0 00.957 4.958L3.964 7.29C4.672 5.163 6.656 3.58 9 3.58z" fill="#EA4335"/>
    </svg>
    Войти через Google
  </button>
  <div style={{display:'flex',alignItems:'center',gap:10}}>
    <div style={{flex:1,height:1,background:line}}/>
    <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em'}}>ИЛИ</span>
    <div style={{flex:1,height:1,background:line}}/>
  </div>
  <input type="email" placeholder="твой@email.com"
    value={a.email} onChange={e=>set('email',e.target.value)}
    onKeyDown={async e=>{
      if(e.key==='Enter'&&a.email.trim()) {
        await supabase.auth.signInWithOtp({
          email:a.email.trim(),
          options:{emailRedirectTo:`${window.location.origin}/dashboard`}
        })
        setStep(99)
      }
    }}/>
  <button onClick={async()=>{
    if(!a.email.trim()) return
    await supabase.auth.signInWithOtp({
      email:a.email.trim(),
      options:{emailRedirectTo:`${window.location.origin}/dashboard`}
    })
    setStep(99)
  }} style={{
    width:'100%',padding:'13px',borderRadius:8,border:'none',
    background:a.email.trim()?t1:'rgba(255,255,255,.06)',
    color:a.email.trim()?bg0:t3,
    fontFamily:sans,fontSize:14,fontWeight:500,cursor:'pointer',
  }}>
    Отправить ссылку на email
  </button>
</div>
          <p style={{fontFamily:mono,fontSize:10,color:t3,textAlign:'center',marginTop:14,letterSpacing:'0.08em'}}>
            ПЛАН ПЕРСОНАЛИЗИРОВАН ПОД ТВОЙ ПРОФИЛЬ
          </p>
        </div>
      </div>
    )
  }
if(step === 99) return (
  <div style={{position:'fixed',inset:0,background:'#0A0A0C',display:'flex',alignItems:'center',justifyContent:'center',zIndex:999,overflow:'hidden'}}>
    <style>{`
      @keyframes logoIn {
        0%   { opacity:0; transform:translateY(16px); }
        35%  { opacity:1; transform:translateY(0); }
        75%  { opacity:1; transform:translateY(0); }
        100% { opacity:0; transform:translateY(-10px); }
      }
      @keyframes lineIn {
        0%   { width:0; opacity:0; }
        35%  { width:80px; opacity:1; }
        75%  { width:80px; opacity:1; }
        100% { width:120px; opacity:0; }
      }
      @keyframes tagIn {
        0%   { opacity:0; }
        40%  { opacity:1; }
        75%  { opacity:1; }
        100% { opacity:0; }
      }
      @keyframes drift {
  0%   { transform:translateY(0) translateX(0) scale(1); opacity:0; }
  8%   { opacity:1; }
  100% { transform:translateY(var(--dy, -400px)) translateX(var(--dx)) scale(0) rotate(var(--rot)); opacity:0; }
}
      .logo-in { animation: logoIn 2.8s cubic-bezier(.22,.68,0,1.1) forwards; }
      .line-in  { animation: lineIn  2.8s cubic-bezier(.22,.68,0,1.1) forwards; }
      .tag-in   { animation: tagIn   2.8s ease forwards; }
    `}</style>

    {/* золотые частицы */}
  
    {[...Array(40)].map((_,i)=>{
  const left = 10+Math.random()*80
  const delay = Math.random()*1.2
  const size = 1+Math.random()*2.5
  const dx = (Math.random()-0.5)*600+'px'
  const dy = -(200+Math.random()*500)+'px'
  return(
    <div key={i} style={{
      position:'absolute',
      left:`${left}%`,
      bottom:'45%',
      width:size, height:size,
      borderRadius:'50%',
      background:'#C8A256',
      boxShadow:`0 0 ${size*4}px #C8A256`,
      animation:`drift ${1.8+Math.random()*1}s cubic-bezier(.2,.8,.4,1) forwards`,
      animationDelay:`${delay}s`,
      '--dx':dx,
      '--rot':`${Math.random()*360}deg`,
    } as React.CSSProperties}/>
  )
})}
    {/* логотип */}
    <div style={{textAlign:'center',position:'relative',zIndex:10}}
  onAnimationEnd={()=>{ setStep(8) }}
 
>

      <div className="logo-in">
        <div style={{fontFamily:"'Instrument Serif',serif",fontStyle:'italic',fontSize:48,color:'#F2EFE9',letterSpacing:'-.025em',lineHeight:1,marginBottom:18}}>
          Masterly
        </div>
        <div className="line-in" style={{height:1,background:'linear-gradient(90deg,transparent,#C8A256,transparent)',margin:'0 auto',marginBottom:16}}/>
        <div className="tag-in" style={{fontFamily:"'Geist Mono',monospace",fontSize:9,color:'#4A4845',letterSpacing:'.16em'}}>
          СТРОИМ ТВОЙ ПЛАН
        </div>
      </div>
    </div>
  </div>
)
  return null
}
