-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Belgium (be) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: на странице https://www.ugent.be/ps/en/education/programmes/emgs подтверждены только название, длительность (2 года) и общая структура программы; дедлайн 28 февраля 2026 для стипендии Erasmus Mundus подтверждён несколькими независимыми источниками (globalstudies-masters.eu, LinkedIn-пост программы). Размер tuition для non-EU и точный IELTS-минимум не извлечены из сниппетов — взяты типичные значения для EMJM и Ghent University соответственно, требуют ручной проверки на сайте координатора (Лейпциг) или странице Ghent.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Arts in Global Studies (Erasmus Mundus)', 'International Relations', 'English', 24, 9000,
  'ai', current_date,
  2, 28, 6.5, null, 'https://www.ugent.be/ps/en/education/programmes/emgs',
  array['Erasmus Mundus Scholarship (full coverage: tuition + €1000/month stipend + travel + insurance, highly competitive)', 'OECD-DAC partner grant for applicants from developing countries (€1000/month + insurance)'],
  'Междисциплинарная 2-летняя магистратура Erasmus Mundus от консорциума 5 европейских и 9 мировых университетов под координацией Лейпцига; Гентский университет — один из ключевых партнёров. Программа ориентирована на глобальные исследования, политику и критическую теорию.',
  array['Полная стипендия Erasmus Mundus покрывает обучение, проживание (€1000/мес), страховку и перелёт', 'Мобильность между несколькими европейскими и мировыми университетами-партнёрами', 'Престиж бренда Erasmus Mundus и сильная международная когорта'],
  array['Точная сумма взноса для non-EU/self-funded на2026/2028 не подтверждена на официальной странице Ghent — оценка €9000 за 2 года (~€4500/год) типична для EMJM, но требует уточнения', 'Дедлайн 28 февраля — для соискателей стипендии Erasmus Mundus; self-funded заявки могут приниматься позже (апрель–май), точные даты на странице Ghent не подтверждены', 'IELTS 6.5 — стандартное требование Ghent, но конкретный порог именно для EMGS на проверенной странице не указан', 'Конкуренция за стипендию крайне высокая (мировой отбор)'],
  false, null
);

-- verified=false: на официальной странице studiekiezer.ugent.be в результатах поиска виден только общий заголовок ''Tuition Fee — More information on tuition fees'' без конкретных цифр для не-ЕС. Сумма €7,079 и дедлайн ~1 апреля взяты со стороннего агрегатора educations.com (https://www.educations.com/institutions/law-ugent/master-of-laws-in-international-and-european-law-international-and-human-rights-law), который явно разделяет EU/EEA и Non-EU дедлайны. studyqa.com даёт близкую сумму ~$6.14k/год, но другой дедлайн (22 апреля). IELTS официально не подтверждён в выдаче — взят типово для магистратур UGent.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Laws in International and European Law (International and Human Rights Law)', 'Law', 'English', 24, 7079,
  'ai', current_date,
  4, 1, 6.5, null, 'https://studiekiezer.ugent.be/master-of-laws-in-international-and-european-law-international-and-human-rights-law-en',
  array['Ghent University Top-Up Grants (выборочно для иностранных студентов)'],
  'Годовая англоязычная программа LLM в Гентском университете с уклоном в международное публичное право и права человека (на базе Faculty of Law and Criminology). Для граждан ЕС/ЕЭЗ обучение практически бесплатное, для не-ЕС — около €7,000 за двухгодичный курс.',
  array['Престижный бельгийский юрфак с сильной школой международного права', 'Полностью на английском, международная среда', 'Возможность выбора курсов из смежных специализаций EU Law / Business Law'],
  array['IELTS 6.5 взят как типовое требование UGent — точная цифра с официальной страницы программы в выдаче не подтверждена', 'Дедлайн для не-ЕС ~1 апреля — жёсткое окно, studyqa.com указывает 22 апреля (расхождение между источниками)', 'Точный годовой vs. общий размер не-ЕС платы на официальной странице studiekiezer.ugent.be не виден в выдаче (страница ссылается на отдельный раздел ''Tuition Fee'')'],
  false, null
);

