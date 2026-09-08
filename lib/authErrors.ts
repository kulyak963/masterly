// Человеческие сообщения вместо сырых английских ошибок Supabase.
//
// Появилось 2026-09-08, когда выяснилось, что регистрация не работает:
// встроенная почта Supabase отдаёт всего 2 письма в час и не доставляет
// письма на адреса вне команды проекта. Пользователь при этом видел в
// окне alert английское "email rate limit exceeded" и не понимал ничего.
//
// Постоянное решение — свой SMTP в настройках Supabase; этот файл лишь
// делает отказ понятным, пока он не настроен.

export function humanAuthError(e: unknown): string {
  const raw = (e as { message?: string })?.message ?? ''
  const code = (e as { code?: string })?.code ?? ''
  const m = raw.toLowerCase()

  if (m.includes('rate limit') || code === 'over_email_send_rate_limit') {
    return 'Слишком много писем за короткое время — почтовый сервис нас притормозил. Подожди примерно час и попробуй снова. Если ты уже создавал аккаунт, просто войди.'
  }
  if (m.includes('already registered') || m.includes('already been registered') || code === 'user_already_exists') {
    return 'На эту почту аккаунт уже есть. Войди с паролем — или восстанови его, если забыл.'
  }
  if (m.includes('invalid') && m.includes('email')) {
    return 'Проверь адрес почты — он выглядит некорректно.'
  }
  if (m.includes('password') && (m.includes('short') || m.includes('least'))) {
    return 'Пароль слишком короткий — нужно минимум 8 символов.'
  }
  if (m.includes('captcha')) {
    return 'Не прошла проверка «я не робот». Обнови страницу и попробуй ещё раз.'
  }
  if (m.includes('invalid login credentials')) {
    return 'Неверная почта или пароль.'
  }
  if (m.includes('email not confirmed')) {
    return 'Почта ещё не подтверждена. Проверь входящие и папку «Спам».'
  }
  if (m.includes('failed to fetch') || m.includes('network')) {
    return 'Не получилось связаться с сервером. Проверь интернет и попробуй снова.'
  }

  return 'Не получилось создать аккаунт. Попробуй ещё раз, а если повторится — напиши нам на support@mastersly.ru.'
}
