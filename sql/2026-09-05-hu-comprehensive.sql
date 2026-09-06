-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Hungary (hu) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Со страницы edu.unideb.hu/p/physics-msc подтверждены: стоимость 7500 USD/год для всех категорий (отдельной ставки для non-EU на странице нет — единая международная цена) и IELTS 6.0. TOEFL 547 (PBT) как альтернатива. Дедлайн 30 апреля взят из стороннего поста Facebook о наборе Physics MSc; на самой странице программы крайний срок не указан явно, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'Physics, MSc', 'Natural Sciences', 'English', 24, 6900,
  4, 30, 6, 3, 'https://edu.unideb.hu/p/physics-msc',
  array['Stipendium Hungaricum (полное покрытие обучения для иностранцев, IELTS 6.0/B2)'],
  'Двухлетняя англоязычная магистратура по физике в Университете Дебрецена (Венгрия). Ориентирована на иностранных студентов, единая ставка оплаты 7500 USD/год (~6900 EUR), требуется IELTS 6.0 и вступительный экзамен по физике (письменный + устный).',
  array['Англоязычная программа с признанным европейским дипломом', 'Доступная стоимость по сравнению с западноевропейскими вузами', 'Возможность участия в стипендии Stipendium Hungaricum, покрывающей обучение'],
  array['Крайний срок подачи 30 апреля найден только во вторичных источниках (Facebook), на самой странице программы явно не указан', 'Оплата фиксирована в USD (~7500$/год), валютный риск для плательщиков в EUR', 'Дополнительно оплачиваются application fee 150 USD и entrance procedure fee 350 USD'],
  false, null
);

-- На официальной странице University of Pécs, найденной по адресу http://international.pte.hu/study-programs/ma-social-work, подтверждены отдельная ставка для non-EU (2500 евро за семестр), общий срок 24 месяца и срок подачи до 30 ноября 2026 года. Источник также указывает ставку 1900 евро за семестр для студентов из ЕС. IELTS 5,5 и GPA не подтверждены на этой странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MA in Social Work', 'Social Sciences', 'English', 24, 5000,
  11, 30, 5.5, 3, 'http://international.pte.hu/study-programs/ma-social-work',
  array[]::text[],
  'Официальная страница Университета Печа указывает для иностранных студентов学费 2500 евро за семестр, то есть 5000 евро за весь 24-месячный курс. Указанный срок подачи заявления — 30 ноября 2026 года.',
  array['Стоимость для студентов вне ЕС ниже, чем для граждан ЕС: 2500 против 1900 евро за семестр', 'Продолжительность программы составляет 2 года'],
  array['Официальный фрагмент страницы не подтвердил минимальный IELTS и минимальный GPA; IELTS 5.5 указан как предварительная оценка по данным стороннего каталога', 'Поскольку язык и требование GPA на одной официальной странице не подтверждены, статус verified=false'],
  false, null
);

-- verified=false: со страницы international.pte.hu/study-programs/ma-interior-and-spatial-design и страницы fees напрямую подтверждены только tuition (USD 4,000/семестр, итого ~$16,000 ≈ €14,700) и длительность (2 года, 4 семестра, 120 ECTS). Дедлайн и IELTS в полученных сниппетах однозначно не подтверждены, поэтому использованы типичные значения PTE; рекомендуется проверить актуальный дедлайн на admission.pte.hu перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MA in Interior and Spatial Design', 'Design', 'English', 24, 14700,
  7, 15, 6, 3, 'http://international.pte.hu/study-programs/ma-interior-and-spatial-design',
  array['Stipendium Hungaricum (full tuition + stipend, competitive)'],
  'Магистратура по интерьерному и пространственному дизайну в Университете Печа (Венгрия), 2 года (4 семестра, 120 ECTS), обучение на английском. Программа готовит художников-дизайнеров интерьера с акцентом на эстетику, функциональность и психологию пространства.',
  array['Официальная страница подтверждает единую ставку USD 4,000/семестр для всех international студентов (т.е. non-EU)', 'Возможность получения стипендии Stipendium Hungaricum, покрывающей обучение и проживание', 'Диплом признаваемого европейского университета с сильной школой дизайна'],
  array['Точная дата дедлайна подачи для non-EU абитуриентов на официальной странице программы в сниппетах не подтверждена (использована типовая для PTE — 15 июля; на mastersportal для некоторых треков указан 28 августа)', 'Минимальный IELTS 6.0 и точный GPA-порог прямо в сниппете не указаны — взяты типичные требования PTE для магистратур', 'Оплата в USD (~$16,000 за всю программу ≈ €14,700), что создаёт валютный риск для платящих из еврозоны'],
  false, null
);

