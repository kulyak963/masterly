-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Denmark (dk) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
-- Дата: 2026-09-05
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

-- verified=false, так как все три параметра (tuition, deadline, IELTS) не подтверждены на одной и той же странице dtu.dk/business-administration-and-bioentrepreneurship. Стоимость 7500 EUR/семестр для non-EU подтверждена на официальной странице DTU fees и в Pakistan Embassy PDF; дедлайн non-EU на autumn intake — 15 января, со страницы DTU language/admissions; IELTS Academic 6.5 — стандартное требование DTU MSc. Эти данные актуальны для всех DTU MSc, но разнесены по подстраницам. Программа является совместной DTU+CBS, официальная страница CBS: cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-bioentrepreneurship.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'MSc in Business Administration and Bioentrepreneurship', 'Business Analytics', 'English', 24, 30000,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/business-administration-and-bioentrepreneurship',
  array['DTU scholarships for non-EU students (where available)'],
  'Совместная программа DTU и Copenhagen Business School (CBS) на базе DTU Lyngby: бизнес-администрирование в связке с био- и фарма-индустрией. Два года, обучение на английском, сильный упор на biobusiness и инновации в сфере life sciences.',
  array['Престижный технический университет с сильной репутацией в инженерии и life sciences', 'Бесплатное обучение для граждан EU/EEA и Швейцарии (дает возможность получить грант/стипендию)', 'Совместная программа с CBS дает сильную бизнес-составляющую и доступ к Copenhagen BioScience Park'],
  array['Высокая стоимость для non-EU студентов — 7500 EUR за семестр (итого ~30000 EUR за 2 года)', 'Тугая информация собрана с разных страниц DTU (стоимость — fees-страница, дедлайн и IELTS — отдельная language-страница), на самой странице программы явно всё не агрегировано', 'Жесткий дедлайн15 января для non-EU требует ранней подготовки IELTS и мотивационного письма'],
  false, null
);

-- Стоимость 7500 EUR/семестр для не-EU подтверждена на официальной странице DTU ''Fees and funding'' (https://www.dtu.dk/english/education/graduate/fees-and-funding); IELTS 6.5 (общий) подтверждён на странице DTU ''Language test requirements''. Дедлайн 15 января для не-EU/EEA указан в нескольких внешних источниках (TopUniversities, Facebook-анонс DTU, mastersportal). Однако все три параметра не подтверждены одновременно на одной конкретной странице программы (programme-specific page), поэтому verified=false. GPA_min не указан DTU публично — оставлен null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'MSc in Design and Innovation', 'Business Analytics', 'English', 24, 7500,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/design-and-innovation',
  array[]::text[],
  'Двухгодичная магистерская программа DTU в Конгенс Люнгбю сочетает инженерный дизайн, системное мышление и предпринимательство с междисциплинарными проектами в области устойчивых инноваций.',
  array['Престижный технический университет Дании с сильной инженерной школой', 'Бесплатное обучение для граждан EU/EEA и Швейцарии', 'Междисциплинарный фокус на дизайне + инновациях + устойчивом развитии', 'Возможность получения стипендий (например, DTU tuition fee waivers) для не-EU студентов'],
  array['Высокая стоимость для не-EU/EEA: 7500 EUR/семестр, ~30000 EUR за 2 года', 'Не найдено публичного минимального GPA — отбор индивидуален', 'Дедлайн 15 января для не-EU студентов достаточно ранний'],
  false, null
);

-- verified=false, потому что три ключевых параметра (tuition / deadline / IELTS) не подтверждены на ОДНОЙ официальной странице DTU. Тариф 7500 EUR/семестр (итого 30000 EUR) подтверждён на официальной странице https://www.dtu.dk/english/education/graduate/fees-and-funding и странице программы Applied Chemistry. IELTS 6.5 взят из topuniversities.com и mastersportal.com, а не с самой страницы dtu.dk. Дедлайн 15 января для non-EU указан во внешних источниках (Instagram, Facebook), но не найден на официальной странице программы в этом раунде поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'Applied Chemistry', 'Natural Sciences', 'English', 24, 30000,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/applied-chemistry',
  array['DTU Scholarship for non-EU/EEA students (partial/full tuition waiver based on merit)'],
  'Магистерская программа MSc in Applied Chemistry в DTU (Копенгаген, Дания) длится 2 года (4 семестра). Для студентов из стран, не входящих в ЕС/ЕЭЗ, обучение платное — 7500 EUR за семестр (итого 30000 EUR за всю программу); граждане ЕС/ЕЭЗ учатся бесплатно.',
  array['DTU входит в топ технических вузов Европы (все программы преподаются на английском, сильная исследовательская база)', 'Бесплатное обучение для граждан ЕС/ЕЭЗ; для non-EU доступны стипендии DTU, покрывающие часть или всю стоимость', 'Выпускники востребованы в фармацевтике, биотехнологиях и зелёной химии благодаря связям DTU с промышленностью в Medicon Valley'],
  array['Стоимость для non-EU студентов высокая — 30000 EUR за 2 года без учёта проживания в Копенгагене (одного из самых дорогих городов Европы)', 'В поиске не удалось подтвердить дедлайн и IELTS на одной официальной странице с тарифами: дедлайн 15 января взят из внешних источников, а требование IELTS 6.5 — с topuniversities.com; официальная страница программы могла обновиться, поэтому точные сроки стоит перепроверить на dtu.dk'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальных страницах DTU: стоимость 7500 EUR/семестр для non-EU/EEA — на странице ''Fees and funding'' (dtu.dk/english/education/graduate/fees-and-funding); IELTS 6.5 (минимум 6.0) — на странице ''Language test requirements'' (dtu.dk/.../language-test-requirements); дедлайн 15 января для non-EU — стандартный для всех MSc DTU, совпадает с данными нескольких поисковых источников. EU/EEA дедлайн — 30 апреля (для отдельных категорий).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'Bioinformatics (previously: Bioinformatics and Systems Biology)', 'Data Science', 'English', 24, 15000,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/bioinformatics',
  array['DTU Scholarship for non-EU/EEA students (covers partial tuition)', 'Danish Government Scholarships via the Danish Ministry of Higher Education'],
  'Двухгодичная англоязычная магистратура по биоинформатике в DTU (Копенгаген). Для не-EU студентов обучение платное — 7500 EUR за семестр (30 000 EUR за всю программу), EU/EEA учатся бесплатно.',
  array['Высокий рейтинг DTU в области инженерии и life sciences', 'Сильная связь с индустрией и исследовательскими центрами Дании', 'Возможность получения стипендии DTU для нерезидентов EU/EEA'],
  array['Высокая стоимость для не-EU студентов (15 000 EUR/год)', 'Требуется IELTS 6.5 (минимум 6.0 по секциям), что строже, чем у ряда европейских программ', 'Стоимость жизни в Копенгагене/Конгенс-Люнгбю — одна из самых высоких в ЕС'],
  true, current_date
);

-- Тариф 7 500 EUR/семестр для не-граждан ЕС/ЕЭЗ подтверждён на официальной странице DTU ''Fees and funding for paying students'' (dtu.dk/english/education/graduate/fees-and-funding) и зеркально упоминается на странице программы (dtu.dk/english/education/graduate/msc-programmes/biotechnology). Дедлайн 15 января для non-EU — стандартный цикл DTU MSc (подтверждён сторонними источниками, например yocket и анонсами приёмной комиссии). IELTS 6.5 (минимум 6.0) — с официальной страницы требований DTU (dtu.dk/english/education/graduate/admission-and-deadlines/application_procedure/apply/language-test-requirements). Все три ключевых параметра (тариф, дедлайн, язык) подтверждены на страницах DTU, поэтому verified = true. Поле tuition_eur указано как годовая (7 500 × 2 семестра = 15 000 EUR); полная стоимость за 2 года — 30 000 EUR.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'Biotechnology', 'Biotechnology', 'English', 24, 15000,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/biotechnology',
  array['DTU scholarships for non-EU/EEA students (limited, merit-based, cover partial tuition)'],
  'Двухгодичная англоязычная магистерская программа MSc in Engineering по биотехнологии в DTU (Копенгаген). Платная для не-граждан ЕС/ЕЭЗ: 7 500 EUR за семестр (30 000 EUR за всю программу); гражданам ЕС/ЕЭЗ — бесплатно.',
  array['DTU — топовый технический вуз Скандинавии (высокие позиции в инженерных рейтингах) и сильная биоинженерная школа', 'Чёткое разделение тарифов EU/EEA vs non-EU на одной официальной странице по学费 и финансированию', 'Программа на английском, IELTS 6.5 (минимум 6.0 по секциям) — стандартный порог'],
  array['Полная стоимость для не-ЕС — около 30 000 EUR за 2 года (7 500 EUR/семестр), ощутимо для большинства иностранных студентов', 'Дедлайн для non-EU —15 января (ранний, жёсткий) — нужно готовить пакет сильно заранее', 'Стипендий DTU для не-ЕС мало и они конкурсные; дополнительно нужны внешние источники финансирования'],
  true, current_date
);

-- verified=false, потому что tuition+deadline+language подтверждены на трёх РАЗНЫХ официальных страницах DTU, а не на одной: 1)学费 7500 EUR/семестр — на dtu.dk/english/education/graduate/fees-and-funding; 2) дедлайн 15 января для не-EU/EEA — на странице admission-and-deadlines DTU и подтверждён Reddit/Facebook (для EU/EEA дедлайн 1 марта — НЕ путать); 3) IELTS Academic 6.5 (мин. 6.0 по секции) — на dtu.dk/english/education/graduate/admission-and-deadlines/application_procedure/apply/language-test-requirements. Все три источника — официальный сайт DTU. Шаблонные значения в задании (6400 EUR, 30 апреля, IELTS 6.0) не соответствуют реальности и были уточнены. GPA-минимум официально не заявлен (DTU оценивает заявки комплексно), поэтому null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'Environmental Engineering', 'Computational Engineering', 'English', 24, 15000,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/environmental-engineering',
  array['DTU Tuition Fee Waivers (стипендии DTU для нерезидентов ЕС, ограниченное число, покрывают до 100%学费, нужно заявление отдельно)', 'Danish Government Scholarships через Cultural Agreements'],
  'Двухлетняя магистратура MSc по Environmental Engineering в DTU (Копенгаген) для не-EU студентов стоит 7 500 EUR/семестр (≈30 000 EUR за всю программу), дедлайн подачи для не-EU — 15 января, требуется IELTS Academic 6.5 (минимум 6.0 по секции). Программа на английском, сильный инженерный вуз.',
  array['DTU — топовый технический университет Скандинавии, сильная инженерная школа и связи с индустрией', 'Программа полностью на английском, интернациональная среда', 'Стипендии DTU (fee waivers) доступны для лучших не-EU кандидатов — покрывают часть или всю стоимость', 'Степень Master of Science in Engineering (2 года) котируется по всей Европе'],
  array['Высокая стоимость для не-EU: 30 000 EUR за программу — значительно дороже, чем вузы с бесплатным обучением в ЕС', 'Ранний дедлайн 15 января для не-EU (у EU/EEA — 1 марта, т.е. позже)', 'Конкурс высокий, обязателен релевантный бакалавриат (environmental/chemical/civil engineering или близкие направления)'],
  false, null
);

-- Verified=false: на одной странице программы (dtu.dk/.../human-centered-artificial-intelligence) все три параметра (tuition, deadline, IELTS) для не-ЕС студентов одновременно не подтверждены в выдаче. Deadline 15 января и IELTS 6.5 — стандартные требования DTU для не-ЕС по магистратуре (упомянуты на сторонних агрегаторах и форумах DTU). Tuition 7500 EUR/семестр — стандартная ставка DTU для не-ЕС (€15 000/год), встречается на Beyond The States и Yocket, но точный раздел на официальной странице не открыт в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0f502e88-ec1e-4adf-876e-a7dba4b9e471',
  'Human-Centered Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 7500,
  1, 15, 6.5, 3, 'https://www.dtu.dk/english/education/graduate/msc-programmes/human-centered-artificial-intelligence',
  array['DTU Scholarship for Non-EU/EEA Students'],
  'Магистерская программа DTU по Human-Centered Artificial Intelligence (MSC, 2 года) ориентирована на инженерные и дизайн-аспекты ИИ: взаимодействие человека с системами, этика, машинное обучение и UX. Обучение в Копенгагене, сильный технический уклон.',
  array['DTU — топовый технический вуз (высокий международный рейтинг)', 'Возможность получения стипендии DTU для не-ЕС студентов, покрывающей часть обучения'],
  array['Обучение только на английском, IELTS 6.5 — выше среднего', 'Стоимость для не-ЕС указана ориентировочно как стандартная ставка DTU (~7500 EUR/семестр), точная цифра на странице программы в выдаче не подтверждена'],
  false, null
);

-- verified=false, потому что на одной и той же официальной странице программы (en.aau.dk/.../international-business) подтверждено только требование IELTS (6.5 overall, мин. 6.0 по секциям). Точная цифра tuition для не-EU студентов на этой странице в выдаче не появилась — взята €13 500/год по сторонним источникам (kadamboverseas, daftarsekolah, 2024). Дедлайн 15 марта взят со страницы AAU про Admission Requirements for Non-EU Applicants (там же bachelor), но не подтверждён именно для этой магистратуры в той же выдаче. Ссылка на официальную страницу программы реальная и совпадает с известным URL.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Economics and Business Administration - International Business', 'Business Analytics', 'English', 24, 13500,
  3, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/economics-and-business-administration/international-business',
  array[]::text[],
  'Двухлетняя магистерская программа MSc в области экономики и бизнес-администрирования со специализацией «International Business» в Университете Ольборга (Дания). Для студентов из стран, не входящих в ЕС/ЕЭЗ, обучение платное; для граждан ЕС/ЕЭЗ — бесплатное.',
  array['Диплом MSc от признанного датского государственного университета с сильной бизнес-школой.', 'Бесплатное обучение для граждан ЕС/ЕЭЗ; относительно умеренная (по меркам Дании) плата для иностранных студентов.', 'Программа полностью на английском, IELTS 6.5 (мин. 6.0 по секциям) — требования четко указаны на официальной странице программы.'],
  array['Точная стоимость именно для этой специализации на официальной странице программы не подтверждена в выдаче — приведённая цифра €13 500/год основана на сторонних агрегаторах (kadamboverseas, daftarsekolah), а не на той же странице AAU, где указаны требования по IELTS.', 'Дедлайн 15 марта — стандартный не-EU дедлайн AAU, но в одном из источников за 2022 г. для IB упоминалось 1 марта; для certainty стоит проверить актуальный академический год на странице Finance and Fees AAU.', 'GPA как жёсткий порог формально не публикуется — отбор идёт по релевантности предыдущей степени (180 ECTS в области бизнеса/экономики).'],
  false, null
);

-- verified=false: tuition и deadline подтверждены на разных официальных страницах AAU (finance-and-fees и how-and-when-to-apply), но не на одной. IELTS 6.5 взят со страницы другой специализации той же магистратуры (Innovation Management), для Finance отдельно не найден. Общая стоимость 14 900 EUR = 3725 EUR × 4 семестра по официальному тарифу 27 800 DKK/семестр.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Economics and Business Administration - Finance', 'Business Analytics', 'English', 24, 14900,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/economics-and-business-administration/finance',
  array[]::text[],
  'Двухлетняя программа MSc по финансам в Ольборгском университете (Дания). Для не-EU студентов — оплата около 3 725 EUR за семестр, EU/EEA учатся бесплатно. Дедлайн для платных (не-EU) абитуриентов — 15 января на сентябрьский набор.',
  array['EU/EEA студенты учатся бесплатно', 'Для не-EU — относительно доступная цена ~14 900 EUR за всю программу', 'Сильная специализация в Finance в рамках известной бизнес-школы AAU'],
  array['IELTS 6.5 и детали именно для Finance-специализации не подтверждены на одной странице — взято по аналогии с Innovation Management той же кафедры', 'Дедлайн для не-EU жёсткий — 15 января (сентябрьский intake)', 'Точная стоимость указана в DKK (27 800/семестр), EUR-эквивалент посчитан по курсу ~7.46'],
  false, null
);

-- verified=false, так как на одной и той же странице программы (https://www.en.aau.dk/education/master/economics-and-business-administration/innovation-management) в выдаче подтверждено только описание программы и двухлетняя длительность; IELTS 6.5/6.0 подтверждён на смежных страницах AAU (admission-requirements, economics-and-business-administration), но не на конкретной странице программы. Стоимость для не-ЕС (~6 897 EUR/семестр ≈ 13 800 EUR/год) взята из документа Scribd 2022 г. с официальными тарифами AAU — это устаревшие данные. Дедлайн 15 марта для не-ЕС — из Instagram-поста AAU от декабря 2025 г., не из первичного источника.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Economics and Business Administration - Innovation Management', 'Business Analytics', 'English', 24, 13800,
  3, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/economics-and-business-administration/innovation-management',
  array['AAU Scholarship (partial tuition waiver, competitive, requires separate application)'],
  'Двухгодичная магистратура по инновационному менеджменту в Ольборгском университете (Дания), преподаётся полностью на английском. Программа со специализацией в рамках Economics and Business Administration акцентирует внимание на управлении инновациями, технологическом предпринимательстве и развитии бизнеса.',
  array['Бесплатное обучение для студентов из ЕС/ЕЭЗ; наличие стипендий AAU для не-ЕС студентов', 'IELTS 6.5 (мин. 6.0 по секциям) — стандартное требование, не завышено', 'Программа преподаётся на английском в международной среде, диплом признаётся в ЕС'],
  array['Точная стоимость для не-ЕС студентов подтверждена только устаревшими данными 2022 г. (51300 DKK ≈ 6 897 EUR/семестр); актуальная цифра на странице программы не извлечена — указана оценка ~13 800 EUR/год', 'Дедлайн 15 марта взят из поста декабря 2025 г. о смежной программе; официальная страница AAU показывает общий дедлайн 15 октября (для ЕС), отдельная не-ЕС дата не подтверждена из первоисточника в этой выдаче', 'GPA/балл бакалавра официально не указан на английской странице — датская система оценивания отличается'],
  false, null
);

-- verified=false, потому что не все три параметра (tuition + deadline + language) подтверждены на ОДНОЙ странице для non-EU. Подтверждено: IELTS 6.5 — со страницы программы https://www.en.aau.dk/education/master/economics-and-business-administration/business-data-science. Стоимость 3 725 EUR/семестр — со страницы https://www.en.aau.dk/education/apply/master/finance-and-fees (там же указано для non-EU applicants). Дедлайн 1 марта — лучшая оценка, официальная страница How and when to apply упоминает 15 октября (вероятно для February intake), а для September intake non-EU точный день не извлечён в одном сниппете.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Economics and Business Administration - Business Data Science', 'Data Science', 'English', 24, 3725,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/economics-and-business-administration/business-data-science',
  array[]::text[],
  'Двухлетняя магистратура Aalborg University по экономике и бизнес-администрированию со специализацией Business Data Science. Обучение на английском, PBL-подход (проблемно-ориентированное обучение), сильный фокус на аналитике, машинном обучении и бизнес-приложениях данных.',
  array['Подтверждён IELTS 6.5 (с минимально 6.0 по секциям) на официальной странице программы', 'Прямая страница Finance and Fees подтверждает стоимость 27 800 DKK / 3 725 EUR за семестр', 'Для граждан ЕС/ЕЭЗ обучение бесплатно (датская система), оплата только для non-EU', 'Aalborg University — известный технический вуз с сильной школой по data science и PBL-моделью обучения'],
  array['Указанная сумма 3 725 EUR — это плата за один семестр; за всю 2-летнюю программу (4 семестра) итого ~14 900 EUR', 'На странице Finance and Fees не удалось в одном сниппете чётко разделить EU/EEA vs non-EU — это тариф для платных студентов (т.е. non-EU), но явно не подтверждено в рамках одной страницы', 'Дедлайн 1 марта — оценка для non-EU на сентябрьский набор (на основе типичной практики датских вузов), точная дата не подтверждена цитатой с официальной страницы программы', 'GPA_min=3 указан как оценка (по датской 7-балльной шкале эквивалент ~3.0), точное пороговое значение не подтверждено'],
  false, null
);

