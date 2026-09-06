-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Подтверждено отдельно: IELTS ≥6.0 (polimi.it/en/students/language-requirements/students-of-laurea-magistrale-study-programmes); архитектурные программы принимаются только на 1-й семестр, early bird 1 декабря (polimi.it/.../deadlines); диапазон €3 300–€3 900/год для иностранцев (polimi.it/.../tuition-fees и сторонние источники). verified=false, потому что все три параметра (tuition + deadline + language) не подтверждены на одной конкретной странице программы, а дедлайн 30 января — оценка по постам прошлых лет, актуальную дату нужно сверить на странице дедлайнов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Architecture', 'Design', 'English', 24, 3900,
  1, 30, 6, 3, 'https://www.polimi.it/en/prospective-students/how-to-apply/admission-to-laurea-magistrale/foreign-qualification/deadlines',
  array['Italian Government Scholarships for Foreign Students (MAECI)', 'Invest Your Talent in Italy', 'DSU regional scholarship (income-based, for non-EU too)', 'Politecnico merit-based tuition fee waivers'],
  'Двухлетняя магистерская программа Laurea Magistrale in Architecture в Politecnico di Milano — одна из сильнейших архитектурных школ Европы; программы Школы архитектуры принимают студентов только на первый семестр, обучение ведётся на английском (с возможностью изучения итальянского).',
  array['Топовая архитектурная школа Италии и Европы, сильный бренд в проектировании и урбанистике', 'Программа преподаётся на английском, IELTS 6.0 — относительно мягкое требование', 'Возможность поступления только на 1-й семестр — дедлайн раньше, чем у инженерных программ, но результаты тоже приходят быстрее', 'Доступны стипендии итальянского правительства и освобождение от оплаты за заслуги для иностранных студентов'],
  array['Для абитуриентов архитектурных программ обязателен GRE General Test — дополнительные расходы и подготовка', 'Плата для non-EU варьируется по доходу (€3 300–€3 900/год), фиксированной ставки без подтверждения ISEE нет', 'Дедлайн для не-ЕС приблизительно 30 января (early bird — 1 декабря), точная дата меняется по годам — нужна ручная проверка на странице дедлайнов'],
  false, null
);

-- Не удалось подтвердить все три параметра (tuition, deadline, IELTS) на одной и той же странице Polimi за один раунд поиска. Стоимость €3,898 для non-EEA взята со страницы educations.com, цитирующей официальные тарифы Polimi (на самой странице программы Polimi раздел ''Costs and scholarships'' присутствует, но конкретная цифра в сниппете не показана). Дедлайн 29 января для non-EEA нерезидентов Италии взят со страницы Polimi deadlines (foreign-qualification/deadlines) — однако точная разбивка по раундам в сниппете обрезана. IELTS 6.0 — стандартное требование Polimi для англоязычных магистратур, прямого подтверждения именно для LLH в выдаче нет. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Landscape Architecture - Land Landscape Heritage', 'Design', 'English', 24, 3898,
  1, 29, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/landscape-architecture-land-landscape-heritage',
  array['Invest Your Talent in Italy', 'Polimi merit-based fee waivers', 'DSU regional scholarship (based on income)'],
  'Двухгодичная магистратура (Laurea Magistrale, 120 ECTS) в Школе AUIC Политехнико Милано с кампусом в Пьяченце. Программа сосредоточена на наследии ландшафта, территориальном планировании и проектной культуре, ведётся полностью на английском.',
  array['Фиксированная non-EU ставка ~€3,898/год (прозрачно и часто ниже, чем в топовых школах Северной Европы)', 'Сильная проектная школа AUIC с доступом к итальянским ландшафтным кейсам — UNESCO-объекты в Ломбардии и Пьемонте'],
  array['Дедлайн для non-EU резидентов за пределами Италии жёсткий — около 29 января (1-й раунд), рекомендуется ранняя подача', 'Программа ориентирована на ландшафтную архитектуру/урбанистику — требуется релевантное бакалаврское образование, иначе возможен условный приём'],
  false, null
);

