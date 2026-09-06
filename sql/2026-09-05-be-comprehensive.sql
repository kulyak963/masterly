-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Belgium (be) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, так как на одной странице не подтверждены все три ключевых параметра. IELTS 7.0 — подтверждено на официальной странице toelatingsvoorwaarden (onderwijsaanbod.kuleuven.be/opleidingen/e/SC_53419709/toelatingsvoorwaarden). Цена €6 400/год и дедлайн 1 апреля — оценочные значения на основе общей политики KU Leuven для не-EEA студентов (страница программы отсылает к отдельному разделу fees/admission, цифр в сниппете нет). Чтобы поставить verified=true, нужно открыть основную страницу программы и подраздел fees напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of Business Engineering', 'Business Analytics', 'English', 24, 6400,
  4, 1, 7, 3, 'https://www.kuleuven.be/programmes/master-business-engineering/index.html',
  array['KU Leuven Global Minds Scholarship (для не-EEA студентов)'],
  'Двухгодичная англоязычная магистратура KU Leuven в Лувене на стыке инженерии и бизнеса: сочетает технологическую, экономическую и управленческую подготовку. Один из топовых бельгийских вузов с сильной инженерной школой и доступом к брюссельской/европейской экосистеме.',
  array['Престижный диплом KU Leuven — вуз стабильно в топ-50 Европы (Times Higher Education, Shanghai Ranking)', 'Сильная программа на стыке бизнеса и инженерии, высокая трудоустраиваемость выпускников в Бельгии и ЕС', 'Возможность получения Global Minds Scholarship для не-EEA студентов (покрытие части обучения и страхования)'],
  array['IELTS 7.0 (не 6.0!) — подтверждено на официальной странице toelatingsvoorwaarden программы, требование выше, чем для большинства других магистратур KU Leuven', 'Точная стоимость для не-EU студентов на самой странице программы напрямую не указана (€6 400/год — оценка по общему не-EEA тарифу KU Leuven; полная двухлетняя стоимость ≈ €12 800)', 'Точная дата дедлайна для не-EEA на 2026/27 на странице не подтверждена в выдаче (указана ссылка на раздел ''admission/application''); использован типичный не-EEA дедлайн KU Leuven для англоязычных магистратур — 1 апреля', 'Для не-EEA требуется дополнительная процедура APS certificate и подтверждение финансовой состоятельности', 'GPA 3.0 — оценочное значение, прямого подтверждения на странице в выдаче не найдено'],
  false, null
);

-- Подтверждено с официальной страницы KU Leuven: требование IELTS 7.0 — на странице admission requirements (onderwijsaanbod.kuleuven.be/oplevingen/e/SC_54550446/toelatingsvoorwaarden). Дедлайн non-EU для англоязычных магистратур KU Leuven исторически приходится на ~1 марта, но точная дата на конкретный год на основной странице программы не указана — использована оценка. Стоимость для non-EU не указана явно на странице программы (только ссылка на tuition fee calculator), цифра €6400 — лучшая оценка исходя из типичной non-EU ставки FEB ~€3000–€3500/год × 2 года. verified=false, так как все три параметра (tuition+deadline+language) не подтверждены на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of International Business (Brussels)', 'Business Analytics', 'English', 24, 6400,
  3, 1, 7, 3, 'https://www.kuleuven.be/programmes/master-international-business',
  array[]::text[],
  'Двухгодичная магистерская программа KU Leuven факультета экономики и бизнеса, ориентированная на студентов без бизнес-образования; проводится в Брюсселе на английском, сочетающая академическую подготовку с практикой в международной среде.',
  array['Престиж KU Leuven и факультета FEB в Европе', 'Англоязычная программа с сильной международной средой', 'Расположение в Брюсселе — доступ к институтам ЕС и компаниям', 'Программа аккредитована, высокая трудоустраиваемость выпускников'],
  array['IELTS 7.0 — высокий порог, нужно готовиться серьёзно', 'Точная non-EU стоимость не подтверждена с той же страницы (на сайте ссылка на калькулятор), цифра ~€6400 за 2 года — оценочная (≈€3200/год), реальная может быть выше с учётом повышения non-EU ставок'],
  false, null
);

-- verified=false: подтверждена только сама программа и её длительность 60 ECTS (URL https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_51017073/diploma_omschrijving). Tuition4 100 EUR/год — взято как средняя non-EEA ставка KU Leuven (study.eu, цитата: ''average tuition fees for students from outside the EU/EEA are 4 100 EUR per year''), конкретная цифра именно для Business Economics может отличаться. Дедлайн 30 апреля — стандартный не-EEA дедлайн KU Leuven, но точную дату для этого конкретного цикла нужно перепроверить. IELTS 6.5 — общеуниверситетский минимум; на той же странице программы это не подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of Business Economics (Leuven)', 'Business Analytics', 'English', 12, 4100,
  4, 30, 6.5, 3, 'https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_51017073',
  array['KU Leuven Global Mind Scholarship (для не-EEA студентов, конкурсный, покрывает часть/полную стоимость)'],
  'Один год (60 ECTS) магистерской программы по бизнес-экономике в KU Leuven — одном из ведущих европейских исследовательских университетов, с возможностью специализации (International Business и др.), обучение на английском.',
  array['KU Leuven стабильно в топ-50 мировых рейтингов и #1 в Бельгии — сильный бренд для CV', 'Стоимость для не-EEA около 4 100 EUR/год — заметно ниже, чем в UK/США при сопоставимом качестве', 'Программа на английском, специализации позволяют углубиться в международный бизнес/финансы', 'Лёвен — компактный студенческий город рядом с Брюсселем (EU-хаб) и крупными корпорациями'],
  array['Не удалось подтвердить все три параметра (tuition/deadline/IELTS) на одной официальной странице — возможны неточности по конкретной сумме для этой программы (она может отличаться от среднего 4 100 EUR/год по вузу)', 'IELTS 6.5 — типовая планка KU Leuven, но Business Economics может требовать 7.0; точный минимум нужно сверить на admissions странице', 'Длительность 12 месяцев (60 ECTS), а не 24 — для двухлетней версии программы нужен отдельный код программы'],
  false, null
);

-- Verified=false: подтверждено только IELTS 7.0 (страница toelatingsvoorwaarden той же программы). Точная non-EU tuition и точный deadline для не-EEA на одной странице не найдены за один раунд поиска. Сумма 6000 EUR — оценочная на основе диапазона не-EEA тарифов KU Leuven (€1750–€7500/год) и характерной ставки для Economics-факультета; реальная цифра может быть4000 или 7500. Дедлайн 1 марта — типичный для англоязычных магистратур KU Leuven (не-EEA), но не подтверждён персонально для SC_51007574. Рекомендуется проверить https://www.kuleuven.be/application-windows с фильтром по Faculty of Economics and Business.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of Economics (Leuven)', 'Business Analytics', 'English', 24, 6000,
  3, 1, 7, 3, 'https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_51007574',
  array['KU Leuven Global Minds Scholarship (для не-EEA, конкурентный)', 'VLIR-UOS ICP Scholarships (для развивающихся стран)', 'Master Mind Scholarships (правительство Фландрии)'],
  'Англоязычная двухгодичная магистерская программа по экономике в KU Leuven — старейшем и одном из самых рейтинговых университетов Бенилюкса. Подходит выпускникам с сильной математической/экономической подготовкой.',
  array['KU Leuven стабильно в топ-50 мира (Times Higher Education), сильный бренд для карьеры в ЕС', 'Англоязычная программа с международным контингентом студентов', 'Возможность остаться в Бельгии после учёбы (Belgium offers 12-month job-seeker visa для выпускников)'],
  array['IELTS минимум 7.0 — заметно выше типичного порога 6.5 в европейских вузах; нужен высокий уровень английского', 'Точная non-EU ставка не подтверждена на странице программы; цифра 6000 EUR/год — оценочная (вероятный диапазон 4000–7500, потолок для не-EEA —7500/год по регламенту KU Leuven)', 'Дедлайн для не-EEA на англоязычных магистратурах KU Leuven жёсткий (обычно 1 марта), поздние заявки не принимаются', 'Минимальный GPA формально не опубликован; конкурс высокий, оценочный порог ~3.0/4.0'],
  false, null
);

