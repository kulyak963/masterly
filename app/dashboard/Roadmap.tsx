'use client'
import { useState, useEffect } from 'react'
import { bg0, bg1, bg2, line, t1, t2, t3, gold, red, grn, sans, serif, mono } from '@/lib/theme'
import { buildJourney, PARALLEL_PHASE_IDS, SEQUENTIAL_CHAIN_IDS, type JourneyPhase, type JourneyTask } from '@/lib/journey'
import LockIcon from '@/components/LockIcon'

// Третий заход 2026-09-15. Денис выбрал 2 из 3 показанных эскизов
// ("доска блоков" и "путь со станциями") и попросил сделать ОБА с
// маленьким переключателем, задачи мельче/атомарнее (декомпозировано —
// см. lib/journey.ts), и убрать подписанные поля "что/как/когда/зачем" —
// теперь у задачи просто короткое предложение (task.detail) и компактная
// метка срока/цены (task.meta) без лейблов.

function Bar({v=0,color=t1,h=2}:{v:number,color?:string,h?:number}) {
  return (
    <div style={{height:h,background:'rgba(255,255,255,.07)',borderRadius:1,overflow:'hidden'}}>
      <div style={{height:'100%',width:`${v}%`,background:color,borderRadius:1,
        animation:'barGrow .7s ease both',transformOrigin:'left'}}/>
    </div>
  )
}

function Check({done, urgent, onClick}:{done:boolean, urgent?:boolean, onClick:()=>void}) {
  return (
    <div onClick={onClick} style={{width:14,height:14,borderRadius:'50%',flexShrink:0,marginTop:1,cursor:'pointer',
      border:`1.5px solid ${done?grn:urgent?red:t3}`,background:done?grn:'transparent',
      display:'flex',alignItems:'center',justifyContent:'center',transition:'all .18s',
      boxShadow:done?`0 0 6px ${grn}35`:'none'}}>
      {done&&<span style={{color:bg0,fontSize:7,fontWeight:700}}>✓</span>}
    </div>
  )
}

// ============================================================
// ВИД "БЛОКИ" — сетка мелких карточек внутри каждой фазы.
// ============================================================
function Tile({task, done, onToggle}:{task:JourneyTask, done:boolean, onToggle:()=>void}) {
  if (task.locked) return (
    <div style={{width:190,background:`${gold}0D`,border:'1px dashed rgba(242,169,59,.4)',borderRadius:9,padding:'10px 12px',
      display:'flex',gap:7,alignItems:'flex-start'}}>
      <LockIcon size={11} color={gold} />
      <span style={{fontFamily:sans,fontSize:11,color:gold,lineHeight:1.4}}>{task.title}</span>
    </div>
  )
  return (
    <div style={{width:190,background:bg1,border:`1px solid ${done?`${grn}30`:task.urgent?`${red}35`:line}`,
      borderRadius:9,padding:'10px 12px',transition:'border-color .15s'}}>
      <div style={{display:'flex',gap:7,alignItems:'flex-start'}}>
        <Check done={done} urgent={task.urgent} onClick={onToggle}/>
        <span style={{fontFamily:sans,fontSize:11.5,fontWeight:600,lineHeight:1.35,
          color:done?t2:t1,textDecoration:done?'line-through':'none'}}>{task.title}</span>
      </div>
      {task.urgent&&!done&&<span style={{fontFamily:mono,fontSize:7.5,color:red,letterSpacing:'.08em',marginLeft:21,display:'block',marginTop:2}}>СРОЧНО</span>}
      {task.meta&&<div style={{fontFamily:mono,fontSize:8.5,color:t3,marginTop:6,marginLeft:21,letterSpacing:'.02em'}}>{task.meta}</div>}
      {task.detail&&<div style={{fontFamily:sans,fontSize:10.5,color:t2,fontWeight:300,lineHeight:1.5,marginTop:5,marginLeft:21}}>{task.detail}</div>}
    </div>
  )
}

