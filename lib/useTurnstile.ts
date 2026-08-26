'use client'
import { useEffect, useRef, useState } from 'react'

declare global {
  interface Window { turnstile?: any }
}

const SITE_KEY = process.env.NEXT_PUBLIC_TURNSTILE_SITE_KEY

// Капча Cloudflare Turnstile. Если NEXT_PUBLIC_TURNSTILE_SITE_KEY не задан —
// виджет просто не рендерится и token остаётся null (auth-запросы уходят без
// captchaToken, что нормально пока капча не включена на стороне Supabase).
export function useTurnstile() {
  const containerRef = useRef<HTMLDivElement>(null)
  const widgetId = useRef<string | null>(null)
  const [token, setToken] = useState<string | null>(null)

  useEffect(() => {
    if (!SITE_KEY) return
    let cancelled = false

    const render = () => {
      if (cancelled || !containerRef.current || !window.turnstile || widgetId.current) return
      widgetId.current = window.turnstile.render(containerRef.current, {
        sitekey: SITE_KEY,
        theme: 'dark',
        callback: (t: string) => setToken(t),
        'expired-callback': () => setToken(null),
        'error-callback': () => setToken(null),
      })
    }

    if (window.turnstile) {
      render()
    } else {
      const existing = document.querySelector('script[data-turnstile]')
      if (!existing) {
        const script = document.createElement('script')
        script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js'
        script.async = true
        script.defer = true
        script.setAttribute('data-turnstile', '1')
        script.onload = render
        document.head.appendChild(script)
      } else {
        existing.addEventListener('load', render)
      }
    }

    return () => {
      cancelled = true
      if (widgetId.current && window.turnstile) {
        try { window.turnstile.remove(widgetId.current) } catch {}
      }
      widgetId.current = null
    }
  }, [])

  const reset = () => {
    setToken(null)
    if (widgetId.current && window.turnstile) {
      try { window.turnstile.reset(widgetId.current) } catch {}
    }
  }

  return { containerRef, token, enabled: !!SITE_KEY, reset }
}
