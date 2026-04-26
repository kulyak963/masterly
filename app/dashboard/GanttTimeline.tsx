'use client'
import { useState, useEffect } from 'react'
import CalendarExportModal, { CalEvent } from './CalendarExportModal'

const bg0='#0A0A0C', bg1='#111115'
const line='rgba(255,255,255,0.07)'
const t1='#F2EFE9', t2='#7A7670', t3='#3D3B38'
const gold='#C8A256', blue='#6B8CFF', red='#E5534B', grn='#3FB950', purp='#A78BFA', amb='#D4843A'
const sans="'Geist',sans-serif"
const serif="'Instrument Serif',serif"
const mono="'Geist Mono',monospace"

const NOW = new Date(); NOW.setHours(0,0,0,0)

function toIdx(d: Date): number {
  return (d.getTime() - NOW.getTime()) / (1000*60*60*24*30.44)
}

function monthLabel(offset: number): string {
  return new Date(NOW.getFullYear(), NOW.getMonth()+offset, 1)
    .toLocaleDateString('ru-RU',{month:'short'}).replace('.','').toUpperCase()
}

function yearOf(offset: number): number {
  return new Date(NOW.getFullYear(), NOW.getMonth()+offset, 1).getFullYear()
}

interface Bar { startIdx:number; endIdx:number; label:string; blocker?:boolean }
interface Marker { idx:number; label:string; urgent?:boolean }
interface Lane { id:string; label:string; sub:string; color:string; bars:Bar[]; markers:Marker[] }

