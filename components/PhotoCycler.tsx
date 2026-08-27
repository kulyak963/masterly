/**
 * Бесшовный кроссфейд-слайдшоу из фото городов — общий компонент.
 *
 * Раньше `app/page.tsx` и `app/login/page.tsx` каждый писали свою копию этой
 * функции (плюс свой список фото). URL-адреса были специально одинаковые —
 * так браузер грузит каждую картинку один раз и переиспользует между
 * страницами. Теперь это гарантировано одним общим списком, а не ручным
 * копированием.
 *
 * Анимации `cycleFade`/`cycleZoom` и класс `.cycle-layer` должны быть
 * определены в глобальном `<style>` страницы, которая рендерит этот
 * компонент (см. `CYCLER_KEYFRAMES_CSS` ниже — вставь его в свой CSS-блок).
 */

/** Крупные фоны (1-2200px) — для fullscreen hero/баннеров, не мылят на десктопе. */
export const CITY_LARGE = [
  { img: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=2200&q=58' },
  { img: 'https://images.unsplash.com/photo-1599946347371-68eb71b16afc?auto=format&fit=crop&w=2200&q=58' },
  { img: 'https://images.unsplash.com/photo-1564511287568-54483b52a35e?auto=format&fit=crop&w=2200&q=58' },
  { img: 'https://images.unsplash.com/photo-1584003564911-a7a321c84e1c?auto=format&fit=crop&w=2200&q=58' },
  { img: 'https://images.unsplash.com/photo-1573599852326-2d4da0bbe613?auto=format&fit=crop&w=2200&q=58' },
]

/** Мелкие превью (440px) — филмстрип, карточки стран. Не растягивать на весь экран. */
export const CITY_SHOTS = [
  { c: 'fr', city: 'Париж', img: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=440&q=65' },
  { c: 'de', city: 'Берлин', img: 'https://images.unsplash.com/photo-1599946347371-68eb71b16afc?auto=format&fit=crop&w=440&q=65' },
  { c: 'cz', city: 'Прага', img: 'https://images.unsplash.com/photo-1564511287568-54483b52a35e?auto=format&fit=crop&w=440&q=65' },
  { c: 'nl', city: 'Амстердам', img: 'https://images.unsplash.com/photo-1584003564911-a7a321c84e1c?auto=format&fit=crop&w=440&q=65' },
  { c: 'at', city: 'Вена', img: 'https://images.unsplash.com/photo-1573599852326-2d4da0bbe613?auto=format&fit=crop&w=440&q=65' },
  { c: 'se', city: 'Стокгольм', img: 'https://images.unsplash.com/photo-1630772063386-f363836989cc?auto=format&fit=crop&w=440&q=65' },
  { c: 'ch', city: 'Цюрих', img: 'https://images.unsplash.com/photo-1731879787307-99c435ac06de?auto=format&fit=crop&w=440&q=65' },
  { c: 'fi', city: 'Хельсинки', img: 'https://images.unsplash.com/photo-1538332576228-eb5b4c4de6f5?auto=format&fit=crop&w=440&q=65' },
]

export const CYCLER_KEYFRAMES_CSS = `
@keyframes cycleFade{0%{opacity:0}3%{opacity:1}17%{opacity:1}20%{opacity:0}100%{opacity:0}}
@keyframes cycleZoom{0%{transform:scale(1.02)}20%{transform:scale(1.08)}100%{transform:scale(1.08)}}
.cycle-layer{position:absolute;inset:0;background-size:cover;background-position:center;will-change:opacity,transform}
`

const CYCLE_SLOT = 6 // секунд на фото

export default function PhotoCycler({
  images = CITY_LARGE,
  offset = 0,
  position = 'absolute',
}: {
  images?: { img: string; city?: string }[]
  offset?: number
  position?: 'absolute' | 'fixed'
}) {
  const total = images.length * CYCLE_SLOT
  return (
    <div style={{ position, inset: 0, overflow: 'hidden' }}>
      {images.map((im, i) => (
        <div
          key={i}
          className="cycle-layer"
          style={{
            backgroundImage: `url(${im.img})`,
            animation: `cycleFade ${total}s ease-in-out infinite, cycleZoom ${total}s ease-out infinite`,
            animationDelay: `${-((i + offset) % images.length) * CYCLE_SLOT}s`,
          }}
        />
      ))}
    </div>
  )
}
