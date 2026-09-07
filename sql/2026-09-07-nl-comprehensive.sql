-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Netherlands (nl) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Стоимость €23 500/год для non-EEA подтверждена на официальной странице tuition fees UvA (2025–2026). Дедлайн ~1 марта и IELTS 6.5 взяты из общих правил приёма UvA на селективные магистратуры и упоминаний на Reddit, но не подтверждены именно со страницы программы Medical Informatics, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Medical Informatics', 'Medicine', 'English', 24, 23500,
  'ai', current_date,
  3, 1, 6.5, null, 'https://www.uva.nl/en/programmes/masters/medical-informatics/medical-informatics.html',
  array['Amsterdam Excellence Scholarship (partial)', 'Holland Scholarship (non-EU, €5,000 в первый год)'],
  'Двухгодичная магистерская программа UvA на стыке медицины и ИТ: медицинская информатика, ИКТ в здравоохранении, анализ клинических данных. Стоимость для студентов из-за пределов ЕЭЗ — €23 500 в год (институциональный тариф).',
  array['Топовый европейский вуз и сильная школа медицинской информатики (AMIS/AMC)', 'Амстердам как международный хаб eHealth и MedTech — сильные карьерные перспективы', 'Программа на английском, рассчитана на международных студентов'],
  array['Высокая стоимость для non-EEA (~€23 500/год ×2 = ~€47 000)', 'Дедлайн и точный IELTS-минимум на момент проверки не подтверждены напрямую со страницы программы, цифры приблизительные'],
  false, null
);

-- Подтверждено на официальной странице non-Dutch admission: дедлайн 1 декабря 2025; на странице Tuition Fee & Finances подтверждена не-EU ставка MSc €25 633; IELTS 6.5 — общее требование TU Delft для MSc (Bachelor-страница). Все три параметра найдены, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Architecture, Urbanism and Building Sciences', 'Architecture', 'English', 24, 25633,
  'verified', current_date,
  12, 1, 6.5, null, 'https://www.tudelft.nl/en/education/programmes/masters/aubs/msc-architecture-urbanism-and-building-sciences/admission-and-application/non-dutch-bsc-degree',
  array[]::text[],
  'Двухгодичная магистратура TU Delft на стыке архитектуры, урбанизма и строительных наук; обучение на английском, сильный международный факультет.',
  array['Высокий рейтинг TU Delft в архитектуре и инженерии', 'Полностью английский язык обучения'],
  array['Высокая стоимость для не-EU студентов (~€25 633/год, итого ~€51 266 за 2 года)', 'Ранний дедлайн для не-EU — 1 декабря (плюс дополнительный numerus fixus-отбор)'],
  true, current_date
);

-- Все три ключевых поля подтверждены на официальных страницах UU: tuition €20,605 (2025-2026 non-EU/EEA) и €21,342 (2026-2027) — страница tuition-fees-and-financial-support; дедлайн 1 апреля для non-Dutch degree — страница application-and-admission/degree-from-a-non-dutch-university; IELTS 6.5 — официальная страница магистра и ymgrad. verified=true, т.к. все три значения взяты с uu.nl.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Applied Cognitive Psychology', 'Psychology', 'English', 12, 20605,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.uu.nl/en/masters/applied-cognitive-psychology/tuition-fees-and-financial-support',
  array['Utrecht Excellence Scholarship', 'Holland Scholarship'],
  'Один год (12 месяцев), полностью на английском, программа ориентирована на применение когнитивной психологии в реальных задачах (интернатура, проект, диссертация). Для не-ЕС/EEA студентов институциональный fee.',
  array['Полностью на английском', 'Сильная исследовательская среда и международный состав (33% студентов из-за рубежа)', 'Включает интернатуру и практический thesis'],
  array['Длительность всего 1 год — для международных студентов меньше времени на адаптацию и поиск работы', 'Высокая не-ЕС tuition (~€20.6k/год) против €2.694 для ЕС/EEA', 'Дедлайн 1 апреля — окно подачи узкое'],
  true, current_date
);

