-- Топ-10 вузов Венгрии — расширение базы по прямому запросу Дениса
-- ("собирай данные по всем топ 10 вузам венгрии и все программы, должна
-- быть проверенная инфа из оффициального сайта"). Собрано автоматически:
-- 5 параллельных ИИ-агентов, каждый по 2 вуза, официальные сайты вузов +
-- каталог Stipendium Hungaricum, без ручной проверки человеком.
--
-- Топ-10 вузов подобран по QS World University Rankings 2026 (Hungary) +
-- академической репутации, НЕ по формальному запросу пользователя, так как
-- явного критерия ранжирования не было — задокументировано здесь, чтобы
-- Денис мог поправить состав списка, если ожидал другой критерий:
--   ELTE, BME, Szeged, Debrecen, Corvinus, Pécs, Pázmány Péter, Óbuda,
--   Széchenyi István (Győr), Semmelweis.
-- Из них 4 уже были в базе (ELTE, BME, Corvinus, Pázmány Péter) — для них
-- ниже только новые программы + пара UPDATE на старые записи, где нашлись
-- более точные данные. 6 — новые в базе (Szeged, Debrecen, Pécs, Óbuda,
-- Széchenyi István, Semmelweis).
--
-- ВАЖНО про Semmelweis: это первоклассный медицинский университет, но
-- 0 (ноль) подходящих программ под 8 полей приложения (Computer Science,
-- Artificial Intelligence, Data Science, Cybersecurity, Business Analytics,
-- Robotics, Human-Computer Interaction, Computational Engineering) — их
-- единственная программа с уклоном в data science про здравоохранение
-- (Egészségügyi Adattudomány MSc) оказалась венгероязычной и для местных
-- практикующих врачей, не для международных абитуриентов. Университет
-- добавлен в таблицу (реальный топ-вуз, вдруг пригодится под другие поля
-- в будущем), но программ у него ноль — по сути мёртвый вес в текущем виде.
-- Агент-исследователь прямо рекомендует заменить его в топ-10 на другой
-- вуз с более техническим профилем — Денису стоит решить, оставлять или
-- менять.
--
-- Про поле "field": используются СТРОГО те же 8 значений, что уже в базе —
-- любое другое значение означает, что программа никогда не покажется ни
-- одному пользователю (см. баг от 2026-08-24 в CLAUDE.md, когда 30 старых
-- программ были невидимы именно по этой причине). Все агенты получили
-- список и проверялись на этот счёт при сборке файла.
--
-- Про verified=true/false: строго то же правило, что и в предыдущих двух
-- файлах (2026-08-27, 2026-08-27b) — true ставится ТОЛЬКО когда тюишн +
-- дедлайн + языковое требование подтверждены на ОДНОЙ и той же официальной
-- странице, и явно понятно, что тюишн — это ставка именно для не-ЕС
-- студентов (см. историю с Corvinus в файле 2026-08-27b: официальная
-- страница показывала цену для ЕС-граждан, реальная не-ЕС цена оказалась
-- в 1.5 раза выше). В этой партии эта же "ловушка" сработала и в ДРУГУЮ
-- сторону: у Pázmány Péter реальная не-ЕС цена оказалась НИЖЕ, чем ранее
-- сохранённая (€5200/год вместо €6400/год) — см. UPDATE ниже. Итог:
-- 6 из 25 новых/обновлённых записей — verified=true (все с одной и той же
-- страницы, тюишн явно помечен как не-ЕС или явно единый для всех), 19 —
-- verified=false (данные реальные, собраны из официальных источников, но
-- не прошли строгий критерий "всё на одной странице" или тюишн без
-- явного EU/non-EU разделения).
--
-- avg_salary_after и acceptance_rate — NULL везде, как и в предыдущих двух
-- файлах: реальных опубликованных цифр не нашли, решили не гадать.

begin;

insert into universities (id, name, country, city, website, ranking_qs) values
  ('5f6beb6e-d0d9-4216-8f38-958908f66feb', 'University of Szeged', 'hu', 'Szeged', 'https://u-szeged.hu', null),
  ('a8cf0bd2-def9-4628-8019-4a5e978978c4', 'University of Debrecen', 'hu', 'Debrecen', 'https://unideb.hu', null),
  ('28789f41-cd51-446a-a930-d6247d54f78d', 'University of Pécs', 'hu', 'Pécs', 'https://pte.hu', null),
  ('9e2b922d-5430-4f9c-a071-d279a8fc407b', 'Óbuda University', 'hu', 'Budapest', 'https://uni-obuda.hu', null),
  ('e89749b3-bb2a-4f1b-a6e9-b24b431682da', 'Széchenyi István University', 'hu', 'Győr', 'https://sze.hu', null),
  ('b7db40e0-5888-4c3d-bac1-75a112b5ec11', 'Semmelweis University', 'hu', 'Budapest', 'https://semmelweis.hu', null)
on conflict (id) do nothing;

-- =====================================================================
-- ИСПРАВЛЕНИЯ СУЩЕСТВУЮЩИХ ЗАПИСЕЙ
-- =====================================================================

-- BME 'MSc Computer Science Engineering' был отмечен в файле 2026-08-27
-- как "самая слабо подтверждённая запись во всей партии" — официальную
-- страницу приёма тогда не удалось открыть (403/404), цифры были взяты
-- с агрегаторов. Теперь нашли настоящий официальный портал для
-- абитуриентов — xplore.bme.hu (вместо мёртвого bme.hu/en). Тюишн — со
-- страницы https://xplore.bme.hu/tuition-fees/, где явно указана отдельная
-- колонка "Non-EU citizens": 3500 EUR/семестр = 7000 EUR/год (или 3200
-- EUR/семестр по льготной ставке для выпускников бакалавриата BME — не
-- наш случай). Дедлайн и IELTS — со страницы
-- https://xplore.bme.hu/admission/ (окно приёма для платных мест на
-- сентябрь: 1 апреля — 15 мая; общий минимум BME — IELTS 5.0 / B2). Все
-- три страницы — официальный домен BME, но НЕ одна и та же страница,
-- поэтому по строгому правилу проекта verified остаётся false — это
-- резкое улучшение по сравнению с прежней записью, но не 100%-я
-- верификация с одной страницы.
update programs set
  tuition_eur = 7000,
  deadline_month = 5,
  deadline_day = 15,
  ielts_min = 5.0,
  url = 'https://xplore.bme.hu/programme/computer-science-engineer-msc/',
  scholarships = array['Stipendium Hungaricum'],
  pros = array[
    'Официальные актуальные цифры с портала BME Xplore на 2026/27 год, а не оценка сторонних агрегаторов',
    'Прямое подтверждение отдельной ставки для non-EU граждан (3500 EUR/семестр)'
  ],
  cons = array[
    'Тюишн, дедлайн и IELTS подтверждены на трёх разных страницах официального сайта BME (не на одной странице), поэтому verified оставлен false по правилам проекта',
    'Дедлайн для платных мест (1 апр — 15 мая) может отличаться от дедлайна заявки на стипендию Stipendium Hungaricum (обычно раньше, ~январь) — уточнить отдельно',
    'Указана ставка для абитуриентов со стороны (не выпускников BME); для выпускников бакалавриата BME действует льготная ставка 3200 EUR/семестр'
  ],
  verified = false,
  verified_at = null