-- verified=false: tuition (7079 EUR) и deadline (~1 апреля) найдены на educations.com, но на официальной странице studiekiezer.ugent.be точная сумма и дата не отображены в выдаче. Разграничение EU/non-EU не подтверждено на одной странице с программой. IELTS 6.5 — типовое требование UGent, для конкретно EU Law track отдельно не подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Laws in International and European Law (European Union Law)', 'Law', 'English', 12, 7079,
  'ai', current_date,
  4, 1, 6.5, null, 'https://www.educations.com/institutions/law-ugent/master-of-laws-in-international-and-european-law-european-union-law',
  array[]::text[],
  'Один год магистратуры LLM в области права ЕС в Гентском университете — одной из ведущих юридических школ Бельгии с сильной экспертизой по праву Европейского союза. Программа на английском для выпускников-юристов, желающих специализироваться на европейском праве.',
  array['Преподавание на английском языке в топовом бельгийском университете с сильной экспертизой по праву ЕС', 'Компактная одногодичная программа (60 ECTS), быстрый возврат инвестиций'],
  array['Не найдено явного разграничения ставок EU/non-EU на самой странице studiekiezer; цифра 7079 EUR взята с educations.com — требует перепроверки на официальном сайте UGent', 'Точный крайний срок подачи документов указан приблизительно (~1 апреля), официальная дата на studiekiezer.ugent.be не подтверждена', 'Минимальный IELTS не подтверждён напрямую для этой программы — указано по общему требованию UGent'],
  false, null
);

-- verified=false, потому что все три параметра (tuition/deadline/language) одновременно с одной и той же страницы программы не подтверждены. Дедлайн для non-EU ''до 1 апреля'' подтверждён паттерном по страницам других LLM-программ UGent 2026 (studiekiezer.ugent.be/.../starten) и educations.com. IELTS6.5 Academic взят из официального PDF UGent ''Specific Language Requirements 2026-2027'' (ugent.be/prospect), но llmgent.eu/apply указывает 7.0 — расхождение не разрешено. Стоимость €6400 — оценка по типичному non-EU тарифу UGent на англоязычные магистратуры 60 ECTS, но без прямого подтверждения именно для этой программы. Длительность 12 месяцев подтверждена studiekiezer и LLM Guide.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Laws in International and European Law (Comparative Law and Transnational Dispute Resolution)', 'Law', 'English', 12, 6400,
  'ai', current_date,
  4, 1, 6.5, null, 'https://studiekiezer.ugent.be/master-of-laws-in-international-and-european-law-comparative-law-and-transnational-dispute-resolution-en',
  array[]::text[],
  'Годовая (60 ECTS) англоязычная программа LLM в Гентском университете с фокусом на сравнительное право и транснациональное разрешение споров, с гибким индивидуальным учебным планом и сильной репутацией в области европейского права.',
  array['Программа длится всего 1 год (60 ECTS) — быстрое завершение', 'Преподавание полностью на английском; гибкая настройка 15 кредитов специализации', 'Сильная юридическая школа Ghent с экспертизой в европейском и международном праве', 'Расположение в Бельгии — доступ к институтам ЕС и международным арбитражным центрам'],
  array['Точная non-EU стоимость обучения для этой конкретной программы не подтверждена напрямую с указанной страницы; €6400 — оценка по тарифам UGent на англоязычные магистратуры', 'По IELTS наблюдается разнобой источников: 6.5 (UGent PDF) vs 7.0 (llmgent.eu/LLM Guide); минимальный порог может зависеть от конкретной специализации', 'Дедлайн 1 апреля для non-EU студентов жёсткий и ранний — нужно готовить документы сильно заранее'],
  false, null
);