function buildLanes(profile: any): { lanes: Lane[], calEvents: CalEvent[] } {
  const admYear = parseInt(profile.timeline)||2026
  const dy = admYear-1
  const ni = profile.ielts < 6.5
  const sf = profile.budget === 'zero'
  const countries: string[] = (profile.countries?.split(',')||[]).filter(Boolean)

  const D = (y:number, m:number, d=15) => toIdx(new Date(y,m-1,d))
  const dateStr = (y:number,m:number,d=15) => {
    const dt = new Date(y,m-1,d)
    return dt.toISOString().slice(0,10)
  }

  const uniMap: Record<string,{label:string,idx:number,date:string}> = {
    ch:{label:'ETH Zurich',    idx:D(dy,12,15), date:dateStr(dy,12,15)},
    fr:{label:'Sciences Po',   idx:D(dy,1,9),   date:dateStr(dy,1,9)},
    de:{label:'TU Munich',     idx:D(dy,1,15),  date:dateStr(dy,1,15)},
    fi:{label:'Aalto',         idx:D(dy,1,20),  date:dateStr(dy,1,20)},
    nl:{label:'TU Delft',      idx:D(dy,2,1),   date:dateStr(dy,2,1)},
    se:{label:'KTH Stockholm', idx:D(dy,2,15),  date:dateStr(dy,2,15)},
    cz:{label:'CTU Prague',    idx:D(dy,2,28),  date:dateStr(dy,2,28)},
    at:{label:'TU Wien',       idx:D(dy,3,1),   date:dateStr(dy,3,1)},
  }

  const unis = countries.map(c=>uniMap[c]).filter(Boolean).sort((a,b)=>a.idx-b.idx)
  const firstDl = unis[0]?.idx ?? D(dy,1,15)
  const lastDl  = unis[unis.length-1]?.idx ?? D(dy,2,15)

  /* calendar events */
  const calEvents: CalEvent[] = [
    {date:dateStr(dy,1,9),  label:'Дедлайн — Eiffel Excellence', desc:'Стипендия Франция · €1 181/мес', urgent:true},
    {date:dateStr(dy,1,14), label:'Дедлайн — DAAD',              desc:'Стипендия Германия · €934/мес', urgent:sf},
    {date:dateStr(dy,2,15), label:'Дедлайн — SI Scholarship',    desc:'Стипендия Швеция · SEK 10 000/мес'},
    {date:dateStr(dy,2,1),  label:'Дедлайн — Holland Scholarship',desc:'Стипендия Нидерланды · €5 000'},
    ...unis.map(u=>({date:u.date, label:`Дедлайн подачи — ${u.label}`, desc:'Подача заявки в вуз', urgent:u.idx===firstDl})),
    {date:dateStr(admYear,4,15), label:'Ожидаются первые ответы от вузов', desc:'6–12 недель после дедлайна'},
    {date:dateStr(admYear,5,1),  label:'Принять оффер от вуза',  desc:'4–6 недель на решение'},
    {date:dateStr(admYear,5,7),  label:'Подать на студенческую визу', desc:'Германия 6–12 нед · Нидерланды 3–4 нед', urgent:true},
    {date:dateStr(admYear,9,1),  label:`Начало учёбы — сентябрь ${admYear}`, desc:'Переезд и первый день в вузе'},
  ].filter(e=>e.date>=NOW.toISOString().slice(0,10)) // only future
   .sort((a,b)=>a.date.localeCompare(b.date))

  const lanes: Lane[] = [
    {
      id:'ielts', label:'IELTS Academic',
      sub: ni?`Балл ${profile.ielts} → нужно 6.5+`:`Сдан — ${profile.ielts} ✓`,
      color: ni?red:grn,
      bars: ni?[
        {startIdx:0, endIdx:2.8, label:'Подготовка 8–12 недель', blocker:true},
        {startIdx:2.8, endIdx:3.4, label:'Экзамен + результаты'},
      ]:[{startIdx:0, endIdx:0.5, label:`IELTS ${profile.ielts} — готово`}],
      markers: ni?[{idx:3.0,label:'Сдать IELTS',urgent:true}]:[],
    },
    {
      id:'profile', label:'Профиль',
      sub:'Academic CV · GitHub · Курс',
      color:purp,
      bars:[{startIdx:0, endIdx:2.5, label:'CV · GitHub · онлайн-курс'}],
      markers:[{idx:2.5,label:'Профиль готов'}],
    },
    {
      id:'research', label:'Исследование',
      sub:'Вузы · Шортлист · Cold email',
      color:blue,
      bars:[{startIdx:0, endIdx:3, label:'Шортлист · Cold email профессорам'}],
      markers:[],
    },
    {
      id:'schol', label:'Стипендии',
      sub: sf?'⚡ DAAD — дедлайн 14 января':'Параллельно с документами',
      color:gold,
      bars:[{startIdx:0, endIdx:D(dy,1,14), label:'DAAD · Erasmus · SI · Holland', blocker:sf}],
      markers:[
        {idx:D(dy,1,9),  label:'Eiffel 9 янв', urgent:true},
        {idx:D(dy,1,14), label:'DAAD 14 янв',  urgent:sf},
        {idx:D(dy,2,15), label:'SI 15 фев'},
      ].filter(m=>m.idx>-0.3),
    },
    {
      id:'docs', label:'Документы',
      sub:'SoP · Рекомендации · Нотариус',
      color:amb,
      bars:[{startIdx:0.3, endIdx:firstDl-0.3, label:'SoP · Рекомендации · Переводы'}],
      markers:[
        {idx:0.3, label:'Запросить рекомендации', urgent:true},
        {idx:firstDl-0.3, label:'Пакет готов'},
      ],
    },
    {
      id:'apply', label:'Подача заявок',
      sub: unis.map(u=>u.label).join(' · ')||'По выбранным вузам',
      color:blue,
      bars:[{startIdx:firstDl, endIdx:lastDl+0.3, label:'Подача во все вузы'}],
      markers: unis.map(u=>({idx:u.idx,label:u.label,urgent:u.idx===firstDl})),
    },
    {
      id:'wait', label:'Ожидание решений',
      sub:'6–12 недель · Возможны интервью',
      color:t2,
      bars:[{startIdx:lastDl+0.3, endIdx:D(admYear,4,1), label:'Рассмотрение заявок'}],
      markers:[{idx:D(admYear,4,1), label:'Первые ответы'}],
    },
    {
      id:'final', label:'Оффер и переезд',
      sub:`Виза · Жильё · Старт ${admYear}`,
      color:grn,
      bars:[
        {startIdx:D(admYear,4,1), endIdx:D(admYear,5,15), label:'Принять оффер'},
        {startIdx:D(admYear,5,7), endIdx:D(admYear,9,1),  label:'Виза · Жильё'},
      ],
      markers:[
        {idx:D(admYear,5,7), label:'Подать на визу', urgent:true},
        {idx:D(admYear,9,1), label:`Переезд — Сент ${admYear}`},
      ],
    },
  ]

  return {lanes, calEvents}
}

