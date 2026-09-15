'use client'
import { useState, useEffect } from 'react'
import { bg0, bg1, bg2, line, t1, t2, t3, gold, red, grn, sans, serif, mono } from '@/lib/theme'
import { buildJourney, UNIVERSAL_DOCS, FINANCIAL_DOCS, type JourneyPhase, type JourneyTask } from '@/lib/journey'
import LockIcon from '@/components/LockIcon'
import DocCard from '@/components/DocCard'

// Переписано 2026-09-15 по прямой просьбе Дениса: "даже 12-летний ребёнок
// понял что нужно делать шаг за шагом от идеи до переезда... абсолютно все
// шаги". Раньше здесь была 3-колоночная канбан-доска с параллельными
// "зонами" и выезжающей панелью деталей — визуально насыщенно, но саму
// идею "шаг за шагом сверху вниз" нужно было расшифровывать по легенде.
// Теперь — просто пронумерованный список шагов (①→⑧), сверху вниз, каждый
// разворачивается на месте. Контент/ветвление по профилю перенесены в
// lib/journey.ts без изменения логики — здесь только рендер.
//
// Свободен весь список, кроме одной явно помеченной ветки "Стипендии"
// (см. proBadge в lib/journey.ts) — так решил Денис, когда мы обсуждали
// объём переписывания.

function Bar({v=0,color=t1,h=2}:{v:number,color?:string,h?:number}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,borderRadius:1,
        animation:'barGrow .7s ease both',transformOrigin:'left'}}/>
    </div>
  )
}

function TaskRow({task, done, onToggle}:{task:JourneyTask, done:boolean, onToggle:()=>void}) {
  if (task.locked) return (
    <div style={{display:'flex',alignItems:'flex-start',gap:10,
      padding:'10px 12px',borderRadius:8,
      background:`${gold}0D`,border:`1px dashed ${gold}40`,
      borderLeft:`2px dashed ${gold}70`}}>
      <div style={{width:14,height:14,flexShrink:0,marginTop:2,
        display:'flex',alignItems:'center',justifyContent:'center'}}><LockIcon size={11} color={gold} /></div>
      <div style={{fontFamily:sans,fontSize:12,fontWeight:500,color:gold,letterSpacing:'-.01em',lineHeight:1.45}}>
        {task.text}
      </div>
    </div>
  )
  const clickable = !task.done
  return (
    <div onClick={()=>clickable&&onToggle()}
      className={clickable?'task-r':undefined}
      style={{display:'flex',alignItems:'flex-start',gap:10,
        padding:'10px 12px',borderRadius:8,
        background:done?`${grn}0D`:'rgba(255,255,255,.02)',
        border:`1px solid ${done?`${grn}25`:task.urgent?`${red}28`:line}`,
        borderLeft:`2px solid ${done?grn:task.urgent?red:'transparent'}`,
        cursor:clickable?'pointer':'default',transition:'all .15s'}}>
      <div style={{width:15,height:15,borderRadius:'50%',flexShrink:0,marginTop:2,
        border:`1.5px solid ${done?grn:task.urgent?red:t3}`,
        background:done?grn:'transparent',
        display:'flex',alignItems:'center',justifyContent:'center',
        transition:'all .18s',boxShadow:done?`0 0 6px ${grn}35`:'none'}}>
        {done&&<span style={{color:bg0,fontSize:8,fontWeight:700}}>✓</span>}
      </div>
      <div style={{flex:1}}>
        <div style={{fontFamily:sans,fontSize:12.5,fontWeight:500,
          color:done?t2:t1,textDecoration:done?'line-through':'none',
          letterSpacing:'-.01em',lineHeight:1.45,marginBottom:task.urgent&&!done?3:0}}>
          {task.text}
        </div>
        {task.urgent&&!done&&(
          <span style={{fontFamily:mono,fontSize:8,color:red,
            letterSpacing:'0.1em',animation:'pulse 2s infinite'}}>СРОЧНО</span>
        )}
      </div>
      {done&&<span style={{fontFamily:mono,fontSize:8,color:grn,flexShrink:0,paddingTop:3}}>ГОТОВО</span>}
    </div>
  )
}