-- Частично подтверждено: IELTS 7.0 — на странице toelatingsvoorwaarden для SC_54542934 (реальная ссылка из выдачи). Стоимость €9 493/год для non-EU взята со страницы topuniversities (агрегатор), на исходной странице KU Leuven точная разбивка EU/non-EU в сниппете не отобразилась. Дедлайн 30 апреля — типичный для англоязычных программ KU Leuven, но точная дата для non-EU именно по этой программе на одной странице не подтверждена, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of Business Administration (Brussels)', 'Business Analytics', 'English', 24, 9493,
  4, 30, 7, 3, 'https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_54542934',
  array[]::text[],
  'Годичная (фактически 24-месячная) программа MBA в кампусе KU Leuven в Брюсселе с фокусом на интернациональном бизнесе. Программа преподаётся на английском и ориентирована на студентов с опытом работы.',
  array['Престижный бельгийский диплом с сильной репутацией в Европе', 'Расположение в Брюсселе — доступ к европейским институтам и бизнес-среде'],
  array['Высокая стоимость для не-EEA студентов (≈€9 493/год по данным topuniversities)', 'Не удалось подтвердить точный дедлайн для не-EU абитуриентов на исходной странице SC_54542934 — оценка основана на общем окне приёма KU Leuven для не-EEA (≈1 февраля для голландских программ, позже для английских)'],
  false, null
);

-- IELTS минимум 7.0 подтверждён на официальной подстранице toelatingsvoorwaarden того же ID SC_54533410 (найдено в поиске). Различие сборов EU/не-EU подтверждено общей страницей fees KU Leuven и страницей FEB study costs (база €835 + не-EU надбавка ≈ €4175 в год ≈ €5010/год для 2-летней программы — около €10 020 итого; topuniversities.com цитирует €9 493/год, что слегка расходится). Точная сумма tuition именно для MBA Antwerp и точный deadline для не-EU абитуриентов не были найдены на одной и той же странице в первом раунде поиска, поэтому verified=false; значение 6400 EUR из шаблона не подтвердилось — фактический годовой сбор для не-EU значительно выше. Дедлайн 30 апреля — типичный не-EU deadline KU Leuven, но требует верификации.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e5719d8-89a3-431f-bb82-5d4fb79d3d71',
  'Master of Business Administration (Antwerp)', 'Business Analytics', 'English', 24, 5010,
  4, 30, 7, 3, 'https://onderwijsaanbod.kuleuven.be/opleidingen/e/SC_54533410',
  array['KU Leuven Master Mind Scholarship (исторически доступна, нужно проверять на год поступления)'],
  'Годичная магистратура по бизнес-администрированию в кампусе KU Leuven в Антверпене, преподаётся на английском. Программа факультета экономики и бизнеса (FEB) ориентирована на подготовку менеджеров с акцентом на европейский и международный контекст.',
  array['Преподавание полностью на английском, признаваемый диплом KU Leuven (топ-вуз Бенилюкса)', 'Расположение в Антверпене — крупном портовом и бизнес-хабе, хорошие нетворкинг-возможности', 'Доступ к стипендии KU Leuven Master Mind для не-ЕС студентов при выдающейся успеваемости'],
  array['Требование IELTS 7.0 (не 6.0) — выше среднего, нужно подтверждение из официальной страницы toelatingsvoorwaarden', 'Точная сумма tuition для не-ЕС на 2026/27 академический год не подтверждена в одном источнике вместе с дедлайном и IELTS, поэтому verified=false'],
  false, null
);

-- verified=false, так как tuition (€7079/год с mastersportal.com), deadline (апрель, с globaladmissions.com) и IELTS 6.5 (studyabroadupdates.com) взяты с трёх разных страниц и не подтверждены единым официальным источником. Официальная страница программы studiekiezer.ugent.be существование программы подтверждает, но конкретные цифры для non-EEA на ней в выдаче не раскрыты. Официальный документ ugent.be 2026-2027 показывает €16000/год для non-EEA на обычных магистратурах — этот разнобой отдельно отмечен в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Science in Biomedical Sciences', 'Biotechnology', 'English', 24, 7079,
  4, 30, 6.5, 3, 'https://studiekiezer.ugent.be/2025/master-in-biomedical-sciences-en/starten',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа Университета Гента в области биомедицинских наук (120 ECTS). Программа охватывает молекулярную биологию, биохимию, физиологию и исследовательскую работу; стоимость для не-EEA студентов около €7079/год, IELTS 6.5.',
  array['Престижный бельгийский исследовательский университет с сильной школой биомедицины', 'Полностью на английском, 120 ECTS за 2 года, прямой доступ к лабораториям и исследовательским группам'],
  array['Точная non-EU ставка в разных источниках расходится: mastersportal указывает ~€7079/год, тогда как официальный раздел tuition ugent.be показывает €16000/год для non-EEA на не-продвинутых магистратурах — цифры не подтверждены на одной странице'],
  false, null
);

-- URL studiekiezer.ugent.be подтверждён в поисковой выдаче как официальная страница программы на 2026 год. Стоимость €3,879 для не-EU студентов найдена в стороннем справочнике EHMA (ehma.org/where-to-study-health-management), а не на самой странице studiekiezer, поэтому нельзя подтвердить tuition+deadline+IELTS единым первоисточником — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Science in Health Care Management and Policy', 'Business Analytics', 'English', 24, 3879,
  4, 30, 6, 3, 'https://studiekiezer.ugent.be/2026/master-of-science-in-health-care-management-and-policy',
  array[]::text[],
  'Магистерская программа Гентского университета по управлению и политике здравоохранения (2 года, 120 ECTS), ориентированная на менеджмент медицинских учреждений и анализ политики в сфере здравоохранения.',
  array['Сильная специализация на менеджменте и политике здравоохранения, востребованная в ЕС', 'Возможность изучать до 6 ECTS на других магистерских программах Гентского университета'],
  array['Точная не-EU стоимость обучения и крайний срок подачи для международных студентов на официальной странице studiekiezer в выдаче не подтверждены единым блоком; цифра €3,879 взята из внешнего источника EHMA и может быть устаревшей для 2026'],
  false, null
);

-- verified=false, потому что на одной и той же странице программы не подтверждены все три параметра одновременно. ПОДТВЕРЖДЕНО: программа существует (ugent.be/ps/en/education/programmes/master-of-science-in-sociology.htm); факультет — Political and Social Sciences (PS); длительность 2 года / 120 ECTS. СТОИМОСТЬ: для non-EEA студентов €7079.40/год взята с официального PDF факультета PS (ugent.be/ps/en/degree-students/tuition_fee_non_eea, 2026-27) — формула: €305.40 фикс + €31/кредит + €81.90/кредит надбавка, для 60 кредитов = €7079.40. Это отличается от €16 000/год, которая указана для Master''s in Teaching на отдельной странице. НЕ ПОДТВЕРЖДЕНО ПРЯМО: дедлайн (использован стандарт UGent для non-EEA — 30 апреля) и IELTS (использован стандарт UGent — 6.0). GPA min 3.0 — оценка по шкале 4.0, так как UGent формально GPA не указывает, требуя диплом с отличием.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Science in Sociology', 'Social Sciences', 'English', 24, 7079,
  4, 30, 6, 3, 'https://www.ugent.be/ps/en/education/programmes/master-of-science-in-sociology.htm',
  array[]::text[],
  'Двухлетняя (120 кредитов) англоязычная магистерская программа по социологии в Гентском университете на факультете политических и социальных наук с упором на продвинутые количественные методы исследования.',
  array['Сильная исследовательская среда и топовый бельгийский вуз', 'Полностью англоязычная программа с фокусом на advanced quantitative methods', 'Гент — студенческий город с относительно доступной стоимостью жизни по сравнению с Брюсселем'],
  array['Точный дедлайн для international degree students и минимальный IELTS не подтверждены напрямую с одной и той же страницы программы — указаны стандартные значения UGent'],
  false, null
);

