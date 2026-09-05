#!/usr/bin/env node
// Инструмент для сбора верифицированных данных по магистерским программам
// с реальным веб-поиском (Anthropic server-side web_search tool), вместо
// старого app/api/admin/seed-programs/route.ts, который просто просил
// модель "вспомнить" программы без проверки (это и создало исходную
// непроверенную базу из 281 программы).
//
// Отличия от seed-programs:
// - Реально ищет в интернете (web_search_20260209), не угадывает по памяти
// - Знает про "ловушку" EU/non-EU тюишна (см. CLAUDE.md, урок с Corvinus)
// - verified=true только когда тюишн+дедлайн+язык подтверждены на ОДНОЙ
//   официальной странице, явно для не-ЕС студентов
// - Не пишет в базу напрямую сам — готовит SQL-файл в том же формате, что
//   и предыдущие ручные партии. С 2026-08-28 в .env.local есть
//   SUPABASE_SERVICE_ROLE_KEY — применить файл можно через
//   `node scripts/run-sql.mjs sql/<файл>.sql --apply` (сначала без
//   --apply — dry run), без похода в Supabase SQL Editor руками.
// - Проверяет существующие university/program по анонимному ключу (только
//   чтение), чтобы не дублировать то, что уже в базе
// - Каждая найденная ссылка проверяется настоящим HTTP-запросом (не ИИ) —
//   если не резолвится (404/DNS-ошибка), запись целиком отбрасывается,
//   а не остаётся с выдуманным URL
//
// Использование:
//   node scripts/research-programs.mjs --country de --name Germany
//   node scripts/research-programs.mjs --country de --name Germany --fields "Computer Science,Data Science"
//   node scripts/research-programs.mjs --country de --name Germany --model claude-sonnet-5 --max-uses 6
//
// Режим --comprehensive (2026-08-29, по просьбе Дениса "закрыть Венгрию
// полностью, собирать вообще все направления, все смежные программы"):
// три отдельных шага на каждый вуз, а не один большой запрос:
//   1. enumerateUniversityPrograms — просто перечислить ВСЕ англоязычные
//      магистратуры вуза (имя+ссылка), без классификации и деталей —
//      минимальная схема, самый надёжный шаг.
//   2. classifyPrograms — расфасовать список по нашим 8 категориям (или
//      null = не подходит) БЕЗ веб-поиска вообще — чистый текстовый
//      вызов, в принципе не подвержен багу прокси про повторные раунды
//      поиска (см. ниже), потому что поиска тут просто нет.
//   3. fetchProgramDetails — по каждой подошедшей программе отдельный
//      маленький запрос за тюишном/дедлайном/IELTS.
// Раньше пробовал одним большим запросом "весь каталог сразу с деталями"
// и даже "вуз × поле сразу с деталями" — оба варианта регулярно ловили
// баг с повторным раундом поиска именно из-за объёма/сложности задачи за
// один вызов. Дробление на простые шаги оказалось надёжнее.
// Business Analytics и Computational Engineering — широкие категории
// "по умолчанию" (Sport Management, Agile/Entrepreneurship и т.п. туда
// осознанно попадают, а не отбрасываются).
//   node scripts/research-programs.mjs --country hu --name Hungary --comprehensive
//   node scripts/research-programs.mjs --country hu --name Hungary --comprehensive --only-university "Corvinus,Debrecen"
//
// Модель по умолчанию — claude-sonnet-5 (см. находку про opus-5 ниже).
//
// ВАЖНАЯ НАХОДКА про прокси api.apihost.one (эмпирически, 2026-08-28/29):
// - web_search реально исполняется на сервере (не просто прокидывается
//   модели как пустой tool_use)
// - но многораундовый поиск (нашёл → подумал → снова ищет) ломается:
//   модель делает второй раунд поиска и НИКОГДА не пишет финальный текст,
//   ответ тихо теряется (stop_reason=end_turn, пустой text). Чем
//   амбициознее задача за один вызов — тем сильнее модель тянется ко
//   второму раунду, независимо от того, как жёстко это запрещено в
//   промпте. Один раунд с параллельными запросами внутри него — работает
//   надёжно, но только если сама задача достаточно узкая/простая
// - ОТДЕЛЬНО от этого есть плавающая ненадёжность: даже при одном раунде
//   ответ иногда обрывается на полуслове (например, прямо на "[") ещё
//   ЗАДОЛГО до лимита токенов — не всегда воспроизводится, похоже на
//   таймаут самого прокси на более долгих запросах, а не на баг логики.
//   Лечится только повторными попытками (см. withRetry ниже)
// Если в будущем это исправят на стороне прокси — можно будет снова
// пробовать более крупные/амбициозные запросы за один раз.

import Anthropic from '@anthropic-ai/sdk'
import { createClient } from '@supabase/supabase-js'
import { readFileSync, writeFileSync, appendFileSync, mkdirSync, existsSync } from 'fs'
import { randomUUID } from 'crypto'
import { jsonrepair } from 'jsonrepair'

// ---- .env.local (читаем файл напрямую — на этой машине есть системные
// ANTHROPIC_BASE_URL/ANTHROPIC_API_KEY от самого Claude Code, которые
// иначе перекрыли бы значения из .env.local) ----
const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(
  envText
    .split('\n')
    .map((l) => l.trim())
    .filter((l) => l && !l.startsWith('#') && l.includes('='))
    .map((l) => {
      const idx = l.indexOf('=')
      return [l.slice(0, idx).trim(), l.slice(idx + 1).trim()]
    })
)