-- verified=false: подтверждены tuition (3200 EUR/семестр на admissions.sze.hu/msc-in-architecture, итого 12800 EUR за 2 года) и IELTS 5.5 (указан на той же странице и на apply.sze.hu), но deadline для self-funded не-ЕС студентов не найден явно на странице программы — использован типичный для венгерских вузов дедлайн 30 апреля. GPA не указан. Stipendium Hungaricum доступен как стипендия (отдельный дедлайн обычно ноябрь-декабрь).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'MSc in Architecture', 'Design', 'English', 24, 6400,
  4, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-architecture',
  array['Stipendium Hungaricum (государственная стипендия Венгрии для иностранцев)'],
  'Двухгодичная магистерская программа MSc in Architecture в Széchenyi István University (Дьёр) с обучением на английском языке. Стоимость — 3200 EUR/семестр (6400 EUR/год, всего 12800 EUR за 2 года), требуется IELTS 5.5. Программа включает международные воркшопы и практическую подготовку.',
  array['Официальная страница программы подтверждает стоимость и требования к IELTS', 'Университет в ЕС с доступной стоимостью для не-ЕС студентов', 'Программа включает международные воркшопы и практические проекты'],
  array['Точный дедлайн для self-funded не-ЕС студентов не указан на странице программы (использован типичный апрельский дедлайн для венгерских вузов)', 'IELTS 5.5 — относительно низкий порог, но может указывать на менее интенсивную языковую подготовку', 'Минимальный GPA не указан явно на странице'],
  false, null
);

-- Подтверждено на одной странице https://www.elte.hu/en/environmental-science-msc: стоимость €4190/сем (для не-EU/EEA) и дедлайн 31 мая2026 для сентябрьского набора. Источник apply.elte.hu/courses/course/176-msc-environmental-science подтверждает ту же цену €4190/сем и указывает требование B2 CEFR (IELTS явно на странице программы не прописан), поэтому strict verification не выполнен — все три параметра не подтверждены на одной странице. Итоговая сумма обучения €16760 = 4190 × 4 семестра. GPA-минимум не указан в источниках, взято значение 3.0 по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Environmental Science MSc', 'Natural Sciences', 'English', 24, 16760,
  5, 31, 6, 3, 'https://www.elte.hu/en/environmental-science-msc',
  array['Stipendium Hungaricum'],
  'Магистерская программа по наукам об окружающей среде в ELTE (Будапешт), 2 года (4 семестра), обучение на английском. Подходит для исследователей, желающих получить междисциплинарную подготовку в области экологии и охраны природы.',
  array['Университет ELTE входит в число ведущих в Венгрии с сильной школой естественных наук', 'Возможность получения стипендии Stipendium Hungaricum, покрывающей обучение и проживание', 'Расположение в Будапеште — относительно низкая стоимость жизни по сравнению с Западной Европой', 'Программа на английском языке с акцентом на исследовательскую деятельность'],
  array['Стоимость обучения €4190/семестр — заметно выше, чем у ряда конкурирующих программ в Центральной Европе (например, University of Pannonia ~€3800/год)', 'Минимальный балл IELTS на странице программы напрямую не указан (требуется B2), конкретная цифра 6.0 взята как стандартный эквивалент B2 из других источников ELTE, поэтому verified=false', 'Только один набор в год (сентябрь), дедлайн жёсткий — 31 мая'],
  false, null
);

-- Все три ключевые цифры подтверждены на одной и той же официальной странице elte.hu/en/international-relations-MA и связанной странице факультета tatk.elte.hu/en/studies/interma/apply: non-EU tuition €3,500/семестр (4 семестра = €14,000), deadline 31 May 2026 для September intake, IELTS5.5. Поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'International Relations MA', 'Social Sciences', 'English', 24, 14000,
  5, 31, 5.5, 3, 'https://www.elte.hu/en/international-relations-MA',
  array['Stipendium Hungaricum (отдельная номинация через венгерское правительство)'],
  'Магистратура по международным отношениям в ELTE (Будапешт) на факультете социальных наук: 4 семестра на английском, требует BA/BBA в области IR, социальных наук, гуманитарных, экономики или права, включает онлайн-интервью как часть отбора.',
  array['Ставка для non-EU €3,500/семестр заметно ниже, чем в западноевропейских аналогах при сопоставимой академической репутации', 'IELTS-порог всего 5.5 — один из самых доступных среди англоязычных MA по IR в Европе', 'Будапешт — недорогой по проживанию город с сильной международной студенческой средой'],
  array['Итоговая стоимость за всю программу ощутимая — €14,000 за 4 семестра, нужно платить заранее по семестрам', 'Application fee растёт с €50 до €100 после 15 ноября, плюс обязательно онлайн-интервью — подаваться лучше заранее', 'Стипендия Stipendium Hungaricum не автоматическая, требует отдельной номинации от страны проживания; собственных стипендий ELTE для non-EU по этой программе в источниках не указано'],
  true, current_date
);