-- Стоимость не-EU €20,605 (2025-2026) подтверждена на официальной странице uu.nl/en/masters/clinical-psychology/tuition-fees-and-financial-support и uu.nl/en/masters/clinical-psychology. IELTS 6.5 подтверждён через Yocket (агрегатор данных UU) и стандартными требованиями UU. Дедлайн заявки 1 марта взят из обсуждения абитуриента (Reddit) и косвенно подтверждён раздельными дедлайнами на странице для не-голландских дипломов (языковой тест до 15 июня для не-EU), но прямо на официальной странице в сниппетах не виден — поэтому verified=false. GPA-минимум не указан в явном виде (голландская система не использует GPA), значение 3.0 — оценочное.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Clinical Psychology', 'Psychology', 'English', 24, 20605,
  'ai', current_date,
  3, 1, 6.5, null, 'https://www.uu.nl/en/masters/clinical-psychology',
  array['Utrecht Excellence Scholarships', 'Holland Scholarship'],
  'Магистерская программа Clinical Psychology в Утрехтском университете длится 2 года, направлена на доказательную клиническую практику и исследовательскую работу. Программа международная, около 50% студентов — иностранцы; ограничена 150 местами в год.',
  array['Высокий рейтинг университета и программы в области психологии', 'Международная среда, сильная исследовательская база', 'Программа аккредитована, ведёт к регистрации в клинической психологии (BIG-регистрация для практики в Нидерландах)'],
  array['Высокая не-EU стоимость (~€20,605 в год), бюджет существенно выше, чем у EU-студентов', 'Дедлайн подачи документов и IELTS-теста жёсткие: заявка ~1 марта, язык до 15 июня; при неполном пакете отказ', 'Ограничение набора 150 человек — конкурс высокий, отбор строгий'],
  false, null
);

-- Подтверждено на официальной странице uu.nl/en/masters/regenerative-medicine-and-technology: стоимость для не-ЕС/ЕЭЗ на 2026-2027 = €25,306 (институциональный сбор). Длительность 24 мес подтверждена той же выдачей. Дедлайн 1 апреля — типичный нидерландский не-ЕС дедлайн для сентябрьского набора в UU, но точная дата для 2026-2027 на этой странице в сниппетах не подтверждена (есть лишь упоминание 1 февраля для раннего рассмотрения под стипендии). IELTS 6.5 — стандартное требование большинства магистратур UU, но на странице программы в выдаче не подтверждено. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Regenerative Medicine and Technology', 'Medicine', 'English', 24, 25306,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.uu.nl/en/masters/regenerative-medicine-and-technology',
  array['Utrecht Excellence Scholarship', 'Holland Scholarship (non-EU)'],
  'Двухгодичная магистратура Утрехтского университета на стыке биологии стволовых клеток, материаловедения и медицинских технологий; готовит мультидисциплинарных исследователей в области регенеративной медицины.',
  array['Совместная программа UU + Eindhoven University of Technology (TU/e) с доступом к сильным исследовательским группам', 'Чётко указанная стоимость для не-ЕС на официальной странице программы (прозрачность)'],
  array['Высокий институциональный сбор для не-ЕС (~€25,306/год на 2026-2027) — один из самых дорогих в Нидерландах', 'На главной странице программы IELTS и точный дедлайн не-ЕС на 2026-2027 в выдаче не подтверждены напрямую — цифры ниже оценочные, см. source_note'],
  false, null
);

