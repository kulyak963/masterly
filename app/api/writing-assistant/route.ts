import { NextRequest, NextResponse } from 'next/server'
import { askAI } from '../../../lib/ai'
import { getSupabaseAdmin } from '../../../lib/supabaseAdmin'

// ИИ-чат помощник для CV и мотивационного письма — Pro-фича, тот же
// паттерн проверки (Bearer-токен + profiles.is_pro), что у /api/verdict.
// Приглашение сообщение первый ход не идёт через ИИ — рисуется сразу в
// компоненте (CVMotivationAssistant.tsx), сюда попадают только реальные
// реплики студента и дальше.

export async function POST(req: NextRequest) {
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
    return NextResponse.json({ error: 'Помощник CV и писем — платная функция Pro', locked: true }, { status: 403 })
  }

  const { mode, profile, program, messages } = await req.json()
  if (mode !== 'cv' && mode !== 'motivation') {
    return NextResponse.json({ error: 'Неизвестный режим' }, { status: 400 })
  }
  if (!Array.isArray(messages) || messages.length === 0) {
    return NextResponse.json({ error: 'Пустой запрос' }, { status: 400 })
  }

  const directionText = profile.master_direction === 'same' ? 'продолжает то же направление бакалавриата'
    : profile.master_direction === 'related' ? 'смежная область с бакалавриатом'
    : profile.master_direction === 'change' ? 'кардинальная смена направления от бакалавриата' : 'не указано'
  const workText = profile.work === 'yes' ? 'есть, 1+ год' : profile.work === 'some' ? 'немного — стажировки/проекты' : 'нет'

  const programText = program
    ? `\nПРОГРАММА, на которую пишем (учитывай её конкретику — название вуза, направление, требования):
${program.name} — ${program.university_name}
Направление: ${program.field}
Языковой минимум: IELTS ${program.ielts_min ?? 'не указан'}${program.requires_work_years ? `\nТребует опыт работы: от ${program.requires_work_years} лет (формат MBA/Executive — тон и акценты письма должны быть соответствующими)` : ''}`
    : '\nКонкретная программа не выбрана — пиши универсально, но напоминай, что финальную версию для конкретного вуза обычно нужно чуть адаптировать под его специфику.'

  const docLabel = mode === 'cv' ? 'CV (résumé)' : 'мотивационное письмо (Statement of Purpose)'

  const system = `Ты — ИИ-помощник в Mastersly, помогаешь российскому студенту написать ${docLabel} для поступления на магистратуру в Европе.

ПРОФИЛЬ СТУДЕНТА:
- GPA: ${profile.gpa ?? 'не указан'} из 5 (российская шкала)
- IELTS: ${profile.ielts || 'сертификата ещё нет'}
- Направление бакалавриата относительно магистратуры: ${directionText}
- Опыт работы: ${workText}
${programText}

ПРАВИЛА, СЛЕДУЙ ИМ СТРОГО:
1. Общайся со студентом ПО-РУССКИ — объясняй, спрашивай уточнения, комментируй черновики на русском.
2. Сам текст CV/письма пиши ВСЕГДА НА АНГЛИЙСКОМ — это язык подачи документов почти во все программы, которые есть в Mastersly, независимо от языка разговора вокруг.
3. САМОЕ ГЛАВНОЕ ПРАВИЛО: НИКОГДА не выдумывай за студента конкретные факты — названия проектов, должности, цифры результатов, достижения, публикации. Если для убедительного абзаца не хватает конкретики — спроси у студента напрямую, что было в реальности. Если студент просит "просто напиши что-нибудь" или "придумай что-то" — предложи готовую СТРУКТУРУ текста с плейсхолдерами в квадратных скобках (например "[название проекта]", "[на сколько % улучшил метрику]"), которые студент заполнит сам, а не придумывай правдоподобные на вид факты. Выдуманное достижение в реальном CV — это не просто плохой текст, это риск для самого студента при поступлении.
4. ${mode === 'cv'
    ? 'Формат CV: одна страница, разделы Education / Work Experience / Skills / Languages (+ Projects или Publications, если релевантно для профиля). Пункты опыта — короткие, начинаются с глагола действия, там где есть реальные цифры — с результатом. Без фото, без даты рождения (не принято в англоязычных CV).'
    : 'Формат письма: примерно 450-600 слов. Структура: почему это направление -> почему именно эта программа/вуз (если выбрана) -> как бэкграунд студента это подтверждает конкретными фактами -> куда дальше (карьерные планы). Формально, но живым языком — без клише вида "I have always been passionate about..." без конкретики сразу после.'}
5. Когда выдаёшь готовый текст документа — оформляй его отдельным чистым блоком (просто текст на английском, без лишней разметки), чтобы студент мог легко его скопировать.
6. Будь по-настоящему полезным помощником, а не просто генератором текста: если видишь слабое место в подаче (например, нет опыта, а программа его подразумевает) — прямо скажи об этом и подскажи, как обойти/компенсировать в тексте, честно.`

  try {
    const text = await askAI(messages, { maxTokens: 1400, system })
    return NextResponse.json({ reply: text })
  } catch (e: any) {
    console.error('writing-assistant AI call failed:', e)
    return NextResponse.json({ error: e?.message ?? 'AI request failed' }, { status: 502 })
  }
}