function BlocksPhase({phase, isOpen, pct, onToggleOpen, taskDone, onToggleTask, onOpenReality}:
  {phase:JourneyPhase, isOpen:boolean, pct:number, onToggleOpen:()=>void,
   taskDone:Record<string,boolean>, onToggleTask:(k:string)=>void, onOpenReality?:()=>void}) {
  const isBlocker = phase.status==='blocker'
  return (
    <div style={{marginBottom:14}}>
      <div onClick={onToggleOpen} style={{cursor:'pointer',display:'flex',alignItems:'baseline',gap:9,marginBottom:isOpen?10:0}}>
        <div style={{width:8,height:8,borderRadius:'50%',flexShrink:0,background:pct===100?grn:phase.color,
          boxShadow:isBlocker?`0 0 0 4px ${red}25`:'none',animation:isBlocker?'pulse 1.5s infinite':'none'}}/>
        <span style={{fontFamily:sans,fontSize:14,fontWeight:700,color:t1}}>{phase.title}</span>
        {phase.proBadge&&<span style={{fontFamily:mono,fontSize:7.5,fontWeight:700,letterSpacing:'.06em',padding:'2px 5px',borderRadius:3,background:`${gold}18`,border:`1px solid ${gold}40`,color:gold}}>PRO</span>}
        {isBlocker&&<span style={{fontFamily:mono,fontSize:7.5,fontWeight:700,letterSpacing:'.08em',color:red,animation:'pulse 2s infinite'}}>СРОЧНО</span>}
        <span style={{fontFamily:mono,fontSize:9,color:t3}}>{phase.tasks.length} {phase.tasks.length===1?'задача':'задачи'}</span>
        <span style={{flex:1}}/>
        {pct>0&&<span style={{fontFamily:mono,fontSize:9,color:pct===100?grn:phase.color}}>{pct}%</span>}
        <span style={{fontFamily:mono,fontSize:11,color:t3,transform:isOpen?'rotate(90deg)':'none',transition:'transform .15s',display:'inline-block'}}>›</span>
      </div>
      {isOpen&&(
        <>
          <div style={{display:'flex',flexWrap:'wrap',gap:8}}>
            {phase.tasks.map(task=>(
              <Tile key={task.key} task={task} done={!!task.done||!!taskDone[task.key]} onToggle={()=>onToggleTask(task.key)}/>
            ))}
          </div>
          {phase.proNote&&(
            <div onClick={onOpenReality} style={{display:'flex',alignItems:'center',gap:8,marginTop:10,padding:'9px 12px',
              borderRadius:8,background:`${gold}0D`,border:`1px solid ${gold}30`,cursor:onOpenReality?'pointer':'default',maxWidth:400}}>
              <span style={{fontFamily:sans,fontSize:11,color:gold,lineHeight:1.5,flex:1}}>{phase.proNote}</span>
              {onOpenReality&&<span style={{fontFamily:mono,fontSize:11,color:gold}}>→</span>}
            </div>
          )}
        </>
      )}
    </div>
  )
}

