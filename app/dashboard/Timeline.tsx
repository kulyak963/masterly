'use client'
import { useState, useEffect } from 'react'

const bg0='#0A0A0C',bg1='#111115',bg2='#17171C'
const line='rgba(255,255,255,0.07)'
const t1='#F2EFE9',t2='#7A7670',t3='#3D3B38'
const gold='#C8A256',blue='#6B8CFF',red='#E5534B',grn='#3FB950',purp='#A78BFA'
const sans="'Geist',sans-serif"
const serif="'Instrument Serif',serif"
const mono="'Geist Mono',monospace"

interface Event {
  id: string
  date: string          // 'YYYY-MM-DD'
  label: string
  sub?: string
  type: 'deadline'|'milestone'|'task'|'goal'
  color: string
  urgent?: boolean
  gcal?: boolean        // включать в экспорт
}

function buildEvents(profile: any): Event[] {
  const year = parseInt(profile.timeline) || 2026
  const sf = profile.budget === 'zero'
  const ni = profile.ielts < 6.5
  const countries = profile.countries?.split(',').filter(Boolean) || []

  const events: Event[] = []

  /* ── TODAY ── */
  const today = new Date().toISOString().split('T')[0]
  events.push({
    id:'start', date:today,
    label:'Ты здесь — старт',
    sub:'Профиль создан, план готов',
    type:'milestone', color:blue,
  })

  /* ── IELTS ── */
  if(ni) {
    events.push({
      id:'ielts-reg', date:addDays(today,3),
      label:'Записаться на IELTS Academic',
      sub:'British Council или IDP — запись за 2–3 месяца',
      type:'task', color:red, urgent:true, gcal:true,
    })
    events.push({
      id:'ielts-exam', date:addDays(today,90),
      label:'Сдать IELTS — цель 7.0+',
      sub:'Результаты через 3–5 дней',
      type:'deadline', color:red, gcal:true,
    })
  }

  /* ── SCHOLARSHIPS ── */
  events.push({
    id:'daad-start', date:addDays(today,7),
    label:'Начать Motivation Letter для DAAD',
    sub:'Это не SoP — отдельный документ',
    type:'task', color:gold, gcal:true,
  })
  events.push({
    id:'eiffel', date:`${year-1}-01-09`,
    label:'Дедлайн — Eiffel Excellence',
    sub:'Франция · €1 181 / мес',
    type:'deadline', color:gold, urgent:true, gcal:true,
  })
  events.push({
    id:'erasmus', date:`${year-1}-01-10`,
    label:'Дедлайн — Erasmus Mundus',
    sub:'ЕС · €1 000 / мес',
    type:'deadline', color:gold, urgent:true, gcal:true,
  })
  events.push({
    id:'daad', date:`${year-1}-01-14`,
    label:'Дедлайн — DAAD',
    sub:'Германия · €934 / мес · ГЛАВНАЯ СТИПЕНДИЯ',
    type:'deadline', color:gold, urgent:sf, gcal:true,
  })
  events.push({
    id:'holland', date:`${year-1}-02-01`,
    label:'Дедлайн — Holland Scholarship',
    sub:'Нидерланды · €5 000 единовременно',
    type:'deadline', color:gold, gcal:true,
  })
  events.push({
    id:'si', date:`${year-1}-02-15`,
    label:'Дедлайн — SI Scholarship',
    sub:'Швеция · SEK 10 000 / мес',
    type:'deadline', color:gold, gcal:true,
  })

  /* ── UNIVERSITY DEADLINES ── */
  const uniDls: Record<string,{n:string,date:string,sub:string}> = {
    de:{n:'TU Munich',    date:`${year-1}-01-15`, sub:'Германия · TUMonline'},
    fi:{n:'Aalto',        date:`${year-1}-01-20`, sub:'Финляндия · universityadmissions.fi'},
    nl:{n:'TU Delft',     date:`${year-1}-02-01`, sub:'Нидерланды · Studielink'},
    se:{n:'KTH Stockholm',date:`${year-1}-02-15`, sub:'Швеция · universityadmissions.se'},
    ch:{n:'ETH Zurich',   date:`${year-1}-12-15`, sub:'Швейцария · mystudies.ethz.ch'},
    fr:{n:'Sciences Po',  date:`${year-1}-01-09`, sub:'Франция'},
    cz:{n:'CTU Prague',   date:`${year-1}-02-28`, sub:'Чехия'},
    at:{n:'TU Wien',      date:`${year-1}-03-01`, sub:'Австрия'},
  }
  countries.forEach((c:string)=>{
    const u = uniDls[c]
    if(u) events.push({
      id:`uni-${c}`, date:u.date,
      label:`Дедлайн подачи — ${u.n}`,
      sub:u.sub,
      type:'deadline', color:blue, gcal:true,
    })
  })

  /* ── DOCS MILESTONES ── */
  events.push({
    id:'rec-request', date:addDays(today,14),
    label:'Запросить рекомендации у профессоров',
    sub:'Минимум за 2 месяца до дедлайна',
    type:'task', color:purp, urgent:true, gcal:true,
  })
  events.push({
    id:'cv', date:addDays(today,21),
    label:'Готовый Academic CV',
    sub:'Europass или Harvard формат',
    type:'milestone', color:purp, gcal:true,
  })
  events.push({
    id:'transcript', date:addDays(today,30),
    label:'Заверить транскрипт и диплом',
    sub:'Нотариальный перевод',
    type:'task', color:purp, gcal:true,
  })

  /* ── RESULTS & AFTER ── */
  events.push({
    id:'results', date:`${year}-04-01`,
    label:'Первые ответы от вузов',
    sub:'6–12 недель после дедлайна',
    type:'milestone', color:grn,
  })
  events.push({
    id:'accept', date:`${year}-05-01`,
    label:'Принять оффер',
    sub:'4–6 недель на принятие решения',
    type:'deadline', color:grn, gcal:true,
  })
  events.push({
    id:'visa', date:`${year}-05-07`,
    label:'Подать на студенческую визу',
    sub:'Германия: 6–12 нед · Нидерланды: 3–4 нед',
    type:'task', color:grn, urgent:true, gcal:true,
  })
  events.push({
    id:'housing', date:`${year}-05-07`,
    label:'Найти жильё',
    sub:'Wohnungssuche / Kamernet / Spotahome',
    type:'task', color:grn, gcal:true,
  })
  events.push({
    id:'move', date:`${year}-09-01`,
    label:`Переезд — сентябрь ${year} 🎓`,
    sub:'Начало учёбы в европейском вузе',
    type:'goal', color:gold,
  })

  /* sort by date */
  return events.sort((a,b)=>a.date.localeCompare(b.date))
}

