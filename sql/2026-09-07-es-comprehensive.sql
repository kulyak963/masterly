-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Spain (es) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, потому что на известной странице https://www.upc.edu/en/masters/architecture-barcelona-etsab в сниппете поиска прямо указана цена для non-EU ''€2,700'' (это подтверждено), НО точный IELTS-минимум и конкретная дата дедлайна для non-EU на той же странице не зафиксированы. Дополнительно: UPC в июле 2025 снизил цену за кредит для non-EU с €102.52 до €45 (см. https://www.upc.edu/en/press-room/news/the-upc-reduces-tuition-fees-for-non-eu-students-enrolling-in-master-degrees), поэтому €2,700 = 60 × €45 для квалифицирующего магистра. Длительность — 60 ECTS = 12 месяцев, а не 24 как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '82e05545-5d70-462e-b4d5-7425d25e4a25',
  'Master''s degree in Architecture', 'Architecture', 'English', 12, 2700,
  'ai', current_date,
  5, 31, 6.5, null, 'https://www.upc.edu/en/masters/architecture-barcelona-etsab',
  array[]::text[],
  'Квалифицирующий магистерский degree по архитектуре в Школе архитектуры Барселоны (ETSAB) при UPC. Программа 60 ECTS, преподаётся преимущественно на испанском, даёт право профессиональной практики архитектора.',
  array['Подтверждена отдельная цена для non-EU: €2,700 за всю программу (60 ECTS × €45/кредит после снижения 2025)', 'Квалифицирующий магистр — открывает путь к лицензии архитектора в ЕС', 'Программа в престижной архитектурной школе ETSAB'],
  array['Точный IELTS-минимум для этой конкретной программы не найден на известной странице — указано ориентировочно 6.5 (общий уровень B2 UPC)', 'Дедлайн не подтверждён единой датой — у UPC несколько раундов pre-enrolment (по сторонним источникам основной раунд — май–июнь)', 'Преподавание в основном на испанском, что критично для non-EU без знания языка', 'Информация о стипендиях для non-EU именно по этой программе не подтверждена'],
  false, null
);

-- verified=false: на странице upc.edu не удалось одновременно увидеть tuition, deadline и IELTS для не-ЕС студентов. Цена 3 875 € (EU 2 400 €) взята из bestarchitecturemasters.com, сроки/IELTS — ориентировочно. Рекомендуется уточнить на mbarch.masters.upc.edu/en и у admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '82e05545-5d70-462e-b4d5-7425d25e4a25',
  'Master''s degree in Advanced Studies in Architecture-Barcelona (MBArch)', 'Architecture', 'English', 18, 3875,
  'ai', current_date,
  4, 30, 6.5, null, 'https://www.upc.edu/en/masters/advanced-studies-in-architecture-barcelona-mbarch',
  array['UPC Master''s grants (limited, merit-based)'],
  'Официальная магистерская программа UPC/ETSAB на 60 ECTS (≈1 учебный год, фактически 18 месяцев) с девятью специализациями, преподавание на английском. Для не-ЕС студентов стоимость около 3 875 € за весь курс.',
  array['Англоязычная программа от престижной архитектурной школы ETSAB', 'Несколько треков специализации в одной программе (Urbanism, Process & Programming и др.)', 'Стоимость для не-ЕС заметно ниже, чем в среднем по Европе'],
  array['Сумма 3 875 € приведена сторонним агрегатором (bestarchitecturemasters.com), на официальной странице UPC точную цифру для не-ЕС в выдаче не удалось подтвердить — возможны расхождения', 'Дедлайн 30 апреля и требование IELTS 6.5 не подтверждены на одной странице с tuition — взяты как типичные для UPC MBArch, нужна проверка'],
  false, null
);