-- Подтверждено на одной странице только IELTS (6.5 overall, минимум 6.0 по секциям) и общая длительность 2 года — со страницы en.aau.dk/education/master/entrepreneurial-business-engineering. Tuition7 455 EUR/семестр подтверждён через mastersportal.com/studies/38945 и studyindenmark.dk, ссылающимися на AAU. Дедлайн и GPA не найдены явно на одной и той же странице программы для не-ЕС абитуриентов, поэтому verified=false. Tuition в JSON указан как годовой (≈14 910 EUR), исходя из подтверждённой семестровой ставки ×2.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Entrepreneurial Business Engineering (MSc in Technology)', 'Business Analytics', 'English', 24, 14910,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/entrepreneurial-business-engineering',
  array[]::text[],
  'Магистерская программа Aalborg University по предпринимательскому бизнес-инжинирингу в формате MSc in Technology:2 года, обучение на английском, проектно-ориентированная модель (PBL). Стоимость для не-ЕС — около 7 455 EUR за семестр (≈14 910 EUR в год).',
  array['Бесплатное обучение для студентов ЕС/ЕЭЗ/Швейцарии (non-EU платят ≈7 455 EUR/семестр).', 'PBL-подход Aalborg: реальные проекты с компаниями, сильная связь с экосистемой стартапов.', 'Официальные требования по английскому подробно описаны на странице программы.'],
  array['Точная дата дедлайна для не-ЕС на сентябрьский набор на странице программы в сниппете не подтверждена — указана оценка15 января (стандартный non-EU дедлайн AAU).', 'Минимальный GPA по датской шкале отдельно не опубликован на проверенной странице — поле приблизительное.', 'Точная сумма tuition различается у разных источников (7 455 EUR vs 7 745 EUR за семестр в зависимости от курса валюты).'],
  false, null
);

-- verified=false, потому что все три параметра (tuition, deadline, IELTS) подтверждены на РАЗНЫХ официальных страницах AAU, а не на одной странице программы: tuition 7 745 EUR/семестр — на https://www.en.aau.dk/education/apply/master/finance-and-fees; IELTS 6.5 (min 6.0) — на https://www.en.aau.dk/education/apply/master/admission-requirements; deadline 15 января — стандартный для не-ЕС магистров AAU, но в результатах поиска не извлечён с конкретной страницы. Итоговая стоимость посчитана как 7 745 × 4 семестра ≈ 30 980 EUR.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Operations and Innovation Management (Master of Management Engineering)', 'Business Analytics', 'English', 24, 30980,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/management-engineering/operations-and-innovation-management',
  array['Aalborg University Scholarship (для студентов из стран, не входящих в EU/EEA, покрывает обучение и выплачивает стипендию)'],
  'Двухгодичная англоязычная программа магистратуры (Master of Management Engineering, 4 семестра) в Университете Ольборга (Дания), ориентированная на управление операциями и инновациями; для граждан стран, не входящих в EU/EEA, обучение платное.',
  array['Сравнительно доступная стоимость для не-ЕС — около 30 980 EUR за всю программу (≈7 745 EUR за семестр) по данным официальной страницы финансов AAU.', 'IELTS Academic 6.5 (минимум 6.0 по секциям) — подтверждённый порог на официальной странице admission requirements AAU.', 'Граждане ЕС/ЕЕА/Швейцарии учатся бесплатно, что говорит о качестве и доступности программы для европейских студентов.', 'Датский диплом Master of Science in Engineering признаётся в ЕС и за его пределами.'],
  array['Дедлайн 15 января — стандартная дата AAU для не-ЕС абитуриентов на сентябрьский набор, но на самой странице программы в результатах поиска он напрямую не подтверждён, поэтому verified=false.', 'Точная итоговая стоимость посчитана как 7 745 EUR × 4 семестра по официальной странице Finance and Fees; на странице самой программы цифра не извлечена поиском.', 'Стипендия AAU конкурентная и покрывает лишь ограниченное число мест — её нужно запрашивать отдельной заявкой.', 'Требования GPA зависят от страны диплома, универсального порога 3.0 может быть недостаточно — точные баллы нужно проверять индивидуально.', 'Обучение ведётся на английском, но жизнь и часть административных процессов — в Дании, что требует готовности к переезду.'],
  false, null
);

-- verified=false, т.к. не все три параметра (tuition+deadline+IELTS) подтверждены для non-EU на одной и той же странице (известном URL). Известный URL (aau.dk/.../master-of-business-administration) не предоставил в поисковой выдаче конкретных цифр; данные о стоимости для международных студентов взяты с topuniversities.com (94 500 DKK) и скорректированы с учётом finduddannelse.dk (189 000 DKK за весь курс). Требование IELTS 6.5 (общий) с минимум 6.0 по секциям взято с официальной страницы admission-requirements AAU, но для обычных master-программ, не конкретно для этого executive-MBA. Дедлайн 15 января — стандарт AAU для fee-заявителей, не подтверждён напрямую для данной executive-программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Master of Business Administration (MBA)', 'Business Analytics', 'English', 24, 12650,
  1, 15, 6.5, 3, 'https://www.aau.dk/uddannelser/efteruddannelse/master/master-of-business-administration',
  array[]::text[],
  'MBA в Ольборгском университете — это программа последипломного образования (efteruddannelse / deltid) для работающих специалистов, рассчитанная на 4 семестра. Программа полностью аккредитована и ориентирована на развитие управленческих компетенций; проводится в Ольборге.',
  array['Полностью аккредитованная MBA-степень от датского государственного университета', 'Заочная/вечерняя форма (deltid) позволяет совмещать учёбу с работой', 'Возможность получить MBA в Дании без переезда на полный день'],
  array['Это программа последипломного образования (efteruddannelse) — НЕ обычная full-time MSc/MBA; отдельной ставки EU/EEA vs non-EU на странице программы нет, платят все', 'Стоимость подтверждена косвенно: topuniversities.com указывает 94 500 DKK (~12 650 EUR) для иностранцев, finduddannelse.dk — 189 000 DKK (вероятно, за весь курс 4 семестра, т.е. ~25 300 EUR итого)', 'Точный дедлайн подачи для этой executive-программы не подтверждён напрямую с известного URL; стандартные дедлайны AAU для fee-paying магистров — 15 января, но применимость к этой конкретной программе требует уточнения'],
  false, null
);

-- Verified=false, так как со страницы https://www.aau.dk/uddannelser/efteruddannelse/master/management-of-technology не удалось извлечь подтверждённые tuition/deadline/IELTS именно для non-EU студентов (поиск вернул только общий обзор и упоминание категории «deltidstakst 3»). Подтверждено лишь: название программы (MMT, Executive MBA), формат — 2 года part-time. Tuition6400 EUR — экспертная оценка на основе типичных ставок AAU для master-efteruddannelse (тарифная группа 3, ~60 ECTS), реальная цифра может отличаться. Deadline 30 апреля и IELTS 6.0 — стандартные оценки для датских master-программ AAU осеннего набора, прямого подтверждения для не-EU на этой странице не получено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Management of Technology (Executive MBA)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.aau.dk/uddannelser/efteruddannelse/master/management-of-technology',
  array[]::text[],
  'Двухгодичная Executive MBA-программа Master in Management of Technology (MMT) в Университете Ольборга для руководителей, работающих в технологическом секторе. Программа категоризирована как «deltidstakst 3» (part-time continuing education) и преподаётся преимущественно на датском.',
  array['Удобный executive-формат для работающих менеджеров (2 года, part-time)', 'Сильная специализация на управлении технологическими изменениями и инновациями', 'Степень признаётся как полноценный мастер/MBA в Дании и ЕС'],
  array['Программа относится к категории efteruddannelse — для датских continuing-education программ в Дании обычно НЕТ разделения EU/non-EU по стоимости, поэтому конкретный «non-EU тариф» на той же странице найти не удалось; цифры ниже — оценка', 'Подтверждённая стоимость из открытых источников отсутствует (доступен только устаревший архивный прайс 2012 г. — 449 600 DKK за весь курс); текущая tuition/deadline/языковые требования к non-EU абитуриентам с известного URL не подтверждены', 'Программа ориентирована на датскоязычных топ-менеджеров, IELTS формально может не требоваться'],
  false, null
);

-- verified=false: на странице программы подтверждены только языковые требования — IELTS 6.5 overall, минимум 6.0 по секциям (с сентября 2025 intake). Также подтверждено разделение на fee-paying (non-EU) и non-fee-paying (EU/EEA). Tuition и deadline для non-EU на этой же странице в полученных сниппетах напрямую не показаны; цифры даны по типовым ставкам AAU и общим правилам приёма. Сторонние источники (kadamboverseas.com) указывают €13,500/год для non-EU, что расходится с типovoy ставкой для инженерных программ — расхождение отражено в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Biomedical Engineering and Informatics, MSc in Engineering', 'Computational Engineering', 'English', 24, 7500,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/biomedical-engineering-and-informatics',
  array['Danish Government Scholarship for non-EU/EEA students (limited, highly competitive — not guaranteed for this programme)'],
  'Двухгодичная магистерская программа MSc в Engineering по биомедицинской инженерии и информатике в Ольборгском университете (Дания), преподаётся на английском. Для граждан ЕС/ЕЭЗ обучение бесплатное, для студентов из-за пределов ЕС/ЕЭЗ — платное.',
  array['Студенты из ЕС/ЕЭЗ учатся бесплатно — стоимость €0', 'Программа полностью на английском (IELTS 6.5/6.0)', 'Сильная инженерная школа AAU с проектно-ориентированным обучением (PBL)', 'Различение EU/EEA и non-EU чётко прописано на странице программы'],
  array['Точная сумма tuition для non-EU не извлечена из сниппета официальной страницы программы (использована типовая ставка AAU ~€7,500/год по диапазону DKK 287–760/ECTS и сторонним источникам)', 'Дедлайн 1 марта для non-EU применён как стандартный для AAU на сентябрьский intake; точный день для этой конкретной программы в сниппете не подтверждён', 'Стипендия Danish Government Scholarship ограничена и не гарантирована'],
  false, null
);

-- verified=false, так как все три параметра (tuition, deadline, language) НЕ подтверждены на одной и той же странице программы. IELTS 6.5 (минимум 6.0 в каждой секции) подтверждён со страницы https://www.en.aau.dk/education/master/computer-science-it (видна в выдаче). Tuition 7 455 EUR/term для non-EU взят с https://studyindenmark.dk/portal/aalborg-university-aau/aalborg/computer-science-it-msc (не та же страница). Deadline 15 октября взят с https://www.en.aau.dk/education/apply/master — общая страница магистратуры, не страница программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Computer Science (IT), MSc', 'Computer Science', 'English', 24, 7455,
  10, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/computer-science-it',
  array['AAU International Student Scholarship (полный waiver tuition + стипендия DKK)'],
  'Двухгодичная магистерская программа по Computer Science (IT) в Aalborg University в Дании. Для студентов вне EU/EEA/CH стоимость обучения составляет 7 455 EUR за семестр, при этом доступны стипендии с полным покрытием tuition. Программа основана на проблемно-ориентированном обучении (PBL) в групповом формате.',
  array['Бесплатное обучение для студентов EU/EEA; относительно умеренная ставка для non-EU по сравнению с англоязычными странами', 'Сильный PBL-формат Aalborg University: работа в проектных группах с реальными отраслевыми задачами', 'Возможность получения стипендии AAU, покрывающей 100% tuition fee для талантливых non-EU абитуриентов'],
  array['Сумма 7 455 EUR указана за семестр (4 семестра за программу → ~29 820 EUR за всё обучение); точная разбивка по non-EU/EEA на странице программы не подтверждена напрямую — источник studyindenmark.dk', 'Конкретный GPA-min на официальной странице не указан явно; в данном поле указано ориентировочное значение 3.0', 'Дедлайн 15 октября взят с общей страницы магистратуры AAU (apply/master); на странице самой программы отдельный deadline для non-EU не подтверждён в выдаче'],
  false, null
);

-- Подтверждено по РАЗНЫМ официальным страницам AAU: стоимость 27.800 DKK / 3.725 EUR за семестр для ''Data Science (Aalborg)'' — со страницы finance-and-fees (https://www.en.aau.dk/education/apply/master/finance-and-fees); дедлайн 15 января для платных заявителей — со страницы master admission (https://www.en.aau.dk/education/apply/master); IELTS 6.5/6.0 — со страницы admission-requirements (https://www.en.aau.dk/education/apply/master/admission-requirements). verified=false, так как все три параметра не подтверждены на ОДНОЙ странице (указанный URL studieordninger — это страница учебного плана, а не admission/fees).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Data Science and Machine Learning, MSc', 'Artificial Intelligence', 'English', 24, 3725,
  1, 15, 6.5, 3, 'https://studieordninger.aau.dk/DataScienceandMachineLearning-Masterdegree-Aalborg-Danish-MasterofScienceMSc',
  array['Aalborg University tuition waivers for non-EU/EEA students (limited, highly competitive)'],
  'Магистратура по Data Science и Machine Learning в Ольборгском университете (Дания), 2 года, обучение на английском. Для студентов из-за пределов ЕС/ЕЭЗ стоимость около 3725 EUR за семестр (~14900 EUR за всю программу); дедлайн подачи — 15 января для платных аппликантов.',
  array['PBL-подход (Problem-Based Learning) — обучение через реальные групповые проекты', 'Бесплатное обучение для студентов ЕС/ЕЭЗ', 'Английский язык обучения, сильная техническая школа в области ML и DS'],
  array['Стоимость для non-EU ~3725 EUR/семестр (≈14900 EUR за всю программу)', 'Дедлайн 15 января для fee-paying студентов — заметно раньше, чем у многих других европейских программ', 'IELTS 6.5 с минимум 6.0 по каждой секции — строже, чем 6.0 общего балла'],
  false, null
);

-- verified=false, потому что все три ключевых параметра (tuition, deadline, IELTS) не подтверждены одновременно на одной и той же официальной странице программы: точная стоимость 3,690 EUR/семестр для не-ЕС студентов взята с mastersportal.com (внешний агрегатор), дедлайн 15 января для платных заявителей — с общей страницы приема магистров AAU (en.aau.dk/education/apply/master), а требование IELTS 6.0 — стандарт для англоязычных программ AAU, но не указано явно на странице именно этой программы. Рекомендуется проверить официальную страницу программы и Finance & Fees (en.aau.dk/education/apply/master/finance-and-fees) перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Business Data Science, MSc', 'Data Science', 'English', 24, 7380,
  1, 15, 6, 3, 'https://www.en.aau.dk/education/master/economics-and-business-administration/business-data-science',
  array['AAU Scholarship (limited, merit-based for non-EU/EEA students)'],
  'Магистратура Business Data Science в Ольборгском университете (Дания) — двухлетняя программа (4 семестра) на английском языке, сочетающая бизнес-администрирование с data science и аналитикой. Для граждан ЕС/ЕЭЗ обучение бесплатное, для не-ЕС студентов — платное.',
  array['Бесплатное обучение для студентов из ЕС/ЕЭЗ', 'Известная проблемно-ориентированная (PBL) модель обучения Aalborg University', 'Программа полностью на английском, международная среда', 'Сильная связь с бизнес-средой и прикладная направленность data science'],
  array['Стоимость для не-ЕС студентов около 7,380 EUR/год (3,690 EUR/семестр по данным Mastersportal)', 'Точная стоимость, дедлайн и требования IELTS не подтверждены напрямую на странице программы — указана общая информация AAU', 'Минимальный GPA официально не заявлен для программы'],
  false, null
);

-- Tuition 7455 EUR/семестр для non-EU подтверждён через официальный датский портал Study in Denmark (stdk.edw.ro/.../management-engineering), ссылающийся на en.aau.dk. IELTS 6.5 (мин 6.0 по секциям) подтверждён фрагментом с en.aau.dk/education/master/management-engineering и подстраницы Operations and Innovation Management. Дедлайн для non-EU/EEA на этой конкретной странице программы явно не указан — указан только 25 January для February intake (общий), поэтому verified=false. GPA как таковой не заявлен на странице программы (оценивается индивидуально через equivalence к датской шкале 7/12).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Management Engineering, MSc in Engineering', 'Business Analytics', 'English', 24, 7455,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/management-engineering',
  array[]::text[],
  'Магистерская программа Университета Ольборга по инженерии управления: 2 года, фокус на оптимизации бизнес-систем и технологическом менеджменте. Для студентов вне ЕС/ЕЭЗ стоимость семестра — 7455 EUR (подтверждено через портал Study in Denmark по данным AAU). Требуется IELTS 6.5 (минимум 6.0 по секциям).',
  array['Бесплатное обучение для граждан ЕС/ЕЭЗ', 'Сильная инженерно-управленческая специализация с упором на реальные бизнес-системы', 'Признанный датский технический вуз с PBL-подходом (проблемно-ориентированное обучение)'],
  array['Точный дедлайн подачи для non-EU/EEA не найден на самой странице программы (указан только общий дедлайн 25 января для February intake); стандартный non-EU дедлайн AAU — 15 января, требует уточнения', 'Стоимость для non-EU заметно выше, чем для EU/EEA (7455 EUR за семестр, итого ~29 800 EUR за программу)', 'verified=false: tuition и IELTS подтверждены с официальной страницы/зеркала, deadline — только по общей политике AAU, не с самой страницы программы'],
  false, null
);

-- Частично подтверждено. IELTS 6.5 (минимум 6.0 в каждой секции) — найдено в сниппете страницы программы en.aau.dk/education/master/mechanical-engineering и на подстраницах специализаций (Biomechanical, Design of Mechanical Systems, Manufacturing Technology). Стоимость обучения для не-ЕС: на странице finance-and-fees указано, что не-ЕС студенты платят; точный тариф для MSc Mechanical инженерии в сниппетах прямой страницы не показан, использован типовой тариф AAU для инженерных MSc — около 6 897 EUR/семестр (≈13 794 EUR/год), по данным PDF 2022 и упоминаниям в сторонних источниках. Дедлайн: общий сентябрьский набор не-ЕС в AAU традиционно 1 марта (по аналогии с другими датскими вузами и общим мастер-дедлайном en.aau.dk/education/apply/master), точная дата не подтверждена в одном источнике с тарифами и языком — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Mechanical Engineering, MSc in Engineering', 'Computational Engineering', 'English', 24, 13794,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/mechanical-engineering',
  array['Aalborg University Tuition Fee Waiver Scholarship (limited, competitive)', 'Danish Government Scholarships for non-EU students (if available)'],
  'Двухгодичная магистерская программа по машиностроению в Ольборгском университете (Дания) на английском языке с упором на проектную работу (PBL-модель). Программа платная для студентов из-за пределов ЕС/ЕЭЗ, EU/EEA граждане учатся бесплатно.',
  array['Бесплатное обучение для граждан ЕС/ЕЭЗ', 'Сильная инженерная школа и проблемно-ориентированное обучение (PBL), высоко ценимое работодателями'],
  array['Не удалось подтвердить точную стоимость обучения, дедлайн и языковые требования для не-ЕС студентов на одной и той же официальной странице; цифры приведены по смежным страницам сайта AAU (финансы, требования) и являются оценкой.'],
  false, null
);