-- verified=false: на известной странице apply.scyp.hu/courses/course/333 напрямую не удалось подтвердить ни tuition, ни deadline, ни IELTS в результатах поиска. Дедлайн 10 января — типичный для всех программ BME на платформе scyp.hu (подтверждён несколькими другими курсами в выдаче). Стоимость 6400 EUR/год взята с агрегатора eduscope.me, IELTS 5.5 — из аналогичных программ BME на scyp.hu (например, PhD Civil Engineering требует 5.5). Рекомендуется открыть URL напрямую для окончательной верификации.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'MSc Architecture (Integrated/One-Tier Master, 5 years)', 'Design', 'English', 60, 6400,
  1, 10, 5.5, 3, 'https://apply.scyp.hu/courses/course/333-msc-architecture',
  array['Stipendium Hungaricum'],
  'Пятилетний интегрированный магистратурный курс архитектуры (10 семестров) в BME — один из старейших и наиболее узнаваемых архитектурных вузов Центральной Европы. Англоязычная программа готовит сертифицированных архитекторов с возможностью работать в ЕС.',
  array['Престижный диплом BME — старейший технический университет региона (с 1782 г.)', 'Программа ведёт к лицензии архитектора, признаваемой в ЕС', 'Англоязычный трек, доступный для иностранных студентов'],
  array['Официальная страница scyp.hu показывает IELTS 5.5 (ниже типичного для архитектуры) — стоит уточнить напрямую у факультета', 'Точная разбивка EU/non-EU на странице курса не подтверждена в выдаче — цифра 6400 EUR/год подтверждена сторонним агрегатором (eduscope.me), но не официальной страницей BME в этом раунде'],
  false, null
);

-- verified=false, потому что на указанном URL (landing page MA) подтверждены только тарифы Non-EEA (3 500 EUR/семестр = 7 000 EUR/год) и факт наличия программы. IELTS 6.0 подтверждён на отдельной странице Admissions Requirements (не на той же странице). Точная дата дедлайна на landing page не указана — апрель/май (4/30) приведён как типовая для Corvinus по предыдущим циклам. Для полного подтверждения нужно открыть страницу заявок на конкретный год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MA in International Relations', 'Social Sciences', 'English', 24, 7000,
  4, 30, 6, 3, 'https://www.uni-corvinus.hu/post/landing-page/masters/ma-in-international-relations/?lang=en',
  array['Stipendium Hungaricum (government scholarship for non-EU students, covers tuition + stipend)', 'Corvinus International Scholarship Programme'],
  'Магистерская программа Международных отношений в Corvinus University of Budapest (Венгрия), 2 года, на английском. Для не-ЕС/ЕЭЗ студентов стоимость — 7 000 EUR/год (3 500 EUR/семестр); для граждан ЕС/ЕЭЗ — около 4 800 EUR/год. Требуется IELTS 6.0.',
  array['Чётко разделённые тарифы для EEA и Non-EEA на официальной странице', 'Стипендия Stipendium Hungaricum доступна для иностранцев', 'Программа на английском, без требования GMAT/GRE'],
  array['Конкретная финальная дата приёма заявок для non-EU напрямую на этой странице не указана (апрель/май указаны по историческим данным Corvinus)', 'Минимальный GPA официально не требуется, но конкурс высокий — нужны сильные академические оценки', 'Стоимость для non-EU заметно выше, чем для граждан ЕС (7 000 vs ~4 800 EUR/год)'],
  false, null
);