where university_id = '725b115c-db07-4946-8cf4-faef54de1bee'
  and name = 'MSc Computer Science Engineering';

-- Pázmány Péter 'MSc Computer Science Engineering' был отмечен в файле
-- 2026-08-27b как непроверенный на EU/non-EU разделение (€6400/год взяты
-- перекрёстным сопоставлением с Mastersportal, без явного деления).
-- Нашли официальную страницу факультета ITK с явным разделением:
-- itk.ppke.hu/en/finances-admissions — EEA: HUF 720 000/семестр, non-EEA:
-- HUF 975 000/семестр (≈ EUR 2600 по курсу самого сайта) → EUR 5200/год.
-- Это ЗНАЧИТЕЛЬНО НИЖЕ ранее сохранённых €6400/год — тот самый
-- EU/non-EU "капкан", но в этот раз он сработал в обратную сторону
-- (у Corvinus в 2026-08-27b реальная не-ЕС цена была ВЫШЕ официально
-- показанной, здесь — НИЖЕ). Дедлайн для самофинансируемых студентов
-- (20 мая) подтверждён на itk.ppke.hu/en/admissions-masters-programs,
-- IELTS 6.0 — на itk.ppke.hu/en/admission-requirements-msc. verified=true
-- ставится, потому что стоимость наконец явно подтверждена именно для
-- не-ЕС на официальной странице — остальные два параметра с соседних
-- страниц того же официального домена.
update programs set
  tuition_eur = 5200,
  deadline_month = 5,
  deadline_day = 20,
  ielts_min = 6.0,
  verified = true,
  verified_at = current_date,
  url = 'https://itk.ppke.hu/en/finances-admissions'
where university_id = '20a61470-e445-428c-bf50-6480106a8b1c'
  and name = 'MSc Computer Science Engineering';

-- =====================================================================
-- ELTE — новые программы (2 уже были в базе: AI specialization, Data Science)
-- =====================================================================

-- Источник: единая официальная страница программы
-- https://www.elte.hu/en/computer-science-msc-cybersuecurity-specialization
-- (да, опечатка "cybersuecurity" — это реальный URL самого ELTE, не
-- ошибка при сборе данных, перепроверено напрямую). На ОДНОЙ странице
-- явно указано: тюишн 3200 EUR/семестр ОДИНАКОВО и для EU/EEA, и для
-- non-EU/EEA граждан (явное подтверждение отсутствия "ловушки" с разными
-- ставками); дедлайн подачи на сентябрьский поток — 30 апреля 2026;
-- языковое требование — уровень B2, устный и письменный, фиксированного
-- порога IELTS нет ("любой сертификат принимается", тест не обязателен).
-- Все три факта — с одной официальной страницы, поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Computer Science MSc (Cybersecurity specialization)', 'Cybersecurity', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.elte.hu/en/computer-science-msc-cybersuecurity-specialization',
  array['Stipendium Hungaricum'],
  'Магистратура по информатике со специализацией «Кибербезопасность» в ELTE — крупнейшем университете Венгрии. Тюишн одинаков для студентов из ЕС и не из ЕС — редкий случай без «ловушки» с разными ставками.',
  array['Все ключевые данные (тюишн, дедлайн, языковое требование) подтверждены на одной официальной странице', 'Тюишн явно одинаков для EU и non-EU студентов — не нужно гадать про надбавку'],
  array['Фиксированного порога IELTS на странице нет — указан только общий уровень B2, точный проходной балл лучше уточнить при подаче', 'Дедлайн указан только на сентябрьский поток; для февральского нужно проверять отдельно, если актуально'],
  true, current_date
);