-- Подтверждено на известной странице https://www.upf.edu/en/web/met/presentacio (и подтверждено на https://www.upf.edu/en/web/met/acces): тариф для не-ЕС 5 749,8 € против 1 302 € для ЕС, 44 места, двухлетний очный формат. НЕ подтверждено на той же странице: конкретный дедлайн подачи и точный IELTS-минимум для этой магистратуры — взяты по общей практике UPF (апрель, IELTS 6.5), поэтому verified=false. Шкалы GPA в Испании как таковой нет — указано условное 3.0.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master in Translation Studies', 'Linguistics', 'English', 24, 5750,
  'ai', current_date,
  4, 30, 6.5, null, 'https://www.upf.edu/en/web/met/presentacio',
  array[]::text[],
  'Магистерская программа UPF по переводу в Барселоне (60 ECTS, очно) на испанском и английском с упором на специальный и профессиональный перевод. Для не-ЕС студентов годовая стоимость около 5 749,8 € против 1 302 € для студентов ЕС — заметная разница.',
  array['Чётко опубликованный отдельный тариф для не-ЕС студентов на той же странице программы', 'Обучение в топовом испанском университете в Барселоне с двуязычной средой (испанский + английский)', 'Большой бюджет мест (44 студента) и вечерний формат занятости (14:00–20:00), удобный для работающих'],
  array['Стоимость для не-ЕС почти в 4,5 раза выше, чем для студентов ЕС (≈5 749,8 € против 1 302 €)', 'Точные дедлайны и IELTS-порог для конкретно этого магистра в найденных результатах не указаны — взяты по общим требованиям UPF (заявки до ~30 апреля, IELTS 6.5)'],
  false, null
);

-- Подтверждено на странице admissions-and-fees самой программы: tuition для non-EU = 34 500 € (страница самой программы + кросс-проверка через Fulbright 2026–2027) и IELTS 7.0 (минимум) с рекомендацией 7.5 (страница applying-to-a-masters-program + admissions dual-degree). НЕ подтверждено как verified=true, потому что tuition+IELTS подтверждены, но жёсткого deadline на странице программы нет — указано rolling admissions; конкретная дата закрытия набора на странице не зафиксирована, поэтому deadline_month/day — экспертная оценка (типичный поздний срок ~30 июня для сентябрьского старта, возможны более ранние реальные закрытия). Длительность 11 месяцев подтверждена Fulbright Award страницей, а не 24, как указано в вашем шаблоне. GPA-минимум официально не опубликован — цифра 3.0/4.0 дана как типичное неформальное ожидание IE.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in International Relations', 'International Relations', 'English', 11, 34500,
  'ai', current_date,
  6, 30, 7, null, 'https://www.ie.edu/school-politics-economics-global-affairs/programs/master-in-international-relations/admissions-and-fees/',
  array[]::text[],
  '11-месячная англоязычная магистерская программа по международным отношениям в IE University (Мадрид). Стоимость для студентов из стран, не входящих в ЕС, составляет 34 500 € (по данным на 2026–2027 учебный год).',
  array['Программа в топовой частной бизнес-школе Испании с сильным брендом в IR и global affairs', 'Гибкий rolling admissions — можно подать документы в течение года до заполнения мест', 'Полностью на английском, международная среда и связи с испанскими/европейскими институтами'],
  array['Высокая стоимость для не-ЕС студентов — 34 500 €, одна из самых дорогих программ MR в Испании', 'IELTS требуется минимум 7.0 (рекомендуют 7.5) — это заметно выше среднего и может стать барьером', 'Фиксированного дедлайна нет (rolling admissions), реальная дата закрытия зависит от набора; конкретную дату на сайте программы не подтверждают', 'Длительность 11 месяцев (не 24, как иногда пишут в агрегаторах) — короткий и интенсивный формат'],
  false, null
);

-- Предупреждения при сборе:
-- - Universitat Politècnica de Catalunya / "Master's degree in Architectural Design Ecology in the Digital Age": timeout: прокси не ответил за 90с
-- - Universitat Pompeu Fabra / "Master in Theoretical and Applied Linguistics": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Universidad Carlos III de Madrid / "Master in Clinical Engineering": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use, tool_use]. Text: (empty)
