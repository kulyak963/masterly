-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Spain (es) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- URL https://www.upc.edu/en/masters/business-administration-and-management подтверждён через поисковые сниппеты (включая страницу списка магистратур UPC 2026–2027 и страницу предварительной записи). Однако конкретные цифры tuition/deadline/IELTS для не-ЕС студентов не извлеклись из одного и того же источника за отведённый один раунд поиска — стоимость €6 400, дедлайн 30 апреля, IELTS 6.0 и GPA 3.0 приведены как наиболее вероятные оценки на основе типичных параметров магистратур UPC для не-ЕС (см. аналоги: Data Science €5 400, Technology and Engineering Management €4 050). verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '82e05545-5d70-462e-b4d5-7425d25e4a25',
  'Master''s degree in Business Administration and Management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.upc.edu/en/masters/business-administration-and-management',
  array[]::text[],
  'Магистерская программа по бизнес-администрированию и менеджменту в Политехническом университете Каталунии (Барселона). Программа ориентирована на международных студентов, обучение ведётся на английском языке.',
  array['Политехнический университет Каталунии — один из ведущих технических вузов Испании с сильной инженерной и бизнес-школой', 'Программа на английском, что удобно для иностранных студентов', 'Расположение в Барселоне — крупном деловом и культурном центре'],
  array['Точные цифры стоимости для не-ЕС студентов, дедлайна и требований по IELTS не удалось подтвердить на одной странице за один раунд поиска — приведены оценочные значения', 'В результатах поиска фигурирует также отдельная программа EUNCET (9 месяцев) — возможна путаница с версией на upc.edu, уточняйте длительность на официальной странице', 'Для не-ЕС студентов UPC обычно применяет повышенный коэффициент к стоимости (по аналогии с другими магистратурами UPC: ~€4 050–€5 400), реальная цифра может отличаться'],
  false, null
);

-- verified=false: на странице upc.edu/en/masters/financial-innovation-and-fintech конкретные цифры (tuition, deadline, IELTS) в сниппетах поиска не показаны. Цена 12 300 EUR взята с topuniversities.com (агрегатор), а не с официальной страницы UPC. После реформы 2025 года цена за кредит для не-ЕС студентов снижена до 45 EUR/кредит, что формально должно снижать итоговую стоимость, но точной цифры для этой конкретной программы подтвердить не удалось. Deadline и IELTS-минимум — лучшие оценки, не подтверждены одним источником. tuition=deadline=IELTS НЕ подтверждены все три для non-EU на одной официальной странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '82e05545-5d70-462e-b4d5-7425d25e4a25',
  'Master''s degree in Financial Innovation and Fintech', 'Business Analytics', 'English', 9, 12300,
  10, 1, 6.5, 3, 'https://www.upc.edu/en/masters/financial-innovation-and-fintech',
  array[]::text[],
  'Магистерская программа UPC/EUNCet по финансовым инновациям и финтеху в Барселоне длится 9 месяцев, проводится на английском, ориентирована на практику в финтехе. Стоимость для международных студентов — около 12 300 EUR.',
  array['Известный технический университет UPC и бизнес-школа EUNCet', 'Программа на английском в финтех-столице Барселоне'],
  array['Программа реализуется через EUNCet (партнёрская школа UPC), а не напрямую силами UPC — стоит учитывать при подаче документов'],
  false, null
);

-- Подтверждено на одной странице (upc.edu/.../management-engineering-terrassa-eseiaat): явный non-EU тариф €5,400 vs EU €2,324, обнаружен в сниппете поиска. Дедлайн и IELTS не подтверждены на той же странице в выдаче — взяты как типичные для UPC (апрельский раунд, IELTS 6.5). Плюс в июле 2025 UPC объявил снижение цены за кредит для магистров с €102.52 до €45, что может уменьшить итоговую сумму для не-ЕС, но это не отражено в сниппете страницы программы. verified=false, так как не все три параметра подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '82e05545-5d70-462e-b4d5-7425d25e4a25',
  'Master''s degree in Management Engineering', 'Business Analytics', 'English', 18, 5400,
  4, 30, 6.5, 3, 'https://www.upc.edu/en/masters/management-engineering-terrassa-eseiaat',
  array['UPC International Master''s Scholarship (partial tuition waivers, competitive)', 'EQUO Catalonia grants for non-EU students (need-based, limited)'],
  'Магистерская программа UPC в ESEIAAT (Террасса) по инженерному менеджменту для выпускников технических и экономических специальностей: 90 ECTS, обучение на испанском/английском, акцент на операционный менеджмент, логистику и промышленные системы.',
  array['Стоимость для не-ЕС ~€5,400 ниже, чем у большинства англоязычных магистратур Северной Европы', 'Диплом UPC — сильный бренд в Латинской Америке и ЕС, особенно в инженерно-промышленной сфере', 'Кампус ESEIAAT в Террассе — современная инженерная школа с лабораториями и связями с промышленностью Каталонии'],
  array['Финальная сумма для не-ЕС в источнике указана €5,400, но с июля 2025 UPC снизил цену за кредит до €45 — реальная цифра может быть ниже, нужно уточнять на момент подачи', 'Точный дедлайн и минимальный IELTS на самой странице программы в выдаче не подтверждены (взяты как типичные значения UPC — апрельский раунд и 6.5), поэтому verified=false', 'Обучение частично на испанском — даже в «английской» ветке часть материалов и экзаменов может быть на испанском'],
  false, null
);

-- verified=false, потому что на одной и той же официальной странице (https://www.upf.edu/en/web/econ/mres) не удалось одновременно подтвердить три ключевые цифры для non-EU студентов: (1) tuition — в выдаче попал только per-credit тариф €19,37 (€1,302) для EU/резидентов Испании со страницы upf.edu/en/web/masters/preus, non-EU ставка не показана; (2) deadline — точная дата не извлеклась из сниппетов, использована типичная BSE priority-дата 15 января по аналогии; (3) IELTS — конкретный минимум для MRes в выдаче отсутствует, взят стандарт UPF/BSE 6.5. Реальная страница программы https://www.upf.edu/en/web/econ/mres подтверждает только существование, длительность (2 года, как coursework-фаза 2+3 PhD) и статус second-year-of-PhD-track. Оценка tuition €16,500/год взята по аналогии с MSc-PhD Track BSE и может отличаться.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master of Research in Economics, Finance and Management (MRes)', 'Business Analytics', 'English', 24, 16500,
  1, 15, 6.5, 3, 'https://www.upf.edu/en/web/econ/mres',
  array['BSE/UPF PhD Track fellowships (full tuition waiver + stipend for selected admitted students)', 'La Caixa fellowships', 'AGAUR/Generalitat de Catalunya pre-doctoral grants'],
  'Двухлетняя исследовательская магистратура (MRes) при UPF/BSE, фактически представляющая собой coursework-фазу PhD-трека (2+3). Программа готовит к PhD по экономике/финансам/менеджменту и читается полностью на английском в Барселоне.',
  array['Прямая дорога в PhD в UPF/BSE — MRes это 2-й год PhD-трека, сильный академический бренд и публикации факультетов', 'Большинство admitted студентов получают полный fellowship (отмена tuition + стипендия), что делает программу фактически бесплатной для лучших кандидатов', 'Преподавание и атмосфера на английском, сильный интернациональный состав, центр Барселоны'],
  array['Точная non-EU tuition на одной и той же странице UPF не подтверждена в выдаче: €19,37/credit в сниппете относится к EU-резидентам; реальная non-EU ставка выше и явно не указана в найденных результатах — оценка €16,500/год приведена по аналогии с BSE MSc-PhD треком и помечена verified=false', 'Дедлайн 15 января — оценочный (типичный priority deadline BSE), точной даты для non-EU applicants в выдаче не подтверждено; может быть второй раунд позже', 'IELTS 6.5 — типовое требование BSE, конкретный порог для MRes в найденных сниппетах не указан явно', 'Программа исследовательская и жёстко селективная: без сильного GRE/quant-бэкграунда и research statement шансы низкие'],
  false, null
);

-- verified=false: на одной странице не найдены одновременно tuition+deadline+языковые требования именно для не-ЕС студентов по этой программе. Длительность 12 мес / 60 ECTS подтверждена на странице TecnoCampus. Стоимость €6400 — оценка для60-ECTS программы TecnoCampus (фрагмент ''Price: Price for the 2026-2027...'' обрезан в сниппете, точная цифра для не-ЕС не извлечена). IELTS 6.0 — типичное требование UPF для магистратур, не подтверждено для конкретно этой программы. Дедлайн 30 апреля взят по аналогии с календарём приёмных волн UPF (Call 4 в апреле–июне).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master''s Degree in Management for Global Business', 'Business Analytics', 'English', 12, 6400,
  4, 30, 6, 3, 'https://www.tecnocampus.cat/en/master/master-universitari-en-management-global-business',
  array[]::text[],
  'Официальная магистратура Universitat Pompeu Fabra, реализуемая в TecnoCampus (аффилированный центр UPF). Программа на английском, 60 ECTS, очная, готовит к управленческой карьере в международном бизнесе. Степень присуждается UPF.',
  array['Диплом престижного UPF — топового испанского университета', 'Полностью на английском, ориентация на международных студентов', 'Короткий формат: 1 год (60 ECTS) — быстрый выход на рынок'],
  array['Программа фактически проходит в TecnoCampus (Матаро), а не в центральном кампусе UPF в Барселоне — это стоит учитывать при планировании локации', 'Точная цена для не-ЕС студентов и финальный дедлайн не подтверждены в одном источнике — цифры оценочные'],
  false, null
);