function BlocksView({parallelPhases, chainPhases, open, togglePhase, pct, taskDone, onToggle, onOpenReality, readyForApply}:
  {parallelPhases:JourneyPhase[], chainPhases:JourneyPhase[], open:Set<string>, togglePhase:(id:string)=>void,
   pct:(ph:JourneyPhase)=>number, taskDone:Record<string,boolean>, onToggle:(k:string)=>void, onOpenReality?:()=>void, readyForApply?:boolean}) {
  return (
    <>
      <div style={{position:'relative',paddingLeft:16,marginBottom:4}}>
        <div style={{position:'absolute',left:0,top:4,bottom:22,width:2,background:`linear-gradient(180deg,${gold}60,${gold}20)`,borderRadius:1}}/>
        <div style={{fontFamily:mono,fontSize:9,color:gold,letterSpacing:'.1em',marginBottom:12}}>⇉ ЭТИ {parallelPhases.length} БЛОКА — ОДНОВРЕМЕННО, ПОРЯДОК НЕ ВАЖЕН</div>
        {parallelPhases.map(ph=>(
          <BlocksPhase key={ph.id} phase={ph} isOpen={open.has(ph.id)} pct={pct(ph)}
            onToggleOpen={()=>togglePhase(ph.id)} taskDone={taskDone} onToggleTask={onToggle} onOpenReality={onOpenReality}/>
        ))}
        <div style={{display:'flex',flexDirection:'column',alignItems:'center',padding:'6px 0 4px'}}>
          <div style={{width:2,height:14,background:line}}/>
          <div style={{fontFamily:mono,fontSize:9,padding:'4px 10px',borderRadius:12,border:`1px solid ${line}`,background:bg1,
            color:readyForApply?grn:t3}}>{readyForApply?'✓ готово — можно подавать':'когда: язык сдан + документы собраны'}</div>
          <div style={{width:2,height:14,background:line}}/>
          <span style={{fontFamily:mono,fontSize:10,color:t3}}>▼</span>
        </div>
      </div>
      <div>
        {chainPhases.map((ph,i)=>{
          const isLast = i===chainPhases.length-1
          return (
            <div key={ph.id} style={{display:'flex',gap:12}}>
              <div style={{display:'flex',flexDirection:'column',alignItems:'center',flexShrink:0,width:24}}>
                <div style={{width:22,height:22,borderRadius:'50%',flexShrink:0,display:'flex',alignItems:'center',justifyContent:'center',
                  background:pct(ph)===100?grn:ph.color,color:bg0,fontFamily:mono,fontWeight:700,fontSize:10}}>{pct(ph)===100?'✓':i+1}</div>
                {!isLast&&<div style={{width:2,flex:1,minHeight:14,background:line,marginTop:3}}/>}
              </div>
              <div style={{flex:1,minWidth:0,paddingBottom:isLast?0:12}}>
                <BlocksPhase phase={ph} isOpen={open.has(ph.id)} pct={pct(ph)}
                  onToggleOpen={()=>togglePhase(ph.id)} taskDone={taskDone} onToggleTask={onToggle} onOpenReality={onOpenReality}/>
              </div>
            </div>
          )
        })}
      </div>
    </>
  )
}

// ============================================================
// ВИД "ПУТЬ" — карта со станциями, задачи — остановки на платформе.
// ============================================================
function Stop({task, done, onToggle}:{task:JourneyTask, done:boolean, onToggle:()=>void}) {
  if (task.locked) return (
    <div style={{border:'1px dashed rgba(242,169,59,.4)',borderRadius:20,padding:'6px 10px',
      display:'flex',alignItems:'center',gap:6,fontFamily:sans,fontSize:10.5,color:gold}}>
      <LockIcon size={9} color={gold}/>{task.title}
    </div>
  )
  return (
    <div onClick={onToggle} style={{background:bg1,border:`1px solid ${line}`,borderRadius:10,padding:'7px 10px',cursor:'pointer'}}>
      <div style={{display:'flex',alignItems:'flex-start',gap:7}}>
        <Check done={done} urgent={task.urgent} onClick={onToggle}/>
        <span style={{fontFamily:sans,fontSize:10.5,fontWeight:600,color:done?t2:t1,textDecoration:done?'line-through':'none',lineHeight:1.3,flex:1}}>{task.title}</span>
      </div>
      {task.meta&&<div style={{fontFamily:mono,fontSize:8,color:t3,marginTop:3,marginLeft:19}}>{task.meta}</div>}
      {task.detail&&<div style={{fontFamily:sans,fontSize:9.5,color:t2,fontWeight:300,lineHeight:1.45,marginTop:3,marginLeft:19}}>{task.detail}</div>}
    </div>
  )
}

const PHASE_ICON: Record<string,string> = { research:'🎯', ielts:'🗣️', profile:'👤', docs:'📄', schol:'🎓' }

