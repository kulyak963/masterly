-- Топ-10 вузов Венгрии — ВТОРАЯ партия, расширенный поиск внутри тех же
-- 8 полей приложения. Денис посмотрел на первую партию
-- (2026-08-28-hungary-top10-batch.sql, 23 программы) и справедливо
-- заметил: "внутри направления может быть куча программ с разными
-- названиями. Бизнес аналитика, управление бизнесом, международный
-- менеджмент, к примеру." В первом проходе агенты нашли по одной
-- "очевидной" программе на поле и останавливались — а у большинства
-- вузов на самом деле есть 5-15+ программ, которые честно попадают в
-- наши 8 категорий под разными официальными названиями.
--
-- Категории сайта НЕ менялись (это код, отдельная задача) — просто
-- поиск внутри тех же 8 полей стал гораздо шире: под 'Business
-- Analytics' теперь также Business Administration, International
-- Management, Marketing (если про данные), Finance, Accounting,
-- количественная Economics, Supply Chain/Logistics, Health Care
-- Management (если управленческая, не клиническая); под 'Computational
-- Engineering' — почти любая инженерная магистратура с вычислительной
-- составляющей (Electrical/Mechanical/Civil/Structural/Transportation/
-- Geoinformatics и т.д.); аналогично расширены остальные поля. Полный
-- список правил классификации — в истории задач агентам, коротко
-- продублирован в комментариях над INSERT-ами ниже, где это неочевидно.
--
-- Итог: 61 новая программа (было 23 в первой партии — итого 84 новые
-- программы за оба захода + 2 исправления старых записей). Разброс по
-- вузам честно отражает разницу в размере их англоязычного каталога:
-- BME +12, Corvinus +9, Széchenyi István +12, Debrecen +7 — это крупные
-- университеты с большим количеством факультетов; Semmelweis +1 — это
-- медицинский вуз, у него физически почти нет непрофильных программ.
--
-- Правило verified=true/false — то же самое, что в первой партии: true
-- только когда тюишн + дедлайн + языковое требование подтверждены на
-- ОДНОЙ официальной странице, явно для не-ЕС ставки. В этой партии
-- отдельно интересно: у Corvinus (Corvinus) практически ВСЕ проверенные
-- страницы программ системно показывают явное EU/non-EU разделение — это
-- не исключение, а стандарт сайта; у Széchenyi István и Óbuda наоборот —
-- сайт вообще нигде не разделяет тарифы явно, это тоже системная
-- особенность конкретного сайта, а не пробел в поиске.
--
-- Много новых программ помечены как "натяжка, но честная" — где название
-- программы (Marketing, Management, International Economy and Business,
-- Applied Mathematics, Geoinformatics и т.п.) не идеально соответствует
-- нашей категории, но учебный план даёт достаточно оснований для
-- расширенного включения. Все такие случаи явно помечены в cons каждой
-- записи — если что-то покажется натянутым, легче всего найти именно
-- через текст в cons.
--
-- avg_salary_after и acceptance_rate — NULL везде, как и раньше.

begin;

-- =====================================================================
-- ELTE — 3 новые программы
-- =====================================================================

-- Geoinformatics MSc — источник: ОДНА официальная страница
-- https://www.elte.hu/en/geoinformatics-msc, на ней явно указано: тюишн
-- 3200 EUR/семестр ОДИНАКОВО для EU/EEA и non-EU/EEA; дедлайн 30 апреля
-- 2026 на сентябрьский поток; языковое требование — B2, фиксированного
-- балла IELTS нет. Все три факта — с одной страницы → verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Geoinformatics MSc', 'Computational Engineering', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.elte.hu/en/geoinformatics-msc',
  array['Stipendium Hungaricum'],
  'Магистратура ELTE по геоинформатике: обработка и управление пространственными данными, ГИС, картовизуализация. Тюишн одинаков для студентов из ЕС и не из ЕС.',
  array['Все ключевые данные подтверждены на одной официальной странице', 'Тюишн явно одинаков для EU и non-EU — нет скрытой надбавки', 'Открыта для абитуриентов с разным бэкграундом — computer science, география, картография'],
  array['Фиксированного балла IELTS нет — только общий уровень B2, уточнить при подаче', 'Только сентябрьский поток, весеннего нет'],
  true, current_date
);

-- Cartography MSc — источник: ОДНА официальная страница
-- https://www.elte.hu/en/cartography-msc. Тюишн 3200 EUR/семестр явно
-- ОДИНАКОВ для EU/EEA и non-EU/EEA; дедлайн 30 апреля 2026; языковое
-- требование B2, вместо IELTS — письменный вступительный тест. Все три
-- факта — с одной страницы → verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Cartography MSc', 'Computational Engineering', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.elte.hu/en/cartography-msc',
  array['Stipendium Hungaricum'],
  'Магистратура ELTE по картографии с сильным вычислительным компонентом: картографическое ПО, пространственные базы данных, программирование веб-ГИС на открытом коде.',
  array['Все ключевые данные подтверждены на одной официальной странице', 'Тюишн явно одинаков для EU и non-EU', 'Современный вычислительный уклон (Open Source Web GIS Programming), а не только классическая картография'],
  array['Есть письменный вступительный тест (20-25 вопросов) вместо интервью — стоит заранее подготовиться', 'Только сентябрьский поток'],
  true, current_date
);

-- Mechanical Engineering MSc — источник: страница
-- https://www.inf.elte.hu/en/apply-mechanical-engineering-msc. Тюишн
-- (3200 EUR/семестр), дедлайн (30 апреля) и упоминание IELTS как
-- подтверждения языка — но НЕТ явного разделения EU/non-EU → verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Mechanical Engineering MSc', 'Computational Engineering', 'English', 24, 6400,
  4, 30, null, 3, 'https://www.inf.elte.hu/en/apply-mechanical-engineering-msc',
  array['Stipendium Hungaricum'],
  'Магистратура ELTE по машиностроению — админится совместно с факультетом информатики, что даёт заметный вычислительный/IT-уклон по сравнению с классическими программами машиностроения.',
  array['Необычное сочетание — машиностроение через факультет информатики, сильный computational-уклон', 'IELTS явно принимается как подтверждение языка'],
  array['На странице тюишн НЕ разделён на EU/non-EU (указана только одна ставка) — не факт, что это именно non-EU ставка', 'Точный минимальный балл IELTS на странице не указан — язык также проверяется на интервью'],
  false, null
);