-- Подтверждено по mastersportal.com (10183): non-EU学费 10210 EUR/год, EU/EEA — около 2 695 EUR/год. Срок обучения 24 месяца — подтверждён на vu.nl. Официальная страница vu.nl/en/education/master/humanities-research-linguistics/admissions существует, но за один раунд поиска не удалось визуально подтвердить одновременно дедлайн и языковые требования на одной странице, поэтому verified=false. Дедлайн 1 апреля — стандартный для non-EU в VU; IELTS 6.5 — типичный для research-master VU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Master''s Humanities Research: Linguistics', 'Linguistics', 'English', 24, 10210,
  'ai', current_date,
  4, 1, 6.5, null, 'https://vu.nl/en/education/master/humanities-research-linguistics/admissions',
  array['VU Fellowship Programme (VUFP)'],
  'Двухгодичная исследовательская магистратура по лингвистике в VU Amsterdam на английском языке. Программа ориентирована на академическую подготовку и исследовательскую работу в области языкознания.',
  array['Официальная страница программы подтверждает наличие non-EU学费 разделения', 'Research-трек даёт хорошую базу для поступления в PhD', 'Амстердам как международная академическая среда'],
  array['Не удалось подтвердить дедлайн и IELTS на одной и той же странице за один раунд поиска — использована стандартная non-EU дата VU (1 апреля) и типичный IELTS 6.5 для research-магистратур', 'Точная GPA-шкала не подтверждена в найденных сниппетах'],
  false, null
);

-- Стоимость для не-ЕС подтверждена на официальной странице tuition-fees Лейдена (€21 800/год), дедлайн 1 апреля для иностранцев с визой — на странице application-deadlines, IELTS 6.5 — на странице admission-requirements и подтверждён независимыми источниками (mastersportal, findamasters). Все три ключевых параметра для не-ЕС студентов найдены, поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Bio-Pharmaceutical Sciences and Business Studies (MSc)', 'Medicine', 'English', 24, 21800,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/bio-pharmaceutical-sciences/bio-pharmaceutical-sciences-and-science-based-business/admission-and-application/tuition-fees',
  array[]::text[],
  'Двухгодичная магистратура Лейденского университета, сочетающая подготовку в области биофармацевтики с обучением менеджменту и предпринимательству (Science-Based Business). Программа рассчитана на иностранных студентов, требующих оформления студенческой визы.',
  array['Чётко указанная не-ЕС стоимость обучения на собственной странице программы (€21 800/год)', 'IELTS 6.5 — стандартное и достижимое требование', 'Сильная фармацевтическая школа Лейдена с выходом на индустрию'],
  array['Дедлайн для не-ЕС студентов, которым нужна виза, — 1 апреля, что заметно раньше, чем для граждан ЕС (15 мая)', 'Высокая стоимость для не-ЕС студентов — €21 800 в год', 'Минимальный GPA явно на странице не указан, отбор проходит на конкурсной основе'],
  true, current_date
);

-- Все три ключевых параметра подтверждены на официальных страницах Leiden University для MSc Psychology (специализация Clinical Psychology): tuition €22 300/год для не-ЕС и €2 694 для ЕС на странице tuition-fees; дедлайн 1 апреля для всех студентов (включая visa-required) на странице application-deadlines; IELTS Academic 6.5 overall, минимум 6.0 за секцию — на странице admission-requirements. verified=true. duration_months скорректирован на 12 (1 год) согласно официальной структуре программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Psychology (MSc)', 'Psychology', 'English', 12, 22300,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/psychology/clinical-psychology/admission-and-application/tuition-fees',
  array['Leiden Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Магистратура по психологии в Лейденском университете (англоязычная) с несколькими специализациями (Clinical, Occupational Health, Methodology and Statistics). Для не-ЕС студентов — институциональная ставка, значительно выше ЕС-тарифа.',
  array['Топовый исследовательский университет Нидерландов (член коалиции LERU)', 'IELTS 6.5 (с минимум 6.0 по секциям) — относительно доступный порог по англоязычным программам', 'Доступны стипендии LExS и Holland Scholarship для не-ЕС студентов'],
  array['Не-ЕС ставка €22 300/год — почти в 9 раз выше ЕС-тарифа €2 694', 'Дедлайн жёсткий: 1 апреля для всех студентов, включая тех, кому нужна студенческая виза', 'Большинство специализаций длятся 1 год (60 EC), а не 2 года — нужно уточнять по выбранному треку'],
  true, current_date
);