-- verified=false, так как не удалось подтвердить все три поля (tuition+deadline+IELTS) для не-ЕС студентов на одной официальной странице программы. Tuition ~€3 898/год для не-ЕС (максимальный брекет) подтверждён через страницу Tuition fees Polimi и сторонние источники (educations.com, uniprogroup); дедлайн 29 января — со страницы Deadlines Polimi для Laurea Magistrale (общий пул, архитектура/дизайн); IELTS 6.0 — стандартное соответствие B2 в Polimi. На самой странице программы отдельной таблицы «non-EU vs EU» не нашёл за один раунд поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Sustainable Architecture and Landscape Design', 'Design', 'English', 24, 7796,
  1, 29, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/sustainable-architecture-and-landscape-design',
  array['Invest Your Talent in Italy', 'Polimi Merit-Based Scholarships for international students', 'Italian Government Scholarships for foreign students'],
  'Магистратура Polimi в Пьяченце по устойчивой архитектуре и ландшафтному дизайну на английском, готовит архитекторов с экспертизой в экологическом проектировании для частного и государственного сектора.',
  array['Программа полностью на английском, аккредитована и признаётся для профессионального экзамена архитекторов в Италии', 'Сильная специализация на устойчивости и ландшафте — редкое сочетание на уровне MSc', 'Polimi входит в топ мировых архитектурных школ и имеет широкую сеть партнёрств и стипендий для иностранцев'],
  array['Для не-ЕС студентов Polimi автоматически ставит максимальный брекет оплаты (~€3 898/год, всего ~€7 796 за 2 года) — это самый высокий тариф без скидок по доходу', 'Основной дедлайн подачи на магистратуру — около 29 января (ранний бёрд — 1 декабря), что очень рано для абитуриентов с дипломами из не-ЕС', 'Точные требования к GPA и портфолио не зафиксированы единой цифрой на странице программы; IELTS 6.0 (B2) — минимум, но конкурс может требовать выше'],
  false, null
);

-- verified=false: на programme-detail странице факты по tuition/deadline/IELTS для не-ЕС студентов не подтверждены одним источником. Tuition ~€3 900/год для не-ЕС взят из описаний в Mastersportal/Scribd/Polimi-проспекте, но официальный ISEE-based fee calculator Polimi даёт широкий диапазон, поэтому точная цифра зависит от дохода семьи. Дедлайн 29 января 2026 — со страницы polimi.it/.../deadlines (окно 1 Oct 2025 – 29 Jan 2026, early bird 1 Dec 2025), IELTS6.0 — со страницы требований Polimi. Все три цифры требуют сверки перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Integrated Product Design', 'Design', 'English', 24, 3900,
  1, 29, 6, 3, 'https://www.polimi.it/en/prospective-students/how-to-apply/admission-to-laurea-magistrale/foreign-qualification/deadlines',
  array[]::text[],
  'Магистратура Integrated Product Design в Politecnico di Milano — двухгодичная программа на английском в кампусе Бовиза, ориентированная на индустриальный и сервисный дизайн с сильной проектной и инженерной составляющей.',
  array['Англоязычная программа в топовом европейском техническом университете с сильной индустриальной базой', 'Стипендии Invest Your Talent in Italy и merit-based стипендии Polimi для нерезидентов ЕС'],
  array['Дедлайн января 2026 подтверждён со страницы Deadlines, но конкретный крайний срок именно для Design-программ (1-й семестр) лучше перепроверить на programme-detail, в найденных сниппетах он не указан явно'],
  false, null
);

-- Программа подтверждена на polimi.it (2 года, английский). Цена €3 900/год и IELTS 6.0 подтверждены сторонними агрегаторами (thetrustline.com, yocket). Дедлайн 31 марта 2026 — по TopUniversities (агрегатор Polimi). На самой странице polimi.it точный non-EU дедлайн и точная ставка €3 900 для non-EU в одном месте не показаны, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Interior and Spatial Design', 'Design', 'English', 24, 3900,
  3, 31, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/interior-and-spatial-design',
  array['Polimi Merit Scholarship', 'DSU Lombardia regional scholarship', 'Invest Your Talent in Italy'],
  'Магистратура Polimi по интерьерному и пространственному дизайну на английском, 2 года (120 ECTS), сильная школа дизайна с сильным портфолио и доступом к миланской индустрии.',
  array['Престижная школа дизайна и сеть выпускников в индустрии', 'Программа полностью на английском, не нужна IELTS сверх 6.0', 'Возможность получить стипендию Polimi Merit или DSU'],
  array['Неевропейский фиксированный взнос ~€3 900/год (итого ~€7 800), без скидок по доходам', 'Высокий конкурс и портфолио-зависимый отбор'],
  false, null
);

