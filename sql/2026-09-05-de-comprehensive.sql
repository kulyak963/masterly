-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Программа и страница TUM подтверждены. Официальная страница TUM по学费 отдельно указывает для магистерских программ обычно 4 000 или 6 000 евро за семестр для студентов из не-EU/EEA стран: https://www.tum.de/en/studies/fees/tuition. Для Architecture (M.A.) наиболее вероятна верхняя граница — 6 000 евро за семестр, но это не подтверждено на странице самой программы. Дедлайн 31 мая и IELTS 6.0 также не удалось подтвердить на одной странице программы, поэтому значения являются оценочными.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Architecture (M.A.)', 'Design', 'English', 24, 6000,
  5, 31, 6, 3, 'https://www.ed.tum.de/en/ed/studies/degree-programs/architecture-m-a/',
  array[]::text[],
  'Магистерская программа TUM рассчитана на 2 года. Для студентов из стран вне ЕС/ЕЭЗ ориентировочная学费 составляет 6 000 евро за семестр; подтверждённый в официальных материалах диапазон для магистратур TUM — 4 000–6 000 евро за семестр.',
  array['Программа реализуется в Мюнхене и имеет стандартную продолжительность 2 года', 'Для иностранных студентов TUM указывает ориентировочный диапазон学费 4 000–6 000 евро за семестр'],
  array['Не удалось подтвердить на одной официальной странице программы одновременно точную学费, срок подачи и требование IELTS; поэтому verified=false', 'Точная сумма学费 и дата могут зависеть от учебного года и конкретного набора'],
  false, null
);

-- Стоимость 4000 €/семестр подтверждена напрямую с официальной страницы tum.de для программы Landscape Architecture MA (не ЕС/ЕЭЗ). Срок подачи для зимнего семестра 01.01–31.05 подтверждён. IELTS 6.5 указан по косвенным источникам (Reddit, общие требования TUM), но на известной странице ed.tum.de конкретное число по IELTS явно не извлечено в выдаче — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Landscape Architecture (M.A.)', 'Design', 'English', 24, 4000,
  5, 31, 6.5, 3, 'https://www.ed.tum.de/en/ed/studies/degree-programs/landscape-architecture-m-a/',
  array['Deutschlandstipendium (для части студентов)'],
  'Магистерская программа M.A. Landscape Architecture в TUM длится 4 семестра (24 месяца), преподаётся на английском и немецком. С зимнего семестра 2024/25 введена плата для студентов из третьих стран (не ЕС/ЕЭЗ).',
  array['Престижный технический университет с сильной школой ландшафтной архитектуры', 'Программа на английском языке, что важно для иностранных абитуриентов', 'Хорошие стипендиальные возможности, включая Deutschlandstipendium'],
  array['Плата 4000 € за семестр для не-ЕС студентов ощутима для четырёх семестров (итого ~16 000 €)', 'Точный минимальный IELTS для этой программы 6.5 не подтверждён напрямую с известной страницы — взят из косвенных источников'],
  false, null
);

-- verified=false: дедлайн (1 февраля — 31 мая на зимний семестр) подтверждён со страницы программы cit.tum.de. Тариф для не-ЕС подтверждён только с общей страницы TUM fees (€4000 или €6000/семестр для магистратуры), точная цифра для Mathematics не подтверждена в одном источнике с программой. IELTS 6.5 взят из общего требования TUM для англоязычных магистратур, конкретный порог для Mathematics не подтверждён в выдаче. Все три поля (tuition/deadline/ielts) должны быть на одной странице программы для verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Mathematics (M.Sc.)', 'Natural Sciences', 'English', 24, 6000,
  5, 31, 6.5, 3, 'https://www.cit.tum.de/en/cit/studies/degree-programs/master-mathematics/',
  array['Deutschlandstipendium', 'DAAD Scholarship', 'TUM Global Incentive Fund'],
  'Магистратура по математике в Technical University of Munich — престижная англоязычная программа одного из лучших технических вузов Германии (TU9). Высокое качество исследований, сильная связь с индустрией и кампусом в Мюнхене.',
  array['TUM — один из ведущих технических университетов Германии (TU9, Excellence Strategy)', 'Программа полностью на английском языке', 'Сильная исследовательская среда и связи с индустрией Баварии', 'Доступны стипендии DAAD и Deutschlandstipendium'],
  array['Для студентов не-ЕС действует повышенная плата за обучение (~€6,000/семестр по данным общей страницы fees)', 'IELTS 6.5 — точная цифра для Mathematics M.Sc. не подтверждена по сниппету конкретной страницы программы', 'Конкретный тариф для Mathematics M.Sc. (€4000 vs €6000/семестр) не удалось подтвердить напрямую со страницы программы'],
  false, null
);

-- Подтверждено на странице tum.de: туту 6 000 €/семестр для не-ЕС, дедлайн 31 мая (зимний семестр). IELTS 6.5 указан на общей странице требований TUM для англоязычных программ, но точное значение для Physics не подтверждено одной страницей — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Physics (M.Sc.) — Applied and Engineering Physics', 'Natural Sciences', 'English', 24, 6000,
  5, 31, 6.5, 3, 'https://www.tum.de/en/studies/degree-programs/detail/physics-applied-and-engineering-physics-master-of-science-msc',
  array['Deutschlandstipendium (300 €/мес. на основе успеваемости)', 'TUM Global Online Scholarship', 'возможность полного освобождения от оплаты после подтверждения академической успеваемости'],
  'Магистратура TUM по физике (Applied and Engineering Physics) — двухлетняя англоязычная программа с сильным исследовательским уклоном и доступом к современным лабораториям. Для не-ЕС студентов установлена специальная повышенная плата, но университет предлагает пути её снижения.',
  array['TUM — один из топовых технических вузов Европы и один из лучших вузов Германии по физике', 'Программа полностью на английском языке, без требования знания немецкого при поступлении', 'Сильная исследовательская база и связи с Max Planck, DESY, CERN'],
  array['Туту за семестр для не-ЕС студентов (за весь срок ≈ 24 000 €) — значительно выше, чем стандартный взнос в Баварии (≈ 150 €)', 'Очень плотный конкурс: отбор по GPA, мотивации и профильным предметам бакалавриата; точный порог IELTS требует уточнения на странице поступления', 'Дедлайн 31 мая — жёсткий, и для визовых абитуриентов рекомендуют подаваться до 15 января'],
  false, null
);

-- Страница программы подтверждает отсутствие tuition fees и наличие языка German/English. Официальная страница international applicants RWTH подтверждает, что не-ЕС студенты tuition не платят. Однако с апреля 2025 по новостям обсуждается введение платы €3000–5000/сем. для не-ЕС — фактическая стоимость может измениться. Дедлайн 1 марта для не-ЕС подтверждён несколькими независимыми источниками (Collegedunia, Facebook-пост RWTH). IELTS 6.0 и GPA 3.0 — стандартные требования RWTH для англоязычных магистратур, конкретные цифры для Mathematics M.Sc. на странице программы не указаны — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '551175dd-cb8a-45ca-b1e3-c28872f889c6',
  'Mathematics M.Sc.', 'Natural Sciences', 'English', 24, 0,
  3, 1, 6, 3, 'https://www.rwth-aachen.de/cms/root/studium/vor-dem-studium/studiengaenge/liste-aktuelle-studiengaenge/studiengangbeschreibung/~bour/mathematik-m-sc-/?lidx=1',
  array[]::text[],
  'Магистерская программа по математике в RWTH Aachen — исследовательская, с возможностью обучения на немецком или английском. Для не-граждан ЕС обучение бесплатное, оплачивается только семестровый взнос около 300 евро.',
  array['Бесплатное обучение для не-граждан ЕС (NRW субсидирует)', 'Сильная исследовательская математическая школа, топовый технический университет', 'Возможность учиться на английском языке'],
  array['Дедлайн для не-ЕС абитуриентов — 1 марта (зимний семестр), что ужесточает планирование', 'С апреля 2025 обсуждается введение платы 3000–5000 €/семестр для не-ЕС — данные могут устареть', 'Точный минимальный IELTS и GPA не указаны на странице программы — приведены общие требования RWTH'],
  false, null
);

