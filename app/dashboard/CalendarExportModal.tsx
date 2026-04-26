'use client'
import { useState } from 'react'

const bg0='#0A0A0C', bg1='#111115', bg2='#17171C'
const line='rgba(255,255,255,0.08)'
const t1='#F2EFE9', t2='#7A7670', t3='#3D3B38'
const gold='#C8A256', blue='#6B8CFF', red='#E5534B', grn='#3FB950'
const sans="'Geist',sans-serif"
const serif="'Instrument Serif',serif"
const mono="'Geist Mono',monospace"

/* ── reminder options ── */
const REMINDER_OPTIONS = [
  { id:'1mo',  label:'За месяц',     days:30,  minutes:43200 },
  { id:'2wk',  label:'За 2 недели',  days:14,  minutes:20160 },
  { id:'1wk',  label:'За неделю',    days:7,   minutes:10080 },
  { id:'3d',   label:'За 3 дня',     days:3,   minutes:4320  },
  { id:'1d',   label:'За день',      days:1,   minutes:1440  },
  { id:'1h',   label:'За час',       days:0,   minutes:60    },
]

export interface CalEvent {
  date: string   // YYYY-MM-DD
  label: string
  desc?: string
  urgent?: boolean
}

interface Props {
  events: CalEvent[]
  onClose: () => void
}

function makeGcalUrl(ev: CalEvent, reminders: string[]): string {
  const dt = ev.date.replace(/-/g,'')
  const next = new Date(ev.date); next.setDate(next.getDate()+1)
  const dtEnd = next.toISOString().slice(0,10).replace(/-/g,'')
  const title = encodeURIComponent(`📅 ${ev.label}`)
  const details = encodeURIComponent(
    `${ev.desc||'Masterly — план поступления'}\n\nНапоминания настроены через Masterly.`
  )
  return `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${title}&dates=${dt}/${dtEnd}&details=${details}&sf=true&output=xml`
}

function makeICS(events: CalEvent[], selectedReminders: string[]): string {
  const reminders = REMINDER_OPTIONS.filter(r => selectedReminders.includes(r.id))
  const lines = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Masterly//Deadlines//RU',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:Masterly — Дедлайны',
    'X-WR-CALDESC:Все дедлайны поступления в магистратуру',
    'X-WR-TIMEZONE:Europe/Moscow',
  ]

  events.forEach(ev => {
    const dt = ev.date.replace(/-/g,'')
    const next = new Date(ev.date); next.setDate(next.getDate()+1)
    const dtEnd = next.toISOString().slice(0,10).replace(/-/g,'')
    const uid = `${dt}-${ev.label.replace(/\s/g,'-').toLowerCase()}@masterly.app`

    lines.push(
      'BEGIN:VEVENT',
      `DTSTART;VALUE=DATE:${dt}`,
      `DTEND;VALUE=DATE:${dtEnd}`,
      `SUMMARY:${ev.label}`,
      `DESCRIPTION:${ev.desc || 'Masterly — план поступления'}`,
      `UID:${uid}`,
      `STATUS:CONFIRMED`,
    )

    // add alarms for each selected reminder
    reminders.forEach(r => {
      // for day-based: trigger on day at 9:00
      const trigger = r.minutes === 60
        ? 'TRIGGER:-PT1H'
        : `TRIGGER:-P${r.days}D`
      lines.push(
        'BEGIN:VALARM',
        'ACTION:DISPLAY',
        trigger,
        `DESCRIPTION:${r.label}: ${ev.label}`,
        'END:VALARM',
      )
    })

    // always add 1 hour before as well if not already selected
    if (!selectedReminders.includes('1h')) {
      lines.push(
        'BEGIN:VALARM',
        'ACTION:DISPLAY',
        'TRIGGER:-PT1H',
        `DESCRIPTION:Через час: ${ev.label}`,
        'END:VALARM',
      )
    }

    lines.push('END:VEVENT')
  })

  lines.push('END:VCALENDAR')
  return lines.join('\r\n')
}

