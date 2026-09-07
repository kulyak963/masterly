// Единая логика показа стоимости — раньше `tuition_eur === 0` значило
// "Бесплатно" в трёх разных местах интерфейса, и после того как генератор
// начал писать null вместо угаданного нуля (см. аудит продукта 2026-09-07,
// scripts/research-programs.mjs) её пришлось бы чинить в трёх местах
// заново. Теперь "Бесплатно" пишется только когда цена НЕ ТОЛЬКО равна
// нулю, но и подтверждена (tuition_status='verified') — иначе честное
// "Стоимость уточняется", а не наугад посчитанная выгода.
export interface TuitionLike {
  tuition_eur: number | null
  tuition_status?: string | null
}

export function tuitionLabel(p: TuitionLike, locale: 'ru' = 'ru'): string {
  if (p.tuition_eur == null) return 'Стоимость уточняется'
  if (p.tuition_eur === 0) {
    return p.tuition_status === 'verified' ? 'Бесплатно' : 'Возможно бесплатно — уточняется'
  }
  return `€${p.tuition_eur.toLocaleString(locale === 'ru' ? 'ru-RU' : undefined)}/год`
}

// Неизвестная цена — не "дёшево" и не "дорого". Раньше null проходил как
// 0 через нестрогое сравнение (`null > budgetLimit` === false в JS), что
// тихо считало непроверенную стоимость помещающейся в любой бюджет.
export function isOverBudget(p: TuitionLike, budgetLimit: number): boolean {
  return p.tuition_eur != null && p.tuition_eur > budgetLimit
}

export function isWithinBudget(p: TuitionLike, budgetLimit: number): boolean {
  return p.tuition_eur != null && p.tuition_eur <= budgetLimit
}

export function isUnknownTuition(p: TuitionLike): boolean {
  return p.tuition_eur == null
}

// Три честных состояния вместо одного предупреждающего треугольника на
// каждой платной строке (см. аудит продукта 2026-09-07: раньше бюджет
// собирался в анкете и почти ни на что не влиял — "⚠" стоял почти
// везде, а предупреждение, которое везде, не читается нигде).
// 'fits' — реально укладывается. 'scholarship' — не укладывается, но у
// программы есть реальные стипендии в базе (может закрыть разницу) или
// цена ещё не подтверждена. 'over' — не укладывается и без известной
// стипендии рассчитывать не на что.
export type BudgetState = 'fits' | 'scholarship' | 'over'

export function budgetState(
  p: TuitionLike & { scholarships?: unknown },
  budgetLimit: number
): BudgetState {
  if (isWithinBudget(p, budgetLimit)) return 'fits'
  if (isUnknownTuition(p)) return 'scholarship'
  const hasScholarship = Array.isArray(p.scholarships) && p.scholarships.length > 0
  return hasScholarship ? 'scholarship' : 'over'
}
