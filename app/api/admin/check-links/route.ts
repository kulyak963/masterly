import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../../lib/supabaseAdmin'

// Фаза 4, задача 4.2 (план после аудита продукта 2026-09-07) —
// регулярная автопроверка ссылок программ, безопасный замен того же
// cron-слота, что раньше занимал /api/admin/seed-programs (удалён —
// он звал модель "вспомнить" данные без проверки и еженедельно тихо
// подмешивал мусор в базу, см. коммит "Phase 0: stop the false
// 'Бесплатно' bug"). Этот эндпоинт НИЧЕГО не выдумывает и не пишет в
// programs/universities — только настоящий HTTP-запрос на уже
// существующий url и запись url_status/url_checked_at. Никакого вызова
// ИИ — нулевая стоимость токенов, только сетевой трафик.
//
// Обходит каталог порциями (самые давно проверенные — первыми), а не
// весь список за один вызов — у serverless-функции есть лимит времени
// выполнения, а с 1400+ программами полный прогон занимает несколько
// минут (см. scripts/check-links.mjs, который умеет проверить всё сразу,
// но запускается вручную).
export const maxDuration = 55
const TIME_BUDGET_MS = 45_000
const BATCH_SIZE = 250
const CONCURRENCY = 15
const TIMEOUT_MS = 8000
const UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36'

async function checkUrl(url: string): Promise<number> {
  const ctrl = new AbortController()
  const t = setTimeout(() => ctrl.abort(), TIMEOUT_MS)
  try {
    const res = await fetch(url, { method: 'GET', redirect: 'follow', signal: ctrl.signal, headers: { 'User-Agent': UA } })
    return res.status
  } catch (e: any) {
    return e?.name === 'AbortError' ? -1 : -2
  } finally {
    clearTimeout(t)
  }
}

async function mapLimit<T, R>(items: T[], limit: number, fn: (item: T) => Promise<R>): Promise<R[]> {
  const results: R[] = new Array(items.length)
  let i = 0
  async function worker() {
    while (i < items.length) {
      const idx = i++
      results[idx] = await fn(items[idx])
    }
  }
  await Promise.all(Array.from({ length: limit }, worker))
  return results
}

export async function GET(req: NextRequest) {
  const authHeader = req.headers.get('authorization')
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'unauthorized' }, { status: 401 })
  }

  const start = Date.now()
  const db = getSupabaseAdmin()

  // Самые давно проверенные (или никогда не проверенные — null сортируется
  // первым в ascending) — первыми в очереди.
  const { data: rows, error } = await db
    .from('programs')
    .select('id,url,url_checked_at')
    .not('url', 'is', null)
    .order('url_checked_at', { ascending: true, nullsFirst: true })
    .limit(BATCH_SIZE)

  if (error) {
    console.error('check-links cron: не удалось прочитать programs:', error.message)
    return NextResponse.json({ error: error.message }, { status: 500 })
  }
  if (!rows?.length) return NextResponse.json({ checked: 0, note: 'нет программ с url' })

  let checked = 0
  const now = new Date().toISOString()
  await mapLimit(rows, CONCURRENCY, async (p) => {
    if (Date.now() - start > TIME_BUDGET_MS) return // не начинаем новые, если время почти вышло
    const status = await checkUrl(p.url)
    const { error: updErr } = await db.from('programs').update({ url_status: status, url_checked_at: now }).eq('id', p.id)
    if (!updErr) checked++
  })

  return NextResponse.json({ checked, ofBatch: rows.length, tookMs: Date.now() - start })
}