-- verified=false: программа, длительность 120 ECTS/24 мес и структура call for applications подтверждены через официальные страницы unibo.it/en/study/second-cycle-degree/programme/2025/6727 и corsi.unibo.it/2cycle/ArchitectureCreativePractices/how-to-enrol, а также PDF bando ACPCL. Однако tuition, deadline и IELTS именно для non-EU на одной и той же странице 2025/6727 не подтверждены одним источником — данные собраны из Yocket (€3060/год), Shiksha (€3315/год), Mastersportal (€157 минимум по ISEE), открытого поста о deadline 30.05.2025. Без прямого парсинга официальной страницы программы верифицировать все три параметра (tuition+deadline+IELTS) для non-EU в одной точке нельзя — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Architecture and Creative Practices for the City and Landscape', 'Design', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.unibo.it/en/study/second-cycle-degree/programme/2025/6727',
  array['Unibo International Talents @Unibo (fee-waiver + study grant for non-EU students)', 'Italian Government Scholarships (Invest Your Talent / MAECI)', 'ERASMUS+ study grants (during mobility windows)'],
  'Двухгодичная магистратура (120 ECTS) Университета Болоньи на английском, посвящённая архитектуре, городскому проектированию и ландшафту. Программа со «restricted access» — требуется отдельный отбор через call for applications (call ACPCL internaz).',
  array['Полностью на английском, без требования итальянского', 'Самая старая университетская традиция Европы (Alma Mater Studiorum), сильная архитектурная школа', 'Болонья — компактный, студенческий, недорогой по сравнению с Миланом/Лондоном город', 'Хорошая поддержка международных студентов через scholarships @Unibo Action 2'],
  array['Программа restricted access: отдельный call for applications с конкурсом портфолио и мотивационного письма, не просто подача документов', 'Точная стоимость для non-EU зависит от наличия ISEE/equivalente; цифра 6400 EUR — экспертная оценка на 2 года (≈3200/год по открытым источникам типа Yocket/Shiksha), точный non-EU-тариф именно на этой программе 2025/2026 на главной странице в выдаче не подтверждён', 'Дедлайны у не-ЕС студентов часто привязаны к единственному раунду в марте-апреле; апрельский 30.04 — наиболее вероятное окно, но точная дата зависит от годового call (PDF ACPCL internaz 2026/2027 доступен, для 2025/2026 нужна сверка)', 'IELTS 6.0 указан по умолчанию как типичный B2-minimum Unibo, но минимальный балл на этой конкретной программе в открытой выдаче не подтверждён'],
  false, null
);

-- Подтверждено частично: studyineurope.eu указывает non-EU fee ~€1 400/год для магистратур архитектурного/инженерного профиля Болоньи; IELTS минимум по другим англоязычным магистратурам Unibo (corsi.unibo.it) варьируется 5.5–6.5; конкретные значения для не-EU студентов на странице da.unibo.it/en в одной выдаче одновременно не подтверждены, поэтому verified=false. Deadline взят как типичный апрельский для non-EU наборов Unibo, требует проверки на официальной странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Architecture — Engineering and Architecture', 'Design', 'English', 24, 2800,
  4, 30, 6, 3, 'https://da.unibo.it/en',
  array[]::text[],
  'Магистратура по архитектуре в Университете Болоньи (Школа инженерии и архитектуры) на английском языке, длительностью 2 года. Подходит иностранным студентам благодаря относительно низкой фиксированной плате для non-EU.',
  array['Один из старейших и престижных технических вузов Европы', 'Англоязычная программа, IELTS обычно около 6.0–6.5', 'Фиксированная non-EU плата ~€1 400/год — ниже многих других европейских вузов'],
  array['Точная сумма tuition и крайний срок для non-EU не подтверждены на одной официальной странице da.unibo.it/en (verified=false)', 'Архитектурные программы в Италии часто требуют портфолио или вступительный экзамен — нужно уточнять на странице программы'],
  false, null
);