-- =====================================================================
-- BME — 12 новых программ
-- =====================================================================
-- Все — с официального портала xplore.bme.hu: тюишн с явным разделением
-- EU/non-EU взят с общей таблицы xplore.bme.hu/tuition-fees/, дедлайн и
-- IELTS — с xplore.bme.hu/admission/ (окно 1 апр — 15 мая, IELTS 5.0/B2
-- общий минимум BME), длительность — со списка
-- xplore.bme.hu/available-programmes/. Факты подтверждены на разных
-- страницах одного официального домена (не на одной странице), поэтому
-- все — verified=false, как и остальные записи BME в первой партии.

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Construction Information Technology Engineer MSc', 'Computational Engineering', 'English', 18, 7600,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/consrtuction-information-technology-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура на стыке гражданского строительства и информационных технологий (BIM, цифровое моделирование зданий) в BME.',
  array['Актуальная тема — цифровизация строительной отрасли (BIM)', 'Короткая программа — 1.5 года вместо стандартных 2 лет'],
  array['Тюишн/дедлайн/IELTS подтверждены на разных страницах официального сайта BME, не на одной — verified=false', 'Короткая длительность (3 семестра) может означать более сжатый учебный план — уточнить нагрузку'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Electrical Engineer MSc', 'Computational Engineering', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/electrical-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Классическая магистратура по электротехнике в ведущем техническом вузе Венгрии — база для карьеры в энергетике, электронике и смежных инженерных отраслях.',
  array['Широкий выбор индустрий трудоустройства (энергетика, электроника, автоматизация)', 'Тюишн подтверждён официальной таблицей BME для non-EU'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Infrastructural Engineer MSc', 'Computational Engineering', 'English', 18, 7600,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/infrastructural-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по инфраструктурному строительству (автодороги, железные дороги, водные и гидро-экологические системы) в BME.',
  array['Две узкие специализации (дороги/ж/д и водное хозяйство) — понятная карьерная траектория'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Короткая программа (1.5 года) — уточнить, засчитывается ли она как полноценная магистратура в стране абитуриента'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Land Surveying and Geographical Information Systems Engineering MSc', 'Computational Engineering', 'English', 24, 7600,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/land-surveying-and-geographical-information-systems-engineering-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по геодезии и геоинформационным системам: БПЛА-съёмка, спутниковое позиционирование, обработка геопространственных данных и цифровые двойники местности.',
  array['Сильный вычислительный/data-компонент (геопространственный анализ, цифровые двойники)', 'Востребованные прикладные навыки — дистанционное зондирование, мониторинг климата'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Structural Engineer MSc', 'Computational Engineering', 'English', 18, 7600,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/structural-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по строительным конструкциям с тремя специализациями: численное моделирование, конструкции и геотехника.',
  array['Специализация «численное моделирование» — сильный вычислительный уклон внутри классической строительной инженерии'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Короткая программа (1.5 года)'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Transportation Engineer MSc', 'Computational Engineering', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/transportation-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по транспортной инженерии с пятью специализациями: транспортные системы, автоматизация транспорта, управление и экспедирование грузов.',
  array['Широкий выбор специализаций внутри программы', 'Растущая отрасль — автоматизация и умные транспортные системы'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Vehicle Engineer MSc', 'Computational Engineering', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/vehicle-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по конструированию транспортных средств: проектирование, производство, эксплуатация и диагностика автомобилей.',
  array['Отличается от уже занесённой в базу Autonomous Vehicle Control Engineer MSc — здесь общее машиностроение транспорта, а не только автономное управление'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Риск путаницы с программой Autonomous Vehicle Control Engineer MSc — стоит явно показать абитуриенту разницу'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Finance MSc', 'Business Analytics', 'English', 24, 4400,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/finance-ma/',
  array['Stipendium Hungaricum'],
  'Магистратура по финансам с аккредитацией EFMD: инвестиционный анализ, риск-менеджмент, корпоративные и банковские финансы. Специализации — риск-менеджмент и финансовый анализ.',
  array['Международная аккредитация EFMD (март 2025) — признаётся работодателями', 'Самый низкий тюишн среди программ BME из нашей выборки (2200 EUR/семестр non-EU)'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Management and Leadership MSc', 'Business Analytics', 'English', 24, 4400,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/management-and-leadership-ma/',
  array['Stipendium Hungaricum'],
  'Магистратура по менеджменту с аккредитацией EFMD: количественное принятие решений, операционный менеджмент, бизнес-аналитика, маркетинг, международная стратегия.',
  array['Международная аккредитация EFMD', 'Программа явно включает «business analytics» и количественные методы в учебный план'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Старт только в сентябре, нет весеннего потока'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Logistics Engineer MSc', 'Business Analytics', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/logistics-engineer-msc/',
  array['Stipendium Hungaricum'],
  'Магистратура по логистической инженерии: управление цепочками поставок в сочетании с инженерными и IT-дисциплинами.',
  array['Сочетание инженерного и управленческого профиля — редкое и востребованное на рынке труда сочетание'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Тюишн выше (3500 EUR/семестр), чем у чисто экономических программ той же школы'],
  false, null
);

-- Источник по Engineering Management MSc: официальная страница профильной
-- кафедры en.mvt.bme.hu/programs/msc — отдельной страницы на портале
-- xplore.bme.hu для этой программы не нашлось (404). Тюишн — из общей
-- таблицы xplore.bme.hu/tuition-fees/, дедлайн/IELTS — общая страница
-- admission.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Engineering Management MSc', 'Business Analytics', 'English', 24, 7000,
  5, 15, 5.0, 3, 'http://en.mvt.bme.hu/programs/msc',
  array['Stipendium Hungaricum'],
  'Магистратура для инженеров, которые хотят перейти в управление: технологический менеджмент, проектный менеджмент, маркетинг и производственный менеджмент.',
  array['Хорошее сочетание для абитуриента с инженерным бакалавриатом, который хочет в менеджмент, не теряя технический бэкграунд'],
  array['Не нашли отдельную страницу программы на официальном портале xplore.bme.hu — источник url ведёт на страницу профильной кафедры', 'Тюишн/дедлайн/IELTS с разных страниц — verified=false', 'Старт только в сентябре'],
  false, null
);

-- Applied Mathematics MSc — специализация "Stochastics and Financial
-- Mathematics" явно про данные — отнесена к Data Science, а не к чистой
-- математике.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'Applied Mathematics MSc', 'Data Science', 'English', 24, 7000,
  5, 15, 5.0, 3, 'https://xplore.bme.hu/programme/applied-mathematics-msc/',
  array['Stipendium Hungaricum'],
  'Прикладная математика со специализацией «стохастика и финансовая математика»: теория вероятностей, статистика, практические курсы от индустрии и финансового сектора.',
  array['Сильная математическая база — открывает дорогу в data science, квант-финансы, риск-анализ', 'Курсы напрямую от индустрии и финансового сектора'],
  array['Тюишн/дедлайн/IELTS с разных страниц официального сайта — verified=false', 'Это не программа по Data Science в чистом виде, а прикладная математика'],
  false, null
);

-- =====================================================================
-- University of Szeged — 3 новые программы
-- =====================================================================

-- Источник: u-szeged.hu/english/study-programmes/international-economy-and-business
-- (тюишн 3000 EUR/сем. = 6000 EUR/год подтверждён на этой странице).
-- Учебный план квантитативный (Statistics/аналитика). НЕ verified:
-- дедлайн взят с общей страницы факультета (eco.u-szeged.hu), не с
-- этой; IELTS 6.0 — из вторичного источника; EU/non-EU не разделено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5f6beb6e-d0d9-4216-8f38-958908f66feb',
  'MSc International Economy and Business', 'Business Analytics', 'English', 24, 6000,
  6, 30, 6.0, 3,
  'https://u-szeged.hu/english/study-programmes/international-economy-and-business',
  array['Stipendium Hungaricum'],
  'Магистратура по международной экономике и бизнесу в Университете Сегеда с упором на международные финансы, стратегический менеджмент и анализ данных для бизнес-решений.',
  array['Международная ориентация программы (торговля, финансы, межкультурная коммуникация)', 'Доступна стипендия Stipendium Hungaricum', 'Требуется всего 60 ECTS в профильной области для поступления'],
  array['Дедлайн подачи не указан на странице самой программы — использовано общее значение с сайта факультета экономики', 'Точный балл IELTS не подтверждён на официальной странице программы', 'Разделение тарифов ЕС/не-ЕС не подтверждено', 'Программа больше про международный бизнес в целом, чем про аналитику как таковую'],
  false, null
);

-- Источник: u-szeged.hu/english/applied-mathematics-msc (тюишн 2700
-- EUR/сем. = 5400 EUR/год и IELTS 5.5 подтверждены на этой же странице).
-- Классическая прикладная математика (не явный data/ML-профиль) —
-- отнесена к Data Science по расширенному правилу, но со оговоркой.
-- Дедлайн — оценка по аналогии с MSc Computer Science той же кафедры.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5f6beb6e-d0d9-4216-8f38-958908f66feb',
  'MSc Applied Mathematics', 'Data Science', 'English', 24, 5400,
  5, 15, 5.5, 3,
  'https://u-szeged.hu/english/applied-mathematics-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по прикладной математике в Университете Сегеда с тремя специализациями: прикладной анализ, индустриальная математика и финансовая математика.',
  array['Сильная теоретическая база от математического института им. Бойяи', 'Специализация Financial Mathematics полезна для карьеры в аналитике/финтехе', 'Доступна стипендия Stipendium Hungaricum'],
  array['ВАЖНО: программа классическая математическая, а не про data science/ML в чистом виде — соответствие категории умеренное', 'Дедлайн подачи не указан на официальной странице — использована оценка по аналогии (15 мая)', 'Разделение тарифов ЕС/не-ЕС не подтверждено'],
  false, null
);

-- Источник: u-szeged.hu/english/geoinformatics-msc (тюишн 3200 EUR/сем.
-- = 6400 EUR/год и IELTS 5.5 подтверждены на этой же странице). Учебный
-- план явно вычислительный (геостатистика, программирование, ГИС) —
-- уверенно попадает в Data Science.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5f6beb6e-d0d9-4216-8f38-958908f66feb',
  'MSc Geoinformatics', 'Data Science', 'English', 24, 6400,
  5, 15, 5.5, 3,
  'https://u-szeged.hu/english/geoinformatics-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по геоинформатике в Университете Сегеда: работа с большими пространственными данными — геостатистика, программирование, ГИС-анализ, дистанционное зондирование, дроны, веб-картография.',
  array['Сильный вычислительный/data-уклон (программирование, базы данных, геостатистика)', 'Востребованная ниша на стыке данных и наук о Земле', 'Доступна стипендия Stipendium Hungaricum'],
  array['Дедлайн подачи не указан на официальной странице — использована оценка по аналогии (15 мая)', 'Разделение тарифов ЕС/не-ЕС не подтверждено', 'Требуется профильный бакалавриат'],
  false, null
);

-- =====================================================================
-- University of Debrecen — 7 новых программ
-- =====================================================================
-- Все — официальная страница edu.unideb.hu/p/... (тюишн, дедлайн, IELTS
-- на одной странице); отсутствие разделения ЕС/не-ЕС подтверждено общей
-- страницей тарифов вуза. Конвертация: $7500-8000 × 0.858 (курс на
-- 27.08.2026).

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/artificial-intelligence-msc',
  array[]::text[],
  'Магистратура по искусственному интеллекту в Дебреценском университете: нейросети, глубокое обучение, генеративный ИИ, NLP, MLOps на первом курсе; explainable AI, робототехника и приложения кибербезопасности — на втором.',
  array['Очень современный и насыщенный учебный план (LLM/генеративный ИИ, MLOps, explainable AI)', 'Обязательная 6-недельная стажировка', 'Гибкие требования к бакалавриату'],
  array['Не найдено подтверждения, что программа есть в каталоге Stipendium Hungaricum — стипендия под вопросом', 'Тариф в USD, конвертация в EUR по плавающему курсу'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Electrical Engineering', 'Computational Engineering', 'English', 24, 6864,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/electrical-engineering-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по электротехнике в Дебреценском университете с сильным вычислительным уклоном: теория управления, IoT-системы, обработка сигналов, встраиваемые системы, сети датчиков.',
  array['Хороший баланс "железа" и вычислительных/встраиваемых систем', 'Доступна стипендия Stipendium Hungaricum', 'Два потока приёма в год (сентябрь и февраль)'],
  array['Тариф выше, чем у большинства других программ Дебрецена ($8000 vs $7500/год)', 'Тариф в USD, конвертация в EUR по плавающему курсу', 'Требуется профильный инженерный бакалавриат'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Mechatronical Engineering', 'Robotics', 'English', 24, 6864,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/mechatronical-engineering-msc',
  array[]::text[],
  'Магистратура по мехатронике в Дебреценском университете: динамические системы, электроника, теория управления, цифровые и сервоприводы, встраиваемые системы, обработка изображений.',
  array['Прямое попадание в категорию "робототехника" (мехатроника, приводы, управление)', 'Практический уклон — обязательная стажировка', 'Два потока приёма в год'],
  array['В каталоге Stipendium Hungaricum найдена только бакалаврская версия программы, магистерская — нет', 'Тариф в USD, конвертация в EUR по плавающему курсу', 'Требуется бакалавриат по мехатронике или близкому направлению'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Mechanical Engineering', 'Computational Engineering', 'English', 24, 6864,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/mechanical-engineering-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по машиностроению в Дебреценском университете с курсами по прикладной статистике, моделированию, симуляции и оптимизации производственных процессов.',
  array['Учебный план включает симуляцию, оптимизацию и прикладную статистику — не только "классическое" машиностроение', 'Доступна стипендия Stipendium Hungaricum', 'Два потока приёма в год'],
  array['Тариф выше, чем у CS-программ Дебрецена ($8000 vs $7500/год)', 'Тариф в USD, конвертация в EUR по плавающему курсу', 'Требуется профильный инженерный бакалавриат'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Geoinformatics', 'Data Science', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/geoinformatics-msc',
  array[]::text[],
  'Магистратура по геоинформатике в Дебреценском университете: управление базами данных, LiDAR, фотограмметрия, дроны, веб-картография, дистанционное зондирование, программирование.',
  array['Явный вычислительный/data-уклон на втором курсе (анализ данных, дистанционное зондирование, программирование)', 'Востребованная ниша на стыке геонаук и данных', 'Два потока приёма в год'],
  array['Наличие стипендии Stipendium Hungaricum для этой конкретной программы (Дебрецен) не подтверждено', 'Тариф в USD, конвертация в EUR по плавающему курсу', 'Требуется бакалавриат в науках о Земле или смежной области'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc International Economy and Business', 'Business Analytics', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/international-economy-and-business-msc',
  array[]::text[],
  'Магистратура по международной экономике и бизнесу в Дебреценском университете с явным количественным уклоном: статистика и эконометрика, международная торговля и финансы, международный учёт и информационные системы.',
  array['Учебный план заметно более количественный/аналитический, чем у аналогичной программы в Сегеде (статистика и эконометрика с 1 курса)', 'Обязательная стажировка', 'Два потока приёма в год'],
  array['Наличие стипендии Stipendium Hungaricum отдельно не подтверждено', 'Тариф в USD, конвертация в EUR по плавающему курсу', 'Требуется бакалавриат в экономике/бизнесе/менеджменте'],
  true, current_date
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a8cf0bd2-def9-4628-8019-4a5e978978c4',
  'MSc Applied Mathematics', 'Data Science', 'English', 24, 6435,
  6, 15, 6.0, 3,
  'https://edu.unideb.hu/p/applied-mathematics-msc',
  array['Stipendium Hungaricum'],
  'Магистратура по прикладной математике в Дебреценском университете: алгебра, оптимизация, теория вероятностей и финансовая математика на первом курсе, дифференциальные уравнения, многомерный анализ и эконометрика — на втором.',
  array['Эконометрика и многомерный анализ дают неплохую базу для карьеры в data science', 'Доступна стипендия Stipendium Hungaricum', 'Выпускников готовят в том числе к карьере в software development'],
  array['ВАЖНО: программа классическая математическая, специализированных data science/ML курсов в плане не обнаружено — соответствие категории умеренное', 'Тариф в USD, конвертация в EUR по плавающему курсу'],
  true, current_date
);

-- =====================================================================
-- University of Pécs — 4 новые программы
-- =====================================================================
-- Источник полного каталога магистратур PTE:
-- international.pte.hu/admission/study-programs/master-courses (52
-- программы, вручную классифицированы).

-- Источник: international.pte.hu/study-programs/msc-structural-engineering
-- — тьюишн (USD 4000/сем.) и дедлайн (30.06) с этой страницы. IELTS —
-- оценка по аналогии с параллельной программой факультета.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Structural Engineering', 'Computational Engineering', 'English', 18, 7400,
  6, 30, 5.0, 3, 'https://international.pte.hu/study-programs/msc-structural-engineering',
  array[]::text[],
  'Ускоренная (1.5 года) магистратура по расчёту и проектированию строительных конструкций на факультете инженерии и IT Печского университета.',
  array['Короткая программа — 3 семестра вместо стандартных 4', 'Тот же сильный технический факультет, что и у Computer Science Engineering'],
  array['IELTS не указан на странице программы — оценка сделана по аналогии с похожей программой факультета', 'EU/non-EU разделение тьюишна не указано', 'Наличие Stipendium Hungaricum не подтверждено для этой программы'],
  false, null
);

-- Источник: international.pte.hu/study-programs/msc-geoinformatics —
-- тьюишн сразу в EUR (4000/сем.) и дедлайн (30.06) с этой же официальной
-- страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Geoinformatics', 'Data Science', 'English', 24, 8000,
  6, 30, 5.5, 3, 'https://international.pte.hu/study-programs/msc-geoinformatics',
  array[]::text[],
  'Магистратура по геоинформатике: геоинформационные системы, дистанционное зондирование, программирование, пространственные базы данных и 3D-визуализация.',
  array['Тьюишн указан сразу в EUR на официальной странице — не требует конвертации из USD', 'Практический упор на программирование и работу с большими пространственными данными, включая обязательную 6-недельную практику'],
  array['IELTS не указан на странице программы — использована общая оценка PTE', 'EU/non-EU разделение тьюишна не указано', 'Это нишевая специализация (геоданные), а не "чистый" Data Science'],
  false, null
);

-- Источник: international.pte.hu/study-programs/msc-business-development —
-- РЕДКИЙ случай полного подтверждения EU/non-EU разделения: non-EU EUR
-- 3150/сем. против EU HUF 400 000/сем. (non-EU платит более чем в 3
-- раза больше EU-студента), и дедлайн 30.09.2026 — оба на одной
-- странице. Нестандартный весенний старт (1 февраля 2027). IELTS явно
-- не указан → verified=false несмотря на подтверждённые тюишн/дедлайн.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Business Development', 'Business Analytics', 'English', 24, 6300,
  9, 30, 5.0, 3, 'https://international.pte.hu/study-programs/msc-business-development',
  array[]::text[],
  'Магистратура по развитию бизнеса: инновационный менеджмент, бизнес-моделирование, стартап-развитие, e-commerce.',
  array['Официально подтверждена именно non-EU цена тьюишна на странице программы (EUR 3150/сем. против EUR ~1000/сем. для EU)', 'Прикладной фокус на инновациях и предпринимательстве'],
  array['Необычный старт в феврале, а не в сентябре — дедлайн 30.09 относится к весеннему набору', 'Учебный план без выраженного data/analytics компонента', 'IELTS на странице не указан (только общий CEFR B2)'],
  false, null
);

-- Источник: international.pte.hu/study-programs/msc-management-and-leadership
-- — та же официальная страница даёт явное EU/non-EU разделение: non-EU
-- EUR 3150/сем. против EU HUF 400 000/сем., дедлайн 30.09.2026.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '28789f41-cd51-446a-a930-d6247d54f78d',
  'MSc Management and Leadership', 'Business Analytics', 'English', 24, 6300,
  9, 30, 5.0, 3, 'https://international.pte.hu/study-programs/msc-management-and-leadership',
  array[]::text[],
  'EFMD-аккредитованная магистратура по менеджменту и лидерству со специализациями Service или Finance: продвинутый учёт, международные финансы, стратегическое управление персоналом.',
  array['Официально подтверждена именно non-EU цена тьюишна на странице программы', 'EFMD-аккредитация — признанный международный знак качества бизнес-образования', 'Есть выбор специализации Finance'],
  array['Учебный план в целом ориентирован на управление, а не на анализ данных', 'IELTS на странице не указан (только общий CEFR B2)'],
  false, null
);

-- =====================================================================
-- Óbuda University — 4 новые программы
-- =====================================================================

-- Источник: nik.uni-obuda.hu/en/data-science-msc/ (официальная страница
-- факультета информатики). Тьюишн (3500 EUR/сем.) — с сайта-партнёра
-- budapestcollege.hu, т.к. официальная страница не публикует финансовые
-- условия. Участие в Stipendium Hungaricum подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Data Science', 'Data Science', 'English', 24, 7000,
  6, 30, 5.5, 3, 'https://nik.uni-obuda.hu/en/data-science-msc/',
  array['Stipendium Hungaricum'],
  'Прямая профильная магистратура по Data Science на факультете информатики им. Яноша Ноймана: работа со сложными наборами данных, преобразование сырых данных, построение моделей.',
  array['Название и содержание программы напрямую совпадают с полем "Data Science"', 'Подтверждено участие в Stipendium Hungaricum'],
  array['Тьюишн и дедлайн подтверждены только через сайт-посредник, не на официальном домене uni-obuda.hu напрямую', 'IELTS не подтверждён именно для этой программы', 'EU/non-EU разделение тьюишна не найдено'],
  false, null
);

-- Источник: nik.uni-obuda.hu/en/applied-mathematics-msc-2/ — уникальная
-- специализация "Engineering computational methods", страница прямо
-- перечисляет data science, machine learning, big data и computer
-- vision как карьерные направления выпускников. IELTS 5.5+ подтверждён
-- именно для этой программы на study-in-hungary.com.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Applied Mathematics', 'Data Science', 'English', 24, 7000,
  6, 30, 5.5, 3, 'https://nik.uni-obuda.hu/en/applied-mathematics-msc-2/',
  array['Stipendium Hungaricum'],
  'Магистратура по прикладной математике с уникальной для Венгрии специализацией "Engineering computational methods": алгоритмы, дискретная математика, статистика, машинное обучение и big data.',
  array['Официальная страница напрямую упоминает data science, machine learning и big data как карьерные направления выпускников', 'IELTS 5.5 подтверждён именно для этой программы на сайте-партнёре', 'Подтверждено участие в Stipendium Hungaricum'],
  array['Тьюишн подтверждён только через посредника, есть небольшое расхождение между источниками', 'Точный дедлайн для самофинансируемых студентов не найден на официальном домене', 'EU/non-EU разделение тьюишна не найдено'],
  false, null
);

-- Источник: kvk.uni-obuda.hu/en/msc-courses/ (факультет Kandó Kálmán —
-- специализации Automation, Communication Technologies, Embedded
-- Systems, Energy). IELTS — оценка по общей политике вуза, отдельная
-- страница именно под эту программу не найдена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Electrical Engineering', 'Computational Engineering', 'English', 24, 6400,
  6, 30, 5.5, 3, 'https://kvk.uni-obuda.hu/en/msc-courses/',
  array['Stipendium Hungaricum'],
  'Магистратура по электротехнике на факультете им. Кальмана Кандо: автоматизация, встроенные системы, энергетика и коммуникационные технологии.',
  array['Несколько специализаций на выбор (Automation, Embedded Systems, Energy и др.)', 'Подтверждено участие в Stipendium Hungaricum через каталог'],
  array['IELTS не подтверждён именно для этой программы — оценка сделана по общей политике вуза', 'Тьюишн и дедлайн — только через сайт-посредник, не с официального домена', 'EU/non-EU разделение тьюишна не найдено'],
  false, null
);

-- Источник: kgk.uni-obuda.hu/en/bd-2/ (факультет Keleti Károly). IELTS
-- 5.5+ подтверждён именно для этой программы на study-in-hungary.com.
-- Участие в Stipendium Hungaricum подтверждено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9e2b922d-5430-4f9c-a071-d279a8fc407b',
  'MSc Business Development', 'Business Analytics', 'English', 24, 6400,
  6, 30, 5.5, 3, 'https://kgk.uni-obuda.hu/en/bd-2/',
  array['Stipendium Hungaricum'],
  'Магистратура по развитию бизнеса на факультете бизнеса и менеджмента им. Кароя Кэлети: инновационный менеджмент, бизнес-моделирование, финансы для стартапов и e-commerce.',
  array['IELTS 5.5 подтверждён именно для этой программы на сайте-партнёре', 'Подтверждено участие в Stipendium Hungaricum', 'Тьюишн заметно ниже, чем у технических программ того же университета'],
  array['Учебный план ориентирован на предпринимательство/менеджмент, а не на анализ данных как таковой', 'Тьюишн и точный дедлайн не подтверждены на официальном домене uni-obuda.hu', 'EU/non-EU разделение тьюишна не найдено'],
  false, null
);

