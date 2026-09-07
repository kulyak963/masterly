-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Ireland (ie) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- На официальной странице ucd.ie/courses/t339 подтверждены: non-EU fee €29,500/год, IELTS 6.5 (мин. 6.0 по секциям). Дедлайн подачи не указан явно на этой странице — взят ориентир из официального Instagram программы (21.06.2024), поэтому verified=false. Реальная длительность — 12 месяцев (1 год), а не 24 как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'dfb22df0-6169-4900-b1c6-e4e10550c662',
  'MSc Architecture, Urbanism & Climate Action', 'Architecture', 'English', 12, 29500,
  'ai', current_date,
  6, 21, 6.5, null, 'https://www.ucd.ie/courses/t339',
  array['UCD Global Scholarships (для non-EU студентов)'],
  'Годичная магистратура UCD в Дублине (Level 9, 90 кредитов) для архитекторов и градостроителей: проектирование устойчивых низкоуглеродных городов и адаптация к климатическому кризису.',
  array['Чёткий фокус на климатической повестке в архитектуре и градостроительстве', 'UCD предлагает отдельные стипендии для non-EU студентов (UCD Global)'],
  array['Высокая non-EU стоимость €29,500/год против €9,720/год для EU — большой разрыв', 'Точный дедлайн на 2025/2026 не указан явно на ucd.ie/courses/t339; использован ориентир из официального Instagram @maucaucd (21 июня 2024), поэтому verified=false'],
  false, null
);

-- Подтверждено только наличие программы по URL ucd.ie/courses/t273 и упоминание о scholarships для international students на самой странице. Точные цифры tuition/deadline/IELTS со страницы курса в выдаче не раскрыты (поиск вернул только общие фрагменты: страница существует, требуется портфолио и степень NFQ Level 8). Использованы типичные для UCD Graduate Studies значения: IELTS 6.5, не-EU fee ~€25,600/год, дедлайн 30 июня (стандарт UCD для fall intake) — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'dfb22df0-6169-4900-b1c6-e4e10550c662',
  'Master of Architecture', 'Architecture', 'English', 24, 25600,
  'ai', current_date,
  6, 30, 6.5, null, 'https://www.ucd.ie/courses/t273',
  array['UCD Global Graduate Scholarships (для self-funding international students)'],
  'Двухгодичная профессиональная программа магистра архитектуры в UCD (Дублин) — одна из ведущих архитектурных школ Ирландии с акцентом на проектную работу и подготовку к регистрации в RIAI. Программа требует портфолио и подходит для выпускников бакалавриата по архитектуре.',
  array['UCD входит в топ-1% университетов мира, сильный бренд для архитектурной карьеры', 'Программа аккредитована RIAI и ведёт к профессиональной квалификации архитектора в Ирландии', 'Доступны Global Graduate Scholarships для иностранных студентов'],
  array['Точная стоимость для non-EU студентов не подтверждена напрямую со страницы курса — указана оценочная цифра ~€25,600/год (итого ~€51,200 за 2 года); реальная цифра может отличаться, проверяйте на странице Fees & Funding', 'Высокая стоимость обучения по сравнению с континентальными программами архитектуры', 'Обязательно портфолио + собеседование — конкурс отбора'],
  false, null
);

-- verified=false: tuition €23,000 non-EU подтверждена на официальной странице DCU (dcu.ie). IELTS 6.5 и дедлайн 1 июля взяты как стандартные требования DCU для postgraduate non-EU — точная страница с дедлайном/IELTS именно этой программы не была найдена в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac9a5883-1e9a-4f38-a84a-95a74fabcb33',
  'MSc in Diagnostics and Precision Medicine', 'Medicine', 'English', 24, 23000,
  'ai', current_date,
  7, 1, 6.5, null, 'https://www.dcu.ie/courses/postgraduate/school-biotechnology/msc-diagnostics-and-precision-medicine',
  array['Faculty of Science and Health International Scholarship (€5,000 fee reduction for non-EU students)'],
  'Двухгодичная магистерская программа DCU в области диагностики и прецизионной медицины в Школе биотехнологий. Стоимость для студентов вне ЕС — €23,000 в год, доступна стипендия факультета.',
  array['Стипендия Faculty of Science and Health для иностранцев — скидка €5,000 от non-EU tuition', 'Программа при сильной исследовательской школе биотехнологий DCU', 'Возможность модульной оплаты (per-credit) для non-EU студентов'],
  array['Высокая стоимость для non-EU — €23,000 в год (полная двухгодичная ≈ €46,000)', 'Точная дата дедлайна подачи не подтверждена на странице программы — указана ориентировочно (обычно 1 июля для non-EU); IELTS официально 6.5 (по данным DCU для большинства PG программ)'],
  false, null
);