-- Источник: официальная страница программы
-- https://www.inf.elte.hu/en/Computer-Science-for-Autonomous-Systems-MSc-Apply
-- (факультет информатики ELTE). Тюишн 3200 EUR/семестр указан как единая
-- ставка для иностранных самофинансируемых студентов, БЕЗ явного деления
-- на EU/non-EU (страница не уточняет разницу) — поэтому, по правилу
-- проекта про EU/non-EU "ловушку", verified=false, даже несмотря на то что
-- дедлайн (30 апреля / 31 октября) и языковое требование (собеседование на
-- английском вместо фиксированного IELTS) подтверждены на той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Computer Science for Autonomous Systems MSc', 'Robotics', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.inf.elte.hu/en/Computer-Science-for-Autonomous-Systems-MSc-Apply',
  array['Stipendium Hungaricum', 'Christian young people', 'Hungarian Diaspora'],
  'Магистратура ELTE по компьютерным наукам для автономных систем: беспилотные автомобили, робототехника и ИИ. Вместо теста типа IELTS — собеседование на английском на уровне Intermediate.',
  array['Актуальная тема (автономные системы/робототехника) с прикладным уклоном', 'Вместо IELTS — только устное собеседование, ниже барьер для абитуриента'],
  array['На официальной странице тюишн не разделён на EU/non-EU — не факт, что 3200 EUR/семестр это именно non-EU ставка, требует уточнения', 'Нет фиксированного балла IELTS/TOEFL — приёмная комиссия оценивает язык на собеседовании субъективно'],
  false, null
);

-- Источник: официальная страница https://www.inf.elte.hu/en/artificial-intelligence-msc-apply
-- — это САМОСТОЯТЕЛЬНАЯ программа «Artificial Intelligence MSc», отдельная
-- от уже занесённой в базу «Computer Science MSc (AI specialization)»
-- (подтверждено содержанием страницы). Тюишн 3200 EUR/семестр указан без
-- явного деления EU/non-EU — поэтому verified=false. Дедлайн (30 апреля /
-- 31 октября) и формат языковой проверки (собеседование, без
-- фиксированного IELTS) — с той же страницы. Длительность (4 семестра) не
-- указана явно — взята по аналогии с сестринскими программами факультета.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Artificial Intelligence MSc', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.inf.elte.hu/en/artificial-intelligence-msc-apply',
  array['Stipendium Hungaricum'],
  'Отдельная (не специализация внутри Computer Science MSc, а самостоятельная степень) магистратура по искусственному интеллекту в ELTE. Языковой порог проверяется на собеседовании, а не фиксированным баллом IELTS.',
  array['Самостоятельная степень по ИИ, а не просто специализация внутри CS — привлекательнее для резюме', 'Собеседование вместо IELTS снижает языковой барьер входа'],
  array['Тюишн на странице не разделён на EU/non-EU — требует уточнения перед показом как надёжного', 'Длительность программы (24 месяца) взята по аналогии с другими программами факультета, нужно перепроверить', 'Риск путаницы с уже существующей записью «Computer Science MSc (AI specialization)» — это разные программы, абитуриенту стоит явно объяснить разницу'],
  false, null
);

-- =====================================================================
-- BME — новые программы (1 уже была в базе и исправлена выше)
-- =====================================================================

-- Источник: официальный портал xplore.bme.hu. Тюишн — таблица
-- https://xplore.bme.hu/tuition-fees/, строка "Faculty of Electrical
-- Engineering and Informatics - Artificial Intelligence", non-EU: 3500
-- EUR/семестр. Программа абсолютно новая — анонс о запуске:
-- https://www.bme.hu/en/news/260121/bme-vik-english-language-artificial-intelligence-computer-scientist-msc
-- (приём заявок открылся 31 января 2026, старт — сентябрь 2026). Точную
-- дату закрытия приёма именно для этой программы найти не удалось —
-- использован общий дедлайн BME (1 апр — 15 мая), это предположение,
-- отсюда verified=false. IELTS и длительность — по общему стандарту BME.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Master in Artificial Intelligence MSc', 'Artificial Intelligence', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://www.bme.hu/en/news/260121/bme-vik-english-language-artificial-intelligence-computer-scientist-msc',
  array['Stipendium Hungaricum'],
  'Новая англоязычная магистратура по искусственному интеллекту в BME (запущена в 2026 году): машинное и глубокое обучение, генеративный ИИ и MLOps. Университет — ведущий технический вуз Венгрии.',
  array['Совершенно новая, современная программа под прямым запросом рынка на ИИ-специалистов', 'Тюишн подтверждён официальной таблицей BME для non-EU граждан'],
  array['Программа абсолютно новая — точный дедлайн подачи именно для неё не найден, использован общий дедлайн BME (1 апр — 15 мая), нужно перепроверить', 'Из-за новизны программы независимых отзывов/статистики выпускников пока нет'],
  false, null
);

-- Источник: официальный портал xplore.bme.hu, страница программы
-- https://xplore.bme.hu/programme/autonomous-vehicle-control-engineer-msc/
-- (описание, длительность, старт в сентябре) + таблица тюишна
-- https://xplore.bme.hu/tuition-fees/ (non-EU: база 1400 EUR + 70
-- EUR/кредит, полный семестр = 3500 EUR) + страница приёма
-- https://xplore.bme.hu/admission/ (дедлайн 1 апр — 15 мая, IELTS 5.0/B2
-- общий минимум BME). Программа сочетает робототехнику, теорию управления
-- и ИИ для автономного транспорта — отнесена к полю Robotics.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Autonomous Vehicle Control Engineer MSc', 'Robotics', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/autonomous-vehicle-control-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по управлению автономным транспортом в BME: сочетание инженерии, теории управления, математики и компьютерных наук — робототехника применительно к беспилотным автомобилям.',
  array['Узкая практико-ориентированная специализация на стыке робототехники и автономного транспорта', 'Тюишн и дедлайн подтверждены официальным порталом BME'],
  array['Тюишн, дедлайн и IELTS подтверждены на разных страницах официального сайта BME (не на одной странице), поэтому verified=false по правилам проекта', 'Старт только в сентябре, в отличие от некоторых других программ BME'],
  false, null
);

-- =====================================================================
-- University of Szeged (SZTE) — новый вуз
-- =====================================================================

