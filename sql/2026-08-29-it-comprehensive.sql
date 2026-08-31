-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
-- Дата: 2026-08-29
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

-- verified=false: страница https://www.unifi.it/en/study-us/degree-programs/second-cycle-degree/energy-engineering подтверждает существование программы и длительность 2 года (Unrestricted Duration 2 years), но конкретная сумма tuition, дедлайн и минимальный IELTS для non-EU на этой странице не подтверждены в результатах поиска. Tuition €3 000/год — оценка по общим данным UNIFI для инженерных программ non-EU (beyondthestates.com, housinganywhere.com). Дедлайн 30 апреля и IELTS 6.0 — типичные значения для UNIFI, но не подтверждены для конкретно Energy Engineering.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Energy Engineering', 'Computational Engineering', 'English', 24, 3000,
  4, 30, 6, 3, 'https://www.unifi.it/en/study-us/degree-programs/second-cycle-degree/energy-engineering',
  array['DSU Toscana regional scholarship (income-based, non-EU eligible)'],
  'Магистратура по энергетике в Университете Флоренции на английском, 2 года. Программа входит в список English-taught программ UNIFI.',
  array['Преподавание полностью на английском', 'Низкая стоимость обучения для иностранных студентов (~€3 000/год)', 'Флоренция — крупный студенческий город с развитой инфраструктурой'],
  array['Точная сумма tuition для non-EU не подтверждена с конкретной страницы программы', 'Дедлайн и точный порог IELTS для non-EU не найдены на одной странице с программой'],
  false, null
);

-- Не полностью подтверждено: на известной странице https://www.ing-mme.unifi.it/vp-157-presentation-of-the-course.html подтверждён только английский язык обучения и требование сертификата B2 по английскому, но ни tuition, ни deadline для не-ЕС студентов там не указаны напрямую. Цифра €2 650 взята из Beyond the States ($2 650 ≈ €2 650/год), дедлайн 30 июня — типовая дата для не-ЕС абитуриентов Университета Флоренции через портал apply.unifi.it (стандартный порядок подачи не-ЕС заявок). IELTS ≥6.0 указан как эквивалент B2 согласно общепринятой шкале. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Management Engineering', 'Business Analytics', 'English', 24, 2650,
  6, 30, 6, 3, 'https://www.ing-mme.unifi.it/vp-157-presentation-of-the-course.html',
  array[]::text[],
  'Магистерская программа Management Engineering в Университете Флоренции — двухлетняя программа полностью на английском языке с двумя специализациями: Smart Industry и International (с двойным дипломом HSLU Люцерн и годом за рубежом).',
  array['Полностью на английском — программа подходит иностранцам', 'Возможность двойного диплома с HSLU Lucerne и годом обучения за рубежом'],
  array['Точная сумма tuition для не-ЕС студентов и точный дедлайн подачи не подтверждены на одной официальной странице программы — данные взяты из агрегатора Beyond the States (≈$2 650 ≈ €2 650/год)'],
  false, null
);

-- Дедлайн 17 апреля подтверждён несколькими источниками (mastersportal.com, Instagram Университета Флоренции, apply.unifi.it) для категории non-EU/иностранных абитуриентов. Стоимость €6400/год — стандартный non-EU тариф Университета Флоренции (страница vp-146-enrollment.html не показывает прямую цифру в сниппетах; beyondthestates.com показывает $2862 для EU). IELTS 6.0 — общее требование Unifi, но на странице apply.unifi.it упоминается, что сертификат должен быть выдан Centro Linguistico Unifi в последние 5 лет, а не IELTS напрямую. Поскольку все три параметра (tuition+deadline+language) не подтверждены на одной странице — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Mechanical Engineering for Sustainability', 'Computational Engineering', 'English', 24, 6400,
  4, 17, 6, 3, 'https://apply.unifi.it/courses/course/90-mechanical-engineering-sustainability',
  array['Invest Your Talent in Italy (Italian Government scholarships for non-EU students)', 'DSU Toscana regional scholarship (based on income/merit)'],
  'Магистратура по машиностроению с уклоном в устойчивое развитие в Университете Флоренции,2 года, полностью на английском. Программа ориентирована на зелёную энергетику, энергоэффективность и промышленную устойчивость.',
  array['Полностью англоязычная программа в историческом центре Флоренции', 'Сильный инженерный факультет с международной сетью и аккредитацией ASIIN'],
  array['Точная стоимость для non-EU и точные языковые требования не подтверждены на одной официальной странице — цифры приведены по стандартным тарифам Unifi и нескольким сторонним источникам'],
  false, null
);

-- verified=false: на одной официальной странице не подтверждены одновременно tuition+deadline+IELTS именно для non-EU. Официальная страница программы (unifi.it) подтверждает длительность 2 года, язык English и формат MSc. Конкретные цифры (€2,650, дедлайн 30 апреля, IELTS 6.0) — best-effort по агрегаторам Beyond The States и общим правилам UniFI, не из одного первичного источника.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Economics and Development', 'Business Analytics', 'English', 24, 2650,
  4, 30, 6, 3, 'https://www.unifi.it/en/study-us/degree-programs/second-cycle-degree/economics-and-development',
  array['University of Florence fee waivers based on ISEEU/financial status'],
  'Двухгодичная магистерская программа (120 ECTS) полностью на английском языке во Флоренции с двумя треками: Economics и Development. Сильный междисциплинарный фокус на экономическом развитии.',
  array['Полностью на английском, без требований к итальянскому', '2 года, 120 ECTS — стандарт европейского диплома, признаётся в ЕС', 'Возможность double degree с Гёттингенским университетом'],
  array['Точная стоимость для non-EU не подтверждена на одной странице; цифра ~€2,650/год взята со стороннего агрегатора Beyond The States (вероятно базовая плата для EU, non-EU может отличаться)', 'Дедлайн 30 апреля — ориентир по общему циклу подачи на магистратуру UniFI, для non-EU через apply.unifi.it обычно раньше (март), точная дата в сниппетах не подтверждена', 'IELTS 6.0 — типовое требование UniFI, но именно для этой программы на официальной странице в выдаче не показано'],
  false, null
);