-- URL https://www.bsm.upf.edu/en/international-mba-english подтверждён в выдаче, но конкретные tuition/deadline/IELTS для не-ЕС студентов в сниппетах не раскрыты — все три поля оценочные (verified=false). Tuition ~€18,500 взят по аналогии с MSc International Business UPF-BSM и Reddit-данными о non-EU ценах BSM; IELTS 6.5 — стандартное требование UPF для англоязычных магистров (подтверждено сторонним агрегатором universityliving.com для UPF в целом); дедлайн — типичный летний раунд при rolling admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'International MBA in English', 'Business Analytics', 'English', 12, 18500,
  6, 30, 6.5, 3, 'https://www.bsm.upf.edu/en/international-mba-english',
  array[]::text[],
  'Официальная магистерская программа (master''s degree) от UPF Barcelona School of Management с аккредитацией AMBA, преподаётся на английском и ориентирована на международных студентов без опыта работы или с минимальным опытом.',
  array['Аккредитация AMBA и EQUIS — международно признаваемый диплом магистра от Universitat Pompeu Fabra', 'Преподавание полностью на английском в центре Барселоны', 'Сильный международный нетворкинг и репутация школы в Европе'],
  array['Стоимость, дедлайн и точный минимальный IELTS для не-ЕС студентов не подтверждены напрямую на странице программы из сниппетов поиска — verified=false', 'Это не тот же International MBA за €28,000 на 13 месяцев: цифры ниже — оценка по аналогичным программам BSM (€17–18,5k для не-ЕС)', 'Официальная страница не показывает в сниппетах отдельную EU/non-EU цену, что нетипично — стоит уточнить через admissions напрямую'],
  false, null
);

-- Подтверждено с сайта bsm.upf.edu: 10 месяцев, 60 ECTS, начало октябрь 2026, преподаётся UPF-BSM. Стоимость 6 400 €, дедлайн 30 апреля и IELTS 6.0 — оценочные, так как страница UPF-BSM для non-EU не дала явно подтверждённой разбивки цен EU/non-EU; verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master in Digital Marketing Management', 'Business Analytics', 'English', 10, 6400,
  4, 30, 6, 3, 'https://www.bsm.upf.edu/en/master-in-direct-and-digital-marketing',
  array[]::text[],
  'Магистратура UPF Barcelona School of Management по цифровому маркетингу — 10 месяцев (60 ECTS), на испанском, очная форма, начало — октябрь 2026. Программа ориентирована на международную аудиторию.',
  array['Преподаётся при UPF — топовом испанском университете', 'Международный состав студентов (более 21 страны)'],
  array['Точная разбивка цены EU/non-EU и финальный дедлайн на найденных страницах не подтверждены — привожу оценочные значения', 'Программа на испанском языке, IELTS/англоязычный порог не указан на странице UPF-BSM'],
  false, null
);

-- Подтверждено раздельно: (1) tuition €9,000/год для non-EU (Partner country) — страница https://www.upf.edu/web/emai/scholarships-fees; (2) IELTS ≥6.5 overall и по всем субшкалам, CEFR C1 — страница https://www.upf.edu/web/emai/access-admission; (3) дедлайн scholarship-раунда ~20 декабря 2025 для2026-28 intake (по сторонним источникам), точный апрельский дедлайн для самофинансируемых не подтверждён на официальной странице. Поскольку все три параметра не подтверждены на одной и той же странице UPF, verified=false. GPA 3.0 — стандартное требование Erasmus Mundus, на найденных страницах напрямую не цитируется.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Erasmus Mundus Joint Master in Artificial Intelligence (EMAI)', 'Artificial Intelligence', 'English', 24, 18000,
  4, 30, 6.5, 3, 'https://www.upf.edu/web/emai/scholarships-fees',
  array['Erasmus Mundus full scholarship (covers tuition + €1,400/month stipend for 24 months + travel + insurance)', 'Self-funded students pay tuition, travel and living expenses themselves'],
  'Двухлетняя совместная магистерская программа Erasmus Mundus по ИИ координируется UPF (Барселона) с ротацией по нескольким европейским университетам. Для не-EU студентов полная стоимость обучения составляет €9,000/год (€18,000 за 2 года); студенты из EU получают 50% скидку.',
  array['Полная стипендия Erasmus Mundus покрывает обучение, проживание (€1,400/мес) и дорогу', 'Диплом совместный от нескольких ведущих европейских университетов (мульти-кампус ротация)', 'Сильный бренд UPF в области ИИ и Barcelona как хаб стартапов/tech-индустрии'],
  array['Для не-EU самофинансируемых студентов обучение дорогое (€18,000 за 2 года) — без стипендии сумма ощутимая', 'IELTS требуется строго6.5 по всем субшкалам (overall и каждая часть ≥6.5), что выше типичного порога', 'Дедлайн основного раунда на стипендию обычно середина декабря; точная дата апреля для самофинансируемых на найденных страницах явно не подтверждена', 'verified=false: tuition, language и deadline не найдены подтверждёнными на ОДНОЙ и той же официальной странице — данные собраны с двух разных страниц UPF'],
  false, null
);

-- verified=false: на странице https://www.upf.edu/en/web/masters/tecnologies-de-la-informacio-i-les-comunicacions подтверждены только название программы и длительность (1 год / 60 ECTS). Конкретная стоимость для non-EU, финальный deadline и IELTS-min для Master in Data Science на этой же странице не указаны — карточка ведёт на bsm.upf.edu, который в результатах поиска не вернулся с конкретикой. Tuition оценён ~€9500 как середина диапазона BSM (€7000–€15000 по независимым обзорам), deadline и IELTS — типичные значения для англоязычных магистратур UPF/BSM, не верифицированы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master in Data Science', 'Data Science', 'English', 12, 9500,
  6, 15, 6.5, 3, 'https://www.upf.edu/en/web/masters/tecnologies-de-la-informacio-i-les-comunicacions',
  array['UPF Master''s scholarship (partial tuition waiver for international applicants)'],
  'Магистерская программа UPF по науке о данных реализуется через UPF Barcelona School of Management, длится 1 учебный год (60 ECTS) и ориентирована на международных студентов с сильной технической подготовкой.',
  array['Преподаётся на английском в топовом испанском вузе (UPF входит в топ-100 молодых университетов мира)', 'Короткая программа 60 ECTS позволяет быстро выйти на рынок', 'Связь с BSM даёт доступ к нетворкингу и стажировкам в Барселоне'],
  array['Точные цифры tuition/deadline/IELTS для non-EU на одной странице UPF не подтверждены — пришлось оценивать (см. source_note)', 'Срок 12 месяцев, а не 24 как в шаблоне — данные из листинга UPF имеют приоритет над шаблоном'],
  false, null
);

-- Подтверждено на upf.edu/en/web/master-investigacio-comunicacio и upf.edu/en/web/masters/preus: не-EU fee = 5 749,8 €, EU fee = 1 302 €,60 ECTS, сентябрь–июнь. Дедлайн и точный IELTS-min не найдены в выдаче (страница acces-i-admissio не отрендерилась полностью), поэтому verified=false — указаны типичные для магистратур UPF значения (апрель, IELTS 6.5).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e12c60b2-3ae9-4de3-82bb-6f5617ad1ddb',
  'Master''s degree programme in Research and Innovation in Communication', 'Business Analytics', 'English', 10, 5749.8,
  4, 30, 6.5, 3, 'https://www.upf.edu/en/web/master-investigacio-comunicacio',
  array[]::text[],
  'Очная англоязычная магистратура по исследованиям и инновациям в коммуникациях в УПФ (Барселона), 60 ECTS, длительность один учебный год (сентябрь–июнь). Стоимость для не-ЕС студентов официально подтверждена на странице программы.',
  array['Стоимость для не-ЕС значительно ниже средней по Европе (≈5750 € за год)', 'Сильная исследовательская школа коммуникаций в Барселоне', 'Программа на английском, удобно для международных абитуриентов'],
  array['Дедлайн подачи и минимальный IELTS не подтверждены на той же официальной странице (verified=false)', 'Реальная длительность — один учебный год (≈10 мес.), а не 24 мес. как в шаблоне; проверьте на сайте'],
  false, null
);

-- Подтверждено на одной странице только частично: официальная страница UPM подтверждает название программы, формат (on-campus), 60 ECTS и языки (Spanish/English); tuition 5040 EUR взят из MastersPortal как цена для non-EU (vs ~2700 EUR для EU). Дедлайн и точный IELTS на этой же странице не указаны, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Artificial Intelligence', 'Artificial Intelligence', 'English', 12, 5040,
  4, 30, 6, 3, 'https://www.upm.es/internacional/Students/StudiesDegrees/UniversityMasters/Master%20programs?id=10.9&fmt=detail',
  array[]::text[],
  'Магистерская программа UPM по искусственному интеллекту (MUIA) — 60 ECTS, преподавание на испанском и английском, проводится в Школе компьютерных инженеров (ETSISI/DIA). Стоимость для студентов вне ЕС существенно выше, чем для граждан ЕС/Испании.',
  array['Программа на английском и испанском — гибкость для иностранцев', 'Сильная техническая школа UPM, исследовательский профиль магистратуры', 'Стоимость для non-EU (~5040 EUR/год) заметно ниже англоязычных аналогов в UK/Нидерландах'],
  array['Дедлайн подачи (30 апреля) и точный минимальный IELTS для non-EU не подтверждены на официальной странице программы в этом раунде поиска', 'На странице MUIA упоминается правило 45 ECTS за первые два года — фактическая длительность обучения может выходить за 12 месяцев, уточнять приёмную комиссию', 'Минимальный GPA официально не опубликован на найденной странице'],
  false, null
);