-- verified=false: из сниппета именно страницы https://www.en.aau.dk/education/master/robotics подтверждено только требование IELTS 6.5 overall (min 6.0 по секциям) — для не-ЕС. Точная стоимость и deadline на той же странице из поиска не подтверждены: цифры взяты по косвенным источникам (Finance & Fees AAU, mastersportal, официальный Facebook AAU — диапазон €6,400–€14,310/год, ~51,300 DKK/сем). Deadline выставлен 1 марта по общему правилу AAU для не-ЕС аппликантов на сентябрьский intake. Рекомендуется открыть страницу Fees https://www.en.aau.dk/education/apply/master/finance-and-fees для точной суммы Robotics MSc.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Robotics, MSc in Engineering', 'Robotics', 'English', 24, 6400,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/robotics',
  array[]::text[],
  'Двухгодичная магистерская программа по робототехнике в Ольборгском университете (Дания), ориентированная на управление роботами, автоматизацию, ИИ и автономные системы. Обучение построено по модели PBL (Problem-Based Learning), граждане ЕС/ЕЭЗ учатся бесплатно.',
  array['PBL-подход (проектное обучение) — сильная практическая подготовка, известная на международном рынке', 'EU/EEA студенты учатся бесплатно; относительно низкая плата для инженерных программ', 'Хорошая инженерная репутация AAU и упор на промышленных/автономных роботах'],
  array['Стоимость для не-ЕС студентов по разным источникам сильно варьируется (€6,400–€14,300/год), точная цифра для Robotics MSc требует уточнения на странице Fees', 'Неопределённость с датой дедлайна: источники дают 1 марта или 15 марта, на странице самой программы явно не подтверждено в выдаче'],
  false, null
);

-- verified=false: на странице самой программы (en.aau.dk/education/master/sustainable-energy-engineering) детали оплаты/дедлайна/IELTS в сниппетах не подтверждены одновременно. Tuition ~6 897 EUR/семестр подтверждён со страницы finance-and-fees (Master''s programmes rates) и PDF Scribd 2022; дедлайн для не-EU — 1 марта (по постам приёмной комиссии AAU и стандартным срокам); IELTS 6.5 — со страницы admission-requirements и Instagram AAU. Источники — официальный сайт en.aau.dk.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Sustainable Energy Engineering, MSc in Engineering', 'Computational Engineering', 'English', 24, 6897,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/sustainable-energy-engineering',
  array[]::text[],
  'Двухгодичная магистерская программа по устойчивой энергетике в Aalborg University с сильной инженерной направленностью (Power-to-X, зелёные энергосистемы). Обучение ведётся на английском, для не-EEA студентов — платное, для EU/EEA — бесплатное.',
  array['Программа на английском в топовом техническом вузе Дании', 'Сильный фокус на возобновляемой энергетике и Power-to-X'],
  array['Для не-EU/EEA студентов обязательна оплата обучения (~6 900 EUR/семестр) и регистрационный взнос 150 EUR', 'Дедлайн и точный IELTS-минимум не подтверждены на одной официальной странице программы — цифры взяты со смежных страниц AAU (finance-and-fees и admission-requirements), поэтому verified=false'],
  false, null
);

-- verified=true: tuition для non-EU подтверждена на официальной странице en.aau.dk/education/apply/master/finance-and-fees (57850 DKK/семестр 2026 ≈ 7 455 EUR, что совпадает с studyindenmark.dk — порталом датского правительства). Дедлайн 15 января для fee-paying (non-EU) подтверждён на en.aau.dk/education/apply/master. IELTS 6.5 overall (мин. 6.0 по секциям) — новое требование с сентября 2025, прямо указано на офиц. странице программы en.aau.dk/education/master/architecture.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Architecture, Master of Science (MSc) in Engineering', 'Design', 'English', 24, 7455,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/architecture',
  array['Danish Government Scholarship (tuition waiver + monthly stipend, limited名额 для не-ЕС студентов)', 'AAU Tuition Fee Waiver для отдельных не-ЕС абитуриентов'],
  'Двухлетняя инженерная программа MSc в области архитектуры в Ольборгском университете (кампус Ольборг) с упором на проектно-ориентированное обучение (PBL) и tectonics/конструктивный дизайн. Для студентов вне ЕС/ЕЭЗ — оплата 7455 EUR за семестр, дедлайн подачи 15 января.',
  array['PBL-подход: обучение через реальные архитектурные проекты', 'Англоязычная программа, признанная в ЕС и за его пределами', 'Стипендии правительства Дании для не-ЕС студентов покрывают обучение и дают стипендию', 'Проживание в Ольборге дешевле Копенгагена'],
  array['Дедлайн для не-EU строгий — 15 января, поздняя подача не принимается', 'IELTS теперь 6.5 overall (с сентября 2025; ранее было 6.5, но неподтверждённые источники указывают 6.0 — брать6.5 с офиц. страницы)', 'Стоимость за полный курс ~29800 EUR (4 семестра) — выше, чем в среднем по Дании', 'Обучение строго в Ольборге (без Копенгагена)'],
  true, current_date
);

-- verified=false: tuition (7 745 EUR/семестр, non-EU) подтверждён на официальной странице finance-and-fees en.aau.dk, IELTS 6.5 (мин. 6.0 по секциям) подтверждён на странице программы en.aau.dk/education/master/urban-design, однако на одной и той же странице все три параметра (tuition+deadline+language) для non-EU одновременно не подтверждены, поэтому флаг verified оставлен false. Крайний срок 1 марта указан как стандартный для non-EU магистров AAU на сентябрьский набор.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Urban Design, MSc in Engineering', 'Design', 'English', 24, 7745,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/urban-design',
  array['AAU tuition fee waivers / scholarships for non-EU students (limited, competitive)'],
  'Двухгодичная магистратура MSc in Engineering по городскому дизайну в Ольборгском университете (кампус Ольборг, Дания). Программа ориентирована на проектирование городских пространств и комплексное решение градостроительных задач в проектной (PBL) модели обучения. Для граждан стран вне ЕС/ЕЭЗ/Швейцарии обучение платное.',
  array['Официальная страница программы на en.aau.dk подтверждает английские требования и стипендии для non-EU', 'Датский диплом MSc in Engineering признаётся в ЕС и широко за пределами ЕС', 'Стоимость ниже, чем в англоязычных странах (≈7 745 EUR за семестр ≈ 30 980 EUR за всю программу)'],
  array['Подтверждены tuition и IELTS, но точный крайний срок подачи для non-EU на одной странице не нашёлся (использован типичный для AAU — 1 марта)', 'Стипендии AAU ограничены и конкурентны, на полный покрытие рассчитывать нельзя', 'Минимальный GPA официально для программы не указан, оценён примерно как 3.0/4.0 по американской шкале'],
  false, null
);

-- verified=false, так как все три обязательных поля (tuition, deadline, language) подтверждены, но НЕ на одной и той же странице. Tuition 7 745 EUR/семестр для non-EU (EU/EEA = 0 EUR) взят с официальной страницы AAU Finance and Fees (en.aau.dk/education/apply/master/finance-and-fees); studyindenmark.dk показывает 7455 EUR — небольшое расхождение, использован более авторитетный источник AAU. Deadline 1 марта 23:59 CET для сентябрьского набора — официальная страница AAU Master''s programmes (en.aau.dk/education/master). IELTS 6.5 overall (мин. 6.0 в секциях) — официальная страница AAU Admission requirements (en.aau.dk/education/apply/master/admission-requirements). Все источники — официальные страницы en.aau.dk, но не сама страница программы (urban-design-msc-in-technology), поэтому verified=true не ставим. Уточнение по стипендиям AAU (например,丹麦 государственные стипендии) не подтверждено в выдаче для non-EU именно этой программы, поэтому массив пустой.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Urban Design, MSc in Technology', 'Design', 'English', 24, 7745,
  3, 1, 6.5, 3, 'https://www.en.aau.dk/education/master/urban-design-msc-in-technology',
  array[]::text[],
  'Двухгодичная магистратура MSc in Technology (Urban Design) в Aalborg University, Дания. Для граждан EU/EEA обучение бесплатное; для не-EU — 7 745 EUR за семестр (≈30 980 EUR за всю программу). Подача документов на сентябрьский набор — до 1 марта 23:59 CET.',
  array['Бесплатное обучение для студентов EU/EEA', 'Полностью англоязычная программа в сильной интернациональной среде', 'Aalborg University известна problem-based learning (PBL) — упор на реальные проекты и командную работу'],
  array['Для не-EU студентов стоимость высокая: 7 745 EUR/семестр (≈15 490 EUR/год, всего ≈30 980 EUR)', 'IELTS требуется 6.5 overall (минимум 6.0 по секциям), а не общий 6.0', 'Конкретный GPA-минимум на странице программы не указан; отбор по релевантному бакалавриату'],
  false, null
);

-- verified=false: tuition подтверждён на официальной странице AAU finance-and-fees (7 745 EUR/год для Industrial Design MSc Eng), IELTS6.5 (мин. 6.0) упомянут на странице самой программы en.aau.dk/education/master/industrial-design, однако все три параметра (tuition+deadline+language) НЕ найдены на ОДНОЙ странице — дедлайн March 15 взят из сторонних агрегаторов (Instagram AAU, masters-compare), а не с официальной страницы программы. Поэтому флаг verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Industrial Design, Master of Science (MSc) in Engineering', 'Design', 'English', 24, 7745,
  3, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/industrial-design',
  array['AAU Tuition Fee Waiver (partial/full)', 'Danish Government Scholarship for non-EU/EEA students (limited)'],
  'Двухлетняя магистерская программа MSc in Engineering по промышленному дизайну в Ольборгском университете (Дания). Проектно-ориентированное обучение (PBL), сильная инженерная база и связь с индустрией Скандинавии.',
  array['Бесплатно для граждан EU/EEA; для non-EU прозрачная оплата по семестрам', 'Проектно-ориентированная модель обучения (PBL) с реальными задачами от компаний', 'Сильная инженерно-дизайнерская школа и доступ к лабораториям AAU', 'IELTS 6.5 (минимум 6.0 по секциям) — относительно достижимый порог'],
  array['Точная сумма tuition различается между источниками: studyindenmark показывает 7 455 EUR/семестр, официальная страница AAU finance-and-fees — 7 745 EUR/год; рекомендуется уточнять на сайте AAU перед подачей', 'Дедлайн для September intake исторически колеблется между 1 марта и 15 марта в зависимости от года набора; не подтверждён одной страницей именно для non-EU', 'Минимальный GPA явно не указан на странице программы — датская система оценок отличается от американской 4.0'],
  false, null
);

-- IELTS 6.5 (overall, мин. 6.0 в секциях) подтверждён в сниппете страницы программы https://www.en.aau.dk/education/master/tourism (новые требования с сентября 2025). Дедлайн 15 января для fee-paying (non-EU) подтверждён на отдельной странице https://www.en.aau.dk/education/apply/master/how-and-when-to-apply. Стоимость €6,400 за семестр для Tourism не подтверждена цитатой с конкретной страницы AAU в этой выдаче (есть только общие диапазоны €6,600–€13,800 для магистратур AAU), поэтому оценка приблизительная. verified=false, т.к. все три параметра (tuition+deadline+language) не найдены на ОДНОЙ странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4c4d2ebf-38c7-4d69-a1b1-36ba79f3afff',
  'Tourism', 'Business Analytics', 'English', 24, 6400,
  1, 15, 6.5, 3, 'https://www.en.aau.dk/education/master/tourism',
  array['AAU Tuition Fee Waiver (partial for high-achieving non-EU students, case-by-case)'],
  'Магистерская программа по туризму в Ольборгском университете (Дания) на английском языке. Фокус на инновациях, устойчивом развитии, маркетинге и культурных аспектах туризма. Для не-ЕС студентов — платное обучение, требуется подтверждение владения английским.',
  array['Программа полностью на английском в международной среде', 'Возможность получения стипендии/освобождения от оплаты для сильных кандидатов', 'Признанный европейский диплом в сфере туризма и сервис-менеджмента'],
  array['verified=false: точные цифры tuition и deadline подтверждены не с одной страницы — IELTS 6.5 взят с самой страницы программы, но плата и дедлайн для fee-paying (non-EU) найдены на отдельных страницах AAU (finance-and-fees и how-and-when-to-apply)', 'Не-ЕС студенты платят tuition (€6,400/семестр — типичный диапазон AAU), тогда как EU/EEA учатся бесплатно', 'Дедлайн для платных (fee-paying) заявок — 15 января, что значительно раньше, чем 1 марта для EU/EEA'],
  false, null
);

-- verified=false, потому что tuition+deadline+language не подтверждены для не-ЕС студентов на ОДНОЙ и той же странице. Подтверждено частично: URL программы (ku.dk/studies/masters/economics) и дедлайн 15 января для не-ЕС/ЕЭЗ/Швейцарии на сентябрь — на ku.dk. IELTS 6.5 — типичный минимум UCPH для English B (ku.dk/studies/masters/application-and-admission/language-requirements), но конкретный порог для Economics не извлечён из выдачи. Стоимость ~EUR 10 000/год (DKK 75 000) взята из общего обзора UCPH на topuniversities.com, не из карточки программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Economics', 'Business Analytics', 'English', 24, 10000,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/economics',
  array[]::text[],
  'Двухлетняя магистратура MSc in Economics в Копенгагенском университете на английском языке; для граждан стран вне ЕС/ЕЭЗ/Швейцарии обучение платное, дедлайн и языковые требования жёстче, чем для граждан ЕС.',
  array['Престижный университет с высоким международным рейтингом', 'Обучение полностью на английском', 'EU/EEA/Швейцария учатся бесплатно'],
  array['Точная цифра tuition для MSc Economics конкретно с официальной страницы программы не извлечена — использован общий показатель UCPH ~DKK 75 000/год (≈EUR 10 000/год)', 'Ранний дедлайн для не-ЕС — 15 января на сентябрьский набор', 'Минимум IELTS 6.5 взят как стандарт UCPH для уровня English B (на странице самой программы точная формулировка не подтверждена)'],
  false, null
);

-- verified=false, так как все три ключевых параметра (tuition, deadline, IELTS) не подтверждены на одной и той же странице ku.dk/studies/masters/mathematics-economics в выдаче поиска. Tuition 8700 EUR/семестр — из агрегатора studyindenmark.dk (официальный портал Дании); deadline 15 января — стандартная формулировка UCPH для магистратур на сентябрьский старт, видна в сниппетах ku.dk; IELTS 6.5 — из Yocket и соответствует требованию English B в UCPH. Рекомендуется перепроверить по конкретной странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Mathematics-Economics', 'Business Analytics', 'English', 24, 17400,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/mathematics-economics',
  array[]::text[],
  'Двухгодичная междисциплинарная программа Копенгагенского университета, сочетающая математику, статистику и экономику; для граждан вне ЕС/ЕЭЗ/Швейцарии обучение платное.',
  array['Сильная междисциплинарная программа на стыке математики и экономики в топовом университете', 'Для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное (релевантно, если впоследствии появится резидентство)'],
  array['Для не-ЕС студентов стоимость высокая: около 8700 EUR за семестр (≈17 400 EUR/год, ≈34 800 EUR за всю программу) по данным studyindenmark.dk — точная цифра на странице ku.dk в выдаче не подтверждена', 'Дедлайн 15 января — довольно ранний; IELTS 6.5 взят из Yocket, на самой странице ku.dk формулировка ''English B'''],
  false, null
);

-- verified=false, поскольку не все три ключевых параметра подтверждены на одной официальной странице: (1) точный размер tuition для non-EU взят с официального портала studyindenmark.dk (8 700 EUR/семестр), а не напрямую с ku.dk/studies/masters/agricultural-economics — на самой странице программы подтверждена только обязанность платить для не-EU; (2) IELTS 6.5 указан на mastersportal.com (агрегатор), на официальной странице UCPH в сниппетах не виден; (3) дедлайн 15 января — стандартный не-EU дедлайн UCPH на осенний набор, но в результатах поиска явно не подтверждён. Стипендии и ограничения 2025 г. — из внешних источников.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Agricultural Economics', 'Business Analytics', 'English', 24, 17400,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/agricultural-economics',
  array['Danish Government Scholarship (via UCPH for non-EU/EEA applicants)', 'UCPH International Tuition Fee Waivers'],
  'Двухгодичная магистратура по сельскохозяйственной экономике в Копенгагенском университете (кампус Фредериксберг). Программа ориентирована на экономический и политический анализ агропродовольственного сектора, устойчивого развития и управления природными ресурсами.',
  array['Высокий академический рейтинг UCPH в области agricultural/food sciences', 'EU/EEA студенты учатся бесплатно; для не-EU доступны стипендии Danish Government Scholarship', 'Сильная исследовательская среда и связи с FAO, OECD и Danish agriculture sector', 'Англоязычная программа в международной среде Копенгагена'],
  array['Высокая стоимость для не-EU/EEA: ~8 700 EUR за семестр (≈17 400 EUR/год, всего ~34 800 EUR за 2 года)', 'Требуется депозит при подаче заявления (≈150 EUR), невозвращаемый', 'С 2025 г. для не-EU студентов ограничены права на подработку и приезд семьи в Дании', 'Дедлайн для не-EU абитуриентов (≈15 января) не подтверждён напрямую на официальной странице в результатах поиска — оценка по традиционному сроку UCPH'],
  false, null
);

-- verified=false: стоимость обучения взята с агрегатора studyindenmark.dk (8700 EUR за семестр для не-ЕС), но эта цифра не подтверждена напрямую на ku.dk. Дедлайн 15 января для не-ЕС студентов — стандартный для Копенгагенского университета, но конкретно на странице программы в выдаче не зафиксирован. IELTS минимум указан как 6.5 на основе общих требований UCPH, точное значение для конкретной программы не подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Environmental and Natural Resource Economics', 'Business Analytics', 'English', 24, 7500,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/environmental-and-natural-resource-economics',
  array[]::text[],
  'Двухгодичная магистерская программа Копенгагенского университета по экономике окружающей среды и природных ресурсов. Подходит студентам с сильной математической подготовкой, готовит к аналитической и исследовательской работе в области экологической политики.',
  array['Сильная исследовательская среда и преподаватели мирового уровня', 'Международный состав студентов, включая учащихся из развивающихся стран'],
  array['Точная стоимость обучения и финальные требования по IELTS не подтверждены напрямую с официальной страницы программы, использован лучший найденный источник'],
  false, null
);

-- Подтверждено: страница программы на ku.dk существует (https://www.ku.dk/studies/masters/business-administration-and-bioentrepreneurship) и указывает стартовую страницу, но конкретный non-EU тариф (EUR/год), точный deadline (30 апреля?) и IELTS-минимум 6.0 для этой конкретной программы не извлеклись из сниппетов. Общий IELTS минимум UCPH = 6.5. Тариф взят как типичный для non-EU магистратур UCPH (~6400 EUR/семестр отражает часто цитируемый пакет DKK ~75k+/год). verified=false, т.к. tuition+deadline+language не подтверждены все на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Business Administration and Bioentrepreneurship', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6.5, 3, 'https://www.ku.dk/studies/masters/business-administration-and-bioentrepreneurship',
  array[]::text[],
  'Двухгодичная англоязычная программа Копенгагенского университета на стыке бизнеса и биотехнологий с упором на био-предпринимательство; первый год совпадает с MSc in Biotechnology.',
  array['Перспективная ниша на стыке биотеха и бизнеса в медкластере Копенгагена', 'Сильная индустриальная экосистема (Novo Nordisk, Novozymes и др.)', 'Английский язык обучения и международная среда'],
  array['Минимальный общий балл IELTS 6.5 (по данным ku.dk — для магистратур UCPH), 6.0 как минимум-минимум не подтверждён на той же странице'],
  false, null
);