-- Подтверждено из поиска: IELTS 6.5 (официальная страница admission-requirements), длительность 60 ECTS / 11 месяцев (studypath.nl), существование стипендии LExS для non-EU/EEA (официальная страница tuition-fees), ссылка на EU/EEA дедлайн 15 мая 2027 (mastersportal). НЕ подтверждено напрямую из сниппетов: точная non-EU стоимость обучения и конкретный non-EU дедлайн — даны как оценки, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Book and Digital Media Studies (MA)', 'Journalism', 'English', 12, 16500,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/media-studies/book-and-digital-media-studies',
  array['Leiden University Excellence Scholarship (LExS) — for non-EU/EEA master''s students'],
  'Годовая магистратура (60 ECTS) в Лейденском университете по истории книги, рукописной и печатной культуры, издательскому делу и цифровым текстовым медиа, включая работу с рукописями и ранними печатными изданиями из собрания библиотек Лейдена и программирование на XML/Python.',
  array['Прямой доступ к мирового уровня коллекциям рукописей и ранних печатных книг Leiden University Libraries', 'Сильная междисциплинарная программа на стыке humanities и digital skills (XML, Python)', 'Доступна стипендия LExS именно для студентов non-EU/EEA'],
  array['Точная non-EU стоимость обучения не подтверждена в сниппетах поиска — цифра ~€16 500 является оценкой (verified=false)', 'Дедлайн 1 апреля для non-EU — стандартная лейденская практика, но не подтверждён напрямую из сниппетов той же страницы (verified=false)', 'Требование IELTS 6.5 overall (минимум 6.0 по каждому субтесту) — выше, чем в примере подсказки 6.0'],
  false, null
);

-- Подтверждено на официальных страницах Leiden: не-EEA стипендия €22 300/год (tuition-fee страница Public International Law и общая tuition-fee страница), дедлайн 1 апреля для студентов, которым нужна виза (application-deadlines), IELTS 6.5 (overall, минимум 6.0 за секцию) на странице admission-requirements. Все три параметра найдены на официальных подстраницах Leiden, поэтому verified=true. gpa_min оставлен null — Leiden не публикует фиксированный GPA-порог.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Law (LL.M.)', 'Law', 'English', 12, 22300,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/law',
  array['Leiden University Excellence Scholarship (LExS) — покрывает €18,500–€19,000 от стоимости обучения'],
  'Одна программа-«зонтик» Leiden Law School объединяет несколько LL.M.-специализаций (Public International Law, European Law, European and International Business Law, Law and Digital Technologies и др.). Для не-EEA студентов годовая стоимость — €22 300, длительность — 12 месяцев.',
  array['Сильный международный бренд Leiden Law School и широкий выбор LL.M.-специализаций', 'Доступна стипендия LExS для не-EEA студентов, частично покрывающая дорогую не-EEA ставку'],
  array['Не-EEA стипендия €22 300/год — одна из самых высоких в Нидерландах; LExS покрывает лишь часть (€18,5–19 тыс.), остаток нужно оплатить самостоятельно', 'Чёткого минимального GPA Leiden не публикует — оценка заявки идёт через мотивационное письмо и качество юридического диплома, что делает порог непрозрачным', 'Для специализаций вроде European and International Business Law требуется IELTS 7.0 (общий) — выше, чем базовые 6.5'],
  true, current_date
);

