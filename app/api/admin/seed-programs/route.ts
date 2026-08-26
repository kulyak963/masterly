import { NextRequest, NextResponse } from 'next/server'
import { askAI, extractJson } from '../../../../lib/ai'
import { getSupabaseAdmin } from '../../../../lib/supabaseAdmin'

// Vercel Cron only ever calls GET. maxDuration is kept conservative (60s) so
// this works even on the Hobby plan — the time budget below stops the loop
// before hitting it, rather than relying on the platform to kill it cleanly.
export const maxDuration = 60
const TIME_BUDGET_MS = 50_000
const SLEEP_BETWEEN_CALLS_MS = 1500

const COUNTRIES: [string, string][] = [
  ['de', 'Germany'], ['nl', 'Netherlands'], ['se', 'Sweden'],
  ['fi', 'Finland'], ['ch', 'Switzerland'], ['fr', 'France'],
  ['at', 'Austria'], ['cz', 'Czech Republic'], ['dk', 'Denmark'],
  ['be', 'Belgium'], ['ie', 'Ireland'], ['it', 'Italy'],
  ['es', 'Spain'], ['pt', 'Portugal'], ['no', 'Norway'],
  ['pl', 'Poland'], ['hu', 'Hungary'], ['ee', 'Estonia'],
  ['lt', 'Lithuania'], ['lv', 'Latvia'],
]

const FIELDS = [
  'Computer Science', 'Artificial Intelligence', 'Data Science',
  'Cybersecurity', 'Business Analytics', 'Robotics',
  'Human-Computer Interaction', 'Computational Engineering',
]

const PROMPT = (field: string, country: string) => `Fill a database of English-taught master's programs in ${field} in ${country}.

Return 3-5 REAL programs you are highly confident about. Skip any program you are unsure of.

Return ONLY a JSON array, no markdown, no explanation:

[
  {
    "university_name": "Official university name in English",
    "university_city": "City",
    "university_website": "https://university.edu",
    "ranking_qs": 150,
    "program_name": "Official program name",
    "duration_months": 24,
    "tuition_eur": 0,
    "deadline_month": 1,
    "deadline_day": 15,
    "ielts_min": 6.5,
    "program_url": "https://link-to-program-admissions-page",
    "scholarships": ["DAAD", "Erasmus+"],
    "summary": "2-3 предложения о программе на русском языке.",
    "pros": ["плюс 1", "плюс 2", "плюс 3"],
    "cons": ["минус 1", "минус 2"]
  }
]

Rules:
- tuition_eur: 0 if free, annual EUR cost for non-EU if paid
- deadline_month/day: typical autumn intake deadline. Guess if unsure.
- ranking_qs: integer, null if truly unknown
- program_url: direct admissions link. Empty string "" if unsure — do NOT invent URLs
- scholarships: only major well-known ones (DAAD, SI, Holland Scholarship, Eiffel, Erasmus+)
- summary/pros/cons: in Russian
- Skip programs with no English-taught option`

interface AiProgram {
  university_name: string
  university_city?: string
  university_website?: string
  ranking_qs?: number | null
  program_name: string
  duration_months?: number
  tuition_eur?: number
  deadline_month?: number
  deadline_day?: number
  ielts_min?: number
  program_url?: string
  scholarships?: string[]
  summary?: string
  pros?: string[]
  cons?: string[]
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms))

async function alreadyExists(countryCode: string, field: string): Promise<boolean> {
  const db = getSupabaseAdmin()
  const { data: unis } = await db
    .from('universities')
    .select('id')
    .eq('country', countryCode)
  if (!unis?.length) return false

  const { count } = await db
    .from('programs')
    .select('id', { count: 'exact', head: true })
    .eq('field', field)
    .in('university_id', unis.map((u) => u.id))
  return (count ?? 0) > 0
}

async function saveProgram(countryCode: string, field: string, prog: AiProgram): Promise<boolean> {
  const db = getSupabaseAdmin()
  let uniId: string
  const { data: existingUni } = await db
    .from('universities')
    .select('id')
    .eq('name', prog.university_name)
    .maybeSingle()

  if (existingUni) {
    uniId = existingUni.id
  } else {
    const { data: newUni, error } = await db
      .from('universities')
      .insert({
        name: prog.university_name,
        country: countryCode,
        city: prog.university_city ?? '',
        website: prog.university_website ?? '',
        ranking_qs: prog.ranking_qs ?? null,
      })
      .select('id')
      .single()
    if (error || !newUni) throw error ?? new Error('Failed to insert university')
    uniId = newUni.id
  }

  const { data: existingProgram } = await db
    .from('programs')
    .select('id')
    .eq('name', prog.program_name)
    .eq('university_id', uniId)
    .maybeSingle()
  if (existingProgram) return false // уже есть

  const { error } = await db.from('programs').insert({
    university_id: uniId,
    name: prog.program_name,
    field,
    language: 'English',
    duration_months: prog.duration_months ?? 24,
    tuition_eur: prog.tuition_eur ?? 0,
    deadline_month: prog.deadline_month ?? 1,
    deadline_day: prog.deadline_day ?? 15,
    ielts_min: prog.ielts_min ?? 6.5,
    gpa_min: null, // не просим — ненадёжно
    url: prog.program_url ?? '',
    scholarships: prog.scholarships ?? [],
    summary: prog.summary ?? '',
    pros: prog.pros ?? [],
    cons: prog.cons ?? [],
    acceptance_rate: null, // не просим — галлюцинация
    avg_salary_after: null, // не просим — галлюцинация
  })
  if (error) throw error
  return true
}

export async function GET(req: NextRequest) {
  const authHeader = req.headers.get('authorization')
  if (authHeader !== `Bearer ${process.env.CRON_SECRET}`) {
    return NextResponse.json({ error: 'unauthorized' }, { status: 401 })
  }

  const { searchParams } = new URL(req.url)
  const onlyCountry = searchParams.get('country')
  const onlyField = searchParams.get('field')

  const combos = onlyCountry || onlyField
    ? COUNTRIES.filter(([c]) => !onlyCountry || c === onlyCountry).flatMap((c) =>
        FIELDS.filter((f) => !onlyField || f === onlyField).map((f) => [c, f] as const)
      )
    : COUNTRIES.flatMap((c) => FIELDS.map((f) => [c, f] as const))

  const start = Date.now()
  let added = 0
  let skipped = 0
  const errors: string[] = []
  let stoppedEarly = false

  for (const [[countryCode, countryName], field] of combos) {
    if (Date.now() - start > TIME_BUDGET_MS) {
      stoppedEarly = true
      break
    }

    try {
      if (await alreadyExists(countryCode, field)) {
        skipped++
        continue
      }

      const text = await askAI(PROMPT(field, countryName), { maxTokens: 3000 })
      const programs = extractJson<AiProgram[]>(text)

      for (const prog of programs) {
        if (await saveProgram(countryCode, field, prog)) added++
      }
      await sleep(SLEEP_BETWEEN_CALLS_MS)
    } catch (e: any) {
      errors.push(`${field}/${countryCode}: ${e?.message ?? String(e)}`)
    }
  }

  return NextResponse.json({ added, skipped, errors, stoppedEarly, tookMs: Date.now() - start })
}