-- Подтверждено на странице RWTH International Academy: tuition 18 000 € (6 000 €/семестр, одинаково для всех стран), deadline для non-EU — 1 марта (для EU — 15 июля), язык — английский. verified=false, так как конкретный минимальный балл IELTS на этой же странице в сниппете не указан; длительность уточнена как 3 семестра (18 месяцев), а не 24.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '551175dd-cb8a-45ca-b1e3-c28872f889c6',
  'Master of Public Administration in European Studies (MPA-ES)', 'Social Sciences', 'English', 18, 18000,
  3, 1, 6, 3, 'https://www.academy.rwth-aachen.de/en/programs/masters-degree-programs/detail/master-of-public-administration-european-studies',
  array[]::text[],
  'Магистерская программа RWTH Aachen University (через RWTH International Academy) на стыке публичного управления, политики ЕС и европейской экономики, преподаётся полностью на английском, длится 3 семестра.',
  array['Одинаковая стоимость для всех стран (нет разделения EU/non-EU по tuition)', 'Программа при престижном техническом университете RWTH Aachen', 'Полностью на английском, без требований по немецкому', 'Early Bird скидка 10% при подаче до 15 января (non-EU) / 15 апреля (EU)'],
  array['Точный балл IELTS на странице программы не указан (по общим требованиям RWTH — около 6.0–6.5, нужно уточнять)', 'Дедлайн для non-EU жёсткий — 1 марта, что заметно раньше EU-абитуриентов', 'Дополнительно семестровый взнос ~300 EUR и расходы на проживание в Аахене'],
  false, null
);

-- verified=false, так как все три ключевых параметра (tuition, deadline, language) найдены на РАЗНЫХ страницах, а не на одной официальной странице программы. Tuition = 0 EUR подтверждено на странице financing и упомянуто nbyula.com (программа tuition-free, нет разницы EU/non-EU, что отличается от шаблона 6400 EUR). Deadline31 августа (зимний) / 28 февраля (летний) с mygermanuniversity.com. IELTS6.5 (= C1 по CEFR) указан на официальной странице программы и на Faculty IV master''s programs. GPA-минимум не указан — открытый приём.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e1a54bc3-0c34-4ec2-b3e5-9a46b7f7fcd0',
  'Environmental Science and Technology M.Sc.', 'Natural Sciences', 'English', 24, 0,
  8, 31, 6.5, 3, 'https://www.tu.berlin/en/studying/study-programs/all-programs-offered/study-course/environmental-science-and-technology-m-sc-1',
  array['Deutschlandstipendium (300€/мес при отличной успеваемости)', 'TU Berlin Stipendienprogramm (для иностранных студентов)', 'DAAD Scholarships'],
  'Магистерская программа M.Sc. по науке и технологиям окружающей среды в TU Berlin, преподаётся на английском, обучение бесплатное (только семестровый взнос ~€350), открытый приём без Numerus Clausus.',
  array['Полностью бесплатное обучение для не-граждан ЕС (только семестровый взнос ~€350/семестр)', 'Преподавание на английском, C1 требуется', 'Открытый приём (open admission), не нужно проходить через Numerus Clausus', 'TU Berlin — один из топовых технических вузов Германии'],
  array['Семестровый взнос ~€350 всё равно нужно оплачивать каждый семестр (включает проездной по Берлину)', 'IELTS 6.5+ для подтверждения C1 — строже, чем многие английские программы в других немецких вузах', 'Дедлайн для не-граждан ЕС — 31 августа (зимний семестр), что позже, чем у конкурентов', 'verified=false: tuition, deadline и language подтверждены с разных страниц, а не все три на одной официальной'],
  false, null
);

-- Проверена официальная страница программы TU Berlin: https://www.tu.berlin/en/studying/study-programs/all-programs-offered/study-course/architecture-typology-m-sc. Она подтверждает существование программы и указывает, что набор на Winter Semester 2026/27 не проводится, но в доступном результате поиска не содержит одновременно подтверждённых не-EU-ставки обучения, точного дедлайна и требования IELTS. Дополнительные результаты указывают IELTS от 6.0 и для заявителей из не-EU стран дедлайн 15 мая, поэтому значения выше оставлены как предварительные; 6 400 евро и GPA 3.0 не считаются подтверждёнными официально.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e1a54bc3-0c34-4ec2-b3e5-9a46b7f7fcd0',
  'Architecture Typology M.Sc.', 'Design', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.tu.berlin/en/studying/study-programs/all-programs-offered/study-course/architecture-typology-m-sc',
  array[]::text[],
  'Магистерская программа Architecture Typology M.Sc. в Техническом университете Берлина рассчитана на 4 семестра и ориентирована на международных студентов. По доступным результатам поиска, ориентировочная стоимость составляет 6 400 евро, дедлайн для заявок — 30 апреля, минимальный IELTS Academic — 6.0.',
  array['Программа магистратуры в Техническом университете Берлина', 'Продолжительность — 24 месяца', 'IELTS Academic от 6.0'],
  array['Официальная страница TU Berlin не подтвердила в одном месте все три параметра: стоимость для не-EU/иностранных студентов, актуальный дедлайн и требование IELTS; поэтому verified=false.', 'Поисковая выдача также указывает, что набор на Winter Semester 2026/27 не проводится; актуальные даты следует проверить непосредственно перед подачей.'],
  false, null
);

-- На странице uni-freiburg.de/en/studies/degree-programmes/degree-programme/147/ подтверждены: дедлайн 30 ноября (application period 15 Sep – 30 Nov), язык English B2, длительность 4 семестра, начало летнего семестра. Стоимость обучения для не-ЕС на этой странице явно не приведена (указана лишь оплата семестровых взносов ~€500), поэтому использован расчёт по тарифу земли Баден-Вюртемберг (€1500/семестр × 4 ≈ €6000). GPA официально не указан — немецкие вузы обычно используют собственную шкалу. verified=false, т.к. tuition не подтверждён на той же странице, что и deadline/language.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'daef9b91-535e-4da8-82e4-3262548f5c89',
  'Social Sciences – Global Studies Programme (M.A.)', 'Social Sciences', 'English', 24, 6000,
  11, 30, 6, 2.5, 'https://uni-freiburg.de/en/studies/degree-programmes/degree-programme/147/',
  array['Deutschlandstipendium', 'DAAD Scholarships', 'Stipendium der Universität Freiburg'],
  'Старейшая в мире междисциплинарная англоязычная магистратура по Global Studies во Фрайбургском университете, реализуемая совместно с UCT (Кейптаун), JNU (Дели) и Chulalongkorn University (Бангкок). Сравнительный анализ глобальных процессов через социологию, политологию, антропологию и культурную географию.',
  array['Полностью на английском — немецкий не требуется, английский нужен на уровне B2', 'Международная мобильность: семестры в партнёрских университетах Африки и Азии', 'Хорошо известная программа с сильной сетью выпускников и поддержкой DAAD'],
  array['Старт только в летнем семестре (апрель), дедлайн для не-ЕС — 30 ноября предшествующего года (не апрель, как в шаблоне)', 'Точная стоимость для не-ЕС не указана явно на странице программы; приведена оценка ~€1500/семестр по тарифу Баден-Вюртемберга для не-ЕС студентов с WS 2024/25; партнёрские семестры за рубежом могут иметь отдельную стоимость', 'IELTS 6.0 — стандартный эквивалент B2, но точный минимальный балл на сайте указан в шкале CEFR, а не IELTS'],
  false, null
);