-- =====================================================================
-- Corvinus University of Budapest — 9 новых программ
-- =====================================================================
-- Прошёл полный каталог из 37 магистратур Corvinus
-- (uni-corvinus.hu/ind/programs-curriculum-degree/master-programs).
-- Абсолютно все программы Corvinus системно показывают явное
-- разделение EEA/non-EEA прямо на странице программы — риска
-- "ловушки EU/non-EU" здесь почти нет. Дедлайн (25 июня, визовые/не-ЕС
-- кандидаты) и требование по английскому — с общих страниц приёма
-- Corvinus (application-information, admissions-requirements), не с
-- той же страницы, что цена, поэтому все ниже — verified=false.

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'International MBA', 'Business Analytics', 'English', 12, 9000,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-international-mba/?lang=en',
  array[]::text[],
  'Годичная MBA-программа с международной аккредитацией AMBA — для кандидатов с опытом работы от 3 лет, готовит будущих топ-менеджеров и предпринимателей.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Аккредитация AMBA — международное признание', 'Короткая программа — 1 год'],
  array['Требуется от 3 лет опыта работы, вступительное эссе и собеседование — подходит не всем', 'Дедлайн и точный языковой сертификат не подтверждены на той же странице, что цена', 'Самая дорогая опция среди добавленных — €9000/год'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Management', 'Business Analytics', 'English', 24, 7400,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-management/?lang=en',
  array[]::text[],
  'Классическая двухлетняя магистратура по менеджменту (Master in Management) с гибким выбором специализации на втором году: Supply Chain, Sport Business или Project Management.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Не требует предыдущего управленческого опыта — подходит выпускникам бакалавриата', 'Гибкий выбор специализации на 2 курсе'],
  array['Требование по английскому (IELTS/TOEFL) явно не указано на странице программы', 'Дедлайн подтверждён только на общей странице приёма, не на странице программы'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Finance', 'Business Analytics', 'English', 24, 7400,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-finance/?lang=en',
  array[]::text[],
  'Магистратура по финансам: корпоративные финансы, банковское дело, рынки капитала и поддержка финансовых решений.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Широкий выбор карьерных треков: корпоративные финансы, банкинг, рынки капитала'],
  array['Требование по английскому явно не указано на странице программы', 'Дедлайн подтверждён только на общей странице приёма'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Marketing', 'Business Analytics', 'English', 24, 7400,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/international-application-to-corvinus-university-of-budapest/marketing/?lang=en',
  array[]::text[],
  'Магистратура по маркетингу с акцентом на data-driven маркетинг: работа с большими данными о клиентах, транзакционная аналитика, digital-каналы.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Явный акцент на данных и аналитике, а не только на креативе'],
  array['Требование по английскому явно не указано на странице программы', 'Дедлайн подтверждён только на общей странице приёма'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Digital Innovation', 'Business Analytics', 'English', 12, 10800,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-digital-innovation/?lang=en',
  array[]::text[],
  'Годичная магистратура для предпринимателей и интрапренёров — цифровая трансформация бизнеса, AI и data-стратегия, работа со стартапами.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Короткая программа — 1 год', 'Явный фокус на AI и данных в бизнес-стратегии'],
  array['Дороже классических 2-летних программ Corvinus при том же уровне диплома', 'Дедлайн и требование по английскому подтверждены на других страницах, не на странице цены'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Economic Analysis', 'Business Analytics', 'English', 24, 7400,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-economic-analysis/?lang=en',
  array[]::text[],
  'Магистратура по количественному экономическому анализу: эконометрика, статистика, макро- и микроэкономическое моделирование, специализации в анализе рынков или макромоделировании.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Сильная количественная/эконометрическая база', 'Специализации: анализ рынков или макромоделирование'],
  array['Программа скорее академическая/исследовательская, чем прикладная бизнес-аналитика', 'Дедлайн и языковое требование подтверждены на других страницах'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Advanced Supply Chain Management', 'Business Analytics', 'English', 12, 10800,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/international-application-to-corvinus-university-of-budapest/msc-advanced-supply-chain-management/?lang=en',
  array[]::text[],
  'Годичная магистратура по управлению цепочками поставок: закупки, производство, дистрибуция, устойчивость и цифровизация операций.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Узкая прикладная специализация — понятный карьерный трек', 'Короткая программа — 1 год'],
  array['Дедлайн и языковое требование подтверждены на других страницах, не на странице цены', 'Цена для не-ЕС (€10800/год) заметно выше классических 2-летних программ Corvinus'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc International Accounting and Auditing', 'Business Analytics', 'English', 12, 10800,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-international-accounting-and-auditing/?lang=en',
  array[]::text[],
  'Годичная магистратура по международному учёту и аудиту для мультинациональных компаний — международные стандарты отчётности и взаимосвязь учёта и аудита.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Понятный, востребованный карьерный трек (аудит, международный учёт)', 'Короткая программа — 1 год'],
  array['Дедлайн и языковое требование подтверждены на других страницах', 'Более узкая специализация — обычно нужна база в бухучёте'],
  false, null
);

