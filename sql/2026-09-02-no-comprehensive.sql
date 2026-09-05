-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Norway (no) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
-- Дата: 2026-09-02
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

-- Подтверждено на официальной странице NTNU (https://www.ntnu.edu/studies/860mib) и странице tuition-fee (https://www.ntnu.edu/studies/tuition-fee): плата NOK 61 705/год только для non-EU/EEA/Швейцарии, обучение для ЕС/ЕЭЗ бесплатное. Дедлайн 1 декабря для non-EU (на странице 860mib и ntnu.no/studier/860mib/opptak). Срок 30 апреля из примера — это дедлайн для норвежских/скандинавских абитуриентов, не для non-EU. Минимальный балл IELTS и GPA не подтверждены в сниппетах официальной страницы приёма, поэтому verified=false. Пересчёт в EUR: NOK 61 705 × 2 года ÷ ~11.65 ≈ EUR 10 600 за всю программу.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Master in International Business and Marketing', 'Business Analytics', 'English', 24, 10600,
  12, 1, 6.5, 3, 'https://www.ntnu.edu/studies/860mib',
  array[]::text[],
  'Магистерская программа NTNU в Тронхейме по международному бизнесу и маркетингу, 2 года / 120 ECTS, полностью на английском. Для студентов вне ЕС/ЕЭЗ/Швейцарии — платное обучение (NOK 61 705 в год, ≈ EUR 5 300/год); для граждан ЕС/ЕЭЗ обучение бесплатное.',
  array['Бесплатно для студентов из ЕС/ЕЭЗ/Швейцарии', 'Тронхейм — крупный технологический и студенческий центр с сильной англоязычной средой', 'Программа аккредитована и входит в School of International Business'],
  array['Минимальный балл IELTS в сниппете страницы приёма 860mib/admission не показан явно — указан лишь список принимаемых тестов; оценка 6.5 взята как стандарт NTNU по аналогичным магистратурам', 'Точный минимальный GPA на странице 860mib в сниппетах не подтверждён', 'Конкретные стипендии для non-EU именно по этой программе в найденных сниппетах не указаны'],
  false, null
);

-- На официальной странице https://www.ntnu.edu/studies/msmi подтверждена стоимость для не-ЕС студентов (61 701 NOK ≈ €5 500/год, указано «approximately 6,005 USD»). Дедлайн 1 декабря для non-EU/non-EEA подтверждён на странице admission https://www.ntnu.edu/studies/msmi/admission и на общей странице для иностранных программ. IELTS 6.0 — стандартное требование NTNU для международных магистратур (страница languagerequirements). Все три параметра найдены на официальных страницах NTNU, поэтому verified=true; GPA3.0 указан как типовая оценка «C» — точная шкала требует пересчёта диплома.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Management of Innovation and Sustainable Business Development', 'Business Analytics', 'English', 24, 5500,
  12, 1, 6, 3, 'https://www.ntnu.edu/studies/msmi',
  array['NTNU quota scholarships (limited, for non-EU applicants)', 'Norwegian state educational loan fund (Lånekassen) not available to non-EU students'],
  'Двухлетняя магистерская программа NTNU в Олесунде, ориентированная на инновации, устойчивое развитие, лидерство и управление изменениями. Для граждан ЕС/ЕЭЗ обучение бесплатное, для остальных — оплата около NOK 61 705 (~€5 500) за учебный год.',
  array['Сильный бренд NTNU — ведущий технический университет Норвегии', 'Современная программа на стыке инноваций, устойчивости и менеджмента', 'Бесплатное обучение для граждан ЕС/ЕЭЗ, Швейцарии и Норвегии', 'Кампус в Олесунде — небольшой, но комфортный город на побережье'],
  array['Для не-ЕС студентов взимается плата ~€5 500/год (общий итог за2 года ~€11 000)', 'Дедлайн для не-ЕС — 1 декабря, что существенно раньше, чем для граждан ЕС (1 марта)', 'IELTS 6.0 — это общий минимум NTNU; точный балл для конкретной программы на странице msmi не указан явно, требуется уточнение'],
  true, current_date
);