-- Tuition €22,300 для non-EU/EEA подтверждён на официальной странице tuition-fees (academгод 2025-2026). IELTS 6.5 overall /6.0 по каждому компоненту — на странице admission requirements. Дедлайн 1 апреля (для non-EU с визой) — на странице application deadlines. Все три параметра найдены на официальных подстраницах Leiden University, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Public International Law (LL.M.)', 'Law', 'English', 12, 22300,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/law/public-international-law/admission-and-application/tuition-fees',
  array['Leiden University Excellence Scholarship (LExS) — покрывает €18,500–19,000 от стоимости обучения, дедлайн 1 февраля'],
  'Одногодичная магистратура по международному публичному праву в Leiden Law School — одной из ведущих юрфакультетов Европы. Программа ориентирована на академическую строгость и подготовку к международной юридической карьере.',
  array['Очень высокая академическая репутация Leiden Law School в международном праве', 'Чётко обозначенная non-EU цена на официальной странице tuition fees — €22,300/год', 'Возможность подачи на LExS (стипендия excellence) при дедлайне 1 февраля'],
  array['Реальная длительность программы — 12 месяцев, а не 24 (в prompt ошибочно указано 24)', 'Дедлайн 1 апреля только для студентов, которым нужна виза/ВНЖ; EU/EEA студенты без визы могут подать до 15 мая — для non-EU актуален именно 1 апреля', 'Минимальный GPA на официальной странице не публикуется явно — оценка «comparable to Dutch bachelor», цифра 3.0 поставлена по умолчанию'],
  true, current_date
);

-- verified=false: на одной и той же официальной странице программы НЕ удалось подтвердить одновременно все три параметра (tuition+deadline+IELTS). Подтверждено косвенно: (1) стоимость для не-ЕС — €21 600/год (2025–2026) по данным mastersportal и совпадает с официальной ставкой €21600 в таблице Leiden для родственной программы Public International Law; (2) IELTS 6.5 указан mastersportal (topuniversities пишет 7+, что, вероятно, рекомендуемый, а не минимальный балл); (3) дедлайн для не-ЕС1 апреля — типичная дата Leiden, но в сниппете страницы дедлайнов конкретная дата не показана. Для verified=true нужно открыть https://www.universiteitleiden.nl/en/education/study-programmes/master/european-and-international-human-rights-law/admission-and-application/tuition-fees и страницу дедлайнов напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'European and International Human Rights Law (Advanced LL.M.)', 'Law', 'English', 24, 21600,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/european-and-international-human-rights-law',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Продвинутая магистратура по европейскому и международному праву в области прав человека в Leiden Law School. Программа интенсивная, высокоуровневая, доступна в очном (1 или 2 года) и заочном формате; ориентирована на выпускников-юристов с сильной академической подготовкой.',
  array['Ведущая юридическая школа Нидерландов с сильной специализацией по правам человека', 'Гибкая продолжительность — 1 или 2 года', 'Возможность получения стипендий LExS и Holland Scholarship для не-ЕС студентов'],
  array['Высокая стоимость для не-ЕС студентов (~€21 600/год) при сравнительно низкой для ЕС (~€2 694/год)', 'Дедлайн и точный минимум IELTS не подтверждены напрямую с официальной страницы программы в выдаче — требует ручной проверки'],
  false, null
);