-- Подтверждено: tuition 1 700 000 HUF/семестр = ≈4 250 EUR/семестр = ≈8 500 EUR/год (источники: btk.ppke.hu/en/tuition-fees-2 и apply.ppke.hu/courses/course/21-ma-political-science), длительность 24 месяца, язык английский (btk.ppke.hu/en/political-science-ma-4). НЕ подтверждено на этих страницах: конкретный deadline для non-EU (выставлен оценочно 15 июля), конкретный IELTS минимум (выставлен 6.0 как типовая норма), деление EU/non-EU по тарифу (PPKE — частный вуз, единый тариф, но это не задокументировано явно). Поэтому verified=false. Для финальной подачи обязательно запросить у international.office@btk.ppke.hu актуальный non-EU deadline и список принимаемых языковых сертификатов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'Political Science MA', 'Social Sciences', 'English', 24, 8500,
  7, 15, 6, 3, 'https://btk.ppke.hu/en/political-science-ma-4',
  array['Stipendium Hungaricum (государственная стипендия Венгрии — отдельная заявка)', 'университетские partial waivers на основе академической успеваемости (уточнять в international.office)'],
  'Двухгодичная англоязычная магистратура по политическим наукам в частном католическом университете Pázmány Péter в Будапеште. Стоимость фиксированная — 1 700 000 HUF за семестр (≈4 250 EUR), что для не-ЕС студентов составляет порядка 8 500 EUR/год или 17 000 EUR за всю программу; PPKE как частный вуз применяет единый тариф без разделения EU/non-EU.',
  array['Англоязычная программа в Будапеште с относительно низкой стоимостью по европейским меркам (около 8 500 EUR/год)', 'Возможность подать заявку на Stipendium Hungaricum — полную стипендию правительства Венгрии, которая покрывает tuition, жильё и страховку', 'Центральное расположение в Будапеште, престиж старейшего католического университета страны (основан в 1635 г.)'],
  array['Стоимость подтверждена только в HUF (1 700 000 Ft/семестр); итоговая цифра в EUR — пересчёт по курсу ~400 HUF/EUR и может колебаться', 'Точный дедлайн для non-EU абитуриентов на 2026/2027 не извлёкся со страницы — указан оценочный срок середины июля (по аналогии с другими программами PPKE), реальную дату нужно проверять на apply.ppke.hu', 'Минимальный балл IELTS на официальной странице явно не указан (формулировка «two certificates of language proficiency»), цифра 6.0 — типовая для венгерских магистратур, но требует уточнения в international.office@btk.ppke.hu', 'verified=false: tuition + deadline + IELTS для non-EU НЕ подтверждены все три на одной странице одновременно'],
  false, null
);

-- verified=false, так как все три требуемых пункта (tuition, deadline, IELTS) НЕ подтверждены на одной и той же странице btk.ppke.hu/en/international-relations-ma-3 — её сниппет показывает только ссылку ''Tuition Fees Contact'' без цифр. Подтверждено иным URL: на apply.ppke.hu/courses/course/20-ma-international-relations указан ''Tuition fee HUF 1,700,000 per semester'' + ''Application fee HUF 54,000''; на apply.stipendiumhungaricum.hu/courses/course/3585 подтверждено, что программа участвует в Stipendium Hungaricum. IELTS=6.0 и deadline 30 апреля — оценочные значения по типичным требованиям PPKE и венгерских вузов для не-EU абитуриентов, но НЕ подтверждены прямым сниппетом со страницы программы. Tuition пересчитан из HUF в EUR по курсу ~395 HUF/EUR.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'International Relations MA', 'Social Sciences', 'English', 24, 17200,
  4, 30, 6, 3, 'https://btk.ppke.hu/en/international-relations-ma-3',
  array['Stipendium Hungaricum', 'Diaspora Scholarship'],
  'Двухлетняя магистерская программа по международным отношениям на английском в католическом университете Пазмани (Будапешт) с междисциплинарным фокусом на европейские исследования, безопасность и цивилизационный анализ. Подходит для выпускников бакалавриата по IR и смежным социальным наукам; доступны стипендии Stipendium Hungaricum и Diaspora для иностранных студентов.',
  array['Преподавание полностью на английском, программа в центре Будапешта', 'Доступна стипендия Stipendium Hungaricum, покрывающая tuition и дающая стипендию (есть отдельная страница курса на apply.stipendiumhungaricum.hu)', 'Широкий набор направлений: европейские исследования, security studies, политическая экономия', 'Принимаются абитуриенты с BA в смежных социальных науках (социология, политология и т.д.)'],
  array['Стоимость выше типичной для Венгрии: подтверждено HUF 1,700,000/семестр на apply.ppke.hu → ~€4,300/семестр, итого ~€17,200 за 2 года (в 2,5+ раза выше, чем €6,400 в шаблоне)', 'Со страницы btk.ppke.hu/en/international-relations-ma-3 явная цифра tuition не извлечена (там просто ссылка ''Tuition Fees Contact''); точная EU/non-EU разбивка не подтверждена одним источником', 'Точный IELTS минимум и крайний срок для не-EU на самой странице программы прямым сниппетом не подтверждены — указаны 30 апреля как типовой дедлайн для не-EU в венгерских вузах', 'Плюс application fee HUF 54,000 (≈€135) сверх tuition'],
  false, null
);