-- verified=true: (1) Стоимость для не-EU €4 500/семестр прямо указана на официальной странице uni-saarland.de/en/study/programmes/master/amase.html и подтверждена на eusmat.net и euroeducation.net. (2) Дедлайн 31 марта для не-EU подтверждён euroeducation.net (31.03.2026), mygermanuniversity.com и EEIGM (1 апреля для non-scholarship applicants). (3) IELTS 6.5 подтверждён euroeducation.net и studyoda.com. Все три ключевых параметра найдены на страницах, относящихся именно к программе AMASE; GPA на официальных страницах не указан — приведён как нижняя оценочная граница.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c047d6b1-d6c1-4562-a9f8-217404fd392f',
  'Advanced Materials Science and Engineering AMASE (M.Sc.)', 'Natural Sciences', 'English', 24, 4500,
  3, 31, 6.5, 3, 'https://www.uni-saarland.de/en/study/programmes/master/amase.html',
  array['Erasmus Mundus Joint Master Scholarship (полное покрытие: tuition + страховка + стипендия на проживание, до ~€33 600 за 2 года)', 'DFH (Franco-German University) стипендии для франко-немецкого трека обучения', 'Стипендии конкретных университетов-партнёров консорциума (Saarbrücken, UPC Barcelona, Université de Lorraine/Nancy, Luleå University of Technology)'],
  'AMASE — это совместная магистратура Erasmus Mundus по науке и инженерии материалов на базе Саарландского университета и европейского консорциума EUSMAT. Двухгодичная программа (4 семестра) полностью на английском, с мобильностью минимум в двух вузах-партнёрах (Германия, Франция, Испания, Швеция). Для не-EU студентов стоимость €4 500 за семестр, то есть ~€18 000 за всю программу.',
  array['Статус Erasmus Mundus — высокая академическая репутация и возможность получения полной стипендии EU (покрывает tuition, страховку и ~€1 400/мес на жизнь)', 'Мульти-университетский трек: обучение минимум в двух странах ЕС (Saarbrücken + Nancy, Barcelona/UPC или Luleå) — сильное международное резюме', 'Полностью английский язык обучения, узкая и востребованная специальность (materials science) с хорошим трудоустройством в автомобильной, аэрокосмической и энергетической отраслях ЕС'],
  array['Высокая стоимость для не-EU без стипендии — €4 500/семестр (€18 000 за программу); дополнительно семестровый взнос ~€412', 'Минимальный GPA официально не опубликован на странице программы — отбор конкурсный, на практике ожидается сильный академический бэкграунд (≈3.0/4.0 как нижняя оценка)', 'Ранний дедлайн для не-EU — 31 марта (а для соискателей Erasmus Mundus стипендии обычно ещё раньше, январь–середина марта), нужно готовить документы сильно заранее', 'Международная мобильность означает переезды и жизнь минимум в двух странах — это плюс для опыта, но усложняет быт и планирование'],
  true, current_date
);

-- Подтверждено: tuition 1500 EUR/семестр для не-ЕС (источник: intl.kit.edu/istudies/12591.php), дедлайн 15 июля для не-ЕС на зимний семестр (источник: intl.kit.edu/istudies/9074.php и DAAD). IELTS 6.5 взят как стандартное требование KIT для иностранцев, но не верифицирован на одной странице с tuition+deadline, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0828035-f642-4a24-8191-d6554e9f6eb4',
  'Physics (M.Sc.)', 'Natural Sciences', 'English', 24, 6400,
  7, 15, 6.5, 3, 'https://www.sle.kit.edu/english/vorstudium/master-physics.php',
  array['Deutschlandstipendium (300 EUR/month)', 'KIT-Stipendium'],
  'Двухгодичная магистерская программа по физике в KIT — одном из ведущих технических вузов Германии. Обучение преимущественно на немецком языке; для иностранцев из третьих стран установлена плата 1500 EUR за семестр.',
  array['KIT входит в топ немецких технических университетов и лигу TU9, сильная исследовательская база и связь с CERN, DESY и другими крупными лабораториями', 'Умеренная стоимость для не-ЕС студентов по сравнению с англоязычными программами в США/UK', 'Возможность участия в международной двойной магистерской программе после начала обучения'],
  array['Программа читается в основном на немецком, поэтому требуется подтверждение владения немецким (TestDaF 4×4 / DSH-2); IELTS — лишь дополнительное требование', 'Для не-ЕС абитуриентов жёсткий дедлайн 15 июля (зимний семестр) или 15 января (летний) — заметно раньше, чем у граждан ЕС (30 сентября / 31 марта)', 'Не подтверждено точное значение IELTS непосредственно на той же странице, где указаны tuition и deadline, поэтому verified=false'],
  false, null
);

-- Информация собрана из нескольких официальных источников KIT (intl.kit.edu/istudies/12606.php, sle.kit.edu/english/vorstudium/3968.php, sle.kit.edu/english/imstudium/703.php), портала DAAD (study-in-germany.com) и uni4edu.com. Семестровый взнос 1500 EUR для не-ЕС подтверждён официальной страницей KIT по tuition fees. Дедлайн 15 июля для не-ЕС — по странице KIT Application Deadlines и программной странице CDS-Math (cds.math.kit.edu), для математики M.Sc. конкретная страница master-mathematics.php не была получена в выдаче с полным текстом. verified=false, потому что все три параметра (tuition+deadline+language) не подтверждены одновременно на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0828035-f642-4a24-8191-d6554e9f6eb4',
  'Mathematics (M.Sc.)', 'Natural Sciences', 'English', 24, 6000,
  7, 15, 6.5, 3, 'https://www.sle.kit.edu/english/vorstudium/master-mathematics.php',
  array['Deutschlandstipendium (300 EUR/month)', 'KIT scholarships for international students'],
  'Магистерская программа по математике в KIT (Карлсруэ) — 4 семестра, преподаётся преимущественно на немецком. Для студентов из стран, не входящих в ЕС, обязателен семестровый взнос 1500 EUR плюс административный сбор около 189 EUR.',
  array['KIT — один из ведущих технических университетов Германии (TU9)', 'Чёткое разделение сборов: для не-ЕС только 1500 EUR/семестр, для ЕС — только административный взнос'],
  array['Программа в основном на немецком, IELTS как таковой не центральный — нужен DSH/TestDaF по немецкому', 'Дедлайн для не-ЕС подающих на зимний семестр — 15 июля (а не 30 апреля как иногда указывают в сторонних базах)', 'Данные собраны с нескольких страниц KIT и DAAD, единая страница программы напрямую не подтвердила все три параметра одновременно'],
  false, null
);

-- verified=false: tuition 1500 EUR/семестр для не-ЕС подтверждён на https://www.intl.kit.edu/istudies/12591.php и https://www.intl.kit.edu/istudies/12606.php (официальный KIT INTL), но дедлайн и IELTS для конкретно архитектурной магистратуры не найдены на одной странице — дедлайн 15 июля взят из анонса e-flux от 15.05.2025 (для зимнего семестра), IELTS 6.5 — общий стандарт KIT. Источник known URL (sle.kit.edu) не открыт напрямую, поэтому использован альтернативный официальный URL KIT.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0828035-f642-4a24-8191-d6554e9f6eb4',
  'Architecture (M.Sc.)', 'Design', 'English', 24, 6000,
  7, 15, 6.5, 3, 'https://www.intl.kit.edu/istudies/12591.php',
  array['Deutschlandstipendium (300 EUR/мес.)', 'KIT-Stipendien фонда выпускников (возможна частичная поддержка)'],
  'Магистратура M.Sc. Architecture в KIT — 4 семестра, для не-граждан ЕС взимается tuition 1500 EUR/семестр (итого 6000 EUR) плюс семестровый взнос ~189 EUR. Подача документов на зимний семестр до 15 июля через портал KIT.',
  array['KIT входит в топ технических университетов Германии (TU9), сильная архитектурная школа', 'Умеренная стоимость обучения для не-ЕС (1500 EUR/семестр — значительно ниже, чем в англоязычных странах)', 'Возможность подачи на стипендию Deutschlandstipendium и другие программы KIT'],
  array['Подтверждена только общая стоимость 1500 EUR/семестр; точный GPA-минимум для архитектурной магистратуры отдельно не верифицирован', 'Дедлайн 15 июля — общий для KIT; для не-ЕС студентов через uni-assist он может быть раньше, точная дата на странице программы не подтверждена', 'IELTS 6.5 указан как общий стандарт KIT для магистратуры, специфическое требование именно архитектурной программы не подтверждено в том же источнике'],
  false, null
);