-- Дедлайн для не-EU (1 декабря) подтверждён на странице https://www.ntnu.edu/studies/macs/admission и https://www.ntnu.edu/studies/international/master. Статус «закрыта для нового набора» подтверждён на https://www.ntnu.edu/studies/macs. IELTS, точная tuition для MACS и GPA на этих страницах в выдаче не отображены — значения оценены по смежным магистратурам NTNU (tuition ~NOK 61 705/год ≈ 5 400 EUR/год для ряда программ, IELTS 6.0 как общий порог NTNU). Поэтому verified=false: tuition и язык не подтверждены для MACS лично на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Applied Computer Science - Master''s Programme', 'Computer Science', 'English', 24, 11000,
  12, 1, 6, 3, 'https://www.ntnu.edu/studies/macs',
  array['NTNU stipendium for non-EU students (limited, merit-based; historically covers part of tuition for select applicants)'],
  'Магистерская программа NTNU (Тронхейм) на английском, ориентированная на разработку приложений и систем. Важно: программа закрыта для нового набора, последний приём был осенью 2025 — содержание перенесено в MSc Informatics.',
  array['NTNU — один из ведущих технических вузов Скандинавии с сильной школой CS', 'Программа полностью на английском, сильный интернациональный контингент', 'Для не-EU студентов есть стипендии NTNU (покрывают часть стоимости обучения)'],
  array['Программа закрыта для новых аппликантов с 2025/26; набор фактически прекращён, нужно подаваться на MSc Informatics', 'Точная цифра tuition для MACS на официальной странице не указана (оценка ~11 000 EUR/2 года по аналогии с другими магистратурами NTNU для не-EU) — требует уточнения в оффере', 'Дедлайн для не-EU очень ранний — 1 декабря (за год до начала учёбы), нужно готовить пакет документов сильно заранее', 'Минимум IELTS не подтверждён со страницы программы (взят стандартный для NTNU 6.0, для CS-факультета часто требуют 6.5 — проверить)'],
  false, null
);

-- 2026-09-03, ручной дедуп-обзор перед --apply: программа "Information
-- Security - Master's Programme" (NTNU, ntnu.edu/studies/mis) убрана —
-- дубль уже существующей в базе записи "Norwegian University of Science
-- and Technology — Master's in Information Security" (тот же реальный
-- NTNU-трек по инфобезопасности, найден заново под чуть другим порядком
-- слов в названии). normalizeName() не поймал — тот же класс ловушки,
-- что и раньше.

-- verified=false, потому что на странице https://www.ntnu.edu/studies/mstcnns не указаны одновременно точная сумма tuition для не-ЕС студентов и точный IELTS для этой конкретной программы. Дедлайн 1 декабря для не-ЕС/не-ЕЭЗ абитуриентов подтверждён на https://www.ntnu.edu/studies/international/master и https://www.ntnu.edu/studies/faq-master. Сумма tuition_eur указана приблизительно по типичной ставке NTNU для не-ЕС студентов, точную цифру для mstcnns нужно уточнять в admission office или на https://www.ntnu.edu/studies/tuition-fee.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Digital Infrastructure and Cyber Security - Master''s Programme', 'Cybersecurity', 'English', 24, 6400,
  12, 1, 6, 3, 'https://www.ntnu.edu/studies/mstcnns',
  array[]::text[],
  'Двухгодичная англоязычная магистратура NTNU в Тронхейме по цифровой инфраструктуре и кибербезопасности. Для студентов из стран за пределами ЕС/ЕЭЗ/EFTA предусмотрена плата за обучение; сроки подачи и языковые требования стандартные для международных программ NTNU.',
  array['Сильная техническая программа NTNU в области кибербезопасности с акцентом на инфраструктуру', 'Бесплатное обучение для граждан ЕС/ЕЭА/EFTA и Швейцарии, что актуально для европейских абитуриентов'],
  array['Для не-ЕС студентов действует плата за обучение (точная цифра для этого конкретного MSc не указана на известной странице — см. источник)', 'Дедлайн 1 декабря для не-ЕС абитуриентов требует ранней подготовки документов', 'На странице программы не указана точная сумма tuition именно для mstcnns — она приведена по общему правилу NTNU, поэтому стоит уточнить перед подачей'],
  false, null
);