function PathView({parallelPhases, chainPhases, pct, taskDone, onToggle, onOpenReality, readyForApply}:
  {parallelPhases:JourneyPhase[], chainPhases:JourneyPhase[], pct:(ph:JourneyPhase)=>number,
   taskDone:Record<string,boolean>, onToggle:(k:string)=>void, onOpenReality?:()=>void, readyForApply?:boolean}) {
  return (
    <>
      <div style={{fontFamily:mono,fontSize:9,color:gold,letterSpacing:'.1em',textAlign:'center',marginBottom:14}}>ПЕРЕСАДОЧНАЯ ПЛОЩАДЬ — ВСЁ ОДНОВРЕМЕННО</div>
      <div className="journey-cluster-grid" style={{['--n' as any]:parallelPhases.length,display:'grid',gap:14,
        padding:16,border:`1px dashed ${line}`,borderRadius:16,background:'rgba(255,255,255,.015)',marginBottom:8}}>
        {parallelPhases.map(ph=>(
          <div key={ph.id} style={{display:'flex',flexDirection:'column',alignItems:'center',gap:8}}>
            <div style={{width:42,height:42,borderRadius:'50%',display:'flex',alignItems:'center',justifyContent:'center',
              fontSize:17,background:bg1,boxShadow:`0 0 0 2px ${pct(ph)===100?grn:ph.color}`}}>{PHASE_ICON[ph.id]}</div>
            <div style={{fontSize:11.5,fontWeight:700,textAlign:'center',lineHeight:1.3}}>
              {ph.title}
              {ph.proBadge&&<span style={{fontFamily:mono,fontSize:7,border:'1px solid rgba(242,169,59,.4)',color:gold,padding:'1px 4px',borderRadius:3,marginLeft:5,whiteSpace:'nowrap'}}>PRO</span>}
            </div>
            <div style={{display:'flex',flexDirection:'column',gap:5,width:'100%'}}>
              {ph.tasks.map(task=>(
                <Stop key={task.key} task={task} done={!!task.done||!!taskDone[task.key]} onToggle={()=>onToggle(task.key)}/>
              ))}
            </div>
          </div>
        ))}
      </div>
      {parallelPhases.some(ph=>ph.proNote)&&(
        <div onClick={onOpenReality} style={{display:'flex',alignItems:'center',gap:8,margin:'0 auto 8px',padding:'9px 12px',
          borderRadius:8,background:`${gold}0D`,border:`1px solid ${gold}30`,cursor:onOpenReality?'pointer':'default',maxWidth:420}}>
          <span style={{fontFamily:sans,fontSize:11,color:gold,lineHeight:1.5,flex:1}}>{parallelPhases.find(ph=>ph.proNote)?.proNote}</span>
          {onOpenReality&&<span style={{fontFamily:mono,fontSize:11,color:gold}}>→</span>}
        </div>
      )}

      <div style={{display:'flex',justifyContent:'center',padding:'10px 0 4px'}}>
        <svg width="100" height="40" viewBox="0 0 100 40">
          <path d="M15,0 C15,18 50,14 50,26" stroke={line} fill="none" strokeWidth="2"/>
          <path d="M85,0 C85,18 50,14 50,26" stroke={line} fill="none" strokeWidth="2"/>
          <path d="M50,0 L50,26" stroke={line} fill="none" strokeWidth="2"/>
          <circle cx="50" cy="29" r="4" fill={readyForApply?grn:gold}/>
          <path d="M50,33 L50,40" stroke={readyForApply?grn:gold} strokeWidth="2"/>
        </svg>
      </div>
      <div style={{textAlign:'center',fontFamily:mono,fontSize:9,color:readyForApply?grn:t3,marginBottom:18}}>
        {readyForApply?'✓ готово — можно подавать':'когда: язык сдан + документы собраны'}
      </div>

      <div style={{display:'flex',flexDirection:'column',alignItems:'center'}}>
        {chainPhases.map((ph,i)=>{
          const isLast = i===chainPhases.length-1
          const open = true // цепочка всегда развёрнута — там всего 3 фазы
          return (
            <div key={ph.id} style={{width:'100%',maxWidth:460}}>
              <div style={{display:'flex',alignItems:'flex-start',gap:14}}>
                <div style={{width:38,height:38,borderRadius:'50%',flexShrink:0,display:'flex',alignItems:'center',justifyContent:'center',
                  background:bg1,color:pct(ph)===100?grn:ph.color,fontFamily:mono,fontWeight:700,fontSize:13,
                  boxShadow:`0 0 0 2px ${pct(ph)===100?grn:ph.color}`}}>{pct(ph)===100?'✓':i+1}</div>
                <div style={{flex:1,paddingTop:2}}>
                  <div style={{fontSize:13.5,fontWeight:700,marginBottom:6}}>{ph.title}</div>
                  <div style={{display:'flex',flexDirection:'column',gap:5}}>
                    {ph.tasks.map(task=>(
                      <Stop key={task.key} task={task} done={!!task.done||!!taskDone[task.key]} onToggle={()=>onToggle(task.key)}/>
                    ))}
                  </div>
                </div>
              </div>
              {!isLast&&<div style={{width:2,height:18,background:line,marginLeft:19,marginTop:4}}/>}
            </div>
          )
        })}
      </div>
    </>
  )
}

