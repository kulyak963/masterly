import { NextRequest, NextResponse } from 'next/server'
import { askAI, extractJson } from '../../../lib/ai'
import { getSupabaseAdmin } from '../../../lib/supabaseAdmin'
import { tuitionLabel } from '../../../lib/tuition'

// НЕ трогаем maxDuration — лимит зависит от тарифа Vercel, а его конкретное
// значение отсюда не проверить; завысить его — верный способ уронить сборку
// ("maxDuration cannot exceed N for your plan"). Таймаут на клиенте в
// getVerdict — достаточная защита от зависшего запроса без этого риска.

export async function POST(req: NextRequest) {
  // Раньше эндпоинт был открыт вообще без проверки — не только бесплатным
  // пользователям, а вообще любому, кто найдёт URL, включая неавторизо-
  // ванных: каждый вызов — реальный платный запрос к Anthropic. По модели
  // монетизации (см. память проекта) "ИИ-анализ" — платная фича Pro.
  const authHeader = req.headers.get('authorization') ?? ''
  const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : null
  if (!token) return NextResponse.json({ error: 'Требуется вход' }, { status: 401 })

  const db = getSupabaseAdmin()
  const { data: userRes } = await db.auth.getUser(token)
  if (!userRes?.user) return NextResponse.json({ error: 'Требуется вход' }, { status: 401 })

  const { data: profileRow } = await db
    .from('profiles')
    .select('is_pro')
    .eq('user_id', userRes.user.id)
    .order('created_at', { ascending: false })
    .limit(1)
    .maybeSingle()

  if (!profileRow?.is_pro) {
    return NextResponse.json({ error: 'Персональный анализ — платная функция Pro', locked: true }, { status: 403 })
  }

  const { program, profile } = await req.json()

  const prompt = `Ты помогаешь студенту понять подходит ли ему магистерская программа.

ПРОФИЛЬ СТУДЕНТА:
- GPA: ${profile.gpa} из 5
- IELTS: ${profile.ielts}
- Бюджет: ${profile.budget === 'zero' ? 'только стипендия' : profile.budget === 'low' ? 'до €5000/год' : profile.budget === 'mid' ? 'до €15000/год' : 'без ограничений'}
- Приоритеты: ${profile.quiz_vibe === 'research' ? 'сильная наука' : profile.quiz_vibe === 'startup' ? 'стартап-экосистема' : 'качество жизни'}
- Хочет остаться в Европе: ${profile.quiz_stay === 'yes' ? 'да' : profile.quiz_stay === 'no' ? 'нет' : 'не решил'}
- Главная боль: ${profile.pain}

ПРОГРАММА: ${program.name} в ${program.university_name}
Стоимость: ${tuitionLabel(program).toLowerCase()}
IELTS минимум: ${program.ielts_min}
Рейтинг: ${program.ranking_qs ? `#${program.ranking_qs} QS` : 'не в рейтинге'}
Плюсы программы: ${program.pros?.join(', ')}
Минусы программы: ${program.cons?.join(', ')}
Описание: ${program.summary}

СТАТУС ДАННЫХ: ${program.verified
  ? 'проверено человеком против официального сайта вуза — можно рассуждать уверенно.'
  : 'НЕ проверено человеком — цифры выше сами собраны ИИ и могут быть неточны или устаревшими. Не выдумывай новые факты сверх того, что дано; там, где рассуждение прямо опирается на непроверенную цифру (стоимость/дедлайн/IELTS), явно оговори в verdict или warnings, что это стоит перепроверить на сайте вуза.'}

Напиши персональный анализ для этого студента. Только JSON, без markdown:
{
  "fit": ["причина 1 почему подходит именно этому студенту", "причина 2", "причина 3"],
  "warnings": ["предупреждение 1", "предупреждение 2"],
  "verdict": "одно предложение — стоит ли подавать и почему"
}`

  try {
    const text = await askAI(prompt, { maxTokens: 500 })
    const json = extractJson(text)
    return NextResponse.json(json)
  } catch (e: any) {
    console.error('verdict AI call failed:', e)
    return NextResponse.json(
      { error: e?.message ?? 'AI request failed' },
      { status: 502 }
    )
  }
}