-- verified=false: на официальной странице UGent (https://www.ugent.be/ps/en/education/programmes/emgs) tuition для non-EU НЕ указан — Гент явно пишет, что оплата определяется Лейпцигом как координатором, поэтому нельзя подтвердить все три поля (tuition+deadline+IELTS) на ОДНОЙ указанной странице. Самостоятельно подтверждено только: self-funded дедлайн 31 мая 2026, 23:59 CET (источники: globalstudies-masters.eu и scholarships.af), scholarship-дедлайн 28 февраля 2026 (scholarships.af и LinkedIn EMGS). IELTS 6.5 — стандартное требование консорциума EMGS, но точная цифра не извлечена из сниппетов в одной выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Arts in Global Studies (Erasmus Mundus EMGS)', 'Social Sciences', 'English', 24, 6400,
  5, 31, 6.5, 3, 'https://globalstudies-masters.eu/',
  array['Erasmus Mundus full scholarship (tuition + ~€1400/month stipend + travel + insurance)'],
  'Совместная магистратура Erasmus Mundus по глобальным исследованиям координируется Лейпцигским университетом; Гент — один из ключевых партнёров (мобильность в 3-м семестре). Программа длится 2 года, междисциплинарная, с обязательной мобильностью между несколькими европейскими вузами.',
  array['Полная стипендия Erasmus Mundus покрывает обучение, страховку, перелёт и выплачивает ~€1400/мес', 'Междисциплинарная программа с ротацией между Лейпцигом, Гентом, Роскилле и другими партнёрами', 'Диплом координирующего вуза (Лейпциг) признаётся в нескольких странах ЕС'],
  array['Точная сумма tuition для non-EU без стипендии не подтверждена с одной официальной страницы (страница UGent прямо пишет: ''Tuition fees are handled by the coordinating institution — Leipzig University''); €6400 — лучшая доступная оценка, но не верифицирована на одной странице', 'Стипендиальный дедлайн (28 февраля) жёстче, чем self-funded (31 мая), и требует сильного пакета'],
  false, null
);

-- verified=false: не удалось найти одну страницу UGent, где одновременно подтверждены точные три пункта (tuition/deadline/IELTS) именно для non-EU студентов на 2026/27. Дедлайн «1 апреля для нуждающихся в визе» подтверждён на studiekiezer.ugent.be (страница 2026) и на общей странице дедлайнов ugent.be/prospect/en/administration/application/application-degree/deadlines.htm. IELTS 6.5 (min 5.5 по субскорам) подтверждён агрегатором studyabroadupdates.com со ссылкой на программу. Точная non-EEA tuition на 2026/27 не подтверждена одной страницей: на странице UGent 2024-2025 указано €16 000/год для не-EEA, на mastersportal — €7 079/год (вероятно устаревшее), общий ориентир UGent 2025-2026 для не-EEA магистров ~€6 400/год — использован как оценка. Реальный URL конкретной программы — studiekiezer.ugent.be/master-of-science-in-conflict-and-development-KMCODT-en (а не ugent.be/ps/en, который ведёт на факультет).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cd8bea44-1207-4eda-bf72-5e96f3648360',
  'Master of Science in Conflict and Development Studies', 'Social Sciences', 'English', 12, 6400,
  4, 1, 6.5, 3, 'https://studiekiezer.ugent.be/master-of-science-in-conflict-and-development-KMCODT-en',
  array[]::text[],
  'Годовая междисциплинарная магистерская программа в Гентском университете по конфликтологии и развитию. Подходит для выпускников социологии, политологии, права, истории и смежных дисциплин; преподавание на английском.',
  array['Интенсивная одногодичная программа с сильной междисциплинарной базой (право, политика, экономика развития)', 'Возможные стипендии и сниженные ставки для отдельных категорий иностранных студентов (уточнять на сайте UGent)', 'Признанный европейский диплом, сильная исследовательская среда факультета'],
  array['Стоимость для не-EEA студентов значительно выше, чем для EU/EEA (по общему правилу UGent не-EEA ≈ несколько тысяч евро/год), точную цифру на 2026/27 найти на одной странице не удалось — оценка приблизительная', 'Дедлайн для студентов, которым нужна виза, — 1 апреля (а не 30 апреля, как иногда ошибочно указывают агрегаторы); кто без визы — 1 июня', 'IELTS минимум 6.5 (не 6.0), с субскорами не ниже 5.5 — агрегаторы иногда занижают требование', 'По данным самого факультета (ugent.be/ps/conflict-ontwikkeling/en), admission requirements «currently under revision» — правила приёма могут меняться'],
  false, null
);

-- Дедлайн 31 марта 2026 для non-EEA подтверждён на самой странице VUB по админиссии программы. Стоимость €5720/год для non-resident подтверждена на mastersportal.com (страница именно этой программы, ID 9042). IELTS 6.5 (минимум 6.0 по секциям) подтверждён через globaladmissions.com. Поскольку все три параметра (tuition, deadline, language) не подтверждены на одной и той же официальной странице VUB в одном сниппете — verified=false. Фактически данные согласованы между источниками.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in International Business', 'Business Analytics', 'English', 24, 5720,
  3, 31, 6.5, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-international-business/master-international-business-admission-enrolment',
  array[]::text[],
  'Двухгодичная магистерская программа VUB по международному бизнесу на английском языке в Брюсселе. Для не-EEA студентов действует повышенная ставка ~€5720/год и ранний дедлайн подачи документов — 31 марта.',
  array['Удобное расположение в Брюсселе — столице ЕС и крупном бизнес-хабе', 'Английский язык обучения и международная среда'],
  array['Дедлайн для не-EEA студентов ранний (31 марта) — нужно готовить документы сильно заранее', 'Фиксированной стипендии именно по этой программе в открытых источниках не подтверждено'],
  false, null
);

-- Частично подтверждено: официальная страница программы (vub.be/en/.../master-management-admission-enrolment) найдена и существует. Дедлайн1 апреля для non-EEA подтверждён общей политикой VUB (apply before 1 April для иностранных дипломов). IELTS 6.5 (мин. 6.0 по каждой части) — общий стандарт VUB для магистратур. Точная сумма tuition для конкретно Master of Science in Management на non-EEA не подтверждена в результатах поиска, использована оценка ~€3200/год (€6400 за 2 года) на основе диапазона VUB. verified=false, так как tuition не подтверждён на той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Management', 'Business Analytics', 'English', 24, 6400,
  4, 1, 6.5, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-management/master-management-admission-enrolment',
  array['VUB Master Mind Scholarship (fully funded, для высококвалифицированных иностранных студентов)'],
  'Двухгодичная магистерская программа Master of Science in Management в Vrije Universiteit Brussel на английском языке. Расположена в Брюсселе, столице ЕС и крупном деловом центре.',
  array['Расположение в Брюсселе — доступ к институтам ЕС и международным компаниям', 'Программа на английском языке, подходит для иностранных студентов', 'Умеренная стоимость обучения для non-EEA студентов по сравнению с другими бельгийскими и европейскими бизнес-школами', 'Возможность получения стипендии VUB Master Mind'],
  array['Точная стоимость обучения для non-EEA студентов на странице программы не указана напрямую — цифра оценена на основе общего диапазона VUB (€4850–10000/год)', 'Дедлайн для иностранных студентов с зарубежным дипломом — 1 апреля (очень ранний срок)', 'Минимальный балл GPA указан неявно, официальное требование — эквивалент бельгийского диплома'],
  false, null
);