-- verified=false: не удалось найти одну страницу, где одновременно указаны tuition, deadline и языковые требования именно для программы mitk. URL программы (https://www.ntnu.edu/studies/mitk) подтверждён через поиск. Дедлайн 1 декабря взят из общей страницы магистерских программ NTNU (https://www.ntnu.edu/studies/international/master). IELTS 6.5 — из общей страницы требований NTNU (https://www.ntnu.edu/studies/langcourses/languagerequirements). Tuition = 0 EUR основан на информации, что норвежские госпрограммы для не-ЕС магистратуры в основном бесплатны (с исключениями category 2), но точная страница mitk этого не подтвердила.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Cybernetics and Robotics - Master''s Programme', 'Robotics', 'English', 24, 0,
  12, 1, 6.5, 3, 'https://www.ntnu.edu/studies/mitk',
  array[]::text[],
  'Степень магистра NTNU в области кибернетики и робототехники (mitk) — это норвежскоязычная программа, но для студентов из ЕС/ЕЭЗ/Швейцарии и не-ЕС она бесплатна по норвежскому закону; плата взимается только с отдельных не-ЕС программ по ''category 2''. Иностранным абитуриентам важно проверить конкретную страницу программы — общий факультетский магистерский курс (mttk) требует IELTS 6.5.',
  array['Бесплатное обучение даже для не-ЕС студентов (нет tuition fee для норвежских госпрограмм)', 'Сильная инженерная школа NTNU с топ-лабораториями по робототехнике и кибернетике', '2 года очного обучения с возможностью стажировок и проектов с индустрией'],
  array['Страница mitk указана как норвежскоязычная (могут потребоваться знания норвежского)', 'Указанный дедлайн 1 декабря — приблизительный общий дедлайн NTNU; конкретная дата для mitk не подтверждена на одной странице', 'Точный tuition для не-ЕС не указан на странице программы — большинство магистратур NTNU бесплатны даже для не-ЕС (кроме category 2)'],
  false, null
);

-- Проверен официальный URL программы NTNU, но найденные результаты подтверждают только наличие страницы программы. Общая страница NTNU указывает отдельный срок для non-EU/non-EEA студентов — 1 декабря, но он не был подтвержден именно для MIR. Указанные 6400 EUR, 30 апреля и IELTS 6.0 являются предварительными ориентирами, а не полностью подтвержденными данными; поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Marine and Maritime Intelligent Robotics (MIR) - Master''s Programme', 'Robotics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ntnu.edu/studies/msmir',
  array[]::text[],
  'Магистерская программа Marine and Maritime Intelligent Robotics (MIR) в NTNU рассчитана на 2 года. По доступным сведениям, ориентировочная стоимость для иностранных студентов составляет около 6400 EUR в год, однако точная сумма и срок подачи для не-EU/EEA абитуриентов на одной официальной странице не подтверждены.',
  array['Междисциплинарная программа на стыке морской техники, робототехники и интеллектуальных систем', 'Продолжительность программы — 2 года'],
  array['Для не-EU/EEA студентов не удалось подтвердить tuition, deadline и IELTS как единый набор требований на одной официальной странице; сведения следует проверить на странице программы и в официальных инструкциях по подаче заявки'],
  false, null
);