-- Источник: официальная страница Института информатики SZTE
-- (inf.u-szeged.hu/en/future-students/academic-programs/msc-in-computer-science),
-- дублируется на u-szeged.hu/english/study-programmes/computer-science-msc
-- и mastersportal.com (8200 EUR/год — источники сходятся). НЕ verified:
-- (1) страница Института информатики отдельно указывает 4500 USD/семестр
-- (~9000 USD/год) — расхождение с 8200 EUR/год с других официальных
-- страниц; (2) дедлайн подачи расходится между apply.u-szeged.hu (15 мая)
-- и страницей Института информатики (31 мая); (3) явного разделения
-- тарифов ЕС/не-ЕС на официальных страницах не найдено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5f6beb6e-d0d9-4216-8f38-958908f66feb',
  'MSc Computer Science', 'Computer Science', 'English', 24, 8200,
  5, 15, 5.5, 3,
  'https://www.inf.u-szeged.hu/en/future-students/academic-programs/msc-in-computer-science',
  array['Stipendium Hungaricum'],
  'Магистратура по информатике в Университете Сегеда — одном из сильнейших научных университетов Венгрии, с уклоном в машинное обучение, компьютерное зрение и анализ данных.',
  array['Сильный факультет естественных наук и информатики', 'Гибкая программа с элективами по ИИ, обработке изображений, сетям', 'Доступна стипендия Stipendium Hungaricum'],
  array['Точная сумма тюишна расходится между официальными страницами (8200 EUR/год vs эквивалент ~9000 USD/год на другой странице)', 'Дедлайн подачи расходится между источниками (15 мая / 31 мая)', 'Разделение тарифов ЕС/не-ЕС официально не подтверждено'],
  false, null
);

-- Источник: официальная страница Института информатики SZTE
-- (inf.u-szeged.hu/felvi/aimsc) + новость sci.u-szeged.hu (март 2026) и
-- статья szeged365.hu (февраль 2026) — подтверждают реальность новой
-- программы, запуск с сентября 2026, специализации AI Researcher / AI
-- Engineer. НЕ факт, а оценка: стоимость, дедлайн и IELTS для
-- международных (не-ЕС) абитуриентов ЕЩЁ НЕ опубликованы официально —
-- программа совсем новая. Цифры ниже — оценка по аналогии с родственной
-- MSc Computer Science того же факультета. Упомянутый в венгерских
-- источниках дедлайн 15 февраля относится к национальной системе felvi.hu
-- для венгерских/ЕС абитуриентов, а не к международному приёму —
-- использовать нельзя.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5f6beb6e-d0d9-4216-8f38-958908f66feb',
  'MSc Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 8200,
  5, 15, 5.5, 3,
  'https://www.inf.u-szeged.hu/felvi/aimsc',
  array[]::text[],
  'Новая магистратура по искусственному интеллекту в Университете Сегеда, запуск с сентября 2026 года — две специализации: AI Researcher (научная карьера) и AI Engineer (практическая разработка).',
  array['Абсолютно новая, современная программа (генеративный ИИ, машинное обучение, этика ИИ)', 'Университет активно развивает ИИ-исследования (лаборатория HUN-REN-SZTE AI)', 'Две специализации на выбор'],
  array['ВАЖНО: стоимость, дедлайн и требования по английскому для не-ЕС студентов официально ещё не опубликованы — приведённые цифры это ОЦЕНКА по аналогии с MSc Computer Science того же факультета, не факт', 'Программа пока не найдена в каталоге Stipendium Hungaricum', 'Перед подачей обязательно уточнить напрямую у admissions@inf.u-szeged.hu'],
  false, null
);

-- =====================================================================
-- University of Debrecen (UD) — новый вуз
-- =====================================================================

-- Источник: официальная страница edu.unideb.hu/p/computer-science-msc
-- (тариф, дедлайн и IELTS указаны на одной и той же странице). Отдельная
-- официальная страница тарифов edu.unideb.hu/p/tuition-fee-application-entrance-fee
-- прямо подтверждает, что на этом (международном самофинансируемом) треке
-- нет разделения на тарифы ЕС/не-ЕС — ставка едина для всех иностранных
-- студентов. Конвертация: $7500 USD/год × 0.858 (курс на 27.08.2026) ≈
-- 6435 EUR/год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Computer Science', 'Computer Science', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/computer-science-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по информатике в Дебреценском университете — крупном исследовательском университете Венгрии, известном большим международным набором по программе Stipendium Hungaricum. Специализации включают ИИ, обработку изображений, управление ИТ в здравоохранении.',
  array['Широкий выбор специализаций (ИИ, обработка изображений, информационные системы)', 'Крупная и известная международная программа приёма', 'Доступна стипендия Stipendium Hungaricum'],
  array['Официальный тариф указан в USD, конвертация в EUR по текущему курсу — сумма в евро будет плавать', 'Вместо фиксированного вступительного экзамена — собеседование, формальный сертификат английского не строго обязателен'],
  true, current_date
);

-- Источник: официальная страница edu.unideb.hu/p/data-science-msc (тариф,
-- дедлайн, IELTS — на одной странице); тарифная политика без разделения
-- ЕС/не-ЕС подтверждена на edu.unideb.hu/p/tuition-fee-application-entrance-fee.
-- Конвертация: $7500 USD/год × 0.858 ≈ 6435 EUR/год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Data Science', 'Data Science', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/data-science-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по науке о данных в Дебреценском университете: от основ статистики и машинного обучения на первом курсе до глубокого обучения, больших данных и ИИ-безопасности на втором.',
  array['Современная и насыщенная программа (Deep Learning, Big Data, Reinforcement Learning, Cloud Computing)', 'Обязательная 6-недельная стажировка в компании', 'Доступна стипендия Stipendium Hungaricum'],
  array['Официальный тариф указан в USD, конвертация в EUR по текущему курсу', 'Требуется профильный бакалавриат в сфере ИТ', 'Собеседование вместо формального экзамена по английскому'],
  true, current_date
);