-- Подтверждено на официальной странице DCU (dcu.ie/courses/postgraduate/school-law-and-government/ma-international-relations): не-EU тариф €17,200 (full-time), дедлайн для не-EU 1 июля 2026, IELTS 6.5 с минимум 6.0 по компонентам — все три параметра найдены на одной странице. Длительность full-time указана как 1 год (12 месяцев). GPA указан приблизительно — DCU использует ирландскую шкалу 2:1/2:2, эквивалент ~3.0 по шкале 4.0.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac9a5883-1e9a-4f38-a84a-95a74fabcb33',
  'MA in International Relations', 'International Relations', 'English', 12, 17200,
  'verified', current_date,
  7, 1, 6.5, null, 'https://www.dcu.ie/courses/postgraduate/school-law-and-government/ma-international-relations',
  array[]::text[],
  'Магистратура по международным отношениям в Дублинском городском университете — старейшая программа MA в Ирландии в этой области, с фокусом на политику, права человека, торговлю и безопасность.',
  array['Старейшая программа MA по международным отношениям в Ирландии', 'Официальный не-EU тариф чётко указан на странице программы (€17,200/год)', 'Приём заявок rolling, но для не-EU дедлайн — 1 июля'],
  array['Тариф для не-EU (€17,200/год) более чем вдвое превышает EU-тариф (€8,100)', 'Дедлайн 1 июля для не-EU — из-за визовой обработки рекомендуют подавать заранее, IELTS требует 6.5 с минимум 6.0 по каждому компоненту'],
  true, current_date
);

-- verified=false: на самой странице курса (literature-publishing.html) из сниппетов подтверждены только описание программы, код1MLP1, длительность 12 месяцев и дедлайн подачи документов — 30 сентября (для набора 2025-26, приём на 2026/27 помечен как закрытый). Стоимость €20 040 для non-EU взята со страницы postgraduate-fees по тому же шаблону, что и для International Development MA (€8 290 / €20 040 на 2026/27). Требование IELTS для этого конкретного курса на странице не отобразилось — у соседней MA English указано 7.0; оценка 6.5 как типовое требование университета не верифицирована. Источник: universityofgalway.ie (официальный сайт).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99808560-afc2-4c12-9a4a-4103b5b13be3',
  'Literature and Publishing (MA)', 'Journalism', 'English', 12, 20040,
  'ai', current_date,
  9, 30, 6.5, null, 'https://www.universityofgalway.ie/courses/taught-postgraduate-courses/literature-publishing.html',
  array['University of Galway Global Scholarships (merit-based)'],
  'Единственная в Ирландии полноформатная (full-time) магистратура, сочетающая академическое изучение литературы с профессиональными навыками издательского дела, включая обучение Adobe InDesign. Программа длится 12 месяцев (90 кредитов ECTS), код курса 1MLP1.',
  array['Уникальная для Ирландии специализация — единственная полноформатная программа, объединяющая литературу и паблишинг', 'Практические навыки (Adobe InDesign, портфолио-проект или диссертация на выбор) повышают трудоустраиваемость в издательской отрасли'],
  array['Не подтверждено напрямую на странице курса требование по IELTS именно для этой программы — взято ориентировочно 6.5 (у смежной MA English указано 7.0); точную цифру нужно уточнять у приёмной комиссии', 'Стоимость €20 040 в год для не-ЕС получена по аналогии с шаблоном страницы fees (€8 290 EU / €20 040 non-EU для 2026/27) — конкретная строка для 1MLP1 в сниппете не была видна целиком'],
  false, null
);

-- Предупреждения при сборе:
-- - University College Dublin / "MSc International Law & Business": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use, tool_use]. Text: (empty)
-- - University College Dublin / "MA Journalism & International Affairs": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use]. Text: (empty)

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - University College Dublin — "MSc Urban Design (Research)": https://www.ucd.ie/courses/t060 (ECONNRESET)
-- - University College Dublin — "Research Masters in Architectural Design": https://www.ucd.ie/courses/t256 (ECONNRESET)
-- - University of Galway — "MSc in Health Psychology": https://www.universityofgalway.ie/courses/taught-postgraduate-courses/health-psychology.html (ECONNRESET)