function addDays(dateStr: string, days: number): string {
  const d = new Date(dateStr)
  d.setDate(d.getDate()+days)
  return d.toISOString().split('T')[0]
}

function formatDate(dateStr: string): string {
  const d = new Date(dateStr)
  return d.toLocaleDateString('ru-RU',{day:'numeric',month:'long'})
}

function formatMonth(dateStr: string): string {
  const d = new Date(dateStr)
  return d.toLocaleDateString('ru-RU',{month:'long',year:'numeric'})
}

function daysFromNow(dateStr: string): number {
  const now = new Date()
  const d = new Date(dateStr)
  return Math.ceil((d.getTime()-now.getTime())/(1000*60*60*24))
}

/* ── Google Calendar URL ── */
function makeGcalUrl(event: Event): string {
  const start = event.date.replace(/-/g,'')
  const end = addDays(event.date,1).replace(/-/g,'')
  const title = encodeURIComponent(event.label)
  const details = encodeURIComponent(event.sub||'Masterly — план поступления')
  return `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${title}&dates=${start}/${end}&details=${details}&sf=true&output=xml`
}

/* ── ICS file content ── */
function makeICS(events: Event[]): string {
  const gcalEvents = events.filter(e=>e.gcal)
  const lines = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Masterly//Plan//RU',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:Masterly — Дедлайны',
    'X-WR-TIMEZONE:Europe/Moscow',
  ]
  gcalEvents.forEach(e=>{
    const dt = e.date.replace(/-/g,'')
    const dtEnd = addDays(e.date,1).replace(/-/g,'')
    lines.push(
      'BEGIN:VEVENT',
      `DTSTART;VALUE=DATE:${dt}`,
      `DTEND;VALUE=DATE:${dtEnd}`,
      `SUMMARY:${e.label}`,
      `DESCRIPTION:${e.sub||''}`,
      `BEGIN:VALARM`,
      `TRIGGER:-P7D`,
      `ACTION:DISPLAY`,
      `DESCRIPTION:Напоминание за 7 дней: ${e.label}`,
      `END:VALARM`,
      `BEGIN:VALARM`,
      `TRIGGER:-P14D`,
      `ACTION:DISPLAY`,
      `DESCRIPTION:Напоминание за 14 дней: ${e.label}`,
      `END:VALARM`,
      'END:VEVENT',
    )
  })
  lines.push('END:VCALENDAR')
  return lines.join('\r\n')
}