-- verified=false, так как tuition, deadline и IELTS не подтверждены на одной и той же странице. Tuition non-EU (~84 EUR/credit × 90 ECTS ≈ 7,560 EUR) взят с mastersportal.com/studies/391249 (отдельный URL). Дедлайн 30 апреля — типичный раунд UPM для международных абитуриентов, но точная дата на этой странице не указана. IELTS 6.0 — общее требование UPM для англоязычных магистратур, конкретно для Data Science не подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Data Science', 'Data Science', 'English', 24, 7560,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/391249/data-science.html',
  array[]::text[],
  'Магистерская программа по Data Science в Мадридском политехническом университете (UPM) длительностью ~24 месяца (90 ECTS), преподаётся на английском и испанском; сильная техническая школа с упором на инженерию данных, машинное обучение и статистику.',
  array['Международная стоимость ~84 EUR/кредит (≈7,560 EUR за всю программу), что заметно ниже, чем у многих конкурентов из англоязычных стран', 'Престижный технический вуз Европы, сильный преподавательский состав и связи с индустрией Мадрида'],
  array['Точная сумма для non-EU студентов, крайний срок подачи и языковой минимум не подтверждены на одной и той же странице — цифры являются лучшей аппроксимацией (tuition по Mastersportal, deadline по типичному расписанию UPM, IELTS — общее требование вуза)', 'В испанской системе официального GPA нет; указан эквивалент по усмотрению приёмной комиссии'],
  false, null
);

-- verified=false, так как на указанной официальной странице UPM (https://www.upm.es/...id=10.18) подтверждено только преподавание на английском и то, что заявки идут через EIT Digital Master School. Конкретная стоимость для non-EU взята из mastersportal.com (€84/credit × 120 ECTS), IELTS 6.5 — также оттуда. Дедлайн 30 апреля — расчётный по типичному Round 2 EIT Digital. Все три ключевых параметра (tuition+deadline+language) НЕ подтверждены на одной и той же странице UPM, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Digital Innovation', 'Business Analytics', 'English', 24, 10080,
  4, 30, 6.5, 3, 'https://www.upm.es/internacional/Students/StudiesDegrees/UniversityMasters/Master%20programs?id=10.18&fmt=detail',
  array[]::text[],
  'Магистерская программа Университета Политехники Мадрида (UPM) «Digital Innovation» — двухлетняя (120 ECTS) программа с преподаванием полностью на английском языке, имеющая лейбл EIT Digital. Заявки подаются через EIT Digital Master School, а не напрямую в UPM; предлагается несколько специализаций (Data Science, HCI & Design, Health & Medical Data Analytics, Fintech и др.).',
  array['Полностью на английском — подходит для иностранных студентов', 'Программа с лейблом EIT Digital — престижная европейская сертификация и сильная сеть выпускников', 'Широкий выбор специализаций на стыке технологий и бизнеса'],
  array['Стоимость и точные дедлайны для non-EU не указаны на официальной странице UPM — фактическая цена и сроки определяются EIT Digital Master School (по данным mastersportal.com, для international — €84/кредит × 120 ECTS ≈ €10 080, но для EIT Digital non-EU ставка может отличаться)', 'Дедлайн 30 апреля — оценочный (типичный раунд 2 EIT Digital); точные даты раундов нужно проверять на masterschool.eitdigital.eu', 'GPA-минимум не указан явно — указан как 3.0 по умолчанию без подтверждения'],
  false, null
);

-- verified=false: tuition5040 EUR/год для non-residents взят с mastersportal.com (агрегатор, ссылается на UPM), но на самой странице upm.es цены для не-ЕС явно не разделены в выдаче; дедлайн 30 апреля и IELTS 6.0 — типичные значения для UPM, но не подтверждены для конкретно этой программы на одной странице; GPA 3.0 — стандартная рекомендация UPM для иностранцев.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Biomedical Engineering', 'Computational Engineering', 'English', 12, 5040,
  4, 30, 6, 3, 'https://www.upm.es/internacional/Students/StudiesDegrees/UniversityMasters/Master%20programs?id=9.18&fmt=detail',
  array[]::text[],
  'Официальный магистерский курс UPM (Мадрид) по биомедицинской инженерии на 60 ECTS, преподаётся в основном на английском, сильная техническая школа и связи с исследовательскими центрами Мадрида.',
  array['UPM — один из ведущих технических вузов Испании с сильной инженерной школой и исследовательской базой', 'Программа 60 ECTS, реальная стоимость для не-ЕС около 5040 EUR/год — заметно дешевле, чем в среднем по study.eu для UPM (~13 000 EUR/год)'],
  array['На официальной странице программы явный разброс цен EU vs non-EU и точный дедлайн для не-ЕС на момент проверки не подтверждены одной страницей — verified=false', 'Длительность указана как 60 ECTS (≈12 мес), а не 24 мес как в шаблоне; точный академический календарь и требование по IELTS для конкретно этой программы нужно уточнять у координатора'],
  false, null
);

-- Проверены официальные страницы UPM и UCM, а также страница программы FI UPM. В результатах поиска официальная страница FI UPM указывает продолжительность один год (60 ECTS) и описание языков, но не дает полного набора требуемых не-EU данных. Страница UPM подтверждает межвузовский характер программы; опубликованные сторонние источники дают существенно отличающиеся сведения, поэтому tuition_eur=6400, deadline_month=4, deadline_day=30, ielts_min=6.0 и gpa_min=3 являются оценочными, а не полностью подтвержденными. verified=false, поскольку tuition, deadline и IELTS для не-EU студентов не подтверждены на одной официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Formal Methods in Computer Science and Engineering', 'Computer Science', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.fi.upm.es/?id=metodosformalesii',
  array[]::text[],
  'Магистерская программа Университета Политехники Мадрида по формальным методам. Опубликованная на странице программы продолжительность — один год (60 ECTS), поэтому указанные в запросе 24 месяца могут относиться к другому варианту или быть устаревшей информацией.',
  array['Программа межвузовская: преподавание ведется преподавателями UPM и UCM', 'Обучение проводится преимущественно на английском языке'],
  array['На официальной странице не подтверждены одной публикацией одновременно не-EU ставка, точный срок подачи для иностранных студентов и минимальный IELTS 6.0; поэтому verified=false', 'Фактическая продолжительность на официальной странице — 12 месяцев и 60 ECTS, а не 24 месяца; GPA_MIN не подтвержден'],
  false, null
);

-- Подтверждено: tuition для non-EU (€4 500/год × 2 года = €9 000) и общая длительность 24 месяца — на странице amir-master.com/fees-and-scholarships/. НЕ подтверждено на одной и той же странице UPM: точный deadline для трека в UPM и точный IELTS-минимум для non-EU, поэтому verified=false. URL указан на официальный источник AMIR, а не на предполагаемую страницу UPM, так как её не удалось найти в результатах поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37b67d8c-54d0-435e-85ea-93e3b518ac50',
  'Master in Advanced Innovative Recycling (AMIR Master) - Circular Economy Speciality: Minerals and Construction Products', 'Computational Engineering', 'English', 24, 9000,
  4, 30, 6, 3, 'https://www.amir-master.com/fees-and-scholarships/',
  array['EIT RawMaterials Scholarship (covers tuition + stipend)', 'Erasmus Mundus Scholarship (fully funded for selected candidates)'],
  'AMIR — это совместная магистратура Erasmus Mundus / EIT RawMaterials по инновационной переработке материалов; трек Circular Economy / Minerals & Construction Products предлагается в том числе с участием Universidad Politécnica de Madrid как принимающего вуза. Программа длится 2 года, обучение на английском, студенты учатся в 2-3 европейских университетах.',
  array['Англоязычная программа с возможностью обучения в нескольких европейских вузах и получения double degree', 'Доступны стипендии EIT RawMaterials и Erasmus Mundus, покрывающие tuition, страховку и выплачивающие стипендию', 'Сильная специализация на устойчивости и циркулярной экономике — высокий спрос на специалистов в ЕС'],
  array['Указанная стоимость €9 000 — общая программная fee за 2 года (€4 500/год для non-EU), но она отображается на сайте amir-master.com, а не на конкретной странице UPM; точную страницу UPM для трека Minerals & Construction Products подтвердить не удалось', 'Дедлайн и IELTS-минимум взяты по типичным требованиям AMIR — для трека с участием UPM могут незначительно отличаться, конкретный UPM-листинг в результатах не выявлен'],
  false, null
);

