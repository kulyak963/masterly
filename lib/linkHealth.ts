// Здоровье ссылки на программу (url_status/url_checked_at, см.
// sql/2026-09-08-tuition-truth.sql и scripts/check-links.mjs). Первый
// полный прогон 2026-09-08 нашёл 348 из 1405 битых ссылок (25%) — пока
// они не заменены (это отдельная исследовательская задача, не быстрый
// фикс), интерфейс не должен вести пользователя на мёртвую страницу
// без предупреждения.
export function isDeadLink(urlStatus: number | null | undefined): boolean {
  return urlStatus != null && (urlStatus === 0 || urlStatus < 0 || urlStatus >= 400)
}