-- Единственная явная "Data Science" находка на Corvinus — учебный план
-- (Applied Network Science, Causal Inference, Machine Learning,
-- геоданные и текстовые данные) прямо соответствует полю Data Science.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Social Data Science', 'Data Science', 'English', 12, 10800,
  6, 25, null, 3,
  'https://www.uni-corvinus.hu/post/landing-page/masters/msc-in-social-data-science/?lang=en',
  array[]::text[],
  'Годичная магистратура на стыке социальных наук, компьютерных наук и статистики: сетевой анализ, причинный вывод, машинное обучение, работа с текстовыми и геоданными для решения социальных и экономических задач.',
  array['Официально подтверждена раздельная цена EEA/non-EEA', 'Прямое попадание в поле Data Science — сильная количественная программа', 'Востребованность у международных организаций (World Bank, OECD, UN)'],
  array['Дедлайн и языковое требование подтверждены на других страницах, не на странице цены', 'Годовая цена (€10800) — на уровне самых дорогих программ Corvinus'],
  false, null
);

-- =====================================================================
-- Pázmány Péter Catholic University — 3 новые программы
-- =====================================================================

-- Bioinformatics MSc — стоимость (HUF 975 000/сем. ≈ EUR 5200/год)
-- подтверждена на itk.ppke.hu/en/finances-admissions (общий тариф из
-- 5 программ факультета).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Bioinformatics', 'Data Science', 'English', 24, 5200,
  5, 20, 6.0, 3,
  'https://itk.ppke.hu/en/bioinformatics-msc',
  array['Stipendium Hungaricum'],
  'Магистратура на стыке информатики и биологии — обработка биологических данных, разработка ПО для биомедицины и персонализированной медицины.',
  array['Официально подтверждена стоимость для не-ЕС (общий тариф факультета)', 'Доступна стипендия Stipendium Hungaricum', 'Уникальное сочетание CS + биология'],
  array['Стоимость, дедлайн и языковое требование подтверждены на трёх разных официальных страницах, поэтому verified=false', 'Это скорее биоинформатика, чем чистый Data Science', 'Требуется подготовительный семестр (1+4)'],
  false, null
);