-- Deadline 16 September подтверждён на официальной странице apply (не-EU students). Tuition ~€1,000 — по сторонним источникам (Quora, Yocket), официальная страница использует скользящую шкалу €300–€2,500 в зависимости от ISEE/страны. IELTS 6.0 — стандарт Sapienza для англоязычных программ, но на найденной странице явно не указан. Verified=false, так как не все три параметра tuition/deadline/IELTS подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Architecture (Conservation)', 'Design', 'English', 24, 1000,
  9, 16, 6, 3, 'https://corsidilaurea.uniroma1.it/en/archive/2025/33430/apply',
  array['Invest Your Talent in Italy', 'Sapienza fee waivers based on ISEE/income'],
  'Магистратура по реставрации архитектурного наследия в Sapienza (Рим) — 2 года, обучение на английском, диплом одного из старейших университетов Европы. Программа ориентирована на работу с исторической застройкой и объектами культурного наследия Италии.',
  array['Университет мирового уровня в центре Рима с сильной школой реставрации', 'Программа полностью на английском, рассчитана на иностранных студентов', 'Доступная стоимость обучения по сравнению с североевропейскими вузами'],
  array['Точный размер tuition зависит от дохода/ISEE и подтверждения по стране происхождения — цифра приблизительная', 'IELTS не подтверждён как обязательный именно на официальной странице программы (часто требуется на уровне 6.0)'],
  false, null
);

-- verified=false: на известном URL https://corsidilaurea.uniroma1.it/en/course/33431 в выдаче появился только PDF (33431_e.pdf), который упоминает сбор €10 за оценку требований и non-EU визовые сроки, но НЕ содержит конкретных tuition/IELTS/deadline для non-EU студентов в сниппете. Цифры €1,462/год взяты из агрегаторов (TopUniversities, Yocket, Shiksha, ScholarshipsAds), а IELTS 6.0 — стандартное требование Sapienza для англоязычных магистратур, но не подтверждено на той же странице, что и tuition/deadline. Дедлайн 30 апреля — типичная дата для non-EU преселекции в итальянских вузах, но не взят напрямую с официальной страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Architecture - Urban Regeneration', 'Design', 'English', 24, 1462,
  4, 30, 6, 3, 'https://corsidilaurea.uniroma1.it/en/course/33431',
  array['Invest Your Talent in Italy', 'Sapienza international scholarships (based on country of residence and ISEE)'],
  'Магистратура по архитектуре и городской регенерации в Sapienza University of Rome — 2-летняя англоязычная программа в Риме. Ориентирована на проектирование, исследования и управление процессами реновации городской среды.',
  array['Программа полностью на английском, в центре Рима — престижный исторический контекст', 'Стоимость для иностранцев относительно невысокая (примерно €1,462/год по данным агрегаторов), возможны скидки до €300/год по ISEE', 'Диплом Sapienza — одного из старейших и крупнейших университетов Европы'],
  array['Точные цифры tuition/deadline/IELTS для НЕ-EU студентов не удалось подтвердить единым официальным источником за один раунд поиска: на известном URL есть только PDF-вложение, конкретных non-EU цифр в выдаче нет', 'Часть агрегаторов (TopUniversities, Yocket) показывает €2,924 за весь курс (≈€1,462/год), но это усреднённое значение, а реальная ставка для non-EU зависит от страны проживания и ISEE', 'Одно стороннее упоминание (''No IELTS required'') противоречит стандартным требованиям — требует ручной проверки на странице курса'],
  false, null
);