-- GPA 3.0 и IELTS 6.5 (общий, с 6.0 по каждой секции) подтверждены на официальной admission-странице VUB для Business & Technology и на общей странице языковых требований VUB. Дедлайн 31 марта для non-EEA подтверждён на globaladmissions.com/VUB. Точная цифра tuition именно для этой программы на одной официальной странице НЕ подтверждена — VUB даёт диапазон €835–€5000+/год для non-EEA магистров; 6400 EUR принят как оценка (вероятно годовая), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Business Engineering: Business & Technology', 'Business Analytics', 'English', 24, 6400,
  3, 31, 6.5, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-business-engineering-business-technology/master-business-engineering-business-technology-admission-enrolment',
  array[]::text[],
  'Двухгодичная магистерская программа VUB на стыке бизнеса и технологий с сильным фокусом на технологическое предпринимательство; рассчитана на иностранных студентов с инженерным или экономическим бэкграундом.',
  array['Умеренная стоимость обучения по сравнению с англоязычными программами в США/UK', 'Брюссель как мультикультурная бизнес-столица ЕС — сильные стажировки и нетворкинг', 'Программа официально на английском, IELTS 6.5 — достижимый порог'],
  array['Точная цифра tuition именно для Business Engineering не подтверждена на одной официальной странице — VUB публикует non-EEA ставки в формате ''от X до Y EUR/год'', поэтому6400 EUR приведён как лучшая оценка', 'Дедлайн для non-EU — 31 марта (жёстче, чем апрель у многих других бельгийских вузов)', 'Стипендии для этой конкретной программы в открытом доступе не перечислены'],
  false, null
);

-- URL ведёт на официальную страницу VUB о поступлении именно в Master of Science in Applied Sciences and Engineering: Applied Computer Science. Поисковая выдача подтвердила наличие страницы и отдельного tuition-fees раздела VUB, однако не предоставила одной официальной страницы, где одновременно для non-EEA/non-EU студентов были бы указаны tuition 6400 евро, дедлайн 30 апреля и IELTS 6.0. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Applied Sciences and Engineering: Applied Computer Science', 'Computer Science', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-applied-sciences-and-engineering-applied-computer-science/master-applied-sciences-and-engineering-applied-computer-science-admission-enrolment',
  array[]::text[],
  'Очная двухлетняя программа VUB по прикладной компьютерной науке. Для иностранных студентов указана ориентировочная стоимость обучения 6400 евро в год, заявка подаётся до 30 апреля; требование по английскому языку — IELTS 6.0.',
  array['Программа рассчитана на 24 месяца и даёт инженерную подготовку в области интеллектуальных систем и data science.', 'Официальная страница VUB отдельно описывает поступление и требования для иностранных дипломов.'],
  array['Стоимость 6400 евро, дедлайн 30 апреля и IELTS 6.0 не были подтверждены одновременно на одной официальной странице поисковой выдачей;雅思的具体分项要求 и актуальный год набора требуют проверки перед подачей.', 'Минимальный средний балл 3.0 указан как ориентир GPA и может зависеть от системы оценивания диплома.'],
  false, null
);

-- Основная страница VUB (известный URL) подтверждает название программы, двухлетнюю длительность и наличие AI/Data Science профилей. На mastersportal.com указана tuition 5720 EUR/year для не-EEA (приведено приблизительно), а срок подачи для non-EEA с зарубежным дипломом — 31 марта (по разделам VUB о дедлайнах приёма). Однако IELTS-минимум 6.0 и точная не-EEA плата не подтверждены напрямую на самой странице программы VUB, поэтому verified=false. Финальная стоимость может варьироваться по годам; рекомендую уточнять на vub.be/en/studying-vub/practical-info-for-students/how-much-does-studying-cost/tuition-fees.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Applied Informatics: Artificial Intelligence and Data Science', 'Artificial Intelligence', 'English', 24, 5720,
  3, 31, 6, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-applied-informatics-artificial-intelligence-data-science',
  array[]::text[],
  'Двухгодичная магистерская программа VUB в Брюсселе на английском языке по прикладной информатике с двумя профилями — Artificial Intelligence и Big Data Technology. Подходит для выпускников бакалавриата по информатике/Computer Science, готовит к работе в индустрии ИИ и данных.',
  array['Англоязычная программа в Брюсселе (столица ЕС, мультикультурная среда)', 'Сильный акцент на практических аспектах AI и Data Science в индустрии'],
  array['Подтверждена не вся тройка фактов на одной странице: точная сумма для не-EEA студентов и IELTS-минимум не зафиксированы напрямую на основной странице программы; verified=false'],
  false, null
);

-- Verified=false: на официальной странице Admission & Enrolment для Master Electrical Engineering VUB tuition указан как ориентировочный диапазон €800–€3000 в год (не фиксированная сумма), конкретный дедлайн в сниппете обрезан (''Applications must be…''), а IELTS 6.5 взят со стороннего агрегатора globaladmissions, а не с vub.be. Поэтому verified=true поставить нельзя — все три поля (tuition/deadline/language) не подтверждены на ОДНОЙ странице vub.be. Оценка tuition_eur=4000 — середина диапазона за 2 года; дедлайн 1 апреля — типичный крайний срок VUB для non-EU абитуриентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Electrical Engineering', 'Computational Engineering', 'English', 24, 4000,
  4, 1, 6.5, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-electrical-engineering/master-electrical-engineering-admission-enrolment',
  array[]::text[],
  'Совместная магистерская программа VUB (Брюссель) по электротехнике длительностью 24 месяца на английском языке. Для студентов вне ЕС/ЕЭЗ указана ориентировочная стоимость обучения, окончательная сумма пересчитывается ежегодно совместно двумя вузами-партнёрами.',
  array['Англоязычная программа в Брюсселе — международная среда и доступ к европейскому хабу технологий и политики', 'Совместная программа с партнёрским бельгийским университетом — расширенная исследовательская база и преподаватели'],
  array['Точная сумма tuition для non-EEA указана как диапазон €800–€3000/год и пересчитывается ежегодно — нельзя назвать фиксированную цифру', 'Дедлайн и точные требования по IELTS не подтверждены на одной официальной странице программы (verified=false)'],
  false, null
);

-- Подтверждено на одной странице: IELTS 6.5 (academic) и крайний срок 31 марта для не-EEA абитуриентов — оба указаны на странице admission конкретной программы. Tuition для non-EU точно на этой странице не указан (VUB публикует общий диапазон €4850–10000/год для магистратур; €6400 — середина диапазона для инженерии), поэтому verified=false. Дедлайн в JSON поставлен 31 марта (месяц 3), а не 30 апреля как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master in Civil Engineering', 'Computational Engineering', 'English', 24, 6400,
  3, 31, 6.5, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-civil-engineering/master-civil-engineering-admission-enrolment',
  array[]::text[],
  'Магистерская программа VUB по гражданскому строительству (Master of Science in Civil Engineering), 120 кредитов ECTS, 2 года, преподаётся на английском. Университет в Брюсселе, активно сотрудничает с промышленностью и Bruface (совместная программа с Université Libre de Bruxelles).',
  array['Англоязычная программа в столице ЕС, диплом признаётся по всей Европе', 'Совместная инженерная школа Bruface с ULB — сильная техническая база и связи с индустрией', 'Умеренная плата для не-EEA студентов по сравнению с Anglo-Saxon университетами'],
  array['Точный non-EU тариф для Civil Engineering на одной странице с программой не подтверждён — публикуется общий диапазон €4850–10000/год; приведённая цифра €6400 — оценка по диапазону VUB для инженерных магистратур', 'Приём документов от не-EEA закрывается 31 марта, что раньше многих европейских вузов — нужно готовиться заранее'],
  false, null
);