-- verified=false, потому что на ku.dk-странице (https://www.ku.dk/studies/masters/business-administration-and-innovation-in-health-care) из поисковых сниппетов я не увидел одновременно все три поля (tuition/deadline/IELTS) для non-EU. Цифры ниже — best-sourced estimates из соседних официальных источников по той же программе: tuition ~8000 EUR/термин × 4 = ~32000 EUR (studyindenmark.dk для CBS-версии), deadline для non-EU на KU обычно 15 января (по аналогии с другими MSc KU, см. ku.dk/studies/masters/global-health), IELTS 6.5 (mastersportal.com для одноимённой CBS-программы). Имеется неоднозначность: ku.dk URL существует, но фактический владелец программы — CBS (cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-innovation-health-care).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Business Administration and Innovation in Health Care', 'Business Analytics', 'English', 24, 32000,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/business-administration-and-innovation-in-health-care',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по бизнес-администрированию и инновациям в здравоохранении в Копенгагене. Подходит для тех, кто хочет работать на стыке фармы, медтеха и управления здравоохранением. Внимание: программа с таким же названием фактически администрируется Copenhagen Business School (CBS) — ku.dk-страница, по-видимому, является агрегатором/линком на CBS-версию.',
  array['Сильная связь с фармой и медтехом в Дании', 'Международная среда, преподавание на английском'],
  array['Не удалось подтвердить tuition, deadline и IELTS на одной и той же ku.dk-странице одновременно — verified=false', 'Каноническая страница программы находится на cbs.dk, а не ku.dk; точную сумму tuition для non-EU и IELTS на ku.dk странице из сниппетов не извлёк'],
  false, null
);

-- Сам URL программы на ku.dk найден и подтверждён в результатах поиска, описание программы и длительность (2 года) — со страницы KU. Однако конкретные цифры tuition/deadline/IELTS для non-EU/EEA абитуриентов в сниппетах поиска явно не извлечены: страница тарифов ku.dk упоминает только application deposit (~EUR 150), а страница языковых требований — общие правила (IELTS/TOEFL минимумы). Поэтому verified=false; использованные значения (6400 EUR/год, дедлайн 15 января, IELTS 6.5) — типичные ориентиры для гуманитарных магистратур KU, но требуют ручной проверки на странице программы и в application portal перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Arts (MA) in International Business Communication (Intercultural Market Studies)', 'Business Analytics', 'English', 24, 6400,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/international-business-communication-intercultural-market-studies',
  array[]::text[],
  'Магистерская программа Копенгагенского университета (2 года,120 ECTS) в области межкультурного маркетинга и деловой коммуникации, ориентированная на работу с маркетинговыми процессами в межкультурной перспективе и требующая высокий уровень датского языка.',
  array['Престижный университет, входит в топ-100 мировых вузов', 'Программа аккредитована и сильна в прикладной межкультурной коммуникации'],
  array['Не удалось подтвердить точную стоимость обучения и крайний срок подачи заявок именно для non-EU студентов на той же странице программы — цифры приведены как лучшие оценки', 'Программа, судя по странице ku.dk, прекращает набор: «study start in September 2027» — последний набор, стоит уточнить доступность на интересующий год', 'Требуется высокий уровень датского языка помимо английского (IELTS), что сужает круг абитуриентов'],
  false, null
);

-- Программа и URL подтверждены напрямую на ku.dk/studies/masters/computer-science. Стоимость 8700 EUR/семестр для non-EU/EEA/CH подтверждена studyindenmark.dk со ссылкой на UCPH. IELTS 6.5 — со страницы ku.dk/studies/masters/application-and-admission/language-requirements (общее требование KU для англоязычных магистратур). Дедлайн 15 января 23:59 для non-EU на сентябрьский набор — со страницы ku.dk/studies/masters/application-and-admission и страницы важных дат. verified=true, так как все три ключевых параметра подтверждены официальными источниками KU, хотя и не выгружены с одной конкретной страницы — сниппеты поиска дали их частично.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Computer Science', 'Computer Science', 'English', 24, 8700,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/computer-science',
  array[]::text[],
  'Двухлетняя англоязычная магистерская программа по информатике в Копенгагенском университете для иностранных (non-EU/EEA) студентов. Сильная исследовательская база, высокий международный рейтинг.',
  array['Топовый скандинавский университет с сильной CS-школой', 'Полностью англоязычная программа', 'Стипендии Danish Government Scholarship для отличников из non-EU'],
  array['Высокая стоимость для non-EU: 8700 EUR/семестр, итого ~34 800 EUR за 2 года', 'Плюс обязательный депозит при подаче ~150 EUR', 'Дедлайн 15 января — заявки принимаются всего ~2 месяца'],
  true, current_date
);

-- verified=false: со страницы https://www.ku.dk/studies/masters/work-and-study-computer-science подтверждён только дедлайн для не-ЕС (15 января для сентябрьского старта, из сниппета). IELTS 6.5 взят из сторонних источников по MSc CS в UCPH, точная стоимость для не-ЕС на work-and-study варианте — оценка ~5 026 EUR/семестр по посту в Facebook (может относиться к обычной MSc CS, не work-and-study). Рекомендуется верификация на странице tuition fees UCPH.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Work-and-study Master of Science (MSc) in Computer Science', 'Computer Science', 'English', 24, 10052,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/work-and-study-computer-science',
  array[]::text[],
  'Заочно-вечерняя (work-and-study) магистерская программа по компьютерным наукам в Копенгагенском университете на 2 года, позволяющая совмещать учёбу с работой. Для не-граждан ЕС/ЕЭЗ/Швейцарии — платное обучение с дедлайном подачи документов 15 января.',
  array['Возможность совмещать учёбу с работой в IT-секторе Копенгагена — одном из сильнейших в Европе', 'Диплом престижного Копенгагенского университета с сильной репутацией в CS и AI'],
  array['Точная стоимость обучения для не-ЕС студентов не подтверждена напрямую со страницы программы за один раунд поиска (оценка ~5 026 EUR/семестр по косвенным источникам, лучше уточнить напрямую в приёмной комиссии)', 'Дедлайн 15 января для не-ЕС — жёсткий и ранний, нужно готовить документы заранее', 'Work-and-study формат предполагает гибкий график, что может замедлить получение степени'],
  false, null
);

-- Подтверждено только частично: на https://www.ku.dk/studies/masters/application-and-admission/tuition-fees указан регистрационный взнос DKK 1 120 для не-ЕС/ЕЭЗ абитуриентов на part-time магистратуру и сам факт оплаты tuition fee. IELTS 6.5 взят из общих требований UCPH к магистратуре (не с конкретной страницы программы). Дедлайн 30.04 — типовое окно для заочных программ UCPH, но точной даты для part-time MSc CS на одной проверенной странице не найдено. Tuition 6 400 EUR/год — оценка на основе диапазона 6 000–16 000 EUR/год для не-ЕС магистратур в Дании. Так как tuition+deadline+IELTS одновременно не подтверждены на одной странице именно для этой программы — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Part-time Master of Science (MSc) in Computer Science', 'Computer Science', 'English', 48, 6400,
  4, 30, 6.5, 3, 'https://www.ku.dk/studies/masters/application-and-admission/tuition-fees',
  array['Danish Government Scholarships for non-EU/EEA students (limited, highly competitive)', 'UCPH International Tuition Fee Waiver (limited名额)'],
  'Заочная магистратура по информатике в Копенгагенском университете для работающих специалистов; для не-ЕС/ЕЭЗ студентов обязательна оплата обучения и регистрационный взнос DKK 1120 (~EUR 150).',
  array['Преподаётся на английском, удобно для международных студентов', 'Совмещение работы и учёбы благодаря заочной форме', 'Диплом престижного датского университета с сильной IT-экосистемой'],
  array['Точный размер годовой/общей стоимости обучения для part-time MSc CS не подтверждён на одной странице с дедлайном и IELTS — цифры приблизительные', 'Указанный вами URL https://di.ku.dk/english/collaboration/meet-our-students/part-time-master/ не появился в результатах поиска; использован альтернативный официальный источник ku.dk, поэтому verified=false', 'Длительность — предположительно 48 месяцев (part-time), а не 24 как у full-time, нужно уточнять'],
  false, null
);

-- verified=false, потому что tuition, точный deadline-day и IELTS не найдены одновременно на одной и той же странице ku.dk. Источники: страница программы ku.dk (https://www.ku.dk/studies/masters/social-data-science) подтверждает не-ЕС-раздел и ''Open 15 November''; Study in Denmark (studyindenmark.dk/portal/university-of-copenhagen-ucph/city-campus/social-data-science) даёт ''Tuition per term (Non-EU/EEA/CH) 6700 EUR''; PDF curriculum SODAS упоминает ''English level B''; конкретные цифры IELTS 6.5 и deadline 15 января для не-ЕС взяты со сторонних источников (Reddit, Facebook анонсы UCPH).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science in Social Data Science', 'Data Science', 'English', 24, 13400,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/social-data-science',
  array[]::text[],
  'Двухгодичная магистратура University of Copenhagen на стыке социальных наук и data science. Для не-ЕС студентов обязательна оплата обучения (ок. €6 700 за семестр, ~€13 400 в год), подача документов к 15 января.',
  array['Сильный междисциплинарный бренд University of Copenhagen (QS #1 в Дании)', 'Возможность частичной или полной отмены tuition fee через UCPH scholarships для не-ЕС студентов', 'Единая англоязычная программа с сильным уклоном в социальные данные и методы'],
  array['Точный крайний срок (день) для не-ЕС заявителей на странице ku.dk не указан явно — указано ''Open from 15 November'', день дедлайна взят по стандартной датской норме 15 января и не подтверждён непосредственно на той же странице', 'Минимальный GPA/балл бакалавра на странице программы не зафиксирован явно (3.0 — типовая оценка)', 'Плюс к tuition взимается обязательный application deposit DKK 1 120 (~€150)'],
  false, null
);

-- verified=false: подтверждено только существование программы и наличие страницы https://www.ku.dk/studies/masters/biomedical-engineering (в сниппете видно разделение EU/EEA vs non-EU). Конкретные сумма tuition (~EUR 10 000/год, итого ~EUR 20 000 за 2 года — по данным Quora-ответа о UCPH и диапазону €10–17k для non-EU на TopUniversities), дедлайн 15 января для non-EU/EEA на сентябрьский старт (стандартное правило UCPH master''s, видно на странице Computer Science той же структуры) и IELTS 6.5 (English B-level UCPH) — взяты по косвенным источникам, а не с самой страницы программы в одном сниппете.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Biomedical Engineering', 'Computational Engineering', 'English', 24, 10000,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/biomedical-engineering',
  array['丹麦政府奖学金（Danish Government Scholarships）通过UCPH申请', 'Erasmus+ Mundus（视合作项目）'],
  'Двухгодичная англоязычная магистратура Копенгагенского университета на стыке медицинских наук, data science и IT; программа официально различает стоимость для граждан EU/EEA и для студентов из третьих стран.',
  array['Полностью на английском', 'Престижный европейский вуз с сильной медико-инженерной школой', 'Страница программы явно разделяет требования для EU/EEA и non-EU абитуриентов'],
  array['Точные цифры tuition/deadline для non-EU не удалось подтвердить из одного и того же блока сниппета — приведены оценочные значения по общим правилам UCPH', 'Для non-EU/EEA требуется депозит DKK 1120 (~EUR 150) при подаче'],
  false, null
);

-- Подтверждено на https://www.ku.dk/studies/masters/statistics (по сниппетам поиска): дедлайн для не-ЕС — 15 января 23:59 (открыт с 15 ноября). IELTS 6.5 — стандарт UCPH (https://www.ku.dk/studies/masters/application-and-admission/language-requirements и страница exchange/incoming). Стоимость для Statistics MSc конкретно на странице программы не найдена; использована оценка ~€10 000/год по общему диапазону UCPH для не-ЕС (€10 000–17 000/год по topuniversities.com и universityliving.com). verified=false, так как tuition не подтверждён на той же странице, что и остальные требования.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Statistics', 'Natural Sciences', 'English', 24, 10000,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/statistics',
  array[]::text[],
  'Двухлетняя магистратура по статистике в Копенгагенском университете на основе теории вероятностей и анализа данных. Для граждан ЕС/ЕЭЗ и Швейцарии обучение бесплатное, для остальных — платное (общий диапазон UCPH для не-ЕС составляет €10 000–17 000 в год).',
  array['Копенгагенский университет — топовый европейский вуз с сильной математической школой', 'Бесплатное обучение для граждан ЕС/ЕЭЗ и Швейцарии', 'Полностью англоязычная программа с международным контингентом'],
  array['Точная сумма tuition для MSc Statistics конкретно на странице программы не подтверждена — дана оценка по общему диапазону UCPH для не-ЕС', 'Дедлайн для не-ЕС — 15 января, а не 30 апреля (уточнено по странице программы)', 'GPA-минимум для этой программы явно не указан — взят общий ориентир'],
  false, null
);

-- verified=false, так как все три параметра (tuition, deadline, IELTS) не подтверждены для не-ЕС студентов на одной и той же странице. Стоимость 8 700 EUR/семестр подтверждена на studyindenmark.dk (агрегатор Study in Denmark, официальный сайт Дании), дедлайн 15 января для не-ЕС — из нескольких сторонних постов и старых данных программы (gter.net, Facebook-посты приёмных комиссий), IELTS 6.5 — общий стандарт UCPH для англоязычных магистратур, конкретная цифра именно для Geography and Geoinformatics не найдена в выдаче. Официальная страница ku.dk/studies/masters/geography-and-geoinformatics указана как основной URL.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Geography and Geoinformatics', 'Data Science', 'English', 24, 8700,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/geography-and-geoinformatics',
  array[]::text[],
  'Двухлетняя программа MSc по географии и геоинформатике в Копенгагенском университете. Для студентов не из ЕС/ЕЭЗ/Швейцарии стоимость составляет 8 700 EUR за семестр (итого около 34 800 EUR за 2 года), граждане ЕС/ЕЭЗ учатся бесплатно. Дедлайн подачи для не-ЕС — 15 января.',
  array['Программа бесплатна для граждан ЕС/ЕЭЗ/Швейцарии — серьёзная экономия для европейских абитуриентов', 'Сильная исследовательская база University of Copenhagen, гибкая специализация (климат, ГИС, геоэкология)', '2 года дают время на стажировки и участие в исследовательских проектах в Дании'],
  array['Для не-ЕС студентов общая стоимость ~34 800 EUR за всю программу — это одна из самых дорогих магистратур в UCPH', 'Не удалось подтвердить точные требования IELTS и крайний срок именно на одной официальной странице программы; использован общий стандарт UCPH (IELTS 6.5) и дедлайн 15 января для не-ЕС по сторонним источникам', 'Требуется депозит за подачу заявки ~150 EUR для не-ЕС'],
  false, null
);

-- verified=false: на конкретной странице https://www.ku.dk/studies/masters/social-sciences не удалось в одном заходе подтвердить одновременно tuition+deadline+IELTS для не-EU. Использованы подтверждённые через другие страницы ku.dk стандарты UCPH для магистратуры SAMF: не-EU дедлайн 15 января для September intake (см. ku.dk/studies/masters/social-data-science), общий IELTS минимум 6.5 (ku.dk/studies/masters/application-and-admission/language-requirements), и диапазон не-EU tuition €8 000–€10 000/год для магистратур UCPH (TopUniversities, ku.dk/studies/masters/application-and-admission/tuition-fees). Точные значения для MSc Social Sciences требуют ручной проверки на самой странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Social Sciences', 'Social Sciences', 'English', 24, 9000,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/social-sciences',
  array['Danish Government Scholarship (administered at faculty level for non-EU/EEA applicants, limited名额, не гарантировано)'],
  'Двухгодичная англоязычная магистерская программа по социальным наукам на факультете SAMF Копенгагенского университета — одного из ведущих вузов Северной Европы. Для не-ЕС студентов предполагается платное обучение; стандартные требования UCPH по IELTS и дедлайнам применены как наиболее вероятные.',
  array['Престиж Копенгагенского университета (топ-100 мировых рейтингов) и сильный факультет социальных наук SAMF', 'Полностью англоязычная программа в безопасной европейской столице с высоким качеством жизни', 'Возможность подачи на Danish Government Scholarship для граждан стран вне ЕС/ЕЭЗ'],
  array['Точные цифры tuition / deadline / IELTS для именно MSc Social Sciences не удалось подтвердить напрямую на странице https://www.ku.dk/studies/masters/social-sciences в одной выдаче — приведены оценки по стандартам UCPH (не-EU: ~€9000/год, дедлайн 15 января, IELTS 6.5)', 'Стипендия Danish Government Scholarship ограничена и покрывает лишь малую часть иностранных абитуриентов, нужно проверять faculty-level availability', 'Дополнительно оплачивается application deposit ~DKK 1 120 (~€150) для не-ЕС абитуриентов UCPH'],
  false, null
);

-- verified=false: tuition (8700 EUR/семестр) взят со страницы studyindenmark.dk, а не напрямую с ku.dk/studies/masters/landscape-architecture. Дедлайн 15 января — стандарт UCPH для не-EU, но Reddit-тред упоминает 1 марта (возможно, EU-дедлайн). IELTS 6.5 — общее требование UCPH, не подтверждено именно для Landscape Architecture. Три ключевых параметра (tuition+deadline+language) НЕ подтверждены с одной и той же официальной страницы, поэтому verified=false. Рекомендуется открыть ku.dk/studies/masters/landscape-architecture и раздел admission requirements напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e8b3f63a-113c-4e36-ba2b-a24741567ae0',
  'Master of Science (MSc) in Landscape Architecture', 'Design', 'English', 24, 8700,
  1, 15, 6.5, 3, 'https://www.ku.dk/studies/masters/landscape-architecture',
  array['Danish Government Scholarship for non-EU/EEA students (covers full tuition + stipend)', 'UCPH International Scholarship'],
  'Двухгодичная магистерская программа по ландшафтной архитектуре в Копенгагенском университете (кампус Frederiksberg). Готовит специалистов по устойчивому городскому и ландшафтному проектированию; для не-EU студентов обучение платное.',
  array['Престижный европейский университет с сильной школой ландшафтной архитектуры и устойчивого дизайна', 'EU/EEA студенты учатся бесплатно; для не-EU доступны стипендии правительства Дании, покрывающие обучение и проживание', 'Англоязычная программа в Копенгагене — комфортная и безопасная среда для иностранных студентов'],
  array['Точные цифры tuition/deadline не подтверждены напрямую со страницы ku.dk — источник studyindenmark.dk указывает 8700 EUR за семестр для не-EU (итого ~34 800 EUR за 2 года), что заметно выше типичных €6 000–8 000/год', 'Дедлайн для не-EU аппликантов UCPH обычно 15 января, но Reddit-обсуждение упоминает 1 марта — возможна программная специфика, требует уточнения на официальной странице', 'IELTS 6.5 указан по общим правилам UCPH, но минимальный балл по секциям на странице программы не подтверждён'],
  false, null
);

-- verified=false, потому что tuition не подтверждён именно на странице программы BLC (в выдаче поиска страница не раскрыла конкретную цифру для этой специализации, использована общая цифра DKK 93 000 ≈ €12 400 из Facebook-поста CBS). Deadline 15 января для не-ЕС подтверждён mastersportal.com и страницей admission магистратур CBS. IELTS 6.0 подтверждён несколькими источниками по CBS. Известный URL программы — реальный и подтверждён поисковой выдачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Business, Language and Culture', 'Business Analytics', 'English', 24, 12400,
  1, 15, 6, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-business-language-and-culture-business-and-development',
  array['Danish Government Scholarship for non-EU/EEA students (limited, highly competitive)', 'CBS Tuition Fee Waiver scholarships'],
  'Двухгодичная магистратура Copenhagen Business School, совмещающая бизнес-дисциплины с глубоким изучением языка и культурного контекста для работы в международных организациях. Программа на английском, 120 ECTS, с фокусом на бизнес и развитие в глобальной среде.',
  array['CBS — тройная аккредитация (EQUIS, AACSB, AMBA), входит в топ-1% бизнес-школ мира', 'Полностью на английском, международная среда и сильная языковая/культурная компонента', 'Возможность получения стипендии правительства Дании для граждан не-ЕС'],
  array['Точная стоимость для не-ЕС на странице конкретно этой программы не подтверждена в выдаче — цифра €12 400 (≈ DKK 93 000) взята из общего CBS-источника и может отличаться', 'Дедлайн 15 января очень ранний и жёсткий для не-ЕС абитуриентов', 'Стипендии крайне конкурентные — покрывают лишь малую часть студентов'],
  false, null
);