-- Quantum Engineering MSc — тот же тариф факультета (5 программ с
-- единым тарифом).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Quantum Engineering', 'Computational Engineering', 'English', 24, 5200,
  5, 20, 6.0, 3,
  'https://itk.ppke.hu/en/quantum-engineering-msc',
  array['Stipendium Hungaricum'],
  'Уникальная для Венгрии инженерная магистратура по квантовым технологиям: квантовые алгоритмы, фотоника, микроэлектроника и полупроводники, применения в AI и медтехе.',
  array['Официально подтверждена стоимость для не-ЕС (общий тариф факультета)', 'Доступна стипендия Stipendium Hungaricum', 'Редкая узкоспециализированная программа — низкая конкуренция за место'],
  array['Стоимость, дедлайн и языковое требование подтверждены на разных официальных страницах', 'Требует сильной базы по физике/математике', 'Требуется подготовительный семестр (1+4)'],
  false, null
);

-- Image Processing and Computer Vision (Erasmus Mundus IPCVai) —
-- совместная программа с Бордо и Мадридом. EU/non-EU разделение явно
-- подтверждено официальной финансовой декларацией ipcv.eu
-- (EU €4500/год, non-EU €9000/год).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Image Processing and Computer Vision (Erasmus Mundus IPCVai)', 'Artificial Intelligence', 'English', 24, 9000,
  4, 7, 6.5, 3,
  'https://ipcv.eu/',
  array['Erasmus Mundus'],
  'Совместная магистратура Erasmus Mundus (Венгрия-Испания-Франция) по компьютерному зрению и AI: первый семестр в Pázmány (Будапешт), далее в Мадриде и стажировка в индустрии или лаборатории.',
  array['Официально подтверждена явная цена для не-ЕС (€9000/год) из финансовой декларации программы', 'Возможность получить стипендию Erasmus Mundus (покрывает всё + стипендия на жизнь ~€1400/мес)', 'Обучение в 2-3 странах — сильный международный опыт'],
  array['Дедлайн окна самофинансирования на 2026 год уже прошёл (9 марта - 7 апреля) — дата в базе ориентировочная, нужно перепроверить перед следующим циклом', 'Совсем другая структура приёма (через ipcv.eu, не apply.ppke.hu/itk.ppke.hu) — стоит явно объяснить это пользователю в интерфейсе', 'IELTS порог (6.5) выше, чем у остальных программ Pázmány (6.0)'],
  false, null
);

