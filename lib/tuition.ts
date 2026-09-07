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