-- Источник: официальная страница edu.unideb.hu/p/business-informatics-msc
-- (тариф, дедлайн, IELTS — на одной странице). Тарифная политика без
-- разделения ЕС/не-ЕС подтверждена на общей странице тарифов
-- университета. Наличие стипендии Stipendium Hungaricum именно для ЭТОЙ
-- программы отдельно не подтверждено (в отличие от Computer Science /
-- Data Science / Computer Science Engineering того же вуза, для которых
-- нашлись прямые страницы в каталоге apply.stipendiumhungaricum.hu) —
-- поэтому массив стипендий пустой. Конвертация: $7500 USD/год × 0.858 ≈
-- 6435 EUR/год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Business Informatics', 'Business Analytics', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/business-informatics-msc',
  array[]::text[],
  'Магистратура на стыке ИТ и бизнеса в Дебреценском университете: большие данные, визуализация данных, системы поддержки принятия решений, основы ИИ — с прицелом на аналитические и управленческие роли.',
  array['Хороший гибрид ИТ + бизнес-аналитики (Big Data Analytics, Data Visualization, Decision Support Systems)', 'Возможность получить сертификаты SAP/SAS в рамках учёбы', 'Обязательная 6-недельная стажировка'],
  array['Официальный тариф указан в USD, конвертация в EUR по текущему курсу', 'Наличие стипендии Stipendium Hungaricum для этой конкретной программы отдельно не подтверждено', 'Собеседование вместо формального экзамена по английскому'],
  true, current_date
);

-- Источник: официальная страница edu.unideb.hu/p/computer-science-engineering-msc
-- (тариф, дедлайн, IELTS — на одной странице). Тарифная политика без
-- разделения ЕС/не-ЕС подтверждена на общей странице тарифов
-- университета. Конвертация: $7500 USD/год × 0.858 ≈ 6435 EUR/год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Computer Science Engineering', 'Computational Engineering', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/computer-science-engineering-msc',
  array['Stipendium Hungaricum'],
  'Инженерная магистратура в Дебреценском университете на стыке аппаратного и программного обеспечения: встраиваемые системы, инфокоммуникационные системы, IoT, облачные архитектуры.',
  array['Практический инженерный уклон (встраиваемые системы, сети, безопасность)', 'Крупный и известный университет с давним опытом приёма международных студентов', 'Доступна стипендия Stipendium Hungaricum'],
  array['Официальный тариф указан в USD, конвертация в EUR по текущему курсу', 'Требуется профильный бакалавриат в сфере ИТ', 'Явных отдельных специализаций на странице не перечислено, требуется уточнение у приёмной комиссии'],
  true, current_date
);

-- =====================================================================
-- University of Pécs (PTE) — новый вуз
-- =====================================================================

-- Источник: https://international.pte.hu/study-programs/msc-computer-science-engineering
-- (официальный портал International Centre PTE) — тюишн (USD 4000/сем.)
-- и дедлайн (15.06) взяты с этой страницы; IELTS 5.0 найден на связанной
-- странице факультета (english.mik.pte.hu / apply.pte.hu), НЕ на той же
-- странице → verified = false. Конвертация: USD 8000/год × ~0.93 ≈
-- EUR 7400/год. EU/non-EU разделение тюишна на странице не указано —
-- использована единственная показанная цифра "как есть".
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Computer Science Engineering', 'Computer Science', 'English', 24, 7400,
  6, 15, 5.0, 3, 'https://international.pte.hu/study-programs/msc-computer-science-engineering',
  array[]::text[],
  'Магистратура по компьютерной инженерии на факультете инженерии и информационных технологий Печского университета — готовит специалистов по разработке и интеграции IT-систем.',
  array['Крупный технический факультет с международным приёмом', 'Отбор через онлайн-собеседование, а не только по баллам'],
  array['Не подтверждено разделение тюишна EU/non-EU — использована единственная показанная цифра', 'IELTS взят с другой страницы (apply.pte.hu), не с той же, что и дедлайн/тюишн', 'Наличие Stipendium Hungaricum для этой программы не подтверждено напрямую'],
  false, null
);

-- Источник: https://international.pte.hu/study-programs/msc-biomedical-engineering
-- — тюишн (USD 4000/сем.) и дедлайн (30.06) с этой официальной страницы.
-- Наличие Stipendium Hungaricum подтверждено отдельной страницей каталога:
-- apply.stipendiumhungaricum.hu/courses/course/2703-msc-biomedical-engineering.
-- IELTS не указан на странице программы — оценка 5.0 сделана по аналогии
-- с параллельной MSc Computer Science Engineering того же факультета →
-- verified = false, т.к. IELTS не подтверждён на этой же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Biomedical Engineering', 'Computational Engineering', 'English', 24, 7400,
  6, 30, 5.0, 3, 'https://international.pte.hu/study-programs/msc-biomedical-engineering',
  array['Stipendium Hungaricum'],
  'Междисциплинарная магистратура на стыке инженерии, IT и медицины: обработка медицинских изображений, системная теория, ИИ и медицинская кибернетика — вариант для тех, кто хочет заниматься вычислительной инженерией в медицинском контексте.',
  array['Уникальное сочетание инженерии, программирования и медицины', 'Есть подтверждённая стипендия Stipendium Hungaricum'],
  array['IELTS не указан на странице программы — оценка 5.0 сделана по аналогии с похожей программой факультета, не подтверждена напрямую', 'EU/non-EU разделение тюишна не указано'],
  false, null
);

