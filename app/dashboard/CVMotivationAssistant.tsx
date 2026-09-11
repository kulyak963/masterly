'use client'
import { useState, useRef, useEffect } from 'react'
import { supabase } from '../../lib/supabase'
import { bg0, bg1, bg2, line, t1, t2, t3, gold, red, sans, mono } from '@/lib/theme'

type Mode = 'cv' | 'motivation'
type Msg = { role: 'user' | 'assistant'; content: string }

const MODE_LABEL: Record<Mode, string> = { cv: 'CV', motivation: 'Мотивационное письмо' }

function opener(mode: Mode, programName: string | null): string {
  const doc = mode === 'cv' ? 'CV' : 'мотивационное письмо'
  const forProgram = programName ? ` под программу «${programName}»` : ''
  return `Привет! Помогу написать ${doc}${forProgram}.\n\nЧтобы текст был убедительным, а не общими словами — расскажи о себе: учёба, работа/стажировки, проекты, достижения (с конкретикой — цифры, названия, роль). Я не буду придумывать факты за тебя — если чего-то не хватит для абзаца, я прямо спрошу.\n\nЕсть готовый черновик, который нужно доработать? Пришли его. Начинаем с нуля? Просто расскажи о себе, и я задам вопросы.`
}

function CopyButton({ text }: { text: string }) {
  const [copied, setCopied] = useState(false)
  return (
    <button
      onClick={() => { navigator.clipboard.writeText(text); setCopied(true); setTimeout(() => setCopied(false), 1500) }}
      style={{
        fontFamily: mono, fontSize: 10, letterSpacing: '0.05em', color: copied ? gold : t3,
        background: 'transparent', border: `1px solid ${copied ? gold : line}`, borderRadius: 5,
        padding: '3px 8px', cursor: 'pointer', marginTop: 8,
      }}
    >
      {copied ? '✓ СКОПИРОВАНО' : 'СКОПИРОВАТЬ'}
    </button>
  )
}

export default function CVMotivationAssistant({ profile, programs }: { profile: any; programs: any[] }) {
  const [mode, setMode] = useState<Mode>('cv')
  const [programId, setProgramId] = useState<string>('')
  const [messages, setMessages] = useState<Msg[]>([])
  const [input, setInput] = useState('')
  const [sending, setSending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const scrollRef = useRef<HTMLDivElement>(null)

  const selectedProgram = programs.find((p) => p.id === programId) ?? null

  // Смена режима или программы — разговор специфичен под них, начинаем
  // заново, а не пытаемся склеить старый контекст с новым.
  useEffect(() => {
    setMessages([])
    setInput('')
    setError(null)
  }, [mode, programId])

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: 'smooth' })
  }, [messages, sending])

  const send = async () => {
    const text = input.trim()
    if (!text || sending) return
    const nextMessages: Msg[] = [...messages, { role: 'user', content: text }]
    setMessages(nextMessages)
    setInput('')
    setSending(true)
    setError(null)
    try {
      const { data: { session } } = await supabase.auth.getSession()
      const res = await fetch('/api/writing-assistant', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', ...(session ? { Authorization: `Bearer ${session.access_token}` } : {}) },
        body: JSON.stringify({
          mode,
          profile: { gpa: profile.gpa, ielts: profile.ielts, master_direction: profile.master_direction, work: profile.work },
          program: selectedProgram ? {
            name: selectedProgram.name, university_name: selectedProgram.university?.name,
            field: selectedProgram.field, ielts_min: selectedProgram.ielts_min, requires_work_years: selectedProgram.requires_work_years,
          } : null,
          messages: nextMessages,
        }),
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.error ?? 'Не удалось получить ответ')
      setMessages((m) => [...m, { role: 'assistant', content: data.reply }])
    } catch (e: any) {
      setError(e.message ?? 'Что-то пошло не так')
    } finally {
      setSending(false)
    }
  }

  const displayMessages: Msg[] = messages.length === 0 ? [{ role: 'assistant', content: opener(mode, selectedProgram?.name ?? null) }] : messages

  return (
    <div style={{ padding: '36px 40px', display: 'flex', flexDirection: 'column', height: '100%', maxWidth: 760 }}>
      <div style={{ marginBottom: 20 }}>
        <div style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.12em', color: gold, marginBottom: 8 }}>CV И МОТИВАЦИОННОЕ · PRO</div>
        <div style={{ display: 'flex', gap: 8, marginBottom: 14 }}>
          {(['cv', 'motivation'] as Mode[]).map((m) => (
            <button key={m} onClick={() => setMode(m)} style={{
              padding: '7px 14px', borderRadius: 7, cursor: 'pointer',
              border: `1px solid ${mode === m ? t1 : line}`,
              background: mode === m ? t1 : 'transparent',
              color: mode === m ? bg0 : t2,
              fontFamily: sans, fontSize: 12.5, fontWeight: 500,
            }}>{MODE_LABEL[m]}</button>
          ))}
        </div>
        <select value={programId} onChange={(e) => setProgramId(e.target.value)} style={{
          width: '100%', padding: '9px 12px', borderRadius: 7, border: `1px solid ${line}`,
          background: bg1, color: t1, fontFamily: sans, fontSize: 12.5, cursor: 'pointer',
        }}>
          <option value="">Без привязки к конкретной программе — общий вариант</option>
          {programs.map((p) => (
            <option key={p.id} value={p.id}>{p.name} — {p.university?.name}</option>
          ))}
        </select>
      </div>

      <div ref={scrollRef} style={{ flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: 14, paddingRight: 4, marginBottom: 14 }}>
        {displayMessages.map((m, i) => (
          <div key={i} style={{
            alignSelf: m.role === 'user' ? 'flex-end' : 'stretch',
            maxWidth: m.role === 'user' ? '80%' : '100%',
            background: m.role === 'user' ? gold : bg1,
            border: m.role === 'assistant' ? `1px solid ${line}` : 'none',
            borderRadius: 10, padding: '12px 15px',
          }}>
            <div style={{
              fontFamily: sans, fontSize: 13.5, lineHeight: 1.65, whiteSpace: 'pre-wrap',
              color: m.role === 'user' ? bg0 : t1,
            }}>{m.content}</div>
            {m.role === 'assistant' && <CopyButton text={m.content} />}
          </div>
        ))}
        {sending && (
          <div style={{ alignSelf: 'flex-start', color: t3, fontFamily: mono, fontSize: 11, letterSpacing: '0.05em' }}>печатает…</div>
        )}
      </div>

      {error && (
        <div style={{ marginBottom: 10, padding: '8px 12px', borderRadius: 6, background: `${red}12`, border: `1px solid ${red}40`, color: red, fontFamily: sans, fontSize: 12 }}>{error}</div>
      )}

      <div style={{ display: 'flex', gap: 10, alignItems: 'flex-end' }}>
        <textarea
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send() } }}
          placeholder="Расскажи о себе или вставь черновик…"
          rows={2}
          style={{
            flex: 1, resize: 'none', padding: '11px 14px', borderRadius: 8, border: `1px solid ${line}`,
            background: bg2, color: t1, fontFamily: sans, fontSize: 13, lineHeight: 1.5, outline: 'none',
          }}
        />
        <button onClick={send} disabled={sending || !input.trim()} style={{
          padding: '11px 18px', borderRadius: 8, border: 'none', height: 42,
          background: gold, color: bg0, fontFamily: sans, fontSize: 13, fontWeight: 600,
          cursor: sending || !input.trim() ? 'not-allowed' : 'pointer', opacity: sending || !input.trim() ? 0.5 : 1,
        }}>Отправить</button>
      </div>
    </div>
  )
}
