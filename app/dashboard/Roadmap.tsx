'use client'
import { useState, useEffect } from 'react'

const bg0 = '#0A0A0C'
const bg1 = '#111115'
const bg2 = '#17171C'
const line = 'rgba(255,255,255,0.07)'
const t1 = '#F2EFE9'
const t2 = '#7A7670'
const t3 = '#3D3B38'
const gold = '#C8A256'
const blue = '#6B8CFF'
const red = '#E5534B'
const grn = '#3FB950'
const purp = '#A78BFA'
const sans = "'Geist',sans-serif"
const serif = "'Instrument Serif',serif"
const mono = "'Geist Mono',monospace"

interface Task { t: string; done?: boolean; urgent?: boolean }
interface Node {
  id: string; label: string; sub: string; color: string
  status: 'blocker'|'done'|'active'|'parallel'|'upcoming'|'locked'
  zone: 1|2|3; row: number; parallel: boolean
  tasks: Task[]; insight: string; blockedBy?: string[]
}

function buildNodes(p: any): Node[] {
  const ni = p.ielts < 6.5
  const sf = p.budget === 'zero'
  return [
    {
      id:'ielts', label:'IELTS', sub: ni ? `${p.ielts} → 6.5+` : `${p.ielts} ✓`,
      color: ni ? red : grn,
      status: ni ? 'blocker' : 'done',
      zone:1, row:1, parallel:false,
      insight: ni ? `Текущий балл ${p.ielts} — ниже минимума 6.5. Это единственный жёсткий блокер. Без него ни один вуз не примет заявку.` : `IELTS ${p.ielts} принят всеми вузами шортлиста. Для ETH нужно 7.0+.`,
      tasks: ni ? [
        {t:'Записаться на IELTS Academic — British Council или IDP', urgent:true},
        {t:'Пройти бесплатный mock test на Cambridge One'},
        {t:'Подготовка по Cambridge IELTS 14–17, минимум 8 недель'},
        {t:'Целевой балл 7.0 — запас на всякий случай'},
      ] : [{t:`IELTS ${p.ielts} — зачтено`, done:true}],
    },
    {
      id:'profile', label:'Профиль', sub:'CV + GitHub',
      color: purp, status:'active', zone:1, row:2, parallel:true,
      insight:`GPA ${p.gpa} — ${p.gpa>=4.0?'выше среднего для Европы':'достаточно для большинства программ'}. ${p.work==='no'?'Добавь проекты на GitHub — комиссия это проверяет.':'Опыт работы усиляет заявку.'}`,
      tasks:[
        {t:'Academic CV — Europass или Harvard формат, не LinkedIn'},
        {t:'GitHub: проекты с читаемым кодом, readme на английском'},
        {t:'Онлайн-курс от целевого вуза на Coursera / edX'},
        {t: p.work==='no' ? 'Найти стажировку или research project' : 'Описать опыт в academic формате'},
      ],
    },
    {
      id:'research', label:'Исследование', sub:'Вузы и программы',
      color: blue, status:'active', zone:1, row:3, parallel:true,
      insight:'Составь шортлист: 2 dream + 3 match + 2 safe. Напиши cold email 2–3 потенциальным supervisors — это даёт реальное преимущество.',
      tasks:[
        {t:'Изучить требования каждой программы в шортлисте'},
        {t:'Составить таблицу: дедлайны, требования, стоимость'},
        {t:'Написать cold email 2–3 потенциальным supervisors'},
        {t:'Зарегистрироваться в порталах вузов заранее'},
      ],
    },
    {
      id:'schol', label:'Стипендии', sub: sf ? 'СРОЧНО — 14 янв' : 'Параллельно',
      color: gold, status: sf ? 'active' : 'parallel', zone:2, row:1, parallel:true,
      insight: sf ? 'DAAD закрывается 14 января — раньше вузовских дедлайнов! Motivation Letter — отдельный документ, не SoP.' : 'Стипендии подаются параллельно с документами. Пропустишь дедлайн — ждать год.',
      tasks:[
        {t:'Motivation Letter для DAAD — отдельный документ, не SoP!', urgent:sf},
        {t:'Подать на DAAD через portal.daad.de — дедлайн 14 января', urgent:sf},
        {t:'SI Scholarship (Швеция) — дедлайн 15 февраля'},
        {t:'Проверить Erasmus Mundus и Holland Scholarship'},
      ],
    },
    {
      id:'docs', label:'Документы', sub:'SoP + рекомендации',
      color:'#D4843A', status:'upcoming', zone:2, row:2, parallel:true,
      blockedBy:['profile'],
      insight:'SoP пишется отдельно для каждого вуза — нельзя копировать. Рекомендации нужно запросить за 2+ месяца до дедлайна.',
      tasks:[
        {t:'Запросить рекомендации у 2–3 профессоров — прямо сейчас!', urgent:true},
        {t:'Statement of Purpose для каждого вуза — упоминай лабораторию'},
        {t:'Перевести транскрипт и диплом у нотариуса'},
        {t:'Проверить форматы файлов в порталах каждого вуза'},
      ],
    },
    {
      id:'apply', label:'Подача заявок', sub:'Дек — Фев',
      color: blue, status:'locked', zone:3, row:1, parallel:false,
      blockedBy:['ielts','docs'],
      insight:'Подавай последовательно — начни с менее приоритетных для практики. Каждая заявка занимает 2–4 часа.',
      tasks:[
        {t:'TU Munich — через TUMonline, дедлайн 15 янв'},
        {t:'Aalto — через universityadmissions.fi, дедлайн 20 янв'},
        {t:'TU Delft — через Studielink, дедлайн 01 фев'},
        {t:'KTH Stockholm — дедлайн 15 фев'},
      ],
    },
    {
      id:'result', label:'Оффер и переезд', sub:`Сент ${p.timeline}`,
      color: grn, status:'locked', zone:3, row:2, parallel:false,
      blockedBy:['apply'],
      insight:'Сразу после оффера — виза и жильё. Не медли: места в общежитиях заканчиваются в первые дни.',
      tasks:[
        {t:'Принять оффер (4–6 недель на решение)'},
        {t:'Подать на студенческую визу сразу после оффера'},
        {t:'Найти жильё — Wohnungssuche / Kamernet / Spotahome'},
        {t:`Начало учёбы — сентябрь ${p.timeline}`},
      ],
    },
  ]
}