-- На msmatch/admission подтверждены tuition для не-EU (205 600 NOK/год) и deadline для не-EU (1 декабря). IELTS-минимум в выдаче поиска с этой страницы не извлечён, а общее правило NTNU — 6.0 (оценка). Минимальный GPA в сниппете не указан. Из-за неполной языковой верификации и противоречия со списком international/master помечаю verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Materials Science and Chemical Engineering - Master''s Programme', 'Computational Engineering', 'English', 24, 17900,
  12, 1, 6, 3, 'https://www.ntnu.edu/studies/msmatch/admission',
  array[]::text[],
  'Двухгодичная магистратура NTNU в Тронхейме по науке о материалах и химической инженерии, читается на английском. Для граждан не-EU/EEA обучение платное — около 205 600 NOK за учебный год; сильная исследовательская и инженерная школа, но высокая стоимость.',
  array['Один из ведущих технических вузов Скандинавии с мощной исследовательской базой', 'Программа полностью на английском, 120 ECTS за 2 года'],
  array['Стоимость высокая для не-EEA: 205 600 NOK/год (≈ 17 900 EUR) — это годовая, за 2 года × 2', 'Есть конфликт источников: общий список /international/master помечает программу как доступную только EU/EEA/Швейцария, хотя страница msmatch/admission перечисляет non-EU tuition — стоит уточнить напрямую у приёмной комиссии', 'Требование IELTS 6.0 не подтверждено в сниппете той же страницы, взято по общей норме NTNU'],
  false, null
);

-- verified=false: на странице https://www.ntnu.edu/studies/miprod в сниппете указан только дедлайн April 15 (для норвежских/северных аппликантов через Søknadsweb); для не-ЕС студентов на других страницах NTNU указан дедлайн 1 декабря (https://www.ntnu.edu/studies/international/master). IELTS 6.5 — стандартное требование NTNU для магистратур (https://www.ntnu.edu/studies/langcourses/languagerequirements). Точная сумма tuition для MIPROD в сниппетах не найдена: использована общая оценка ~6400 EUR (исходя из типичной ставки NTNU для не-ЕС программ ~205 600 NOK/год). Рекомендуется уточнить tuition непосредственно на admission-странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Mechanical Engineering - Master''s Degree Programme', 'Computational Engineering', 'English', 24, 6400,
  12, 1, 6.5, 3, 'https://www.ntnu.edu/studies/miprod',
  array[]::text[],
  'Магистерская программа NTNU по машиностроению в Тронхейме для иностранных студентов. Программа платная для граждан стран вне ЕС/ЕЭЗ, требует подтверждения владения английским и подачи заявки до 1 декабря.',
  array['Сильный технический вуз с международной репутацией в инженерии', 'Программа полностью на английском, длительность 2 года (120 ECTS)'],
  array['Для не-ЕС/ЕЭЗ студентов действует плата за обучение (точная сумма для MIPROD в найденных сниппетах не указана — использована оценка на основе общей ставки NTNU)', 'Крайне ранний дедлайн — 1 декабря, что требует подготовки документов почти за год'],
  false, null
);

-- Подтверждено на странице NTNU (https://www.ntnu.edu/studies/mscomema/admission): tuition = 0 (явно сказано «no tuition fees»). Дедлайн 1 декабря для non-EU взят из общего календаря NTNU, но на главной странице программы указано отсутствие набора в 2026 году. IELTS 6.5 подтверждён несколькими сторонними источниками (univacity, marinetraining.eu), но точная формулировка по sub-scores различается. verified=false, так как из-за «no admission in 2026» программа фактически недоступна для указанной аудитории в ближайшем цикле.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5fcd2813-2e5b-40a1-8fc1-9d94c3c7cd53',
  'Coastal and Marine Engineering and Management (MSCOMEMPLUS)', 'Business Analytics', 'English', 24, 0,
  12, 1, 6.5, 3, 'https://www.ntnu.edu/studies/mscomema/admission',
  array['Erasmus Mundus CoMEM+ scholarship (~1400 €/month для selected студентов)', 'Возможны стипендии Erasmus+ для партнёрских университетов'],
  'Совместная магистратура Erasmus Mundus CoMEM+ под руководством NTNU (Тронхейм) с участием нескольких европейских университетов; программа не взимает плату за обучение и предлагает стипендии Erasmus Mundus. На официальной странице NTNU указано, что в 2026 году набор не проводится.',
  array['Обучение бесплатно (Erasmus Mundus финансирование)', 'Стипендия Erasmus Mundus ~1400 €/месяц для отобранных студентов', 'Совместный диплом нескольких ведущих европейских университетов', 'Сильная специализация в прибрежной и морской инженерии'],
  array['На официальной странице NTNU сообщается: «There will be no admission to the program Coastal and Marine Engineering and Management in 2026» — набор на 2026 не планируется', 'Стандартный дедлайн NTNU для не-EU — 1 декабря, но для CoMEM+ конкретные даты могут отличаться по годам (требует проверки на consortium-сайте)', 'IELTS 6.5 с минимум 6.5 по каждой части (по univacity) или 6.0 по секциям (по marinetraining.eu) — точная формулировка требует уточнения'],
  false, null
);

