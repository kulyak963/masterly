-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Portugal (pt) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: официальная страница https://www.up.pt/portal/en/study/masters-degrees/courses/fpceup/22601/ подтверждена как реальная и описывает MPSI, но в сниппетах не указаны non-EU tuition, deadline и IELTS напрямую. Tuition взят из TopUniversities (3500 EUR international) — это агрегатор, а не официальный источник U.Porto. Дедлайн и IELTS — стандартные значения U.Porto, не специфичные для MPSI.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61de3ef5-03be-44ac-92c9-a0419af2dd62',
  'Master''s Degree in Psychology (MPSI)', 'Psychology', 'English', 24, 3500,
  'ai', current_date,
  4, 30, 6, null, 'https://www.up.pt/portal/en/study/masters-degrees/courses/fpceup/22601/',
  array[]::text[],
  'Магистерская программа по психологии в Университете Порту (FPCEUP) длительностью 2 года готовит профессиональных психологов. Программа аккредитована и предлагает исследовательские и клинические направления.',
  array['Аккредитованная программа в ведущем университете Португалии', 'Психология как профессиональная квалификация (MPSI), признаваемая в ЕС', 'Международная среда и сильная исследовательская база FPCEUP'],
  array['Не удалось подтвердить точную non-EU стоимость обучения с официальной страницы программы — использован агрегированный показатель TopUniversities (от 3500 EUR), а не прямая цифра U.Porto', 'Дедлайн 30 апреля — типичный для U.Porto (1-я фаза для международных студентов), но не подтверждён напрямую со страницы MPSI', 'IELTS 6.0 — стандартное требование U.Porto для не-EU, точный порог для MPSI не подтверждён'],
  false, null
);

-- Стоимость для non-EU (3500 EUR/год) подтверждена на странице программы и в официальном EDITAL PDF FPCEUP (EDITAL_FPCEUP_MTP_eng.pdf), длительность 24 месяца подтверждена в Sigarra. Дедлайн и точный IELTS не найдены на самой странице программы — они оценены по типичным требованиям U.Porto, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61de3ef5-03be-44ac-92c9-a0419af2dd62',
  'Master''s Degree in Psychology Themes', 'Psychology', 'English', 24, 7000,
  'ai', current_date,
  4, 30, 6, null, 'https://www.up.pt/portal/en/study/masters-degrees/courses/fpceup/822/',
  array[]::text[],
  'Магистерская программа по психологии в Университете Порту (FPCEUP) длительностью 4 семестра, ориентированная на специализацию в нескольких тематических областях психологии (нейрокогниция, психология развития, психология здоровья и др.). Для иностранных студентов (non-EU) стоимость составляет 3500 EUR в год, итого около 7000 EUR за всю программу.',
  array['Стоимость для non-EU значительно ниже, чем в большинстве англоязычных стран (3500 EUR/год)', 'Преподавание на английском языке, широкий выбор тематических специализаций внутри психологии', 'Порту — крупный студенческий город с умеренной стоимостью жизни'],
  array['Точный дедлайн подачи документов для иностранных студентов на странице программы не подтверждён (использован типичный для U.Porto апрельский дедлайн)', 'Минимальный балл IELTS 6.0 указан как оценка по общим требованиям U.Porto, а не напрямую на странице программы', 'Минимальный GPA не указан явно — оценка 3.0/4.0 приведена как разумное предположение'],
  false, null
);