const STATUS_LABEL: Record<string,string> = {
  blocker:'БЛОКЕР', done:'ГОТОВО', active:'АКТИВНО',
  parallel:'ПАРАЛЛЕЛЬНО', upcoming:'СКОРО', locked:'ПОСЛЕ',
}

function Bar({v=0,color=t1,h=2}:{v:number,color?:string,h?:number}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,borderRadius:1,
        animation:'barGrow .7s ease both',transformOrigin:'left'}}/>
    </div>
  )
}

export default function Roadmap({profile, taskDone = {}, onToggle}:{profile:any, taskDone?:Record<string,boolean>, onToggle:(k:string)=>void}) {
  const [active, setActive] = useState<string|null>(null)
 

  useEffect(()=>{
    const s = document.createElement('style')
    s.textContent = `
      @keyframes barGrow{from{transform:scaleX(0)}to{transform:scaleX(1)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      @keyframes popIn{0%{opacity:0;transform:scale(.85) translateY(8px)}100%{opacity:1;transform:scale(1) translateY(0)}}
      @keyframes slideR{from{opacity:0;transform:translateX(16px)}to{opacity:1;transform:translateX(0)}}
      @keyframes glow{0%,100%{box-shadow:0 0 0 0 var(--gc)}50%{box-shadow:0 0 0 8px var(--gc)}}
      .bubble{transition:transform .2s cubic-bezier(.34,1.56,.64,1),box-shadow .2s;cursor:pointer}
      .bubble:hover{transform:translateY(-4px) scale(1.04)}
      .bubble.active-b{transform:translateY(-4px) scale(1.04)}
      .task-r{transition:background .12s;cursor:pointer}
      .task-r:hover{background:rgba(255,255,255,.04)!important}
    `
    document.head.appendChild(s)
    return()=>s.remove()
  },[])

  const nodes = buildNodes(profile)
  const activeNode = nodes.find(n=>n.id===active)
  const toggle = (id:string,ti:number) => {
    const k=`${id}-${ti}`
    onToggle(d=>({...d,[k]:!d[k]}))
  }
  const pct = (n:Node) => {
    const d = n.tasks.filter((t,ti)=>t.done||!!taskDone[`${n.id}-${ti}`]).length
    return n.tasks.length?Math.round(d/n.tasks.length*100):0
  }
  const totalT = nodes.reduce((s,n)=>s+n.tasks.length,0)
  const doneT  = nodes.reduce((s,n)=>s+n.tasks.filter((t,ti)=>t.done||!!taskDone[`${n.id}-${ti}`]).length,0)

  const zones = [
    {n:1, label:'Старт', sub:'Начинай всё сразу', color:blue,   nodes:nodes.filter(n=>n.zone===1)},
    {n:2, label:'Подготовка', sub:'Параллельно со стартом', color:gold, nodes:nodes.filter(n=>n.zone===2)},
    {n:3, label:'Финал', sub:'Когда всё готово', color:grn,  nodes:nodes.filter(n=>n.zone===3)},
  ]

  const BUBBLE_SIZE = 140

  return (
    <div style={{display:'flex',height:'100%',overflow:'hidden'}}>

      {/* ── MAP AREA ── */}
      <div style={{flex:1,display:'flex',flexDirection:'column',overflow:'hidden'}}>

        {/* header */}
        <div style={{padding:'28px 36px 24px',borderBottom:`1px solid ${line}`,flexShrink:0}}>
          <div style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between'}}>
            <div>
              <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.11em',color:t3,marginBottom:10}}>
                ПЕРСОНАЛЬНЫЙ РОАДМАП
              </div>
              <h1 style={{fontFamily:serif,fontStyle:'italic',fontSize:28,color:t1,
                fontWeight:400,letterSpacing:'-.02em',marginBottom:6}}>
                {profile.name?.split(' ')[0]}, вот твой путь в Европу
              </h1>
              <p style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300}}>
                Нажми на блок — увидишь задачи. Блоки в одной зоне можно делать параллельно.
              </p>
            </div>
            <div style={{textAlign:'right',flexShrink:0}}>
              <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:6}}>ПРОГРЕСС</div>
              <div style={{fontFamily:serif,fontStyle:'italic',fontSize:36,color:t1,letterSpacing:'-.03em',lineHeight:1}}>
                {Math.round(doneT/totalT*100)||0}<span style={{fontSize:16,opacity:.4}}>%</span>
              </div>
              <div style={{width:80,marginTop:8,marginLeft:'auto'}}>
                <Bar v={Math.round(doneT/totalT*100)||0} color={t1} h={2}/>
              </div>
            </div>
          </div>
        </div>

        {/* roadmap grid */}
        <div style={{flex:1,overflowY:'auto',padding:'32px 36px'}}>

          {/* legend */}
          <div style={{display:'flex',gap:20,marginBottom:28}}>
            {[
              {c:red,   l:'Блокер — разблокирует следующее', dot:true, pulse:true},
              {c:gold,  l:'Параллельный — делай сейчас', dot:true},
              {c:t3,    l:'Заблокировано — сначала другое', dot:true, dim:true},
            ].map((l,i)=>(
              <div key={i} style={{display:'flex',alignItems:'center',gap:7}}>
                <div style={{width:8,height:8,borderRadius:'50%',
                  background:l.dim?'transparent':l.c,
                  border:`1.5px solid ${l.c}`,opacity:l.dim?.5:1,
                  animation:l.pulse?'pulse 1.5s infinite':'none'}}/>
                <span style={{fontFamily:mono,fontSize:9,color:t2,letterSpacing:'0.06em'}}>{l.l}</span>
              </div>
            ))}
          </div>

          {/* three zone columns */}
          <div style={{display:'grid',gridTemplateColumns:'1fr 1fr 1fr',gap:20,minHeight:400}}>
            {zones.map((zone,zi)=>(
              <div key={zone.n}>
                {/* zone header */}
                <div style={{marginBottom:20,padding:'12px 16px',borderRadius:8,
                  background:`${zone.color}08`,
                  border:`1px solid ${zone.color}20`,
                  borderTop:`2px solid ${zone.color}`}}>
                  <div style={{fontFamily:mono,fontSize:9,color:zone.color,
                    letterSpacing:'0.1em',marginBottom:4}}>
                    ЗОНА {zone.n} — {zone.label.toUpperCase()}
                  </div>
                  <div style={{fontFamily:sans,fontSize:12,color:t2}}>{zone.sub}</div>
                </div>

                {/* connector arrow between zones */}
                {zi<2&&(
                  <div style={{position:'absolute',
                    /* purely decorative — shown via column gap */}}/>
                )}

                {/* bubbles */}
                <div style={{display:'flex',flexDirection:'column',gap:16}}>
                  {zone.nodes.map((node,ni)=>{
                    const isActive = active===node.id
                    const p = pct(node)
                    const isLocked = node.status==='locked'
                    return (
                      <div key={node.id}
                        onClick={()=>setActive(isActive?null:node.id)}
                        className={`bubble${isActive?' active-b':''}`}
                        style={{
                          position:'relative',
                          borderRadius:16,
                          padding:'20px 22px',
                          background: isActive
                            ? `linear-gradient(135deg,${node.color}18,${node.color}08)`
                            : isLocked ? 'rgba(255,255,255,.015)' : bg2,
                          border:`1.5px solid ${isActive?node.color:isLocked?'rgba(255,255,255,.06)':node.color+'40'}`,
                          boxShadow: isActive ? `0 8px 32px ${node.color}20` : 'none',
                          opacity: isLocked ? .55 : 1,
                          transition:'all .2s',
                          animation:`popIn .4s cubic-bezier(.34,1.56,.64,1) ${ni*.08+zi*.15}s both`,
                        }}>

                        {/* blocker pulse ring */}
                        {node.status==='blocker'&&(
                          <div style={{position:'absolute',inset:-4,borderRadius:20,
                            border:`2px solid ${red}`,
                            animation:'pulse 1.5s infinite',pointerEvents:'none'}}/>
                        )}

                        {/* top row */}
                        <div style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between',marginBottom:10}}>
                          <div>
                            {/* status pill */}
                            <div style={{marginBottom:8}}>
                              <span style={{fontFamily:mono,fontSize:8,letterSpacing:'0.1em',
                                padding:'2px 7px',borderRadius:3,
                                background:`${node.color}20`,border:`1px solid ${node.color}40`,
                                color:node.color,
                                animation:node.status==='blocker'?'pulse 2s infinite':'none'}}>
                                {STATUS_LABEL[node.status]}
                              </span>
                            </div>
                            <div style={{fontFamily:sans,fontSize:15,fontWeight:600,
                              color:isLocked?t2:t1,letterSpacing:'-.01em',marginBottom:3}}>
                              {node.label}
                            </div>
                            <div style={{fontFamily:mono,fontSize:9,color:node.color,
                              letterSpacing:'0.06em'}}>{node.sub}</div>
                          </div>

                          {/* % circle */}
                          <div style={{width:40,height:40,borderRadius:'50%',
                            border:`2px solid ${p===100?grn:node.color}30`,
                            background:bg1,
                            display:'flex',alignItems:'center',justifyContent:'center',
                            flexShrink:0}}>
                            <span style={{fontFamily:mono,fontSize:10,color:p===100?grn:node.color}}>
                              {p>0?`${p}%`:'—'}
                            </span>
                          </div>
                        </div>

                        {/* progress bar */}
                        {p>0&&<div style={{marginBottom:10}}><Bar v={p} color={node.color} h={2}/></div>}

                        {/* parallel badge */}
                        {node.parallel&&!isLocked&&(
                          <div style={{display:'inline-flex',alignItems:'center',gap:5,
                            padding:'3px 8px',borderRadius:4,
                            background:`${gold}12`,border:`1px solid ${gold}25`,marginBottom:8}}>
                            <div style={{width:5,height:5,borderRadius:'50%',background:gold}}/>
                            <span style={{fontFamily:mono,fontSize:8,color:gold,letterSpacing:'0.08em'}}>
                              НАЧИНАЙ СЕЙЧАС
                            </span>
                          </div>
                        )}

                        {/* blocked by */}
                        {node.blockedBy&&isLocked&&(
                          <div style={{fontFamily:mono,fontSize:8,color:t3,letterSpacing:'0.06em'}}>
                            ПОСЛЕ: {node.blockedBy.map(id=>nodes.find(n=>n.id===id)?.label).join(' + ')}
                          </div>
                        )}

                        {/* task preview */}
                        {!isLocked&&(
                          <div style={{marginTop:10,paddingTop:10,borderTop:`1px solid ${line}`}}>
                            {node.tasks.slice(0,2).map((task,ti)=>{
                              const done=task.done||!!taskDone[`${node.id}-${ti}`]
                              return (
                                <div key={ti} style={{display:'flex',gap:8,alignItems:'center',
                                  marginBottom:4,opacity:done?.5:1}}>
                                  <div style={{width:5,height:5,borderRadius:'50%',flexShrink:0,
                                    background:done?grn:task.urgent?red:node.color,opacity:.7}}/>
                                  <span style={{fontFamily:sans,fontSize:11,color:done?t3:t2,
                                    textDecoration:done?'line-through':'none',
                                    letterSpacing:'-.01em',
                                    overflow:'hidden',textOverflow:'ellipsis',whiteSpace:'nowrap'}}>
                                    {task.t}
                                  </span>
                                </div>
                              )
                            })}
                            {node.tasks.length>2&&(
                              <div style={{fontFamily:mono,fontSize:8,color:t3,marginTop:4,letterSpacing:'0.06em'}}>
                                + ЕЩЁ {node.tasks.length-2} ЗАДАЧИ →
                              </div>
                            )}
                          </div>
                        )}
                      </div>
                    )
                  })}
                </div>
              </div>
            ))}
          </div>

          {/* flow arrows between zones */}
          <div style={{marginTop:28,padding:'16px 0',borderTop:`1px solid ${line}`,
            display:'flex',alignItems:'center',gap:8}}>
            <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>ПОСЛЕДОВАТЕЛЬНОСТЬ</span>
            <div style={{display:'flex',alignItems:'center',gap:6}}>
              {['ЗОНА 1 — Старт','→','ЗОНА 2 — Подготовка','→','ЗОНА 3 — Финал'].map((s,i)=>(
                <span key={i} style={{fontFamily:mono,fontSize:9,
                  color:s==='→'?t3:[blue,t3,gold,t3,grn][i],
                  letterSpacing:'0.06em'}}>{s}</span>
              ))}
            </div>
            <div style={{flex:1,height:1,background:line}}/>
            <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.06em'}}>
              ПАРАЛЛЕЛЬНЫЕ БЛОКИ ДЕЛАЙ ОДНОВРЕМЕННО
            </span>
          </div>
        </div>
      </div>

      {/* ── DETAIL PANEL ── */}
      {activeNode&&(
        <div style={{width:340,borderLeft:`1px solid ${line}`,
          background:bg1,overflowY:'auto',flexShrink:0,
          animation:'slideR .3s cubic-bezier(.22,.68,0,1.1) both'}}>

          {/* panel header */}
          <div style={{padding:'22px 22px 18px',borderBottom:`1px solid ${line}`,
            background:`linear-gradient(160deg,${activeNode.color}0C,transparent 60%)`,
            position:'relative'}}>
            <div style={{position:'absolute',top:0,left:0,right:0,height:2,
              background:`linear-gradient(90deg,${activeNode.color},transparent)`}}/>

            <div style={{display:'flex',alignItems:'center',justifyContent:'space-between',marginBottom:12}}>
              <span style={{fontFamily:mono,fontSize:9,letterSpacing:'0.1em',
                padding:'3px 8px',borderRadius:3,
                background:`${activeNode.color}20`,border:`1px solid ${activeNode.color}40`,
                color:activeNode.color,
                animation:activeNode.status==='blocker'?'pulse 2s infinite':'none'}}>
                {STATUS_LABEL[activeNode.status]}
              </span>
              <button onClick={()=>setActive(null)} style={{
                background:'none',border:'none',color:t3,cursor:'pointer',
                fontFamily:mono,fontSize:12,padding:'2px 6px',borderRadius:3}}>✕</button>
            </div>

            <h2 style={{fontFamily:serif,fontStyle:'italic',fontSize:22,color:t1,
              fontWeight:400,letterSpacing:'-.015em',lineHeight:1.1,marginBottom:4}}>
              {activeNode.label}
            </h2>
            <div style={{fontFamily:mono,fontSize:9,color:activeNode.color,letterSpacing:'0.08em',marginBottom:14}}>
              {activeNode.sub.toUpperCase()}
            </div>

            <div style={{display:'flex',justifyContent:'space-between',marginBottom:5}}>
              <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>ЗАДАЧ ВЫПОЛНЕНО</span>
              <span style={{fontFamily:mono,fontSize:9,color:activeNode.color}}>
                {activeNode.tasks.filter((t,ti)=>t.done||!!taskDone[`${activeNode.id}-${ti}`]).length} / {activeNode.tasks.length}
              </span>
            </div>
            <Bar v={pct(activeNode)} color={activeNode.color} h={3}/>
          </div>

          {/* why */}
          <div style={{padding:'14px 18px',borderBottom:`1px solid ${line}`,
            borderLeft:`3px solid ${activeNode.color}40`}}>
            <div style={{fontFamily:mono,fontSize:9,color:activeNode.color,
              letterSpacing:'0.1em',marginBottom:8}}>ПОЧЕМУ ЭТО ВАЖНО</div>
            <p style={{fontFamily:sans,fontSize:12,color:t2,lineHeight:1.7,fontWeight:300}}>
              {activeNode.insight}
            </p>
          </div>

          {/* parallel / blocked note */}
          {activeNode.parallel&&(
            <div style={{padding:'10px 18px',borderBottom:`1px solid ${line}`,background:`${gold}08`}}>
              <div style={{fontFamily:mono,fontSize:9,color:gold,letterSpacing:'0.08em',marginBottom:3}}>ПАРАЛЛЕЛЬНЫЙ ШАГ</div>
              <p style={{fontFamily:sans,fontSize:11,color:t2,fontWeight:300}}>
                Начинай прямо сейчас — не жди завершения других блоков.
              </p>
            </div>
          )}
          {activeNode.blockedBy&&(
            <div style={{padding:'10px 18px',borderBottom:`1px solid ${line}`,background:`${red}06`}}>
              <div style={{fontFamily:mono,fontSize:9,color:red,letterSpacing:'0.08em',marginBottom:3}}>ТРЕБУЕТ ГОТОВНОСТИ</div>
              <p style={{fontFamily:sans,fontSize:11,color:t2,fontWeight:300}}>
                Сначала: {activeNode.blockedBy.map(id=>nodes.find(n=>n.id===id)?.label).join(' и ')}
              </p>
            </div>
          )}

          {/* tasks */}
          <div style={{padding:'16px 18px'}}>
            <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.1em',marginBottom:12}}>ЗАДАЧИ</div>
            <div style={{display:'flex',flexDirection:'column',gap:6}}>
              {activeNode.tasks.map((task,ti)=>{
                const key=`${activeNode.id}-${ti}`
                const done=task.done||!!taskDone[key]
                return (
                  <div key={ti} onClick={()=>!task.done&&onToggle(`${activeNode.id}-${ti}`)}
                    className="task-r"
                    style={{display:'flex',alignItems:'flex-start',gap:12,
                      padding:'12px 14px',borderRadius:8,
                      background:done?'rgba(63,185,80,.05)':'rgba(255,255,255,.025)',
                      border:`1px solid ${done?`${grn}25`:task.urgent?`${red}28`:line}`,
                      borderLeft:`2px solid ${done?grn:task.urgent?red:'transparent'}`,
                      cursor:task.done?'default':'pointer',transition:'all .15s'}}>
                    <div style={{width:16,height:16,borderRadius:'50%',flexShrink:0,marginTop:1,
                      border:`1.5px solid ${done?grn:task.urgent?red:t3}`,
                      background:done?grn:'transparent',
                      display:'flex',alignItems:'center',justifyContent:'center',
                      transition:'all .18s',boxShadow:done?`0 0 6px ${grn}35`:'none'}}>
                      {done&&<span style={{color:bg0,fontSize:8,fontWeight:700}}>✓</span>}
                    </div>
                    <div style={{flex:1}}>
                      <div style={{fontFamily:sans,fontSize:12,fontWeight:500,
                        color:done?t2:t1,textDecoration:done?'line-through':'none',
                        letterSpacing:'-.01em',lineHeight:1.4,marginBottom:task.urgent&&!done?3:0}}>
                        {task.t}
                      </div>
                      {task.urgent&&!done&&(
                        <span style={{fontFamily:mono,fontSize:8,color:red,
                          letterSpacing:'0.1em',animation:'pulse 2s infinite'}}>СРОЧНО</span>
                      )}
                    </div>
                    {done&&<span style={{fontFamily:mono,fontSize:8,color:grn,flexShrink:0,paddingTop:2}}>ГОТОВО</span>}
                  </div>
                )
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