export default function Roadmap({profile, programs = [], taskDone = {}, onToggle, onOpenReality}:
  {profile:any, programs?:any[], taskDone?:Record<string,boolean>, onToggle:(k:string)=>void, onOpenReality?:()=>void}) {

  useEffect(()=>{
    const s = document.createElement('style')
    s.textContent = `
      @keyframes barGrow{from{transform:scaleX(0)}to{transform:scaleX(1)}}
      @keyframes pulse{0%,100%{opacity:1}50%{opacity:.3}}
      .journey-cluster-grid{grid-template-columns:repeat(var(--n),1fr)}
      @media (max-width:860px){
        .journey-cluster-grid{grid-template-columns:repeat(auto-fit,minmax(150px,1fr))}
      }
    `
    document.head.appendChild(s)
    return()=>s.remove()
  },[])

  const [view, setView] = useState<'blocks'|'path'>('blocks')
  useEffect(()=>{
    try { const saved = localStorage.getItem('masterly_journey_view'); if (saved==='blocks'||saved==='path') setView(saved) } catch {}
  },[])
  const setViewPersist = (v:'blocks'|'path') => { setView(v); try { localStorage.setItem('masterly_journey_view', v) } catch {} }

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
  const [open, setOpen] = useState<Set<string>>(new Set(defaultOpenId ? [defaultOpenId] : []))
  const togglePhase = (id:string) => setOpen(prev => { const n = new Set(prev); n.has(id)?n.delete(id):n.add(id); return n })

  const readyForApply = chainPhases[0].blockedBy?.every(id => byId(id).tasks.every(t=>t.done||!!taskDone[t.key]))

  return (
    <div style={{height:'100%',overflowY:'auto'}}>
      <div style={{maxWidth:1200,margin:'0 auto',padding:'28px 24px 60px'}}>

        <div style={{display:'flex',alignItems:'flex-start',justifyContent:'space-between',gap:12,marginBottom:20,flexWrap:'wrap'}}>
          <div>
            <div style={{fontFamily:mono,fontSize:10,letterSpacing:'0.11em',color:t3,marginBottom:10}}>ПЕРСОНАЛЬНЫЙ ПЛАН</div>
            <h1 style={{fontFamily:serif,fontStyle:'normal',fontSize:24,color:t1,fontWeight:800,letterSpacing:'-.02em',marginBottom:6,textWrap:'balance' as any}}>
              {profile.name?.split(' ')[0]}, вот весь путь от идеи до переезда
            </h1>
          </div>
          <div style={{display:'flex',gap:2,background:bg1,border:`1px solid ${line}`,borderRadius:8,padding:2,flexShrink:0}}>
            {(['blocks','path'] as const).map(v=>(
              <button key={v} onClick={()=>setViewPersist(v)} style={{fontFamily:mono,fontSize:9,letterSpacing:'.05em',
                padding:'6px 10px',borderRadius:6,border:'none',cursor:'pointer',
                background:view===v?bg2:'transparent',color:view===v?t1:t3}}>
                {v==='blocks'?'▦ БЛОКИ':'⟿ ПУТЬ'}
              </button>
            ))}
          </div>
        </div>

        <div style={{display:'flex',alignItems:'center',gap:10,marginBottom:24}}>
          <span style={{fontFamily:mono,fontSize:9,color:t3,letterSpacing:'0.08em'}}>ЗАДАЧ ВЫПОЛНЕНО {doneT}/{totalT}</span>
          <div style={{flex:1}}><Bar v={Math.round(doneT/totalT*100)||0} color={t1} h={2}/></div>
        </div>

        {view==='blocks' ? (
          <BlocksView parallelPhases={parallelPhases} chainPhases={chainPhases} open={open} togglePhase={togglePhase}
            pct={pct} taskDone={taskDone} onToggle={onToggle} onOpenReality={onOpenReality} readyForApply={readyForApply}/>
        ) : (
          <PathView parallelPhases={parallelPhases} chainPhases={chainPhases} pct={pct}
            taskDone={taskDone} onToggle={onToggle} onOpenReality={onOpenReality} readyForApply={readyForApply}/>
        )}
      </div>
    </div>
  )
}