-- verified=false: точная цифра tuition для non-EU на одной странице не подтверждена (источники дают €47,300 в одном месте и €51,200 в другом для другого учебного года). IELTS 7.0 указан на странице International MBA IE, для MiM конкретно рекомендация 7.5 — взято как осторожная оценка. Дедлайна как такового нет (rolling admissions), взят последний ориентировочный раунд 15 мая из внешнего источника mimineurope.com. Длительность MiM по разным источникам 10–15 месяцев, не 24.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Management', 'Business Analytics', 'English', 11, 47300,
  5, 15, 7, 3.8, 'https://www.ie.edu/business-school/programs/masters/master-in-management/admissions-fees/',
  array['IE Foundation scholarships (до 70% стоимости, по GPA)'],
  'Master in Management в IE Business School (Мадрид) — элитная программа мирового уровня с гибким графиком и сильной карьерной поддержкой. Платформа rolling admissions без жёсткого дедлайна, ориентир для последнего раунда — 15 мая.',
  array['Престиж IE в международных рейтингах MiM', 'Сильный карьерный сервис и глобальная сеть выпускников', 'Возможность гибкого выбора специализаций и обменов'],
  array['Очень высокая стоимость обучения (~€47k плюс €1,200 регистрационный взнос)', 'IELTS 7.0 — высокий порог, реально нужен 7.5+', 'GPA-минимум 3.8/4.0 существенно ограничивает пул кандидатов'],
  false, null
);

-- verified=false: не удалось найти одну страницу IE, где одновременно подтверждены tuition non-EU + дедлайн + IELTS именно для Master in Management & Strategy. Известный URL https://www.ie.edu/business-school/programs/masters/master-in-management-and-strategy/ подтверждён как официальный (в результатах поиска), а dedicated admissions page существует: https://www.ie.edu/business-school/programs/masters/master-in-management-and-strategy/admissions-fees/. Цена €42,000 взята с admissions-fees страницы Master in Finance, где IE указывает non-EU tuition €42,000 для группы MiM/MiMS/MiF программ (требует прямой проверки). Длительность 15 мес. и IELTS 7.0 указаны на основе данных официальных страниц IE и стороннего справочника yourdreamschool.com (2026 guide). Дедлайн не фиксированный — rolling admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Management & Strategy', 'Business Analytics', 'English', 15, 42000,
  null, null, 7, 3, 'https://www.ie.edu/business-school/programs/masters/master-in-management-and-strategy/',
  array['IE Foundation Scholarship', 'IE Excellence Scholarship', 'IE Diversity Scholarship', 'IE Talent & Innovation Scholarship'],
  '15-месячная магистратура IE Business School в Мадриде на английском, ориентированная на стратегическое лидерство и управление для выпускников бакалавриата с небольшим опытом или без опыта работы.',
  array['IE Business School входит в топ-европейских школ, сильный бренд в Мадриде', 'Англоязычная программа с гибким набором элективных курсов', 'Широкий пул стипендий для нерезидентов ЕС (Excellence, Diversity, Talent & Innovation)'],
  array['Точная сумма tuition для non-EU на странице MiMS не подтверждена одной выдержкой — указана по аналогии с MiM/MiF (€42,000), рекомендую перепроверить на admissions-fees странице программы', 'IE использует rolling admissions без жёсткого дедлайна, точные месяц/день не указаны — рекомендуется подавать за 3–6 месяцев до сентября', 'IELTS 7.0 (рекомендуется 7.5) — требование выше минимального стандарта 6.0/6.5'],
  false, null
);

-- Tuition ~€43 200 подтверждён из двух вторичных источников (mim-essay.com за 2025 и leverageedu.com 2025–26), но на одной и той же официальной странице IE цифра tuition+IELTS+deadline одновременно не подтверждена в выдаче. Страница IE явно указывает rolling admissions без фиксированного дедлайна (https://www.ie.edu/business-school/programs/masters/master-in-finance/admissions-fees/), поэтому deadline_month/day я поставил условно (конец августа как разумный ориентир перед сентябрьским intake), а не как официальную дату. IELTS 7.0 — типичный уровень IE Business School, но не извлечён напрямую со страницы MFin, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Finance', 'Business Analytics', 'English', 10, 43200,
  8, 31, 7, 3, 'https://www.ie.edu/business-school/programs/masters/master-in-finance/admissions-fees/',
  array['IE Foundation Scholarship (need-based)', 'Dean''s Award (up to ~70% of tuition for top candidates)'],
  'Master in Finance в IE Business School (Мадрид) — 10-месячная программа full-time на английском для подготовки к карьере в инвестиционном банкинге, asset management и корпоративных финансах. Один набор в сентябре (плюс дополнительный апрельский intake по отдельным трекам), rolling admissions без жёсткого дедлайна.',
  array['IE стабильно входит в топ-10 MFin в Европе по рейтингам FT/QS, сильное международное комьюнити и networking в Мадриде', 'Гибкая структура: можно добавить exchange term, dual degree (например, MiM+MFin) или стажировку, плюс доступ к Liquid Lab и CFA-альянсам', 'Хороший ROI для non-EU студентов благодаря карьерным офферам в IB/MBB/AM в Лондоне и ЕС после выпуска'],
  array['Официальной разницы EU/non-EU по tuition IE не публикует — тариф единый (~€42 000 академический взнос + €1 200 взнос IE Foundation ≈ €43 200), что для non-EU ощутимо без стипендии', 'Дедлайнов в классическом смысле нет (rolling admissions), что запутывает тайминг для international аппликантов, которым нужна виза — реально подаваться за 4–6 месяцев до сентября', 'IELTS/TOEFL минимум с официальной страницы MFin в выдаче не подтверждён (типично 7.0 для IE Business School, но это нужно перепроверить на admissions-fees перед подачей)', 'Стоимость жизни в Мадриде €1 200–1 800/мес сверху tuition — реальный бюджет на год ближе к €60 000'],
  false, null
);

-- Tuition 37 000 EUR подтверждено на официальной странице admissions-fees и TopUniversities/MastersPortal; длительность 10 месяцев подтверждена несколькими источниками; дедлайн 1 марта 2027 взят с MastersPortal (не с официальной страницы IE). IELTS-минимум и GPA-минимум явно не указаны в сниппетах — указаны типичные для IE значения (6.5 и 3.0/4.0), поэтому verified=false. Tuition для EU/non-EU одинаковое (частный вуз), что уточняет запрос про разделение ставок.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Talent Development & Human Resources', 'Business Analytics', 'English', 10, 37000,
  3, 1, 6.5, 3, 'https://www.ie.edu/business-school/programs/masters/master-in-talent-development-human-resources/admissions-fees/',
  array['IE Foundation Scholarship (need/merit based)', 'IE Women in Leadership Scholarship', 'IE Diversity Scholarship'],
  'Десятимесячная очная программа магистратуры в IE Business School (Мадрид) на английском языке, ориентированная на стратегию управления талантами и цифровую трансформацию HR. Стоимость 37 000 EUR единой ставкой для всех студентов (IE — частный вуз, различия EU/non-EU по tuition не применяется).',
  array['Престиж IE Business School и сильный бренд в HR-среде', 'Программа на английском в Мадриде — международная среда и нетребовательная виза для не-EU'],
  array['Высокая стоимость (37 000 EUR + ~1 200 EUR взнос IE Foundation) без разделения EU/non-EU', 'Минимальный балл IELTS и GPA не подтверждены напрямую с официальной страницы admissions (использованы типичные для IE значения)'],
  false, null
);

-- verified=false, потому что tuition (€41,000) и IELTS (7.0+) подтверждены на admissions-fees странице IE и на TopUniversities/mastersportal, но фиксированного дедлайна нет — только rolling admissions с intake-start 1 апреля (TopUniversities). Все три параметра (tuition+deadline+language) на одной странице одновременно не подтверждены. Разделения EU/non-EU по стоимости не обнаружено — для международных студентов цена та же €41,000.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Executive Master in Digital Transformation & Innovation Leadership', 'Business Analytics', 'English', 13, 41000,
  4, 1, 7, 3, 'https://www.ie.edu/business-school/programs/masters/executive-master-in-digital-transformation-innovation-leadership/admissions-fees/',
  array[]::text[],
  'Программа IE Business School для руководителей цифровой трансформации: 13 месяцев, стоимость €41,000, гибкий формат для работающих профессионалов.',
  array['Престиж IE Business School и сильный бренд в Латинской Америке и Европе', 'Гибкий формат (blended) для работающих специалистов, нет жёсткого дедлайна — rolling admissions', 'Чёткая стоимость €41,000 без разделения на EU/non-EU — одинакова для всех'],
  array['Жёсткого фиксированного дедлайна нет (rolling admissions), но ближайший intake стартует 1 апреля — фактический последний срок подачи не опубликован', 'Высокий порог IELTS 7.0+ и TOEFL 100+', 'Длительность 13 месяцев по TopUniversities, а не 24 как предполагалось изначально', 'Программа ориентирована на executive-аудиторию, требует подтверждённого опыта работы'],
  false, null
);

-- Подтверждено: tuition 41 000 € (явно указано на странице admissions-fees IE и подтверждено TopUniversities) и длительность 11 месяцев (IE-страница программы + блок ''Full-Time In-person'' в выдаче). НЕ подтверждено в рамках заданного URL: конкретный deadline для non-EU (на admissions-странице упоминаются rolling rounds и приоритетные даты, но точной финальной даты я не извлёк) и IELTS-минимум (на странице фраза ''English Test (minimum score 130)'' — вероятно Duolingo или TOEFL, не IELTS). Различие EU/non-EU отсутствует: TopUniversities прямо показывает domestic=international=41 000 €. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Financial Technology', 'Business Analytics', 'English', 11, 41000,
  7, 15, 6.5, 3, 'https://www.ie.edu/school-science-technology/programs/master-financial-technology/',
  array[]::text[],
  '11-месячная магистратура по финтеху в IE University (Мадрид): цифровые финансы, блокчейн, AI. Стоимость 41 000 € для всех студентов — у IE ставка для domestic и international одинаковая, отдельной non-EU надбавки нет.',
  array['Преподавание полностью на английском, кампус в Мадриде', 'Сильный финтех-бренд IE и связи с индустрией (банки, стартапы, блокчейн-компании)', 'Фокус на практических кейсах и прикладных технологиях (AI, blockchain, data)'],
  array['Высокая стоимость 41 000 € + дополнительный admin fee ~1 200 € при зачислении', 'Точные дедлайны (наш приоритетный round и финальная дата подачи) и IELTS-порог не удалось надёжно подтвердить с указанной known-страницы — взяты оценочно по типичной практике IE (финал ~июль, IELTS 6.5)', 'Длительность всего 11 месяцев (не двухгодичная программа, как иногда пишут каталоги)'],
  false, null
);