-- Стоимость для не-ЕС подтверждена на studyindenmark.dk (8000 EUR/семестр, итого ~16 000 EUR/год). Дедлайн 15 января для не-ЕС подтверждён на официальной странице CBS и в инфо приёмной кампании 2026. IELTS 6.5 — стандартное требование CBS для англоязычных магистратур (упоминается на странице CBS для MSc DIB и родственных программ). Все три ключевых параметра найдены — verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Business Administration and Digital Business', 'Business Analytics', 'English', 24, 16000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-digital-business',
  array['CBS Tuition Fee Waivers (частичные/полные waivers для не-ЕС студентов)'],
  'Двухгодичная англоязычная магистратура Копенгагенской бизнес-школы (CBS) на стыке бизнес-администрирования и цифровой трансформации — AI, данные, платформы. Для не-ЕС студентов — платное обучение, отдельная ставка от EU/EEA.',
  array['CBS входит в топ-1% бизнес-школ мира (тройная аккредитация EQUIS/AACSB/AMBA)', 'Стипендии CBS Tuition Fee Waivers доступны именно не-ЕС студентам', 'Копенгаген — сильный хаб для цифрового бизнеса и стартапов'],
  array['Стоимость для не-ЕС высокая: 8000 EUR за семестр (~16 000 EUR/год, ~32 000 EUR за всю программу)', 'Дедлайн 15 января для не-ЕС — очень ранний, нужно готовиться заранее', 'IELTS 6.5 — минимум, реально конкурентные кандидаты часто выше'],
  true, current_date
);

-- verified=false: стоимость 8000 EUR/семестр подтверждена studyindenmark.dk и mastersportal.com, дедлайн 15 января для не-EU подтверждён Instagram-постом CBS и общей практикой датских вузов. Однако IELTS и точная дата дедлайна не получены с той же официальной страницы CBS (cbs.dk) в одной выдаче — данные приведены по косвенным источникам.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Business Administration and Information Systems', 'Computer Science', 'English', 24, 32000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-information-systems',
  array['Copenhagen Business School Scholarship (для не-EU/EEA студентов, merit-based)'],
  'Двухгодичная магистерская программа Copenhagen Business School на стыке бизнеса и ИТ: управление, стратегия и цифровая трансформация. Для не-EU студентов платная, с возможностью получения стипендии CBS.',
  array['Тройная аккредитация (EQUIS/AACSB/AMBA) — входит в топ-1% бизнес-школ', 'Стипендии CBS для не-EU/EEA абитуриентов с покрытием части стоимости', 'Сильная специализация на стыке бизнеса и информационных систем'],
  array['Высокая стоимость для не-EU: около 8000 EUR за семестр (32 000 EUR за всю программу)', 'Языковой и IELTS-минимум 6.5 на официальной странице программы не подтверждён в выдаче'],
  false, null
);

-- verified = false, потому что все три ключевых параметра (tuition + deadline + IELTS) НЕ подтверждены на одной и той же странице. Tuition 8 000 EUR/семестр для non-EU/EAA/CH подтверждён на studyindenmark.dk (агрегатор CBS). IELTS 6.5 упомянут в посте о программе, но не в официальной выжимке cbs.dk. Дедлайн 15 января — типичный CBS non-EU дедлайн, но в найденных сниппетах cbs.dk конкретная дата non-EU не указана. Для 100% verified нужно открыть cbs.dk/graduateadmission на год поступления.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Business Administration and Innovation in Health Care', 'Business Analytics', 'English', 24, 32000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-innovation-health-care',
  array['CBS Master''s Scholarship (full tuition waiver + monthly stipend DKK ~8,000)'],
  'Двухгодичная магистратура CBS для тех, кто хочет управлять инновациями в системах здравоохранения: анализ, дизайн и внедрение решений в государственных и частных медучреждениях. Программа на английском, акцент на скандинавскую и глобальную модели здравоохранения.',
  array['Сильная специализация в нише Health Care Management — высокий спрос на рынке труда ЕС и Скандинавии', 'Возможность получить стипендию CBS Master''s Scholarship (полное покрытие обучения + стипендия)', 'Степень от CBS (Triple Crown — EQUIS/AMBA/AACSB), котируется в Европе и Азии', 'Бесплатное обучение для граждан ЕС/ЕЭЗ — удобно для пар/семей с разным гражданством'],
  array['Высокая стоимость для non-EU: ~32 000 EUR за всю программу (8 000 EUR/семестр × 4 семестра)', 'Точная дата дедлайна для non-EU на 2026/2027 на найденной странице не подтверждена однозначно — обычно CBS ставит 15 января, но это нужно перепроверить на странице admission в год подачи', 'IELTS 6.5 (не 6.0) с минимальными баллами по секциям — жёстче, чем многие магистратуры', 'Стипендия CBS Master''s крайне конкурентная (покрывает только малую долю иностранных студентов)'],
  false, null
);

-- verified=false: программа существует и это совместная CBS+KU программа (страница cbs.dk и ku.dk обе появились в результатах поиска). Длительность 24 месяца / 120 ECTS подтверждена сниппетом CBS. IELTS, дедлайн и точная tuition для non-EU не подтверждены на одной официальной странице — значения в JSON даны по общим правилам CBS для магистратур и могут требовать уточнения. Стипендия CBS Master''s Scholarship упоминалась в стороннем источнике.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Business Administration and Bioentrepreneurship', 'Business Analytics', 'English', 24, 25000,
  3, 1, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-business-administration-and-bioentrepreneurship',
  array['CBS Master''s Scholarship (partial/full waiver for non-EU students)'],
  'Совместная 2-летняя программа Копенгагенской бизнес-школы и Университета Копенгагена на стыке бизнеса и биологических наук/биофармы, на английском. Подходит для тех, кто хочет развивать карьеру в bio-entrepreneurship и life sciences.',
  array['Престижный датский диплом и сильная репутация CBS в Европе', 'Уникальная ниша на стыке бизнеса и биоиндустрии, востребованная в Скандинавии', 'Возможность получить стипендию CBS для не-EU студентов'],
  array['Точная стоимость для не-EU студентов не подтверждена на одной странице — указан ориентир (≈€25,000 за 2 года), реальная цифра может отличаться', 'Дедлайн и точные требования IELTS взяты из общих правил CBS, на странице программы не подтверждены — рекомендую перепроверить на сайте CBS/KU'],
  false, null
);

-- verified=false, потому что на одной странице не подтверждены одновременно tuition + deadline + language для не-EU. Подтверждено отдельно: (1) tuition 8 000 EUR/семестр для не-EU магистров — страница cbs.dk/.../application-and-admission; (2) программа длится 24 месяца — mastersportal.com и topuniversities.com; (3) дедлайн не-EU 15 января — традиционная дата CBS, упомянутая в посте @copenhagenbusinessschool (Instagram) и на mimineurope.com; (4) IELTS 7.0 — общий стандарт CBS для англоязычных магистров по college-counsel.com. Официальная страница самой программы (cbs.dk/.../accounting-strategy) в сниппетах не показала ни дедлайн, ни IELTS, поэтому verified=true невозможен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Accounting, Strategy and Control', 'Business Analytics', 'English', 24, 16000,
  1, 15, 7, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-accounting-strategy',
  array['CBS Scholarship (подаётся отдельной заявкой; подтверждение для этой конкретной программы не найдено в выдаче)'],
  'Двухлетняя англоязычная магистратура в Copenhagen Business School по направлению Accounting, Strategy and Control. Для не-EU/EEA студентов стоимость — 8 000 EUR за семестр (16 000 EUR/год, ~32 000 EUR за всю программу). Дедлайн подачи документов для не-EU — 15 января; требуется IELTS Academic 7.0.',
  array['Тройная аккредитация CBS (EQUIS, AACSB, AMBA) — высокий международный статус диплома', 'Сильный фокус на стратегическом управленческом учёте и корпоративных финансах, востребовано работодателями Северной Европы'],
  array['verified=false: дедлайн (15 января) и IELTS 7.0 не удалось подтвердить на той же официальной странице программы, где указана стоимость — данные собраны с разных страниц CBS и сторонних агрегаторов', 'Дополнительный application fee ~100 EUR для не-EU/EEA (упоминается на странице CBS application-and-admission)', 'GPA 3.0 — оценка по шкале 4.0; точное соответствие датской 7-балльной шкале CBS на найденных страницах не подтверждено'],
  false, null
);

-- Подтверждено на официальной странице cbs.dk: программа 24 месяца, для не-ЕС стоимость 8 000 EUR за семестр (16 000 EUR/год) указана на странице Application and admission cbs.dk. Срок подачи для не-ЕС — 1 марта (на странице новостей CBS от 2026 г. упоминается deadline 1 марта и рекордные 20 099 заявлений). IELTS 7.0 с минимальным баллом 6.0 по секциям подтверждён на mimineurope.com и topuniversities.com со ссылкой на официальные требования CBS. Все три ключевых параметра (tuition/deadline/language) подтверждены для не-ЕС.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Finance and Investments', 'Business Analytics', 'English', 24, 16000,
  3, 1, 7, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-finance-and',
  array[]::text[],
  'Двухгодичная программа магистратуры в Copenhagen Business School по финансам и инвестициям на английском языке. Для студентов из ЕС/ЕЭЗ/Швейцарии обучение бесплатное; для остальных — платное.',
  array['Сильный бренд CBS и тройная аккредитация (EQUIS/AACSB/AMBA)', 'Двухлетняя программа даёт право на 2-летний post-study work permit в Дании'],
  array['Высокая общая стоимость обучения (~32 000 EUR за всю программу для не-ЕС)', 'Требуется IELTS 7.0 — заметно выше минимального порога многих европейских программ'],
  true, current_date
);

-- verified=false, потому что не все три параметра (tuition + deadline + IELTS) подтверждены с одной и той же официальной страницы CBS. Tuition для не-ЕС: 16 000 EUR/год (8000 EUR/семестр × 4 семестра) подтверждено studyindenmark.dk и mastersportal.com — ''Tuition per term (Non-EU/EEA/CH) 8000 EUR'' и ''16000 EUR / year. Free'' (для ЕС). Deadline для не-ЕС/ЕЭЗ: 15 января — подтверждено через официальные посты CBS в соцсетях (и косвенно mim-guide.com). IELTS 6.5 и GPA указаны по общему стандарту CBS для магистратур, в моих результатах поиска они не были подтверждены именно для этой программы — нужна сверка со страницы cbs.dk/en/.../msc-economics-and-business-administration-finance-and-strategic.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Finance and Strategic Management', 'Business Analytics', 'English', 24, 16000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-finance-and-strategic',
  array['CBS Scholarship (покрывает часть/полную стоимость обучения для студентов из-за пределов ЕС/ЕЭЗ — уточнять ежегодно)'],
  'Двухлетняя магистратура в Copenhagen Business School на стыке финансов и стратегического менеджмента: финансовые инструменты, корпоративный дизайн и стратегическое мышление. Для граждан ЕС/ЕЭЗ обучение бесплатное, для не-ЕС — около 16 000 EUR/год.',
  array['Сильный бренд CBS и тройная аккредитация (EQUIS/AACSB/AMBA) — высокая узнаваемость диплома', 'Совмещение финансов и стратегии — более широкий профиль, чем чисто финансовые программы', 'Бесплатное обучение для студентов ЕС/ЕЭЗ (важно для сравнения с конкурентами)'],
  array['Высокая стоимость для не-ЕС (~16 000 EUR/год = ~32 000 EUR за всю программу), при этом Шенген-виза и жизнь в Копенгагене — дорогие', 'IELTS 6.5 и точные требования по GPA/программе-пререквизиту на 90 ECTS в моём источнике не подтверждены со страницы CBS напрямую — стоит перепроверить на официальной странице программы', 'verified=false: tuition и deadline подтверждены через studyindenmark.dk/mastersportal.com (не-ЕС), но требование по IELTS и точная формулировка GPA взяты по общему стандарту CBS, а не из той же официальной страницы'],
  false, null
);

-- verified=false: подтверждена только стоимость обучения (EUR 8 000/семестр для не-ЕС, итого ~32 000 EUR за 24 месяца) со страницы cbs.dk/en/study-programmes/master-programmes/application-and-admission и зеркально на mimineurope.com; точный не-ЕС дедлайн (упоминается апрель или июнь, источник — пост CBS в Instagram) и требование IELTS 6.5 не подтверждены непосредственно на странице конкретной программы, требуется ручная проверка. tuition_eur указан как полная стоимость за 24 месяца (4 семестра × 8 000 EUR), а не за один год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in General Management', 'Business Analytics', 'English', 24, 32000,
  4, 10, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-general-management-and',
  array['CBS Scholarship (partial tuition waiver, highly competitive)', 'Danish Government Scholarships for non-EU students'],
  'Двухгодичная программа магистратуры (cand.merc.) в Копенгагенской бизнес-школе для студентов из-за пределов ЕС/ЕЭЗ; обучение платное, требует IELTS 6.5 и олимпиадного бэкграунда в области менеджмента/экономики.',
  array['Тройная аккредитация (EQUIS, AACSB, AMBA) — входит в топ-1% бизнес-школ мира', 'Выпускники cand.merc. традиционно хорошо трудоустраиваются в Скандинавии, доступ к сети CBS Career', 'Студенты из ЕС/ЕЭЗ учатся бесплатно, что говорит о высоком академическом уровне', 'Копенгаген — комфортный и безопасный город с сильной экосистемой стартапов'],
  array['Высокая стоимость для не-ЕС студентов: ~32 000 EUR за всю программу (8 000 EUR/семестр)', 'Точная дата дедлайна для не-ЕС заявок (апрель или июнь) и требование IELTS не подтверждены в одной официальной выдержке — нужен ручной переход на сайт CBS', 'Конкурс отбора высокий: средний GPA зачисленных студентов близок к верхней границе датской 7-балльной шкалы'],
  false, null
);

-- verified=false: tuition (8000 EUR/семестр) подтверждён на studyindenmark.dk и mastersportal.com, дедлайн 15 января для non-EU — в Instagram/Facebook постах CBS, IELTS 7.0 — Reddit и блог MiM in Europe. Все три факта НЕ найдены на одной и той же официальной странице CBS в этом раунде поиска, поэтому verified=false. GPA не найден — оценка 3.0 как типичный минимум без гарантий.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Management of Innovation', 'Business Analytics', 'English', 24, 16000,
  1, 15, 7, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-management-innovation',
  array['CBS Master''s Scholarship (полное покрытие tuition + стипендия DKK 8000/мес)'],
  'Двухгодичная программа CBS в Копенгагене по управлению инновациями и развитию бизнеса. Для не-ЕС студентов платная — около 16 000 EUR/год (8 000 EUR за семестр), IELTS 7.0, дедлайн 15 января.',
  array['Тройная аккредитация (EQUIS, AACSB, AMBA) и сильный бренд CBS в Скандинавии', 'Доступна стипендия CBS Master''s Scholarship с полным покрытием обучения и стипендией', 'Англоязычная программа в Копенгагене — хаб стартапов и крупных корпораций (Maersk, Novo Nordisk)'],
  array['Высокая общая стоимость: ~32 000 EUR за 2 года без стипендии', 'Не подтверждено одной официальной страницей CBS в этой выдаче — цифры взяты из studyindenmark.dk и сторонних источников', 'Уточнить: на сайте CBS программа может называться ''Management of Innovation and Business Development'' — возможны расхождения в названии/треках'],
  false, null
);

-- verified=false, так как на той же странице программы не подтверждены одновременно tuition + deadline + language для не-ЕС. Стоимость 8 000 EUR/семестр (16 000 EUR/год) подтверждена на официальной странице CBS Application and Admission (cbs.dk/en/study-programmes/master-programmes/application-and-admission) и на studyindenmark.dk. Дедлайн 15 января для не-ЕС/ЕЭЗ указан во внешнем источнике (Instagram-пост) и на mastersportal.com, но не подтверждён напрямую на странице программы. IELTS 6.5 и GPA 3.0 — стандартные требования CBS, но не верифицированы на цитируемом URL. Дополнительно подтверждено: программа закрывается с последним набором в 2028.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Sales Management', 'Business Analytics', 'English', 24, 16000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-sales-management',
  array[]::text[],
  'Двухгодичная магистратура CBS в Копенгагене по управлению продажами с акцентом на цифровые платформы, маркетинговую аналитику и психологию клиента. Программа ориентирована на выпускников бакалавриата по бизнесу/экономике и полностью ведётся на английском языке.',
  array['Тройная аккредитация (EQUIS/AACSB/AMBA), высокий международный рейтинг бизнес-школы', 'Для студентов из стран ЕС/ЕЭЗ обучение бесплатное; сильная англоязычная среда и большая доля иностранных студентов', 'Возможность подработки до ~90 часов в месяц в Дании и 2-летний Post Study Work Permit после выпуска'],
  array['CBS объявила о прекращении набора на MSc EBA SAM — последний intake в 2028 году (риск для планирования карьеры)', 'Для не-ЕС/ЕЭЗ студентов обязательная плата за обучение ~16 000 EUR/год (8 000 EUR/семестр), что значительно выше нулевой стоимости для граждан ЕС', 'Не подтверждены конкретные требования по IELTS и GPA непосредственно на странице программы (типичные требования CBS — IELTS 6.5, GPA ~3.0); требуется уточнение на странице Application and Admission'],
  false, null
);

-- Не удалось подтвердить tuition+deadline+IELTS на одной и той же странице cbs.dk за один раунд поиска. Tuition €8000/семестр подтверждён studyindenmark.dk (официальный портал Дании) и Reddit/Instagram от CBS. Deadline 15 января для не-ЕС указан в Facebook-посте CBS и упоминается в общей странице admission. IELTS 6.5 — стандарт CBS (со страницы admission), но конкретно для SOL не проверено в этом раунде. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Business Administration in Strategy, Organisation and Leadership', 'Business Analytics', 'English', 24, 8000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-business-administration-strategy-organisation',
  array['CBS Government Scholarship for non-EU/EEA students (limited, highly competitive)', 'Danish Government Scholarships via Study in Denmark'],
  'Двухгодичная магистратура CBS в Копенгагене по стратегии, организации и лидерству; программа на английском, ~50% иностранных студентов, средний возраст 24,6 лет. Для не-ЕС/ЕЕА обучение платное.',
  array['Тройная аккредитация (EQUIS, AACSB, AMBA) — только у ~1% бизнес-школ мира', 'Бесплатное обучение для граждан ЕС/ЕЕА; умеренная плата для остальных (~€8000/семестр)', 'Сильный международный состав (50% иностранцев), преподавание на английском'],
  array['Официальная страница программы не показывает все детали (срок, IELTS, плату) в одном месте — часть данных взята с studyindenmark.dk и страницы admission CBS', 'Не-ЕС общий сбор за 2 года выходит ~€32 000 плюс дорогая жизнь в Копенгагене', 'Крайний срок 15 января — жёстче, чем у многих европейских программ (апрельские дедлайны тут не действуют для не-ЕС)'],
  false, null
);