// ---- CLI-аргументы ----
const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, arr) => {
    if (a.startsWith('--')) acc.push([a.slice(2), arr[i + 1] && !arr[i + 1].startsWith('--') ? arr[i + 1] : true])
    return acc
  }, [])
)

const COUNTRY_CODE = args.country
const COUNTRY_NAME = args.name
if (!COUNTRY_CODE || !COUNTRY_NAME) {
  console.error('Использование: node scripts/research-programs.mjs --country <код> --name <Название страны> [--fields "Field1,Field2"] [--comprehensive] [--only-university "Name1,Name2"] [--model claude-sonnet-5]')
  process.exit(1)
}

const ALL_FIELDS = [
  'Computer Science', 'Artificial Intelligence', 'Data Science',
  'Cybersecurity', 'Business Analytics', 'Robotics',
  'Human-Computer Interaction', 'Computational Engineering',
]
const FIELDS = args.fields ? args.fields.split(',').map((f) => f.trim()) : ALL_FIELDS
for (const f of FIELDS) {
  if (!ALL_FIELDS.includes(f)) {
    console.error(`Неизвестное поле "${f}". Разрешены только: ${ALL_FIELDS.join(', ')}`)
    process.exit(1)
  }
}

// см. research-reviews.mjs — claude-opus-5 оказался ненадёжен на этом
// прокси для длинных промптов с web_search (2026-08-28), claude-sonnet-5
// стабильно работает. Не решение по цене — вопрос совместимости с прокси.
const MODEL = args.model ?? 'claude-sonnet-5'
const MAX_USES = Number(args['max-uses'] ?? 6)
const SLEEP_MS = Number(args.sleep ?? 2000)

// --from-file <path>: пропустить шаги 1 (перечислить) и 2 (классифицировать)
// целиком — вместо ИИ-перечисления, которое на больших многофакультетных
// вузах (Болонья и т.п.) систематически недосчитывает программы даже при
// успешном ответе (см. CLAUDE.md, 2026-08-30), список уже готов заранее
// (например, собран через MastersPortal + тот же классификатор ключевых
// слов офлайн). Формат файла: { "Имя вуза как в БД": [{name,url,field}] }.
// Шаг 3 (детали по каждой программе через web_search) выполняется как
// обычно — MastersPortal не даёт официальный источник для tuition/deadline.
const FROM_FILE = args['from-file']

const anthropic = new Anthropic({ apiKey: env.ANTHROPIC_API_KEY, baseURL: env.ANTHROPIC_BASE_URL })
const supabase = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_ANON_KEY)

const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

// ---- Retry-обёртка (сетевые обрывы до Supabase, "оборванный на полуслове"
// ответ ИИ-прокси — см. шапку файла) ----
async function withRetry(fn, attempts = 4) {
  let lastErr
  for (let i = 1; i <= attempts; i++) {
    try {
      return await fn()
    } catch (e) {
      lastErr = e
      if (i < attempts) {
        console.log(`  (попытка ${i}/${attempts - 1} не удалась: ${e.message}, повтор через паузу)`)
        await sleep(3000 * i)
      }
    }
  }
  throw lastErr
}

// ---- Уже есть в базе — чтобы не дублировать ----
async function fetchExisting(countryCode) {
  const { data: unis, error: uniErr } = await withRetry(() =>
    supabase.from('universities').select('id, name, city, website').eq('country', countryCode)
  )
  if (uniErr) throw uniErr

  const existingUnisByName = new Map(unis.map((u) => [u.name.toLowerCase(), u.id]))

  let existingPrograms = []
  if (unis.length) {
    const { data: progs, error: progErr } = await withRetry(() =>
      supabase.from('programs').select('name, field, university_id').in('university_id', unis.map((u) => u.id))
    )
    if (progErr) throw progErr
    const idToName = new Map(unis.map((u) => [u.id, u.name]))
    existingPrograms = progs.map((p) => ({ university: idToName.get(p.university_id), name: p.name, field: p.field }))
  }

  return { existingUnisByName, existingPrograms, universities: unis }
}

// ---- Проверка URL по-настоящему (не ИИ) — отсеивает выдуманные ссылки ----
async function verifyUrl(url) {
  try {
    const controller = new AbortController()
    const timeout = setTimeout(() => controller.abort(), 8000)
    let res
    try {
      res = await fetch(url, { method: 'HEAD', redirect: 'follow', signal: controller.signal })
    } catch {
      res = await fetch(url, { method: 'GET', redirect: 'follow', signal: controller.signal })
    }
    clearTimeout(timeout)
    if (res.status === 404 || res.status === 410) return { ok: false, reason: `HTTP ${res.status}` }
    return { ok: true, status: res.status }
  } catch (e) {
    // DNS-ошибка / соединение не установлено — считаем ссылку выдуманной.
    // Таймаут/блокировка ботов — не считаем однозначным доказательством
    // подделки, оставляем с пометкой в cons.
    if (e.name === 'AbortError') return { ok: true, status: 'timeout', uncertain: true }
    return { ok: false, reason: e.cause?.code || e.message }
  }
}

