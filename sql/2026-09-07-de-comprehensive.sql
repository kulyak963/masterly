-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
-- Дата: 2026-09-07
--
-- В отличие от app/api/admin/seed-programs/route.ts (тот просит модель
-- "вспомнить" данные без проверки), этот инструмент реально ищет в
-- интернете через Anthropic web_search и цитирует официальные страницы.
-- Тем не менее verified=true проставлено только когда тюишн+дедлайн+язык
-- подтверждены на ОДНОЙ официальной странице явно для не-ЕС ставки —
-- остальное verified=false, хоть цифры и реальные, с официальных сайтов.
-- Источник и обоснование verified для каждой программы — в комментарии
-- прямо над её INSERT (source_note_ru от модели, дословно).
--
-- Файл пишется ПО ХОДУ СБОРА (не одним куском в конце) — если прогон
-- прервётся на середине, всё найденное до этого момента уже сохранено.
--
-- НЕ запущено в Supabase — выполнить вручную через SQL Editor, или
-- node scripts/run-sql.mjs sql/<этот файл>.sql --apply

-- Дедлайн 15 мая и средний балл 2.5 подтверждены на med.lmu.de; плата ~€6 400 и IELTS 6.0 — по сторонним агрегаторам (DAAD, mastersportal, expatrio), поэтому verified=false. Точный IELTS-min и точная сумма для не-ЕС на одной странице med.lmu.de явно не зафиксированы в выдаче — требуется ручная проверка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'Epidemiology (M.Sc.)', 'Medicine', 'English', 24, 6400,
  'ai', current_date,
  5, 15, 6, 2.5, 'https://www.med.lmu.de/en/study/masters-of-science/epidemiology/',
  array['Deutschlandstipendium', 'LMU Excellence Scholarship'],
  'Магистерская программа LMU Munich по эпидемиологии (Pettenkofer School of Public Health), 4 семестра, на английском. Это одна из немногих программ LMU с платой для иностранцев.',
  array['Престижный университет и школа общественного здоровья Pettenkofer', 'Программа полностью на английском, международная среда', 'Сильная исследовательская база и связи с клиникой Großhadern'],
  array['Платная для не-ЕС/ЕЭЗ студентов (около €6 400 за всю программу) — нужно уточнять актуальную сумму на сайте', 'Жёсткий дедлайн 15 мая и требуется средний балл не ниже 2.5 по немецкой шкале', 'Не подтверждено единым числом IELTS-min и плата в одном источнике — данные собраны с нескольких страниц факультета'],
  false, null
);