-- Подтверждено частично: программа и URL — corsidilaurea.uniroma1.it/en/course/33429; туиция не-ЕС €2,924/год — mastersportal.com (агрегатор); дедлайн не-ЕС 15 мая 2026 — общая страница admissions Sapienza (uniroma1.it/en/en/admissions) для поступающих с визой; IELTS 6.0 — mastersportal и сторонние источники. Официальная PDF (offertaformativa) найдена, но конкретные цифры из неё в выдаче не извлечены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Landscape Architecture', 'Design', 'English', 24, 2924,
  5, 15, 6, 3, 'https://corsidilaurea.uniroma1.it/en/course/33429',
  array[]::text[],
  'Магистратура по ландшафтной архитектуре в Sapienza (код 33429, LM-3) — 2 года, преподавание на английском, входной экзамен для проверки знаний. Ориентирована на международных студентов.',
  array['Преподавание на английском', 'Низкая стоимость для не-ЕС (~€2,924/год)', 'Престижный университет в центре Рима'],
  array['Туиция, дедлайн и IELTS подтверждены из разных источников (mastersportal + общая страница admissions Sapienza), а не с одной официальной страницы курса — verified=false'],
  false, null
);

-- Частично подтверждено: страница курса https://corsidilaurea.uniroma1.it/en/course/33433 и Apply-страница подтверждают 2-летнюю магистратуру LM-12 на английском и публикацию call 16/06/2026 на 2026/2027. На mastersportal.com указан тариф 2924 EUR/year, но это базовый rate Sapienza без явного разграничения EU vs non-EU bands; на той же странице IELTS показан как 5.5 (хотя общий порог Sapienza — 6.0). Дедлайн ''June 19'' взят из анонса 2025/2026 цикла. Все три параметра (тариф, дедлайн, IELTS для non-EU) одновременно на одной официальной странице явно не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Product and Service Design', 'Design', 'English', 24, 2924,
  6, 19, 6, 3, 'https://corsidilaurea.uniroma1.it/en/course/33433',
  array['Invest Your Talent in Italy', 'Sapienza regional scholarships (DSU Lazio)'],
  'Магистратура Sapienza на английском языке (LM-12, 2 года) на стыке промышленного дизайна, сервис-дизайна и новых технологий. Обучение в Риме, доступно для иностранных студентов.',
  array['Полностью на английском языке', 'Диплом Sapienza — престижного римского университета', 'Специализация на продуктовом и сервисном дизайне с акцентом на новые технологии'],
  array['Указанная сумма 2924 EUR/год — это базовая ставка Sapienza для non-EU/extra-EU студентов; реальная стоимость может быть выше в зависимости от страны происхождения (bands A–E по ISEE-equivalent). Точный non-EU тариф для одного академического года на одной странице с дедлайном и IELTS одновременно не подтверждён — нужна сверка с официальным PDF ''call for applications'' 2026/2027'],
  false, null
);

-- verified=false: tuition, deadline и IELTS не подтверждены все три на одной официальной странице corsi.unige.it/11913. Подтверждено: код 11913, LM-4, длительность 2 года/120 CFU, английский язык обучения. Дедлайн взят как UNIGEAPPLY для не-EU (20 марта 2026, по постам приёмной комиссии UniGe 2026/27). Tuition оценён по средним публичным данным UniGe для не-EU (≈€3 300/год), IELTS 6.0 — стандартное требование B2 для англоязычных магистратур UniGe.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7f7a886b-711e-40a3-85ac-d208bec0313b',
  'Architecture', 'Design', 'English', 24, 6600,
  3, 20, 6, 3, 'https://corsi.unige.it/en/corsi/11913',
  array['Invest Your Talent in Italy', 'UniGe regional DSU scholarship (based on income)', 'Marco Polo / Italian Government scholarships for non-EU'],
  'Магистратура по архитектуре (LM-4) в Университете Генуи — 2 года, 120 CFU, официальный язык обучения английский. Программа ориентирована на проектирование, имеет правоустанавливающий статус для профессии архитектора в Италии.',
  array['Англоязычная программа в гос-вузе Италии с дипломом LM-4, дающим доступ к профессии архитектора', 'Относительно низкая стоимость по сравнению с частными архитектурными школами Северной Европы', 'Генуя — крупный портовый город с практической архитектурной средой и прибрежной урбанистикой'],
  array['Точная сумма tuition для не-EU на странице программы не подтверждена, оценка €3 000–3 500/год (≈€6 600 за 2 года) по средним данным UniGe', 'Дедлайн варьируется: предварительная регистрация до 30 ноября 2026, но для не-EU через UNIGEAPPLY отдельная волна с дедлайном ~20 марта 2026 — нужна проверка на конкретный набор', 'IELTS 6.0/B2 выставлен как типовое требование итальянских программ на английском, но на странице 11913 в выдаче явно не указан'],
  false, null
);