-- verified=false. Найдено: главная страница программы (vub.be) и страница admission & enrolment; MastersPortal указывает non-resident fee €5720/год для этой программы; Brussels Times (29.06.2026) сообщает о надбавке €400–1000+ для не-EU в VUB; VUB central deadlines — ''apply before 1 April'' для не-EU; VUB общий минимум English — IELTS 6.0 / TOEFL iBT 79. Три ключевых параметра (tuition + deadline + IELTS) для конкретно не-EU студентов не подтверждены на одной странице — использована лучшая доступная оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '61143918-8c72-42b0-97eb-df49164cae04',
  'Master of Science in Business & Technology', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.vub.be/en/studying-vub/all-study-programmes-vub/bachelors-and-masters-programmes-vub/master-business-engineering-business-technology/master-business-engineering-business-technology-programme',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа VUB на стыке бизнеса и технологий в Брюсселе. Подходит инженерам и экономистам, желающим работать в технологическом секторе и предпринимательстве.',
  array['Англоязычная программа в Брюсселе — крупном технологическом и бизнес-хабе ЕС', 'Умеренная для не-ЕС студентов стоимость по сравнению с бельгийскими частными вузами'],
  array['Точная сумма tuition для не-EEA на одной странице не подтверждена (€5720/год по MastersPortal + надбавка €400–1000 по Brussels Times 2026 → оценка ~€6400/год); единый официальный non-EU тариф именно для этой программы не найден', 'verified=false: дедлайн 30 апреля и IELTS 6.0 — типичные значения для VUB, но не подтверждены одной страницей именно для Business & Technology'],
  false, null
);

-- verified=false: на странице самого курса (ulb.be/en/programme/ma-gest) в поисковой выдаче видно только заголовок; полных данных о дедлайне и IELTS оттуда не извлечено. Подтверждено отдельно на странице оплаты ULB (ulb.be/en/enrolment/tuitions-fees): не-ЕС студенты платят €1 194 + €4 175 = €5 369/год → ~€10 738 за 24 месяца. Дедлайн 30 апреля — стандартный ориентир для не-ЕС аппликантов ULB (по сторонним источникам и для некоторых программ Solvay), но не подтверждён именно для ma-gest. IELTS 6.0 — типовое нижнее требование ULB. Общий вывод: плата надёжна, дедлайн и язык — требуют ручной проверки на указанной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Management Science', 'Business Analytics', 'English', 24, 10738,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ma-gest',
  array[]::text[],
  'Двухгодичная магистерская программа по менеджменту в ULB (Solvay Brussels School). Ориентирована на иностранных студентов, преподавание частично на английском, диплом бельгийского государственного вуза.',
  array['Преподавание в ULB/Solvay — вуз с высокой международной репутацией, особенно в менеджменте и экономике', 'Чётко фиксированная для Бельгии доплата для не-ЕС студентов (€4 175/год) — стоимость понятна заранее', 'Расположение в Брюсселе — крупный европейский деловой и политический хаб, удобно для стажировок'],
  array['Не удалось подтвердить дедлайн и требование IELTS непосредственно на странице программы ma-gest — данные взяты из общей страницы оплаты ULB и сторонних источников', 'Программа ведётся в Solvay Brussels School of Economics and Management, где фактическая плата может отличаться от стандартного тарифа ULB и быть выше (от €16 000+/год по данным агрегаторов) — уточнять напрямую', 'Официальный язык программы — французский (с английскими треками): сдавать IELTS нужно под выбранную специализацию, реальный проходной балл может быть выше 6.0'],
  false, null
);

-- С официального URL ulb.be/en/programme/ma-inge подтверждено: длительность 2 года (120 кредитов), языки английский/французский, тип Master. Стоимость для не-ЕС ~€5 369/год (= €1 194 базовый + €4 175 надбавка) подтверждена несколькими источниками (college-council.com, llm-guide.com, общий ULB enrolment page), но не на той же странице программы. IELTS 6.0 — типичный минимум ULB для англоязычных программ, но точный порог для MA-INGE не извлечён с той же страницы. Поскольку tuition + deadline + language не подтверждены для не-ЕС на одной странице — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Business engineering', 'Business Analytics', 'English', 24, 5369,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ma-inge',
  array[]::text[],
  'Магистерская программа ULB по бизнес-инжинирингу на 120 кредитов, длительность 2 года, обучение на английском и французском; ведётся совместно с Solvay Brussels School of Economics and Management.',
  array['Программа присутствует в рейтинге Financial Times Masters in Management (Solvay)', 'Возможность обучения на английском языке для иностранных студентов', 'Бельгийский диплом европейского образца, признаваемый в ЕС'],
  array['Точная стоимость для не-ЕС зависит от трека: стандартный ULB (~€5 369/год) или премиум-трек Solvay (значительно выше); на той же странице не указана явно', 'Дедлайн для не-ЕС (30 апреля) указан как типичный, но точная дата с официальной страницы программы не извлечена'],
  false, null
);

-- Не полностью верифицировано (verified=false): стоимость €5369 для не-ЕС (€1194 + €4175 доплата) подтверждена из нескольких сторонних источников (llm-guide.com, college-counsel.com), но не с конкретной страницы ma-econ. IELTS 6.5 — общий стандарт ULB (gotouniversity.com, pathorient.com). Дедлайн 30 апреля — типичный для ULB, но точно на странице ma-econ не подтверждён. Страница ma-econ упоминает обязательность GMAT/GRE для не-ЕС бакалавров.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Economics : General', 'Business Analytics', 'English', 24, 5369,
  4, 30, 6.5, 3, 'https://www.ulb.be/en/programme/ma-econ',
  array[]::text[],
  'Магистратура по экономике общего профиля в Свободном университете Брюсселя (ULB) на английском языке, длительностью 2 года. Программа требует сильную техническую и аналитическую подготовку.',
  array['Расположение в Брюсселе — столице ЕС, хорошие карьерные перспективы', 'Английский язык обучения, интернациональная среда', 'Умеренная стоимость для не-ЕС студентов по сравнению с другими европейскими программами'],
  array['Для не-ЕС студентов с бакалавриатом вне ЕС обязательны GMAT или GRE', 'Конкретный дедлайн и точная стоимость для не-ЕС на странице программы не подтверждены — данные взяты из общей информации ULB', 'Минимальный IELTS по общим требованиям ULB — 6.5, а не 6.0 как указано в шаблоне'],
  false, null
);

-- verified=false, так как на странице https://www.ulb.be/en/programme/ma-ecoe подтверждена только разовая административная пошлина €200 для не-ЕС абитуриентов. Стоимость обучения (€1 194 базовый tuition + €4 175 DIS = €5 369/год) взята со страницы https://www.ulb.be/en/enrolment/tuitions-fees и подтверждена сторонними источниками (llm-guide.com, studacy.com). Дедлайн 30 апреля для не-ЕС — со страницы https://www.ulb.be/en/enrolment/submit-an-application (стандартная политика ULB, на странице самой программы не указан). IELTS 6.0 — общепринятый минимум ULB для англоязычных магистратур, на странице MA-ECOE конкретный балл не указан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Economics : Econometrics', 'Business Analytics', 'English', 24, 5369,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ma-ecoe',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по эконометрике в Свободном университете Брюсселя (ULB) на стыке экономики, статистики и анализа данных. Программа ориентирована на подготовку исследователей и аналитиков с сильной количественной базой.',
  array['Английский язык обучения, программа без требования знания французского для поступления', 'Умеренная стоимость для не-ЕС по сравнению с англоязычными магистратурами в Западной Европе (около €5 369/год)', 'Брюссель — крупный центр европейских институтов и международных организаций, хорошие карьерные перспективы'],
  array['Точные суммы tuition, deadline и IELTS подтверждены не на одной странице программы, а на разных разделах сайта ULB (verified=false)', 'Помимо tuition €5 369/год не-ЕС студенты платят разовый административный сбор €200 и обязательный взнос DIS (~€4 175/год), итоговая стоимость за 2 года — около €11 000+', 'Дедлайн для не-ЕС (~30 апреля) значительно раньше, чем для граждан ЕС (30 сентября), нужно планировать подачу документов заранее'],
  false, null
);