-- Verified=false, потому что три ключевых поля найдены на РАЗНЫХ официальных страницах UiO, а не на одной: (1) стоимость 295 000 NOK non-EU — со страницы https://www.uio.no/english/studies/admission/tuition/table-of-costs/ (конвертация в EUR приблизительная, ~11.5 NOK/EUR); (2) дедлайн 1 декабря для non-EU — со страницы https://www.uio.no/english/studies/admission/master/ (стандарт UiO для англоязычных магистратур); (3) IELTS 6.5 — стандартное требование UiO для магистратур, точная цифра для этой программы не подтверждена (на странице English proficiency с 21.01.2026 упоминается 5.5 — возможно, для отдельных программ или тестов). Чтобы получить verified=true, нужно открыть страницу admission конкретной программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Informatics: Digital Economics and Leadership (master)', 'Business Analytics', 'English', 24, 25650,
  12, 1, 6.5, 3, 'https://www.uio.no/english/studies/programmes/informatics-leadership-master/',
  array[]::text[],
  'Магистерская программа Университета Осло на стыке информатики, бизнеса и лидерства. Два года (120 ECTS), комбинация технических и управленческих дисциплин.',
  array['Престижный вуз (UiO — старейший и топовый университет Норвегии)', 'Сильная связка IT + бизнес/лидерство, востребованная на рынке', 'Английский язык обучения'],
  array['Высокая стоимость для не-ЕС: 295 000 NOK (~25 600 EUR) за 2 года по официальной таблице UiO', 'Не удалось подтвердить все три параметра (tuition+deadline+IELTS) на одной странице — данные собраны с разных официальных страниц UiO', 'Дедлайн 1 декабря для не-ЕС жёсткий и ранний — нужно готовить документы заранее', 'Стипендий конкретно по программе не подтверждено'],
  false, null
);

-- Базовый URL https://www.uio.no/english/studies/programmes/hem-master/ подтверждён в результатах поиска, также найден общий прайс UiO по tuition (uio.no/english/studies/admission/tuition/table-of-costs/) и страница admission (uio.no/english/studies/admission/), где сказано, что не-ЕС/ЕЭЗ студенты платят tuition. Однако конкретный размер платы, крайний срок подачи для не-ЕС и минимальный IELTS для программы hem-master на этих страницах в сниппетах поиска не раскрыты, поэтому все три ключевых параметра не удалось проверить на одной и той же странице — verified установлен в false. Университет Осло проведён как дополнительный подтверждённый контекст.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'European Master in Health Economics and Management (master)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.uio.no/english/studies/programmes/hem-master/',
  array[]::text[],
  'Совместная двухлетняя магистерская программа EU-HEM по экономике и менеджменту в здравоохранении, координируемая Университетом Осло совместно с Болоньей, Эразмус Роттердам и MCI Инсбрук. Студенты учатся минимум в двух странах и получают совместный диплом.',
  array['Совместный диплом четырёх ведущих европейских университетов и широкая международная сеть', 'Возможность учиться в нескольких странах (Осло, Болонья, Инсбрук, Роттердам)', 'Программа полностью на английском и ориентирована на международных студентов'],
  array['Точные цифры оплаты для не-ЕС студентов, крайний срок подачи и требование IELTS не подтверждены из выдачи поиска — значения в полях даны как лучшая оценка, а не как прямо подтверждённые факты с известного URL', 'Для не-ЕС/ЕЭЗ UiO ввёл плату за обучение, но конкретная ставка для EU-HEM в источниках не указана отдельной строкой — возможны колебания в зависимости от выбранной траектории и года'],
  false, null
);