export default function CalendarExportModal({ events, onClose }: Props) {
  const [selected, setSelected] = useState<string[]>(['2wk', '1d', '1h'])
  const [target, setTarget] = useState<'both'|'google'|'apple'>('both')
  const [step, setStep] = useState<'config'|'done'>('config')
  const [exported, setExported] = useState<string[]>([])

  const toggle = (id: string) => {
    setSelected(s => s.includes(id) ? s.filter(x=>x!==id) : [...s,id])
  }

  const doExport = () => {
    const actions: string[] = []

    if (target === 'apple' || target === 'both') {
      const ics = makeICS(events, selected)
      const blob = new Blob([ics], {type:'text/calendar;charset=utf-8'})
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url; a.download = 'masterly-deadlines.ics'; a.click()
      URL.revokeObjectURL(url)
      actions.push('apple')
    }

    if (target === 'google' || target === 'both') {
  // Google Calendar supports ICS import - much better than opening tabs
  const ics = makeICS(events, selected)
  const blob = new Blob([ics], {type:'text/calendar;charset=utf-8'})
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url; a.download = 'masterly-google.ics'; a.click()
  URL.revokeObjectURL(url)
  actions.push('google')
}

    setExported(actions)
    setStep('done')
  }

  return (
    <div style={{
      position:'fixed', inset:0, zIndex:1000,
      background:'rgba(0,0,0,.7)',
      backdropFilter:'blur(8px)',
      display:'flex', alignItems:'center', justifyContent:'center',
      padding:20,
    }} onClick={e=>e.target===e.currentTarget&&onClose()}>

      <div style={{
        width:'100%', maxWidth:520,
        background:bg1,
        border:`1px solid ${line}`,
        borderRadius:12,
        overflow:'hidden',
        boxShadow:'0 24px 64px rgba(0,0,0,.6)',
      }}>

        {/* header */}
        <div style={{
          padding:'24px 28px 20px',
          borderBottom:`1px solid ${line}`,
          background:`linear-gradient(135deg,${blue}0A,transparent 60%)`,
          position:'relative',
        }}>
          <div style={{position:'absolute',top:0,left:0,right:0,height:2,
            background:`linear-gradient(90deg,${blue},${gold},transparent)`}}/>

          <div style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between'}}>
            <div>
              <div style={{fontFamily:mono,fontSize:9,color:blue,
                letterSpacing:'0.12em',marginBottom:10}}>
                ЭКСПОРТ В КАЛЕНДАРЬ
              </div>
              <h2 style={{fontFamily:serif,fontStyle:'italic',fontSize:22,
                color:t1,fontWeight:400,letterSpacing:'-.015em',marginBottom:4}}>
                {step==='done' ? 'Готово!' : 'Настрой напоминания'}
              </h2>
              <p style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300,lineHeight:1.6}}>
                {step==='done'
                  ? `Добавлено ${events.length} событий с напоминаниями`
                  : `${events.length} дедлайнов · выбери когда напоминать`}
              </p>
            </div>
            <button onClick={onClose} style={{
              background:'none',border:'none',color:t3,cursor:'pointer',
              fontFamily:mono,fontSize:14,padding:'4px 8px',borderRadius:4,
              transition:'color .15s',
            }}
              onMouseEnter={e=>(e.target as HTMLElement).style.color=t2}
              onMouseLeave={e=>(e.target as HTMLElement).style.color=t3}>
              ✕
            </button>
          </div>
        </div>

        {step==='config' ? (
          <>
            {/* reminders */}
            <div style={{padding:'20px 28px',borderBottom:`1px solid ${line}`}}>
              <div style={{fontFamily:mono,fontSize:9,color:t3,
                letterSpacing:'0.1em',marginBottom:14}}>
                НАПОМИНАТЬ
              </div>
              <div style={{display:'grid',gridTemplateColumns:'1fr 1fr 1fr',gap:8}}>
                {REMINDER_OPTIONS.map(r=>{
                  const isOn = selected.includes(r.id)
                  return (
                    <button key={r.id} onClick={()=>toggle(r.id)} style={{
                      padding:'10px 12px',borderRadius:7,cursor:'pointer',
                      border:`1px solid ${isOn?`${blue}60`:line}`,
                      background:isOn?`${blue}12`:bg2,
                      transition:'all .15s',
                    }}>
                      <div style={{fontFamily:sans,fontSize:13,fontWeight:isOn?500:400,
                        color:isOn?t1:t2,letterSpacing:'-.01em',marginBottom:2}}>
                        {r.label}
                      </div>
                      {r.id==='2wk'&&(
                        <div style={{fontFamily:mono,fontSize:8,color:blue,letterSpacing:'0.06em'}}>
                          РЕКОМЕНДУЕМ
                        </div>
                      )}
                      {r.id==='1h'&&(
                        <div style={{fontFamily:mono,fontSize:8,color:gold,letterSpacing:'0.06em'}}>
                          ВСЕГДА
                        </div>
                      )}
                      {isOn&&r.id!=='2wk'&&r.id!=='1h'&&(
                        <div style={{fontFamily:mono,fontSize:8,color:blue,letterSpacing:'0.06em'}}>
                          ВКЛЮЧЕНО
                        </div>
                      )}
                    </button>
                  )
                })}
              </div>
              <p style={{fontFamily:sans,fontSize:11,color:t3,marginTop:12,lineHeight:1.6}}>
                Напоминание за час добавляется всегда — чтобы точно не пропустить.
              </p>
            </div>

            {/* events preview */}
            <div style={{padding:'16px 28px',borderBottom:`1px solid ${line}`,maxHeight:180,overflowY:'auto'}}>
              <div style={{fontFamily:mono,fontSize:9,color:t3,
                letterSpacing:'0.1em',marginBottom:10}}>
                СОБЫТИЯ ({events.length})
              </div>
              {events.map((ev,i)=>(
                <div key={i} style={{display:'flex',alignItems:'center',gap:12,
                  padding:'7px 0',borderBottom:i<events.length-1?`1px solid ${line}`:'none'}}>
                  <div style={{width:5,height:5,borderRadius:'50%',
                    background:ev.urgent?red:blue,flexShrink:0}}/>
                  <span style={{fontFamily:sans,fontSize:12,color:t1,
                    flex:1,letterSpacing:'-.01em'}}>{ev.label}</span>
                  <span style={{fontFamily:mono,fontSize:10,color:t2,flexShrink:0}}>
                    {new Date(ev.date).toLocaleDateString('ru-RU',{day:'numeric',month:'short'})}
                  </span>
                </div>
              ))}
            </div>

            {/* target */}
            <div style={{padding:'16px 28px',borderBottom:`1px solid ${line}`}}>
              <div style={{fontFamily:mono,fontSize:9,color:t3,
                letterSpacing:'0.1em',marginBottom:12}}>ДОБАВИТЬ В</div>
              <div style={{display:'flex',gap:8}}>
                {[
                  {v:'both',   l:'Оба'},
                  {v:'google', l:'Google Calendar'},
                  {v:'apple',  l:'Apple / ICS'},
                ].map(o=>(
                  <button key={o.v} onClick={()=>setTarget(o.v as any)} style={{
                    flex:1,padding:'10px',borderRadius:7,cursor:'pointer',
                    border:`1px solid ${target===o.v?`${t1}50`:line}`,
                    background:target===o.v?'rgba(255,255,255,.07)':bg2,
                    fontFamily:sans,fontSize:12,fontWeight:target===o.v?500:400,
                    color:target===o.v?t1:t2,letterSpacing:'-.01em',
                    transition:'all .15s',
                  }}>{o.l}</button>
                ))}
              </div>
            </div>

            {/* action */}
            <div style={{padding:'20px 28px',display:'flex',gap:10}}>
              <button onClick={onClose} style={{
                padding:'12px 20px',borderRadius:8,border:`1px solid ${line}`,
                background:'transparent',color:t2,fontFamily:sans,
                fontSize:13,fontWeight:500,cursor:'pointer',letterSpacing:'-.01em',
                transition:'all .15s',
              }}
                onMouseEnter={e=>(e.target as HTMLElement).style.borderColor='rgba(255,255,255,.2)'}
                onMouseLeave={e=>(e.target as HTMLElement).style.borderColor=line}>
                Отмена
              </button>
              <button onClick={doExport} disabled={selected.length===0} style={{
                flex:1,padding:'12px',borderRadius:8,border:'none',
                background:selected.length>0?t1:'rgba(255,255,255,.06)',
                color:selected.length>0?bg0:t3,
                fontFamily:sans,fontSize:14,fontWeight:500,
                letterSpacing:'-.01em',cursor:selected.length>0?'pointer':'not-allowed',
                transition:'all .15s',
              }}>
                Добавить в календарь →
              </button>
            </div>
          </>
        ) : (
          /* done screen */
          <div style={{padding:'32px 28px',textAlign:'center'}}>
            <div style={{width:56,height:56,borderRadius:'50%',
              background:`${grn}15`,border:`1.5px solid ${grn}40`,
              display:'flex',alignItems:'center',justifyContent:'center',
              margin:'0 auto 16px'}}>
              <span style={{color:grn,fontSize:22}}>✓</span>
            </div>

            <h3 style={{fontFamily:serif,fontStyle:'italic',fontSize:20,
              color:t1,fontWeight:400,marginBottom:8}}>
              Дедлайны добавлены
            </h3>

            <div style={{display:'flex',flexDirection:'column',gap:8,
              margin:'20px 0',padding:'16px',borderRadius:8,
              background:bg2,border:`1px solid ${line}`,textAlign:'left'}}>
              {exported.includes('apple')&&(
                <div style={{display:'flex',alignItems:'center',gap:10}}>
                  <div style={{width:6,height:6,borderRadius:'50%',background:grn}}/>
                  <span style={{fontFamily:sans,fontSize:13,color:t2}}>
                    Файл <strong style={{color:t1}}>masterly-deadlines.ics</strong> скачан — открой его чтобы добавить в календарь
                  </span>
                </div>
              )}
              {exported.includes('google')&&(
  <div style={{display:'flex',alignItems:'flex-start',gap:10}}>
    <div style={{width:6,height:6,borderRadius:'50%',background:blue,marginTop:4,flexShrink:0}}/>
    <div>
      <span style={{fontFamily:sans,fontSize:13,color:t2}}>
        Файл <strong style={{color:t1}}>masterly-google.ics</strong> скачан.
      </span>
      <div style={{fontFamily:sans,fontSize:12,color:t3,marginTop:4,lineHeight:1.6}}>
        Открой <strong style={{color:t2}}>calendar.google.com</strong> → 
        Настройки (шестерёнка) → Импорт → выбери файл → Импортировать.
        Все {events.length} событий добавятся сразу.
      </div>
    </div>
  </div>
)}
              <div style={{display:'flex',alignItems:'center',gap:10,
                paddingTop:8,borderTop:`1px solid ${line}`,marginTop:4}}>
                <div style={{width:6,height:6,borderRadius:'50%',background:gold}}/>
                <span style={{fontFamily:sans,fontSize:12,color:t3}}>
                  Напоминания: {selected.map(id=>REMINDER_OPTIONS.find(r=>r.id===id)?.label).filter(Boolean).join(' · ')} · За час
                </span>
              </div>
            </div>

            <button onClick={onClose} style={{
              width:'100%',padding:'12px',borderRadius:8,border:'none',
              background:t1,color:bg0,fontFamily:sans,fontSize:14,
              fontWeight:500,letterSpacing:'-.01em',cursor:'pointer',
            }}>
              Готово
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
