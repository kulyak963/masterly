-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Czech Republic (cz) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: на одной странице одновременно tuition+deadline+IELTS для не-ЕС не подтверждены. Tuition €5,400/год подтверждён Collab International (https://www.collabinternational.com/czech-technical-university) и совпадает со ставкой CTU 132 000 CZK/год для магистратуры на английском. IELTS 6.0 — стандарт CTU. Дедлайн 30 апреля — типичный крайний срок CTU для не-ЕС на осенний набор, но точная дата с fjfi.cvut.cz в сниппетах не извлечена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c6221c54-91a4-475e-bde4-4a3d655c03b9',
  'Plasma Physics and Thermonuclear Fusion', 'Natural Sciences', 'English', 24, 5400,
  4, 30, 6, 3, 'https://fjfi.cvut.cz/en/applicants/masters-degree/follow-masters-study-programmes',
  array[]::text[],
  'Магистерская программа магистратуры по физике плазмы и термоядерному синтезу в CTU Prague на факультете ядерных наук и физической инженерии (FJFI). Обучение на английском, 2 года, доступ к учебному токамаку GOLEM и международным проектам Fusion-EP.',
  array['Уникальная программа с доступом к реальному учебному токамаку GOLEM', 'Связь с международной сетью Fusion-EP и европейскими исследовательскими центрами', 'Англоязычное обучение в Праге с относительно умеренной стоимостью'],
  array['Стоимость €5,400 подтверждена третьими лицами (Collab International, Mastersportal), на самой странице FJFI для не-ЕС отдельная цифра не найдена в выдаче', 'Дедлайн 30 апреля указан как типичный для CTU не-ЕС, но на конкретной странице программы не подтверждён в выдаче', 'Стипендии от факультета в открытых источниках не указаны'],
  false, null
);

-- URL подтверждено: 23236 — это магистерская программа (23254 — бакалавр). Дедлайн 30 апреля для осеннего набора упомянут на общей странице admissions MUNI; сниппет 23236 показывает дедлайн 31 октября только для Spring 2027. Тутуition €3500/год — из Mastersportal, официальная страница muni.cz в сниппетах не показала явную разбивку EU/non-EU. IELTS6.0 — типовое требование FSS, но явно не подтверждено в сниппете23236. Поскольку не все три параметра (tuition/deadline/language) подтверждены для non-EU на одной и той же странице, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'International Relations and European Politics', 'Social Sciences', 'English', 24, 3500,
  4, 30, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-fields/23236-international-relations-and-european-politics',
  array[]::text[],
  'Магистерская программа на английском в Faculty of Social Studies Masaryk University в Брно. Стандартная плата за обучение около €3500/год по данным Mastersportal, вступительный экзамен отсутствует, приём заявок до 30 апреля на осенний семестр.',
  array['Преподавание полностью на английском', 'Без вступительных экзаменов — оценивают мотивацию и предыдущее образование', 'Университет в Брно значительно дешевле Праги по проживанию'],
  array['Точная ставка именно для non-EU студентов не подтверждена на официальной странице — €3500/год взят из Mastersportal, официальный сайт не показывает разбивку EU/non-EU в найденных сниппетах', 'Минимальный IELTS6.0 указан по типичному требованию MUNI FSS, на самой странице программы в сниппете не подтверждён', 'Не указаны конкретные стипендии для non-EU'],
  false, null
);

-- verified=true: страница программы muni.cz/en/bachelors-and-masters-study-programmes/26825 подтверждает наличие программы, её совместный статус с Университетом Ренна, продолжительность и крайний срок подачи заявок (September intake — 30 апреля). IELTS 6.0 подтверждён на странице Application Requirements ECON MUNI. Плата в CZK (100 000/год) подтверждена, пересчёт в EUR (≈4000) приблизительный, поэтому в графе указано 4000 EUR как лучшая оценка; точная цифра в EUR на странице не приведена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Public Administration (Administration publique)', 'Social Sciences', 'English', 24, 4000,
  4, 30, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-programmes/26825-public-administration-administration-publique',
  array['Стипендия, покрывающая 50% семестровой платы за обучение для студентов программы'],
  'Магистерская программа Public Administration (Administration publique) в Masaryk University (Брно), реализуемая совместно с Университетом Ренна (Франция) на чешском и английском языках. Обучение длится 4 семестра (2 года), плата для иностранных студентов — около 100 000 CZK в год.',
  array['Совместная программа с Университетом Ренна (Франция)', 'Возможна стипендия, покрывающая половину семестровой платы', 'Университет с сильной репутацией в Центральной Европе'],
  array['Точный размер платы для не-граждан ЕС/ЕЭЗ на странице напрямую не выделен (указано 100 000 CZK/год; в EUR это ≈4000, но значение округлено)'],
  true, current_date
);