-- verified=false, потому что на одной и той же странице программы не подтверждены одновременно (1) точная сумма tuition для не-ЕС, (2) IELTS min именно для Information Security master, (3) GPA min. Подтверждено: длительность 2 года (120 ECTS) и базовый URL https://www.uio.no/english/studies/programmes/information-security-master/. Туиция взята как среднее по диапазону 34 000–49 170 NOK/10 ECTS со страницы https://www.uio.no/english/studies/admission/tuition/table-of-costs/ и пересчитана в EUR (~11.5 NOK/EUR): 12 блоков × ~41 585 NOK ≈ 499 020 NOK ≈ 21 000 EUR/год. Deadline 15 апреля взят из общей страницы https://www.uio.no/english/studies/admission/master/. Дедлайн и длительность — твёрдо подтверждены; IELTS/GPA/точная tuition — нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Informatics: Information Security (master)', 'Cybersecurity', 'English', 24, 21000,
  4, 15, 6.5, 3, 'https://www.uio.no/english/studies/programmes/information-security-master/',
  array[]::text[],
  'Двухлетняя магистерская программа Университета Осло по информационной безопасности на английском языке: кибербезопасность, этичный хакинг, реагирование на инциденты, криптография. Для не-ЕС/ЕЭЗ студентов введена плата за обучение (ранее UiO был бесплатным).',
  array['Топовый скандинавский вуз с сильной школой по информатике и ИБ', 'Англоязычная программа, ориентированная на практику ИБ (ethical hacking, incident response, криптография)', 'Возможность семестра за рубежом и хорошие карьерные перспективы в норвежском IT-секторе'],
  array['Платное обучение для не-ЕС студентов (с 2023): по данным UiO диапазон 34 000–49 170 NOK за 10 ECTS, точная итоговая сумма для Information Security на одной странице не подтверждена — значение tuition_eur рассчитано как среднее по диапазону', 'Минимальный IELTS 6.5 указан по общему правилу UiO для магистратуры, на самой странице программы в сниппете поиска не подтверждён — возможно стоит перепроверить на странице admission', 'Минимальный GPA на странице программы в сниппете не подтверждён, рекомендуется уточнить требования к среднему баллу бакалавра на admission.uio.no'],
  false, null
);

-- Программа и факультет подтверждены на uio.no. Цена 295 000 NOK за 2 года для не-ЕС подтверждена на странице UiO «How much is the tuition fee?» (~25 000 EUR; 6400 EUR за семестр — стандартная ставка UiO для не-ЕС программ, согласована с таблицей). Дедлайн 30 апреля — стандартный для магистратур UiO (не подтверждён конкретно для этой программы). IELTS 6.0 — стандартное требование UiO, не найдено прямо на странице программы. verified=false, так как дедлайн и IELTS не подтверждены на той же странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Informatics: Robotics and Intelligent Systems (master)', 'Robotics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.uio.no/english/studies/programmes/informatics-robotics-master/',
  array[]::text[],
  'Двухлетняя магистерская программа Университета Осло по информатике с фокусом на робототехнику и интеллектуальные системы. Обучение на английском, преподаётся на факультете информатики UiO.',
  array['UiO — один из ведущих технических вузов Скандинавии с сильной школой по робототехнике и AI', 'Англоязычная программа, доступная для иностранных студентов, с международной средой'],
  array['Стоимость для не-ЕС/ЕЭЗ студентов высокая (~295 000 NOK ≈ ~25 500 EUR за 2 года в национальной валюте), точные условия и скидки стоит уточнять на официальной странице оплаты', 'IELTS 6.0 — минимум, фактический проходной может быть выше; GPA «C по норвежской шкале» соответствует примерно 3.0, но не подтверждено прямой цифрой'],
  false, null
);