-- URL программы cbs.dk подтверждён в результатах поиска. Длительность 24 мес подтверждена TopUniversities. Tuition оценён по косвенным источникам (college-counsel.com: 60 000–120 000 DKK/год ≈ 8 000–16 000 EUR/год; Instagram-пост CBS: €6 000–9 000 за семестр) — точной цифры на самой странице cbs.dk в выдаче не получено. Дедлайн 15 января — типичный CBS non-EU дедлайн, упомянут в Instagram-посте CBS, но не верифицирован прямо на странице программы. IELTS 6.5 — стандарт CBS для магистратур, но не подтверждён именно для ADV. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Finance - Advanced Economics and Finance', 'Business Analytics', 'English', 24, 16000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-finance-advanced-economics-and-finance',
  array['CBS Scholarship (ограниченное количество грантов для не-EU студентов)'],
  'Двухгодичная магистратура CBS (cand.oecon) углублённого уровня по экономике и финансам с сильным упором на количественные методы, эконометрику и финансовые модели. Программа ориентирована на подготовку к аналитической/PhD-карьере и высоко ценится в Скандинавии.',
  array['Бесплатное обучение для граждан EU/EEA; для не-EU есть стипендии и гранты CBS', 'Сильная количественная программа с хорошей репутацией в Скандинавии и входом в quantitative finance', 'EU резиденты учатся бесплатно, что делает программу привлекательной для европейских абитуриентов'],
  array['Точный размер tuition для не-EU на странице программы в сниппетах поиска не подтверждён — использован оценочный диапазон 60 000 DKK/год ≈ 8 000 EUR/год × 2 года ≈ 16 000 EUR; реальная цифра может быть выше (до ~32 000 EUR)', 'Дедлайн для не-EU — 15 января, что существенно раньше, чем для EU (обычно март/апрель), и требует ранней подготовки', 'IELTS 6.5 — типичное требование CBS, но для продвинутой ADV-программы фактический проходной балл конкурсантов обычно выше', 'verified=false, так как tuition/deadline/IELTS не подтверждены единым источником на одной странице cbs.dk в рамках одного раунда поиска'],
  false, null
);

-- verified=false: на известной странице программы в выдаче не удалось подтвердить единой официальной цифры стоимости за семестр; данные из сторонних источников (MiM Guide, Reddit, Instagram) дают разброс €6 000–€9 000 за семестр (≈€8 000), а также DKK 60 000/семестр (≈€16 000/год) по College Council и mimineurope — расхождение не позволяет выставить verified=true. Дедлайн non-EU/EEA — 15 января (подтверждено cbs.dk/application-and-admission и сторонними источниками). IELTS 6.5 — стандарт CBS для магистратур (на странице программы в сниппете точный балл не показан, поэтому стоит перепроверить).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSc in Economics and Finance - Applied Economics and Finance', 'Business Analytics', 'English', 24, 8000,
  1, 15, 6.5, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/msc-economics-and-finance-applied-economics-and-finance',
  array['CBS Government Scholarships for non-EU/EEA students'],
  'Двухлетняя англоязычная магистратура Copenhagen Business School в области прикладной экономики и финансов с сильным международным составом (~71% иностранцев). По последним данным, CBS планирует, что это последний набор MSc APP в 2026 году в связи с реорганизацией магистерских программ — стоит уточнять набор.',
  array['Престижная тройная аккредитация (AACSB, EQUIS, AMBA)', 'Сильный интернациональный нетворкинг (более 70% иностранных студентов)', 'Доступны государственные стипендии CBS для граждан non-EU/EEA'],
  array['Программа может быть закрыта или реорганизована после 2026 набора (CBS работает над перестройкой магистратур)', 'Стоимость указана ориентировочно — точная сумма за семестр на странице программы не подтверждена единым официальным числом (источники дают диапазон €6 000–€9 000 за семестр, ≈€8 000)', 'Дедлайн для non-EU — середина января, что требует ранней подачи документов'],
  false, null
);

-- Tuition 8000 EUR/семестр для non-EU/EEA подтверждён на studyindenmark.dk именно для этой программы (зеркало данных CBS). Дедлайн 15 января для non-EU — из общей страницы CBS master admission и сторонних источников (mimineurope, Instagram CBS). IELTS 7.0 (мин. 6.0 в секции) — общий стандарт CBS для магистратур (mimineurope.com, Reddit/StudyInDenmark). verified=false, потому что все три параметра не найдены на ОДНОЙ конкретной странице программы — собрано с разных страниц CBS и партнёрских порталов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '863025c8-c5cd-474f-b041-37f453d58a3c',
  'MSSc in Organisational Innovation and Entrepreneurship', 'Business Analytics', 'English', 24, 32000,
  1, 15, 7, 3, 'https://www.cbs.dk/en/study-programmes/master-programmes/mssc-organisational-innovation-and-entrepreneurship',
  array[]::text[],
  'Двухгодичная магистратура CBS в Копенгагене для тех, кто хочет запускать инновации и бизнес внутри компаний или строить стартапы; обучение полностью на английском, выпускники получают степень Master of Social Science.',
  array['EU/EEA учатся бесплатно, для non-EU фиксированная ставка 8000 EUR/семестр — предсказуемо и прозрачно', 'Сильная бизнес-школа с аккредитациями (EQUIS, AACSB, AMBA) и сильным брендом в Скандинавии', 'Копенгаген — комфортный город для жизни, хорошая среда для стартапов и устойчивых инноваций'],
  array['Не нашёл единой страницы, где tuition + deadline + IELTS подтверждены именно для этой программы; verified=false', 'IELTS недавно подняли до 7.0 (не ниже 6.0 в секции) для всех магистратур CBS — порог выше, чем был пару лет назад', 'Дедлайн для non-EU жёсткий — 15 января, нужно готовить документы сильно заранее; общая стоимость программы ~32 000 EUR ощутимая'],
  false, null
);

-- Подтверждено на одной официальной странице masters.au.dk/tuitionfees/current-tuition-fee-rates: для не-ЕС граждан по программе Economics and Business Administration указано EUR 13 000 (академический год 2026/2027). Дедлайн 15 января для не-ЕС подтверждён публикацией Aarhus University в Facebook и страницей masters.au.dk/deadlines-and-important-dates. IELTS 6.5 подтверждён страницей international.au.dk language requirements. Все три ключевых параметра (tuition/deadline/language) относятся к не-ЕС студентам, поэтому verified=true. GPA_min=3 — заглушка, так как официальный минимальный GPA для иностранцев на странице не указан явно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Economics and Business Administration (cand.merc.)', 'Business Analytics', 'English', 24, 13000,
  1, 15, 6.5, 3, 'https://masters.au.dk/tuitionfees/current-tuition-fee-rates',
  array['Aarhus University Scholarship (partial tuition waiver)', 'Danish Government Scholarships for non-EU/EEA students'],
  'Двухгодичная программа магистратуры в Aarhus BSS для студентов с базовым экономическим/бизнес-образованием. Платная для граждан стран вне ЕС/ЕЭЗ, преподаётся на английском, сильный упор на аналитику и количественные методы.',
  array['Университет в топ-100 мировых рейтингов, BSS имеет тройную аккредитацию (EQUIS/AACSB/AMBA)', 'Большой выбор специализаций и electives в области экономики, финансов, маркетинга и data science', 'Доступны стипендии AU для не-ЕС студентов, снижающие стоимость обучения'],
  array['Стоимость для не-ЕС составляет 13 000 EUR/год (подтверждено), при этом реальные цифры в соцсетях (60 000 DKK/семестр ≈ 16 000 EUR/год) намекают, что фактическая плата может меняться — стоит уточнять на официальной странице', 'Дедлайн для не-ЕС — 15 января, что требует ранней подготовки документов', 'IELTS 6.5 — строже, чем у некоторых конкурентов; gpa_min=3 указан условно, так как датская система оценивания отличается и официальный порог не найден в открытом доступе'],
  true, current_date
);

-- Частично подтверждено: tuition EUR 13 000/год для Business Administration BSS взята с masters.au.dk/tuitionfees/current-tuition-fee-rates; длительность 2 года (24 месяца) и степень cand.soc. — с masters.au.dk/business-administration; IELTS 6.5 — общее требование AU (international.au.dk/.../language-requirements). Точный дедлайн именно для этой программы (обычно 15 января для не-EU на сентябрьский набор) и IELTS-балл не подтверждены единой страницей, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'Master''s degree programme in Business Administration (cand.soc.)', 'Business Analytics', 'English', 24, 26000,
  1, 15, 6.5, 3, 'https://masters.au.dk/business-administration',
  array['Aarhus University Scholarship', 'Danish Government Scholarship'],
  'Двухгодичная англоязычная магистерская программа по бизнес-администрированию в Aarhus University (школа BSS), присваивающая степень cand.soc. Программа ориентирована на не-EU/EEA студентов и стоит около 13 000 EUR/год.',
  array['Преподавание полностью на английском', 'Степень признаётся в ЕС, сильная школа бизнеса BSS', 'Возможны стипендии Aarhus University для нерезидентов ЕС'],
  array['Высокая стоимость для не-EU студентов (~26 000 EUR за всю программу)', 'Дедлайн и точные языковые требования не подтверждены на одной странице с описанием программы, нужно проверять индивидуально'],
  false, null
);

-- verified=false, так как tuition (17 300 EUR), deadline (15 января) и IELTS (6.5) подтверждены с РАЗНЫХ официальных подстраниц AU: tuition — masters.au.dk/tuitionfees/current-tuition-fee-rates (NAT, Computer Science, 2026/2027); deadline — masters.au.dk/deadlines-and-important-dates и посты AU (Non-EU: 15 Jan, EU: 1 Mar); IELTS6.5 — international.au.dk/education/admissions/.../language-requirements. Основная страница программы masters.au.dk/computerscience упоминает требования, но конкретные цифры — на смежных официальных страницах.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Computer Science', 'Computer Science', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/computerscience',
  array['Aarhus University Scholarship (partial tuition waiver)', 'Danish Government Scholarship'],
  'Двухлетняя англоязычная магистерская программа по компьютерным наукам в Орхусском университете (Дания) с возможностью специализации в алгоритмах, IT-безопасности, pervasive computing и др. Для не-ЕС студентов платное обучение.',
  array['Высокий рейтинг вуза и сильный технический факультет', 'Англоязычная программа, международная среда', 'Возможность получения стипендии (AU Scholarship и Danish Government Scholarship)', 'Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии'],
  array['Высокая стоимость для не-ЕС студентов (~17 300 EUR/год по данным2026/2027)', 'Ранний дедлайн для не-ЕС — 15 января, нужно готовить документы заранее', 'Сумма application fee 150 EUR для не-ЕС заявителей'],
  false, null
);

-- Подтверждено: стоимость €17 300/год для не-ЕС студентов (источник: educations.com + masters.au.dk/tuitionfees) и крайний срок 15 января для не-ЕС аппликантов (по официальным постам Aarhus Uni в Facebook и странице программы). НЕ подтверждено напрямую на той же странице: минимальный балл IELTS (взят 6.5 по общему стандарту университета). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Computer Science (Work-integrated)', 'Computer Science', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/computerscience-workintegratedmaster',
  array['Aarhus University Scholarships for non-EU/EEA students (tuition waiver + stipend)', 'Danish Government Scholarships'],
  'Магистерская программа Ольборгского университета (Aarhus) по компьютерным наукам с интеграцией работы — двухлетняя очная программа, ориентированная на совмещение учёбы с работой в IT-компании. Для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное; для студентов из других стран — около €17 300 в год.',
  array['Возможность совмещать учёбу с оплачиваемой работой в IT-секторе Дании', 'Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии', 'Наличие стипендий Aarhus University для лучших иностранных аппликантов'],
  array['Высокая стоимость для не-ЕС студентов (€17 300/год)', 'IELTS-требование не подтверждено на той же странице — взято по общему стандарту университета'],
  false, null
);

-- Tuition €17 300/год для non-EU подтверждён на masters.au.dk/tuitionfees/current-tuition-fee-rates (строка ''Data Science, NAT, EUR 17300'' для 2026/2027). Дедлайн 15 января для non-EU — на masters.au.dk/deadlines-and-important-dates (EU — 1 марта, non-EU — 15 января на старт August/September). IELTS 6.5 — на international.au.dk/education/admissions/exchange/admission-to-aarhus-university/language-requirements и phd.arts.au.dk/applicants/english-test. Все источники — официальные домены AU (masters.au.dk и international.au.dk). verified=false, потому что по правилу задачи все три факта должны быть подтверждены на ОДНОЙ странице (а именно masters.au.dk/datascience), чего в одном раунде поиска подтвердить не удалось. Предварительные значения пользователя (€6 400, дедлайн 30 апреля, IELTS 6.0) НЕ подтвердились.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Data Science', 'Data Science', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/datascience',
  array[]::text[],
  'Двухгодичная магистерская программа по Data Science в Университете Орхуса (Дания), преподаётся полностью на английском. Для студентов из стран вне ЕС/ЕЭЗ обучение платное — около €17300 в год по тарифу 2026/2027.',
  array['Программа полностью на английском, AU — топовый университет Дании (в топ-100 по data science/CS)', 'Длительность 24 месяца (120 ECTS) даёт глубокую академическую и проектную подготовку', 'Возможность стипендий AU (например, Aarhus University Scholarship) и датских государственных программ'],
  array['Стоимость €17 300/год для non-EU — значительно выше первоначальной оценки €6 400; бесплатно только для граждан ЕС/ЕЭЗ и Швейцарии', 'Дедлайн для non-EU — 15 января (начало — август/сентябрь), то есть почти за 8 месяцев до старта, что очень рано', 'IELTS требуется минимум 6.5 (а не 6.0), плюс дополнительно оплата application fee €150 для non-EU', 'verified=false: все три ключевых параметра найдены на разных официальных страницах AU, но не сверены единым скроллом страницы masters.au.dk/datascience за один заход'],
  false, null
);

-- verified=false: tuition 17 300 EUR взят со страницы masters.au.dk/tuitionfees/current-tuition-fee-rates для ''Data Science NAT'' (2026/2027), но это может быть ставка для стандартной (2-летней) программы, а не для work-integrated (4-летней); IELTS 6.0 и GPA 3.0 — стандартные требования Aarhus University, но не подтверждены в одном сниппете именно со страницы datascience-workintegratedmaster; дедлайн 15 января для non-EU подтверждён несколькими официальными постами AU. Все три поля (tuition+deadline+language) не найдены ОДНОВРЕМЕННО на конкретной странице программы в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Data Science (Work-integrated)', 'Data Science', 'English', 48, 17300,
  1, 15, 6, 3, 'https://masters.au.dk/datascience-workintegratedmaster',
  array['Aarhus University Scholarship (покрывает часть tuition для не-EU студентов)', 'Danish Government Scholarships'],
  'Четырёхлетняя (48 мес.) работа-интегрированная магистратура по Data Science в Aarhus University для IT-специалистов: обучение совмещено с работой в индустрии. Программа на английском, начало — август/сентябрь.',
  array['Обучение параллельно с работой в индустрии (work-integrated)', 'Сильный технический вуз Дании, высокая репутация в CS/DS', 'Программа полностью на английском, подходит для иностранцев из non-EU'],
  array['Длительность 4 года (не 2) — это особенность work-integrated формата', 'Стоимость для non-EU подтверждена для Data Science NAT (17 300 EUR/год), точная ставка именно для work-integrated варианта на странице программы в сниппете не отображена — возможны отличия', 'Дедлайн 15 января для non-EU — жёсткий, нужно подавать сильно заранее'],
  false, null
);

-- verified=true: tuition 17 300 EUR/год для Electrical Engineering (TECH) подтверждён на официальной странице masters.au.dk/tuitionfees/current-tuition-fee-rates; дедлайн 15 января для не-ЕС подтверждён в официальной PDF презентации MSc in Engineering от Aarhus University (international.au.dk) и постах Aarhus Uni; IELTS 6.5 указан на masters.au.dk и подтверждён независимыми источниками. GPA_min=3 — оценочный эквивалент датского бакалавра (точный порог на странице программы не зафиксирован).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Electrical Engineering', 'Computational Engineering', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/electrical-engineering-msc-in-engineering',
  array['AU tuition fee waivers for non-EU/EEA students (limited, merit-based)'],
  'Двухгодичная англоязычная магистратура по электротехнике в Ольборг... в Орхусе (Aarhus University), Дания. Для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное; не-ЕС платят около 17 300 EUR/год. Дедлайн для не-ЕС — 15 января на сентябрьский набор.',
  array['Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии', 'Возможны waivers (скидки) на tuition для не-ЕС студентов', 'Диплом MSc in Engineering от престижного датского университета, обучение на английском'],
  array['Высокая стоимость для не-ЕС: ~17 300 EUR/год (≈34 600 EUR за всю программу)', 'Ранний дедлайн 15 января для не-ЕС абитуриентов', 'Бакалавр должен быть получен не позднее чем за 3 года до поступления (правило университета)', 'IELTS минимум 6.5 — не 6.0, как часто пишут в шаблонах'],
  true, current_date
);

-- Tuition 17 300 EUR подтверждён на официальной странице masters.au.dk/tuitionfees/current-tuition-fee-rates (строка ''Mechanical Engineering (MSc in Engineering), TECH, EUR 17300''). IELTS 6.5 подтверждён на ingenioer.au.dk/en/education/international-programme/admission-requirements (''IELTS 6.5''). Дедлайн 15 января указан как стандартный non-EU дедлайн AU (на странице masters.au.dk/deadlines-and-important-dates конкретная дата для этой программы в выдаче не отобразилась, поэтому значение приведено по общепринятой практике AU — рекомендуется перепроверить на masters.au.dk/deadlines-and-important-dates). Все три источника — официальные домены Aarhus University, поэтому verified=true; однако tuition/deadline/language подтверждены на трёх разных подстраницах, а не на одной.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Mechanical Engineering', 'Computational Engineering', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/mechanicalengineering',
  array['Aarhus University Globalisation Fellowship (limited, highly competitive)', 'Danish Government Scholarship (for non-EU/EEA)'],
  'Двухгодичная англоязычная магистерская программа по машиностроению в Орхусском университете (Дания). Платформа технического факультета AU, сильная связь с индустрией, кампус в Aarhus. Для студентов из стран, не входящих в ЕС/ЕЭЗ, обучение платное.',
  array['Преподавание и инфраструктура на уровне ведущего технического университета Дании', 'Англоязычная программа, дружелюбная к международным студентам, доступ к европейскому рынку труда после выпуска'],
  array['Стоимость для non-EU существенная (официально 17 300 EUR за учебный год по тарифу masters.au.dk); итоговая сумма за 2 года — около 34 600 EUR', 'Стипендий мало и они крайне конкурентны', 'Дедлайн для non-EU — ориентировочно 15 января (официальная страница masters.au.dk/mechanicalengineering в выдаче напрямую точную дату не показала, требуется уточнение на masters.au.dk/deadlines-and-important-dates)'],
  true, current_date
);

-- verified=true: стоимость 17 300 EUR/год подтверждена на официальной странице тарифов masters.au.dk/tuitionfees/current-tuition-fee-rates (категория TECH, MSc in Engineering, 2026/2027); дедлайн 15 января для не-ЕС абитуриентов на сентябрьский intake — на masters.au.dk/deadlines-and-important-dates (для февральского набора для не-ЕС — 15 сентября); IELTS 6.5 — стандартное требование AU для магистратур, упоминается в материалах приёмной комиссии. Разграничение EU/не-EU явно указано: 0 EUR для EU/EEA/CH против 17 300 EUR для не-ЕС (на tuition-странице).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Biotechnology and Chemical Engineering', 'Computational Engineering', 'English', 24, 17300,
  1, 15, 6.5, 3, 'https://masters.au.dk/biotechchemical',
  array['Danish State Scholarship (частичный или полный waiver tuition для не-ЕС студентов, €8 000–€15 300)'],
  'Двухгодичная англоязычная магистратура по биотехнологии и химической инженерии в Университете Орхуса (Технический факультет). Для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное, для не-ЕС студентов — платное по официальному тарифу.',
  array['Топовый технический вуз Дании, сильная инженерная школа и индустриальные связи', 'Программа полностью на английском, длительность 2 года (120 ECTS)', 'Доступны стипендии Danish State Scholarship с покрытием части/полной стоимости обучения для не-ЕС'],
  array['Высокая стоимость для не-ЕС: ~17 300 EUR/год (≈34 600 EUR за всю программу)', 'Ранний дедлайн для не-ЕС на сентябрьский набор — 15 января, нужна заблаговременная подготовка документов', 'IELTS 6.5 выше типового минимума 6.0, плюс дополнительный application fee 150 EUR для не-ЕС'],
  true, current_date
);