-- verified=false: на найденной официальной странице apply.unifi.it/courses/course/28-finance-and-risk-management и unifi.it/en/study-us/degree-programs/second-cycle-degree/finance-and-risk-management подтверждены название, длительность (2 года) и формат (английский, unrestricted доступ), но точные tuition non-EU, deadline и IELTS6.0 в сниппетах поиска не отображены — приведены ориентировочные значения по аналогии со стандартной политикой Unifi и данным агрегаторов (beyondthestates.com).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Finance and Risk Management', 'Business Analytics', 'English', 24, 2650,
  4, 30, 6, 3, 'https://apply.unifi.it/courses/course/28-finance-and-risk-management',
  array['Invest Your Talent in Italy', 'DSU Toscana regional scholarship (based on income/merit)', 'University of Florence fee waivers for non-EU students'],
  'Магистратура MSc по финансам и управлению рисками во Флорентийском университете — двухлетняя программа на английском в школе экономики и менеджмента, ориентированная на количественные финансы, риск-менеджмент и актуарные науки.',
  array['Программа полностью на английском, удобно для иностранцев', 'Срок обучения 2 года, диплом LM16 признаётся в ЕС', 'Сильная школа экономики с уклоном в количественные финансы и актуарные науки'],
  array['Точная сумма tuition для non-EU на официальной странице не подтверждена — указана оценка по аналогии с другими магистратурами Unifi (€2 650/год по данным beyondthestates.com); non-EU ставка может быть выше', 'Финальный дедлайн 30 апреля для non-EU не подтверждён на официальной странице курса в выдаче, ориентир из apply.unifi.it'],
  false, null
);

-- verified=false, потому что tuition+deadline+IELTS не подтверждены одновременно на одной официальной странице для не-ЕС абитуриентов. Источники: официальная страница программы unifi.it (длительность, язык, структура); beyondthestates.com указывает €2,650/год (итого ≈€5,300 за 2 года — взято как оценка); стандартный дедлайн non-EU в Университете Флоренции обычно до 30 апреля; IELTS 6.0 — типичное требование B2 в UNIFI. Для окончательного подтверждения нужно проверить apply.unifi.it/STS и dsts.unifi.it/vp-141-how-to-enrol.html на актуальный учебный год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Design of Sustainable Tourism Systems', 'Business Analytics', 'English', 24, 5300,
  4, 30, 6, 3, 'https://www.unifi.it/en/study-us/degree-programs/second-cycle-degree/design-sustainable-tourism-systems',
  array['Invest Your Talent in Italy', 'Regional DSU Toscana scholarship (based on ISEE/financial status)', 'University of Florence fee waivers for high-merit non-EU applicants'],
  'Магистерская программа Университета Флоренции на английском языке, ориентированная на проектирование устойчивых туристических систем: планирование, управление, экономика туризма и оценка воздействия. Длительность — 2 года (120 ECTS), форма обучения — очная.',
  array['Полностью на английском языке — подходит для иностранцев', 'Флоренция — мировой центр туризма и культурного наследия, сильная практическая база', 'Университет Флоренции — один из старейших и престижных вузов Италии'],
  array['Точный размер платы для non-EU студентов не подтверждён на одной официальной странице (указан ориентировочно)', 'Дедлайн для не-ЕС заявок варьируется в разных источниках (апрель–август), точная дата требует уточнения на apply.unifi.it'],
  false, null
);

-- verified=false, потому что не найдено одной страницы, где одновременно подтверждены tuition+deadline+language для не-ЕС студентов. Tuition €2,650/год — из beyondthestates.com (агрегатор). IELTS 6.0 — типичный минимум для магистратур UniFi на английском (источник IIC New Delhi 2024), но пост Университет делла Монтанья 2026 пишет ''IELTS not required''. Дедлайн 30 апреля — оценка по типичному non-EU циклу UniFi, точная дата 2026/27 не подтверждена на одной странице. GPA не подтверждён, взято 3.0 как разумная оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Natural Resources Management for Tropical Rural Development (joint degree)', 'Business Analytics', 'English', 24, 2650,
  4, 30, 6, 3, 'https://www.tropicalagriculture.unifi.it/',
  array[]::text[],
  'Совместная магистерская программа Университета Флоренции (TROPIMUNDO / Erasmus Mundus) по управлению природными ресурсами для тропического сельского развития, обучение полностью на английском, длительность 2 года (120 ECTS).',
  array['Полностью англоязычная программа с акцентом на тропическое сельское хозяйство и устойчивое управление ресурсами', 'Совместный диплом (joint degree) в рамках Erasmus Mundus — высокая академическая репутация и мобильность между университетами-партнёрами', 'Относительно невысокая стоимость обучения для иностранных студентов (~€2,650/год)'],
  array['Точные требования по IELTS и крайний срок подачи для не-ЕС студентов не удалось подтвердить на одной официальной странице (источники расходятся: от 6.0 до ''IELTS not required'', дедлайны Feb/May)', 'Программа на сайте Университета Флоренции теперь фигурирует под новым названием ''Tropical and Subtropical Agriculture'' — возможна путаница с актуальной заявкой'],
  false, null
);

-- Предупреждения при сборе:
-- - University of Florence / "Artificial Intelligence and Data Analytics (B338)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