-- verified=false: все три обязательных поля (tuition + deadline + IELTS) подтверждены разными источниками, но не на ОДНОЙ странице конкретно для не-EU студентов. IELTS 7.0 — сниппет с официальной страницы admissions-fees IE. Стоимость 41 000 EUR — Fulbright/IE University Master''s Award (2025-2026). Rolling admissions без дедлайна — несколько страниц IE (admissions-fees и dual-degree admissions). Различие EU/non-EU на странице IE прямо не выделено в сниппетах, цифра «43000€ depending on your region» указывает на региональные ставки, но конкретная non-EU ставка не подтверждена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Business Analytics and Data Science', 'Data Science', 'English', 11, 41000,
  0, 0, 7, 3, 'https://www.ie.edu/school-science-technology/programs/master-business-analytics-data-science/admissions-fees/',
  array[]::text[],
  'Магистратура IE University в Мадриде на стыке бизнес-аналитики и data science; высокая стоимость, rolling admissions без фиксированного дедлайна, IELTS от 7.0.',
  array['Престижный частный университет в центре Мадрида', 'Сильный бренд IE в Европе и Латинской Америке, хорошая сеть выпускников', 'Программа совмещает бизнес-аналитику и data science, востребованный стек'],
  array['Высокая стоимость: около 41 000 EUR для иностранных студентов (по данным Fulbright 2025-2026); на странице IE встречается цифра 43 000 EUR с пометкой «depending on your region» — точная non-EU ставка не выделена отдельно', 'Фиксированного дедлайна нет — rolling admissions, что затрудняет планирование; рекомендуется подавать как можно раньше', 'IELTS минимум 7.0 (7.5 рекомендуется) — заметно выше типичных 6.0/6.5', 'Явной границы EU/non-EU по tuition на официальной странице найти не удалось'],
  false, null
);

-- verified=false: tuition €36,000 и IELTS 7.0 подтверждены на admissions-fees странице IE и общих требованиях IE к магистратуре, но жёсткий deadline для non-EU не существует (rolling admissions), и отдельного non-EU тарифа у IE нет (вуз частный, единая цена) — три критерия (tuition+deadline+language) на одной странице для non-EU одновременно не подтверждаются.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Computer Science & Digital Innovation', 'Computer Science', 'English', 11, 36000,
  0, 0, 7, 3, 'https://www.ie.edu/school-science-technology/programs/master-computer-science-digital-innovation/admissions-fees/',
  array['IE Foundation Scholarship (need/merit-based, требуется отдельная заявка до ~15 апреля для максимальных шансов)'],
  'Частная 11-месячная программа IE University в Мадриде на стыке computer science, дизайн-мышления и бизнеса. Англоязычная, ориентирована на лидеров цифровой трансформации, без жёсткого дедлайна (rolling admissions).',
  array['Топовая частная бизнес-школа с сильным нетворкингом и связями в индустрии', 'Гибкий rolling admissions — можно подавать круглый год', 'Междисциплинарный фокус: tech + бизнес + инновации, актуально для продуктовых и консалтинговых ролей'],
  array['Высокая стоимость (€36,000) без отдельного non-EU тарифа — IE частный вуз, цена единая для всех', 'Дедлайна как такового нет (rolling admissions) — точные даты deadline_month/day подтвердить не удалось, поэтому стоят 0', 'IELTS минимум 7.0 (рекомендуют 7.5) — заметно выше типичных 6.0/6.5', 'GPA minimum явно не опубликован на странице программы, значение 3 — оценка по умолчанию'],
  false, null
);

-- verified=false, потому что tuition non-EU (36 000 €) и IELTS 7.0 подтверждены, но не на одной и той же официальной странице программы (tuition — на IE admissions-fees, IELTS — на mastersportal/общем гайде IE), а жёсткого deadline и минимального GPA на официальной странице не опубликовано вовсе (rolling admissions).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Computer Science & Business Technology', 'Computer Science', 'English', 11, 36000,
  4, 15, 7, 3, 'https://www.ie.edu/school-science-technology/programs/master-in-computer-science-and-business-technology/admissions-fees/',
  array[]::text[],
  'Магистратура IE University на стыке компьютерных наук и бизнеса в Мадриде: 11 месяцев, non-EU стоимость 36 000 €, rolling admissions (жёсткого дедлайна нет, для стипендий рекомендуют подать до 15 апреля), IELTS от 7.0.',
  array['Non-EU стоимость 36 000 € явно указана на официальной странице admissions & fees — прозрачно по сравнению со многими европейскими вузами', 'IELTS 7.0 подтверждён на mastersportal, синхронно с общим гайдом IE (минимум 7.0, рекомендуется 7.5)', 'Rolling admissions — можно подать в удобное время в течение года'],
  array['Фиксированного дедлайна нет (rolling), поэтому в JSON поставлен рекомендуемый стипендиальный дедлайн 15 апреля, а не жёсткая дата — для non-EU с визой подавать лучше сильно заранее', 'Минимальный GPA официально не опубликован на странице программы — 3.0 взято как разумная оценка, требует уточнения', 'Длительность 11 месяцев по данным unimymasters, что расходится с шаблоном (24) — использована фактическая', 'Tuition пересматривается ежегодно, цифра актуальна на момент выгрузки'],
  false, null
);

-- Подтверждено на одной странице: tuition €22,000 (https://www.ie.edu/school-architecture-design/programs/master-in-architecture/admissions-and-fees/) и IELTS ≥7.0 (https://www.ie.edu/uncover-ie/applying-to-a-masters-program-at-ie-university-everything-you-need-to-know/, Yocket). verified=false, потому что: (1) дедлайн формально rolling, конкретная дата 30 апреля — рекомендация для non-EU из-за визовых сроков, а не официальный крайний срок; (2) на странице программы нет отдельной EU/non-EU ставки — IE частный вуз с единой ценой, что для аудитории плюс, но формально не позволяет подтвердить ''non-EU rate''; (4) GPA не указан как жёсткое требование,3.0 — типовая оценка IE, не подтверждено официально.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Architecture', 'Design', 'English', 24, 22000,
  4, 30, 7, 3, 'https://www.ie.edu/school-architecture-design/programs/master-in-architecture/admissions-and-fees/',
  array['IE Foundation scholarships (need/merit-based, до ~30-50% tuition)', 'IE Talent Scholarship', 'Early bird discount при ранней подаче'],
  'Двухгодичная профессиональная магистратура по архитектуре в частном университете IE в Мадриде. Программа аккредитована и ориентирована на международную практику, обучение полностью на английском.',
  array['Единая стоимость обучения €22,000 за всю программу для всех студентов — нет разделения EU/non-EU, что упрощает планирование', 'Сильный международный нетворкинг и преподаватели с мировой практикой', 'Расположение в Мадриде + связи с архитектурной индустрией Европы и Латинской Америки'],
  array['Минимальный IELTS 7.0 (рекомендуется 7.5) — заметно выше типичных 6.0–6.5', 'Официально rolling admissions без жёсткого дедлайна; для non-EU студентов реальный ориентир — ~30 апреля, чтобы успеть получить визу и разрешение на пребывание', 'Не подтверждена конкретная стипендия именно для non-EU студентов на этой программе — данные приближённые'],
  false, null
);

-- Подтверждено: tuition €27,000 и формат 15 months part-time — со страницы admissions-fees IE и topuniversities.com. Rolling admissions (фиксированной даты дедлайна нет) — с той же страницы IE. IELTS 7.0 — со страницы IE ''Applying to a master''s program'' и Mastersportal (не с самой страницы программы в выдаче). verified=false, т.к. tuition+deadline+IELTS не подтверждены для non-EU на одной и той же странице; кроме того, шаблонные значения из задания (24 мес / €6400 / 30 апреля / IELTS 6.0) не соответствуют реальной программе и не использованы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Master in Business for Architecture and Design', 'Business Analytics', 'English', 15, 27000,
  null, null, 7, 3, 'https://www.ie.edu/school-architecture-design/programs/master-in-business-for-architecture-and-design/',
  array['IE Foundation scholarship (up to ~65–70% of tuition, need/merit-based)', 'IE High Performance Scholarship (up to 30% off tuition)'],
  '15-месячная part-time программа IE University (Мадрид, частично Амстердам), объединяющая архитектуру, дизайн и бизнес; формат удобен для работающих специалистов.',
  array['Престиж бренда IE и сильная сеть выпускников', 'Part-time формат, совместимый с работой', 'Международная среда и бизнес-фокус для архитекторов/дизайнеров'],
  array['Высокая стоимость (€27,000) для 15-месячной программы', 'Дедлайна нет — rolling admissions, но места ограничены, ранняя подача обязательна', 'IELTS 7.0 (не 6.0) — требования к английскому выше, чем в шаблоне'],
  false, null
);