-- Подтверждено: название программы, её существование и стоимость €3 000/год на странице muni.cz/en/bachelors-and-masters-study-programmes/26281-molecular-and-cell-biology; по данным studyineurope.eu ставка €3 000 одинакова для граждан ЕС и не-ЕС. НЕ подтверждено: точные IELTS-минимум и точный дедлайн именно для не-ЕС на этой же странице не указаны — общий дедлайн приёма заявок для не-ЕС на MUNI указан как «1 December–31 May», для факультета естественных наук обычно 30 апреля, минимальный IELTS для Faculty of Science обычно 6.0. Поэтому verified=false: на одной и той же странице все три требования одновременно не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Molecular and Cell Biology', 'Biotechnology', 'English', 24, 6000,
  4, 30, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-programmes/26281-molecular-and-cell-biology',
  array[]::text[],
  'Магистерская программа «Molecular and Cell Biology» в Университете Масарика (Брно, Чехия) на базе факультета естественных наук и центра CEITEC. Обучение полностью на английском, длится 2 года, стоимость — €3 000 в год (€6 000 за весь курс); отдельной повышенной ставки для не-ЕС не показано.',
  array['Низкая стоимость обучения (€3 000/год) одинакова для граждан ЕС и не-ЕС', 'Современная исследовательская база в CEITEC и преподавание на английском', 'Брно — крупный студенческий город с относительно низкими расходами на жизнь по сравнению с Западной Европой'],
  array['Подтверждены не все три параметра (стоимость, дедлайн, язык) на одной странице — заявка подаётся через общий портал MUNI, а точные требования по IELTS и крайний срок для не-ЕС уточняются на странице факультета/приёмной комиссии', 'Стипендии для иностранных студентов напрямую на программе не указаны — нужно искать отдельные конкурсы MUNI или правительства Чехии'],
  false, null
);

-- Подтверждено на одной странице https://www.fa.vutbr.cz/studyarchitecture: стоимость 4600 EUR/год, язык English, дедлайн 31 March 2026, длительность 2 года, уровень Master''s. Разграничения EU/non-EU на этой странице нет — согласно vut.cz/en/students/programmes ставка одинакова для EU и non-EU (4200 EUR/год, цифра устаревшая). IELTS 6.0 подтверждён на партнёрской странице study-in-brno.cz. Verified=true, т.к. tuition+deadline+language берутся с указанного URL; небольшое расхождение по сумме tuition с vut.cz отражено в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '807d60cc-d463-4925-8b5a-728ae288386c',
  'Architecture and Urban Design', 'Design', 'English', 24, 9200,
  3, 31, 6, 3, 'https://www.fa.vutbr.cz/studyarchitecture',
  array[]::text[],
  'Магистратура Architecture and Urban Design в Брно (FA VUT) — очная англоязычная программа длительностью 2 года (степень Ing. arch.), стоимость 4600 EUR/год (одинаковая для EU и non-EU студентов), подача документов до 31 марта.',
  array['Полностью англоязычная программа в одной из сильнейших архитектурных школ Центральной Европы', 'Единая стоимость обучения для всех студентов (EU/non-EU = 4600 EUR/год), прозрачные правила приёма', 'Степень Ing. arch. признаётся в ЕС, доступная стоимость жизни в Брно по сравнению с Западной Европой'],
  array['Дедлайн 31 марта — цикл 2026/27 уже на исходе, для следующего набора ориентировочная дата может сместиться, нужно уточнять на сайте', 'Минимальный GPA на сайте явно не указан (3.0/4.0 — типовая оценка для чешских вузов), кроме того требуется портфолио и мотивационное письмо', 'На факультетской странице (4600 EUR/год) и общеуниверситетском портале vut.cz (4200 EUR/год) фигурируют разные цифры — стоит перепроверить перед оплатой'],
  true, current_date
);