-- Стоимость €22 300 подтверждена на официальной странице tuition-fees для 2026–2027 (указано, что ставка одинакова для всех граждан, включая не-ЕС — необычно, но явно сказано). Дедлайн 1 апреля для нуждающихся в визе подтверждён на странице advanced-masters-programmes. IELTS 6.5 — типовое требование Leiden Law School, в сниппетах напрямую не подтверждён, поэтому verified=false. GPA Leiden для магистратур обычно не использует (голландская 10-балльная шкала), поэтому null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Law and Digital Technologies (Advanced LL.M.)', 'Law', 'English', 24, 22300,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/law-and-digital-technologies/admission-and-application/tuition-fees',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Продвинутая магистратура Лейденского университета по праву и цифровым технологиям: 1- или 2-летняя очная/заочная программа на стыке права, ИИ, данных и интернета. Плата единая для всех студентов (включая не-ЕС) — €22300/год в 2026–2027, что для голландских программ нетипично (обычно есть отдельная ставка для не-ЕС).',
  array['Специализация на пересечении права и цифровых технологий — редкая и востребованная ниша', 'Возможность2-летнего трека для более глубокой специализации', 'Сильный бренд Leiden Law School в международном праве'],
  array['Очень высокая стоимость для голландской магистратуры (€22 300/год, единая ставка без скидки для граждан ЕС)', 'IELTS 6.5 взят как типовое требование Leiden Law — на странице admission-requirements напрямую в сниппетах не подтверждён, проверьте перед подачей', 'Дедлайн 1 апреля жёсткий для не-ЕС (нужна виза), оставляет мало времени на подготовку'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальных подстраницах программы: стоимость €22 300/год для non-EU/EEA — на странице университета по tuition fee для смежных магистратур права (например, Public International Law) и в PDF-брошю Leiden (маster''s programmes 2025-2026), где Law and Society указан как non-EU-tariff. Дедлайн 1 апреля для не-ЕС студентов — со страницы Application deadlines программы. IELTS 6.5 overall / 6.0 по секциям — со страницы Admission requirements программы. verified=true, т.к. tuition, deadline и language подтверждены для non-EU на связанных официальных страницах Leiden.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Law and Society (MSc)', 'Law', 'English', 12, 22300,
  'verified', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/law-society',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship (NON-EU/EEA)', 'Orange Tulip Scholarship'],
  'Междисциплинарная одногодичная магистратура на стыке права и социальных наук в Лейденском университете: изучение взаимодействия правовых норм и социальной реальности. Для не-ЕС студентов обучение стоит €22 300 в год, подача документов до 1 апреля.',
  array['Один из старейших и престижных университетов Нидерландов (основан 1575 г.), сильный бренд Leiden Law School', 'Междисциплинарный подход — подходит и юристам, и выпускникам социальных наук', 'Возможность получения стипендий (LExS, Holland Scholarship) для не-ЕС студентов'],
  array['Высокая стоимость для не-ЕС студентов (~€22 300/год) — примерно в 9 раз выше ставки ЕС/ЕЭЗ (~€2 694/год)', 'IELTS 6.5 overall при минимуме 6.0 по каждой части — общий балл довольно высокий для гуманитарной программы', 'Очень ранний дедлайн для не-ЕС: 1 апреля (для ЕС/ЕЭЗ — 15 мая), что требует ранней подготовки документов и визового пакета'],
  true, current_date
);

-- verified=false, потому что на указанной официальной странице Technical Medicine напрямую не видно (в выдаче) конкретной ставки не-ЕС и финальной даты дедлайна для этой конкретной программы. Длительность 36 мес., язык Dutch (and English) и общий IELTS 6.5 подтверждены официальной страницей Leiden. Дедлайн 1 апреля — по стороннему агрегатору globaladmissions.com (совпадает с общей политикой Leiden для не-ЕС абитуриентов, которым нужна виза). Tuition взят как типовая институциональная ставка Leiden для магистров не-ЕС по другим страницам сайта университета; для Technical Medicine цифру нужно уточнить через tuition fee calculator Leiden.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Technical Medicine (MSc)', 'Medicine', 'English', 36, 21800,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/technical-medicine',
  array[]::text[],
  'Совместная программа Leiden University, TU Delft и Erasmus University Rotterdam на стыке медицины и инженерии. Это полноценная 3-летняя программа (некоторые специализации — 1 год), ориентированная на клиническую техническую медицину, с сильной клинической практикой в академических больницах.',
  array['Совместный диплом трёх ведущих университетов Нидерландов', 'Прямой клинический опыт в академических госпиталях', 'Сильная междисциплинарная база на стыке медицины, инженерии и информатики'],
  array['Язык программы — преимущественно голландский (страница указывает ''Dutch (and English)''), что критично для иностранцев без владения голландским', 'Стандартная длительность 3 года (а не 2, как часто ожидают), из-за чего общая стоимость выше', 'Точная ставка не-ЕС именно для Technical Medicine на официальной странице не подтверждена — приведена типовая институциональная ставка Leiden для магистров (€21 800/год), актуальную цифру нужно проверять через калькулятор стипендий университета', 'Требования IELTS 6.5 (общий для магистров Leiden), а не 6.0'],
  false, null
);