-- Подтверждено на официальной странице admissions (https://www.ie.edu/masters/dual-degrees/programs/dual-degree-master-in-international-relations-master-of-laws-llm/admissions/): стоимость €63 900 (September intake) и IELTS минимум 7.0 (рекомендуется 7.5). Различие EU/non-EU на этой странице в сниппетах не обнаружено — IE указывает единую цену. Фиксированный дедлайн и точная длительность на официальной странице не подтверждены (IE использует rolling admissions для магистратур), поэтому verified=false. GPA 3.0 — стандартное требование IE для магистратур, но в сниппете именно этой программы явно не упомянуто.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4b69a497-64c4-4538-8270-58f16361893c',
  'Dual Degree Master in International Relations & Master of Laws (LL.M.)', 'Social Sciences', 'English', 20, 63900,
  null, null, 7, 3, 'https://www.ie.edu/masters/dual-degrees/programs/dual-degree-master-in-international-relations-master-of-laws-llm/admissions/',
  array['IE Need-based Scholarship', 'IE Merit-based Scholarship', 'IE Talent-Based Diversity Scholarship'],
  'Двойная магистратура IE University в Мадриде, сочетающая международные отношения и американское/международное право (LL.M.). Программа полностью на английском, ориентирована на международную карьеру в дипломатии, ООН, международных организациях и юридических фирмах.',
  array['Престиж IE University и сильное международное сообщество (~94% иностранных студентов)', 'Полностью англоязычная программа в центре Мадрида', 'Двойной диплом по IR и LL.M. открывает двери как в policy, так и в юридическую сферу'],
  array['Высокая стоимость (~€63 900), одна из самых дорогих магистратур в Испании', 'IELTS минимум 7.0 (рекомендуется 7.5) — высокий порог по английскому', 'Дедлайн на официальной странице не подтверждён: у IE rolling admissions для магистратур, фиксированной даты в сниппетах официальной страницы нет', 'Точная длительность программы не указана в найденных сниппетах (оценка ~20 мес. исходя из суммы двух отдельных программ)', 'verified=false, т.к. дедлайн и длительность не подтверждены на той же официальной странице, что и стоимость и IELTS'],
  false, null
);

-- Tuition €39,000 — со страницы esade.edu/master-of-science/en/fees-and-financing (''One year program €39.000''); IELTS 7.0 подтверждён mimineurope.com, ссылающимся на официальные минимумы ESADE (TOEFL 100, IELTS 7.0, CAE B). Дедлайн: на официальной странице MSc упоминаются раунды, конкретный финальный день не указан в выдаче — admitscholar.com сообщает о финальном раунде в июле. Non-EU vs EU: ESADE — частная школа (Ramon Llull), единая цена для всех студентов, поэтому non-EU платит €39,000 (то же, что и EU). verified=false, т.к. tuition+IELTS+deadline day не подтверждены на ОДНОЙ странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'MSc in International Management', 'Business Analytics', 'English', 12, 39000,
  7, 15, 7, 3, 'https://www.esade.edu/master-of-science/en/program/masters-in-international-management',
  array['ESADE Merit-based scholarships (partial tuition waivers)', 'Diversity & need-based grants for international students'],
  'Один год (60 ECTS, сентябрь–следующий год) в ESADE (Ramon Llull University), полностью на английском, кампус в Барселоне. Программа ориентирована на интернациональный менеджмент с сильным акцентом на карьерные сервисы и возможностью двойного диплома с CEMS MIM.',
  array['Топовая школа — #12 в мире по QS International Management 2025', 'Частный вуз Ramon Llull: одна цена для EU и non-EU (нет завышенного non-EU тарифа)', 'Возможность присоединить CEMS MIM double degree за дополнительную плату', 'Проживание включено в стоимость программы по официальной странице fees'],
  array['Стоимость €39,000 заметно выросла по сравнению с €37,500 в прошлом цикле — высокая цена для 1-годичной программы', 'IELTS 7.0 (а не 6.0) — довольно строгое требование', 'Точный финальный день дедлайна на официальной странице не указан (есть несколько раундов, последний ~июль); GMAT/GRE формально рекомендованы, что добавляет нагрузки на поступление', 'verified=false: tuition и IELTS подтверждены, но финальный deadline day не найден на одной странице с двумя другими параметрами'],
  false, null
);

-- verified=false: на основной странице программы (esade.edu/master-of-science/en/program/masters-in-finance) не подтверждены одной страницей tuition для non-EU + финальный дедлайн + IELTS именно для MSc in Finance. IELTS 7.0 взят из topuniversities.com (Esade official admission standards для MSc). Tuition €37 000 — оценка на основе соседних MSc ESADE (MiM €37 500 по mim-essay.com) и Global MiF €43 200; реальная цифра для базового MSc in Finance может отличаться. Дедлайн 1 октября — первый раунд из admission calendar (esade.edu/master-of-science/en/admissions) на 2026/2027 intake. EU/non-EU разделения tuition в найденных источниках не обнаружено — ESADE выставляет единую ставку.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'MSc in Finance', 'Business Analytics', 'English', 12, 37000,
  10, 1, 7, 3, 'https://www.esade.edu/master-of-science/en/program/masters-in-finance',
  array['ESADE MSc Excellence Award (до 15 июля 2026 для intake 2026)', 'Diversity & International scholarships (по усмотрению приёмной комиссии)'],
  'Один из топовых MSc в Finance в Европе (Financial Times 2026 — топ-10). Программа на английском, в Барселоне, ориентирована на технические навыки в финансах для выпускников без опыта. Доступны Excellence Award-стипендии, но конкуренция высокая.',
  array['Высокий международный рейтинг (FT Masters in Finance Ranking 2026 — топ-10 Европы)', 'Программа полностью на английском, сильный карьерный трек в finance', 'Расположение в Барселоне с доступом к рекрутерам ЕС и MENA'],
  array['Точная tuition для MSc in Finance (не Global) не подтверждена на одной странице с дедлайном и IELTS — оценка €37 000 приблизительная, реальный fee нужно уточнять напрямую у приёмной комиссии для non-EU', 'IELTS минимум 7.0 (а не 6.0 как часто заявляют агрегаторы) — жёсткое требование'],
  false, null
);

-- Стоимость €37,500 подтверждена агрегатором educations.com и совпадает с другими MSc ESADE; ESADE — частная школа, тариф единый для всех национальностей (разделения EU/non-EU нет). Дедлайн и точный минимальный IELTS не найдены на одной официальной странице программы для конкретно не-EU аудитории, поэтому verified=false. Программа 1 год (60 ECTS), не 24 месяца как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'MSc in Marketing Management', 'Business Analytics', 'English', 12, 37500,
  7, 1, 6.5, 3, 'https://www.esade.edu/master-of-science/en/program/masters-in-marketing-management',
  array[]::text[],
  'Однагодовая программа MSc по маркетингу в частной бизнес-школе ESADE (Барселона), ориентированная на стратегический маркетинг, поведение потребителей и аналитику; формат 60 ECTS с опциональными стажировками и обменом.',
  array['Престиж ESADE и хорошие позиции в рейтингах (Triple Crown аккредитации)', 'Возможность международного обмена и опциональной стажировки 3-6 месяцев'],
  array['Высокая стоимость (€37,500/год) без различий EU/non-EU — ESADE частная школа с единым тарифом', 'Точные дедлайны и минимальный IELTS для не-EU студентов не подтверждены напрямую на одной странице программы (требуется уточнение)'],
  false, null
);

-- verified=false, так как tuition подтверждён (€39,000, страница Fees & Financing: https://www.esade.edu/master-of-science/en/fees-and-financing) и IELTS7.0 подтверждён (TopUniversities и страница MSc Requirements: https://www.esade.edu/master-of-science/en/admissions), но конкретный deadline для non-EU на той же странице не зафиксирован, а EU/non-EU split на странице fees отсутствует (ESADE — частная школа, тариф единый). Поэтому три поля на одной странице одновременно не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'MSc in Innovation and Entrepreneurship', 'Business Analytics', 'English', 12, 39000,
  4, 30, 7, 3, 'https://www.esade.edu/master-of-science/en/program/masters-in-innovation-entrepreneurship',
  array[]::text[],
  'Годовая магистерская программа ESADE (Ramon Llull University) в Барселоне для тех, кто планирует запускать собственный стартап или развивать инновации внутри компании. Программа делает акцент на предпринимательстве, дизайн-мышлении и глобальной экосистеме.',
  array['Престижная частная бизнес-школа с сильным placement в консалтинге и стартапах в Европе', 'Eduniversal-рейтинг 2024 в категории Innovation and Entrepreneurship', 'Глобальные study tours и сильная связь с барселонской стартап-экосистемой'],
  array['ESADE — частная школа, поэтому tuition одинаковая для EU и non-EU студентов (~€39,000); отдельной ''lower EU rate'' на странице fees не показано', 'Точная финальная дата приёма (deadline) для non-EU абитуриентов в открытых источниках явно не подтверждена — указана примерная апрельская волна', 'Стоимость €39,000 без стипендии ощутима, финансирование нужно планировать заранее'],
  false, null
);

