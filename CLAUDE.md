@AGENTS.md

# MASTERSLY — актуальный контекст (обновлено 2026-08-24)

> Персональный гид поступления в европейскую магистратуру для русскоязычных студентов.
> Live: mastersly.ru (Cloudflare → Vercel) · Repo: github.com/kulyak963/masterly
> Stack: Next.js 16 (Turbopack), TypeScript, Supabase, Vercel

Локальная папка проекта: `C:\Users\kulya\OneDrive\Desktop\masterly-main`
Git настроен и привязан к origin, идентичен origin/main. Идентичность коммитов:
`Denis <kulyak963@gmail.com>` (настроена глобально).

---

## Бренд

Название везде **Mastersly** (с "s" перед "ly") — не Masterly. Переименовано во всех
файлах, .ics-экспортах, package.json. Не тронуты только внутренние технические
идентификаторы без видимости пользователю: localStorage-ключ `masterly_profile`,
UID-домен `@masterly.app` в календарных событиях.

## Дизайн-система (редизайн 2026-08-23/24)

Старая связка Geist + Instrument Serif была заменена — читалась как «дефолтный ИИ
вайбкодинг». Новая:

```typescript
const sans  = "'Manrope', sans-serif"      // основной текст
const serif = "'Fraunces', serif"          // заголовки — ЖИРНЫЕ (700-800), НЕ italic
const mono  = "'Space Mono', monospace"    // лейблы, обычно fontWeight:700
```

Подключены через `next/font/google` в `app/layout.tsx` (self-hosted) + резервный
`@import` в файлах, где он уже был (`login/page.tsx`, `GanttTimeline.tsx`).

**Правило заголовков**: крупные h1/h2 — `fontStyle:'normal', fontWeight:700-800`.
Мелкие акцентные цифры в таблицах/списках (score программы и т.п.) можно оставлять
`italic` — это уместный акцент, не путать с проблемой «тонкого курсива на всё».

### Фото городов — слайдшоу, не статика

На hero (`app/page.tsx` step 0), верхнем баннере шагов 1-7 (`Shell`), экране
результата (step 8) и на `login/page.tsx` — бесшовный CSS-кроссфейд из реальных
фото Unsplash (Париж, Берлин, Прага, Амстердам, Вена), через компонент
`PhotoCycler` + keyframes `cycleFade`/`cycleZoom`. Чистый CSS, без JS-таймеров.

**Важные уроки по картинкам (не наступать снова):**
- Используются ДВА набора: `CITY_SHOTS` (440px, для мелких превью — филмстрип,
  карточки стран) и `CITY_LARGE` (1100px, q=56, для fullscreen фонов). Раньше был
  один баг: hero использовал 440px-превью растянутыми на весь экран → жуткий блюр.
  **Никогда не переиспользуй маленький набор для fullscreen фона.**
- URL в `page.tsx` и `login/page.tsx` намеренно идентичны — браузер кэширует один
  раз и переиспользует между страницами.
- Кол-во фото в ротации намеренно урезано (5 шт для fullscreen) ради веса —
  ~60-120КБ/фото. Не увеличивать без причины.
- Кол-во слайдов в наборе завязано на % в keyframes (`100/N`). Если меняешь длину
  массива — обязательно пересчитай проценты в `cycleFade`/`cycleZoom`.
- Картинки хотлинкаются напрямую с `images.unsplash.com` — это НЕ грузит наш
  Vercel/сервер, трафик идёт у пользователя в браузере напрямую с CDN Unsplash.

---

## Известные проблемы (актуально)

### 1. AI-вердикт (кнопка «Персональный анализ») не работает
`app/api/verdict/route.ts` и `app/dashboard/fill_db.py` бьют не в официальный
`api.anthropic.com`, а в сторонний прокси `https://api.vibecode-claude.online/v1`
с несуществующими именами моделей (`claude-opus-4.7`, `claude-sonnet-4.6`).
Прямая проверка дала `403 insufficient_credits` — ключ прокси рабочий, но баланс
пуст. Фикс: либо пополнить тот аккаунт, либо переключить оба файла на
официальный API + реальный ключ с console.anthropic.com.

### 2. Утечка секретов в fill_db.py
`app/dashboard/fill_db.py` содержит захардкоженный Supabase-ключ и
Anthropic-подобный ключ прямым текстом, закоммичено в git-историю (репозиторий
доступен на GitHub). Ключ стоит ротировать на console.anthropic.com и переписать
файл на чтение из переменных окружения.

### 3. Дашборд не проверен визуально после редизайна
Все шрифты/жирность в `dashboard/page.tsx`, `Roadmap.tsx`, `GanttTimeline.tsx`,
`Timeline.tsx`, `CalendarExportModal.tsx` обновлены и проходят `tsc`/`build`, но
живьём в браузере не смотрели — `/dashboard` требует реальный Google-логин,
который агент проходить не должен. Стоит один раз глазами свериться после логина.

### 4. VS Code TS-ошибки — не блокируют сборку (как и раньше)

---

## Локальный дев-сервер

`.env.local` заполнен (Supabase URL/anon key + Anthropic-ключ прокси).
`.claude/launch.json` в `C:\Users\kulya\.claude\` настроен на
`npm --prefix <путь> run dev`, порт 3000.

```bash
npm install         # если node_modules нет
npm run dev          # http://localhost:3000
npm run build         # прод-сборка, обязательно проверять перед пушем
npx tsc --noEmit      # быстрый тайпчек без полной сборки
```

При смене шрифтов/next-font иногда залипает кэш Turbopack — если после правки
шрифтов что-то не применяется, `rm -rf .next` и рестарт дев-сервера.

## Деплой

```bash
git add <файлы>              # НЕ git add -A — проверяй что стейджишь
git commit -m "..."
git push origin main          # триггерит автодеплой на Vercel через GitHub-интеграцию
```

Vercel CLI на машине не установлен — деплой только через push, других путей нет.