-- URL программы (https://www.ulb.be/en/programme/ms-gest) подтверждён поиском. На этой странице в сниппетах найдено только название и общее описание (120 кредитов, требование диплома 2-го цикла / 240 кредитов). Точные цифры по学费 для non-EU, точная дата дедлайна и IELTS на той же странице НЕ подтверждены в одном раунде поиска. Оценки: ~€6 400 для non-EU (типичный диапазон Solvay Specialized Master), дедлайн ~30 апреля (стандарт ULB для не-ЕС), IELTS 6.0 (типичный минимум ULB). verified=false, так как все три параметра не найдены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Specialized Master in Industrial and technological management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ms-gest',
  array[]::text[],
  'Специализированный магистр ULB/Solvay по промышленному и технологическому менеджменту: вечерняя/part-time программа для инженеров и менеджеров, длительность ~2 года (120 кредитов), с возможностью специализации (Finance, Marketing, Project Management).',
  array['Престиж школы Solvay Brussels School of Economics and Management при ULB', 'Программа рассчитана на работающих специалистов — занятия вне офисных часов', 'Сильный акцент на стыке инженерии и управления, несколько опций специализации'],
  array['Конкретная стоимость для non-EU, дедлайн и требования по IELTS не подтверждены на одной странице программы — цифры приведены как оценка по ULB/Solvay; verified=false', 'Программа преимущественно на французском (часть курсов может быть на англ., но нужно уточнять для non-EU)', 'Доплата для не-ЕС студентов в ULB стандартно составляет ~€4 175 сверх базового взноса'],
  false, null
);

-- verified=false: на странице https://www.ulb.be/en/programme/ma-info и связанных ULB-страницах в одной выдаче не удалось одновременно найти (а) точную годовую плату для не-ЕС именно по MA-INFO, (б) подтверждённый GPA-минимум, (в) IELTS-минимум конкретно для MA-INFO. Что подтверждено: дедлайн 30 апреля для иностранных магистров (https://www.ulb.be/en/prepare-your-application/submission-deadlines, https://www.studyineurope.eu/study-in-belgium/application-deadlines/), общий IELTS 6.5 как стандарт ULB (llm-guide.com), разделение EU/не-EU по оплате (https://www.ulb.be/en/enrolment/tuitions-fees). Оплата €4175 — оценка по типичной ULB не-ЕС ставке для STEM-магистров, не точная цифра.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Computer Science (MA-INFO)', 'Computer Science', 'English', 24, 4175,
  4, 30, 6.5, 3, 'https://www.ulb.be/en/programme/ma-info',
  array['ULB Excellence Scholarships (limited, merit-based, for non-EU)', 'ARES-CCD scholarships (Belgian development cooperation, country-specific)', 'Erasmus Mundus joint masters (if applicable via consortium)'],
  'Двухгодичная магистерская программа по информатике в Université libre de Bruxelles — крупном франкоязычном университете Брюсселя. Обучение ведётся преимущественно на французском, часть курсов на английском; для не-ЕС студентов отдельная (повышенная) ставка оплаты. Дедлайн подачи документов для иностранцев — 30 апреля.',
  array['Сильная школа CS в Брюсселе, доступ к европейским IT-компаниям и институтам EC (EPFL/IMEC-сотрудничество, AI-исследования)', 'Умеренная плата для не-ЕС по сравнению с англоязычной Северной Европой (Нидерланды, Швеция)', 'Брюссель как мультикультурный город с низкими (для столицы ЕС) расходами на жизнь', 'Доступны стипендии ULB Excellence и ARES для не-ЕС абитуриентов'],
  array['Точный размер оплаты для не-ЕС по MA-INFO на странице программы в выдаче не подтвердился — привожу типичный для ULB не-ЕС диапазон (~€4000-4200/год), реальную цифру нужно уточнять у факультета', 'Большая часть курсов на французском, IELTS 6.5 подходит не для всех дисциплин — для некоторых курсов нужен продвинутый французский', 'Дедлайн 30 апреля жёсткий для не-ЕС из-за визовой процедуры, рекомендуют подавать к 1 марта', 'Минимальный GPA не указан явно на странице программы — оценка 3.0 (≈B) дана как общее конкурсное ожидание'],
  false, null
);

-- verified=false, так как на официальной странице ulb.be/en/programme/m-irifs не удалось подтвердить конкретную не-EU ставку, IELTS-минимум и дедлайн одновременно. Дедлайн 30 апреля взят из gotouniversity и логически соответствует окну подачи для не-ЕС (визовые студенты), но €835/год — это агрегаторская цифра, а часть источников называет для не-ЕС ULB гораздо более высокие суммы (~€5 369/год). IELTS6.5 указан по общим данным ULB, не из карточки программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master of Science in Computer Science and Engineering (M-IRIFS)', 'Computer Science', 'English', 24, 1670,
  4, 30, 6.5, 3, 'https://www.ulb.be/en/programme/m-irifs',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа ULB по компьютерным наукам и инженерии (120 кредитов). Дедлайн для не-ЕС студентов — 30 апреля (для оформления визы), обучение стоит заметно дешевле среднего по Бельгии.',
  array['Англоязычная программа в топовом брюссельском университете', 'Очень низкая стоимость обучения для не-ЕС — около €835/год по данным gotouniversity'],
  array['Точная не-EU ставка именно для M-IRIFS не подтверждена на официальной странице программы — цифра €835/год взята из агрегатора gotouniversity и косвенно подтверждена постом о ULB', 'В одних источниках для не-ЕС студентов ULB указывают сумму ~€5 369/год (с надбавкой €4 175) — возможно, реальная ставка выше; требует уточнения у приёмной комиссии'],
  false, null
);

-- verified=false: со страницы polytech.ulb.be/en/studies/masters/computer-science и связанного раздела polytech.ulb.be/en/international/incoming-students в выдаче подтверждены только название программы и дедлайн для non-EU (31 марта, со страницы incoming-students). Точные цифры tuition для non-EU и требование IELTS в результатах поиска не зафиксированы, поэтому tuition и ielts указаны как типичные оценки для ULB и требуют ручной проверки на странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'MSc in Computer Science Engineering - Ecole polytechnique de Bruxelles', 'Computer Science', 'English', 24, 6400,
  3, 31, 6, 3, 'https://polytech.ulb.be/en/studies/masters/computer-science',
  array[]::text[],
  'Двухгодичная магистерская программа (120 ECTS) по компьютерной инженерии в ULB/École polytechnique de Bruxelles, преподаётся на английском, готовит инженеров в области вычислительного интеллекта, веб/информационных систем и разработки ПО.',
  array['Англоязычная программа в бельгийской столице — относительно доступная точка входа в ЕС', 'Дедлайн для иностранных студентов (31 марта) подтверждён на странице EPB для incoming students', 'Брюссель как локация: много англоязычных IT-компаний и международная среда'],
  array['Точная стоимость обучения для non-EU студентов на странице программы в результатах поиска не подтверждена — указана оценочная цифра ~6400 EUR/год, требует уточнения на polytech.ulb.be', 'Конкретный балл IELTS и минимальный GPA со страницы программы также не извлечены из поисковой выдачи — указаны типичные требования ULB (IELTS 6.0), нужна верификация', 'Стипендии, специфичные для этой программы, в результатах поиска не обнаружены'],
  false, null
);

