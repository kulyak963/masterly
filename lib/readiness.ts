// Общая формула "готовности к поступлению" — общий профильный скор
// (не привязан к конкретной программе, см. calcScore в app/dashboard/
// page.tsx для того — это отдельная, легитимно другая метрика "шанс
// именно на эту программу").
//
// Раньше жила в двух местах с разными версиями: на лендинге (app/page.tsx)
// оставалась старая формула с двумя безусловными константами (+10 за
// 2+ страны, +15 просто так — 25 очков из воздуха), из-за которых
// минимум для самого слабого профиля был ~44%, а максимум ~93% —
// цифра физически не могла сказать "ты не готов", даже когда это
// правда, и не менялась осмысленно от реальных действий. В дашборде эти
// константы кто-то уже убрал и добавил направление магистратуры как
// сигнал, но лендинг не тронули — один и тот же профиль показывал 77%
// на лендинге и 55% в кабинете (см. аудит продукта 2026-09-07).
export interface ReadinessProfile {
  gpa: number
  ielts: number
  work: string
  master_direction?: string
}

export function readinessScore(p: ReadinessProfile): number {
  const gpaC = p.gpa >= 4.7 ? 30 : p.gpa >= 4.3 ? 24 : p.gpa >= 4.0 ? 17 : p.gpa >= 3.5 ? 9 : 2
  const langC = p.ielts >= 7.5 ? 28 : p.ielts >= 7.0 ? 24 : p.ielts >= 6.5 ? 18 : p.ielts >= 6.0 ? 10 : 2
  const workC = p.work === 'yes' ? 20 : p.work === 'some' ? 12 : 4
  const dirC = p.master_direction === 'same' ? 8 : p.master_direction === 'related' ? 3 : p.master_direction === 'change' ? -6 : 0
  return Math.max(4, Math.min(96, Math.round(gpaC + langC + workC + dirC)))
}