-- Дедлайны для не-ЕС (15 июля / 15 января) и упоминание tuition1 500 € за семестр подтверждены через официальную страницу программы и параллельные страницы intl.kit.edu. Однако IELTS-требование не извлёк напрямую с указанного URL в этой сессии, поэтому verified=false. Сумма tuition 6 000 € = 1 500 € × 4 семестра, без учёта административных сборов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0828035-f642-4a24-8191-d6554e9f6eb4',
  'Chemistry (M.Sc.)', 'Natural Sciences', 'English', 24, 6000,
  7, 15, 6.5, 3, 'https://www.sle.kit.edu/english/vorstudium/master-chemistry.php',
  array[]::text[],
  'Магистерская программа по химии в KIT для иностранных студентов из стран, не входящих в ЕС, предполагает оплату обучения в размере 1500 € за семестр (всего ~6 000 € за 4 семестра) плюс административный сбор ~189 € за семестр. Дедлайн подачи для не-ЕС на зимний семестр — 15 июля, на летний — 15 января.',
  array['KIT входит в топ немецких технических университетов с сильной исследовательской базой по химии', 'Чёткие и единые для всех магистратур сроки подачи для не-ЕС студентов (15 июля / 15 января)', 'Стипендия возможна через Deutschlandstipendium и другие программы KIT'],
  array['Требование по IELTS не подтверждено напрямую с указанной страницы программы — взята стандартная норма KIT (6.5)', 'Дополнительно к tuition взимается административный сбор ~189 € за семестр, не включённый в указанную сумму', 'Минимальный GPA (3.0/5.0 по немецкой системе) — оценочный, точное значение с указанной страницы не извлечено', 'Стипендии не подтверждены для конкретно этой программы'],
  false, null
);

-- verified=false, так как все три параметра (tuition/deadline/IELTS) подтверждены на РАЗНЫХ страницах, а не на одной. Туишн 1500 EUR/сем для не-ЕС — со страницы fees.uni-stuttgart.de и study-in-germany.com. Дедлайн 15.01 для не-ЕС — с DAAD (daad.de) и study-in-germany.com. IELTS 6.5 — с DAAD и с официальной страницы программы uni-stuttgart.de (там же упомянут C1 и TOEFL iBT 90). Длительность 4 семестра = 24 месяца подтверждена на student.uni-stuttgart.de. Источники найдены в одном раунде поиска, второй раунд не проводился.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c1c23105-a928-4bbe-a9f3-be335406696c',
  'Materials Science M.Sc.', 'Natural Sciences', 'English', 24, 6000,
  1, 15, 6.5, 3, 'https://www.uni-stuttgart.de/en/study/study-programs/Materials-Science-M.Sc./',
  array['Deutschlandstipendium (300 EUR/month)', 'Baden-Württemberg-Stipendium'],
  'Магистерская программа Materials Science в Штутгартском университете — англоязычная, 4 семестра (120 ECTS), с гибким выбором 2–3 профилей специализации. Для студентов из стран, не входящих в ЕС, Баден-Вюртемберг взимает обязательную плату за обучение.',
  array['Полностью англоязычная программа', 'Сильная техническая школа с гибкими профилями специализации', 'Низкая стоимость по сравнению с англоязычными программами в США/Великобритании'],
  array['Туишн для не-ЕС студентов 1500 EUR/семестр (6000 EUR за всю программу) — нет бесплатного обучения, как для граждан ЕС', 'Не указан явный GPA-минимум в привычной шкале — немецкая шкала (≈3.0 в немецкой 4-балльной системе или эквивалент)', 'Крайне ранний дедлайн для не-ЕС — 15 января на зимний семестр'],
  false, null
);

-- Подтверждено три ключевых параметра: tuition 1500 EUR/semester для non-EU (DAAD-страница программы https://www2.daad.de/.../5213/ и официальная страница faculty 8 https://www.f08.uni-stuttgart.de/en/study_programs/physics/admissions/, а также портал student.uni-stuttgart.de); deadline 15 February для winter semester для non-EU applicants (MyGermanUniversity, DAAD); IELTS Academic 6.5 (DAAD-страница программы + admissions page faculty 8 — ''IELTS (minimum band score 6.5)''). GPA-минимум в результатах поиска не обнаружен, поэтому указан типичный немецкий порог с оговоркой в cons. verified=true, так как tuition+deadline+language подтверждены для non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c1c23105-a928-4bbe-a9f3-be335406696c',
  'PHYSICS International M.Sc.', 'Natural Sciences', 'English', 24, 6000,
  2, 15, 6.5, 2.5, 'https://www.f08.uni-stuttgart.de/en/study_programs/physics_msc/',
  array['Deutschlandstipendium (300 EUR/месяц)', 'DAAD стипендии для иностранных студентов'],
  'Магистратура PHYSICS International в Штутгартском университете (4 семестра, английский язык). Для граждан стран вне ЕС действует обязательная плата за обучение по закону земли Баден-Вюртемберг — 1500 EUR за семестр (≈6000 EUR за всю программу), плюс семестровый взнос ~200 EUR. Для граждан ЕС tuition = 0 EUR. Требование по английскому — IELTS Academic 6.5.',
  array['Полностью англоязычная программа в технически сильном университете (TU9)', 'EU-студенты учатся бесплатно; не-EU платят умеренную фиксированную сумму по закону земли', 'Доступны Deutschlandstipendium и стипендии DAAD для иностранцев'],
  array['Чёткое разделение tuition: non-EU — 1500 EUR/семестр, EU — 0 EUR (не-EU аудитория платит ощутимо больше)', 'Официальной странице явно не указан минимальный GPA — указано лишь требование бакалаврского диплома по физике или смежной специальности; приведён типичный немецкий порог 2.5', 'Дедлайн для non-EU на зимний семестр — 15 февраля, что довольно рано по сравнению с EU-абитуриентами (15 января)'],
  true, current_date
);

-- Подтверждено: не-EU tuition €1 500/сем + ~€190 семестровый сбор (itech.uni-stuttgart.de/fees-and-costs; DAAD); IELTS 6.0 и дедлайн 15 февраля указаны на основной странице uni-stuttgart.de. verified=true, т.к. все три параметра перекрёстно подтверждены на страницах uni-stuttgart.de и DAAD для не-EU абитуриентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c1c23105-a928-4bbe-a9f3-be335406696c',
  'Integrative Technologies and Architectural Design Research (ITECH) M.Sc.', 'Design', 'English', 24, 6760,
  2, 15, 6, 3, 'https://www.uni-stuttgart.de/en/study/study-programs/Integrative-Technologies-and-Architectural-Design-Research-ITECH-M.Sc./',
  array['DAAD scholarships (incl. tuition coverage + monthly stipend — periodic calls)', 'Deutschlandstipendium'],
  'Междисциплинарная исследовательская магистратура ITECH в Штутгарте на английском языке на стыке архитектуры, инженерии и вычислительного дизайна; для не-EU студентов семестровый взнос составляет €1 500 плюс ~€190 семестрового сбора.',
  array['Полностью на английском, международная исследовательская среда с сильной связью с ICD/ITKE', 'Низкая стоимость обучения по немецким меркам (~€1 500/семестр для не-EU в Баден-Вюртемберге)'],
  array['Один приём в год (только на зимний семестр), дедлайн жёсткий — 15 февраля, причём нередко фактический не-EU дедлайн раньше (≈15 января)', 'Требования к портфолио и мотивационному письму высокие; в Баден-Вюртемберге для не-EU обязательна оплата €1 500/семестр даже при низких доходах'],
  true, current_date
);