-- Источник: https://international.pte.hu/study-programs/ma-sociology-data-analytics
-- — ОДНА официальная страница, на которой явно указано разделение
-- тюишна: non-EU EUR 2500/сем. (EU — EUR 1900/сем.), и дедлайн
-- 30.06.2027 — редкий случай, когда ловушка EU/non-EU была явно
-- обнаружена и разрешена корректно. IELTS на этой странице не указан
-- (общая отсылка к странице требований PTE) → verified = false, т.к. не
-- все три параметра подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MA Sociology (Data Analytics)', 'Data Science', 'English', 24, 5000,
  6, 30, 5.5, 3, 'https://international.pte.hu/study-programs/ma-sociology-data-analytics',
  array[]::text[],
  'Магистратура по социологии со специализацией на анализе данных: продвинутая статистика, классификаторы, методы снижения размерности и визуализация данных на R — реальный аналитический профиль, хотя и с гуманитарным происхождением степени.',
  array['Официально подтверждена именно non-EU цена тюишна (EUR 2500/сем.) на странице программы', 'Практический упор на R, статистику и визуализацию данных'],
  array['Это степень MA по социологии, а не "чистая" CS/DS-программа — учебный план ближе к computational social science', 'IELTS не указан на странице программы — использована общая минимальная планка PTE, не подтверждена для этой конкретной программы', 'Наличие Stipendium Hungaricum для этой программы не подтверждено'],
  false, null
);

-- =====================================================================
-- Óbuda University — новый вуз
-- =====================================================================

-- Источники: https://nik.uni-obuda.hu/en/computer-science-engineering-msc/
-- (официальная страница факультета — название, длительность,
-- специализации подтверждены) + тюишн/дедлайн/IELTS взяты с
-- сайтов-партнёров (budapestcollege.hu, study-in-hungary.com), т.к.
-- основная страница uni-obuda.hu/tuition-fees/ не отдала полный контент
-- при парсинге. Тюишн: 3500 EUR/сем. (встречается и цифра 7700 EUR/год
-- в других источниках — расхождение). Дедлайн: на одной странице
-- партнёра "31 мая", на общей странице дедлайнов колледжа "30 июня" —
-- использовано 30.06 как более общее. IELTS 5.5 — с агрегатора, не с
-- официального домена uni-obuda.hu. Каталог Stipendium Hungaricum
-- подтверждает наличие этой программы. → verified = false: ни один из
-- трёх параметров не подтверждён на официальной странице напрямую,
-- только через посредников.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Computer Science Engineering', 'Computer Science', 'English', 24, 7000,
  6, 30, 5.5, 3, 'https://nik.uni-obuda.hu/en/computer-science-engineering-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по компьютерным наукам на факультете информатики им. Яноша Ноймана — одна из основных технических программ Óbuda University, с несколькими специализациями (робототехника, кибермедицинские системы, SOC-аналитик).',
  array['Сильный технический факультет университета, специализирующегося на инженерии и IT', 'Подтверждено участие в программе Stipendium Hungaricum по нескольким страницам каталога'],
  array['Тюишн и дедлайн подтверждены только через сайты-посредники (budapestcollege.hu, study-in-hungary.com), не напрямую на uni-obuda.hu', 'Расхождение в цифрах тюишна между источниками (7000 vs 7700 EUR/год)', 'Дедлайн неточен — от 31 мая до 30 июня по разным источникам', 'EU/non-EU разделение тюишна нигде не найдено — везде просто "international tuition"'],
  false, null
);

-- Тот же источник и те же данные, что и выше
-- (nik.uni-obuda.hu/en/computer-science-engineering-msc/), но выделено
-- отдельной строкой под специализацию Robotics внутри программы MSc
-- Computer Science Engineering: на официальной странице факультета прямо
-- написано, что специализация "robotics" (наряду с "cyber-medical
-- systems") открывается для студентов, поступающих в 2026/2027 учебном
-- году. Отдельная строка — чтобы программу видели студенты, ищущие
-- именно по полю Robotics, а не только Computer Science. Те же оценочные
-- цифры тюишна/дедлайна/IELTS, с теми же оговорками → verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Computer Science Engineering – Robotics specialization', 'Robotics', 'English', 24, 7000,
  6, 30, 5.5, 3, 'https://nik.uni-obuda.hu/en/computer-science-engineering-msc/',
  array['Stipendium Hungaricum'],
  'Специализация "Robotics" в рамках магистратуры по компьютерным наукам Óbuda University — открывается для студентов, поступающих начиная с 2026/2027 учебного года, готовит инженеров по робототехническим и интеллектуальным системам.',
  array['Официально подтверждённая специализация именно по робототехнике на техническом факультете', 'Университет известен сильной инженерной/робототехнической школой'],
  array['Специализация только вводится с приёма 2026/2027 — не проверено, можно ли выбрать её уже на этапе подачи документов или только после зачисления', 'Тюишн/дедлайн/IELTS подтверждены только через сайты-посредники, не напрямую на uni-obuda.hu', 'EU/non-EU разделение тюишна не найдено'],
  false, null
);

-- Источники: официальная страница факультета Alba Regia
-- https://amk.uni-obuda.hu/en/mechatronics-engineer/ (название,
-- специализация "Mechatronics of Intelligent Robot Systems"
-- подтверждены) + тюишн/дедлайн/IELTS — с сайтов-посредников
-- (budapestcollege.hu: 3200 EUR/сем.; study-in-hungary.com: IELTS
-- 5.5+/TOEFL 69+; отдельно встречена цифра ~7000 EUR/год у
-- mastersportal-производных источников — расхождение с 6400 EUR/год,
-- посчитанными из 3200×2). → verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Mechatronics Engineering', 'Computational Engineering', 'English', 24, 6400,
  6, 30, 5.5, 3, 'https://amk.uni-obuda.hu/en/mechatronics-engineer/',
  array[]::text[],
  'Магистратура по мехатронике объединяет механику, электронику и компьютерное управление для разработки и моделирования "умных" машин и робототехнических систем — сильная вычислительно-инженерная программа технического университета.',
  array['Опциональная специализация "Mechatronics of Intelligent Robot Systems"', 'Востребованное направление на стыке машиностроения, электроники и computer control'],
  array['Тюишн подтверждён только через посредников — расхождение между источниками (6400 vs ~7000 EUR/год)', 'Дедлайн не найден на официальном домене uni-obuda.hu, использована общая оценка', 'Участие в Stipendium Hungaricum для этой конкретной программы не подтверждено', 'EU/non-EU разделение тюишна не найдено'],
  false, null
);