// ---- Общий вызов модели с web_search + разбор JSON-массива из ответа ----
async function callWithSearchExpectArray(prompt, { maxTokens = 32000, maxUses = MAX_USES } = {}) {
  let messages = [{ role: 'user', content: prompt }]
  let response
  let totalUsage = { input_tokens: 0, output_tokens: 0 }

  // Server-side web_search может занять несколько ходов (stop_reason
  // "pause_turn") — это не наш "второй раунд поиска" баг, это сама
  // модель ещё не закончила текущий ход, продолжаем его нормально.
  for (let i = 0; i < 6; i++) {
    const stream = anthropic.messages.stream({
      model: MODEL,
      max_tokens: maxTokens,
      tools: [{ type: 'web_search_20260209', name: 'web_search', max_uses: maxUses }],
      messages,
    })
    // 2026-08-30: прокси иногда просто виснет — соединение открыто, но
    // ни данных, ни ошибки не приходит бесконечно (реальный случай на
    // Италии: фоновый процесс завис на много часов на одном вызове).
    // Штатный таймаут SDK/прокси тут не срабатывает, поэтому свой жёсткий
    // потолок + stream.abort(), чтобы withRetry вообще получил шанс
    // повторить попытку, а не ждал вечно.
    response = await Promise.race([
      stream.finalMessage(),
      new Promise((_, reject) => setTimeout(() => { stream.abort(); reject(new Error('timeout: прокси не ответил за 90с')) }, 90000)),
    ])
    totalUsage.input_tokens += response.usage?.input_tokens ?? 0
    totalUsage.output_tokens += response.usage?.output_tokens ?? 0
    if (response.stop_reason !== 'pause_turn') break
    messages = [...messages, { role: 'assistant', content: response.content }]
  }

  const textBlocks = response.content.filter((b) => b.type === 'text')
  const fullText = textBlocks.map((b) => b.text).join('\n')
  const parsed = extractJsonArray(fullText, response)
  return { programs: parsed, usage: totalUsage }
}

// Ищем именно ПАРНУЮ закрывающую скобку первого '[', не lastIndexOf(']') —
// тот мог захватить лишнее, если после массива есть ещё текст со своими
// скобками.
function extractJsonArray(fullText, response) {
  const start = fullText.indexOf('[')
  let end = -1
  if (start !== -1) {
    let depth = 0
    for (let i = start; i < fullText.length; i++) {
      if (fullText[i] === '[') depth++
      else if (fullText[i] === ']') { depth--; if (depth === 0) { end = i; break } }
    }
  }
  if (start !== -1 && end !== -1) {
    const raw = fullText.slice(start, end + 1)
    try {
      return JSON.parse(raw)
    } catch {
      try { return JSON.parse(jsonrepair(raw)) } catch { /* падаем в спасательный разбор ниже */ }
    }
  }

  // 2026-09-02, найдено на живом прогоне по Австрии (TU Wien): у крупных
  // вузов с длинным списком программ ответ иногда обрывается ПОСЕРЕДИНЕ
  // JSON-массива — упираемся в max_tokens после того, как много бюджета
  // уже съели thinking/web_search-блоки. Раньше это teряло вообще все
  // найденные программы (ни одной закрывающей ']' — весь ответ выкидывался
  // как ошибка). Теперь, если массив не закрылся, вытаскиваем по одному
  // ЦЕЛЫЕ объекты {...} до места обрыва — то, что модель успела дописать
  // полностью, не пропадает зря.
  if (start !== -1) {
    const salvaged = []
    let i = start + 1
    while (i < fullText.length) {
      const objStart = fullText.indexOf('{', i)
      if (objStart === -1) break
      let depth = 0, objEnd = -1
      for (let j = objStart; j < fullText.length; j++) {
        if (fullText[j] === '{') depth++
        else if (fullText[j] === '}') { depth--; if (depth === 0) { objEnd = j; break } }
      }
      if (objEnd === -1) break // сам объект тоже оборван — дальше спасать нечего
      const objRaw = fullText.slice(objStart, objEnd + 1)
      try { salvaged.push(JSON.parse(objRaw)) }
      catch { try { salvaged.push(JSON.parse(jsonrepair(objRaw))) } catch { /* пропускаем нечитаемый объект */ } }
      i = objEnd + 1
    }
    if (salvaged.length) return salvaged
  }

  const blockSummary = response?.content?.map((b) => b.type).join(', ') ?? '?'
  throw new Error(
    `No JSON array found. stop_reason=${response?.stop_reason}, blocks=[${blockSummary}]. Text: ${fullText.slice(0, 500) || '(empty)'}`
  )
}