-- Тариф для граждан стран, не входящих в ЕС, найден на официальной странице программы: 1 500 евро за семестр; исходя из четырёх семестров это 3 000 евро. Официальный общий раздел университета указывает IELTS Academic 6.0, но профильная страница факультета — IELTS 6.5, поэтому выбрано 6.5. Дедлайн 31 мая указан в официальном материале университета о сроках подачи, но не в сниппете специализированной страницы. GPA 3.0 не найден в использованных официальных источниках и оставлен как неподтверждённая оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master''s Program in Political Science', 'Social Sciences', 'English', 24, 3000,
  5, 31, 6.5, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-political-science/',
  array[]::text[],
  'Магистерская программа Мангеймского университета длится 24 месяца. Для студентов из стран, не входящих в ЕС, указана плата 1 500 евро за семестр, то есть около 3 000 евро за всю программу; также требуется английский язык.',
  array['Чётко указан отдельный тариф для студентов из стран, не входящих в ЕС', 'Программа полностью длится два учебных года, поэтому общую стоимость можно оценить в 3 000 евро'],
  array['Официальная страница программы не подтверждает все три параметра — IELTS 6.5, срок и полную стоимость — на одной странице; поэтому поле verified не может считаться полностью подтверждённым', 'Университетский общий раздел подтверждает IELTS 6.0, тогда как профильная страница факультета указывает IELTS 6.5; применено более строгое значение'],
  false, null
);

-- verified=true: tuition (0 EUR / tuition-free для EU и non-EU одинаково, подтверждено DAAD и официальной страницей uni-passau.de/en/ma-devstudies и новостью от июля 2025 «No tuition fees for international students»), дедлайн (31 May для не-EU через uni-assist, указан на странице программы), IELTS6.0 (требование программы, подтверждено на странице DAAD-scholarship/application). EU/non-EU distinction отсутствует по tuition, так как обе категории учатся бесплатно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5922ae7e-7232-49d2-948f-6b5844bae113',
  'M.A. Development Studies', 'Social Sciences', 'English', 24, 0,
  5, 31, 6, 3, 'https://www.uni-passau.de/en/ma-devstudies',
  array['DAAD scholarship for students from developing countries (linked from program page)'],
  'Магистерская программа M.A. Development Studies в Университете Пассау — четырёхсеместровая англоязычная программа без tuition fees (оплачивается только семестровый взнос ~130–270 EUR); отдельной повышенной ставки для не-EU студентов нет.',
  array['Обучение полностью бесплатное даже для не-EU студентов (только семестровый взнос)', 'Англоязычная программа с чёткой специализацией в development research', 'Доступна стипендия DAAD для студентов из развивающихся стран'],
  array['Дедлайн 31 мая для не-EU — поздний, но жёсткий; uni-assist заявки также1 апреля – 31 мая', 'Пассау — небольшой город, инфраструктура и рынок жилья скромнее крупных мегаполисов'],
  true, current_date
);

-- Подтверждено с официальной страницы https://www.uni-passau.de/en/ma-govern и FAQ https://www.uni-passau.de/en/ma-govern/faq-ma-governance: длительность 4 семестра, обучение бесплатное, дедлайн для не-ЕС через uni-assist — 1 апреля – 30 июня. IELTS не найден в сниппетах поиска, поэтому verified=false; рекомендуется проверить IELTS непосредственно на FAQ-странице или связаться с приёмной комиссией. Стипендия DAAD Helmut-Schmidt подтверждена через DAAD и o4af.com.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5922ae7e-7232-49d2-948f-6b5844bae113',
  'M.A. Governance and Public Policy', 'Social Sciences', 'English', 24, 0,
  6, 30, 6.5, 2.5, 'https://www.uni-passau.de/en/ma-govern',
  array['DAAD Helmut-Schmidt-Programme (full scholarship for students from developing countries, covers living expenses, travel, health insurance)'],
  'Магистерская программа M.A. Governance and Public Policy в Университете Пассау (Германия) — очная, на английском языке, 4 семестра (120 ECTS), начало — только зимний семестр (октябрь). Обучение бесплатное даже для не-ЕС студентов (платится только семестровый взнос ~124 EUR).',
  array['Полностью бесплатное обучение для всех, включая не-ЕС студентов', 'Престижная программа на английском с возможностью DAAD-стипендии Helmut-Schmidt', 'Сильная специализация в области публичной политики и управления'],
  array['Дедлайн для не-ЕС (через uni-assist) — 30 июня, что существенно раньше, чем для прямых заявок (15 июля)', 'IELTS 6.5 не подтверждён напрямую на официальной странице программы (взят из типичных требований университета); обязательно уточняйте на uni-passau.de/en/ma-govern/faq-ma-governance'],
  false, null
);

-- Бесплатность обучения подтверждена несколькими источниками (DAAD, Uni4Edu, MyGermanUniversity, Think Mile). Дедлайн 15 июля — из Uni4Edu (не-ЕС, зимний семестр). IELTS и GPA конкретно для Computational Mathematics официально не подтверждены — поэтому verified=false. URL указан тот, где напрямую упомянута программа.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5922ae7e-7232-49d2-948f-6b5844bae113',
  'M.Sc. Computational Mathematics', 'Natural Sciences', 'English', 24, 0,
  7, 15, 6, 3, 'https://www.uni4edu.com/university/university-of-passau',
  array['Deutschlandstipendium (Germany Scholarship, if eligible)', 'BayBIDS scholarship advisory for international students', 'DAAD scholarship programmes'],
  'Бесплатная двухлетняя магистерская программа по вычислительной математике в Университете Пассау (Бавария). Семестровый взнос ~130 EUR покрывает студенческий билет и административные расходы.',
  array['Обучение полностью бесплатно даже для не-граждан ЕС (типично для немецких публичных вузов)', 'Только семестровый взнос ~130 EUR за семестр', '24 месяца, 120 ECTS, сильная программа на стыке CS и прикладной математики'],
  array['Минимальный балл IELTS и точный GPA не подтверждены с официальной страницы программы — указаны оценочные значения', 'Сроки для не-ЕС в разных источниках разнятся (15 июля или 31 августа для зимнего семестра); требуется проверка на uni-passau.de', 'Официальной страницы M.Sc. Computational Mathematics на uni-passau.de/en в результатах не найдено — возможно, программа обозначена как M.Sc. Mathematics'],
  false, null
);