export default function GanttTimeline({profile}:{profile:any}) {
  const [zoom, setZoom] = useState(1.4)
  const [ready, setReady] = useState(false)
  const [hoveredLane, setHoveredLane] = useState<string|null>(null)
  const [showModal, setShowModal] = useState(false)

  useEffect(()=>{
    const s=document.createElement('style')
    s.textContent=`
      @import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Geist:wght@300;400;500;600&family=Geist+Mono:wght@400;500&display=swap');
      @keyframes barIn{from{clip-path:inset(0 100% 0 0);opacity:0}to{clip-path:inset(0 0 0 0);opacity:1}}
      @keyframes fadeUp{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      @keyframes todayPulse{0%,100%{opacity:.8;box-shadow:0 0 10px #6B8CFF60}50%{opacity:.3;box-shadow:0 0 4px #6B8CFF30}}
      @keyframes diamondIn{0%{transform:rotate(45deg)scale(0)}70%{transform:rotate(45deg)scale(1.4)}100%{transform:rotate(45deg)scale(1)}}
      .g-bar{animation:barIn .9s cubic-bezier(.4,0,.2,1) both}
      .g-lane{transition:background .18s}
      .g-today{animation:todayPulse 3s ease-in-out infinite}
      .g-diamond{animation:diamondIn .5s cubic-bezier(.34,1.56,.64,1) both}
      .zoom-btn:hover{background:rgba(255,255,255,.1)!important}
      .cal-export-btn{transition:all .18s;cursor:pointer}
      .cal-export-btn:hover{transform:translateY(-1px);filter:brightness(1.1)}
      .cal-export-btn:active{transform:scale(.97)}
    `
    document.head.appendChild(s)
    setTimeout(()=>setReady(true),80)
    return()=>s.remove()
  },[])

  const {lanes, calEvents} = buildLanes(profile)
  const TOTAL=19, BASE_MW=70, MW=BASE_MW*zoom, LH=72, LW=220

  if(!ready) return (
    <div style={{flex:1,display:'flex',alignItems:'center',justifyContent:'center',background:bg0}}>
      <span style={{fontFamily:mono,fontSize:11,color:t3,letterSpacing:'0.1em'}}>ЗАГРУЗКА...</span>
    </div>
  )

  return (
    <>
      {showModal&&(
        <CalendarExportModal
          events={calEvents}
          onClose={()=>setShowModal(false)}
        />
      )}

      <div style={{display:'flex',flexDirection:'column',height:'100%',
        background:bg0,fontFamily:sans,color:t1,overflow:'hidden'}}>

        {/* ══ HEADER ══ */}
        <div style={{padding:'24px 32px 18px',borderBottom:`1px solid ${line}`,
          flexShrink:0,background:`linear-gradient(180deg,#0C0C12 0%,${bg0} 100%)`}}>

          <div style={{display:'flex',alignItems:'flex-start',
            justifyContent:'space-between',gap:20,marginBottom:16}}>
            <div>
              <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.12em',color:t3,marginBottom:8}}>
                ПЛАН-ГРАФИК ПОСТУПЛЕНИЯ
              </div>
              <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:28,
                color:t1,fontWeight:400,letterSpacing:'-.025em',marginBottom:4}}>
                От сегодня до переезда
              </h1>
              <p style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300}}>
                Строится из твоего профиля — страны, сроки и бюджет учтены.
              </p>
            </div>

            <div style={{display:'flex',flexDirection:'column',gap:10,alignItems:'flex-end'}}>
              {/* zoom */}
              <div style={{display:'flex',alignItems:'center',gap:8,
                padding:'6px 10px',borderRadius:8,border:`1px solid ${line}`,background:bg1}}>
                <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>МАСШТАБ</span>
                {[['−',-.2],['·',0],['+',+.2]].map(([lbl,delta],i)=>(
                  delta===0 ? (
                    <span key={i} style={{fontFamily:mono,fontSize:11,color:t1,
                      minWidth:36,textAlign:'center'}}>{Math.round(zoom*100)}%</span>
                  ) : (
                    <button key={i} className="zoom-btn" onClick={()=>setZoom(z=>Math.min(3,Math.max(.6,+(z+(delta as number)).toFixed(1))))}
                      style={{width:26,height:26,borderRadius:5,border:`1px solid ${line}`,
                        background:'transparent',color:t2,fontSize:15,cursor:'pointer',
                        display:'flex',alignItems:'center',justifyContent:'center',transition:'background .15s'}}>
                      {lbl}
                    </button>
                  )
                ))}
              </div>

              {/* export button */}
              <button onClick={()=>setShowModal(true)} className="cal-export-btn"
                style={{display:'flex',alignItems:'center',gap:10,
                  padding:'11px 20px',borderRadius:8,border:`1px solid ${blue}50`,
                  background:`${blue}12`,color:t1,
                  fontFamily:sans,fontSize:13,fontWeight:500,letterSpacing:'-.01em'}}>
                <svg width="15" height="15" viewBox="0 0 16 16" fill="none"
                  stroke={blue} strokeWidth="1.3" strokeLinecap="round">
                  <rect x="1.5" y="3" width="13" height="11.5" rx="1.5"/>
                  <line x1="1.5" y1="7" x2="14.5" y2="7"/>
                  <line x1="5" y1="1.5" x2="5" y2="4.5"/>
                  <line x1="11" y1="1.5" x2="11" y2="4.5"/>
                </svg>
                Добавить в календарь
                <span style={{fontFamily:mono,fontSize:9,color:blue,
                  padding:'2px 6px',borderRadius:3,background:`${blue}20`,
                  letterSpacing:'0.06em'}}>
                  {calEvents.length} событий
                </span>
              </button>
            </div>
          </div>

          {/* legend */}
          <div style={{display:'flex',gap:16,alignItems:'center',flexWrap:'wrap'}}>
            {[
              {c:red,   l:'Блокер',     stripe:true},
              {c:purp,  l:'Профиль'},
              {c:blue,  l:'Заявки'},
              {c:gold,  l:'Стипендии'},
              {c:amb,   l:'Документы'},
              {c:grn,   l:'Финал'},
              {c:t2,    l:'Ожидание'},
            ].map((l,i)=>(
              <div key={i} style={{display:'flex',alignItems:'center',gap:6}}>
                <div style={{width:20,height:7,borderRadius:2,background:l.c,
                  backgroundImage:l.stripe?'repeating-linear-gradient(45deg,transparent,transparent 3px,rgba(0,0,0,.25) 3px,rgba(0,0,0,.25) 6px)':'none'}}/>
                <span style={{fontFamily:mono,fontSize:9,color:t2,letterSpacing:'0.05em'}}>{l.l}</span>
              </div>
            ))}
            <div style={{display:'flex',alignItems:'center',gap:6,
              paddingLeft:10,borderLeft:`1px solid ${line}`,marginLeft:4}}>
              <div style={{width:2,height:14,background:blue,borderRadius:1}}/>
              <span style={{fontFamily:mono,fontSize:9,color:blue,letterSpacing:'0.05em'}}>СЕГОДНЯ</span>
            </div>
          </div>
        </div>

        {/* ══ CHART ══ */}
        <div style={{flex:1,overflow:'auto',position:'relative'}}>
          <div style={{minWidth:LW+TOTAL*MW,display:'flex',flexDirection:'column'}}>

            {/* month header */}
            <div style={{display:'flex',position:'sticky',top:0,zIndex:20,
              background:bg0,borderBottom:`2px solid ${line}`}}>
              <div style={{width:LW,flexShrink:0,borderRight:`1px solid ${line}`,
                padding:'10px 20px',background:bg1}}>
                <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em'}}>ЭТАП</span>
              </div>
              <div style={{display:'flex',flex:1}}>
                {Array.from({length:TOTAL}).map((_,i)=>{
                  const isNow=i===0
                  const showYear=i===0||yearOf(i)!==yearOf(i-1)
                  return(
                    <div key={i} style={{width:MW,flexShrink:0,
                      borderRight:`1px solid ${line}`,padding:'8px 0',
                      textAlign:'center',background:isNow?`${blue}10`:'transparent'}}>
                      {showYear&&(
                        <div style={{fontFamily:mono,fontSize:8,color:t3,
                          letterSpacing:'0.06em',marginBottom:2,
                          paddingBottom:2,borderBottom:`1px solid ${line}`}}>
                          {yearOf(i)}
                        </div>
                      )}
                      <div style={{fontFamily:mono,fontSize:zoom>1.2?11:9,
                        letterSpacing:'0.08em',fontWeight:isNow?600:400,
                        color:isNow?blue:t2}}>
                        {monthLabel(i)}
                      </div>
                    </div>
                  )
                })}
              </div>
            </div>

            {/* lanes */}
            {lanes.map((lane,li)=>{
              const isHov=hoveredLane===lane.id
              return(
                <div key={lane.id}
                  onMouseEnter={()=>setHoveredLane(lane.id)}
                  onMouseLeave={()=>setHoveredLane(null)}
                  className="g-lane"
                  style={{display:'flex',height:LH,
                    borderBottom:`1px solid ${line}`,
                    background:isHov?`${lane.color}08`:li%2===0?'rgba(255,255,255,.01)':'transparent',
                    animation:`fadeUp .45s ease ${li*.06}s both`}}>

                  <div style={{width:LW,flexShrink:0,borderRight:`1px solid ${line}`,
                    padding:'0 20px',display:'flex',flexDirection:'column',
                    justifyContent:'center',gap:4,
                    background:isHov?`${lane.color}0A`:bg1,transition:'background .18s'}}>
                    <div style={{display:'flex',alignItems:'center',gap:9}}>
                      <div style={{width:8,height:8,borderRadius:'50%',
                        background:lane.color,flexShrink:0,
                        boxShadow:`0 0 10px ${lane.color}80`}}/>
                      <span style={{fontFamily:sans,fontSize:14,fontWeight:600,
                        color:t1,letterSpacing:'-.01em'}}>{lane.label}</span>
                    </div>
                    <span style={{fontFamily:mono,fontSize:9,color:t3,
                      letterSpacing:'0.04em',paddingLeft:17,
                      overflow:'hidden',textOverflow:'ellipsis',whiteSpace:'nowrap'}}>
                      {lane.sub}
                    </span>
                  </div>

                  <div style={{flex:1,position:'relative',overflow:'visible'}}>
                    {/* grid */}
                    {Array.from({length:TOTAL}).map((_,mi)=>(
                      <div key={mi} style={{position:'absolute',
                        left:mi*MW,top:0,bottom:0,width:1,
                        background:mi===0?`${blue}50`:line,zIndex:0}}/>
                    ))}

                    {/* today */}
                    <div className="g-today" style={{
                      position:'absolute',left:2,top:0,bottom:0,
                      width:2,borderRadius:1,background:blue,zIndex:6}}/>

                    {/* bars */}
                    {lane.bars.map((bar,bi)=>{
                      const sl=Math.max(0,bar.startIdx)
                      const el=Math.max(sl+0.3,bar.endIdx)
                      const left=sl*MW, width=Math.max(MW*0.35,(el-sl)*MW)
                      return(
                        <div key={bi} className="g-bar" style={{
                          position:'absolute',left:left+5,top:'50%',
                          transform:'translateY(-50%)',
                          width:width-10,height:34,borderRadius:8,
                          background:bar.blocker
                            ?`linear-gradient(90deg,${lane.color},${lane.color}BB)`
                            :`linear-gradient(90deg,${lane.color}DD,${lane.color}88)`,
                          border:`1px solid ${lane.color}90`,
                          boxShadow:`0 3px 16px ${lane.color}20,inset 0 1px 0 rgba(255,255,255,.12)`,
                          display:'flex',alignItems:'center',padding:'0 12px',
                          overflow:'hidden',animationDelay:`${.15+li*.06+bi*.05}s`,zIndex:2,
                        }}>
                          {bar.blocker&&<div style={{position:'absolute',inset:0,borderRadius:8,
                            backgroundImage:'repeating-linear-gradient(45deg,transparent,transparent 6px,rgba(0,0,0,.2) 6px,rgba(0,0,0,.2) 12px)'}}/>}
                          <div style={{position:'absolute',top:0,left:0,right:0,height:'40%',
                            background:'linear-gradient(180deg,rgba(255,255,255,.08),transparent)',
                            borderRadius:'8px 8px 0 0',pointerEvents:'none'}}/>
                          <span style={{fontFamily:mono,fontSize:zoom>1.2?10:9,
                            color:'rgba(255,255,255,.92)',letterSpacing:'0.04em',
                            whiteSpace:'nowrap',position:'relative',zIndex:1,
                            overflow:'hidden',textOverflow:'ellipsis'}}>
                            {bar.label}
                          </span>
                        </div>
                      )
                    })}

                    {/* markers */}
                    {lane.markers.filter(m=>m.idx>-0.3&&m.idx<TOTAL).map((mk,mi)=>(
                      <div key={mi} style={{
                        position:'absolute',
                        left:Math.max(4,mk.idx*MW+MW/2),
                        top:0,bottom:0,zIndex:10,
                        display:'flex',flexDirection:'column',alignItems:'center',
                      }}>
                        <div style={{width:1,height:'100%',
                          background:mk.urgent?red:lane.color,opacity:.5}}/>
                        <div className="g-diamond" style={{
                          position:'absolute',top:'50%',marginTop:-6,
                          width:12,height:12,
                          background:mk.urgent?red:lane.color,
                          border:`2px solid ${bg0}`,
                          boxShadow:`0 0 12px ${mk.urgent?red:lane.color}90`,
                          animationDelay:`${.3+li*.06+mi*.06}s`,
                        }}/>
                        <div style={{
                          position:'absolute',bottom:4,
                          transform:'translateX(-50%)',
                          fontFamily:mono,fontSize:zoom>1.4?9:8,
                          color:mk.urgent?red:lane.color,letterSpacing:'0.04em',
                          whiteSpace:'nowrap',background:bg0,
                          padding:'2px 5px',borderRadius:3,
                          border:`1px solid ${mk.urgent?red+'35':lane.color+'25'}`,
                          animation:mk.urgent?'pulse 2s infinite':'none',
                        }}>
                          {mk.label}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )
            })}
            <div style={{height:40}}/>
          </div>
        </div>
      </div>
    </>
  )
}