// =====================================================================
// Режим "по полям для всей страны" (обычный, не --comprehensive)
// =====================================================================
function buildPrompt(field, existingPrograms) {
  const skipList = existingPrograms
    .filter((p) => p.field === field)
    .map((p) => `- ${p.university} — "${p.name}"`)
    .join('\n')

  return `You are researching REAL, currently-open, English-taught master's (MSc/MA) programs in the field "${field}" at universities in ${COUNTRY_NAME}, for a study-abroad web app that helps non-EU (mostly Russian/CIS) students apply.

Use your web_search tool — actually search the web, don't answer from memory. Find up to 3 real programs at different universities (skip ones already in our database, listed below). Prefer well-known, reputable universities.

IMPORTANT — how to search: you get exactly ONE round of web searches. Issue every query you need as PARALLEL tool calls within that single round (e.g. 3-5 searches at once) — do not do a second round after seeing the first round's results, even if something is still unclear. A second round silently drops your final answer on this platform. After that one batch, immediately write your final JSON answer.

${skipList ? `Programs already in our database for "${field}" in ${COUNTRY_NAME} — do NOT repeat these:\n${skipList}\n` : ''}

## Critical rule: the EU vs non-EU tuition trap
Universities in many European countries show ONE tuition figure that is actually the EU/EEA-citizen rate, while a real non-EU student (our target audience) pays a HIGHER rate — sometimes 1.5-3x higher, sometimes the same, occasionally even lower. Actively search for "non-EU tuition"/"international (non-EU/EEA)"/"third-country nationals" tables. If only one figure is shown with no split, use it but set verified=false. verified=true only when tuition+deadline+language are ALL confirmed for non-EU students on the SAME page cited in "url".

## Field values (STRICT — use exactly one of these 8, nothing else)
"Computer Science", "Artificial Intelligence", "Data Science", "Cybersecurity", "Business Analytics", "Robotics", "Human-Computer Interaction", "Computational Engineering"
This program's field must be "${field}" for every entry you return.

## Never fabricate
If you can't find a real figure, use your best-sourced estimate but set verified=false and say what's missing in cons. Never invent a URL — only cite ones you actually found.

## Output — ONLY this JSON array (no markdown fences, no other text):
[
  {
    "university_name": "Official English name of the university",
    "university_city": "City",
    "university_website": "https://university-homepage.example",
    "university_ranking_qs": 150,
    "program_name": "Official program name exactly as the university calls it",
    "duration_months": 24,
    "tuition_eur": 6400,
    "deadline_month": 4,
    "deadline_day": 30,
    "ielts_min": 6.0,
    "gpa_min": 3,
    "url": "https://direct-link-to-the-program-admissions-page",
    "scholarships": [],
    "summary_ru": "1-2 предложения по-русски для абитуриента",
    "pros_ru": ["плюс 1", "плюс 2"],
    "cons_ru": ["минус/оговорка 1"],
    "verified": true,
    "source_note_ru": "что подтверждено и почему verified true/false, по-русски"
  }
]
"ielts_min" null only if genuinely no fixed threshold. "tuition_eur" annual EUR (convert if needed).`
}

async function researchField(field, existingPrograms) {
  return callWithSearchExpectArray(buildPrompt(field, existingPrograms), { maxTokens: 32000 })
}

// =====================================================================
// Режим --comprehensive: 3 шага на вуз (см. пояснение в шапке файла)
// =====================================================================

// ---- Шаг 1: просто перечислить программы, без классификации/деталей ----
//
// 2026-08-29, второй проход (по факту с Италией — Болонья вернула всего 6
// программ ВСЕГО, хотя реально их там около 40): один широкий запрос "на
// всё сразу" по факту недосчитывает крупные/многофакультетные вузы — весь
// поисковый бюджет (10 uses) размазывается по десятку факультетов сразу,
// и на платформе, где второй раунд поиска молча теряет ответ, модель не
// может добрать недостающее повторным поиском. Решение — то же самое, что
// уже сработало для сравнения программ ("расфасовать по кластерам, не
// один большой запрос"): бьём перечисление на 3 узких захода по кластерам
// факультетов, каждый — свой собственный "один раунд поиска", и объединяем
// результаты по URL. Дороже по токенам (3 вызова вместо 1), но не ловит
// баг с повторным раундом и даёт заметно более полный список.
const ENUMERATE_CLUSTERS = [
  { key: 'business', hint: 'Business, Management, Economics, Finance, Marketing, Accounting, Entrepreneurship, HR, Innovation Management' },
  { key: 'tech', hint: 'Engineering (all kinds), Computer Science, Data Science, AI, Cybersecurity, Robotics' },
  { key: 'other', hint: 'Science, Design, Architecture, Social Sciences, and any other schools/faculties not covered by Business or Engineering/CS' },
]

function buildEnumeratePrompt(uni, cluster) {
  const hostname = uni.website ? new URL(uni.website).hostname : uni.name
  return `List EVERY master's (MSc/MA or equivalent) program taught in English at ${uni.name} (${uni.city}${uni.website ? `, official site: ${uni.website}` : ''}), specifically in these fields: ${cluster.hint}.

This is one focused slice of a larger sweep — don't worry about programs outside this field list, another pass covers those. Within this slice, be exhaustive: large universities often have 8-15 programs per cluster like this — don't stop after finding just a couple.

## How to search — ONE round only, hard platform limit
Issue several PARALLEL search queries in a SINGLE turn: one general "site:${hostname} master's programs ${cluster.key}" query, plus one per specific school/department within this slice you'd expect this university to have, plus a query against the Stipendium Hungaricum course catalog if this is a Hungarian university. Do NOT search again after seeing results — a second round silently discards the whole response on this platform.

## URLs must be real
Only use a URL that literally appeared in your search results — never invent one.

## Output — ONLY this JSON array, nothing else (literal "[]" if you truly found nothing in this slice, never explain in prose instead):
[{"name": "Official program name", "url": "https://..."}]`
}