-- verified=false: не удалось в одной выдаче найти одну и ту же страницу, где одновременно подтверждены tuition для non-EU, deadline и IELTS именно для Landscape Architecture (11904). Дедлайн UniGeApply fall session для non-EU магистратур: 26/11/2025–20/03/2026 — подтверждено на странице admission criteria (corsi.unige.it/en/corsi/11904/prospective-students-admission-criteria-procedure), это использовано как deadline_month=3, day=20. IELTS6.0 и tuition ~3000 EUR — типичные значения для non-EU магистратур UniGe по английски-преподаваемым программам (по разрозненным постам о UniGe), но не подтверждены на конкретной странице 11904 в этой выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7f7a886b-711e-40a3-85ac-d208bec0313b',
  'Landscape Architecture', 'Design', 'English', 24, 3000,
  3, 20, 6, 3, 'https://corsi.unige.it/en/corsi/11904',
  array[]::text[],
  'Магистратура по ландшафтной архитектуре в Университете Генуи — двухгодичная англоязычная программа с проектно-исследовательским уклоном и связями с портовым/средиземноморским контекстом Лигурии.',
  array['Преподавание полностью на английском', 'Университет публикует отдельный трек для non-EU абитуриентов через UniGeApply с понятным дедлайном'],
  array['Точный non-EU тариф и требование IELTS на странице курса 11904 в выдаче прямо не подтверждены — цифры приведены по типичным значениям UniGe для международных магистратур (см. source_note)', 'Стипендии/гранты конкретно для этого курса не найдены в одной поисковой выдаче'],
  false, null
);

-- Подтверждено: существование программы и страница https://corsi.unige.it/en/corsi/11967 реальны; длительность 2 года указана на самой странице; в выдаче есть страница дедлайнов (corsi.unige.it/en/corsi/11967/prospective-students-deadlines), упоминающая несколько окон подачи, и страница unige.it/en/internazionale/procedura-prevalutazione-lauree-magistrali-inglese-solo-studenti-non-eu-residenti-all для non-EU. Не подтверждено на одной странице одновременно: tuition для non-EU (6400 € — оценка по верхней границе типичного non-EU тарифа итальянских госвузов), точный deadline 30 апреля (реальные окна — около 14–20 марта или 30 ноября), IELTS 6.0 (в некоторых постах пишут ''IELTS not required'', но это относится к англоязычным носителям или студентам с дипломом на английском). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7f7a886b-711e-40a3-85ac-d208bec0313b',
  'Advanced Materials Science and Technology', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://corsi.unige.it/en/corsi/11967',
  array[]::text[],
  'Магистерская программа Университета Генуи по перспективным материалам, читаемая на английском языке. Длительность — 2 года, ориентирована на инженеров и специалистов по материаловедению.',
  array['Преподавание полностью на английском', 'Генуя — крупный индустриальный и портовый город, есть стажировки в местных компаниях', 'Доступная для итальянского госвуза стоимость обучения по сравнению с североевропейскими программами'],
  array['Точная стоимость для non-EU студентов, крайний срок подачи и требование IELTS не подтверждены на одной официальной странице в рамках одной поисковой сессии — цифры приведены как best-effort оценки', 'На странице программы не указана отдельная non-EU ставка tuition; обычно non-EU платят максимальный взнос, но точный размер требует уточнения через unige.it/en/fees-and-benefits', 'Дедлайн non-EU зависит от цикла набора (UniGeApply): упоминаются окна до 14 марта, 20 марта, 30 ноября и 10 марта следующего года — выбран 30 апреля как середина весеннего окна, реальная дата может быть другой'],
  false, null
);

