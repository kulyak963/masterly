

import Anthropic from '@anthropic-ai/sdk'
import { NextRequest, NextResponse } from 'next/server'

const client = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
  baseURL: 'https://api.vibecode-claude.online/v1'
})


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
console.log("API KEY:", process.env.ANTHROPIC_API_KEY)
ПРОГРАММА: ${program.name} в ${program.university_name}
Стоимость: ${program.tuition_eur === 0 ? 'бесплатно' : `€${program.tuition_eur}/год`}
IELTS минимум: ${program.ielts_min}
Рейтинг: ${program.ranking_qs ? `#${program.ranking_qs} QS` : 'не в рейтинге'}
Плюсы программы: ${program.pros?.join(', ')}
Минусы программы: ${program.cons?.join(', ')}
Описание: ${program.summary}

Напиши персональный анализ для этого студента. Только JSON, без markdown:
{
  "fit": ["причина 1 почему подходит именно этому студенту", "причина 2", "причина 3"],
  "warnings": ["предупреждение 1", "предупреждение 2"],
  "verdict": "одно предложение — стоит ли подавать и почему"
}`

  const msg = await client.messages.create({
    model: 'claude-opus-4.7',
    max_tokens: 500,
    messages: [{ role: 'user', content: prompt }]
  })


  const text = (msg.content[0] as any).text.trim()

const start = text.indexOf('{')
const end = text.lastIndexOf('}')

if (start === -1 || end === -1) {
  throw new Error('Invalid JSON response')
}

const cleanJson = text.slice(start, end + 1)
const json = JSON.parse(cleanJson)

return NextResponse.json(json)
}