async function enumerateUniversityPrograms(uni) {
  const totalUsage = { input_tokens: 0, output_tokens: 0 }
  const byUrl = new Map()
  for (const cluster of ENUMERATE_CLUSTERS) {
    try {
      // maxTokens поднят с 16000 до 28000 (2026-09-02, после сбоя на
      // TU Wien) — на вузах с длинным каталогом (много Executive
      // MBA-вариантов и т.п.) thinking+web_search-блоки съедали почти
      // весь бюджет, и текст ответа обрывался ещё до первой "[".
      const { programs, usage } = await withRetry(() => callWithSearchExpectArray(buildEnumeratePrompt(uni, cluster), { maxTokens: 28000, maxUses: 8 }), 3)
      totalUsage.input_tokens += usage.input_tokens ?? 0
      totalUsage.output_tokens += usage.output_tokens ?? 0
      for (const p of programs) {
        if (p?.name && p?.url && !byUrl.has(p.url)) byUrl.set(p.url, p)
      }
    } catch (e) {
      // Одна не удавшаяся полоска не должна валить весь вуз — остальные
      // кластеры всё равно дают частичный, но полезный результат.
    }
  }
  return { programs: [...byUrl.values()], usage: totalUsage }
}

// ---- Шаг 2: классификация ПРАВИЛАМИ ПО КЛЮЧЕВЫМ СЛОВАМ, без обращения
// к ИИ вообще ----
// Перепробовано несколько форматов промпта через API (с URL, без URL,
// пачками по 8, с номерами вместо текста) — каждый раз ответ обрывался
// на полуслове через несколько десятков токенов, независимо от объёма
// или формата запроса. Раз задача чисто про сопоставление ключевых слов
// (не глубокое рассуждение), надёжнее и быстрее сделать это обычным
// кодом — заодно вообще не тратит ни токены API, ни лимиты этой сессии.
// Правила отражают то же самое "широкое" толкование категорий, что
// использовалось во всех промптах этого файла и в ручной классификации
// за 2026-08-28/29 (Sport Management/Agile Entrepreneurship и т.п. →
// Business Analytics).
const FIELD_KEYWORD_RULES = [
  // Жёсткие исключения — проверяются ПЕРВЫМИ, до любых совпадений по полю
  { exclude: true, re: /\b(medicine|medical|dentist|dental|pharma(cy|ceutical)?(?! innovation)|nursing|clinical|theology|theological|divinity|law\b|llm\b|legal(?! tech)|history|literature|linguistics(?! computational)|philosophy|philology|fine arts|performing arts|music(?! informatics)|painting|sculpture|agricultur|forestry|pedagog|teacher education|social work|veterinary)\b/i },

  { field: 'Cybersecurity', re: /\b(cyber ?security|information security|network security|infosec)\b/i },
  { field: 'Artificial Intelligence', re: /\b(artificial intelligence|\bai\b|machine learning|deep learning)\b/i },
  { field: 'Robotics', re: /\b(robot(ic)?s?|mechatronic|automation engineering|autonomous (system|vehicle|driving))\b/i },
  { field: 'Data Science', re: /\b(data science|data analytics|big data|bioinformatics|geoinformatics|business intelligence)\b/i },
  { field: 'Human-Computer Interaction', re: /\b(human.computer interaction|\bhci\b|ux|user experience|interaction design|digital media design)\b/i },
  { field: 'Computer Science', re: /\b(computer science|software engineering|information technology|information systems(?! management)|it engineering)\b/i },
  {
    // 2026-08-30: добавлены aerospace/automotive/electronic(s)/nuclear/
    // nanotechnology/control engineering — найдено при разборе списка
    // MastersPortal для Италии, где "Aerospace Engineering" (Bologna,
    // Padua) и "Automotive Engineering" (Torino) не матчились вообще ни
    // под одно поле и терялись как неклассифицированные.
    field: 'Computational Engineering',
    re: /\b(electrical engineering|mechanical engineering|civil engineering|environmental engineering|energy engineering|materials engineering|telecommunications?|structural engineering|infrastructural engineering|transportation engineering|vehicle engineering|construction|chemical engineering|biomedical engineering|quantum engineering|aerospace engineering|automotive engineering|electronic(s)? engineering|nuclear engineering|nanotechnology engineering|control (systems? )?engineering)\b/i,
  },
  {
    field: 'Business Analytics',
    re: /\b(business|management|marketing|finance|financial|accounting|entrepreneur|sport management|hr\b|human resources?|supply chain|logistics|hospitality|tourism|economic|econom(y|ics)|innovation|mba|international trade|banking|insurance)\b/i,
  },
]

function classifyByKeywords(name) {
  for (const rule of FIELD_KEYWORD_RULES) {
    if (rule.re.test(name)) return rule.exclude ? null : rule.field
  }
  return null // не нашли уверенного совпадения — не выдумываем, пропускаем
}