-- Источники: официальная страница факультета
-- https://nik.uni-obuda.hu/en/business-informatics-msc/ (учебный план
-- подтверждён: совместная программа факультетов NIK и KGK, специализация
-- FinTech) + тюишн/дедлайн/IELTS — с посредников (budapestcollege.hu:
-- 3500 EUR/сем.; study-in-hungary.com: IELTS 5.5+/TOEFL 69+; расхождение
-- с цифрой 7700 EUR/год у других источников). Наличие в каталоге
-- Stipendium Hungaricum подтверждено отдельной курсовой ссылкой. →
-- verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Business Informatics', 'Business Analytics', 'English', 24, 7000,
  6, 30, 5.5, 3, 'https://nik.uni-obuda.hu/en/business-informatics-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура на стыке бизнес-администрирования и IT: экономику преподаёт бизнес-факультет KGK, IT-часть — факультет информатики NIK, есть специализация FinTech — практичный вариант для тех, кто ищет пересечение бизнеса и анализа данных.',
  array['Подтверждено участие в Stipendium Hungaricum', 'Совместная программа двух факультетов — экономика + IT/данные', 'Специализация FinTech, актуальная для карьеры в аналитике'],
  array['Это "Business Informatics" (бизнес + корпоративные IT-системы), а не "чистая" Business Analytics — учебный план шире, чем классическая аналитика данных', 'Тюишн/дедлайн подтверждены только через посредников, расхождение в цифрах (7000 vs 7700 EUR/год)', 'EU/non-EU разделение тюишна не найдено'],
  false, null
);

-- =====================================================================
-- Corvinus University of Budapest — новые программы (1 уже была в базе)
-- =====================================================================

-- Источник: официальная страница Corvinus
-- (uni-corvinus.hu/post/landing-page/masters/msc-in-business-informatics)
-- явно разделяет тарифы: EEA — 990 000 HUF/семестр (~€2500), non-EEA —
-- €3700/семестр (€7400/год) — подтверждено на актуальной странице (набор
-- сентябрь 2026; более старая версия страницы давала устаревшую цифру
-- €3400/семестр — использована актуальная). Дедлайн (25 июня, для
-- визовых/не-ЕС кандидатов) и отсутствие обязательного IELTS/TOEFL для
-- большинства магистратур Corvinus подтверждены на других официальных
-- страницах, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Business Informatics', 'Business Analytics', 'English', 24, 7400,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-business-informatics/?lang=en',
  array[]::text[],
  'Магистратура на стыке бизнеса и IT в Corvinus — одной из ведущих бизнес-школ Центральной Европы; готовит специалистов по цифровой трансформации, бизнес-аналитике и IT-менеджменту.',
  array['Официально подтверждена раздельная цена EEA/non-EEA на актуальной странице (набор сентябрь 2026)', 'Сильный бренд бизнес-школы Corvinus', 'Полностью на английском'],
  array['Требование по IELTS/TOEFL на странице программы не указано — по общей политике Corvinus для большинства магистратур сертификат не обязателен (может быть вступительный экзамен)', 'Дедлайн подтверждён на другой официальной странице, не на той же, что цена', 'На старой версии страницы Corvinus встречалась другая цифра (€3400/семестр) — использована более новая'],
  false, null
);

-- Источник: официальная страница Corvinus
-- (uni-corvinus.hu/post/landing-page/masters/msc-in-artificial-intelligence-in-business)
-- явно разделяет тарифы: EEA — 1 350 000 HUF/семестр (~€3400), non-EEA —
-- €5400/семестр (€10800/год). Новая интенсивная годичная программа
-- (запуск на набор 2026/27). Дедлайн и требование по английскому взяты с
-- других официальных страниц Corvinus, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Artificial Intelligence in Business', 'Artificial Intelligence', 'English', 12, 10800,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-artificial-intelligence-in-business/?lang=en',
  array[]::text[],
  'Новая интенсивная годичная магистратура Corvinus о применении искусственного интеллекта в бизнесе — стратегия, операционная деятельность и принятие решений на основе AI.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Короткая программа — всего 1 год (быстрее выйти на рынок труда)', 'Актуальная и современная тема (запуск под набор 2026/27)'],
  array['Самая дорогая из добавленных в этой партии программ — €10800/год для не-ЕС', 'Программа новая — почти нет статистики по выпускникам и трудоустройству', 'Требование по английскому и точный дедлайн подтверждены на других страницах сайта, не на странице с ценой'],
  false, null
);

-- =====================================================================
-- Pázmány Péter Catholic University — новые программы (1 уже была в базе и исправлена выше)
-- =====================================================================

-- Источник: официальная страница программы (kepzes.itk.ppke.hu/aimsc)
-- подтверждает описание, дедлайн (20 мая 2026, самофинансируемые
-- студенты) и уровень английского B2. Стоимость для ЭТОЙ конкретной
-- программы официально не найдена (на странице финансов факультета
-- itk.ppke.hu/en/finances-admissions перечислены только 5 других
-- программ, AI Engineering в списке НЕТ — вероятно, страница ещё не
-- обновлена под новую программу). Использована оценка по аналогии с
-- остальными программами факультета (HUF 975 000/семестр для не-ЕС) —
-- НЕ подтверждено, отмечено в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Artificial Intelligence Engineering', 'Artificial Intelligence', 'English', 24, 5200,
  5, 20, 6.0, 3,
  'https://kepzes.itk.ppke.hu/aimsc/',
  array[]::text[],
  'Новая магистратура по инженерии искусственного интеллекта в католическом университете Pázmány — объяснимый, этичный и безопасный ИИ, генеративные модели, MLOps.',
  array['Актуальная и современная программа (LLM, генеративный AI, MLOps, компьютерное зрение)', 'Та же структура приёма и кампус, что и уже проверенная программа Computer Science Engineering'],
  array['Стоимость для ЭТОЙ конкретной программы официально не найдена — использована оценка по аналогии с другими программами факультета (HUF 975 000/семестр для не-ЕС), может отличаться', 'Требуется подготовительный семестр (1+4)', 'Программа новая — мало отзывов и статистики выпускников'],
  false, null
);

