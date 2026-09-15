'use client'
import { useState, useEffect } from 'react'
import { bg0, bg1, bg2, line, t1, t2, t3, gold, red, grn, sans, serif, mono } from '@/lib/theme'
import { buildJourney, PARALLEL_PHASE_IDS, SEQUENTIAL_CHAIN_IDS, type JourneyPhase, type JourneyTask } from '@/lib/journey'
import LockIcon from '@/components/LockIcon'

// Переписано 2026-09-15, ВТОРОЙ заход за день. Первый (пронумерованный
// список 1-8 сверху вниз) Денис отклонил: "должно быть в виде цепочек
// зависимых и параллельных задач, наполни реальными задачами, а не
// фигней... гайд как для 14-летнего, разжёвано как когда зачем и почему".
// Два изменения относительно первой версии:
//   1. ВИЗУАЛ — параллельные шаги (research/ielts/profile/docs/schol)
//      сгруппированы в одну "скобку" без ложной нумерации 1-5 (раньше
//      нумерация подряд читалась как единая очередь, хотя на самом деле
//      это пучок). Дальше — настоящая цепочка со стрелками
//      apply → wait → final, каждое звено явно "после предыдущего".
//   2. КОНТЕНТ — у каждой задачи (JourneyTask в lib/journey.ts) теперь
//      четыре поля: что/как/когда/зачем, а не одна строка текста. Задача
//      разворачивается по клику отдельно от самой фазы (два уровня
//      разворота: фаза → список задач; задача → подробности).

function Bar({v=0,color=t1,h=2}:{v:number,color?:string,h?:number}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,borderRadius:1,
        animation:'barGrow .7s ease both',transformOrigin:'left'}}/>
    </div>
  )
}

function FactLine({label, value, color}:{label:string, value:string, color:string}) {
  if (!value) return null
  return (
    <div style={{display:'flex',gap:8,marginBottom:6,fontSize:12,lineHeight:1.55}}>
      <span style={{fontFamily:mono,fontSize:9,color,letterSpacing:'0.06em',flexShrink:0,paddingTop:2,width:62}}>{label}</span>
      <span style={{fontFamily:sans,color:t2,fontWeight:300}}>{value}</span>
    </div>
  )
}