export default function Roadmap({profile, programs = [], taskDone = {}, onToggle, onOpenReality}:
  {profile:any, programs?:any[], taskDone?:Record<string,boolean>, onToggle:(k:string)=>void, onOpenReality?:()=>void}) {

  useEffect(()=>{
    const s = document.createElement('style')
    s.textContent = `
      @keyframes barGrow{from{transform:scaleX(0)}to{transform:scaleX(1)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      @keyframes stepIn{0%{opacity:0;transform:translateY(6px)}100%{opacity:1;transform:translateY(0)}}
      .task-r{transition:background .12s}
      .task-r:hover{background:rgba(255,255,255,.05)!important}
      .step-head{cursor:pointer;transition:background .15s}
      .step-head:hover{background:rgba(255,255,255,.025)}
    `
    document.head.appendChild(s)
    return()=>s.remove()
  },[])

  const phases = buildJourney(profile, programs)

  const doneCount = (ph: JourneyPhase) => ph.tasks.filter(t=>t.done||!!taskDone[t.key]).length
  const pct = (ph: JourneyPhase) => ph.tasks.length ? Math.round(doneCount(ph)/ph.tasks.length*100) : 0
  const totalT = phases.reduce((s,ph)=>s+ph.tasks.length,0)
  const doneT  = phases.reduce((s,ph)=>s+doneCount(ph),0)

  // По умолчанию открыт первый блокер, иначе первый активный шаг, иначе
  // самый первый — остальные свёрнуты до заголовка, чтобы страница не
  // выглядела как стена текста при первом заходе. Свернуть/развернуть
  // можно любой шаг, включая ещё не начатые — посмотреть, что впереди.
  const defaultOpenId = phases.find(p=>p.status==='blocker')?.id
    ?? phases.find(p=>p.status==='active')?.id
    ?? phases[0]?.id
  const [open, setOpen] = useState<Set<string>>(new Set(defaultOpenId ? [defaultOpenId] : []))
  const toggleOpen = (id:string) => setOpen(prev => {
    const next = new Set(prev)
    next.has(id) ? next.delete(id) : next.add(id)
    return next
  })

  const labelOf = (id:string) => phases.find(p=>p.id===id)?.title

  return (
    <div style={{height:'100%',overflowY:'auto'}}>
      <div style={{maxWidth:640,margin:'0 auto',padding:'28px 20px 60px'}}>

        {/* header */}
        <div style={{marginBottom:28}}>
          <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.11em',color:t3,marginBottom:10}}>
            ПЕРСОНАЛЬНЫЙ ПЛАН
          </div>
          <h1 style={{fontFamily:serif,fontStyle:'normal',fontSize:26,color:t1,
            fontWeight:800,letterSpacing:'-.02em',marginBottom:8,textWrap:'balance' as any}}>
            {profile.name?.split(' ')[0]}, вот весь путь от идеи до переезда
          </h1>
          <p style={{fontFamily:sans,fontSize:13,color:t2,fontWeight:300,marginBottom:16}}>
            8 шагов сверху вниз. Некоторые можно (и нужно) делать одновременно — это написано прямо на шаге.
          </p>
          <div style={{display:'flex',alignItems:'center',gap:10}}>
            <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>ЗАДАЧ ВЫПОЛНЕНО {doneT}/{totalT}</span>
            <div style={{flex:1}}><Bar v={Math.round(doneT/totalT*100)||0} color={t1} h={2}/></div>
          </div>
        </div>

        {/* stepper */}
        <div style={{position:'relative'}}>
          {phases.map((ph, i) => {
            const isOpen = open.has(ph.id)
            const p = pct(ph)
            const isLast = i === phases.length - 1
            const isBlocker = ph.status === 'blocker'

            return (
              <div key={ph.id} style={{display:'flex',gap:16,
                animation:`stepIn .35s ease ${i*.05}s both`}}>

                {/* number rail */}
                <div style={{display:'flex',flexDirection:'column',alignItems:'center',flexShrink:0,width:32}}>
                  <div style={{position:'relative'}}>
                    {isBlocker&&(
                      <div style={{position:'absolute',inset:-3,borderRadius:'50%',
                        border:`2px solid ${red}`,animation:'pulse 1.5s infinite'}}/>
                    )}
                    <div style={{width:32,height:32,borderRadius:'50%',flexShrink:0,
                      display:'flex',alignItems:'center',justifyContent:'center',
                      background: p===100 ? grn : ph.color,
                      color: bg0, fontFamily:mono, fontWeight:700, fontSize:13}}>
                      {p===100 ? '✓' : ph.n}
                    </div>
                  </div>
                  {!isLast&&<div style={{width:2,flex:1,minHeight:20,background:line,marginTop:4}}/>}
                </div>

                {/* card */}
                <div style={{flex:1,minWidth:0,paddingBottom:isLast?0:20}}>
                  <div className="step-head" onClick={()=>toggleOpen(ph.id)}
                    style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between',
                      gap:10,borderRadius:10,padding:'10px 12px',margin:'-10px -12px 0'}}>
                    <div style={{flex:1,minWidth:0}}>
                      <div style={{display:'flex',alignItems:'center',gap:8,flexWrap:'wrap',marginBottom:4}}>
                        <span style={{fontFamily:sans,fontSize:15,fontWeight:700,color:t1,letterSpacing:'-.01em'}}>
                          {ph.title}
                        </span>
                        {ph.proBadge&&(
                          <span style={{fontFamily:mono,fontSize:8,fontWeight:700,letterSpacing:'0.06em',
                            padding:'2px 6px',borderRadius:3,background:`${gold}18`,border:`1px solid ${gold}40`,color:gold}}>
                            PRO
                          </span>
                        )}
                        {isBlocker&&(
                          <span style={{fontFamily:mono,fontSize:8,fontWeight:700,letterSpacing:'0.08em',
                            color:red,animation:'pulse 2s infinite'}}>СРОЧНО</span>
                        )}
                      </div>
                      {ph.runsAlongside&&(
                        <div style={{fontFamily:mono,fontSize:9,color:gold,letterSpacing:'0.04em',marginBottom:2}}>
                          можно начинать одновременно с шагом {phases.find(x=>x.id===ph.runsAlongside![0])?.n}
                        </div>
                      )}
                      {!isOpen&&(
                        <p style={{fontFamily:sans,fontSize:12,color:t2,fontWeight:300,lineHeight:1.5,
                          overflow:'hidden',textOverflow:'ellipsis',display:'-webkit-box',
                          WebkitLineClamp:2,WebkitBoxOrient:'vertical' as any}}>
                          {ph.why}
                        </p>
                      )}
                    </div>
                    <div style={{display:'flex',alignItems:'center',gap:8,flexShrink:0}}>
                      {p>0&&<span style={{fontFamily:mono,fontSize:10,color:p===100?grn:ph.color}}>{p}%</span>}
                      <span style={{fontFamily:mono,fontSize:12,color:t3,transform:isOpen?'rotate(90deg)':'none',
                        transition:'transform .15s',display:'inline-block'}}>›</span>
                    </div>
                  </div>

                  {isOpen&&(
                    <div style={{marginTop:10}}>
                      {p>0&&<div style={{marginBottom:12}}><Bar v={p} color={ph.color} h={2}/></div>}

                      <p style={{fontFamily:sans,fontSize:12.5,color:t2,lineHeight:1.65,fontWeight:300,marginBottom:14}}>
                        {ph.why}
                      </p>

                      {ph.blockedBy&&ph.status==='locked'&&(
                        <div style={{padding:'9px 12px',borderRadius:8,background:`${red}08`,marginBottom:14}}>
                          <span style={{fontFamily:mono,fontSize:9,color:red,letterSpacing:'0.06em'}}>
                            СНАЧАЛА: {ph.blockedBy.map(labelOf).join(' и ')}
                          </span>
                        </div>
                      )}

                      <div style={{display:'flex',flexDirection:'column',gap:6,marginBottom:ph.id==='docs'?18:0}}>
                        {ph.tasks.map(task=>(
                          <TaskRow key={task.key} task={task}
                            done={!!task.done||!!taskDone[task.key]}
                            onToggle={()=>onToggle(task.key)}/>
                        ))}
                      </div>

                      {/* Документы — единственный шаг с полными карточками
                          апостиля/перевода/справок, не просто чекбоксами:
                          там нужно объяснение "что/где/сколько ждать", а не
                          одна строка задачи. */}
                      {ph.id==='docs'&&(
                        <div style={{background:bg2,border:`1px solid ${line}`,borderRadius:10,padding:'16px 16px 4px'}}>
                          <div style={{fontFamily:mono,fontSize:10,color:t3,letterSpacing:'0.1em',marginBottom:14}}>
                            АПОСТИЛЬ И ПЕРЕВОД — ПОДРОБНО
                          </div>
                          {UNIVERSAL_DOCS.map((d,i)=><DocCard key={d.name} step={d} n={i+1}/>)}
                          <div style={{fontFamily:mono,fontSize:10,color:t3,letterSpacing:'0.1em',marginTop:4,marginBottom:14}}>
                            ФИНАНСОВЫЕ СПРАВКИ — ТОЛЬКО ЕСЛИ ТРЕБУЮТСЯ
                          </div>
                          {FINANCIAL_DOCS.map((d,i)=><DocCard key={d.name} step={d} n={i+1}/>)}
                        </div>
                      )}

                      {ph.proNote&&(
                        <div onClick={onOpenReality} style={{display:'flex',alignItems:'center',gap:10,
                          marginTop:14,padding:'11px 13px',borderRadius:8,textAlign:'left',
                          background:`${gold}0D`,border:`1px solid ${gold}30`,
                          cursor:onOpenReality?'pointer':'default'}}>
                          <span style={{fontFamily:sans,fontSize:11.5,color:gold,lineHeight:1.5,flex:1}}>
                            {ph.proNote}
                          </span>
                          {onOpenReality&&<span style={{fontFamily:mono,fontSize:12,color:gold,flexShrink:0}}>→</span>}
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
