import { Unbounded } from 'next/font/google'

/**
 * Крупный дисплейный шрифт для больших заголовков/чисел — тот же приём,
 * что задал hero на лендинге (см. `app/page.tsx`). Один общий вызов
 * next/font/google вместо повторного объявления в каждом файле.
 */
export const displayFont = Unbounded({
  subsets: ['latin', 'cyrillic'],
  weight: ['700', '800', '900'],
  display: 'swap',
})