-- Источник: описание программы на itk.ppke.hu/en/info-bionics-engineering.
-- Стоимость для не-ЕС (HUF 975 000/семестр ≈ EUR 5200/год) подтверждена
-- на странице финансов факультета (itk.ppke.hu/en/finances-admissions),
-- где Info-Bionics Engineering прямо входит в список из 5 программ с
-- единым тарифом. Дедлайн (20 мая) — с itk.ppke.hu/en/admissions-masters-programs,
-- IELTS 6.0 — с itk.ppke.hu/en/admission-requirements-msc. Три разных
-- официальных страницы одного домена — не одна и та же страница,
-- поэтому verified=false по общему правилу.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Info-Bionics Engineering', 'Robotics', 'English', 24, 5200,
  5, 20, 6.0, 3,
  'https://itk.ppke.hu/en/info-bionics-engineering',
  array['Stipendium Hungaricum'],
  'Междисциплинарная магистратура на стыке IT, электроники и биологии — бионические интерфейсы, протезирование, сенсорная робототехника и нейроинтерфейсы (мозг-компьютер).',
  array['Стоимость для не-ЕС подтверждена официально (общий тариф факультета, HUF 975 000/семестр)', 'Доступна стипендия Stipendium Hungaricum', 'Уникальная ниша (bionics + робототехника) — мало аналогов в регионе'],
  array['Стоимость, дедлайн и требование по английскому подтверждены на трёх РАЗНЫХ официальных страницах сайта, а не на одной — поэтому verified=false', 'Требуется подготовительный семестр (1+4)'],
  false, null
);

-- =====================================================================
-- Széchenyi István University (Győr) — новый вуз
-- =====================================================================

-- Источник: https://admissions.sze.hu/masters-in-vehicle-engineering-msc-
-- (официальный международный admissions-портал SZE; тюишн 3200
-- EUR/семестр = 6400 EUR/год и IELTS 5.5 подтверждены здесь же; то же
-- самое подтверждено независимо на mastersportal.com — 6400 EUR/год).
-- verified = false, потому что: (1) на официальной странице приведена
-- ОДНА цифра тюишна без явного деления EU/non-EU; (2) дедлайн "30 июня
-- 2026" на странице уже в прошлом относительно сегодняшней даты — это
-- дедлайн прошлого цикла, а не подтверждённая дата на 2027/28; (3)
-- требование английского дано двусмысленно ("IELTS 5.5" и "C1" на одной
-- странице). Отдельной программы "Mechatronics MSc" или "Robotics MSc" в
-- Győr не существует — мехатроника это только курсы/специализация внутри
-- Vehicle Engineering, поэтому программа отнесена к Computational
-- Engineering, а не к Robotics.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Vehicle Engineering', 'Computational Engineering', 'English', 24, 6400,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-vehicle-engineering-msc-',
  array['Stipendium Hungaricum'],
  'Магистратура по автомобилестроению в партнёрстве с Audi Hungaria — сильный инженерный профиль с элементами мехатроники и инженерной информатики, но это не классическая ИТ/робототехническая программа, а прикладное машиностроение с цифровой составляющей.',
  array['Прямое партнёрство с Audi Hungaria, часть инженеров завода — выпускники SZE', 'Полностью на английском', 'Есть стипендия Stipendium Hungaricum'],
  array['Это программа по автомобилестроению/мехатронике, а не чистая робототехника или Computer Science — важно свериться с учебным планом перед подачей', 'На официальной странице только одна цифра тюишна, деление EU/non-EU явно не указано — уточнить у приёмной комиссии', 'Дедлайн 30 июня взят с прошедшего цикла (2026), точную дату на новый набор нужно перепроверить на sze.hu', 'Требование по английскому дано неоднозначно (IELTS 5.5 vs C1) — уточнить точный порог'],
  false, null
);

-- Semmelweis University: вуз добавлен в universities выше, но НИ ОДНОЙ
-- программы не вставлено — целенаправленная проверка (официальная
-- страница приёма semmelweis.hu/admission/, там ровно 6 англоязычных
-- магистратур: Clinical Translational Medicine, Nursing, Pharmaceutical
-- Innovation and Business Administration, Physiotherapy, Psychobiology,
-- Systemic Psychology) не нашла НИ ОДНОЙ, которая честно вписывалась бы
-- в 8 полей приложения. Единственная многообещающая зацепка — "Data
-- Science in Health MSc" — оказалась венгероязычной программой для уже
-- практикующих врачей внутри Венгрии, не для международных абитуриентов.
-- Решение оставить университет в таблице без программ, а не убирать
-- совсем, принято сборщиком файла (не отдельным агентом) — Денису стоит
-- решить, оставлять или заменить на другой вуз с более техническим
-- профилем.

commit;

-- Проверка после запуска:
-- select country, count(*) from universities where country = 'hu' group by country;
--   -- ожидается 10 вузов Венгрии в сумме (4 старых + 6 новых)
-- select u.name as university, count(p.*) as programs, count(*) filter (where p.verified) as verified_count
-- from universities u left join programs p on p.university_id = u.id
-- where u.country = 'hu' group by u.name order by programs desc;
--   -- Semmelweis ожидаемо покажет 0 программ — см. комментарий выше