-- Подтверждено: страница программы существует по URL https://www.ulb.be/en/programme/ms-bgda (контакт ms-bgda@ulb.be, тел. +32 2 650 58 92), программа — Specialized Master. Двухгодичный формат косвенно подтверждён LinkedIn-профилем координатора (2025–2027). Не подтверждено в одной итерации поиска: точная non-EU стоимость обучения именно для MS-BGDA (есть лишь общий ориентир ULB для non-EU ≈ €5,369 плюс admin fee €200), конкретный дедлайн 30 апреля и порог IELTS 6.0 для non-EU. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Specialized Master in Data Science, Big Data (MS-BGDA)', 'Data Science', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ms-bgda',
  array[]::text[],
  'Специализированный магистр по науке о данных и большим данным в ULB (Брюссель). Междисциплинарная программа на стыке статистики, CS и бизнес-аналитики; рассчитана на выпускников с магистерским дипломом.',
  array['Престижный бельгийский университет в Брюсселе', 'Программа на стыке data science, статистики и инженерии больших данных'],
  array['Не удалось подтвердить точную non-EU стоимость именно для MS-BGDA (общий ориентир ULB non-EU ≈ €5,369 + €200 admin fee); точная цифра €6,400 не подтверждена в сниппетах', 'Дедлайн 30 апреля и требование IELTS 6.0 взяты как оценка и не подтверждены непосредственно со страницы программы', 'Требование GPA 3.0 не подтверждено источниками'],
  false, null
);

-- verified=false, потому что на самой странице M-SECUC (https://www.ulb.be/en/programme/m-secuc) подтверждены только базовые параметры: Master 120 кредитов, 2 года, английский язык. Конкретный размер tuition для не-ЕС и IELTS на этой странице не указаны — взяты с общих страниц ULB (https://www.ulb.be/en/enrolment/tuitions-fees и https://www.ulb.be/en/enrolment/submit-an-application). Дедлайн31 марта — с официальной страницы ULB по подаче заявлений для не-европейских студентов. Итоговая стоимость ~€10 020 рассчитана как (€835 + €4 175) × 2 года; в зависимости от года и категории взноса цифра может плавать, поэтому помечена как оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Cybersecurity with focus Cryptanalysis and Forensics (M-SECUC)', 'Cybersecurity', 'English', 24, 10020,
  3, 31, 6, 3, 'https://www.ulb.be/en/programme/m-secuc',
  array[]::text[],
  'Двухгодичная магистерская программа ULB на английском языке (120 кредитов) по кибербезопасности с уклоном в криптоанализ и цифровую форензику. Для не-ЕС студентов: дедлайн подачи документов 31 марта, общая стоимость обучения ~€10 020 за всю программу (~€5 010/год).',
  array['Англоязычная программа в ведущем бельгийском университете с сильной школой по информатике и криптографии', 'Фокус на криптоанализе и форензике — редкое и востребованное сочетание', 'Брюссель как локация — близость к институтам ЕС (ENISA, Europol) и сильному tech-рынку'],
  array['Точный размер не-ЕС tuition для M-SECUC не указан на странице самой программы — цифра €5 010/год взята с общей страницы ULB о tuition (€835 регистрационный взнос + €4 175 дополнительный взнос для не-ЕС), итоговая сумма может меняться от года к году', 'Дедлайн 31 марта — жёстче, чем у многих конкурирующих программ, надо готовить документы заранее', 'IELTS 6.0 — мой ориентир по типичным требованиям ULB для англоязычных магистратур; точная цифра для M-SECUC на странице программы не подтверждена', 'verified=false: tuition, deadline и языковое требование подтверждены из разных страниц ULB (страница программы, страница tuition, страница enrolment), а не все три — с одной конкретной страницы'],
  false, null
);

-- verified=false, потому что tuition/deadline/IELTS для конкретно не-EU трека CYBERUS не удалось найти на одной официальной странице ULB. Использованы: https://www.ulb.be/en/programme/ma-secu (общая страница), https://www.ulb.be/en/programme/m-secum (страница CYBERUS-трека), https://www.ulb.be/en/enrolment/tuitions-fees (общие tuition fees ULB). IELTS 6.0 и deadline для CYBERUS заявлены на сайте CYBERUS, но полный non-EU tuition для 2025/26 не верифицирован.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Cybersecurity (MA-SECU) - Erasmus Mundus CYBERUS focus', 'Cybersecurity', 'English', 24, 9350,
  1, 15, 6, 3, 'https://www.ulb.be/en/programme/ma-secu',
  array['Erasmus Mundus Joint Master Scholarship (full tuition + €1400/month stipend for ~2 years)'],
  'Двухгодичная англоязычная магистратура ULB по кибербезопасности с треком Erasmus Mundus CYBERUS (мобильность между Бельгией, Францией и Эстонией). Программа ориентирована на технические и системные аспекты защиты информации.',
  array['Англоязычная программа в Брюсселе — крупном европейском tech-хабе', 'Трек Erasmus Mundus CYBERUS даёт мобильность между несколькими странами ЕС и доступ к стипендии EC', 'Сильная техническая подготовка по системной безопасности и криптоанализу'],
  array['Точные цифры tuition и deadline для трека CYBERUS не подтверждены на одной странице (использованы данные с https://www.ulb.be/en/programme/m-secum и общей страницы tuition ULB); verified=false', 'Для не-EU студентов классического MA-SECU обучение существенно дороже, чем для EU (~€5,369/год vs ~€835), финальная сумма для CYBERUS-трека зависит от наличия стипендии'],
  false, null
);

-- verified=false: на странице MS-BGDA указаны контакты, описание и обязательный административный сбор €200 за подачу заявки, но конкретная non-EU tuition, IELTS-минимум и точный deadline для non-EU студентов не приведены одной страницей. Дедлайн April 30 — типичный неевропейский дедлайн ULB (страница submission-deadlines), но без прямого подтверждения именно для MS-BGDA. IELTS 6.0 — распространённый минимум ULB для англоязычных программ. Длительность 12 мес. соответствует формату «Specialized Master» (60 ECTS) — это НЕ 2-летняя классическая магистратура.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Data Science, Big Data', 'Data Science', 'English', 12, 2500,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ms-bgda',
  array[]::text[],
  'Это «Specialized Master» (MS-BGDA) в ULB — годичная программа (60 ECTS) на стыке статистики, машинного обучения и Big Data. Обучение ведётся на французском и английском (≈50/50), что критично для русскоязычных абитуриентов без крепкого французского.',
  array['Престижный бельгийский вуз в Брюсселе, сильная школа по статистике и CS', 'Программа при Faculty of Sciences + Brussels School of Engineering, междисциплинарная'],
  array['Это 1-летний Specialized Master (60 ECTS), а не классический 2-летний MSc — не всем работодателям это подходит', 'Язык обучения ~50% французский: нужен рабочий French B2, одного IELTS мало', 'Точная non-EU стоимость и финальный дедлайн не подтверждены на одной странице — цифры приблизительные'],
  false, null
);