-- Дедлайн для не-ЕЭЗ (31 мая 2026 на 2026–2027 уч. год) подтверждён на странице admission/enrolment самой программы VUB. IELTS 6.5 общий / 6.0 по секциям — на отдельной странице VUB «Academic and language requirements», на странице программы упомянут только сам факт требования IELTS (academic module). Стоимость: на странице программы указана только фиксированная часть — €305,40 для ЕЭЗ и €1680 для не-ЕЭЗ; переменная часть (по кредитам) обрезана в сниппете. Сумма €4800/год взята с educations.com и косвенно подтверждается расчётом €1680 + ~€52/кредит × 60 ECTS ≈ €4800. verified=false, так как tuition, deadline и language requirement не подтверждены все три на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master Linguistics and Literary Studies', 'Linguistics', 'English', 24, 4800,
  'ai', current_date,
  5, 31, 6.5, null, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-linguistics-and-literary-studies/master-linguistics-and-literary-studies-admission-enrolment',
  array['VUB Multicultural Master''s Scholarship — разовая выплата до €3000 для студентов не из ЕЭЗ'],
  'Двухлетняя магистерская программа VUB (120 ECTS) по лингвистике и литературоведению с возможностью получения двойного диплома в партнёрстве с другим европейским университетом. Программа междисциплинарная, сочетает лингвистику, литературоведение и культурологию в многоязычном брюссельском контексте; преподавание ведётся на нескольких языках.',
  array['Двойной диплом с университетом-партнёром (например, MA in Linguistics and Literary Studies VUB + MA в другом вузе)', 'Многоязычная среда Брюсселя, программа изначально ориентирована на интернациональных студентов', 'Стипендия Multicultural Master''s Scholarship до €3000 для студентов не из ЕЭЗ'],
  array['Дедлайн для не-ЕЭЗ — 31 мая (заметно раньше, чем для граждан ЕЭЗ, у которых 31 июля)', 'IELTS 6.5 общий и минимум 6.0 по каждой из 4 секций — строже, чем стандартные6.0/6.0', 'Точный GPA-minimum на странице программы не указан явно; приведён ориентировочный порог'],
  false, null
);

-- Не полностью подтверждено одной страницей: tuition 5720 EUR/год для не-EEA взят с mastersportal.com (имя совпадает с программой VUB), дедлайн 1 апреля 2026 — с официальной страницы admission VUB (foreign diploma), IELTS 6.0 — стандарт VUB. На основной странице программы разбивка EU/non-EU tuition в сниппетах поиска не показана явно, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master Communication Studies: Journalism & Media in Europe', 'Journalism', 'English', 12, 5720,
  'ai', current_date,
  4, 1, 6, null, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-communication-studies-journalism-media-in-europe',
  array[]::text[],
  'Одногодичная англоязычная магистерская программа VUB в Брюсселе, ориентированная на европейскую журналистику, медиа и коммуникации. Подходит для выпускников, желающих работать в европейских институтах, медиа и PR.',
  array['Англоязычная программа в самом сердце ЕС — Брюсселе', 'Доступная по европейским меркам стоимость для не-EEA студентов'],
  array['Стипендии и детальная скидочная политика для не-EEA на странице программы явно не указаны — нужна отдельная проверка', 'Дедлайн для иностранных дипломов 1 апреля — относительно ранний, а точная сумма не-EEA tuition взята с mastersportal, требует подтверждения на официальной странице VUB'],
  false, null
);

-- verified=false: tuition €4 800/год и deadline 31 марта для не-EEA взяты с educations.com (парсинг сниппета: ''TUITION FEES EUR 4,800 / per year … non EEA nationals : 31 March''); IELTS 6.5 (overall, минимум 6.0 по субтестам) — общий стандарт VUB со страницы academic-and-language-requirements; длительность 24 мес. подтверждена TopUniversities. Все три ключевых параметра не найдены одновременно на одной официальной странице программы, поэтому verified=false. Реальный URL программы на VUB подтверждён в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master Educational Sciences', 'Education', 'English', 24, 4800,
  'ai', current_date,
  3, 31, 6.5, null, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-educational-sciences',
  array['VUB Master Mind Scholarship (для не-EEA студентов с высокой успеваемостью)'],
  'Двухгодичная (24 мес.) англоязычная магистратура VUB по педагогическим наукам с международной и сравнительной перспективой, расположена в Брюсселе. Для не-EEA студентов ориентировочная стоимость €4 800/год, дедлайн подачи — 31 марта.',
  array['Программа полностью на английском в мультикультурном Брюсселе (столица ЕС)', 'Международная и сравнительная направленность педагогики — актуально для работы в международных организациях', 'Возможность получения стипендии Master Mind для талантливых не-EEA студентов'],
  array['Стоимость и дедлайн для не-EEA подтверждены сторонним агрегатором educations.com, а не напрямую на официальной странице VUB в одном месте', 'Точный GPA-минимум не указан в выдаче — 3.0 является общевузовской оценкой-экстраполяцией', 'С 2025–2026 ряд фламандских вузов повысил не-EU тарифы (см. The PIE News), цифра может быть уже неактуальна'],
  false, null
);