function TaskRow({task, phaseColor, done, expanded, onToggleDone, onToggleExpand}:
  {task:JourneyTask, phaseColor:string, done:boolean, expanded:boolean, onToggleDone:()=>void, onToggleExpand:()=>void}) {

  if (task.locked) return (
    <div style={{display:'flex',alignItems:'flex-start',gap:10,
      padding:'10px 12px',borderRadius:8,
      background:`${gold}0D`,border:`1px dashed ${gold}40`,
      borderLeft:`2px dashed ${gold}70`}}>
      <div style={{width:14,height:14,flexShrink:0,marginTop:2,
        display:'flex',alignItems:'center',justifyContent:'center'}}><LockIcon size={11} color={gold} /></div>
      <div style={{fontFamily:sans,fontSize:12,fontWeight:500,color:gold,letterSpacing:'-.01em',lineHeight:1.45}}>
        {task.title}
      </div>
    </div>
  )

  const hasDetail = !!(task.what || task.how || task.when || task.why)
  return (
    <div style={{borderRadius:8,
      background:done?`${grn}0D`:'rgba(255,255,255,.02)',
      border:`1px solid ${done?`${grn}25`:task.urgent?`${red}28`:line}`,
      borderLeft:`2px solid ${done?grn:task.urgent?red:'transparent'}`,
      overflow:'hidden'}}>
      <div style={{display:'flex',alignItems:'flex-start',gap:10,padding:'10px 12px'}}>
        <div onClick={onToggleDone}
          style={{width:16,height:16,borderRadius:'50%',flexShrink:0,marginTop:2,cursor:'pointer',
            border:`1.5px solid ${done?grn:task.urgent?red:t3}`,
            background:done?grn:'transparent',
            display:'flex',alignItems:'center',justifyContent:'center',
            transition:'all .18s',boxShadow:done?`0 0 6px ${grn}35`:'none'}}>
          {done&&<span style={{color:bg0,fontSize:8,fontWeight:700}}>✓</span>}
        </div>
        <div onClick={hasDetail?onToggleExpand:undefined} style={{flex:1,cursor:hasDetail?'pointer':'default'}}>
          <div style={{display:'flex',alignItems:'center',gap:8}}>
            <span style={{fontFamily:sans,fontSize:12.5,fontWeight:600,
              color:done?t2:t1,textDecoration:done?'line-through':'none',
              letterSpacing:'-.01em',lineHeight:1.4}}>
              {task.title}
            </span>
            {task.urgent&&!done&&(
              <span style={{fontFamily:mono,fontSize:8,color:red,flexShrink:0,
                letterSpacing:'0.1em',animation:'pulse 2s infinite'}}>СРОЧНО</span>
            )}
          </div>
          {!expanded&&hasDetail&&(
            <div style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.04em',marginTop:2}}>
              что / как / когда / зачем ›
            </div>
          )}
        </div>
        {done&&<span style={{fontFamily:mono,fontSize:8,color:grn,flexShrink:0,paddingTop:3}}>ГОТОВО</span>}
      </div>
      {expanded&&hasDetail&&(
        <div style={{padding:'2px 14px 14px 38px'}}>
          <FactLine label="ЧТО" value={task.what} color={phaseColor}/>
          <FactLine label="КАК" value={task.how} color={phaseColor}/>
          <FactLine label="КОГДА" value={task.when} color={phaseColor}/>
          <FactLine label="СТОИМОСТЬ" value={task.cost||''} color={phaseColor}/>
          <FactLine label="ЗАЧЕМ" value={task.why} color={gold}/>
        </div>
      )}
    </div>
  )
}