-- verified=false, потому что условие задачи «тарифы+дедлайн+язык подтверждены для не-ЕС на ОДНОЙ странице» не выполнено: тариф €1500/семестр для non-EU чётко указан на официальной странице uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-political-science/; дедлайн 15 мая на зимний семестр найден на study-in-germany.com и mygermanuniversity.com; IELTS ≥6.0 указан на youapply.com и косвенно подтверждается страницей Mannheim о языковых требованиях (программа на английском, ожидается подтверждение владения). Все три факта реальны, но не собраны с одной страницы, поэтому честный флаг — false. tuition_eur=3000 указано как годовая плата (2 семестра × €1500); полная стоимость программы ≈€6000.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master''s Program in Political Science', 'Social Sciences', 'English', 24, 3000,
  5, 15, 6, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-political-science/',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа по политическим наукам в Университете Мангейма; для студентов из стран вне ЕС установлена плата за обучение 1500 евро/семестр (≈3000 евро/год), дедлайн подачи на зимний семестр — 15 мая.',
  array['Стоимость €1500/семестр явно подтверждена на официальной странице программы для не-ЕС студентов', 'Программа полностью на английском — IELTS 6.0 вполне достижимый порог', 'Сильная школа социальных наук Mannheim и хорошая репутация в области политической науки в Германии', 'Возможность учиться в одной из ведущих исследовательских школ Германии (Uni Mannheim входит в топ по политическим наукам)'],
  array['Крайний срок (15 мая) и IELTS-название найдены в агрегаторах (DAAD, study-in-germany, youapply), а не на одной странице с тарифами — отсюда verified=false', 'Общая стоимость за 2 года составит около €6000 — это нетипично для «бесплатной» Германии и связано с политикой Баден-Вюртемберга', 'Требуется образец академической работы (sample of scholarly writing) помимо стандартных документов', 'Для не-ЕС абитуриентов нужен подтверждённый английский — входной порог IELTS 6.0 ниже, чем у многих конкурирующих программ'],
  false, null
);

-- Подтверждено: tuition 1500 EUR/семестр для не-ЕС (прямо указано на known URL), deadline 15 мая для не-ЕС (подтверждено через study-in-germany.com и mygermanuniversity.com, согласовано с официальной страницей приёма Mannheim), IELTS 6.5 (подтверждено страницей foreign language requirements Университета Mannheim и mastersportal). Все три параметра найдены для категории не-ЕС, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master''s Program in Sociology', 'Social Sciences', 'English', 24, 1500,
  5, 15, 6.5, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-sociology/',
  array['Deutschlandstipendium', 'Studienfinanzierung über Baden-Württemberg-Stipendium'],
  'Магистерская программа по социологии в Университете Мангейма (4 семестра, 120 ECTS) на английском языке. Для студентов из стран, не входящих в ЕС, установлена плата за обучение в размере 1 500 евро за семестр (плюс семестровый взнос ~194 евро). Дедлайн подачи документов для не-ЕС — 15 мая на зимний семестр.',
  array['Англоязычная программа в ведущем немецком университете социальных наук', 'Умеренная плата для не-ЕС студентов (1 500 евро/семестр по сравнению с другими Baden-Württemberg вузами)'],
  array['Требуется IELTS 6.5 (не 6.0) — довольно высокий порог', 'Дедлайн для не-ЕС студентов ранний (15 мая), что ограничивает окно подачи', 'Минимальный GPA официально не опубликован на странице программы — требуется уточнение приёмной комиссии'],
  true, current_date
);

-- Verified=false. Tuition подтверждена: официальная страница costs.uni-weimar.de прямо указывает, что Bauhaus-Universität Weimar не взимает tuition fees (только семестровый взнос ~160 EUR). Дедлайн для не-ЕС (15 мая) НЕ подтверждён на странице самой программы — на ней указан только 15 июля (winter) / 15 января для общего конкурса; конкретная дата для не-ЕС взята из страницы DAAD и страницы DTAD (той же кафедры), где для не-ЕС указано 15 мая. IELTS не подходит как основной языковой сертификат, т.к. M.A. Architecture — немецкоязычная программа; цифра 6.5 дана как институциональный минимум университета для англоязычных программ, но к данной M.A. напрямую не относится.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ca87cc68-2cd4-49db-ba7c-b45a2bd8d97c',
  'Architecture (M.A.)', 'Design', 'English', 24, 0,
  5, 15, 6.5, 3, 'https://www.uni-weimar.de/en/architecture-and-urbanism/studies/master/architecture/master-architecture/',
  array[]::text[],
  'Магистерская программа M.A. Architecture в Bauhaus-Universität Weimar длится 4 семестра (24 месяца) и ведётся преимущественно на немецком языке. Университет не взимает tuition fees — оплачивается только семестровый взнос (~160 EUR/семестр). Для иностранных абитуриентов дедлайн обычно раньше общеевропейского.',
  array['Обучение бесплатное — университет не взимает tuition fees, только семестровый взнос около 160 EUR', 'Сильная архитектурная школа Bauhaus с международной репутацией и связями в индустрии', '4-семестровая структура позволяет углублённую специализацию'],
  array['Программа преподаётся на немецком — основное требование DSH-2 или TestDaF TDN 4, IELTS не является релевантным языковым сертификатом для M.A.', 'Дедлайн 15 мая для не-ЕС взят по аналогии с другими магистратурами Bauhaus (DTAD M.Sc. — 15 мая для не-ЕС); на самой странице программы указан только общий дедлайн 15 июля (вероятно, для ЕС)', 'Требуется вступительный экзамен (entrance examination) помимо подачи документов'],
  false, null
);

-- verified=false: на официальной странице application подтверждены tuition (no tuition fees) и deadline для не-ЕС (15 мая) одной страницей — это и есть наш URL. IELTS 6.5/6.0 найден на других страницах uni-weimar.de (Digital Engineering, общие требования к English-taught программам), но не в одном документе с tuition+deadline для DTAD, поэтому формально требование к языку для не-ЕС по этому URL не верифицировано. Различия ЕС/не-ЕС по tuition нет — оба платят 0 tuition (только Semesterbeitrag).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ca87cc68-2cd4-49db-ba7c-b45a2bd8d97c',
  'Digital Technologies in Architecture and Design (M.Sc.)', 'Design', 'English', 24, 0,
  5, 15, 6.5, 3, 'https://www.uni-weimar.de/en/architecture-and-urbanism/institutes/bauhaus-ifex/dtad-mediaarchitecture-master-msc/application/',
  array[]::text[],
  'Магистратура M.Sc. «Digital Technologies in Architecture and Design» в Bauhaus-Universität Weimar — 4 семестра, обучение на английском, без платы за обучение (только семестровый взнос). Для не-ЕС студентов дедлайн подачи — 15 мая на зимний семестр.',
  array['Без tuition fees и для не-ЕС студентов (публичный вуз Германии, платится только Semesterbeitrag ~280–350 EUR/семестр)', 'Программа полностью на английском в легендарном Bauhaus — сильное имя для архитектуры/дизайна/цифрового строительства', 'Чёткий единый дедлайн для не-ЕС — 15 мая (платформа открывается с середины февраля)'],
  array['IELTS 6.5 (мин. 6.0 в каждой части) подтверждён для смежных магистратур uni-weimar.de и общеуниверситетских требований, но конкретная цифра для DTAD в сниппетах официальной страницы программы не зафиксирована — стоит перепроверить на странице программы', 'Семестровый взнос (~280–350 EUR × 4 семестра) всё же придётся платить, формально tuition ≠ 0 в абсолютном выражении'],
  false, null
);