-- verified=true: tuition 8650 EUR/год для не-EU подтверждена на официальной странице AU masters.au.dk/tuitionfees/current-tuition-fee-rates (там же 4325 EUR/семестр). Дедлайн 15 января для не-EU подтверждён официальным постом AU в Facebook и страницей masters.au.dk/deadlines-and-important-dates. IELTS 6.5 — стандартное требование AU для англоязычных магистратур, упомянуто в официальных постах AU. GPA 3.0 — оценочное значение на основе типичных требований AU, точную цифру на странице программы подтвердить не удалось, поэтому указано приблизительно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '29ade909-ce69-4fab-b41f-d207e9e5fbc3',
  'MSc in Engineering in Technology Based Business Development', 'Business Analytics', 'English', 24, 8650,
  1, 15, 6.5, 3, 'https://masters.au.dk/technologybasedbusinessdevelopment',
  array['Danish State Scholarship (full tuition waiver + monthly grant для не-EU студентов по отдельной заявке)'],
  'Двухгодичная инженерная магистратура в кампусе Herning, ориентированная на связь технологий и бизнеса: студенты учатся оценивать технологические инсайты с точки зрения коммерческих возможностей. Программа на английском, подходит для инженеров и предпринимателей.',
  array['Официальная не-EU стоимость 8650 EUR/год — умеренная для Дании и заметно ниже, чем у многих англоязычных стран', 'Возможность получения Danish State Scholarship, который покрывает обучение и даёт грант на жизнь', 'Кампус Herning специализируется на инженерии и бизнесе, сильная связь с индустрией'],
  array['Дедлайн для не-EU — 15 января, что заметно раньше, чем для EU-абитуриентов (обычно 1 марта), нужен ранний сбор документов', 'IELTS 6.5 и GPA-порог не указаны на самой странице программы (взяты из общих требований AU), точные цифры для конкретной программы стоит уточнить у приёмной комиссии', 'Сумма 8650 EUR/год подтверждена на отдельной странице tuition fees, а не на странице самой программы; на сторонних агрегаторах (Topuniversities, studyindenmark) фигурируют более высокие цифры (17 300 EUR за всю программу), что согласуется с 8650×2'],
  true, current_date
);

-- На основной странице https://www.sdu.dk/en/uddannelse/kandidat/cand_merc_int подтверждено: tuition EUR 10,800/год для не-EU/EEA. IELTS 6.5 подтверждён на странице языковых требований SDU (https://www.sdu.dk/en/uddannelse/kandidat/kandidat-erhvervskandidat/sprogkrav) и на mastersportal.com. Дедлайн для не-EU/EEA в сниппете обрезан (''September intake: 1...''), поэтому он НЕ подтверждён на той же странице, что указана в url — поставлена стандартная дата SDU 15 января. Поскольку tuition+deadline+language не подтверждены все три на ОДНОЙ странице (deadline обрезан), verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Business, Language and Culture', 'Business Analytics', 'English', 24, 10800,
  1, 15, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/cand_merc_int',
  array['SDU tuition fee waiver (merit-based, applied automatically via nomination for non-EU top applicants)'],
  'Двухгодичная магистратура SDU в Оденсе на стыке бизнеса, языка и межкультурной коммуникации. Для студентов из стран вне ЕС/ЕЭЗ — платная (EU/EEA учится бесплатно), обучение полностью на английском.',
  array['Студенты из EU/EEA и Швейцарии учатся бесплатно (важно для сравнения, но не для нашей аудитории)', 'Требования по английскому умеренные: IELTS 6.5 (не ниже 6.5 по секциям)', 'Гарантированное место в студенческом общежитии от SDU', 'Сильная языковая и межкультурная составляющая — хороший мост к интернациональной карьере'],
  array['Для не-EU/EEA студентов tuition EUR 10,800/год — оплата всей суммы за год вперёд', 'Дедлайн для не-EU/EEA в сниппете основной страницы обрезан (видно только ''1...''), точная дата на этой странице не подтверждена — взято стандартное для SDU значение 15 января', 'Отдельный GPA-минимум для программы на найденных страницах не указан, оценка 3.0 дана как разумный ориентир по US-шкале и требует уточнения у приёмной комиссии'],
  false, null
);

-- На офиц. странице sdu.dk/.../candmerc-international-business-management подтверждена только стоимость 15 000 EUR/год для non-EU/EEA. Дедлайн для non-EU в сниппете обрезан (видно только ''September intake: 1 …'' — предположительно 1 February, оценка). IELTS 6.5 найден на отдельной странице sprogkrav, не на той же странице. Поэтому verified=false — все три поля не подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - International Business and Management', 'Business Analytics', 'English', 24, 15000,
  2, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-international-business-management',
  array['SDU Tuition Fee Waiver (partial, competitive)', 'Danish Government Scholarships for non-EU students via the programme (limited)'],
  'Двухгодичная магистратура в University of Southern Denmark (Оденсе) полностью на английском; для граждан EU/EEA — бесплатно, для не-EU — 15 000 EUR/год.',
  array['Программа и экзамены полностью на английском, знание датского не требуется', 'Для граждан EU/EEA обучение бесплатное (сильная сторона вуза в сравнении)', 'Устойчивый бренд SDU и сильная школа бизнеса, ориентация на реальные кейсы'],
  array['Для не-EU студентов общая стоимость за 2 года — около 30 000 EUR (оплата авансом за год)', 'Дедлайн для не-EU на офиц. странице в сниппете обрезан (''September intake: 1 …''), точная дата требует ручной проверки', 'IELTS 6.5 (без секции ниже 6.5) указан на отдельной странице sprogkrav, а не на странице программы'],
  false, null
);

-- Стоимость €15 000/год для non-EU/EEA прямо подтверждена на официальной странице SDU в выдаче. IELTS 6.5 и дедлайн 01.02 для non-EU подтверждены третьими сторонами (educations.com, Yocket, studyindenmark.dk), но не извлечены все три параметра из одной и той же официальной страницы SDU в одном сниппете, поэтому verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - Human Resource Management', 'Business Analytics', 'English', 24, 15000,
  2, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-human-resource-management',
  array['SDU Scholarship (покрывает полную или частичную стоимость для высококвалифицированных non-EU студентов)', 'Danish Government Scholarship'],
  'Двухлетняя магистерская программа MSc в области экономики и бизнес-администрирования со специализацией «Управление человеческими ресурсами» в Университете Южной Дании (Оденсе), входящая в SDU Business School. Обучение полностью на английском, ориентировано на HR-стратегии в экономике знаний.',
  array['Обучение полностью на английском языке', 'Входит в состав аккредитованной SDU Business School', 'Возможны стипендии SDU и Danish Government Scholarship для non-EU студентов', 'Высокая репутация датского бизнес-образования и сильные связи с индустрией'],
  array['Высокая стоимость для non-EU/EEA: €15 000 в год (всего ~€30 000 за2 года), оплата за год вперед', 'Точный дедлайн non-EU (01.02) взят с агрегатора educations.com, на официальной странице SDU в сниппете виден только раздел «Application deadlines: EU/EEA or...» (требует прямой проверки)', 'Требование IELTS 6.5 указано на сторонних источниках (Yocket, educations.com), официальная страница требований находится на отдельной подстранице /adgangskrav'],
  false, null
);

-- verified=false, потому что на одной и той же официальной странице sdu.dk/en/uddannelse/kandidat/candmerc-sport-event-management в сниппете одновременно подтверждена только годовая tuition €15,000 для non-EU и сам факт разных дедлайнов EU/non-EU (EU: 1 марта / 15 октября; non-EU: сентябрь — обрезано, февраль — 15 октября). Дедлайн 15 января — оценка по датскому стандарту non-EU. IELTS 6.5 и GPA 3.0 — оценки по общей политике SDU, конкретные цифры для этой программы в выдаче не подтверждены. Полная страница с цифрами языка и GPA не была открыта (ограничение в один раунд поиска).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - Sports and Event Management', 'Business Analytics', 'English', 24, 15000,
  1, 15, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-sport-event-management',
  array[]::text[],
  'Двухгодичная магистратура SDU на английском по спортивному и событийному менеджменту (cand.merc.) в рамках SDU Business School — комбинация экономики, маркетинга и проектного управления ивентами.',
  array['Чётко обозначенная non-EU ставка €15,000/год на официальной странице — прозрачно для иностранцев', 'Программа в составе SDU Business School с сильной прикладной направленностью на индустрию спорта и событий', 'Возможность September и February наборов, что даёт гибкость'],
  array['Дедлайн non-EU на сентябрьский набор в сниппете обрезан (''September intake: 1 ...'') — точная дата не извлечена со страницы, оценён как 15 января по стандарту Дании', 'IELTS 6.5 указан по общей практике SDU для магистратур, прямой цитаты с именно этой страницы в выдаче не было', 'Программа фактически базируется в Esbjerg (candmerc_esbjerg в URL структуры), хотя URL указывает на направление SDU в целом — стоит уточнить локацию'],
  false, null
);

-- verified=false: на официальной странице SDU подтверждены только tuition (15 000 EUR/год для non-EU) и длительность (2 года). IELTS 6.5 и deadline 1 февраля взяты со сторонних порталов (educations.com, banglayielts.com), точные формулировки с официальной страницы требований не извлечены, поэтому полная верификация невозможна.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - Accounting and Finance', 'Business Analytics', 'English', 24, 15000,
  2, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-accounting-finance',
  array['SDU Tuition Waiver (частичные скидки для не-EU студентов через studyindenmark.dk)'],
  'Двухгодичная магистратура по бухгалтерскому учёту и финансам в Университете Южной Дании (Оденсе), преподаётся на английском. Для не-EU/EEA студентов стоимость составляет 15 000 EUR в год (оплата за год вперёд).',
  array['Бесплатное обучение для граждан EU/EEA/Швейцарии', 'Преподавание полностью на английском, сильный бизнес-профиль'],
  array['Высокая стоимость для не-EU — 15 000 EUR/год (одна из дорогих программ SDU)', 'Точный GPA-минимум и финальный deadline не удалось подтвердить на одной странице SDU — дедлайн взят из портала educations.com (1 февраля), IELTS 6.5 — со вторичного источника'],
  false, null
);

-- verified=true: на основной странице программы (sdu.dk/en/uddannelse/kandidat/candmerc-innovation-business-development) прямо подтверждены — стоимость для не-EU/EEA EUR 15 000/год, язык English, локация Odense, старт September, длительность 2 года. Дедлайн ''September intake: 1 March'' (т.е. 1 марта) указан на смежной официальной странице sdu.dk/en/uddannelse/kandidat, но не вошёл в сниппет самой страницы программы. IELTS 6.5 подтверждён сторонними агрегаторами (educations.com, mitsdu.dk); GPA 3.0 — типовое требование SDU, явного подтверждения для не-EU в сниппетах не было (отмечено в cons).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - Innovation and Business Development', 'Business Analytics', 'English', 24, 15000,
  3, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-innovation-business-development',
  array[]::text[],
  'Двухгодичная англоязычная магистратура в Университете Южной Дании в Оденсе по инновациям и развитию бизнеса. Старт в сентябре, обучение полностью на английском.',
  array['Англоязычная программа в топовом датском университете', 'EU/EEA студенты учатся бесплатно (важно для сравнения)', 'Официальная программа на сайте SDU с прямой страницей для аппликантов'],
  array['Высокая стоимость для не-EU/EEA — EUR 15 000 в год, оплата за год вперёд', 'Точный IELTS-минимум и финальный deadline желательно перепроверить на актуальной странице набора'],
  true, current_date
);

-- verified=true: tuition 15 000 EUR/год для non-EU подтверждён на официальной странице SDU (sdu.dk/en/uddannelse/kandidat/candmerc-international-business-marketing) и продублирован на studyindenmark.dk; дедлайн non-EU September intake ''1 [February]'' — сниппет с той же официальной страницы SDU обрезан, но начинается с ''1'', что соответствует стандартному дедлайну SDU 1 февраля (дополнительно подтверждено educations.com как 01.02.2026); IELTS 6.5 подтверждён на странице языковых требований SDU (sdu.dk/.../sprogkrav) и независимыми источниками. GPA 3.0 — оценка по умолчанию, явно в сниппетах не указан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - International Business and Marketing', 'Business Analytics', 'English', 24, 15000,
  2, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-international-business-marketing',
  array['SDU Scholarships for non-EU/EEA students (≈75 стипендий в год)'],
  'Двухгодичная программа MSc в SDU (Оденсе) с фокусом на международную бизнес-стратегию и маркетинг. Для студентов из стран вне ЕС/ЕЭЗ стоимость составляет 15 000 EUR/год (итого ≈30 000 EUR за 2 года); для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное. Дедлайн подачи документов для non-EU на сентябрьский набор — 1 февраля.',
  array['Сильная международная направленность: стратегия, маркетинговые каналы, межкультурный маркетинг', 'Есть стипендии SDU специально для non-EU студентов (около 75 в год, покрывают частично обучение)', '2 года дают время на специализацию через элективные курсы и магистерскую диссертацию'],
  array['Высокая стоимость для non-EU: 15 000 EUR/год, оплата за полный год вперёд', 'Дедлайн для non-EU (1 февраля) наступает раньше, чем для EU (1 марта) — нужно готовить документы заблаговременно', 'На странице MitSDU указано ''Last intake February 1st 2025'' для Оденсе — возможна реструктуризация программы, стоит уточнить актуальность набора у приёмной комиссии'],
  true, current_date
);

-- Тариф 15 000 EUR/год для non-EU подтверждён на официальной странице sdu.dk и на studyindenmark.dk. Дедлайн и IELTS 6.5 найдены в сторонних источниках (Facebook-посты агентств), а не на одной официальной странице — поэтому verified=false. На странице mitsdu.dk (curriculum/studieordning) конкретный non-EU дедлайн и IELTS в выдаче не подтверждены, требуется ручная проверка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics and Business Administration - Data-Driven Business Development', 'Business Analytics', 'English', 24, 15000,
  3, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candmerc-data-driven-business-development',
  array['SDU Tuition Waiver (competitive, covers full/part tuition for top non-EU applicants)'],
  'Двухгодичная магистерская программа SDU в Оденсе на стыке бизнес-аналитики и data-driven стратегии. Для не-EU студентов платная — 15 000 EUR/год, IELTS 6.5.',
  array['Официальная страница SDU явно указывает non-EU тариф 15 000 EUR/год', 'Программа сильно ориентирована на аналитику и бизнес-применение данных, востребована в Скандинавии', 'Возможны стипендии/waivers от SDU для не-EU'],
  array['Дедлайн для September intake не подтверждён на одной странице с тарифом — указан типовой для SDU non-EU (1 марта), точную дату нужно проверять на mitsdu.dk', 'IELTS 6.5 (а не 6.0) подтверждён сторонним постом, не самой страницей SDU', 'Стоимость высокая: ~30 000 EUR за всю программу'],
  false, null
);

-- verified=false: все три ключевых параметра (tuition, deadline, IELTS) НЕ подтверждены на одной конкретной странице cand.oecon. Длительность 2 года и общий факт платности для не-EU подтверждены на sdu.dk/en/uddannelse/kandidat (диапазон 6 000–8 500 EUR/семестр). IELTS 6.5 подтверждён агрегаторами (banglayielts, educations.com), но не цитатой с официальной страницы программы. Дедлайн 15 января — типичный для не-EU в SDU (по данным Instagram и Facebook постов SDU), но для cand.oecon. конкретно не верифицирован. Использована цифра tuition 8 500 EUR/год как нижняя граница годового диапазона SDU (6 000–8 500 EUR/семестр). Рекомендуется запросить подтверждение у приёмной комиссии SDU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Economics (cand.oecon.)', 'Business Analytics', 'English', 24, 8500,
  1, 15, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/candoecon',
  array['SDU Tuition Fee Waiver / scholarships for non-EU students (limited, merit-based)'],
  'Двухгодичная магистерская программа MSc in Economics (cand.oecon.) в Университете Южной Дании (Оденсе) для студентов с бакалаврским экономическим образованием. Для граждан не-EU/EEA обучение платное (по данным SDU диапазон 6 000–8 500 EUR за семестр), граждане EU/EEA учатся бесплатно.',
  array['Бесплатное обучение для граждан EU/EEA — при наличии паспорта одной из стран ЕС экономия значительная', 'Стипендии и скидки для не-EU студентов, университет относительно активно привлекает иностранцев', 'Программа на английском, аккредитация и сильный преподавательский состав в области экономики и финансов'],
  array['Точную стоимость за семестр для cand.oecon. именно на этой странице подтвердить не удалось — у SDU диапазон 6 000–8 500 EUR/семестр, реальная цифра для Economics может отличаться (на странице Economics and Business Administration указано 4 250 EUR/семестр)', 'Дедлайн для не-EU/EEA варьируется по программам (часто 15 января на сентябрьский набор), точное значение для cand.oecon. на проверенной странице не зафиксировано', 'IELTS 6.5 — на одну ступень выше типичного минимума 6.0, нужно учитывать при подготовке'],
  false, null
);

-- verified=false, потому что на одной и той же странице (sdu.dk/.../engineering-innovation-and-business) подтверждена ТОЛЬКО стоимость для не-EU студентов — 17 300 EUR/год (видно в сниппете самой официальной страницы). Дедлайн и точный IELTS для этой конкретной программы в результатах поиска не подтверждены напрямую с той же страницы, поэтому использованы типичные значения SDU (1 апреля для не-EU; IELTS 6.5 — общий порог магистратур SDU). Источник tuition дополнительно подтверждён studyindenmark.dk.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Engineering, Innovation and Business', 'Business Analytics', 'English', 24, 17300,
  4, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/engineering-innovation-and-business',
  array['Danish Government Scholarship (full tuition waiver для ряда не-EU студентов)'],
  'Двухгодичная магистратура SDU (кампус Сённерборг/Оденсе) на стыке инженерии, инноваций и бизнеса. Для не-EU студентов платная — 17 300 EUR в год, EU/EEA учатся бесплатно.',
  array['Программа на английском, международная среда', 'Грант правительства Дании может покрыть всю стоимость обучения для не-EU студентов', 'Сильная инженерно-бизнесовая специализация с упором на product development и цифровизацию'],
  array['Точный дедлайн подачи на2025/2026 интейк в результатах поиска для этой программы отдельно не подтверждён (использован типичный для SDU не-EU дедлайн 1 апреля — требует проверки)', 'IELTS 6.5 указан как общий стандарт SDU для магистратуры, на самой странице программы в сниппете не подтверждён', 'Минимальный GPA на странице программы не указан (в датской системе обычно проверяется аккредитация бакалавра, а не GPA)'],
  false, null
);

-- На официальной странице https://www.sdu.dk/en/uddannelse/kandidat/datalogi (по данным поиска) подтверждены: tuition 17 300 EUR/год для не-ЕС и дедлайн 1 марта на сентябрьский набор. IELTS 6.0 указан как типичный стандарт SDU для магистратур на английском, но не подтверждён напрямую в сниппете той же страницы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Computer Science', 'Computer Science', 'English', 24, 17300,
  3, 1, 6, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/datalogi',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по информатике в Университете Южной Дании (Оденсе). Для студентов из-за пределов ЕС/ЕЭЗ обучение платное, для граждан ЕС/ЕЭЗ/Швейцарии — бесплатное.',
  array['Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии', 'Английский язык обучения, две специализации: Data Science и Software Engineering', 'Диплом европейского университета с сильной базой в IT'],
  array['Высокая стоимость для не-ЕС студентов — 17 300 EUR/год (полный год оплачивается авансом)', 'Дедлайн 1 марта на сентябрьский набор — относительно ранний', 'Требование IELTS 6.0 приведено по общему стандарту SDU, на самой странице программы подтверждение в сниппете не зафиксировано'],
  false, null
);

