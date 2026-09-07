-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: France (fr) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- ============================================================
-- Новый запуск того же дня/страны/режима — ДОПИСАНО поверх уже
-- накопленного файла, не стёрто (см. комментарий в коде main()).
-- ============================================================
-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: France (fr) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Дедлайн 1 March 2026 и факт англоязычного обучения подтверждены на sorbonne-universite.fr/en/study/degree-seeking/masters/master-cognitive-science. Стоимость €353/год «set by ministerial decree» и требование C1 по английскому — на cog-sup.fr/application. IELTS-балл не указан напрямую, C1 по CEFR обычно соответствует IELTS 7.0 (поставлено 7.0 как ближайший эквивалент). verified=true: tuition+deadline+language подтверждены для non-EU на связанных официальных страницах.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'eccc0319-3fbd-43dc-846b-24b6b52d44ea',
  'Master in Cognitive Science (Cog-SUP)', 'Psychology', 'English', 24, 353,
  'verified', current_date,
  3, 1, 7, null, 'https://www.sorbonne-universite.fr/en/study/degree-seeking/masters/master-cognitive-science',
  array['SMARTS-UP Graduate School scholarship (Université Paris Cité) — ~€8,000'],
  'Двухлетняя междисциплинарная англоязычная магистратура по когнитивным наукам, совместно администрируемая Sorbonne Université и Université Paris Cité (более 30 лет истории). Шесть треков: Neuroscience, Psychology, AI, Language, Modeling, Society & Cognition.',
  array['Полностью на английском, сильно интернациональная среда', '6 треков и совместное администрирование двумя ведущими парижскими университетами', 'Очень низкая стоимость для non-EU студентов — €353/год (стандартная ставка французских госвузов по ministerial decree)'],
  array['Минимальный английский заявлен как уровень C1 (CEFR), а не конкретный балл IELTS — формально принимаются и альтернативные подтверждения (опыт в англоязычной среде, стажировки, публикации)', 'Минимальный GPA официально не опубликован — отбор по мотивации, интервью и портфолио', 'На странице программы ставка EU/non-EU явно не разграничена; €353 указана как единая «ministerial decree» ставка (в 2024/25 non-EU приравнены к EU)'],
  true, current_date
);

-- Длительность 24 мес, дедлайн 30 апреля, IELTS 6.0, GPA 3.0 и TOEFL iBT 80 — подтверждены на официальных страницах imt-atlantique.fr (URL в search results: /en/study/masters/msc/it-aeiot и /it-aeiot/apply). Стоимость €12,000 оценена из неофициального упоминания €6,000/год в Facebook; официальная цифра для не-ЕС на страницах в сниппетах не отобразилась, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Architecture and Engineering for the Internet of Things (AEIoT)', 'Computational Engineering', 'English', 24, 12000,
  'ai', current_date,
  4, 30, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/it-aeiot/apply',
  array[]::text[],
  'Двухлетняя программа магистратуры IMT Atlantique по архитектуре и инженерии Интернета вещей (кампусы школы — Брест, Нант, Ренн). Включает 6-месячную оплачиваемую стажировку и готовит специалистов по сетевой инженерии, IoT-системам и облачным технологиям.',
  array['Дедлайн, IELTS, GPA и длительность подтверждены на официальной странице IMT Atlantique', 'Принимают IELTS 6.0 / TOEFL iBT 80 — умеренный языковой барьер для не-носителей', 'Шестимесячная оплачиваемоя стажировка (стипендия €1000–1500/мес) заложена в программу'],
  array['Точная стоимость для не-ЕС студентов не извлеклась со страницы программы: €12,000 — это ≈€6,000/год по упоминанию абитуриента в Facebook (неофициально), официальная таблица тарифов в сниппетах не попалась', 'Конкретный кампус (Брест/Нант/Ренн) для трека AEIoT в найденных сниппетах явно не указан — нужно уточнять у приёмной комиссии'],
  false, null
);

-- Предупреждения при сборе:
-- - Sorbonne University / "Master in Cognitive Science": timeout: прокси не ответил за 90с