// Нормализация имени для сравнения дублей: "MSc Innovation and
// Entrepreneurship" и "Innovation and Entrepreneurship MSc" — одна и та
// же программа, но точное сравнение строк это не ловит (реальный случай,
// поймали на Corvinus 2026-08-29: одна и та же программа задвоилась под
// tuition_eur=14800 при уже существующей верифицированной записи €7400).
// Убираем степень/пунктуацию и сортируем слова — так порядок и мелкие
// вариации формулировки degree title перестают иметь значение.
function normalizeName(name) {
  return name
    .toLowerCase()
    .replace(/\b(msc|ma|m\.sc\.?|m\.a\.?|master(?:'s)? (?:of science|of arts)?(?: in)?|master in)\b/g, '')
    .replace(/[^a-z0-9]+/g, ' ')
    .trim()
    .split(' ')
    .filter((w) => w && w !== 'in' && w !== 'of' && w !== 'and' && w !== 'the') // служебные слова — "MSc IN X" vs "Master of Science in X" иначе не совпадают
    .sort()
    .join(' ')
}

async function classifyPrograms(uni, rawList, alreadyKnownNames) {
  const knownNormalized = new Set(alreadyKnownNames.map(normalizeName))
  const items = rawList
    .filter((p) => !knownNormalized.has(normalizeName(p.name)))
    .map((p) => ({ name: p.name, url: p.url, field: classifyByKeywords(p.name) }))
  return { items, usage: { input_tokens: 0, output_tokens: 0 } }
}

// ---- Шаг 3: детали по ОДНОЙ уже известной программе ----
function buildDetailPrompt(uni, item) {
  return `Find official details for this SPECIFIC master's program (you already know it exists — just get the facts):

Program: "${item.name}" at ${uni.name} (${uni.city})
Known URL: ${item.url}

Confirm/refine tuition, deadline, and IELTS requirement — specifically for NON-EU/international students (our audience). Many European universities show a lower EU/EEA rate on the same page as a higher non-EU rate (or occasionally the reverse) — actively look for the distinction.

## How to search — ONE round only
A few parallel searches around the known URL and program name is enough. No second round — it silently loses the response on this platform.

## Never fabricate
If a real figure can't be found, use your best-sourced estimate, set verified=false, explain what's missing in cons. verified=true only when tuition+deadline+language are ALL confirmed for non-EU students on the SAME page cited in "url".

## URLs must be real
Only use a URL that literally appeared in search results — the known URL above, or one you found confirming/refining it. Never invent one.

## Output — ONLY this JSON array with exactly one object, nothing else:
[{
  "program_name": "${item.name.replace(/"/g, '\\"')}",
  "duration_months": 24,
  "tuition_eur": 6400,
  "deadline_month": 4,
  "deadline_day": 30,
  "ielts_min": 6.0,
  "gpa_min": 3,
  "url": "https://real-url-you-confirmed-or-found",
  "scholarships": [],
  "summary_ru": "1-2 предложения по-русски",
  "pros_ru": ["плюс 1", "плюс 2"],
  "cons_ru": ["минус/оговорка 1"],
  "verified": true,
  "source_note_ru": "что подтверждено и почему verified true/false, по-русски"
}]`
}

async function fetchProgramDetails(uni, item) {
  return withRetry(() => callWithSearchExpectArray(buildDetailPrompt(uni, item), { maxTokens: 16000, maxUses: 4 }), 3)
}

// ---- SQL-генерация ----
function sqlEscape(str) {
  return String(str ?? '').replace(/'/g, "''")
}
function sqlArray(arr) {
  if (!arr || !arr.length) return 'array[]::text[]'
  return `array[${arr.map((s) => `'${sqlEscape(s)}'`).join(', ')}]`
}
function sqlNum(n) {
  return n === null || n === undefined ? 'null' : n
}

function programInsertSql(p) {
  return `\n-- ${p.source_note_ru ? sqlEscape(p.source_note_ru).replace(/\n/g, '\n-- ') : 'Источник: ' + p.url}\n` +
    `insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '${p.universityId}',
  '${sqlEscape(p.program_name)}', '${p.field}', 'English', ${sqlNum(p.duration_months ?? 24)}, ${sqlNum(p.tuition_eur ?? 0)},
  ${sqlNum(p.deadline_month)}, ${sqlNum(p.deadline_day)}, ${sqlNum(p.ielts_min)}, ${sqlNum(p.gpa_min ?? 3)}, '${sqlEscape(p.url)}',
  ${sqlArray(p.scholarships)},
  '${sqlEscape(p.summary_ru)}',
  ${sqlArray(p.pros_ru)},
  ${sqlArray(p.cons_ru)},
  ${p.verified ? 'true' : 'false'}, ${p.verified ? 'current_date' : 'null'}
);\n`
}

function universityInsertSql(id, u, countryCode) {
  return `\ninsert into universities (id, name, country, city, website, ranking_qs) values\n` +
    `  ('${id}', '${sqlEscape(u.name)}', '${countryCode}', '${sqlEscape(u.city)}', '${sqlEscape(u.website)}', ${sqlNum(u.ranking_qs)})\n` +
    `on conflict (id) do nothing;\n`
}

async function main() {
  const COMPREHENSIVE = !!args.comprehensive
  console.log(
    COMPREHENSIVE
      ? `Исследую ${COUNTRY_NAME} (${COUNTRY_CODE}) ПОЛНОСТЬЮ, по вузам, модель: ${MODEL}\n`
      : `Исследую ${COUNTRY_NAME} (${COUNTRY_CODE}), поля: ${FIELDS.join(', ')}, модель: ${MODEL}\n`
  )

  const { existingUnisByName, existingPrograms, universities } = await fetchExisting(COUNTRY_CODE)
  console.log(`Уже в базе: ${existingUnisByName.size} вузов, ${existingPrograms.length} программ по стране\n`)

  // Файл пишется СРАЗУ и ДОПОЛНЯЕТСЯ по ходу дела (не копится в памяти до
  // конца) — раньше долгий прогон убивало по таймауту фонового процесса,
  // и весь найденный результат терялся, потому что файл писался только
  // один раз в самом конце. Без begin/commit — каждый insert применяется
  // как отдельный самостоятельный запрос (так же, как run-sql.mjs и так
  // их выполняет, по одному через REST, а не одной транзакцией).
  mkdirSync(new URL('../sql', import.meta.url), { recursive: true })
  const today = new Date().toISOString().slice(0, 10)
  const suffix = COMPREHENSIVE ? 'comprehensive' : 'auto-research'
  const outPath = new URL(`../sql/${today}-${COUNTRY_CODE}-${suffix}.sql`, import.meta.url)
  // 2026-09-03, найдено на живом прогоне по Германии: раньше это всегда
  // было writeFileSync — второй запуск в тот же день на ту же страну (typично
  // при возобновлении после сбоя/зависания, --only-university на остаток)
  // молча стирал всё, что дописал первый запуск, потому что имя файла
  // зависит только от даты+страны+режима, не от конкретного запуска.
  // Реальная потеря: часть успешно найденных программ первого захода по
  // Германии пропала именно так. Теперь при повторном запуске в тот же
  // день — дописываем новый раздел с собственным заголовком поверх уже
  // накопленного, вместо того чтобы стирать файл.
  const fileExists = existsSync(outPath)
  const write = fileExists ? appendFileSync : writeFileSync
  write(outPath, `${fileExists ? '\n-- ============================================================\n-- Новый запуск того же дня/страны/режима — ДОПИСАНО поверх уже\n-- накопленного файла, не стёрто (см. комментарий в коде main()).\n-- ============================================================\n' : ''}-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: ${COUNTRY_NAME} (${COUNTRY_CODE})${COMPREHENSIVE ? ' — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали)' : `, поля: ${FIELDS.join(', ')}`}, модель: ${MODEL}
-- Дата: ${today}
--
-- В отличие от app/api/admin/seed-programs/route.ts (тот просит модель
-- "вспомнить" данные без проверки), этот инструмент реально ищет в
-- интернете через Anthropic web_search и цитирует официальные страницы.
-- Тем не менее verified=true проставлено только когда тюишн+дедлайн+язык
-- подтверждены на ОДНОЙ официальной странице явно для не-ЕС ставки —
-- остальное verified=false, хоть цифры и реальные, с официальных сайтов.
-- Источник и обоснование verified для каждой программы — в комментарии
-- прямо над её INSERT (source_note_ru от модели, дословно).
--
-- Файл пишется ПО ХОДУ СБОРА (не одним куском в конце) — если прогон
-- прервётся на середине, всё найденное до этого момента уже сохранено.
--
-- НЕ запущено в Supabase — выполнить вручную через SQL Editor, или
-- node scripts/run-sql.mjs sql/<этот файл>.sql --apply
`, 'utf8')

  const newUniInserts = new Map() // id -> {name, city, website, ranking_qs}
  const writtenUniIds = new Set()
  let programCount = 0
  const errors = []
  const brokenUrls = []
  let totalUsage = { input_tokens: 0, output_tokens: 0 }

  async function ingestPrograms(programs, universityName, universityCity, universityWebsite, universityRankingQs, defaultField) {
    for (const p of programs) {
      if (!p.program_name || !p.url) {
        errors.push(`${universityName}: пропущена запись без program_name/url`)
        continue
      }
      const field = p.field ?? defaultField
      if (!ALL_FIELDS.includes(field)) {
        errors.push(`${universityName} — "${p.program_name}": неизвестное поле "${field}", пропущено`)
        continue
      }

      // Настоящая HTTP-проверка ссылки — не доверяем ИИ на слово.
      process.stdout.write(`    проверяю ссылку "${p.program_name}"... `)
      const check = await verifyUrl(p.url)
      if (!check.ok) {
        console.log(`ССЫЛКА НЕ ОТВЕЧАЕТ (${check.reason}) — запись пропущена`)
        brokenUrls.push(`${universityName} — "${p.program_name}": ${p.url} (${check.reason})`)
        continue
      }
      console.log(check.uncertain ? 'таймаут (оставляю с пометкой)' : `OK (${check.status})`)
      if (check.uncertain) {
        p.cons_ru = [...(p.cons_ru ?? []), 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом']
      }

      const key = universityName.toLowerCase()
      let uniId = existingUnisByName.get(key)
      if (!uniId) {
        const pending = [...newUniInserts.entries()].find(([, v]) => v.name.toLowerCase() === key)
        if (pending) {
          uniId = pending[0]
        } else {
          uniId = randomUUID()
          newUniInserts.set(uniId, {
            name: universityName,
            city: universityCity ?? '',
            website: universityWebsite ?? '',
            ranking_qs: universityRankingQs ?? null,
          })
        }
      }
      if (!writtenUniIds.has(uniId) && newUniInserts.has(uniId)) {
        appendFileSync(outPath, universityInsertSql(uniId, newUniInserts.get(uniId), COUNTRY_CODE), 'utf8')
        writtenUniIds.add(uniId)
      }

      appendFileSync(outPath, programInsertSql({ universityId: uniId, field, ...p }), 'utf8')
      programCount++
    }
  }

  if (FROM_FILE) {
    const preClassified = JSON.parse(readFileSync(new URL(FROM_FILE, `file://${process.cwd()}/`), 'utf8'))
    for (const [uniName, classified] of Object.entries(preClassified)) {
      const uni = universities.find((u) => u.name === uniName)
      if (!uni) {
        console.log(`  ПРОПУЩЕНО: вуз "${uniName}" не найден в базе для страны ${COUNTRY_CODE}`)
        continue
      }
      console.log(`  ${uni.name} (из файла, ${classified.length} кандидатов)`)
      for (const item of classified) {
        process.stdout.write(`    детали "${item.name}"... `)
        try {
          const { programs, usage } = await fetchProgramDetails(uni, item)
          totalUsage.input_tokens += usage.input_tokens ?? 0
          totalUsage.output_tokens += usage.output_tokens ?? 0
          console.log('получено')
          await ingestPrograms(programs, uni.name, uni.city, uni.website, uni.ranking_qs, item.field)
        } catch (e) {
          console.log(`ОШИБКА: ${e.message}`)
          errors.push(`${uni.name} / "${item.name}": ${e.message}`)
        }
        await sleep(SLEEP_MS)
      }
    }
  } else if (COMPREHENSIVE) {
    const onlyNames = args['only-university'] ? args['only-university'].split(',').map((s) => s.trim().toLowerCase()) : null
    const targetUnis = onlyNames
      ? universities.filter((u) => onlyNames.some((n) => u.name.toLowerCase().includes(n)))
      : universities

    for (const uni of targetUnis) {
      console.log(`  ${uni.name}`)
      const alreadyKnownNames = existingPrograms.filter((p) => p.university === uni.name).map((p) => p.name)

      // Шаг 1: перечислить
      process.stdout.write(`    перечисляю программы... `)
      let rawList
      try {
        const { programs, usage } = await enumerateUniversityPrograms(uni)
        totalUsage.input_tokens += usage.input_tokens ?? 0
        totalUsage.output_tokens += usage.output_tokens ?? 0
        rawList = programs.filter((p) => p?.name && p?.url)
        console.log(`нашёл ${rawList.length}`)
      } catch (e) {
        console.log(`ОШИБКА: ${e.message}`)
        errors.push(`${uni.name} (перечисление): ${e.message}`)
        continue
      }
      if (!rawList.length) continue

      // Шаг 2: классифицировать (без поиска)
      process.stdout.write(`    классифицирую... `)
      let classified
      try {
        const { items, usage } = await classifyPrograms(uni, rawList, alreadyKnownNames)
        totalUsage.input_tokens += usage.input_tokens ?? 0
        totalUsage.output_tokens += usage.output_tokens ?? 0
        classified = items.filter((p) => p?.field && ALL_FIELDS.includes(p.field))
        console.log(`подходят: ${classified.length} из ${rawList.length}`)
      } catch (e) {
        console.log(`ОШИБКА: ${e.message}`)
        errors.push(`${uni.name} (классификация): ${e.message}`)
        continue
      }

      // Шаг 3: детали по каждой подошедшей
      for (const item of classified) {
        process.stdout.write(`    детали "${item.name}"... `)
        try {
          const { programs, usage } = await fetchProgramDetails(uni, item)
          totalUsage.input_tokens += usage.input_tokens ?? 0
          totalUsage.output_tokens += usage.output_tokens ?? 0
          console.log('получено')
          await ingestPrograms(programs, uni.name, uni.city, uni.website, uni.ranking_qs, item.field)
        } catch (e) {
          console.log(`ОШИБКА: ${e.message}`)
          errors.push(`${uni.name} / "${item.name}": ${e.message}`)
        }
        await sleep(SLEEP_MS)
      }
    }
  } else {
    for (const field of FIELDS) {
      process.stdout.write(`  ${field}... `)
      try {
        const { programs, usage } = await researchField(field, existingPrograms)
        totalUsage.input_tokens += usage.input_tokens ?? 0
        totalUsage.output_tokens += usage.output_tokens ?? 0
        console.log(`нашёл ${programs.length}, проверяю ссылки...`)
        for (const p of programs) {
          await ingestPrograms([p], p.university_name, p.university_city, p.university_website, p.university_ranking_qs, field)
        }
      } catch (e) {
        console.log('ОШИБКА')
        errors.push(`${field}: ${e.message}`)
      }
      await sleep(SLEEP_MS)
    }
  }

  if (errors.length || brokenUrls.length) {
    let footer = ''
    if (errors.length) footer += `\n-- Предупреждения при сборе:\n${errors.map((e) => `-- - ${e}`).join('\n')}\n`
    if (brokenUrls.length) footer += `\n-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):\n${brokenUrls.map((e) => `-- - ${e}`).join('\n')}\n`
    appendFileSync(outPath, footer, 'utf8')
  }

  console.log(`\nГотово: ${newUniInserts.size} новых вузов, ${programCount} программ.`)
  if (brokenUrls.length) console.log(`Отброшено из-за нерабочих ссылок: ${brokenUrls.length}`)
  console.log(`Токенов потрачено: ${totalUsage.input_tokens} input / ${totalUsage.output_tokens} output`)
  console.log(`Файл: ${outPath.pathname.replace(/^\//, '')}`)
  if (errors.length) console.log(`\nПредупреждения (${errors.length}):`, errors)
  if (brokenUrls.length) console.log(`\nНерабочие ссылки (${brokenUrls.length}):`, brokenUrls)
}

main().catch((e) => {
  console.error('Фатальная ошибка:', e)
  process.exit(1)
})
