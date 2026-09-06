// Дедлайны большинства европейских программ на осенний интейк — январь-апрель
// того же года, что и старт учёбы (иногда стипендии — октябрь-ноябрь года
// перед стартом, но университетские дедлайны почти всегда в год старта).
// После апреля поступить на "эту осень" уже физически нельзя — приёмная
// кампания закрыта. Раньше анкета жёстко предлагала "2025/2026/2027" вне
// зависимости от реальной даты — при обращении в 2026-09 "Осень 2026"
// (помеченная "Оптимально") на самом деле уже год как закрыта.
export function soonestAdmissionYear(now: Date = new Date()): number {
  const y = now.getFullYear()
  const m = now.getMonth() + 1 // 1-12
  return m <= 4 ? y : y + 1
}

// profile.timeline хранится как '2026'/'2027'/... или 'later' ("пока не
// решил"). parseInt('later') === NaN — раньше это тихо падало на
// хардкоженный дефолт 2026, который к сентябрю 2026 уже в прошлом.
export function resolveAdmissionYear(timeline: string | null | undefined, now: Date = new Date()): number {
  const parsed = parseInt(timeline || '', 10)
  const soonest = soonestAdmissionYear(now)
  return Number.isFinite(parsed) && parsed >= soonest ? parsed : soonest
}