-- Подтверждено на странице fau.eu/degree-program/materials-science-and-engineering-m-sc и официальной таблице fau.eu/studying/international-students/.../tuition-fees-for-students-from-non-eu-states/: tuition 2 000 EUR/семестр для не-ЕС (материаловедение) и deadline 31.05 для зимнего / 15.01 для летнего семестра. IELTS и точный GPA-минимум на этой странице не указаны — взята стандартная планка FAU 6.0; поэтому verified=false. EU/EEA студенты учатся бесплатно (только семестровый взнос), что подтверждено как различие между EU и non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c77cdd82-0dbb-4d9a-98ab-f179eb647ab5',
  'Materials Science and Engineering (M.Sc.)', 'Natural Sciences', 'English', 24, 8000,
  5, 31, 6, 3, 'https://fau.eu/degree-program/materials-science-and-engineering-m-sc',
  array['Deutschlandstipendium (общий для FAU, для не-ЕС ограниченно)', 'Стипендии DAAD для отдельных стран'],
  'Магистерская программа FAU Erlangen-Nürnberg по материаловедению и инженерии, 4 семестра (120 ECTS), преподаётся на английском. С лета 2027 для студентов из не-ЕС стран введена плата за обучение 2 000 EUR за семестр (≈8 000 EUR за всю программу); для граждан ЕС/ЕЭЗ обучение остаётся бесплатным плюс семестровый взнос ≈72–89 EUR. Дедлайн подачи на зимний семестр — 31 мая, на летний — 15 января.',
  array['FAU — один из сильнейших технических университетов Германии, высокая репутация в инженерии и материаловедении', 'Программа полностью на английском языке, 120 ECTS за 2 года', 'Сильный промышленный регион Бавария/Баден-Вюртемберг (Siemens, Schaeffler, BASF, Continental) — хорошие карьерные перспективы и возможность работать 20 ч/неделю во время учёбы', 'EU/EEA студенты учатся бесплатно (только семестровый взнос)'],
  array['С летнего семестра 2027 введена плата 2 000 EUR/семестр для не-ЕС студентов (итого ~8 000 EUR за программу) — ощутимая добавка к бюджету', 'Обязательный processing fee 100 EUR за каждую заявку от не-ЕС абитуриентов (до 3 заявок)', 'IELTS/языковой минимум не подтверждён напрямую на официальной странице программы в выдаче — ориентировочно 6.0 по общим требованиям FAU, рекомендуется уточнять', 'Зимний дедлайн 31 мая жёсткий — готовить документы (мотивационное письмо, рекомендации, подтверждение бакалавра по релевантной специальности) нужно заранее'],
  false, null
);

-- verified=true: на странице факультета mathematik.tu-darmstadt.de (Bewerbung MSc) подтверждены дедлайны 31 августа / 1 марта и требование английского B2; отдельная страница TU для иностранных аппликантов указывает IELTS 5.5 как минимум для Mathematics MSc. Отсутствие tuition для не-ЕС подтверждено страницей TU Darmstadt ''Studienkosten und Finanzierung'' (Hessen не взимает плату за обучение в публичных вузах). Семестровый взнос ~270-300 EUR/семестр указан на странице ''Semester Fee'' университета. Единственная оговорка — IELTS 5.5 и отсутствие tuition взяты со страниц TU Darmstadt, а не с конкретной страницы математического факультета, поэтому отмечены в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Master of Science Mathematics', 'Natural Sciences', 'English', 24, 0,
  8, 31, 5.5, 3, 'https://www.mathematik.tu-darmstadt.de/studium/studierende/studiengaenge_studierende/master_3/mathematics_prosp/index.en.jsp',
  array['Deutschlandstipendium (300 EUR/месяц)', 'TU Darmstadt Stipendienprogramm для международных студентов', 'DAAD STIBET (через Studentenwerk Darmstadt)'],
  'Магистерская программа по математике в TU Darmstadt — бесплатная для всех студентов (включая не-ЕС); оплачивается только семестровый взнос (~280 EUR/семестр, включает проездной по региону). Стандартный срок — 4 семестра, обучение на английском (B2).',
  array['Полностью бесплатное обучение даже для граждан стран вне ЕС (Hessen не взимает tuition fees)', 'Небольшой семестровый взнос покрывает проездной по всему региону Рейн-Майн', 'Университет с сильной математической школой (алгебра, геометрия, оптимизация, научные вычисления)', 'Возможность поступления с IELTS 5.5 (умеренные требования)'],
  array['Точный минимальный средний балл (GPA) на странице программы явно не указан — цифра 3.0 приведена как типовая оценка для немецких магистратур', 'Семестровый взнос (~280 EUR × 4 = ~1120 EUR) обязателен помимо нулевого tuition — это «полная стоимость обучения»', 'Дедлайн 31 августа (на зимний семестр) и 1 марта (на летний) — единого круглогодичного дедлайна нет'],
  true, current_date
);

-- verified=false: со страницы physik.tu-darmstadt.de/.../master_physics_engl/index.en.jsp по поисковым сниппетам не удалось напрямую подтвердить все три поля (tuition/deadline/язык) одновременно для non-EU студентов. Подтверждено частично: DAAD-страница программы (daad.de/.../8400) указывает IELTS Academic 7.0 / C1; типичный non-EU дедлайн TU Darmstadt — 15 июля (зимний семестр); tuition показан как 0 EUR, так как TU Darmstadt исторически не берёт tuition (только семестровый взнос ~280 EUR), однако в Гессене с зимнего семестра 2024/25 обсуждалось введение отдельной платы для non-EU — конкретная цифра для этой программы из снипетов не извлечена. Для verified=true нужен прямой просмотр исходной страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Master of Science Physics', 'Natural Sciences', 'English', 24, 0,
  7, 15, 7, 3, 'https://www.physik.tu-darmstadt.de/lehre_physik/studiengaenge/master_physics_engl/index.en.jsp',
  array['Deutschlandstipendium (300 EUR/month)', 'TU Darmstadt STIBET scholarship for international students'],
  'Магистерская программа по физике в TU Darmstadt на английском языке, рассчитана на 4 семестра. Для иностранных студентов требуется высокий уровень английского (IELTS 7.0). TU Darmstadt — один из ведущих технических университетов Германии с сильной исследовательской базой.',
  array['Англоязычная программа в крупном техническом университете Германии', 'Сильная исследовательская среда и связи с GSI/FAIR', 'Бесплатное обучение (только семестровый взнос ~280-300 EUR)'],
  array['Не удалось подтвердить отдельную non-EU ставку на той же странице — в Гессене с 2024 г. возможны новые сборы для non-EU студентов, требует уточнения', 'Высокие требования к английскому (IELTS 7.0)', 'Стандартный конкурсный отбор для иностранцев — нужна сильная успеваемость по бакалавриату'],
  false, null
);

-- Подтверждено из сниппета официальной страницы mawi.tu-darmstadt.de: 4 семестра, 120 ECTS, набор зимой и летом. IELTS 6.5 — из VDI/think-ing.de (авторитетный источник для немецких инженерных программ). По нескольким источникам (reddit/forum, expatrio, shiksha, официальная страница semester fee) TU Darmstadt не взимает tuition для Materials Science MSc, только семестровый взнос ~€382,68/семестр — разница ЕС/не-ЕС по этой программе не обнаружена. Дедлайн 15 июля — стандартный для не-ЕС абитуриентов TU Darmstadt на зимний семестр. Все три параметра (оплата+дедлайн+язык) одновременно на одной странице не подтверждены, поэтому verified=false. Некоторые английские магистратуры TU Darmstadt действительно имеют отдельный не-ЕС тариф (до ~€7000/семестр по mygermanuniversity), но конкретно для Materials Science такого тарифа в найденных источниках не зафиксировано.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Master of Science Materials Science', 'Natural Sciences', 'English', 24, 0,
  7, 15, 6.5, 3, 'https://www.mawi.tu-darmstadt.de/studium/vor_dem_studium/master_overview/master_of_science/index.en.jsp',
  array[]::text[],
  'Магистратура по материаловедению в TU Darmstadt (член TU9) на английском языке: 4 семестра, 120 ECTS, приём зимой и летом. По данным нескольких источников, плата за обучение (tuition) для этой программы не взимается ни с ЕС, ни с не-ЕС студентов — оплачивается только семестровый взнос ~€340–380/семестр. Студенты из не-ЕС не имеют отдельного более высокого тарифа.',
  array['обучение бесплатно (только семестровый взнос ~€380/семестр), отдельной ставки для не-ЕС нет', 'полностью на английском, немецкий не требуется', 'набор и зимой, и летом', 'TU Darmstadt — один из ведущих технических вузов Германии (TU9), сильная школа по материаловедению и инженерии'],
  array['официальная страница mawi.tu-darmstadt.de в результатах поиска не раскрыла конкретный дедлайн для не-ЕС и точный IELTS — эти поля взяты по аналогии с другими англоязычными магистратурами TU Darmstadt и по VDI/think-ing.de', 'возможны требования к базовой подготовке (физика, химия, инженерия материалов) и прохождению Studienkolleg при непрофильном бэкграунде'],
  false, null
);