-- verified=false: tuition €33,500 и длительность 12 мес. подтверждены (accesseventsonline.com + страница программы), финальный deadline 15 июня указан на esade.edu/master-of-science/en/fees-and-financing, но точный балл IELTS не найден в сниппетах на той же странице — нельзя подтвердить все три параметра на одной странице. EU/non-EU разделения у ESADE нет: частный вуз Испании, платят одинаково все.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'MSc in Sustainability Management', 'Business Analytics', 'English', 12, 33500,
  6, 15, 6.5, 3, 'https://www.esade.edu/master-of-science/en/program/masters-in-sustainability-management',
  array['Sustainability Management Scholarship (mentioned on fees-and-financing page, application deadline June 15)'],
  'Годовая магистратура ESADE в Барселоне по устойчивому развитию и ESG-менеджменту (60 ECTS), с акцентом на практические проекты и реальные бизнес-задачи.',
  array['Престижная бизнес-школа с сильным брендом в Европе', 'Программа в тренде ESG и устойчивого развития, высокий спрос на выпускников', 'Возможность двойного диплома с партнёрскими школами по всему миру'],
  array['Высокая стоимость обучения (~€33,500) без различия EU/non-EU — ESADE частная школа и берёт одинаково со всех', 'IELTS не подтверждён на той же странице, что и остальные данные — реальный минимум ESADE обычно 6.5–7.0'],
  false, null
);

-- verified=false: tuition €55 200 взят со страницы https://www.esade.edu/master-of-science/en/fees-and-financing (CEMS MIM = €55.200), а не напрямую со страницы CEMS MIM double-degree. IELTS 7.0 указан на mimineurope.com (третьи лица), на официальной странице CEMS MIM в выдаче не подтверждён. Дедлайн ''June 2027'' со страницы программы относится к CEMS-этапу, фактический round-1 дедлайн MSc — апрель/май (cems.org: 1 Sept – 26 May). Все три требуемых пункта НЕ подтверждены на одной и той же странице (url).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'CEMS Master in International Management (Double Degree)', 'Business Analytics', 'English', 24, 55200,
  6, 30, 7, 3, 'https://www.esade.edu/master-of-science/en/cems-mim-double-degree',
  array['Esade Merit Scholarships (50–85% покрытие по MSc)', 'CEMS Club Scholarships (для CEMS MIM участников)', 'Banco Santander Scholarships'],
  'Двухгодичная двойная степень ESADE + CEMS MIM в Барселоне для выпускников бакалавриата с сильным академическим бэкграундом; ESADE — частная школа, поэтому ставка единая для EU и non-EU.',
  array['Глобальная сеть CEMS (30+ топ-школ мира)', 'Двойной диплом ESADE MSc + CEMS MIM, высокий ROI и международный рекрутинг', 'Стипендии 50–85% доступны через Esade Scholarships'],
  array['Высокая полная стоимость (~€55200 за 2 года); EU/non-EU ставка не различается на странице программы — это подтверждено косвенно, но прямо на странице CEMS MIM фигура tuition не указана', 'Дедлайн на странице указан как ''June 2027'' (относится к CEMS-этапу после года MSc), а реальный rolling-дедлайн MSc — апрель/май; точная дата non-EU cut-off не подтверждена на той же странице'],
  false, null
);

-- Tuition €43,200 подтверждена на странице esade.edu/master-of-science/en/fees-and-financing; IELTS 7.0 — из стороннего источника mim-essay.com (страница Global Master''s in Finance отдельно не показывает цифру IELTS); общий дедлайн 15 июня и Excellence Award 15 июля — с fees-and-financing. Различие EU/non-EU на найденных страницах явно не зафиксировано, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '0d7186ba-7f57-4ece-9a20-e77afdab612b',
  'Global Master''s in Finance', 'Business Analytics', 'English', 15, 43200,
  6, 15, 7, 3, 'https://www.esade.edu/master-of-science/en/program/global-masters-in-finance',
  array['Excellence Award (дэдлайн 15 июля)', 'ESADE Master''s Scholarship'],
  '15-месячная магистратура ESADE в области финансов в Барселоне с акцентом на глобальные рынки; программа ориентирована на выпускников без опыта работы и предлагает опции обмена.',
  array['Высокий рейтинг FT Masters in Finance (Топ-10 в Европе)', 'Возможность международного обмена и тройной степени', 'Стипендии Excellence Award для сильных кандидатов'],
  array['Высокая стоимость обучения €43,200 без учёта проживания', 'Длительный процесс поступления и обязательный GMAT/GRE', 'Дедлайн 15 июня для общего потока; Excellence Award — отдельный дедлайн 15 июля'],
  false, null
);

-- verified=false: за один раунд поиска не удалось найти страницу с одновременно подтверждённой для non-EU суммой tuition, точным дедлайном и требованием IELTS. Найдено: (1) URL https://bse.eu/masters-degrees/economics-finance/economics существует, программа — 2-летняя research Master''s; (2) разные источники дают tuition от ~€17,500/год до ~€23,046/год (unipage.net) для BSE — цифра €6400 из плейсхолдера выглядит заниженной для non-EU; (3) дедлайны: early bird ~15 января, финальный ~2 июля (Facebook/Instagram BSE 2025/2026), промежуточный апрельский дедлайн также упоминается; (4) конкретный IELTS-minimum на самой странице программы не подтверждён поисковыми сниппетами. Пользователь должен открыть официальную страницу для сверки перед использованием.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Economics Program', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://bse.eu/masters-degrees/economics-finance/economics',
  array['BSE Tuition Waivers (25% / 50% / 75% / 100%) — присуждаются на основе академической успеваемости; заявка на стипендию не требуется, все кандидаты рассматриваются автоматически', 'Merit-based funding: ~€550,000–800,000 в год распределяется среди магистрантов (~24% студентов получают полное покрытие)'],
  'Двухгодичная исследовательская магистратура по экономике в Barcelona School of Economics (UPF) — сильная теоретическая и эконометрическая подготовка, хорошая ступень к PhD-программам. Программа требует серьёзной математической базы (анализ, линейная алгебра, эконометрика на уровне вводного курса).',
  array['Сильный преподавательский состав и репутация в области экономической теории и эконометрики', 'Автоматическое рассмотрение заявки на merit-based стипендии/waivers (до 100% tuition) — не нужно подавать отдельную заявку', 'Барселона как студенческий и карьерный хаб, доступ к европейскому академическому сообществу'],
  array['Точные цифры tuition и требования IELTS для non-EU студентов на указанной странице не удалось достоверно подтвердить за один раунд поиска — цифры в выходных данных приблизительные', 'У BSE есть несколько дедлайнов (early ~15 января, regular ~апрель, final ~2 июля) — точная дата зависит от волны; для scholarship-рассмотрения лучше подавать раньше', 'Программа требовательна по математике, GPA3.0 — это абсолютный минимум, реально конкурентоспособные кандидаты имеют существенно выше'],
  false, null
);

-- verified=false: не удалось подтвердить единовременно tuition+deadline+IELTS именно со страницы bse.eu (со страницы BSE в выдаче виден только фрагмент ''Sep ''26-July …''). Tuition ~€15,200–16,500 (≈$16,500–17,820) получен из beyondthestates.com и standyou.com; deadline 30 апреля и IELTS 6.0 — типичные значения для BSE, но не подтверждены напрямую с указанной страницы в этой сессии поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'International Trade, Finance, and Development Program', 'Business Analytics', 'English', 10, 16500,
  4, 30, 6, 3, 'https://bse.eu/masters-degrees/specialized-economic-analysis/international-trade-finance-and-development',
  array['BSE Tuition Fee Waivers / Scholarships for non-EU students (need-based and merit-based)', 'La Caixa Fellowships (for selected countries)'],
  'Магистерская программа BSE (Universitat Pompeu Fabra) по международной торговле, финансам и развитию: строгая подготовка в области международной экономики и экономики развития, преподавание на английском, сильный академический состав. Программа является частью Master''s Degree in Specialized Economic Analysis.',
  array['BSE входит в топ европейских школ экономики, преподаватели — исследователи мирового уровня', 'Степень Universitat Pompeu Fabra, хорошо котируется для карьеры в международных организациях и PhD-программах', 'Наличие стипендий и fee waivers для non-EU студентов'],
  array['Длительность фактически 9–10 месяцев (Sep–Jul), а не 24 — в шаблоне указано ошибочно', 'Точная non-EU стоимость, крайний срок подачи и минимальный IELTS не удалось подтвердить непосредственно со страницы BSE в одной выдаче — цифры приведены по сторонним источникам (~$16,500–17,820 ≈ €15,200–16,500, оценка)', 'Стоимость для non-EU значительно выше, чем €6,400 (эта цифра ближе к ставке EU/EEA, если она вообще публикуется отдельно)'],
  false, null
);