function PhaseCard({phase, isOpen, pct, onToggleOpen, expandedTasks, onToggleTaskExpand, taskDone, onToggleTaskDone, onOpenReality, showProLine}:
  {phase:JourneyPhase, isOpen:boolean, pct:number, onToggleOpen:()=>void,
   expandedTasks:Set<string>, onToggleTaskExpand:(k:string)=>void,
   taskDone:Record<string,boolean>, onToggleTaskDone:(k:string)=>void,
   onOpenReality?:()=>void, showProLine:boolean}) {

  const isBlocker = phase.status === 'blocker'
  return (
    <div style={{borderRadius:12,border:`1px solid ${isBlocker?red+'50':line}`,
      background:bg2, overflow:'hidden',
      boxShadow:isBlocker?`0 0 0 1px ${red}25`:'none'}}>
      <div onClick={onToggleOpen} style={{cursor:'pointer',display:'flex',alignItems:'flex-start',
        justifyContent:'space-between',gap:10,padding:'14px 16px'}}>
        <div style={{display:'flex',gap:12,flex:1,minWidth:0}}>
          <div style={{width:9,height:9,borderRadius:'50%',flexShrink:0,marginTop:5,
            background:pct===100?grn:phase.color,
            boxShadow:isBlocker?`0 0 0 4px ${red}25`:'none',
            animation:isBlocker?'pulse 1.5s infinite':'none'}}/>
          <div style={{flex:1,minWidth:0}}>
            <div style={{display:'flex',alignItems:'center',gap:8,flexWrap:'wrap',marginBottom:3}}>
              <span style={{fontFamily:sans,fontSize:14.5,fontWeight:700,color:t1,letterSpacing:'-.01em'}}>
                {phase.title}
              </span>
              {phase.proBadge&&(
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
            {!isOpen&&(
              <p style={{fontFamily:sans,fontSize:11.5,color:t2,fontWeight:300,lineHeight:1.5,margin:0,
                overflow:'hidden',textOverflow:'ellipsis',display:'-webkit-box',
                WebkitLineClamp:2,WebkitBoxOrient:'vertical' as any}}>
                {phase.why}
              </p>
            )}
          </div>
        </div>
        <div style={{display:'flex',alignItems:'center',gap:8,flexShrink:0}}>
          {pct>0&&<span style={{fontFamily:mono,fontSize:10,color:pct===100?grn:phase.color}}>{pct}%</span>}
          <span style={{fontFamily:mono,fontSize:12,color:t3,transform:isOpen?'rotate(90deg)':'none',
            transition:'transform .15s',display:'inline-block'}}>›</span>
        </div>
      </div>

      {isOpen&&(
        <div style={{padding:'0 16px 16px'}}>
          {pct>0&&<div style={{marginBottom:12}}><Bar v={pct} color={phase.color} h={2}/></div>}
          <p style={{fontFamily:sans,fontSize:12.5,color:t2,lineHeight:1.65,fontWeight:300,marginBottom:14}}>
            {phase.why}
          </p>
          <div style={{display:'flex',flexDirection:'column',gap:6}}>
            {phase.tasks.map(task=>(
              <TaskRow key={task.key} task={task} phaseColor={phase.color}
                done={!!task.done||!!taskDone[task.key]}
                expanded={expandedTasks.has(task.key)}
                onToggleDone={()=>!task.done&&onToggleTaskDone(task.key)}
                onToggleExpand={()=>onToggleTaskExpand(task.key)}/>
            ))}
          </div>
          {showProLine&&phase.proNote&&(
            <div onClick={onOpenReality} style={{display:'flex',alignItems:'center',gap:10,
              marginTop:14,padding:'11px 13px',borderRadius:8,textAlign:'left',
              background:`${gold}0D`,border:`1px solid ${gold}30`,
              cursor:onOpenReality?'pointer':'default'}}>
              <span style={{fontFamily:sans,fontSize:11.5,color:gold,lineHeight:1.5,flex:1}}>
                {phase.proNote}
              </span>
              {onOpenReality&&<span style={{fontFamily:mono,fontSize:12,color:gold,flexShrink:0}}>→</span>}
            </div>
          )}
        </div>
      )}
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
    `
    document.head.appendChild(s)
    return()=>s.remove()
  },[])

  const allPhases = buildJourney(profile, programs)
  const byId = (id:string) => allPhases.find(p=>p.id===id)!
  const parallelPhases = PARALLEL_PHASE_IDS.map(byId)
  const chainPhases = SEQUENTIAL_CHAIN_IDS.map(byId)

  const doneCount = (ph: JourneyPhase) => ph.tasks.filter(t=>t.done||!!taskDone[t.key]).length
  const pct = (ph: JourneyPhase) => ph.tasks.length ? Math.round(doneCount(ph)/ph.tasks.length*100) : 0
  const totalT = allPhases.reduce((s,ph)=>s+ph.tasks.length,0)
  const doneT  = allPhases.reduce((s,ph)=>s+doneCount(ph),0)

  const defaultOpenId = parallelPhases.find(p=>p.status==='blocker')?.id
    ?? parallelPhases.find(p=>p.status==='active')?.id
    ?? parallelPhases[0]?.id
  const [openPhases, setOpenPhases] = useState<Set<string>>(new Set(defaultOpenId ? [defaultOpenId] : []))
  const togglePhase = (id:string) => setOpenPhases(prev => {
    const next = new Set(prev)
    next.has(id) ? next.delete(id) : next.add(id)
    return next
  })

  const [expandedTasks, setExpandedTasks] = useState<Set<string>>(new Set())
  const toggleTaskExpand = (k:string) => setExpandedTasks(prev => {
    const next = new Set(prev)
    next.has(k) ? next.delete(k) : next.add(k)
    return next
  })

  const readyForApply = chainPhases[0].blockedBy?.every(id => pct(byId(id))===100 || byId(id).tasks.every(t=>t.done||!!taskDone[t.key]))

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
            Первые пять блоков делай одновременно — они ни от чего не зависят. Дальше — по одному, каждый после предыдущего.
          </p>
          <div style={{display:'flex',alignItems:'center',gap:10}}>
            <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>ЗАДАЧ ВЫПОЛНЕНО {doneT}/{totalT}</span>
            <div style={{flex:1}}><Bar v={Math.round(doneT/totalT*100)||0} color={t1} h={2}/></div>
          </div>
        </div>

        {/* ── PARALLEL GROUP — визуальная скобка на 5 карточек, без нумерации,
            чтобы не читалось как ложная очередь. */}
        <div style={{position:'relative',paddingLeft:18,marginBottom:4}}>
          <div style={{position:'absolute',left:0,top:6,bottom:22,width:2,
            background:`linear-gradient(180deg,${gold}60,${gold}20)`,borderRadius:1}}/>
          <div style={{display:'flex',alignItems:'center',gap:8,marginBottom:14}}>
            <span style={{fontFamily:mono,fontSize:9,color:gold,letterSpacing:'0.1em'}}>
              ⇉ ЭТИ {parallelPhases.length} БЛОКА — ОДНОВРЕМЕННО, ПОРЯДОК НЕ ВАЖЕН
            </span>
          </div>
          <div style={{display:'flex',flexDirection:'column',gap:10}}>
            {parallelPhases.map((ph,i)=>(
              <div key={ph.id} style={{animation:`stepIn .35s ease ${i*.05}s both`}}>
                <PhaseCard phase={ph} isOpen={openPhases.has(ph.id)} pct={pct(ph)}
                  onToggleOpen={()=>togglePhase(ph.id)}
                  expandedTasks={expandedTasks} onToggleTaskExpand={toggleTaskExpand}
                  taskDone={taskDone} onToggleTaskDone={onToggle}
                  onOpenReality={onOpenReality} showProLine={true}/>
              </div>
            ))}
          </div>
          {/* connector into the sequential chain */}
          <div style={{display:'flex',flexDirection:'column',alignItems:'center',padding:'10px 0 4px'}}>
            <div style={{width:2,height:16,background:line}}/>
            <div style={{fontFamily:mono,fontSize:9,letterSpacing:'0.04em',
              padding:'4px 10px',borderRadius:12,border:`1px solid ${line}`,background:bg1,
              color: readyForApply ? grn : t3}}>
              {readyForApply ? '✓ готово — можно подавать' : 'когда: язык сдан + документы собраны'}
            </div>
            <div style={{width:2,height:16,background:line}}/>
            <span style={{fontFamily:mono,fontSize:11,color:t3}}>▼</span>
          </div>
        </div>

        {/* ── SEQUENTIAL CHAIN — apply → wait → final, реальные стрелки,
            каждое звено буквально "после предыдущего". */}
        <div>
          {chainPhases.map((ph,i) => {
            const isOpen = openPhases.has(ph.id)
            const isLast = i === chainPhases.length - 1
            return (
              <div key={ph.id} style={{display:'flex',gap:14}}>
                <div style={{display:'flex',flexDirection:'column',alignItems:'center',flexShrink:0,width:28}}>
                  <div style={{width:26,height:26,borderRadius:'50%',flexShrink:0,
                    display:'flex',alignItems:'center',justifyContent:'center',
                    background:pct(ph)===100?grn:ph.color,color:bg0,fontFamily:mono,fontWeight:700,fontSize:11}}>
                    {pct(ph)===100?'✓':i+1}
                  </div>
                  {!isLast&&<div style={{width:2,flex:1,minHeight:16,background:line,marginTop:4}}/>}
                </div>
                <div style={{flex:1,minWidth:0,paddingBottom:isLast?0:14}}>
                  <PhaseCard phase={ph} isOpen={isOpen} pct={pct(ph)}
                    onToggleOpen={()=>togglePhase(ph.id)}
                    expandedTasks={expandedTasks} onToggleTaskExpand={toggleTaskExpand}
                    taskDone={taskDone} onToggleTaskDone={onToggle}
                    onOpenReality={onOpenReality} showProLine={true}/>
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