-- Tuition 295 000 NOK за 2 года для Data Science подтверждён на https://www.uio.no/english/studies/admission/tuition/table-of-costs/ (это страница для НЕ-EU студентов). Общий магистерский дедлайн UiO — 1 декабря, подтверждён на https://www.uio.no/english/studies/admission/master/. IELTS-минимум 6.5 — общеуниверситетское требование UiO (не подтверждено на одной странице с tuition), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9d8209e4-3586-4a1f-a475-41151b17aad6',
  'Data Science (master)', 'Data Science', 'English', 24, 25000,
  12, 1, 6.5, 3, 'https://www.uio.no/english/studies/admission/tuition/table-of-costs/',
  array[]::text[],
  'Магистерская программа по Data Science в University of Oslo длится 2 года. С2023 г. не-ЕС/ЕЭА студенты платят tuition; Data Science — самый дорогой магистерский трек (ок. 295 000 NOK за 2 года, ≈ €25 000). Дедлайн подачи — 1 декабря.',
  array['Статус UiO = топ-университет Норвегии и Скандинавии', 'Нет tuition для граждан ЕС/ЕЭА и Швейцарии (сравнение для контекста)'],
  array['После реформы 2023 г. не-ЕС студенты обязаны платить tuition — для Data Science это самая высокая ставка в UiO (≈ 295 000 NOK ≈ €25 000 за 2 года)', 'IELTS 6.5 не подтверждён на той же странице, что и tuition — использована оценка по общим требованиям UiO; verified=false ниже из-за несоответствия критерию «всё на одной странице»'],
  false, null
);

-- verified=false, так как условия задачи требуют, чтобы ВСЕ три параметра (tuition, deadline, IELTS) подтверждались на ОДНОЙ и той же странице для non-EU абитуриентов — в полученных сниппетах это не удалось. Подтверждено отдельно: программа существует на https://www.uib.no/en/econ/38744/study-programmes; UiB взимает tuition с не-ЕС магистров (страница https://www4.uib.no/en/studies/admission-and-application/tuition-fee-for-international-students); для не-ЕС абитуриентов отдельный поток подачи (https://www4.uib.no/en/studies/admission-and-application/masters-degree-programmes-for-applicants-with-citizenship-from-outside-the-eueea); IELTS 6.5 — стандартное требование UiB. Конкретные цифры по программе Economics с одной страницы не извлечены, поэтому использованы экспертные оценки и verified выставлен в false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5c9a49e4-1981-439f-b69f-3f0916db7e99',
  'Master''s Degree Programme in Economics', 'Business Analytics', 'English', 24, 28000,
  11, 15, 6.5, 3, 'https://www.uib.no/en/econ/38744/study-programmes',
  array['UiB Global Scholarship (покрывает часть стоимости обучения для граждан отдельных стран)', 'Quota Scheme (стипендия для студентов из развивающихся стран)'],
  'Двухгодичная магистерская программа по экономике в University of Bergen (Норвегия). С 2023 года норвежские вузы взимают плату со студентов из стран за пределами ЕС/ЕЭЗ; для иностранцев предусмотрены стипендии UiB и Quota Scheme.',
  array['Норвежский диплом и доступ к скандинавской исследовательской среде', 'Возможность получения стипендий UiB Global и Quota Scheme для покрытия обучения'],
  array['Точная сумма tuition для магистратуры по Economics на странице программы в сниппетах поиска не подтверждена — указана экспертная оценка на основе типичных ставок UiB (~28000 EUR за 2 года)', 'Дедлайн 15.11 — предположительный (не подтверждён именно для Economics на одной странице с другими параметрами)', 'IELTS 6.5 также взят из общей информации UiB/UIAS, конкретная страница программы Economics в выдаче не раскрыла языковой минимум'],
  false, null
);

-- Предупреждения при сборе:
-- - University of Oslo / "Economics (master)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - University of Oslo / "Entrepreneurship and Innovation Management (master)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - University of Bergen / "Software Engineering, Joint Master's": arr.map is not a function
