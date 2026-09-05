import { NextRequest, NextResponse } from 'next/server'
import { askAI, extractJson } from '../../../lib/ai'

export async function POST(req: NextRequest) {
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
Стоимость: ${program.tuition_eur === 0 ? 'бесплатно' : `€${program.tuition_eur}/год`}
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