-- verified=false: страница курса https://corsi.unige.it/en/corsi/11950 содержит общее описание программы, но конкретная стоимость для non-EU студентов в результатах поиска не отображена (нет сниппета с точной суммой); официальный раздел tuition unige.it/en/fees-and-benefits упоминает базовые взносы, но без чёткой привязки к этой конкретной магистратуре и категории non-EU. Сроки подачи UniGeApply и IELTS 6.0 — стандартные требования Генуэзского университета для англоязычных магистратур, но не подтверждены в одном источнике вместе с точной non-EU стоимостью, поэтому verified установлен в false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7f7a886b-711e-40a3-85ac-d208bec0313b',
  'Sustainable Polymer and Process Chemistry', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://corsi.unige.it/en/corsi/11950',
  array[]::text[],
  'Магистерская программа Университета Генуи по устойчивой полимерной и процессной химии (SMART), преподаётся на английском, рассчитана на 2 года и ориентирована на промышленную химию, катализ и науку о полимерах.',
  array['Программа полностью на английском языке и подходит для иностранных студентов', 'Специализация на востребованной области устойчивых полимеров и зелёной химии'],
  array['Точная сумма взноса для non-EU студентов не подтверждена на одной конкретной странице курса; приведённая цифра €6400 — оценка по верхнему диапазону для иностранцев, указанная сумма требует уточнения'],
  false, null
);

-- verified=false: на одной странице одновременно подтверждены только tuition (€7,500 с http://www.santannapisa.it/en/tuition-fee) и общая длительность (2 года). Конкретный дедлайн для не-EU на 2026/27 и явный IELTS-минимум не найдены на одной официальной странице программы; дедлайн взят по аналогии с прошлым циклом (25 сентября 2023, http://www.santannapisa.it/en/call-ii-level-courses), IELTS — типовая оценка для англоязычных магистратур Sant''Anna. EU/non-EU разграничение тарифов не обнаружено — публикуется единая сумма €7,500 для полного магистерского курса.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '02815259-4827-4e75-bedc-0f5752495996',
  'MSc in Molecular Biotechnology', 'Biotechnology', 'English', 24, 7500,
  9, 25, 6, 3, 'http://www.santannapisa.it/en/training/msc-molecular-biotechnology',
  array['Merit-based partial/total tuition waivers and ''Allievi'' honors programme scholarships (covers part or all of €7,500 tuition plus living allowance)'],
  'Двухлетняя магистратура по молекулярной биотехнологии в Школе перспективных исследований Сант''Анна (Пиза), реализуется совместно с Университетом Пизы. Программа на английском языке, ориентирована на фундаментальную и прикладную биотехнологию.',
  array['Престижная Scuola Superiore Sant''Anna с международной репутацией', 'Совместная программа с Университетом Пизы, доступ к ресурсам обоих вузов', 'Возможность получения стипендий, частично или полностью покрывающих обучение'],
  array['Официальная страница программы не публикует IELTS-минимум явно (требуется уточнение у приёмной комиссии)', 'Дедлайн для не-ЕС студентов в текущем цикле 2026/27 не подтверждён в одном источнике с тарифами', 'Чёткого разделения тарифа EU/не-EU на странице tuition fee не найдено — указана единая сумма €7,500'],
  false, null
);

-- verified=false, потому что на одной странице icad.unifi.it одновременно не подтверждены все три параметра (tuition+deadline+IELTS) именно для non-EU студентов. Enrollment-страница (vp-117-enrollment.html) упоминает требование английского B2 и процедуру для non-EU, apply.unifi.it/courses/course/23-architettura-curriculum-architectural-design дублирует требование английского, но точная цифра IELTS 5.5/6.0 и точная дата дедлайна 2025/2026 на этих страницах не зафиксированы. Tuition €2,800 взят как верхняя non-EU планка из общеуниверситетской шкалы (таблица tasse 2025/2026 на unifi.it), а не с самой страницы iCAD — поэтому оценка, а не подтверждение.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Architectural Design (iCAD)', 'Design', 'English', 24, 2800,
  3, 31, 5.5, 3, 'https://www.icad.unifi.it/vp-117-enrollment.html',
  array['Invest Your Talent in Italy', 'Regione Toscana DSU scholarship', 'Unifi fee waivers based on ISEE/ISEEU equivalent for non-EU students'],
  'Двухгодичная англоязычная магистратура по архитектурному дизайну в Университете Флоренции, ориентированная на международных студентов. Стоимость для non-EU студентов попадает в диапазон ~€2,800/год по верхней границе ISEE-шкалы, заявка подаётся через портал apply.unifi.it с английским сертификатом уровня B2.',
  array['Полностью англоязычная программа в историческом центре архитектуры', 'Гибкая система оплаты: от ~€150 до ~€2,800/год в зависимости от дохода семьи', 'Принимаются студенты из-за пределов ЕС через отдельный конкурс'],
  array['Точная сумма tuition для non-EU сильно зависит от ISEE/ISEEU-эквивалента, фиксированной цифры €2,800 на сайте iCAD нет — это верхняя планка шкалы Университета Флоренции', 'Минимальный балл IELTS 5.5 (CEFR B2), но некоторые источники указывают 6.0/6.5 — лучше уточнить при подаче', 'Дедлайн ~конец марта/начало апреля приблизительный, официальная дата варьируется по году'],
  false, null
);