-- =====================================================================
-- Széchenyi István University (Győr) — 12 новых программ
-- =====================================================================
-- Все — официальная страница admissions.sze.hu. Сайт системно НЕ
-- разделяет тюишн на EU/non-EU (структурная особенность всего сайта),
-- и у большинства дедлайн на странице "30 июня" уже в прошлом на дату
-- сбора данных (28.08.2026) — похоже на дедлайн прошлого цикла, нужно
-- перепроверить перед следующим набором. Поэтому все 12 — verified=false.

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Motorsport Engineering', 'Computational Engineering', 'English', 12, 7000,
  9, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-motorsport-engineering-msc',
  array['Stipendium Hungaricum'],
  'Годичная интенсивная магистратура по инженерии автоспорта — узкая специализация на стыке машиностроения и вычислительного инжиниринга, связана с партнёрством университета с Audi Hungaria.',
  array['Всего 1 год обучения — быстрый выход на рынок труда', 'Уникальная ниша (мало где преподают именно motorsport engineering)', 'Дедлайн подачи (30 сентября) ещё актуален на момент проверки'],
  array['Узкоспециализированная программа — нужен профильный бакалавриат', 'Есть дополнительный 2-часовой вступительный тест по инженерным основам + собеседование', 'На официальной странице тюишн дан одной цифрой без явного деления EU/non-EU'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Mechanical Engineering', 'Computational Engineering', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-mechanical-engineering',
  array['Stipendium Hungaricum'],
  'Классическая магистратура по машиностроению с одной специализацией — материалы и производственные технологии.',
  array['Один из самых доступных по цене инженерных вузов Венгрии', 'Партнёрство региона с Audi Hungaria даёт связи с индустрией'],
  array['Только одна специализация — нет отдельных треков по робототехнике или мехатронике', 'Дедлайн 30 июня на странице уже прошёл на момент сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Infrastructural Engineering', 'Computational Engineering', 'English', 18, 6400,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-infrastructural-engineering',
  array['Stipendium Hungaricum'],
  'Магистратура по инфраструктурному инжинирингу (транспортная инфраструктура или геотехника) — ускоренная программа на 3 семестра.',
  array['Короче стандартных программ — 3 семестра вместо 4', 'Две прикладные специализации на выбор'],
  array['Дедлайн 30 июня на странице уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно', 'GPA-порог на странице не указан вовсе'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Electrical Engineering', 'Computational Engineering', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-electrical-engineering',
  array['Stipendium Hungaricum'],
  'Магистратура по электротехнике с элективными треками по автоматизации или инфокоммуникациям — практико-ориентированная программа с семестровыми инженерными проектами и симуляциями.',
  array['Трек "автоматизация" — ближайшее к робототехнике, что есть в каталоге SZE', 'Практико-ориентированное обучение с реальными проектами'],
  array['Это не отдельная программа по робототехнике — автоматизация всего лишь один из элективных треков', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Supply Chain Management', 'Business Analytics', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-supply-chain-management-msc-',
  array['Stipendium Hungaricum'],
  'Магистратура по управлению цепями поставок — интегрированный подход к логистике, бизнес-менеджменту и supply chain с упором на связи с индустрией региона.',
  array['Тесные связи с промышленными партнёрами региона (логистика для автопрома)', 'Есть отдельная стипендия SODA помимо Stipendium Hungaricum'],
  array['Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно', 'GPA-порог на странице не указан'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Marketing', 'Business Analytics', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-marketing-msc-',
  array['Stipendium Hungaricum'],
  'Магистратура по маркетингу с упором на практику — бизнес-визиты, участие в исследованиях, подготовка к ролям маркетинг-менеджера, бренд-менеджера или менеджера по продажам.',
  array['Сильный практический компонент (бизнес-визиты, реальные проекты)', 'Развитие коммуникативных навыков на иностранных языках заявлено отдельно'],
  array['Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно', 'GPA-порог не указан на странице'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in International Economics and Business', 'Business Analytics', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/masters-in-international-economics-and-business-msc-',
  array[]::text[],
  'Магистратура по международной экономике и бизнесу — микро/макроэкономика, международная политика, право и европейская интеграция, с упором на аналитические и управленческие задачи в международном контексте.',
  array['Широкий международный фокус — экономика, право, политика в одном пакете', 'Готовит к аналитическим и управленческим ролям в международных компаниях'],
  array['На странице явно не упомянута стипендия Stipendium Hungaricum именно для этой программы', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

-- Health Care Management — управленческая (НЕ клиническая) программа:
-- страница прямо говорит о позициях "management, leadership,
-- analytical", не о лечении пациентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Health Care Management', 'Business Analytics', 'English', 24, 4000,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-health-care-management',
  array['Stipendium Hungaricum'],
  'Управленческая (не клиническая) магистратура по менеджменту в здравоохранении — стратегическое планирование, финансы, HR и экономика здравоохранения.',
  array['Самая доступная по цене программа в подборке SZE (4000 EUR/год)', 'Не требует медицинского образования — открыта выпускникам разных бакалавриатов', 'Растущий рынок труда на стыке медицины и менеджмента'],
  array['Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно', 'GPA-порог не указан на странице'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Computer Science Engineering', 'Computer Science', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-computer-science-engineering',
  array['Stipendium Hungaricum'],
  'Инженерно-ориентированная магистратура по компьютерным наукам — алгоритмы, безопасность распределённых систем, Rust, облачные и высокопроизводительные вычисления, элементы ИИ.',
  array['Практический инженерный уклон — не только теория', 'Затрагивает актуальные темы: безопасность распределённых систем, HPC, cloud'],
  array['Официально это отдельная от "MSc in Computer Science" программа, но их описания сильно пересекаются', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

-- Официальное описание прямо делает акцент на "artificial intelligence,
-- computational modeling, and high-performance computing" как ядре
-- программы — отнесена к Artificial Intelligence.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Computer Science', 'Artificial Intelligence', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-computer-science',
  array['Stipendium Hungaricum'],
  'Магистратура по компьютерным наукам с явным акцентом на искусственный интеллект, вычислительное моделирование и высокопроизводительные вычисления.',
  array['Официально заявленный фокус на ИИ и вычислительном моделировании', 'Принимает выпускников смежных направлений (математика, прикладная математика, информатика, электротехника)'],
  array['Название программы ("Computer Science") шире её фактического ИИ-уклона', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'Master of Science in Business Informatics', 'Business Analytics', 'English', 24, 5200,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/msc-in-business-informatics',
  array['Stipendium Hungaricum'],
  'Магистратура на стыке бизнеса и ИТ — управление IT-проектами, ERP-системы, технологии баз знаний и анализ данных для управления сложными бизнес-системами.',
  array['Хороший вариант для тех, кто хочет совмещать ИТ и бизнес-менеджмент', 'Есть отдельная стипендия SODA помимо Stipendium Hungaricum'],
  array['Ближе к управлению ИТ/ERP, чем к чистой аналитике данных', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

-- ВАЖНО: это программа юрфака (MA) про организацию и право
-- кибербезопасности, НЕ техническая инженерная программа (нет
-- пентестинга, криптографии, security engineering).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e89749b3-bb2a-4f1b-a6e9-b24b431682da',
  'MA in Modern Technologies and Cybersecurity Law', 'Cybersecurity', 'English', 24, 6400,
  6, 30, 5.5, 3, 'https://admissions.sze.hu/modern-technologies-and-cybersecurity-organizer-ma-',
  array[]::text[],
  'Юридическо-организационная магистратура по кибербезопасности — управление ИТ-функциями и понимание правового регулирования цифровых технологий, а не техническая инженерия безопасности.',
  array['Растущая ниша GRC/compliance в кибербезопасности', 'Хорошее дополнение для тех, кто метит в security-менеджмент, а не в чистую инженерию'],
  array['ВАЖНО: это программа юрфака (MA) про организацию и право кибербезопасности, а НЕ техническая инженерная программа — нет пентестинга, криптографии, security engineering. Не подойдёт тем, кто ищет hands-on техническую кибербезопасность', 'Дедлайн 30 июня уже прошёл к моменту сбора данных', 'Деление тюишн EU/non-EU не указано явно'],
  false, null
);

-- =====================================================================
-- Semmelweis University — 1 новая программа (первая программа этого вуза в базе вообще)
-- =====================================================================

-- Источник: semmelweis.hu/pharmamaster/ + semmelweis.hu/pharmamaster/courseoverview/
-- — единственная бизнес/менеджмент-программа во ВСЕМ официальном
-- каталоге англоязычных магистратур Semmelweis (проверено по полному
-- списку semmelweis.hu/admission/programs/ — там всего 6 англоязычных
-- MSc). Тюишн 3840 EUR/сем. = 7680 EUR/год, независимо перепроверен
-- через Mastersportal (~7500-7700 EUR — сходится). IELTS: сайт прямо
-- говорит "we are not aware of any English requirement" — допуск идёт
-- по уже имеющемуся диплому магистра, это НЕ "не нашли", а объективно
-- нет порога, поэтому ielts_min=null. ВАЖНОЕ ОГРАНИЧЕНИЕ: это программа
-- "второго диплома" — нужен уже имеющийся магистерский диплом
-- (медицина/фарма/стоматология/науки о здоровье) ИЛИ магистр другого
-- профиля + 3 года опыта в здравоохранении — НЕ подходит вчерашним
-- бакалаврам без опыта в отрасли. Дедлайн подачи нигде не публикуется
-- явно (вероятно, приём идёт гибко, blended-формат) — оставлен NULL
-- вместо угадывания; фронтенд (`GanttTimeline.tsx`/`Timeline.tsx`)
-- уже умеет обрабатывать пустой дедлайн (fallback на 1 января),
-- страница программы просто скроет блок с датой — проверено по коду.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b7db40e0-5888-4c3d-bac1-75a112b5ec11',
  'Master of Science in Pharmaceutical Innovation and Business Administration', 'Business Analytics', 'English', 24, 7680,
  null, null, null, 3, 'https://semmelweis.hu/pharmamaster/',
  array[]::text[],
  'Executive-магистратура по фарм-бизнесу и инновациям (blended-формат: очные сессии + онлайн) — разработка препаратов, вывод на рынок, регулирование, маркетинг и бизнес-девелопмент в фарм- и биотех-индустрии. Это вторая степень для тех, кто уже имеет медицинское/фармацевтическое/научное образование или опыт в отрасли, а не первая магистратура после бакалавриата.',
  array['Единственная бизнес-ориентированная англоязычная магистратура во всём каталоге Semmelweis', 'Blended-формат (4 очных дня в семестр) подходит совмещающим учёбу с работой', 'Ниша на стыке медицины/фармы и бизнеса — мало аналогов в регионе'],
  array['ВАЖНО: требует уже имеющегося диплома магистра (медицина/фарма/стоматология/науки о здоровье/естественные науки) ИЛИ магистра другого профиля + 3 года опыта в здравоохранении — не подходит вчерашним бакалаврам без опыта в отрасли', 'Дедлайн подачи не опубликован — уточнить у приёмной комиссии напрямую', 'Деление тюишн EU/non-EU не подтверждено на официальной странице', 'Тюишн выше среднего по венгерским меркам (7680 EUR/год)'],
  false, null
);

commit;

-- Проверка после запуска — итоговый счёт по обеим партиям вместе
-- (2026-08-28 + 2026-08-28b):
-- select u.name as university, count(p.*) as programs, count(*) filter (where p.verified) as verified_count
-- from universities u left join programs p on p.university_id = u.id
-- where u.country = 'hu' group by u.name order by programs desc;
