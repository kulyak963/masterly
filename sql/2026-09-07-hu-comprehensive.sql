-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Hungary (hu) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Сроки (deadline 22 May 2026), tuition (12 000 EUR), язык (English), IELTS 5.5 и длительность (1 год / 2 семестра) подтверждены на официальной странице admission Semmelweis (https://semmelweis.hu/admission/programs/clinical-translational-medicine-msc/) и в Mastersportal (https://www.mastersportal.com/studies/478586/clinical-translational-medicine.html). verified=false, так как на странице admission не показано раздельной EU/non-EU ставки — указанная цена 12 000 EUR представлена как единая, а не подтверждённая отдельно для не-ЕС студентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b7db40e0-5888-4c3d-bac1-75a112b5ec11',
  'Clinical Translational Medicine (MSc)', 'Medicine', 'English', 12, 12000,
  'ai', current_date,
  5, 22, 5.5, null, 'https://semmelweis.hu/admission/programs/clinical-translational-medicine-msc/',
  array[]::text[],
  'Один год очного обучения на английском языке в Центре трансляционной медицины Semmelweis University (Будапешт). Программа практико-ориентированная, готовит специалистов на стыке клинической и лабораторной работы.',
  array['Преподавание и учебная среда полностью на английском', 'Совместная программа с Translational Medicine Foundation — сильная практическая база', 'Расположение в Будапеште, относительно низкие расходы на жизнь в ЕС'],
  array['На официальной странице admission Semmelweis не указано явное разделение tuition на EU/non-EU — единая цена 12 000 EUR показана без отдельной ставки для не-ЕС граждан, поэтому оценка для не-ЕС студентов может быть неточной', 'Высокая относительно венгерских программ стоимость обучения (~12 000 EUR за 1 год)', 'IELTS 5.5 — формально невысокий порог, но реальная академическая нагрузка требует уверенного английского'],
  false, null
);

-- verified=false: на известной странице course/813 явных цифр tuition/deadline/IELTS в сниппетах не подтверждено. Источники для tuition: studiesinhungary.com (3950 EUR/семестр + 475 EUR admission + 230 EUR enrollment), Semmelweis official (3400–3950 EUR/семестр в зависимости от года), Scribd презентация Semmelweis 2025 (7200 EUR за 2 года = ~3600/сем). Итог ~6400 EUR/год — экстраполяция, не точная non-EU ставка. IELTS 6.0 — стандартное требование Semmelweis, но для этого MSc явно не подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b7db40e0-5888-4c3d-bac1-75a112b5ec11',
  'Nursing (MSc) — Advanced Practice in Nursing', 'Medicine', 'English', 24, 6400,
  'ai', current_date,
  4, 30, 6, null, 'https://apply.stipendiumhungaricum.hu/courses/course/813-msc-advanced-practice-nursing',
  array['Stipendium Hungaricum (full tuition waiver + monthly stipend + accommodation for non-EU applicants)'],
  'Магистерская программа Semmelweis University в Будапеште для медсестёр, желающих стать Advanced Practice Nurse (APN) в области первичной и общественной помощи. Обучение на английском, 4 семестра (90 ECTS), диплом признаётся в ЕС.',
  array['Престижный вуз с признанным дипломом медсестры в ЕС', 'Полная стипендия Stipendium Hungaricum для не-ЕС покрывает обучение, жильё и выплаты', 'Английский язык обучения и расположение в Будапеште'],
  array['Точная non-EU ставка на странице курса не указана — приведённая цифра ~6400 EUR/год основана на сторонних источниках (studiesinhungary.com / scribd-презентация Semmelweis 7200 EUR/2 года), единая страница с tuition+deadline+IELTS не подтверждена лично', 'Дедлайн 30 апреля — типичный для Stipendium Hungaricum, но конкретное число для этого курса надо проверять на apply.stipendiumhungaricum.hu'],
  false, null
);