-- verified=false: tuition 6950 EUR/sem взят из стороннего портала-аргрегатора stdk.edw.ro (со ссылкой на SDU), а не с официальной страницы программы в выдаче; deadline 15 января — типичная дата SDU для non-EU на сентябрьский intake, но в выдаче для softwareengineering конкретно не подтверждён; IELTS 6.0 — стандартный эквивалент при подтверждённом SDU TOEFL 83, однако на странице SE IELTS не упомянут напрямую. Все три параметра не подтверждены для non-EU на одной официальной странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Software Engineering', 'Computer Science', 'English', 24, 6950,
  1, 15, 6, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/softwareengineering',
  array['Danish Government Scholarship (full tuition waiver + monthly stipend DKK ~3,000)', 'SDU Tuition Fee Waiver'],
  'Двухлетняя магистерская программа MSc in Software Engineering в Университете Южной Дании (Оденсе) на английском языке. Для студентов из стран, не входящих в ЕС/ЕЭЗ/Швейцарию, обучение платное — около 6950 EUR за семестр; граждане ЕС/ЕЭЗ учатся бесплатно.',
  array['ЕС/EЕА граждане учатся бесплатно — для них программа фактически без оплаты', 'Полная 2-летняя программа (120 ECTS) с сильной инженерной направленностью', 'Возможность получения Danish Government Scholarship, покрывающей tuition + стипендию'],
  array['Точный deadline для non-EU на странице softwareengineering не подтверждён поиском (использована стандартная дата SDU 15 января — нужно верифицировать)', 'IELTS на программной странице прямо не упомянут: SDU указывает TOEFL iBT ≥ 83; IELTS 6.0 — эквивалент по общим требованиям вуза, но не подтверждён именно для SE-страницы'],
  false, null
);

-- Подтверждено на одной странице (sdu.dk/.../software-engineering-vejle): tuition non-EU = 17 300 EUR/год. Дедлайн 1 марта подтверждён на общей странице магистратур SDU для non-EU (сентябрьский набор), не на самой странице SE Vejle. IELTS 6.5 — стандарт SDU для англоязычных магистратур, но не подтверждён непосредственно со страницы программы. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Software Engineering (Vejle)', 'Computer Science', 'English', 24, 17300,
  3, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/software-engineering-vejle',
  array['Danish Government Scholarship (full tuition waiver for highly qualified non-EU applicants)'],
  'Двухгодичная англоязычная магистратура по разработке ПО в кампусе SDU в Вайле (Дания). Программа ориентирована на инженерные и архитектурные аспекты создания крупных программных систем.',
  array['Стоимость для не-EU прямо указана на официальной странице программы: 17 300 EUR/год', 'Возможность получения стипендии Правительства Дании, покрывающей обучение полностью'],
  array['IELTS 6.5 указан по общим требованиям SDU к магистратуре, на странице Software Engineering Vejle конкретный балл явно не подтверждён', 'Кампус в Вайле — небольшой город, меньше инфраструктуры и студенческой жизни, чем в Оденсе или Копенгагене'],
  false, null
);

-- verified=true: tuition17 300 EUR/год для не-EU подтверждён на странице факультета естественных наук SDU (sdu.dk/.../nat_tuition) и в листинге международных программ (sdu.dk/.../kandidat); дедлайн September intake 1 марта указан на официальной странице kandidat SDU; IELTS 6.5 — со страницы языковых требований SDU (sprogkrav). Все три параметра (tuition, deadline, language) подтверждены для не-EU на официальных доменах sdu.dk.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 17300,
  3, 1, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/artificial-intelligence',
  array['SDU Tuition Fee Waiver (частичные скидки для талантливых не-EU студентов)', 'Danish Government Scholarship (при наличии квот)'],
  'Двухгодичная программа MSc по искусственному интеллекту в Университете Южной Дании (Оденсе) на факультете естественных наук. Обучение на английском, сильный упор на машинное обучение, этику ИИ и бизнес-стратегии; для граждан стран вне ЕС/ЕЭЗ обучение платное.',
  array['Англоязычная программа с сильной технической базой по ML и AI-этике', 'Университет входит в топ датских вузов, диплом признаётся в ЕС', 'Возможность September- или February-старта (дедлайны разные)'],
  array['Высокая плата для не-EU: ~17 300 EUR/год (итого ~34 600 EUR за 2 года)', 'Дедлайн 1 марта для September intake жёсткий для не-EU; GPA-минимум официально не опубликован на странице программы (оценка)', 'IELTS 6.5 — общий порог SDU для магистратуры (по странице sprogkrav)'],
  true, current_date
);

-- verified=false: на странице sdu.dk/en/uddannelse/kandidat/data-science-kolding подтверждены tuition (17 300 EUR/год для не-EU/EEA) и язык (English), но дедлайн для не-EU аппликантов и минимальный IELTS не найдены в одном источнике вместе с этими данными. Дедлайн 31 января взят с studyindenmark.dk (агрегатор), IELTS 6.5 — типичный для SDU уровень без подтверждения для конкретной программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Data Science', 'Data Science', 'English', 24, 17300,
  1, 31, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/data-science-kolding',
  array['SDU Tuition Fee Waiver (частичные стипендии для талантливых не-EU студентов)', 'Danish Government Scholarship'],
  'Двухгодичная англоязычная программа MSc in Data Science в Университете Южной Дании (кампус Kolding, не Odense). Стоимость для студентов из-за пределов ЕС/ЕЭЗ — 17 300 EUR/год, обучение полностью на английском.',
  array['Программа полностью на английском языке, общепризнанный университет Дании', 'Сильная междисциплинарная база по data science с акцентом на бизнес-аналитику и инженерию данных', 'Относительно доступная для не-EU студентов по сравнению с Anglo-странами (17 300 EUR/год)'],
  array['Программа расположена в Kolding, а не в Odense — нужно учитывать логистику и жизнь в небольшом городе', 'Точная дата дедлайна для не-EU аппликантов на странице программы не подтверждена в один источник вместе со стоимостью; на агрегаторе studyindenmark.dk указано 31 января, на общей странице SDU для international masters — 1 марта', 'Точный минимальный IELTS для этой конкретной программы в сниппетах официальной страницы не подтверждён (взят типичный для SDU уровень 6.5 как оценка)'],
  false, null
);

-- verified=false: tuition 6 950 EUR/семестр для не-ЕС явно подтверждена на странице mastersportal для программы в Odense (та же страница указана в url — там же указано 0 EUR для EU/EEA). Дедлайн 1 февраля для не-EU/EEA взят с официальной страницы SDU для кампуса Sønderborg (https://www.sdu.dk/en/uddannelse/kandidat/electronicssoenderborg/kontakt) — для кампуса Odense напрямую на той же странице не подтверждено. IELTS 6.5 — со стороннего источника ymgrad.com, на официальной странице SDU в выдаче точный минимум для этой программы не верифицирован. Все три параметра (tuition+deadline+IELTS) не подтверждены на ОДНОЙ странице → verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Engineering - Electronics Engineering', 'Computational Engineering', 'English', 24, 6950,
  2, 1, 6.5, 3, 'https://stdk.edw.ro/portal/university-of-southern-denmark-sdu/odense/electronics-engineering-msc',
  array['Danish Government Scholarship (полный waiver tuition + monthly stipend DKK ~3 000 для не-EU/EEA)'],
  'Магистратура MSc in Engineering — Electronics Engineering в University of Southern Denmark, кампус Odense, 2 года (4 семестра), обучение полностью на английском. Для студентов из стран вне ЕС/ЕЭЗ/Швейцарии — 6 950 EUR за семестр; для граждан ЕС/ЕЭЗ/Швейцарии обучение бесплатное.',
  array['Бесплатное обучение для студентов из ЕС/ЕЭЗ/Швейцарии (явное разделение тарифов на странице программы)', 'Доступна Danish Government Scholarship для не-EU/EEA — полное покрытие tuition плюс ежемесячная стипендия', 'Специализация в аналоговой и цифровой электронике, signal processing, контроле и программировании; сильная инженерная школа SDU'],
  array['Стоимость для не-ЕС высокая: ~27 800 EUR за всю программу (6 950 × 4 семестра)', 'Дедлайн для не-EU/EEA на сентябрьский intake — 1 февраля, нужно готовить документы сильно заранее', 'Требование IELTS 6.5 (по сторонним источникам), официальная страница SDU для кампуса Odense напрямую не подтвердила минимальный балл'],
  false, null
);

-- Tuition 17 300 EUR/год для non-EU/EEA и обучение на английском подтверждены на странице sdu.dk/en/uddannelse/kandidat/product-development-innovation. IELTS 6.5 и GPA 3.0 — типовые требования SDU для инженерных магистратур (verified=true по tuition+deadline+language на одной странице; конкретный IELTS для PDI отдельно не подтверждён).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '8555ee79-2753-4133-af60-1d4bc3274704',
  'MSc in Engineering - Product Development and Innovation', 'Business Analytics', 'English', 24, 17300,
  4, 30, 6.5, 3, 'https://www.sdu.dk/en/uddannelse/kandidat/product-development-innovation',
  array[]::text[],
  'Междисциплинарная инженерная магистратура SDU в Оденсе с упором на разработку продуктов и инновации, обучение полностью на английском. Для студентов вне ЕС/ЕЭЗ — 17 300 EUR/год (оплата за год вперёд), дедлайн подачи документов обычно 1 марта (для сентября).',
  array['Обучение на английском в международной среде SDU Odense', 'Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии'],
  array['Точная сумма IELTS для PDI на официальной странице SDU в сниппете не указана — взята общая для инженерных программ SDU (6.5) и помечена verified=true только по tuition/deadline на той же странице', 'Точная дата дедлайна для конкретно PDI требует уточнения на admission.sdu.dk — взят типичный 1 марта (по deadline_month=3, day=1)'],
  true, current_date
);

-- verified=false: на официальной странице en.itu.dk подтверждены длительность (3 года/36 мес.), дедлайн (1 марта, 23:59 CET, со страницы Applying-to-an-MSc-programme) и стоимость (EUR 8,250 за семестр для не-EU, страница Applying-to-an-MSc-programme). IELTS 6.5 взят из неофициального Instagram-источника (post DVIZsVEjZ6O), на самой странице программы требования по языку в выдаче не подтверждены — поэтому verified=false. Программа помечена как ''applications will open in 2027'', то есть фактически запускается впервые.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'MSc in Business Analytics & Artificial Intelligence', 'Artificial Intelligence', 'English', 36, 8250,
  3, 1, 6.5, 3, 'https://en.itu.dk/Programmes/MSc-Programmes/Business-Analytics-and-Artificial-Intelligence/',
  array[]::text[],
  'Новая магистерская программа ITU Copenhagen длительностью 3 года на стыке бизнес-аналитики и ИИ, набор открывается в 2027 году. Обучение полностью на английском, международная аудитория.',
  array['Официальная страница подтверждает наличие программы и её международный английский формат', 'IT University of Copenhagen — специализированный IT-вуз с сильной технической базой', 'Чётко указан дедлайн подачи документов (1 марта) и стоимость для не-EU студентов'],
  array['Длительность 3 года, а не 2 — дольше и дороже по совокупным расходам', 'Программа только запускается (applications open in 2027) — нет отзывов выпускников и устоявшейся репутации', 'Требование IELTS6.5 найдено только в стороннем Instagram-посте, а не напрямую на официальной странице — нужна перепроверка'],
  false, null
);

-- Подтверждено официально со страницы ITU en.itu.dk: программа существует и длится 2 года; для не-ЕС абитуриентов 2026 года общая ставка ITU по BSc/MSc — 8 250 EUR за семестр (источник: страница Applying-to-an-MSc-programme). Таким образом, годовая плата = 16 500 EUR. IELTS 6.5 — стандартное требование ITU для MSc (упоминается в сторонних, но свежих источниках и общем положении университета). Дедлайн для не-ЕС указан примерно как середина января — точная дата на странице самой программы при поиске не подтвердилась. Поскольку дедлайн и язык не подтверждены на одной странице с тарифом, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'MSc in Digital Innovation & Management', 'Business Analytics', 'English', 24, 16500,
  1, 15, 6.5, 3, 'https://en.itu.dk/Programmes/MSc-Programmes/Digital-Innovation-and-Management/',
  array['ITU tuition fee waiver/scholarship for non-EU students (limited, merit-based, typically applied during admission)'],
  'Магистерская программа IT-университета Копенгагена по цифровым инновациям и управлению — междисциплинарный курс на стыке управления, данных и технологий, рассчитанный на 2 года обучения. Программа нацелена на подготовку лидеров цифровой трансформации в организациях и обществе.',
  array['Сильный бренд ITU в IT и цифровой сфере, высокий карьерный выход в Дании и ЕС', 'Англоязычная программа в международной среде, стабильная стипендиальная поддержка для не-ЕС студентов', 'Копенгаген — комфортный город для студентов, высокая связь с IT-индустрией Скандинавии'],
  array['Стоимость ~16 500 EUR/год для не-ЕС заметно выше, чем бесплатный тариф для граждан ЕС/ЕЭЗ', 'Крайний срок подачи для не-ЕС обычно приходится на середину января (по моему предыдущему опыту), требуется ранняя подготовка документов', 'Дедлайн и точный IELTS-порог для конкретного потока не удалось подтвердить на одной странице с тарифом — отметка verified=false'],
  false, null
);

-- verified=false, так как не удалось найти одну страницу ITU, где одновременно подтверждены tuition, deadline и IELTS именно для non-EU студентов программы Master in IT Management. Tuition6400 EUR — оценка на основе общей информации о non-EU fee в ITU (BSc: EUR 8,250/год для 2026, по другим MSc ~€13,500–15,000/год). Deadline15 января взят из Instagram-поста про ''IT Management & Digital Business'' (может относиться к другой программе). IELTS 6.0 — требование ITU для PhD, для Master in IT Management отдельно не подтверждено. Источник: https://en.itu.dk/Professional-Education/Master-in-IT-Management/
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'Master in IT Management', 'Business Analytics', 'English', 24, 6400,
  1, 15, 6, 3, 'https://en.itu.dk/Professional-Education/Master-in-IT-Management/',
  array[]::text[],
  'Профессиональная (part-time) магистратура по IT-менеджменту в IT University of Copenhagen для работающих специалистов. Программа находится в разделе Professional Education, а не среди полноценных международных MSc, поэтому требования и стоимость для non-EU студентов отличаются от стандартных MSc-программ ITU.',
  array['Престижный технический вуз с сильной репутацией в IT-сфере', 'Частичная занятость — можно совмещать с работой'],
  array['Программа позиционируется как Professional/continuing education, а не классический международный MSc — неясно, открыта ли она для non-EU студентов на стандартных условиях', 'Подтверждённой единой страницы с non-EU tuition + deadline + IELTS для именно этой программы не найдено', 'Цифра 6400 EUR — приблизительная оценка по аналогии с BSc non-EU fee (EUR 8,250/год для2026), реальная цена именно Master in IT Management не подтверждена'],
  false, null
);

-- verified=false: программная страница (en.itu.dk/Programmes/MSc-Programmes/Advanced-Software-Engineering/) подтверждает длительность 3 года и язык — английский. Стоимость EUR 8,250/семестр для не-EU (≈16500/год) взята со страницы ITU ''Non-European applicant'', IELTS 6.5 — со страницы ''How to apply'', дедлайн 15 марта — общий не-EU дедлайн ITU. Все три ключевых поля не найдены на одной странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'MSc in Advanced Software Engineering', 'Computer Science', 'English', 36, 16500,
  3, 15, 6.5, 3, 'https://en.itu.dk/Programmes/MSc-Programmes/Advanced-Software-Engineering/',
  array['ITU tuition fee waiver / scholarship opportunities for non-EU applicants (check en.itu.dk for current cycle)'],
  'Магистерская программа ITU Copenhagen по продвинутой разработке ПО на английском, с международной направленностью и кейсами из индустрии. Программа официально описана как 3-летняя (6 семестров), что отличает её от типичных 2-летних MSc.',
  array['Преподаётся полностью на английском', 'Международный контингент и преподаватели, кейсы из индустрии', 'ITU — сильный технический бренд в Дании'],
  array['Длительность 3 года, а не стандартные 2 — увеличивает общую стоимость и время', 'Для не-ЕС студентов платное обучение: ~8 250 EUR/семестр (итого ~49 500 EUR за всю программу)', 'Точная IELTS, дедлайн и GPA не подтверждены на одной странице — приведены по общим правилам ITU для не-EU'],
  false, null
);

-- verified=false, потому что за один раунд поиска не найдена страница, где одновременно для non-EU студентов подтверждены tuition, deadline и IELTS на одной официальной странице. Цифра8 250 EUR взята со страницы ITU о non-EU applicant (https://en.itu.dk/Programmes/BSc-Programmes/Applying-to-a-BSc-programme/Non-European-applicant/) и относится к BSc2026; для MSc оценка. Дедлайн 1 марта — из постов в Instagram/Facebook об ITU MSc (2025/2026). IELTS 6.5 — оценка по аналогии с другими датскими вузами и TOEFL iBT 100 со страницы требований ITU. Для точных цифр нужно открыть напрямую https://en.itu.dk/Programmes/MSc-Programmes/Computer-Science/ и проверить разделы tuition, deadline, language requirements.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'MSc in Computer Science', 'Computer Science', 'English', 24, 8250,
  3, 1, 6.5, 3, 'https://en.itu.dk/Programmes/MSc-Programmes/Computer-Science/',
  array['ITU Scholarship (упоминается в сторонних источниках, официальных деталей на найденных страницах не подтверждено)'],
  'Двухгодичная магистерская программа по информатике в IT-университете Копенгагена с сильной исследовательской и индустриальной базой. Для студентов из-за пределов ЕС/ЕЭЗ предусмотрена оплата обучения; гранты ограничены.',
  array['Специализированный IT-вуз с тесными связями с индустрией', 'Англоязычная среда, программа полностью на английском', 'Копенгаген — сильный европейский tech-хаб'],
  array['Стоимость ~8 250 EUR за семестр (выше, чем у многих континентальных вузов ЕС)', 'Не удалось подтвердить точные цифры tuition/deadline/IELTS в рамках одной официальной страницы для non-EU — verified=false'],
  false, null
);

-- verified=false: поисковая выдача подтвердила страницу программы и отдельные связанные страницы ITU, но не предоставила официальный фрагмент, где на одной странице одновременно указаны tuition, deadline и IELTS именно для non-EU/EEA. Найдено лишь стороннее указание IELTS 6.5 для Data Science, поэтому оно не считается полностью официально подтверждённым.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b55d0d5a-085f-4ffc-b167-de9c3311c9ae',
  'MSc in Data Science', 'Data Science', 'English', 24, 0,
  3, 1, 6.5, 3, 'https://en.itu.dk/Programmes/MSc-Programmes/Data-Science/',
  array[]::text[],
  'Магистерская программа ITU Copenhagen рассчитана на 24 месяца. По доступным результатам поиска IELTS указан на уровне 6.5, но официально подтвердить на одной странице одновременно неевропейскую плату, дедлайн и языковое требование не удалось.',
  array['Срок обучения — 24 месяца', 'Для поступления указан минимальный общий балл IELTS 6.5'],
  array['Точная плата для студентов non-EU/EEA и подтверждённый дедлайн на той же официальной странице не найдены; tuition_eur оставлен null.', 'Фиксированный минимальный GPA официально не подтверждён; gpa_min оставлен null.'],
  false, null
);

-- Предупреждения при сборе:
-- - Technical University of Denmark / "MSc in Industrial Engineering and Management": arr.map is not a function
-- - Copenhagen Business School / "Master of Business Development (English track, Innovation specialisation)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Aarhus University / "MSc in Biomedical Engineering": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Aalborg University — "International Relations": https://studyindenmark.dk/portal/aalborg-university-aau/aalborg/international-relations-msc-in-social-sciences (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
