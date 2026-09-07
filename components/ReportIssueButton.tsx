'use client'
import { useState } from 'react'
import { bg1, line, t1, t2, t3, gold, grn, red, sans } from '@/lib/theme'

/** "Здесь ошибка" — задача 4.3, план после аудита продукта 2026-09-07. */
export default function ReportIssueButton({ programId }: { programId: string }) {
  const [open, setOpen] = useState(false)
  const [message, setMessage] = useState('')
  const [email, setEmail] = useState('')
  const [sending, setSending] = useState(false)
  const [done, setDone] = useState(false)
  const [error, setError] = useState('')

  const submit = async () => {
    setSending(true)
    setError('')
    try {
      const res = await fetch('/api/report-issue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ programId, message, email }),
      })
      const data = await res.json()
      if (!res.ok) { setError(data.error ?? 'Не получилось отправить'); setSending(false); return }
      setDone(true)
    } catch {
      setError('Не получилось отправить — попробуй позже')
    }
    setSending(false)
  }

  if (!open) {
    return (
      <button onClick={() => setOpen(true)} style={{
        display: 'block', width: '100%', textAlign: 'center', padding: '11px', borderRadius: 8,
        border: `1px solid ${line}`, background: 'transparent', fontFamily: sans, fontSize: 12,
        color: t3, cursor: 'pointer',
      }}>
        Нашёл ошибку в этой программе?
      </button>
    )
  }

  if (done) {
    return (
      <div style={{ padding: '12px 14px', borderRadius: 8, background: `${grn}12`, border: `1px solid ${grn}40`, textAlign: 'center' }}>
        <span style={{ fontFamily: sans, fontSize: 12, color: grn }}>Спасибо, разберём вручную.</span>
      </div>
    )
  }

  return (
    <div style={{ padding: '14px', borderRadius: 8, border: `1px solid ${line}`, background: bg1 }}>
      <textarea
        placeholder="Что не так? Например: цена другая, дедлайн изменился, ссылка не открывается"
        value={message} onChange={e => setMessage(e.target.value)}
        style={{ width: '100%', minHeight: 60, padding: '8px 10px', borderRadius: 6, border: `1px solid ${line}`,
          background: 'transparent', color: t1, fontFamily: sans, fontSize: 12, marginBottom: 8, resize: 'vertical' }}
      />
      <input
        type="email" placeholder="Email — если хочешь ответ (необязательно)"
        value={email} onChange={e => setEmail(e.target.value)}
        style={{ width: '100%', padding: '8px 10px', borderRadius: 6, border: `1px solid ${line}`,
          background: 'transparent', color: t1, fontFamily: sans, fontSize: 12, marginBottom: 10 }}
      />
      <div style={{ display: 'flex', gap: 8 }}>
        <button onClick={submit} disabled={sending || message.trim().length < 3} style={{
          flex: 1, padding: '9px', borderRadius: 6, border: 'none',
          background: message.trim().length >= 3 ? gold : 'rgba(255,255,255,.06)',
          color: message.trim().length >= 3 ? bg1 : t3, fontFamily: sans, fontSize: 12, fontWeight: 600,
          cursor: sending ? 'not-allowed' : 'pointer',
        }}>
          {sending ? 'Отправляем…' : 'Отправить'}
        </button>
        <button onClick={() => setOpen(false)} style={{
          padding: '9px 14px', borderRadius: 6, border: `1px solid ${line}`, background: 'transparent',
          color: t2, fontFamily: sans, fontSize: 12, cursor: 'pointer',
        }}>
          Отмена
        </button>
      </div>
      {error && <p style={{ fontFamily: sans, fontSize: 11, color: red, marginTop: 8 }}>{error}</p>}
    </div>
  )
}