-- verified=false: на странице https://uclouvain.be/en-prog-2026-ling2m-cond_adm в выдаче не подтверждены одновременно tuition+deadline+IELTS для не-EU. Tuition €1,194 — из материалов о реформе UCLouvain 2026-27 и Studacy (неассимилированные не-EU платят ordinary fee). IELTS 6.0 и дедлайн 30 апреля — общие для UCLouvain/ESPO, не подтверждены именно для ling2m. Язык (английский) подтверждён PDF программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '50fd6d84-6cb0-411b-93a4-d7c26a7077ad',
  'Master [120] in Linguistics (Empirical Linguistics Research focus, entirely in English)', 'Linguistics', 'English', 24, 1194,
  'ai', current_date,
  4, 30, 6, null, 'https://uclouvain.be/en-prog-2026-ling2m-cond_adm',
  array[]::text[],
  'Магистратура UCLouvain по лингвистике с фокусом на эмпирических методах исследования, полностью на английском. Программа на 120 кредитов (2 года), сильный исследовательский и международный профиль (более половины студентов — иностранцы).',
  array['Программа полностью на английском — подходит для иностранных студентов', 'Более 50% студентов — международные, мультилингвальная академическая среда', 'Сильный исследовательский трек с подготовкой к PhD'],
  array['Точная не-EU ставка не подтверждена на странице условий допуска: €1,194 — это по реформе 2026-27 «обычная» ставка, по данным Studacy её платят и неассимилированные не-EU студенты, но прямого подтверждения на странице ling2m не найдено', 'IELTS 6.0 взят с факультета ESPO/ESL как типичный для англоязычных программ UCLouvain — на самой странице ling2m-cond_adm в выдаче не подтверждён', 'Дедлайн 30 апреля указан как общий не-EU дедлайн UCLouvain, но на конкретной странице ling2m в выдаче не подтверждён', 'Допуск по среднему баллу 13/20 — GPA в системе 4.0 напрямую не указан'],
  false, null
);

-- verified=false: стоимость €5 010/год для не-ЕС подтверждена со страниц UCLouvain и сторонних источников (835€ базовый + 4 175€ надбавка), но IELTS-минимум и точный дедлайн не найдены на самой странице программы arcb2m; использованы общие правила UCLouvain для магистратур (IELTS 6.5, дедлайн 30 апреля для не-ЕС на сентябрьский набор). Программа действительно существует и преподаётся на английском (подтверждено loci-ima.com и страницей uclouvain.be/en-prog-2026-arcb2m-programme).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '50fd6d84-6cb0-411b-93a4-d7c26a7077ad',
  'Master [120] in Architecture (Bruxelles) – International Master in Architecture (IMA, taught in English)', 'Architecture', 'English', 24, 5010,
  'ai', current_date,
  4, 30, 6.5, null, 'https://uclouvain.be/en-prog-2026-arcb2m-programme',
  array[]::text[],
  'Двухлетняя англоязычная магистратура по архитектуре в Брюсселе на базе факультета LOCI UCLouvain; рассчитана на иностранных студентов с архитектурным бэкграундом, готовит к международной профессиональной практике.',
  array['Полностью англоязычная программа с сильным проектным компонентом (30 кредитов на студийную работу)', 'Международная среда в Брюсселе, одна из немногих полноценных англоязычных магистратур по архитектуре в Бельгии', 'Стоимость для не-ЕС студентов относительно умеренная для Западной Европы (~€5 010/год)'],
  array['Не подтверждены единым первоисточником ни IELTS-минимум, ни точный дедлайн именно для arcb2m — взяты по общим правилам UCLouvain (IELTS 6.5 и30 апреля для не-ЕС), поэтому verified=false', 'Дополнительный сбор €200 за подачу заявки для не-ЕС абитуриентов, не входит в указанную сумму tuition', 'С2026-27 учебного года базовый fee растёт (€835 → €1 194), плюс надбавка для не-ЕС €4 175 — итоговая сумма может вырасти'],
  false, null
);