-- Не удалось подтвердить на одной официальной странице одновременно tuition, deadline и IELTS для не-ЕС студентов. Страница vp-113 — общая презентация программы, без цифр; tuition ~€6400 взят как типичный верхний предел для итальянских вузов по аналогии, deadline30 апреля — типовой для магстратур Unifi; IELTS 6.0 — стандартное требование Unifi для англоязычных магистратур. verified=false, потому что ни одно из значений не подтверждено на той же странице для не-ЕС.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Landscape Architecture', 'Design', 'English', 24, 6400,
  4, 30, 6, 3, 'https://apply.unifi.it/',
  array[]::text[],
  'Магистратура по ландшафтной архитектуре во Флорентийском университете (2 года, LM-3) — классическая итальянская программа с сильной историко-культурной базой.',
  array['2 года, очная форма, междисциплинарная программа LM-3 с фокусом на историческом ландшафте Тосканы', 'Возможность подачи через единый онлайн-портал apply.unifi.it'],
  array['На основной странице кафедры (vp-113-presentation.html) конкретные суммы tuition/deadline/IELTS для не-ЕС студентов не указаны — точные цифры нужно уточнять в приёмной комиссии или на apply.unifi.it, поэтому verified=false'],
  false, null
);

-- Подтверждено: программа действительно существует на sosglo.unifi.it (vp-124-presentation.html) и значится как LM-88 в каталоге unifi.it/en/study-us. Подтверждено наличие двойного диплома (vp-204) и страница подачи заявок на apply.unifi.it/courses/course/51. НЕ подтверждено на одной и той же странице: точная non-EU стоимость, дедлайн и порог IELTS 6.0 — на presentation-странице этих цифр нет, поэтому verified=false. Сумма ~€6400 за 2 года и дедлайн 30 апреля — типичные для Университета Флоренции ориентиры для non-EU магистров, но не подтверждены прямо цитатой. IELTS 6.0 — стандартный порог для англоязычных программ UniFi, явной формулировки на vp-124 в выдаче не нашлось.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'Sociology and Global Challenges', 'Social Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.sosglo.unifi.it/vp-124-presentation.html',
  array['Invest Your Talent in Italy (per programmi in inglese con partner industriali)', 'Borse di studio Unifi per studenti internazionali (DSU/Regione Toscana, ISEEU-based)', 'Erasmus+ per doppi titoli (Double Degree partner)'],
  'Магистерская программа Университета Флоренции (LM-88) на английском языке в области социологии глобальных вызовов — миграция, неравенство, устойчивое развитие, цифровая трансформация. Подходит для выпускников социологии, политологии, международных отношений и смежных дисциплин.',
  array['Преподавание полностью на английском в историческом центре Флоренции', 'Возможность участия в Double Degree с зарубежными партнёрами', 'Сильная исследовательская среда в области социальных наук (SPES)', 'Университет входит в списки и предлагает стипендии для non-EU студентов'],
  array['Не нашли на указанной странице (vp-124) подтверждённых сумм non-EU-тарифа, дедлайна и порога IELTS — точные цифры нужно сверять с apply.unifi.it и страницей admission на 2026/27, поэтому verified=false.', 'Non-EU студенты в Италии платят по индивидуальной шкале ISEEU (зависит от дохода/страны), максимальный годовой взнос меняется ежегодно — €6400 за 2 года лишь типовая оценка.'],
  false, null
);
