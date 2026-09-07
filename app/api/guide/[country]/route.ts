import { NextRequest, NextResponse } from 'next/server'
import { getSupabaseAdmin } from '../../../../lib/supabaseAdmin'
import { HUNGARY_GUIDE_GATED } from '../../../../lib/guides/hungary'
import { ITALY_GUIDE_GATED } from '../../../../lib/guides/italy'
import { GERMANY_REALITY_GATED } from '../../../../lib/guides/germany'
import { NETHERLANDS_REALITY_GATED } from '../../../../lib/guides/netherlands'

// Раньше платный контент гайдов (Венгрия/Италия) жил прямо в клиентских
// компонентах (app/dashboard/HungaryGuide.tsx, ItalyGuide.tsx) как обычные
// экспортированные константы, а ScholarshipLock.tsx только визуально
// блюрил уже отрисованный DOM — весь текст оставался в HTML/JS-бандле и
// читался любым НЕ-Pro пользователем простым копированием текста страницы,
// без единой попытки обойти защиту. Теперь сами данные (lib/guides/*.ts)
// импортируются ТОЛЬКО этим серверным route — и уходят клиенту, только
// если сервер сам проверил profiles.is_pro по токену пользователя.
const GUIDES: Record<string, unknown> = {
  hu: HUNGARY_GUIDE_GATED,
  it: ITALY_GUIDE_GATED,
  de: GERMANY_REALITY_GATED,
  nl: NETHERLANDS_REALITY_GATED,
}

export async function GET(req: NextRequest, { params }: { params: Promise<{ country: string }> }) {
  const { country } = await params
  const guide = GUIDES[country]
  if (!guide) return NextResponse.json({ error: 'unknown guide' }, { status: 404 })

  const authHeader = req.headers.get('authorization') ?? ''
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null
  if (!token) return NextResponse.json({ locked: true })

  const db = getSupabaseAdmin()
  const { data: userRes } = await db.auth.getUser(token)
  if (!userRes?.user) return NextResponse.json({ locked: true })

  const { data: profile } = await db
    .from('profiles')
    .select('is_pro')
    .eq('user_id', userRes.user.id)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  if (!profile?.is_pro) return NextResponse.json({ locked: true })

  return NextResponse.json({ locked: false, content: guide })
}