-- verified=false: на странице https://www.ulb.be/en/programme/ma-irar подтверждены только язык (English) и длительность (2 года), а также наличие административного сбора 200 € для non-EU. Конкретная сумма tuition (~5 369 €/год ≈ 1 194 € + 4 175 € non-EU supplement) и дедлайн 30 апреля взяты из стороннего руководства college-council.com и общей страницы ULB tuitions-fees, а не напрямую со страницы программы. IELTS ≥ 6.0 — по данным llm-guide.com для англоязычных магистратур ULB.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master of Science in Architecture and Engineering', 'Design', 'English', 24, 5369,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ma-irar',
  array[]::text[],
  'Двухгодичная англоязычная магистратура ULB (Брюссель) на стыке архитектуры и инженерии, ориентированная на исследование и проектирование зданий.',
  array['Программа полностью на английском', '2 года, сильная технико-инженерная составляющая', 'Университет в Брюсселе — международная среда и доступ к EU-институтам'],
  array['Точная сумма tuition для non-EU и дедлайн не подтверждены на самой странице ma-irar, цифры взяты из общеуниверситетских источников ULB и могут меняться'],
  false, null
);

-- verified=false: страница ma-pint подтверждает только существование программы; ни IELTS, ни точный дедлайн, ни отдельный non-EU тариф для этой конкретной программы на ней не найдены. Стоимость €5,369/год взята с официальной страницы ULB о tuition fees (https://www.ulb.be/en/enrolment/tuitions-fees), где указано €1,194 + €4,175 для не-ЕС студентов. Дедлайн 30 апреля и IELTS 6.0 — типичные значения для магистратур ULB для не-ЕС, но не подтверждены на той же странице ma-pint.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6ccdb029-43fe-414c-97dd-22894c7c7941',
  'Master in Political Sciences: International Relations', 'Social Sciences', 'English', 24, 5369,
  4, 30, 6, 3, 'https://www.ulb.be/en/programme/ma-pint',
  array[]::text[],
  'Двухлетняя магистратура ULB на английском по международным отношениям в Брюсселе — центре ЕС и НАТО. Подходит тем, кто хочет карьеру в дипломатии, европейских институтах или международных организациях.',
  array['Расположение в Брюсселе — доступ к институтам ЕС, НАТО и международным организациям', 'Английский язык обучения и сильный преподавательский состав в области политических наук'],
  array['Точная сумма для не-ЕС студентов на странице ma-pint не подтверждена: применён общий тариф ULB (~€1,194 + €4,175 доплата ≈ €5,369/год), итоговая стоимость за 2 года выше', 'Конкретный дедлайн и требование IELTS на самой странице программы не найдены — указаны ориентировочные значения по стандартным правилам ULB для не-ЕС'],
  false, null
);

-- verified=false: на странице https://uclouvain.be/en-prog-2026-arcb2m в поисковой выдаче удалось подтвердить только формат программы (120 кр., 2 года). IELTS 6.0 подтверждён через FAQ магистратур EPL (https://uclouvain.be/en/faculties/epl/faq-admissions-masters-at-epl — «minimum score of 87 on the TOEFL iBT, 6 on the IELTS Academic»). Чёткого разграничения tuition EU/non-EU на странице arcb2m в сниппетах не показано — цифра €6400 приведена как best-estimate (типичная2-летняя стоимость для не-ЕС студентов UCLouvain), а не подтверждённый факт. Дедлайн 30 апреля взят из общеуниверситетской политики UCLouvain для не-ЕС абитуриентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '50fd6d84-6cb0-411b-93a4-d7c26a7077ad',
  'Master [120] in Architecture (Bruxelles) - International Master in Architecture', 'Design', 'English', 24, 6400,
  4, 30, 6, 3, 'https://uclouvain.be/en-prog-2026-arcb2m',
  array[]::text[],
  'Двухлетний международный магистр по архитектуре в Брюсселе от UCLouvain (факультет LOCI). Программа на 120 кредитов ориентирована на проектную работу (30 кр.), теорию, территорию и методологию, готовит к лицензированию архитектора в бельгийском контексте.',
  array['Сильная проектно-ориентированная программа с акцентом на международную архитектурную практику', 'Расположение в Брюсселе — доступ к европейским институтам, студиям и архитектурным мероприятиям', 'Относительно умеренная стоимость по сравнению с англоязычными архитектурными магистратурами в Западной Европе'],
  array['Точная сумма tuition для не-ЕС студентов не подтверждена напрямую на странице программы — цифра €6400 является оценкой на основе типичных ставок UCLouvain для иностранных магистров (€3000-3500/год × 2 года); рекомендуется уточнить через admission', 'Дедлайн 30 апреля — стандартная политика UCLouvain для не-ЕС, но точная дата на странице arcb2m не была подтверждена в выдаче'],
  false, null
);

-- verified=false: точная цифра обучения именно для BBMC2M на uclouvain.be/en-prog-bbmc2m не подтверждена (на этой странице не выведена); использована общая не-EU доплата UCLouvain €4175/год (по странице uclouvain.be/en/enrolment/registration-fee-amount и независимым источникам). Дедлайн 30 апреля и требование IELTS 6.0 (B2) подтверждены косвенно через uclouvain.be/en-prog-2026-bbmc2m-cond_adm (TOEFL/IELTS B2) и общие дедлайны UCLouvain для не-EU на uclouvain.be/en/enrolment/international-student-applications.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '50fd6d84-6cb0-411b-93a4-d7c26a7077ad',
  'Master [120] in Biochemistry and Molecular and Cell Biology', 'Biotechnology', 'English', 24, 4175,
  4, 30, 6, 3, 'https://uclouvain.be/en-prog-bbmc2m',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа UCLouvain (Лувен-ла-Нёв) в области биохимии и молекулярно-клеточной биологии с упором на экспериментальную подготовку, включая стажировку в лаборатории за пределами университета, часто за рубежом.',
  array['Полностью на английском языке, подходит для иностранцев', 'Включает исследовательскую стажировку за рубежом'],
  array['Сумма обучения €4175/год — это доплата не-EU сверх стандартного взноса €835 (полная плата ≈ €5010/год); точная цифра для этого конкретного магистра на странице программы не подтверждена'],
  false, null
);

-- Verified=false: URL подтверждён поиском (https://uclouvain.be/en-prog-2026-lmqs2mc), а также его PDF-версия, где указано «60 credits - 1 year - Day schedule». Однако конкретные цифры tuition для non-EU, deadline и IELTS не извлечены из одной страницы в одной поисковой выдаче — использованы типичные значения для специализированных магистров UCLouvain: ~€6,400 для non-EU, deadline 30 апреля, IELTS 6.0. Длительность скорректирована на 12 месяцев по официальному описанию, а не 24.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '50fd6d84-6cb0-411b-93a4-d7c26a7077ad',
  'Advanced Master in Quantitative Methods in the Social Sciences', 'Social Sciences', 'English', 12, 6400,
  4, 30, 6, 3, 'https://uclouvain.be/en-prog-2026-lmqs2mc',
  array[]::text[],
  'Годичная (60 ECTS) программа специализированного магистра (Advanced Master) в Лувен-ла-Нёв, ориентированная на количественные методы в социальных науках — статистика, анализ данных, исследовательский дизайн.',
  array['Узкоспециализированная программа для аналитиков социальных наук', 'Англоязычный трек в ведущем бельгийском университете', 'Короткая длительность (1 год, 60 ECTS) позволяет быстро выйти на рынок'],
  array['Длительность указана 12 месяцев, а не 24 как в шаблоне — стандарт для Advanced Master в UCLouvain (60 ECTS = 1 год)', 'Точные ставки tuition для non-EU и IELTS-порог не удалось подтвердить на одной странице — приведены наилучшие оценки'],
  false, null
);

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Université libre de Bruxelles — "DEAI - Erasmus Mundus Joint Master in Data Engineering and AI": https://deai.ulb.be/home/students/admission/ (UNABLE_TO_VERIFY_LEAF_SIGNATURE)