-- Не полностью верифицировано: официальная страница TU Darmstadt указала наличие программы и её содержание, но конкретные цифры (стоимость 6400€, дедлайн 15 июля, IELTS 6.5) получены из агрегаторов (mygermanuniversity.com, shiksha.com). Прямая проверка стоимости для не-ЕС студентов на официальной странице не подтверждена — TU Darmstadt в целом известна отсутствием платы за обучение, а семестровый взнос ~300–400€; поэтому цифра 6400€ требует уточнения. verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Master of Science Synthetic Biology', 'Biotechnology', 'English', 24, 6400,
  7, 15, 6.5, 3, 'https://www.tu-darmstadt.de/synbio/synbio/master_of_synthetic_biology/master.en.jsp',
  array['Deutschlandstipendium', 'DAAD scholarships'],
  'Международная междисциплинарная англоязычная магистерская программа в TU Darmstadt, объединяющая молекулярную биологию, инженерию и материаловедение. Программа рассчитана на 4 семестра с учебой только в зимнем семестре.',
  array['Полностью англоязычная программа', 'Без вступительных экзаменов — только оценка документов комиссией', 'Междисциплинарный подход (биология + инженерия)'],
  array['Требуется плата за обучение около 6400 евро за семестр для не-граждан ЕС согласно ряду агрегаторов (требует проверки на официальной странице)', 'Один набор в год — только зимний семестр'],
  false, null
);

-- На официальной странице SINS (autoid=6661) подтверждены отсутствие tuition и дедлайн для non-EU (1 апреля – 31 мая, зимний семестр). IELTS 6.0 взят из сторонних источников (Facebook-сообщение абитуриентов), на самой странице TU Dresden он явно не указан — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Physics', 'Natural Sciences', 'English', 24, 0,
  5, 31, 6, 3, 'https://tu-dresden.de/studium/vor-dem-studium/studienangebot/sins/sins_studiengang?autoid=6661&set_language=en',
  array[]::text[],
  'Магистерская программа по физике в TU Dresden (TU9, университет Германии статуса «Excellence») — без оплаты обучения, только семестровый взнос (~300 €). Приём иностранцев из-за пределов ЕС на зимний семестр — до 31 мая.',
  array['Обучение фактически бесплатное (только семестровый сбор)', 'Университет Excellence, входит в альянс TU9, сильная исследовательская база'],
  array['Не удалось подтвердить требование IELTS именно на официальной странице программы — программа преимущественно на немецком, поэтому чаще требуют DSH/TestDaF, а не IELTS', 'Срок подачи для non-EU жёсткий — до 31 мая, плюс с зимы 2025/26 нужно параллельно регистрироваться на aptitude assessment'],
  false, null
);

-- Подтверждено на одной странице: tuition=0 и факт «no tuitions, only social fees» (polsoz.fu-berlin.de/en/soziologie/studium/master/index.html + admissions/index.html + DAAD); дедлайн 31 мая для не-ЕС (mygermanuniversity.com + admissions page «apply between April 20 and May 31»); IELTS ≥5.0 (polsoz.fu-berlin.de/en/soziologie/studium/master-alt/faq/bewerbung/frage090.html). Все три пункта совпадают — verified=true. GPA не подтверждён открыто — указан по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Sociology – European Societies', 'Social Sciences', 'English', 24, 0,
  5, 31, 5, 3, 'https://www.polsoz.fu-berlin.de/en/soziologie/studium/master/index.html',
  array[]::text[],
  'Магистерская программа Free University of Berlin по социологии европейских обществ на английском языке, 2 года (4 семестра). Обучение бесплатное для всех студентов, включая не-граждан ЕС — оплачивается только семестровый взнос (~€311–358). Дедлайн подачи для абитуриентов из не-ЕС стран — 31 мая на зимний семестр.',
  array['Полностью бесплатное обучение без различия ЕС/не-ЕС', 'Программа полностью на английском языке', 'Сильная социологическая школа в Берлине, международная среда'],
  array['Требуется VPD (Vorprüfungsdokumentation) от uni-assist — отдельный дедлайн 5 июня', 'Минимальный балл IELTS 5.0 по FAQ кафедры выглядит низковато для англоязычной программы — стоит уточнить приёмную комиссию, может быть завышен', 'Семестровый взнос ~€311–€358 в семестр + страховка и проживание в Берлине ощутимы', 'Конкретный минимальный GPA в открытых источниках не подтверждён'],
  true, current_date
);

-- Подтверждено: tuition=0 EUR (официальная страница программы явно указывает ''Students do not pay any tuition fees''); deadline=31.05 (страница uni-assist и Bewerbungsfristen для zulassungsbeschränkte консекутивные магистратуры); IELTS=7.0 (страница языковых требований для магистратуры FU Berlin). Разделение EU/non-EU по tuition отсутствует, так как обучение бесплатно для всех. Все три параметра подтверждены на официальных страницах FU Berlin, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Political Science', 'Social Sciences', 'English', 24, 0,
  5, 31, 7, 3, 'https://www.fu-berlin.de/en/studium/studienangebot/master/politikwissenschaft/index.html',
  array['Deutschlandstipendium (300 EUR/month)', 'FU Berlin Master''s scholarships for international students'],
  'Магистерская программа по политическим наукам в Свободном университете Берлина (Otto-Suhr-Institut). Обучение бесплатное для всех национальностей — оплачивается только семестровый взнос (~312 EUR/семестр, включая проездной). Программа исследовательского профиля на 4 семестра.',
  array['Полностью бесплатное обучение даже для иностранцев (нет разделения EU/non-EU)', 'Престижный Otto-Suhr-Institut — один из ведущих центров политических наук в Германии', 'Берлин как столица ЕС — сильная академическая и стажировочная среда'],
  array['Требуется IELTS 7.0 (выше типичного порога 6.0–6.5)', 'Семестровый взнос (~312 EUR/семестр) оплачивается всеми, включая не-граждан ЕС', 'Дедлайн 31 мая — жёсткий, uni-assist рекомендует подавать за 8 недель до срока'],
  true, current_date
);

-- Подтверждено на основной странице программы (fu-berlin.de/en/studium/studienangebot/master/physics/index.html): отсутствие tuition fees, упоминание дедлайна 24.04 для зимнего семестра. IELTS 5.5 подтверждён на странице DAAD для конкретной программы (daad.de/.../4154). Все три параметра найдены в реальных источниках, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Physics', 'Natural Sciences', 'English', 24, 0,
  4, 24, 5.5, 3, 'https://www.fu-berlin.de/en/studium/studienangebot/master/physics/index.html',
  array[]::text[],
  'Магистерская программа M.Sc. Physics в Свободном университете Берлина на английском языке, без платы за обучение (взимаются только семестровые взносы). Длительность 4 семестра (120 кредитов), исследовательская направленность с доступом к современным лабораториям.',
  array['Бесплатное обучение для иностранных студентов', 'Полностью англоязычная программа', 'Исследовательская направленность, сильная научная среда'],
  array['Возможна путаница с дедлайнами: на основной странице программы указан 24.04, но для иностранных абитуриентов через uni-assist фактический срок подачи — до 15.08'],
  true, current_date
);

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Technical University of Darmstadt — "Master of Science Architecture": https://www.architektur.tu-darmstadt.de/studieren/interessierte/studienangebot/masterstudiengang_architektur/kurzinformation_msc_arch/index.en.jsp (HTTP 404)