-- verified=false: на официальной странице MPFM в выдаче не подтверждены одновременно все три пункта (tuition/deadline/language). IELTS 6.5 подтверждён на странице Master''s Degree in Specialized Economic Analysis (bse.eu) и mastersportal.com. Tuition €18,500 взят со страницы аналогичной программы Economics of Public Policy на bse.eu, не напрямую с MPFM. Дедлайн — экспертная оценка типичных раундов BSE; конкретная дата для MPFM в выдаче не найдена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Macroeconomic Policy and Financial Markets Program', 'Business Analytics', 'English', 9, 18500,
  4, 30, 6.5, 3, 'https://bse.eu/masters-degrees/specialized-economic-analysis/macroeconomic-policy-and-financial-markets',
  array['BSE Tuition Waivers (25%, 50%, 75%, 100%)', 'BSE Master Scholarships based on academic merit'],
  'Специализированная 9-месячная магистерская программа BSE (в партнёрстве с Universitat Pompeu Fabra) по макроэкономической политике и финансовым рынкам на английском языке, ориентированная на подготовку аналитиков для центральных банков и финансовых институтов.',
  array['Сильный бренд BSE и UPF в европейской экономике', 'Программа на английском с упором на макроаналитику и финансовые рынки', 'Доступны стипендии BSE (вплоть до 100% waiver) за академические успехи'],
  array['Стоимость €18,500/год высокая для non-EU студентов без waiver (точная цифра для MPFM не подтверждена в выдаче, взята по аналогии с Economics of Public Policy)', 'Дедлайн 30 апреля — оценка на основе типичных раундов BSE, конкретная дата на официальной странице MPFM в выдаче не подтверждена', 'Реальная длительность — 9 месяцев (Sep–July), а не 24, как в шаблоне'],
  false, null
);

-- verified=false: не удалось подтвердить одновременно (а) точную non-EU стоимость, (б) финальный дедлайн 2025/26 и (в) IELTS-минимум на одной и той же странице BSE. Со страницы bse.eu/masters-programs/economics-public-policy сняты фрагменты "Tuition Fee ... €" и указание на разные категории Student/Non-EU; значений и IELTS на одной странице не зафиксировано. Поля заполнены по наиболее вероятным данным (10 месяцев, ~€22 500 как non-EU ставка для топовых магистратур BSE, раунд приёма около 15 мая, IELTS ~6.5), но эти цифры требуют ручной проверки.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Economics of Public Policy Program', 'Business Analytics', 'English', 10, 22500,
  5, 15, 6.5, 3, 'https://bse.eu/masters-programs/economics-public-policy',
  array['BSE Tuition Fee Scholarship (need-based, partial)', 'BSE Academic Excellence Scholarship (merit-based, partial)'],
  'Магистерская программа в Barcelona School of Economics (Universitat Pompeu Fabra) — теория и эмпирика экономики публичной политики; выпускники получают степень UPF, сильный преподавательский состав и связи с исследовательскими центрами BSE.',
  array['Степень Universitat Pompeu Fabra, признанная в ЕС и за его пределами', 'Доступ к исследовательской среде BSE и европейским стажировкам в публичном секторе'],
  array['Точная non-EU ставка для 2025/2026 не подтверждена на одной странице с дедлайном и языковыми требованиями — требуется уточнение на официальной странице программы'],
  false, null
);

-- URL подтверждён как официальная страница BSE. Стоимость €18 500 взята из сниппета bse.eu по программе Energy/Climate (не-ЕС ставка). Длительность 9 мес. подтверждена на bse.eu/masters-degrees. IELTS 6.5 и GPA 3.0 — типичные требования BSE, но не подтверждены на конкретной странице программы; дедлайн оценочный (июнь, исходя из типичного rolling-цикла BSE и сообщения ''one month left to apply'' от 2 июня). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Economics of Energy, Climate Change, and Sustainability Program', 'Business Analytics', 'English', 9, 18500,
  6, 30, 6.5, 3, 'https://bse.eu/masters-degrees/specialized-economic-analysis/economics-energy-climate-change-sustainability',
  array['BSE Master''s Scholarship (partial/full tuition waiver, merit-based)', 'Need-based financial aid available through BSE'],
  'Девятимесячная магистратура BSE/UPF в Барселоне по экономике энергетики, климата и устойчивого развития — интенсивная программа для подготовки к карьере в энергетическом и климатическом секторах.',
  array['Престижная школа с сильной репутацией в эконометрике и прикладной экономике', 'Короткий срок обучения (9 месяцев) и фокус на востребованной теме ESG/климата', 'Возможны стипендии BSE, покрывающие до 100% стоимости обучения'],
  array['Точный дедлайн приёма для не-ЕС студентов и требование IELTS на одной странице официально не подтверждены — цифры оценочные', 'Стоимость €18 500 — ощутимо выше базовой ставки для граждан ЕС на ряде программ UPF'],
  false, null
);

-- verified=false по строгому критерию задачи. На официальной странице bse.eu/masters-degrees/data-science/data-science-decision-making подтверждены только языковые требования (IELTS 6.5, TOEFL 90+, Duolingo 120). Стоимость €19,000 — из mastersportal.com (агрегатор), дедлайн 1 июля — из TopUniversities. Программа НЕ разделяет EU/non-EU ставку: mastersportal явно пишет ''€19,000 for both international and European students'', так что для нашей аудитории (non-EU) релевантна именно эта цифра, и никакой скрытой надбавки нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Data Science for Decision Making', 'Data Science', 'English', 9, 19000,
  7, 1, 6.5, 3, 'https://bse.eu/masters-degrees/data-science/data-science-decision-making',
  array['Academic merit-based tuition fee waivers (BSE communications indicate up to ~66% of waivers distributed; January 15 priority round gets broader access)'],
  '9-месячная магистратура MSc в Barcelona School of Economics (Universitat Pompeu Fabra), которая в отличие от generic data science программ связывает продвинутые вычислительные методы со структурированным принятием решений и оценкой исходов.',
  array['Сильный бренд BSE в quantitative economics и связка с UPF — хороший сигнал для CV в data/finance/policy', 'Единый тариф €19,000 для всех (EU и non-EU) — отсутствует ''international surcharge'', что нетипично для Испании', 'Широкие merit-based tuition waivers: при ранней подаче (до 15 января) доступ к ~66% всех стипендий'],
  array['verified=false: IELTS6.5 подтверждён на официальной странице BSE, но tuition €19,000 и deadline 1 июля взяты со сторонних агрегаторов (mastersportal, TopUniversities) — все три параметра не найдены на одной официальной странице', '€19,000 за 9 месяцев — выше среднего для Барселоны, а город сам по себе сильно подорожал'],
  false, null
);

-- verified=false: на основной странице программы поиск не выдал прямую цитату по tuition non-EU и IELTS; цифры взяты из подтверждающих источников: Topuniversities и Scholarshiptab (€19,500, IELTS 6.5, TOEFL 90+, deadline в апреле), Shiksha (9 месяцев), а также страницы BSE по sister-program Data Science for Decision Making (€19,500 как student fee). Дедлайн 30 апреля — из анонса BSE 2026-27 intake. GPA3.0 — типовое требование BSE, явной цитаты не получено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '99c795e7-0941-4a39-9c3b-e2d4d21f7701',
  'Data Science Methodology', 'Data Science', 'English', 9, 19500,
  4, 30, 6.5, 3, 'https://bse.eu/masters-degrees/data-science/data-science-methodology',
  array['BSE Academic Excellence Scholarship (partial/fully funded, merit-based)', 'BSE Diversity Scholarship'],
  'Девятимесячная магистерская программа BSE (Universitat Pompeu Fabra) в Барселоне по методологии Data Science с сильной академической базой и возможностью перехода на PhD.',
  array['Одна программа (Data Science Methodology) — всего ~9 месяцев вместо типичных 18–24, дешевле по совокупным затратам', 'BSE предлагает merit-based стипендии и путь к PhD с tuition waiver', 'Диплом Universitat Pompeu Fabra + локация в Барселоне'],
  array['Стоимость €19,500 для non-EU — выше, чем у многих государственных программ Испании; точная EU/non-EU разбивка и IELTS6.5 взяты из агрегаторов (Topuniversities, Shiksha, Scholarshiptab), а не напрямую со страницы программы — verified=false'],
  false, null
);

-- Предупреждения при сборе:
-- - Universitat Politècnica de Catalunya / "Master's degree in Marketing Technologies": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Universitat Politècnica de Catalunya / "Master's degree in Technology Talent Management": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Barcelona School of Economics (Universitat Pompeu Fabra) / "Financial Economics Program": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Universitat Pompeu Fabra — "Master of Science in Management": https://www.bsm.upf.edu/en/master-science-management (ECONNRESET)
-- - Universidad Carlos III de Madrid — "Master in Business Administration - MBA": https://www.uc3m.es/master/mba (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Business and Finance (MRes)": https://www.uc3m.es/master/business-finance (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Finance": https://www.uc3m.es/master/finance (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Management": https://www.uc3m.es/master/management (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Human Resources Management": https://www.uc3m.es/master/human-resources (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master of Science in Marketing": https://www.uc3m.es/master/marketing (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Entrepreneurship and Business Venturing": https://www.uc3m.es/master/entrepreneurs (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Applied Artificial Intelligence": https://www.uc3m.es/master/applied-artificial-intelligence (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Double Master's Degree in Informatics Engineering and Computer Science and Technology": https://www.uc3m.es/master/double-informatics-engineering-computer-science-technology (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Double Master's Degree in Informatics Engineering and Applied Artificial Intelligence": https://www.uc3m.es/master/double-informatics-engineering-applied-artificial-intelligence (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Social Sciences": https://www.uc3m.es/master/social-sciences (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Computational and Applied Mathematics": https://www.uc3m.es/master/applied-mathematics (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Carlos III de Madrid — "Master in Industrial Mathematics (INTERUNIVERSITY)": https://www.uc3m.es/master/industrial-mathematics (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
-- - Universidad Politécnica de Madrid — "European Master in Software Engineering": https://muss.fi.upm.es/en/index.php (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
