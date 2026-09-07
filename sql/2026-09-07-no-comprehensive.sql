-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Norway (no) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: tuition (204 000 NOK), deadline (1 декабря) и IELTS (6.5) подтверждены, но на РАЗНЫХ страницах UiO — таблица стоимости, страница поступления на магистратуру и llm-guide.com. На одной и той же странице программы pubint-master все три пункта единым блоком не найдены. Курс NOK→EUR взят ≈11,7 (рыночный), поэтому точная сумма в EUR приблизительная.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Public International Law (Master)', 'Law', 'English', 18, 17436,
  'ai', current_date,
  12, 1, 6.5, null, 'https://www.uio.no/english/studies/programmes/pubint-master/',
  array[]::text[],
  'Магистерская программа UiO по публичному международному праву длится 1,5 года (90 ECTS), ориентирована на глобальное управление и права человека, ведётся на английском. Для граждан стран вне ЕС/ЕЭЗ обучение платное — около 204 000 NOK за всю программу (≈ 17 400 EUR).',
  array['UiO — топовый норвежский вуз с сильной школой международного права', 'Программа полностью на английском, без требования норвежского языка', 'EU/EEA граждане учатся бесплатно (полезно для сравнения, но не для нашей аудитории)'],
  array['Длительность на самом деле 18 месяцев, а не 24 (уточнено по официальной странице UiO)', 'Точные требования по GPA на англоязычной странице программы явно не указаны — оставлено null', 'Высокая стоимость жизни в Осло (~1500–2200 EUR/мес по данным study.eu)'],
  false, null
);

-- URL программы подтвержден (uio.no/english/studies/programmes/ictlaw-master/), длительность 1,5 года и 90 ECTS указаны в его сниппете. Дедлайн 1 декабря взят со страницы UiO master''s admission (https://www.uio.no/english/studies/admission/master/) — стандартный для не-ЕС магистров UiO. IELTS 6.5 указан на LLM Guide и подтверждается общей политикой UiO English proficiency (минимум 6.0, для права обычно 6.5). Tuition 204 000 NOK (~18 500 EUR) — только из LLM Guide, официальная таблица UiO даёт диапазон по кредитам, но итоговую цифру для всей программы в сниппете не показала. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Information and Communication Technology Law (Master)', 'Law', 'English', 18, 18500,
  'ai', current_date,
  12, 1, 6.5, null, 'https://www.uio.no/english/studies/programmes/ictlaw-master/',
  array['Norwegian Quota Scheme (для граждан ряда развивающихся стран)', 'Faculty of Law стипендии для отдельных не-ЕС студентов'],
  'Магистерская программа Университета Осло по праву ИКТ длительностью 1,5 года (90 ECTS) с преподаванием на английском, охватывающая электронные коммуникации, интеллектуальную собственность, защиту данных и приватность. Для не-ЕС/ЕЭЗ студентов программа платная и требует подачи документов к 1 декабря.',
  array['Топовый европейский университет (#100-150 в мире) со специализацией именно в ICT-праве', 'Полностью на английском, степень Master of Laws (LL.M.)', 'Уникальная четырехмодульная структура (коммуникации, IP, privacy, e-commerce)'],
  array['Стоимость обучения (≈18500 EUR за всю программу по данным LLM Guide) — оценка из стороннего источника, на самой странице UiO актуальная цифра в сниппете не подтверждена', 'Срок 1,5 года короче стандартных 2 лет — меньше времени на стажировки', 'verified=false: точная сумма tuition, крайний срок (1 декабря) и IELTS 6.5 подтверждены из разных страниц UiO/LLM Guide, но не из одной официальной страницы программы'],
  false, null
);

-- Подтверждено: программа существует, страница https://www4.uib.no/en/programmes/master-of-laws-llm-programme-in-eu-and-eea-law-masters упоминает оплату для non-EU и неевропейский дедлайн 1 декабря (на странице application process для non-EU указано 1 декабря 2025 на набор August 2026). IELTS и точная сумма tuition в выдаче не найдены — IELTS взят по типичному требованию UiB (6.5), tuition оценён ~6400 EUR (≈NOK 70k) и помечен как непроверенный.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5c9a49e4-1981-439f-b69f-3f0916db7e99',
  'Master of Laws (LLM) in EU and EEA Law', 'Law', 'English', 18, 6400,
  'ai', current_date,
  12, 1, 6.5, null, 'https://www4.uib.no/en/programmes/master-of-laws-llm-programme-in-eu-and-eea-law-masters',
  array[]::text[],
  'Магистерская программа UiB по праву ЕС и ЕЭП — узкоспециализированный LLM на 90 ECTS (1,5 года), читается на английском; редкая экспертиза именно по EEA-праву, а не только EU.',
  array['Уникальная специализация на EEA Law (в дополнение к классическому EU Law)', 'Преподавание на английском, международный контент', 'Берген — доступная норвежская студенческая среда'],
  array['Точная стоимость для non-EU студентов не подтверждена в выдаче — цифра 6400 EUR является оценкой и может быть неточной', 'Дедлайн для non-EU жёсткий — 1 декабря (раньше, чем у EU/EEA кандидатов)'],
  false, null
);

-- Предупреждения при сборе:
-- - University of Oslo / "Maritime Law (Master)": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use, tool_use, tool_use]. Text: (empty)