/* ── group events by month ── */
function groupByMonth(events: Event[]) {
  const groups: Record<string, Event[]> = {}
  events.forEach(e=>{
    const key = e.date.slice(0,7)
    if(!groups[key]) groups[key]=[]
    groups[key].push(e)
  })
  return Object.entries(groups).sort(([a],[b])=>a.localeCompare(b))
}

const TYPE_ICON: Record<string,string> = {
  deadline:'◈', milestone:'◉', task:'◎', goal:'★',
}

export default function Timeline({profile}:{profile:any}) {
  const [exported, setExported] = useState(false)
  const [filter, setFilter] = useState<string>('all')

  useEffect(()=>{
    const s = document.createElement('style')
    s.textContent=`
      @keyframes fadeUp{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      @keyframes lineGrow{from{height:0}to{height:100%}}
      .ev-row{transition:background .15s;cursor:default}
      .ev-row:hover{background:rgba(255,255,255,.03)!important}
      .cal-btn{transition:all .15s;cursor:pointer}
      .cal-btn:hover{opacity:.8;transform:translateY(-1px)}
    `
    document.head.appendChild(s)
    return()=>s.remove()
  },[])

  const allEvents = buildEvents(profile)
  const filtered = filter==='all'
    ? allEvents
    : allEvents.filter(e=>e.type===filter)

  const groups = groupByMonth(filtered)
  const today = new Date().toISOString().split('T')[0]

  const downloadICS = () => {
    const content = makeICS(allEvents)
    const blob = new Blob([content],{type:'text/calendar;charset=utf-8'})
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href=url; a.download='masterly-deadlines.ics'
    a.click(); URL.revokeObjectURL(url)
    setExported(true)
    setTimeout(()=>setExported(false),3000)
  }

  const urgentCount = allEvents.filter(e=>e.urgent&&e.date>=today).length
  const nextEvent = allEvents.find(e=>e.date>=today)

  return (
    <div style={{padding:'32px 40px',maxWidth:800}}>

      {/* header */}
      <div style={{marginBottom:28}}>
        <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.11em',color:t3,marginBottom:10}}>
          ПОЛНЫЙ ТАЙМЛАЙН
        </div>
        <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:32,color:t1,
          fontWeight:400,letterSpacing:'-.02em',marginBottom:8}}>
          От сегодня до переезда
        </h1>
        <p style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300,lineHeight:1.6}}>
          Все важные даты в хронологическом порядке — от регистрации до первого дня учёбы.
        </p>
      </div>

      {/* key stats */}
      <div style={{display:'grid',gridTemplateColumns:'repeat(3,1fr)',
        borderTop:`1px solid ${line}`,borderLeft:`1px solid ${line}`,marginBottom:28}}>
        {[
          {l:'СРОЧНЫХ ЗАДАЧ', v:`${urgentCount}`, c:urgentCount>0?red:grn},
          {l:'БЛИЖАЙШЕЕ',     v:nextEvent?formatDate(nextEvent.date):'—', c:t1},
          {l:'ВСЕГО СОБЫТИЙ', v:`${allEvents.length}`, c:t1},
        ].map((s,i)=>(
          <div key={i} style={{padding:'16px 18px',
            borderRight:`1px solid ${line}`,borderBottom:`1px solid ${line}`}}>
            <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:8}}>{s.l}</div>
            <div style={{fontFamily:serif,fontStyle:'italic',fontSize:24,color:s.c,letterSpacing:'-.02em'}}>{s.v}</div>
          </div>
        ))}
      </div>

      {/* calendar export */}
      <div style={{padding:'18px 20px',marginBottom:28,borderRadius:10,
        background:bg1,border:`1px solid ${line}`,
        display:'flex',alignItems:'center',gap:16,flexWrap:'wrap'}}>
        <div style={{flex:1,minWidth:200}}>
          <div style={{fontFamily:sans,fontSize:14,color:t1,fontWeight:500,
            letterSpacing:'-.01em',marginBottom:4}}>
            Добавить все дедлайны в календарь
          </div>
          <div style={{fontFamily:sans,fontSize:12,color:t2}}>
            Автоматические напоминания за 14 и 7 дней до каждой даты
          </div>
        </div>
        <div style={{display:'flex',gap:8,flexWrap:'wrap'}}>
          {/* Google Calendar */}
          <a href={makeGcalUrl(allEvents.find(e=>e.gcal)||allEvents[0])}
            target="_blank" rel="noopener"
            onClick={()=>{
              /* open each gcal event */
              allEvents.filter(e=>e.gcal).forEach((e,i)=>{
                setTimeout(()=>window.open(makeGcalUrl(e),'_blank'),i*300)
              })
            }}
            className="cal-btn"
            style={{display:'flex',alignItems:'center',gap:8,
              padding:'10px 16px',borderRadius:8,
              background:'rgba(66,133,244,.12)',border:'1px solid rgba(66,133,244,.35)',
              color:'#4285F4',textDecoration:'none',fontFamily:sans,fontSize:13,fontWeight:500}}>
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
              <rect x="1" y="3" width="14" height="12" rx="2" stroke="#4285F4" strokeWidth="1.3"/>
              <line x1="1" y1="7" x2="15" y2="7" stroke="#4285F4" strokeWidth="1.3"/>
              <line x1="5" y1="1" x2="5" y2="5" stroke="#4285F4" strokeWidth="1.3" strokeLinecap="round"/>
              <line x1="11" y1="1" x2="11" y2="5" stroke="#4285F4" strokeWidth="1.3" strokeLinecap="round"/>
            </svg>
            Google Calendar
          </a>

          {/* Apple / ICS */}
          <button onClick={downloadICS} className="cal-btn" style={{
            display:'flex',alignItems:'center',gap:8,
            padding:'10px 16px',borderRadius:8,
            background:exported?`${grn}15`:'rgba(255,255,255,.05)',
            border:`1px solid ${exported?grn+'50':'rgba(255,255,255,.15)'}`,
            color:exported?grn:t1,fontFamily:sans,fontSize:13,fontWeight:500,cursor:'pointer'}}>
            <svg width="14" height="14" viewBox="0 0 16 16" fill="none">
              <path d="M8 1C4.13 1 1 4.13 1 8s3.13 7 7 7 7-3.13 7-7-3.13-7-7-7z" stroke="currentColor" strokeWidth="1.3"/>
              <path d="M8 4v5l3 2" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
            </svg>
            {exported?'Файл скачан ✓':'Apple Calendar (.ics)'}
          </button>
        </div>
      </div>

      {/* filter tabs */}
      <div style={{display:'flex',gap:4,marginBottom:24,
        padding:'4px',borderRadius:8,background:bg1,
        border:`1px solid ${line}`,width:'fit-content'}}>
        {[
          {v:'all',      l:'Все'},
          {v:'deadline', l:'Дедлайны'},
          {v:'milestone',l:'Вехи'},
          {v:'task',     l:'Задачи'},
        ].map(f=>(
          <button key={f.v} onClick={()=>setFilter(f.v)} style={{
            padding:'6px 14px',borderRadius:6,border:'none',
            background:filter===f.v?bg2:'transparent',
            color:filter===f.v?t1:t2,
            fontFamily:sans,fontSize:12,fontWeight:filter===f.v?500:400,
            letterSpacing:'-.01em',cursor:'pointer',transition:'all .15s'}}>
            {f.l}
          </button>
        ))}
      </div>

      {/* timeline */}
      <div style={{position:'relative'}}>

        {/* vertical line */}
        <div style={{position:'absolute',left:20,top:8,bottom:8,
          width:1,background:line,zIndex:0}}/>

        {groups.map(([monthKey, monthEvents])=>{
          const monthLabel = formatMonth(monthKey+'-01')
          const isPast = monthKey < today.slice(0,7)
          const isCurrent = monthKey === today.slice(0,7)

          return (
            <div key={monthKey} style={{marginBottom:32,position:'relative',zIndex:1}}>

              {/* month label */}
              <div style={{display:'flex',alignItems:'center',gap:12,marginBottom:16}}>
                <div style={{width:40,height:40,borderRadius:'50%',
                  background:isCurrent?blue:isPast?bg2:bg1,
                  border:`1px solid ${isCurrent?blue:line}`,
                  display:'flex',alignItems:'center',justifyContent:'center',
                  flexShrink:0,zIndex:2,position:'relative'}}>
                  <div style={{fontFamily:mono,fontSize:8,color:isCurrent?t1:t2,
                    letterSpacing:'0.04em',textAlign:'center',lineHeight:1.2}}>
                    {new Date(monthKey+'-01').toLocaleDateString('ru-RU',{month:'short'}).toUpperCase()}
                  </div>
                </div>
                <div>
                  <div style={{fontFamily:serif,fontStyle:'italic',fontSize:16,color:isCurrent?blue:isPast?t3:t1,
                    letterSpacing:'-.01em'}}>
                    {monthLabel}
                  </div>
                  {isCurrent&&(
                    <div style={{fontFamily:mono,fontSize:8,color:blue,letterSpacing:'0.1em'}}>
                      СЕЙЧАС
                    </div>
                  )}
                </div>
              </div>

              {/* events in month */}
              <div style={{marginLeft:56,display:'flex',flexDirection:'column',gap:6}}>
                {monthEvents.map((event,ei)=>{
                  const diff = daysFromNow(event.date)
                  const isPastEvent = event.date < today
                  return (
                    <div key={event.id} className="ev-row"
                      style={{display:'flex',alignItems:'flex-start',gap:14,
                        padding:'12px 16px',borderRadius:8,
                        background:event.urgent&&!isPastEvent?`${event.color}08`:'rgba(255,255,255,.02)',
                        border:`1px solid ${event.urgent&&!isPastEvent?`${event.color}25`:line}`,
                        borderLeft:`2px solid ${isPastEvent?t3:event.color}`,
                        opacity:isPastEvent?.5:1,
                        animation:`fadeUp .35s ease ${ei*.04}s both`}}>

                      {/* type icon */}
                      <div style={{width:28,height:28,borderRadius:6,flexShrink:0,
                        background:`${event.color}15`,
                        border:`1px solid ${event.color}30`,
                        display:'flex',alignItems:'center',justifyContent:'center'}}>
                        <span style={{fontFamily:mono,fontSize:11,color:event.color}}>
                          {TYPE_ICON[event.type]}
                        </span>
                      </div>

                      <div style={{flex:1,minWidth:0}}>
                        <div style={{display:'flex',alignItems:'flex-start',
                          justifyContent:'space-between',gap:8,marginBottom:2}}>
                          <div style={{fontFamily:sans,fontSize:13,fontWeight:500,
                            color:isPastEvent?t2:t1,letterSpacing:'-.01em',lineHeight:1.3}}>
                            {event.label}
                          </div>
                          <div style={{flexShrink:0,textAlign:'right'}}>
                            <div style={{fontFamily:mono,fontSize:10,
                              color:event.urgent&&!isPastEvent?event.color:t2}}>
                              {formatDate(event.date)}
                            </div>
                            {!isPastEvent&&diff<=30&&(
                              <div style={{fontFamily:mono,fontSize:9,color:red,
                                animation:'pulse 2s infinite',letterSpacing:'0.06em'}}>
                                {diff}д.
                              </div>
                            )}
                          </div>
                        </div>

                        {event.sub&&(
                          <div style={{fontFamily:sans,fontSize:11,color:t2,lineHeight:1.4}}>
                            {event.sub}
                          </div>
                        )}

                        <div style={{display:'flex',alignItems:'center',gap:8,marginTop:6}}>
                          {/* type badge */}
                          <span style={{fontFamily:mono,fontSize:8,letterSpacing:'0.08em',
                            padding:'2px 6px',borderRadius:3,
                            background:`${event.color}12`,border:`1px solid ${event.color}25`,
                            color:event.color}}>
                            {event.type==='deadline'?'ДЕДЛАЙН':
                             event.type==='milestone'?'ВЕХА':
                             event.type==='task'?'ЗАДАЧА':'ЦЕЛЬ'}
                          </span>

                          {event.urgent&&!isPastEvent&&(
                            <span style={{fontFamily:mono,fontSize:8,color:red,
                              letterSpacing:'0.08em',animation:'pulse 2s infinite'}}>
                              СРОЧНО
                            </span>
                          )}

                          {/* add to gcal */}
                          {event.gcal&&!isPastEvent&&(
                            <a href={makeGcalUrl(event)} target="_blank" rel="noopener"
                              style={{marginLeft:'auto',fontFamily:mono,fontSize:8,color:t3,
                                letterSpacing:'0.06em',textDecoration:'none',
                                padding:'2px 8px',borderRadius:3,
                                border:`1px solid ${line}`,transition:'color .15s'}}
                              onMouseEnter={e=>(e.target as HTMLElement).style.color='#4285F4'}
                              onMouseLeave={e=>(e.target as HTMLElement).style.color=t3}>
                              + CALENDAR
                            </a>
                          )}
                        </div>
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
  )
}
