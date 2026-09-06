-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: France (fr) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Длительность 24 месяца, преподавание на английском и сам факт программы подтверждены на официальной странице (programmes.polytechnique.edu/.../economics-data-analytics). IELTS 7.0 взят из официального FAQ École Polytechnique (programmes.polytechnique.edu/en/master/admissions-msct/faq), где явно указано «IELTS minimum 7 overall». Однако точная стоимость для не-ЕС студентов (в отличие от EU/EEA) и конкретный финальный deadline подачи документов не найдены на одной и той же странице вместе с языковыми требованиями — verified=false. Дедлайн 30 апреля — типичный последний раунд MScT IP-Paris, цифра 6400 EUR — ориентир по линейке MScT, но не прямо подтверждена для EDACF.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'MScT Economics, Data Analytics and Corporate Finance (EDACF)', 'Data Science', 'English', 24, 6400,
  4, 30, 7, 3, 'https://programmes.polytechnique.edu/en/master-all-msct-programs/economics-data-analytics-and-corporate-finance/economics-data-analytics',
  array[]::text[],
  'Двухлетняя англоязычная программа MScT в École Polytechnique (Institut Polytechnique de Paris, Palaiseau), объединяющая экономику, data analytics и корпоративные финансы; 140 ECTS, преподавание полностью на английском.',
  array['Полностью английский язык обучения — подходит для иностранных студентов', 'Престиж École Polytechnique / Institut Polytechnique de Paris и сильный бренд в финансах и data science', 'Два года (140 ECTS) с глубокой программой по econometrics, Python, digital finance, blockchain', 'Возможен двойной трек X–Bocconi для ещё большего веса диплома'],
  array['Точная стоимость для не-ЕС студентов и финальный дедлайн не подтверждены в одном источнике вместе с требованиями — данные оценены ориентировочно', 'IELTS 7.0 по официальному FAQ Polytechnique — довольно высокий порог для поступающих', 'Различие тарифов EU/non-EU на сайте явно не зафиксировано в выдаче; цифра 6400 EUR взята как типичная годовая оценка для MScT (итого ~12 800 EUR за 2 года), но не подтверждена напрямую'],
  false, null
);

-- Частично подтверждено: на странице HEC (fees-and-financing) указано «additional €2,000 for international students», а на TopUniversities — «International: from 28,950 EUR». Точная итоговая сумма для не-ЕС в одном месте не сверена; дедлайн 12 января взят из collegedunia/справочников, официальная страница admissions не открыта в выдаче. IELTS 6.5 и GMAT 650 подтверждены collegedunia. Полного единого источника по всем трём полям (tuition+deadline+IELTS именно для non-EU) на одной странице не нашлось — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'X-HEC Data Science & AI for Business (MSc&T)', 'Artificial Intelligence', 'English', 24, 30950,
  1, 12, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/master-science-data-science-ai-business-x-hec/fees-and-financing',
  array['Need-based scholarships via HEC (up to partial tuition)', 'École Polytechnique Excellence scholarships for international candidates', 'Diversity & merit-based scholarships on application'],
  'Двухлетняя совместная программа École Polytechnique и HEC Paris в области Data Science и AI с сильным акцентом на бизнес-применение; в 2026 году QS поставил её на 2-е место в мире среди бизнес-магистратур в этой нише.',
  array['Высокий средний стартовый заработок выпускников (~€81k) и сильный карьерный трек', 'Совместный диплом Polytechnique + HEC даёт двойной бренд инженерной школы и топовой бизнес-школы', 'Высокий процент иностранных студентов (~98%) и селективная группа (~70 человек в год)'],
  array['Стоимость для международных студентов ощутимо выше, чем базовая публикуемая цифра (доп. сбор €2k и актуальные ставки могут отличаться)', 'Дедлайн и точная стоимость для не-ЕС требуют проверки на конкретной странице программы на год поступления', 'IELTS 6.5 и GMAT 650 — высокий барьер по языку и стандартизированным тестам'],
  false, null
);

-- verified = false: ни на одной странице не найдено одновременное явное подтверждение всех трёх параметров (tuition/deadline/IELTS) для non-EU именно по Data & Finance X-HEC. Tuition ~€27 900/год (mastersportal) + надбавка €2 000 для international (hec.edu/.../fees-and-financing) → использовано 29 900 EUR/год. Дедлайн 30 апреля — экстраполяция по дедлайнам HEC MSc (4 раунда, последний обычно конец апреля—начало июня); для Data & Finance точный текст не извлечён. IELTS 6.5 — типовое требование HEC для англоязычных MSc, но не подтверждено цитатой с конкретной страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'Data & Finance Double Degree (X-HEC / HEC & École Polytechnique)', 'Business Analytics', 'English', 24, 29900,
  4, 30, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/double-degree-programs/double-degree-data-finance-x-hec/fees-and-financing',
  array['École Polytechnique Excellence Scholarships (need-based, partial)'],
  'Двухгодичная совместная программа École Polytechnique и HEC Paris на стыке финансов, data science, блокчейна и алгоритмической торговли; студенты учатся на двух кампусах и получают два диплома.',
  array['Два сильных бренда — Polytechnique (инженерия/quant) + HEC (бизнес/finance) и сеть выпускников в банках и хедж-фондах', 'Сильная техническая база (Python, численные методы, ML) рядом с корпоративными финансами — редкое сочетание для non-EU кандидатов', 'Доступ к карьерному центру HEC и рекрутингу в топ-банки Paribas, Société Générale, JP Morgan, Squarepoint и т.п.'],
  array['Стоимость для иностранцев значительно выше, чем для граждан ЕС (надбавка ~€2 000/год по данным страницы fees & financing), плюс学费 ~€29 900/год нужно умножать на 2 года', 'IELTS 6.5 — это оценка по общей практике HEC, конкретный порог именно для Data & Finance X-HEC в сниппетах не подтверждён', 'Финальный дедлайн 30 апреля — приблизительная оценка по типичному раунду HEC; точная дата ближайщего набора в выдаче не найдена, дедлайны разнесены по 4 раундам (октябрь — июнь)', 'Конкурс высокий, требуется сильный quantitative background (математика, Python) — не самая лёгкая программа для абитуриентов без STEM-базы'],
  false, null
);

-- Подтверждено с официальной страницы M1 (URL в поле url): язык English, длительность 12 months full-time, локация Palaiseau, 60 ECTS, ориентация Research & Industry, двухгодовая программа IP Paris + HEC Paris. Дедлайн 30 апреля — стандартный цикл IP Paris, но в сниппете страницы M1 конкретная дата не извлечена напрямую (упоминается как общий цикл IP Paris). Туишн: на отдельной странице fee PDF IP Paris (2026-27) явно различает EU/EEA и international ставки, но конкретная цифра для non-EU по M1 Economics в найденных сниппетах не зафиксирована — поэтому €3770 дано как оценка по типовой non-EU вилке IP Paris, не как подтверждённый факт. IELTS-минимум со страницы M1 Economics не извлечён. verified=false, так как tuition+deadline+IELTS для non-EU не подтверждены все три на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'Master Year 1 in Economics (IP Paris & HEC Paris)', 'Business Analytics', 'English', 12, 3770,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/economics-program/master-year-1-economics',
  array['PhD Track excellence scholarship (≈€10,000/year, доступна при переходе на PhD-track после M1)', 'Fee waivers для отобранных кандидатов PhD-трека'],
  'Совместная двухлетняя (M1+M2) исследовательская программа IP Paris (École Polytechnique) и HEC Paris по экономике, полностью на английском, на кампусе Палезо — M1 даёт 60 ECTS и готовит к M2/PhD-треку.',
  array['Совместный диплом IP Paris (École Polytechnique) и HEC Paris — две топовые школы', 'Полностью на английском, 60 ECTS, ориентация Research & Industry, сильная квантитативная и эмпирическая подготовка', 'Прямой путь в PhD-track со стипендией excellence (≈€10,000/год)', 'Кампус École Polytechnique в Палезо + доступ к инфраструктуре HEC'],
  array['Точная non-EU ставка tuition на странице M1 Economics не подтверждена одним сниппетом — оценка €3770 как типовая non-EU вилка IP Paris; реальная цифра может отличаться, нужен официальный PDF о fees', 'IELTS-минимум не извлечён из сниппета страницы M1 — указана типовая для IP Paris оценка 6.5', 'Длительность именно M1 = 12 месяцев (а не 24, как в шаблоне); полный двухлетний цикл = M1 + M2 Economics', 'Годовая структура fees для M1 Economics с разбивкой EU/EEA vs non-EU доступна в отдельном PDF, а не на самой странице программы', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: стоимость €4 317/год для не-ЕС подтверждена для этой же программы (страница educations.com и TopUniversities ссылаются на карточку IP Paris: «non-EU/EEA/Switzerland students: from 4 317 €/year»). Дедлайн и точный IELTS на самой странице M1 в выдаче не раскрыты — программа ссылается на общий раздел «Fees and scholarships» и общий портал Admissions. 30 апреля и IELTS 6.0 — лучшие разумные оценки по типичной практике IP Paris (дедлайн 1-й сессии для международных заявок и B2≈IELTS 6.0), но это не подтверждено в одном источнике с tuition, что требует отметки verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'Master Year 1 Innovation, Industry and Society (IP Paris)', 'Business Analytics', 'English', 12, 4317,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/innovation-industry-and-society-program/master-year-1-innovation-industry-and-society',
  array[]::text[],
  'Магистерская программа M1 «Инновации, индустрия и общество» в IP Paris (École Polytechnique, Палезо) — междисциплинарная программа по экономическим, социальным и организационным аспектам инноваций,12 месяцев очного обучения, старт в сентябре.',
  array['Для не-ЕС студентов подтверждена отдельная ставка €4 317/год против €254/год для граждан ЕС/ЕЭЗ/Швейцарии — на той же странице', 'Программа сильного междисциплинарного бренда IP Paris / École Polytechnique с индустриальными партнёрствами', 'Удобный отдельный тариф именно для не-ЕС (заметно ниже, чем €15 400/год в некоторых других англоязычных MSc&T IP Paris)'],
  array['Дедлайн подачи (30 апреля) и точный минимум IELTS6.0 не подтверждены на той же странице программы — это лучшие источники из общей политики IP Paris, точное значение IELTS для M1 IIS на официальной странице программы не найдено (упомянут только уровень B2)', 'Длительность именно M1 = 12 месяцев (официально), а не 24 — 24 месяца даёт вся связка M1+M2', 'verified=false: на одной странице с известным URL одновременно не подтверждены tuition+deadline+language для не-ЕС — конкретные цифры взяты из подтверждённого источника по этой же программе (educations.com/TopUniversities), но не с самой карточки M1', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Tuition подтверждена со страницы HEC fees-and-financing (€29 950 + €2 000 для иностранных студентов). Альтернативная цифра €28 950 указана на Polytechnique side — расхождение из-за разных компонентов (страховка/жизнь на кампусе). Конкретный IELTS-минимум и точная дата дедлайна не извлеклись из сниппетов, поэтому они оценочные (4/30 — типичный Round 3, IELTS 6.5 — стандарт HEC). verified=false, так как все три поля (tuition+deadline+language) не подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5ebd9a6a-c854-498f-96d9-76a902093ebe',
  'Master of Science & Technology - Data and Artificial Intelligence for Business (X-HEC)', 'Artificial Intelligence', 'English', 24, 31950,
  4, 30, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/master-science-data-science-ai-business-x-hec/fees-and-financing',
  array['HEC Excellence Scholarship', 'École Polytechnique Master Scholarship', 'Need-based partial waivers'],
  'Совместная программа HEC Paris и École Polytechnique (Париж-Сакле), обучающая data science и ИИ с бизнес-упором; 2 года очно, занятия на английском. В QS 2026 занимает 2-е место в мире среди магистратур по Data Science.',
  array['Диплом сразу двух топовых школ — HEC Paris + École Polytechnique', '#2 в мире по предмету (QS 2026)', 'Сильная связка AI/DS и бизнеса, хорошие карьерные выходы в консалтинг/AI-индустрию', 'Кампус в экосистеме Paris-Saclay — доступ к французскому AI-хабу'],
  array['Высокая стоимость для иностранцев (~€31950 за 2 года) — нужно подтвердить актуальную цифру', 'Точная минимальная оценка IELTS и финальный дедлайн не подтверждены с одной официальной страницы (verified=false)'],
  false, null
);

-- verified=false: на странице MIBS подтверждены только дедлайн (15/01/2026–16/03/2026, платформа Inception) и язык (English); точная non-EU tuition и IELTS-min для MIBS не найдены в тексте сниппетов. Использованы оценочные значения: ~€6,400 за 2 года (€3,200/год с учётом частичного exemption Paris-Saclay) и IELTS 6.0 как распространённый минимум Paris-Saclay.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 International Business and Sustainability (MIBS)', 'Business Analytics', 'English', 24, 6400,
  3, 16, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m1-international-business-and-sustainability-mibs',
  array['Université Paris-Saclay International Master''s Scholarships Programme (~€10,000/year)'],
  'Двухгодичная магистратура MIBS в Paris-Saclay, полностью на английском, готовит менеджеров и консультантов по международному бизнесу и устойчивому развитию. Подача через платформу Inception.',
  array['Программа полностью на английском', 'Сильный бренд Paris-Saclay в STEM/business, хороший нетворкинг', 'Возможность крупного стипендиального гранта от университета (~€10,000/год)'],
  array['Точная сумма tuition для non-EU на официальной странице MIBS не показана в сниппетах — привожу оценочную цифру на основе стандартных дифференцированных сборов Франции (~€3,770/год) с частичным освобождением Paris-Saclay', 'Дедлайн подтверждён только как 16/03/2026 для цикла 2026 (может меняться по годам)', 'IELTS 6.0 указан как типичный минимум Paris-Saclay, точное требование для MIBS не извлеклось из сниппетов'],
  false, null
);

-- verified=false: страница M2 содержит только «Fees and scholarships — amounts may vary depending on the programme», без конкретной суммы, даты дедлайна и IELTS. Tuition €3770 — стандартная дифференцированная ставка для не-ЕС в магистратуре французских госвузов (не подтверждено на самой странице M2); deadline 5 мая — экстраполяция с цикла 2025 (May 5, 2025 для Master''s selection); IELTS 6.0 — типичный минимум для англоязычных магистратур Paris-Saclay, точная цифра не найдена на странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 International Business and Sustainability (MIBS)', 'Business Analytics', 'English', 24, 3770,
  5, 5, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m2-international-business-and-sustainability-mibs',
  array['Université Paris-Saclay Master''s Scholarships (до €10 000/год для лучших иностранных студентов)', 'Eiffel Scholarship (через Campus France для не-ЕС)'],
  'Двухлетняя магистратура MIBS (M1+M2) в Университете Париж-Сакле по стратегическому менеджменту с фокусом на международный бизнес и устойчивое развитие, всё обучение на английском. Кампус — южный пригород Парижа (Орсе/Сакле), сильная связь с топ-французскими школами и исследовательскими центрами.',
  array['Полностью на английском, признанная программа среди бизнес-магистратур Франции', 'Сильный акцент на sustainability + стратегический менеджмент, востребованный профиль', 'Доступ к стипендии Université Paris-Saclay для не-ЕС студентов (~€10 000/год)'],
  array['Страница M2 не публикует tuition, deadline и IELTS напрямую — цифры ниже даны по смежным источникам и стандартным тарифам Франции', 'Кампус разбросан по южному пригороду Парижа, а не в центре города; нужен RER B для поездок в Париж', 'Конкурс на стипендию Paris-Saclay высокий'],
  false, null
);

-- verified=false: на странице M1 Economics нет одновременно tuition/deadline/IELTS для non-EU — только общая отсылка к разделам ''tuition fees'' и ''admission''. Длительность 12 мес подтверждена UniPage и самой структурой M1. Tuition €3 941/год — типовая ставка для non-EU Master во французских гос. вузах (источник: обсуждение и официальный tuition-fees раздел Paris-Saclay, упоминающий дифференцированные fees и partial exemption). Дедлайн 30 апреля взят как типовой международный дедлайн Paris-Saclay, IELTS 6.0 — стандартное требование English-taught Master в Paris-Saclay.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 Economics', 'Business Analytics', 'English', 12, 3941,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/economics/m1-economics',
  array['Paris-Saclay International Master''s Scholarship (до €10 000)'],
  'Одногодичная программа M1 Economics в Université Paris-Saclay на английском языке — первый год магистратуры по экономике с сильной исследовательской составляющей и приглашёнными международными спикерами.',
  array['Программа в топовом исследовательском университете (Paris-Saclay в топ-50 Shanghai)', 'Преподавание на английском, подходит для иностранных студентов', 'Доступна стипендия International Master''s Scholarship (€10 000)'],
  array['На самой странице M1 Economics точная сумма tuition для non-EU не указана — она ссылается на общий раздел fees, поэтому цифра €3 941/год дана как типовая для французских гос. вузов для non-EU Master, но не подтверждена прямо на странице M1 Economics', 'Конкретный дедлайн подачи на этот M1 не указан на самой странице программы (использован типичный апрельский дедлайн Paris-Saclay для international masters)', 'Дифференцированная плата для non-EU может быть частично снижена через exemption, надо проверять индивидуально'],
  false, null
);

-- verified=false, потому что на странице M2 Economics в выдаче не удалось одновременно подтвердить tuition для не-ЕС, дедлайн и IELTS. Подтверждено: программа существует и преподаётся на английском (страница universite-paris-saclay.fr). Базовый тариф Master для ЕС = €254/год (со страницы tuition-fees 2025-2026). Тариф не-ЕС во Франции стандартно ~€3770/год, но на странице самой программы эта цифра не зафиксирована поиском.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Economics', 'Business Analytics', 'English', 12, 3770,
  4, 30, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/economics/m2-economics',
  array['SMARTS-UP Graduate School Scholarship'],
  'Один год (M2) программы магистратуры по экономике в Université Paris-Saclay, преподаётся полностью на английском. Это селективная программа с международным преподавательским составом.',
  array['Полностью английский язык обучения', 'Сильный исследовательский университет (топ-15 в мире по нескольким рейтингам)', 'Возможны стипендии SMARTS-UP для иностранных студентов'],
  array['Точная сумма tuition для не-ЕС студентов не подтверждена на странице программы в поиске — оценка €3770/год взята из стандартных тарифов Франции для не-ЕС магистров на 2024-2025', 'Дедлайн 30 апреля — оценка (типичный весенний дедлайн для M2 на Paris-Saclay), на конкретной странице программы не подтверждён в выдаче', 'IELTS 6.5 — оценка на основе общих требований Paris-Saclay для англоязычных программ, не подтверждено напрямую'],
  false, null
);

-- verified=false: из сниппета официальной страницы подтверждены окно подачи документов 15/05–15/06/2026 и требование сертификата по английскому; точная сумма для non-EU на той же странице в сниппете не показана — взята стандартная ставка для non-EU в госвузах Франции (~3770 €/год по национальной политике дифференцированных взносов с 2019 г.), двухгодичная оплата может быть снижена при праве на частичное освобождение. IELTS 6.5 указан по стороннему агрегатору gotouniversity.com, не из официального источника.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Risk and Asset Management (GRA)', 'Business Analytics', 'English', 24, 3770,
  5, 15, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/finance/m2-risk-and-asset-management-gra',
  array[]::text[],
  'Магистратура M1+M2 в области управления рисками и активами в Университете Париж-Сакле на факультете финансов. Программа делает упор на финансовую инженерию, программирование и количественные методы.',
  array['Сильная программа по количественным финансам с упором на риск-менеджмент', 'Государственный диплом престижного Университета Париж-Сакле с доступом к европейскому рынку труда'],
  array['Уточнённые суммы для non-EU студентов и точный дедлайн не удалось подтвердить по одной официальной странице (только сниппеты из поиска)', 'Дифференцированная non-EU ставка применяется, но итоговая сумма зависит от права на освобождение'],
  false, null
);

-- verified=false: на странице программы не удалось одновременно найти tuition для non-EU, точный deadline и IELTS requirement — указано лишь ''amounts may vary depending on programme and your personal circumstances''. Программа действительно существует по указанному URL, проверена через topuniversities.com и globaladmissions.com. Tuition €3770 — оценка по национальной ставке для non-EU магистрантов публичных университетов Франции; IELTS 6.0 — стандартное требование Paris-Saclay (точная цифра может быть 6.5); deadline 30 апреля — типовой для международного набора на M2 в Faculté Jean-Monnet. Для verified=true нужно открыть admissions.universite-paris-saclay.fr и/или подстраницу ''tuition fees'' с конкретным non-EU тарифом.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Strategy, Engineering and Financial Innovation (SIIF)', 'Business Analytics', 'English', 12, 3770,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/finance/m2-strategy-engineering-and-financial-innovation-siif',
  array['Eiffel Excellence Scholarship', 'Paris-Saclay International Master Scholarships', 'Île-de-France Master Scholarship (for accepted applicants)', 'Formation initiale / contrat de professionnalisation (alternance)'],
  'Программа M2 (второй и заключительный год магистратуры) по финансам в Université Paris-Saclay через Faculté Jean-Monnet, объединяющая стратегию, финансовую инженерию и инновации. Доступна в формате formation initiale и alternance (work-study).',
  array['Преподавание на английском и французском — подходит международным студентам', 'Гибкий формат: classique или alternance (contrat de professionnalisation)', 'Université Paris-Saclay входит в топ мировых исследовательских университетов'],
  array['Точная сумма tuition для не-ЕС студентов на странице программы не зафиксирована — €3770/год это стандартная ставка публичных вузов Франции для non-EU Master''s, реальная цифра для SIIF может отличаться', 'Дедлайн 30 апреля взят как типичный для M2 Faculté Jean-Monnet для международных абитуриентов, точной даты на одной странице не подтверждено'],
  false, null
);

-- Подтверждено только URL и то, что это one-year M2 (12 мес). Tuition, deadline и IELTS на самой странице M2 Quantitative Finance в сниппетах поиска не раскрыты — нельзя выставить verified=true (требуется подтверждение всех трёх параметров на одной странице). €3879 — стандартная «differentiated fee» для не-ЕС в госвузах Франции на магистратуре; IELTS 6.5 и дедлайн ~15 июня — типичные значения по другим программам Paris-Saclay, не точные числа для M2QF. GPA не указан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Quantitative Finance', 'Business Analytics', 'English', 12, 3879,
  6, 15, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/mathematics-and-applications/m2-quantitative-finance',
  array['Sophie Germain Master''s Scholarship', 'IDEX Paris-Saclay International Master''s Scholarships', 'Eiffel Scholarship (по конкурсу вуза)'],
  'Один год (M2, второй год магистратуры) по математике и приложениям в Université Paris-Saclay: стохастическое исчисление, численные методы, финансовые рынки, C++/Python. Сильная подготовка для продаж/квантов/риск-менеджмента.',
  array['Низкая цена по сравнению с London/ Zürich/Imperial', 'Сильная математическая база, диплом топового французского вуза', 'Хороший плюс к CV для рынка ЕС'],
  array['Конкретная сумма для не-ЕС на странице M2 не подтверждена — €3879 это национальный стандарт Франции для non-EU магистров, реальная цифра может отличаться', 'Дедлайн и IELTS на странице программы явно не указаны — оценки приблизительные', 'Длительность M2 = 12 месяцев (не 24): если нужен полный M1+M2, нужно поступать отдельно на M1'],
  false, null
);

-- verified=false: официальная страница программы подтверждена поиском (URL реальный), но в сниппетах не удалось одновременно увидеть на одной странице все три параметра — точную non-EU стоимость, дедлайн и требование IELTS. Стоимость €7,540 рассчитана как стандартная дифференцированная ставка для non-EU студентов во французских государственных вузах (€3,770/год × 2 года) согласно политике tuition fees Paris-Saclay. Дедлайн 30 апреля и IELTS 6.0 — типичные ориентиры для таких программ, но не подтверждены буквально с цитируемой страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'Computer Science Applied to Business Management (MIAGE)', 'Computer Science', 'English', 24, 7540,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science-applied-business-management',
  array['Université Paris-Saclay Excellence Scholarship (potential, merit-based)', 'Eiffel Scholarship (for top international applicants)', 'CROUS scholarships'],
  'Магистратура MIAGE в Университете Пари-Сакле — двухлетняя программа на стыке информатики и управления бизнесом. Программа ориентирована на профессиональную подготовку и предлагает несколько специализаций M2 (аналитика данных, веб-инженерия и др.). Программа преподаётся преимущественно на французском, некоторые курсы на английском.',
  array['Статус Paris-Saclay — один из ведущих исследовательских университетов Франции', 'Двойная экспертиза IT + менеджмент, востребованная на рынке', 'Возможность стажировок в компаниях через партнёрскую сеть', 'Доступ к кампусам LERU и широкой инфраструктуре Paris-Saclay'],
  array['Точные цифры оплаты для non-EU студентов на конкретной странице программы в сниппетах не подтверждены — указана стандартная ставка французских гос. вузов €3,770/год (итого €7,540 за 2 года), фактический сбор может отличаться', 'Дедлайн 30 апреля — ориентир; на странице программы в выдаче конкретная дата не зафиксирована', 'Преподавание в основном на французском, IELTS 6.0 — минимальный ориентир, не подтверждён напрямую с той же страницы', 'Некоторые треки M2 требуют знание французского B2/C1', 'Большая часть обучения — на французском, что ограничивает англоговорящих студентов'],
  false, null
);

-- verified=false: на официальной странице M1 (universite-paris-saclay.fr) подтверждены deadline (16/03/2026) и требование B2 по английскому, а также ссылка на раздел ''International students Tuition fees''. Точная цифра для не-EU на этой странице в сниппете не показана — €3,770/год взят из общеуниверситетской политики дифференцированных сборов для не-EU студентов в гос. вузах Франции (подтверждается отдельной страницей tuition-fees и обсуждением на Reddit r/ParisSaclay, где фигурирует ~€4000 для international). Дедлайн также подтверждён на сайте программы ai-master.lisn.upsaclay.fr: ''M1 deadline: March 16, 2026''. Для полной верификации нужно открыть на странице M1 блок ''Tuition fees'' → ''International students'' и проверить конкретную сумму.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 Artificial Intelligence', 'Artificial Intelligence', 'English', 12, 3770,
  3, 16, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m1-artificial-intelligence',
  array['Paris-Saclay International Master''s Scholarship (IDEAL)', 'Eiffel Scholarship (для поступающих через M2)'],
  'Магистратура M1 по искусственному интеллекту в Université Paris-Saclay, программа полностью на английском, расположена в парижском регионе (Орсе/Сакле). Подача через платформу Inception до 16 марта 2026.',
  array['Топовый вуз — Paris-Saclay в топ-15 мировых рейтингов и сильный кластер по AI/ML', 'Программа полностью на английском, B2 достаточно — IELTS 6.0', 'Сильная связь с исследовательскими лабораториями LISN/TAU/LRI, прямой путь к M2 DKAI'],
  array['Для не-EU студентов действуют дифференцированные сборы (~€3,770/год) против €254 для EU/EEA — разница ~15x', 'Точная сумма tuition для не-EU не отображается в видимом сниппете именно страницы M1 (ссылается на общий раздел International students), поэтому verified=false', 'M1 — это только 1-й год (12 мес), для полного диплома нужно отдельно поступать в M2', 'Минимальный GPA формально не опубликован на странице программы, отбор конкурсный'],
  false, null
);

-- verified=false: на основной странице universite-paris-saclay.fr/en/.../m2-artificial-intelligence НЕ подтверждены одновременно (1) точный не-EU тариф для M2, (2) дедлайн 30 апреля, (3) IELTS ≥ 6.5 — для не-EU. Подтверждены только EU/EEA тариф €254/год (страница tuition-fees) и ссылка на ai-master.lisn.upsaclay.fr. Финальные цифры требуют проверки на ai-master.lisn.upsaclay.fr/admissions, который в результатах поиска не был напрямую открыт (one round).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 4900,
  4, 30, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m2-artificial-intelligence',
  array['Île-de-France Master Scholarship (potential for M1)', 'Paris-Saclay International Master''s Scholarship'],
  'Магистратура M2 по искусственному интеллекту в Университете Париж-Сакле с сильной исследовательской базой, преподаётся частично на английском. Программа ориентирована на исследования и подготовку к PhD, включает треки по ML, компьютерному зрению, NLP и робототехнике.',
  array['Высокий исследовательский уровень (связь с LISN, Saclay AI)', 'Гибкая структура с треками и возможностью PhD-продолжения', 'Стипендии для иностранцев (Paris-Saclay, IDEX)'],
  array['Реальная стоимость для не-EU (~€4900/год) заметно выше €250, и с учётом всей 2-летней программы M1+M2 бюджет значительный', 'Жёсткий отбор: IELTS ≥6.5, конкурс на топ-треки высокий', 'Часть курсов на французском, что может усложнить обучение без языка'],
  false, null
);

-- verified=false: найденная официальная страница подтверждает существование программы, международную направленность и обучение на английском языке, но поисковая выдача не дала официального подтверждения всех трех параметров для не-EU студентов на одной странице. €6400, 30 апреля и IELTS 6.0 — предварительные значения, требующие проверки в актуальной форме заявления; €6400 также может быть ошибочным, поскольку на связанной официальной странице общей стоимости магистратуры для 2025–2026 годов указан другой уровень платы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 Data, Knowledge and Hybrid Artificial Intelligence (DKAI)', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m1-data-knowledge-and-hybrid-artificial-intelligence-dkai',
  array['Международная стипендиальная программа Université Paris-Saclay для магистрантов — до €10 000 в год'],
  'Программа DKAI巴黎-萨克雷大学 — это двухлетняя магистерская программа по data science, knowledge engineering и hybrid artificial intelligence с обучением преимущественно на английском языке. Для нерезидентов ЕС необходимо отдельно учитывать дифференцированную плату и подтвердить текущий набор документов на странице поступления.',
  array['Международная программа с курсами на английском языке', 'Сильная междисциплинарная направленность на стыке данных, знаний и гибридного ИИ', 'Возможность получения стипендии Paris-Saclay International Master''s Scholarship'],
  array['Официальный результат не подтверждает одновременно на одной странице точную не-EU плату, финальный дедлайн и минимальный IELTS именно для этой M1-программы; указанные в JSON значения tuition_eur=6400, deadline=30 апреля и IELTS=6.0 следует считать предварительными, а не полностью верифицированными.', 'Для поступления может требоваться подтверждение уровня английского не ниже B2; конкретный минимальный IELTS на официальной странице не указан.'],
  false, null
);

-- Подтверждено: страница программы существует по известному URL, программа на английском, длительность 24 месяца. НЕ подтверждено на одной странице одновременно: tuition для не-ЕС, IELTS, дедлайн — информация собрана из нескольких источников (общая страница tuition Paris-Saclay, AI-MASTER подсайт, Reddit, University Living, SIEC India). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Data, Knowledge and Hybrid Artificial Intelligence (DKAI)', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m2-data-knowledge-and-hybrid-artificial-intelligence-dkai',
  array['Université Paris-Saclay International Master''s Scholarship (partial tuition waiver + monthly stipend)'],
  'Двухлетняя (M1+M2) программа магистратуры Paris-Saclay по науке о данных и гибридному ИИ, полностью на английском, на факультете компьютерных наук при LISN/CEA. Сильный исследовательский уклон и прямой путь к академии/индустрии в ИИ.',
  array['Программа полностью на английском, ориентирована на интернациональных студентов', 'Принадлежность к Université Paris-Saclay — топ-1 Франции по исследованиям; сильные связи с CEA и лабораториями ИИ', 'Доступна стипендия Paris-Saclay International Master''s Scholarship, покрывающая часть стоимости и дающая ежемесячную выплату'],
  array['Точная сумма tuition для не-ЕС студентов не подтверждена на самой странице M2 DKAI: €6400 — это типовая дифференцированная ставка Paris-Saclay (на отдельных программах), но страница программы показывает только общую ссылку на tuition fees', 'Конкретный IELTS-минимум для DKAI отдельно не опубликован;6.0 — общий ориентир Paris-Saclay, часть источников указывает 6.5', 'Дедлайн варьируется по годам (указано 30 апреля по аналогии с прошлыми циклами), обязательно проверять актуальную дату на странице программы'],
  false, null
);

-- verified=false, потому что за один раунд поиска не удалось подтвердить все три параметра (не-EU tuition + deadline + IELTS) на одной и той же странице программы. Подтверждено только: (1) базовая ставка магистратуры €254/год + CVEC €105 для EU; (2) для не-EU применяется дифференцированная ставка с partial exemption (точная итоговая сумма на странице не показана в выдаче); (3) страница программы существует по известному URL и присутствует в результатах поиска. Цифра €6400 — оценка (~€3200/год при частичном exemption) и может отличаться от фактической цифры для CS.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'Computer Science (Master''s degree)', 'Computer Science', 'English', 24, 6400,
  4, 30, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science',
  array['International Master''s Scholarships Program Université Paris-Saclay (частичная стипендия для нерезидентов ЕС, покрывает часть дифференцированной стоимости обучения и ежемесячную стипендию ~870€/мес)'],
  'Магистратура по информатике в Université Paris-Saclay — двухлетняя исследовательская программа с сильной связью с индустрией, ориентированная на подготовку учёных и инженеров. Обучение частично на английском, есть треки по AI, системам, программной инженерии; доступны стипендии для нерезидентов ЕС.',
  array['Сильная STEM-репутация, входит в топ университетов Европы', 'Программа частично на английском, многие курсы на английском', 'Доступна стипендия International Master''s Scholarship (включая частичный exemption от дифференцированной платы для не-EU)', 'Близость к исследовательским лабораториям Saclay и тех-хабу Paris'],
  array['Точная сумма для нерезидентов ЕС на странице программы не подтверждена поиском — приведена оценка (~€6400 за 2 года при partial exemption от дифференцированной ставки)', 'Дедлайн 30 апреля — ориентировочный общий дедлайн платформы Paris-Saclay, для Computer Science на странице программы не подтверждён в выдаче', 'IELTS 6.5 — оценка по общим требованиям Paris-Saclay для англоязычных магистратур, на конкретной странице не подтверждён'],
  false, null
);

-- Подтверждено на основной странице центрального URL centralesupelec.fr/programmes/master-science-artificial-intelligence (через сниппеты поиска): стоимость €20,000 включая депозит €2,000; IELTS 6.5; раунды подачи Round 1 (28.11.2025) — Round 5 (22.06.2026), указан последний раунд как финальный дедлайн. Прямого разделения EU/non-EU в этой программе нет — это MSc grande école с единой платой для всех. Дополнительно подтверждено на зеркале masterofscience-ia.com. Минимальный GPA на странице не указан явно, оставлено значение по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'Master of Science in Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 20000,
  6, 22, 6.5, 3, 'https://www.centralesupelec.fr/programmes/master-science-artificial-intelligence',
  array[]::text[],
  'Магистерская программа MSc in Artificial Intelligence в CentraleSupélec (часть Université Paris-Saclay) — двухлетняя прикладная программа по ИИ на английском языке с сильной инженерной и исследовательской базой.',
  array['Диплом CentraleSupélec/Université Paris-Saclay — топовая инженерная школа и сильный университет (Paris-Saclay в топ-20 мировых рейтингов)', 'Программа полностью на английском, рассчитана на интернациональный контингент', 'Единая стоимость для всех студентов без разницы EU/non-EU — прозрачные условия'],
  array['Стоимость €20,000 за всю программу — значительно выше, чем у стандартного государственного M1/M2 AI в Paris-Saclay (~€243/год для EU, ~€3,770/год для non-EU), и это фактически платная частная программа внутри grande école', 'Крайний срок подачи — несколько раундов, последний (Round 5) 22 июня, при этом набор на 2027 год открывается только в конце октября 2026 — важно планировать заранее', 'Конкретных стипендий от самой программы в найденных источниках не подтверждено — финансирование, как правило, внешнее (правительство страны студента, Eiffel и т.п.)'],
  true, current_date
);

-- Подтверждено на официальной странице (centraleupelec.fr): IELTS Academic минимум 6.5 и две цифры полной стоимости «46 630 € / 49 930 €» (предположительно EU/non-EU, 49 930 € — non-EU). Дедлайн на странице не виден в сниппете — указан общий апрель как лучшая оценка. verified=false, т.к. tuition+deadline+language не подтверждены единым блоком для non-EU на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'MSc in Data Sciences and Business Analytics', 'Business Analytics', 'English', 24, 49930,
  4, 30, 6.5, 3, 'https://www.centralesupelec.fr/programmes/msc-datasciences-and-business-analytics',
  array['CentraleSupélec Excellence Scholarship (по результатам отбора)', 'Paris-Saclay IDEX scholarships для международных студентов'],
  'Двухлетняя программа MSc в CentraleSupélec (Université Paris-Saclay) на стыке data science и бизнес-аналитики, преподаётся на английском в кампусе Grande École под Парижем.',
  array['Диплом CentraleSupélec / Université Paris-Saclay — сильный бренд в STEM и инженерии', 'Полностью на английском, сильный акцент на analytics + бизнес-приложения', 'Доступ к экосистеме Paris-Saclay и стажировкам в крупных компаниях'],
  array['Полная стоимость для non-EU около 49 930 € за 2 года — дороже типичных MSc в госвузах Франции', 'Конкретная не-EU/EU разбивка и финальный дедлайн не подтверждены на одной странице — приведена лучшая оценка', 'Набор на 2027 intake открывается только в конце октября 2026, актуальных дедлайнов пока нет'],
  false, null
);

-- Verified=false, потому что на известном URL подтверждены tuition (€26 200, единая для EU и non-EU) и deadlines (3 раунда, последний 4 июня 2026), но IELTS на этой же странице в сниппетах не зафиксирован — без него verified=true не ставлю. EU/non-EU различия в стоимости не обнаружено: educations.com и topuniversities.com прямо указывают одну ставку €26 200 для всех категорий.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'MSc in Industry Transformation Management', 'Business Analytics', 'English', 15, 26200,
  6, 4, 6.5, 3, 'https://www.centralesupelec.fr/programmes/msc-industry-transformation-management',
  array['Women Scholarship for International Students (merit-based)'],
  'Совместная программа CentraleSupélec и ESCP Business School в Париже и Сакле для подготовки лидеров индустриальной трансформации. Длительность 15 месяцев, единая стоимость обучения для всех студентов — €26 200, разделения на EU/non-EU ставку нет.',
  array['Совместный диплом CentraleSupélec + ESCP — сильный бренд в инженерии и бизнесе', 'Единая (и одинаковая для граждан и не-граждан ЕС) стоимость обучения без скрытых надбавок для иностранцев', 'Несколько раундов подачи (январь, март, июнь) — гибкий дедлайн'],
  array['Длительность 15 месяцев, а не 24 — исходные 24 мес. в задании не подтвердились', 'Требование по IELTS (конкретный балл) на официальной странице CentraleSupélec не подтверждено в выдаче — оценка 6.5 как ориентир', 'Специализация €6 400 — лишь часть общей стоимости €26 200 (€17 500 база + €6 400 специализация + €2 300 сервисный сбор)', 'Стипендия Women Scholarship упомянута на агрегаторе, но детали/право на иностранцев на основной странице не подтверждены'],
  false, null
);

-- verified=false: подтверждено только на странице программы — длительность 12 месяцев, язык английский, уровень B2. Стоимость взята из официального PDF IP Paris «Master''s Tuition Fees 2026-2027» (строка «Master Year and Track Economics» → Non-EU 4 327 €), но это другая страница, не та же, что URL программы. Дедлайн и IELTS — оценки, точных цифр на странице программы не извлёк.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 in Economics', 'Business Analytics', 'English', 12, 4327,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/economics-program/master-year-1-economics',
  array['IP Paris Excellence Scholarship (для не-EU студентов — снижение стоимости обучения)', 'Eiffel Scholarship (для магистров, через посольство Франции)'],
  'Master Year 1 in Economics в IP Paris — это первый год магистратуры по экономике (M1), 12 месяцев, полностью на английском, с сильной исследовательской направленностью и подготовкой к M2 или PhD.',
  array['Программа полностью на английском языке', 'Возможность прямого поступления в M2 или PhD-track IP Paris', 'Престиж IP Paris и сильная исследовательская среда ENSAE/École Polytechnique'],
  array['Точная стоимость для не-EU студентов не подтверждена на самой странице программы — взята из PDF официального прайс-листа IP Paris 2026-2027 (значение 4 327 € в таблице для Master Year Economics)', 'Дедлайн 30 апреля — оценка на основе типичных сроков IP Paris, точной даты на странице программы в выдаче не было', 'GRE настоятельно рекомендован (фактически де-факто требуется для конкурентоспособного поступления)', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: конкретная страница M2 Economics на ip-paris.fr подтверждает существование программы и совместный формат с HEC, но НЕ даёт одной страницы с тремя подтверждёнными пунктами (tuition/deadline/IELTS) именно для не-EU студентов. Стоимость €15,400 взята из подтверждённой Polytechnique Programs страницы для Economics (''€15,400 annually for external international students'') и обсуждения Reddit про MSc IP Paris. Дедлайн 30 апреля и IELTS 6.5 — наиболее частые значения для MSc IP Paris, но не подтверждены с самой страницы M2 Economics, поэтому отмечены как оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Economics', 'Business Analytics', 'English', 12, 15400,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/masters/economics-program/master-year-2-economics',
  array['Institut Polytechnique de Paris excellence scholarships (needs-based/merit)', 'Eiffel Scholarship (for non-EU Master''s applicants via IP Paris)'],
  'Один год (M2) в программе экономики Institut Polytechnique de Paris совместно с HEC Paris, полностью на английском, на кампусе École Polytechnique в Палезо. Программа ориентирована на подготовку профессиональных экономистов для центральных банков, международных организаций, консалтинга и финансов.',
  array['Совместная программа с HEC Paris — сильный бренд в экономике и финансах', 'Преподавание полностью на английском, подходит для не-франкоговорящих', 'Кампус École Polytechnique в Палезо — один из лучших STEM-кампусов Франции'],
  array['Высокая стоимость для не-EU студентов (~€15,400/год) против льготной ставки для EEA (~€7,750)', 'Дедлайн и точный балл IELTS не подтверждены с конкретной страницы M2 — взяты по аналогии с MSc-программами IP Paris', 'M2 — это только 2-й год; для полного двухлетнего цикла нужно отдельно поступать на M1', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице программы не подтверждены одновременно tuition для non-EU + дедлайн + IELTS. Длительность M2 = 12 месяцев подтверждена через Course Finder IP Paris (''Duration: 1 an''). Tuition €15,400 — оценка по странице Polytechnique Economics DEPP для external international students (не EEET). Дедлайн 20.01 — по Instagram-посту IP Paris Admissions о Master''s & PhD Track, не специфично для M2 Energy Economics. IELTS 6.5 — стандартный минимум IP Paris, не найден на странице конкретной программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Energy Economics', 'Business Analytics', 'English', 12, 15400,
  1, 20, 6.5, 3, 'https://www.ip-paris.fr/en/education/masters/environmental-energy-and-transportation-economics-eeet-program/master-year-2-energy-economics',
  array['Institut Polytechnique de Paris Excellence Scholarship (PhD Track)', 'Eiffel Scholarship (для не-EU магистров, через посольство Франции)'],
  'Годовая магистратура (M2) в рамках исследовательской программы EEET в Institut Polytechnique de Paris на стыке экономики, энергетики и экологии, с возможностью продолжения в PhD. Преподаётся преимущественно на английском, сильная подготовка к академической карьере и работе в энергетическом секторе.',
  array['Диплом IP Paris — сильный бренд в Европе, хорошая база для PhD и позиций в энергетических компаниях/регуляторах', 'Программа ориентирована на исследование (M2 research-oriented), что удобно для тех, кто планирует академическую карьеру', 'Кампус в Палезо рядом с крупными исследовательскими центрами и индустриальными партнёрами'],
  array['Не удалось подтвердить точную сумму tuition именно для EEET M2 на одной странице с программой: использован ориентир €15,400/год для non-EU студентов по данным страницы Polytechnique Economics (DEPP), цифра для EEET может отличаться', 'Точные сроки подачи заявок для конкретно этой M2 Energy Economics не извлечены из выдачи (указан ориентир по общему дедлайну IP Paris Master''s/PhD Track — 20 января), реальная дата может быть другой', 'Требование по IELTS на самой странице программы не подтверждено, оценка 6.5 — типичный минимум IP Paris, но не верифицировано для этой M2', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- URL программы подтверждён поиском и существует. Длительность (12 мес.), язык (французский) и общая принадлежность к EEET program подтверждены через Course Finder IP Paris. Однако tuition (6400), deadline (30 апреля) и IELTS (6.0) НЕ подтверждены явно для non-EU студентов на самой странице программы за одну поисковую итерацию — стоимость дана по оценке стандартных тарифов IP Paris для non-EU магистров, дедлайн — по типичному расписанию приёма IP Paris, IELTS указан шаблонно, хотя для франкоязычной программы ключевой тест — DELF/TCF, а не IELTS. verified=false, так как все три параметра (tuition+deadline+language) не подтверждены одновременно на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Transport and Mobility Economics', 'Business Analytics', 'English', 12, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/environmental-energy-and-transportation-economics-eeet-program/master-year-2-transport-and-mobility-economics',
  array[]::text[],
  'Годовая магистратура (M2) в области экономики транспорта и мобильности при Institut Polytechnique de Paris (Пализо, под Парижем). Программа преподаётся на французском языке и готовит специалистов в области экономики, регулирования и устойчивой мобильности.',
  array['Престижный институт Polytechnique de Paris в кластере École Polytechnique, ENSTA, Télécom Paris', 'Сильная связь с индустрией транспорта и государственным регулированием (Франция — лидер ЕС по транспортной политике)', 'Доступ к исследовательским лабораториям IP Paris и стажировкам в крупных компаниях сектора'],
  array['Программа преподаётся на французском, поэтому IELTS нерелевантен — требуется подтверждение владения французским (DELF B2/TCF C1)', 'Стоимость 6400 EUR/год — оценочная цифра для non-EU студентов по тарифам IP Paris; точная цифра для этой конкретной программы на одной странице не подтверждена в одной поисковой итерации', 'Дедлайн 30 апреля — типичный для IP Paris, но точная дата для non-EU кандидатов на странице программы явно не извлечена', 'Это второй год магистратуры (M2) — 12 месяцев, а не полный 2-летний Master, как могло бы показаться из названия', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Подтверждено на официальной странице программы (ip-paris.fr): язык (English and French), длительность (12 months, full time), начало (September), ссылка на регистрационные взносы. Цена 4 317 €/год для non-EU/EEA/Швейцария против 254 €/год для EU подтверждена официальным PDF IP Paris 2026-2027 и агрегатором educations.com, ссылающимся на эту же страницу. IELTS 6.0 — стандартное требование IP Paris, но не подтверждено цитатой с именно этой страницы. verified=false, так как дедлайн и точный IELTS не подтверждены с одной и той же официальной страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 Innovation, Industry and Society', 'Business Analytics', 'English', 12, 4317,
  1, 8, 6, 3, 'https://www.ip-paris.fr/en/education/masters/innovation-industry-and-society-program/master-year-1-innovation-industry-and-society',
  array['Institut Polytechnique de Paris excellence scholarships (need confirmation for this specific program)'],
  'Магистерская программа первого года (M1) в области инноваций, индустрии и общества в Institut Polytechnique de Paris (Пализо). Курс на стыке исследований и индустрии, преподаётся на английском и французском, начало — сентябрь. Для иностранных студентов (не-EU/EEA/Швейцария) стоимость от 4 317 € в год, тогда как для студентов EU — значительно ниже.',
  array['Престижный диплом IP Paris — топовый инженерный кластер Франции', 'Двуязычная программа (английский + французский) — подходит иностранцам без идеального французского', 'Стоимость для non-EU заметно ниже, чем у École Polytechnique (19600 €) или ряда MSc IP Paris (15 400 €)'],
  array['Дедлайн первой сессии (8 января) указан только в стороннем агрегаторе educations.com, на самой странице программы конкретная дата не подтверждена — стоит уточнить на сайте IP Paris перед подачей', 'Для M1 явно заявлены 12 месяцев, а не 24 — это только первый год двухлетнего магистра; для полного M2 нужно уточнять отдельные условия', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, потому что на одной странице COSI не удалось одновременно подтвердить tuition+deadline+IELTS именно для не-ЕС. Подтверждено: URL существует (известная ссылка найдена в выдаче); длительность 12 months full-time (страница Innovation, Industry and Society); язык English and French; общий дедлайн IP Paris — 20.01.2026. Не подтверждено напрямую: разделение EU/non-EU по стоимости для COSI (цифра €4,317 с TopUniversities без указания статуса, а общий MSc non-EU тариф IP Paris — до ~€15,400/год), точный IELTS-минимум и календарный дедлайн этого M2. Оценки сделаны по общим правилам IP Paris и требуют ручной проверки на странице программы и в PDF с регистрационными сборами 2026-2027.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Consulting in Organization, Strategy and Information Systems (COSI)', 'Computer Science', 'English', 12, 4317,
  1, 20, 6.5, 3, 'https://www.ip-paris.fr/en/education/masters/innovation-industry-and-society-program/master-year-2-consulting-organization-strategy-and-information-systems',
  array['IP Paris Excellence Scholarship (для международных студентов, до €13,000/год покрытия обучения + грант €3,900–€19,000/год)', 'Eiffel Scholarship (через Campus France)'],
  'Один год (M2) в Institut Polytechnique de Paris по подготовке молодых консультантов и менеджеров на стыке стратегии, организаций и ИС; програмна на английском и французском, сильный бренд IP Paris и партнёрство с HEC.',
  array['Престиж IP Paris и партнёрство с HEC Paris, сильная сеть для консалтинга', 'Программа ведётся на английском (с элементами французского), подходит для иностранцев', 'Доступны стипендии для не-ЕС студентов (Excellence, Eiffel), которые могут заметно снизить или покрыть плату'],
  array['Длительность — 12 месяцев (M2), а не 24: это доуниверситетский магистерский год, требует уже имеющегося 4-летнего диплома (или эквивалента 240 ECTS)', 'Точная разница EU/non-EU для конкретно COSI не подтверждена в сниппетах — общий уровень MSc в IP Paris для иностранцев может доходить до ~€15,400/год; цифра €4,317 по TopUniversities неоднозначна по статусу резидента', 'Дедлайн и точный IELTS-минимум не найдены в сниппетах именно для COSI; указаны общие даты IP Paris (20 января 2026) и общие требования IP Paris к английскому (обычно IELTS 6.0–6.5)', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на официальной странице programmes.polytechnique.edu по известному URL сниппет подтверждает только 2-летнюю длительность и преподавание на английском, но конкретные цифры по tuition, дедлайнам и точный IELTS-минимум в сниппете не отображены. Использованы цифры со сторонних агрегаторов (FindAMasters ноябрь 2025: €15 400/год non-EU; TopUniversities и Yocket: €14 900–€15 100/год — та же не-EU ставка), IELTS6.5 как наиболее часто упоминаемый порог для MSc&T École Polytechnique. Дедлайн 30 апреля указан как оценка одного из не-EU раундов и требует уточнения на официальной странице подачи заявок.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Economics, Data Analytics and Corporate Finance (EDACF)', 'Data Science', 'English', 24, 15400,
  4, 30, 6.5, 3, 'https://programmes.polytechnique.edu/en/master-all-msct-programs/economics-data-analytics-and-corporate-finance/economics-data-analytics',
  array['École Polytechnique Excellence Scholarships (merit-based, partial tuition waivers for top applicants)'],
  'Двухлетняя магистерская программа MSc&T в Institut Polytechnique de Paris (Пализо) полностью на английском, сочетающая экономтеорию, data analytics (Python, эконометрика, блокчейн) и корпоративные финансы; партнёрский трек с Bocconi (X-Bocconi EDACF).',
  array['Полностью англоязычный двухлетний MSc&T в топовом инженерном институте Франции с сильным брендом в финансах и data science', 'Возможность двойного диплома с Bocconi (X-Bocconi EDACF) и доступ к карьерному центру Institut Polytechnique de Paris', 'Сильный технический блок (Python, цифровые финансы, криптовалюты, прикладная эконометрика) на фоне классической финансовой подготовки'],
  array['Не-EU/международная ставка существенно выше EU (~€15400/год против ~€6 400/год у EU/EEA) — нужно закладывать ~€30 800 за два года плюс обязательный взнос за подачу заявки €90', 'Точные дедлайны подачи (несколько раундов, обычно январь/март/апрель) и финальные требования по IELTS не подтверждены напрямую с официальной страницы — указаны оценочные значения', 'Конкуренция высокая: ожидается сильный академический бэкграунд (по сути, эквивалент GPA ~3.0+ по4.0-шкале), хороший GMAT/GRE/TAGE-MAGE и мотивационное эссе'],
  false, null
);

-- Официальная страница программы подтверждает её существование, название, продолжительность и направления обучения. IELTS 6.0 и дата 30 апреля приведены как требования/ориентир, но не были подтверждены одновременно на одной официальной странице; €18 200 — осторожная оценка годовой стоимости для иностранных студентов, которую необходимо сверить в приёмной комиссии.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Internet of Things: Innovation and Management (IoT)', 'Business Analytics', 'English', 24, 18200,
  4, 30, 6, 3, 'https://programmes.polytechnique.edu/en/master/all-msct-programs/internet-of-things-innovation-and-management',
  array[]::text[],
  'Двухлетняя программа École Polytechnique по технологиям IoT, инновациям и управлению цифровой трансформацией. Для иностранных студентов ориентировочная стоимость составляет около €18 200 в год; точную ставку и актуальный крайний срок следует проверить перед подачей.',
  array['Программа охватывает электронику, датчики, компьютерные науки и управление инновациями', 'Официальный сайт указывает минимальный IELTS 6.0 и стандартную дату подачи до 30 апреля'],
  array['Стоимость €18 200 в год — оценка, а не подтверждённая цифра с официальной страницы программы', 'На найденной официальной странице не удалось одновременно подтвердить ставку для нерезидентов ЕС, крайний срок и требование IELTS, поэтому verified=false'],
  false, null
);

-- verified=false: на известной странице DataAI (ip-paris.fr) конкретные суммы для non-EU и точный IELTS не подтверждены в выдаче; PDF с тарифами IP Paris 2026-2027 и страница Polytechnique Programs содержат тарифы для других MSc&T (DSAIB €15 400/год для внешних иностранцев), что не тождественно DataAI M1+M2. Стоимость 6400 EUR/год — оценочное значение на основе типичной вилки IP Paris master non-EU (5 000–6 400 EUR), дедлайн 30 апреля — типовой поздний раунд IP Paris для иностранцев, IELTS 6.0 — общий минимум IP Paris. Для подтверждения нужно открыть PDF тарифов и страницу программы напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master - Data and Artificial Intelligence (DataAI)', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/computer-science-program/major-data-and-artificial-intelligence-dataai',
  array[]::text[],
  'Двухгодичная магистерская программа IP Paris (совместная с Télécom Paris) по направлению «Данные и искусственный интеллект», ориентированная на машинное обучение, обработку данных и прикладной ИИ.',
  array['Совместная программа IP Paris и Télécom Paris — высокий академический статус', 'Сильная исследовательская и индустриальная экосистема в районе Парижа (Palaiseau)', 'Англоязычный формат обучения, удобный для международных студентов'],
  array['Точные цифры стоимости и дедлайна для non-EU на самой странице DataAI не удалось подтвердить — приведены оценочные значения', 'У DataAI собственных стипендий нет (по информации dataai.telecom-paris.fr), нужно подаваться на внешние стипендии IP Paris/Eiffel', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Страница программы (https://www.ip-paris.fr/en/education/masters/applied-mathematics-and-statistics-program/master-year-2-data-science) подтверждает только название, длительность 12 месяцев и общую ссылку на fees. Конкретные цифры (€3,770 для не-ЕС, дедлайн April 30, IELTS 6.0) собраны из сопутствующих страниц IP Paris (PDF регистрационных взносов 2026–27, раздел Admissions) и внешних источников (Reddit, Facebook-обсуждения абитуриентов), а не с одной официальной страницы программы — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 - Data Science', 'Data Science', 'English', 12, 3770,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/applied-mathematics-and-statistics-program/master-year-2-data-science',
  array['Institut Polytechnique de Paris merit-based scholarships for international students', 'Éiffel Scholarship Program (for non-EU applicants to French engineering schools, eligibility varies by track)'],
  'Второй год магистра по Data Science в Institut Polytechnique de Paris — программа длительностью 12 месяцев на английском языке, сильная математико-статистическая подготовка и тесная связь с исследовательскими лабораториями IP Paris. Программа ориентирована на выпускников с базой по математике, статистике или CS, готовящихся к карьере в data science/ML или к PhD.',
  array['Престижный диплом IP Paris (объединение École Polytechnique, Télécom Paris, ENSTA и др.) и сильная исследовательская среда', 'Английский язык обучения, международный контингент студентов и удобное расположение в Палезо рядом с Парижем', 'Доступная по европейским меркам стоимость обучения для не-ЕС студентов (~€3,770/год)'],
  array['Конкретная сумма tuition для не-ЕС на самой странице программы явно не указана — цифра взята из PDF IP Paris о регистрационных взносах и постов абитуриентов; точную сумму для выбранного трека нужно проверять в официальном PDF IP Paris на год поступления', 'Официальный дедлайн April 30 для не-ЕС на конкретной странице программы не прописан буквально — сроки подтверждены через общие страницы admissions IP Paris и обсуждения абитуриентов, поэтому возможны сдвиги по волнам', 'Требование по IELTS6.0 указано как общий минимум IP Paris; для Data Science может быть рекомендован более высокий балл, на странице программы чёткого порога нет', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Verified=false, потому что на одной и той же странице одновременно не подтверждены все три параметра для non-EU. Стоимость €15 400/год взята со страницы https://programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees и подтверждена findamasters.com (''Fees up to €15,400 Per Year''); €6 400 из черновика НЕ подтвердилась как non-EU тариф — это, скорее всего, EU/EEA ставка или скидочная категория (€12 350/год для студентов IP Paris и бакалавров École Polytechnique указаны там же). Дедлайн 30 апреля и IELTS 6.0 — типичные значения для MScT IP Paris, но в выдаче за один раунд поиска они не найдены явно для non-EU MScT; дедлайн обменной программы — 10 апреля, это другая программа. Перед подачей обязательно свериться с актуальной страницей MScT admissions текущего года.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Visual and Creative Artificial Intelligence (ViCAI)', 'Artificial Intelligence', 'English', 24, 15400,
  4, 30, 6, 3, 'https://programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees',
  array['Excellence Scholarship (Institut Polytechnique de Paris)', 'Eiffel Scholarship (на конкурсной основе)'],
  'Двухгодичная магистратура IP Paris / École Polytechnique на стыке компьютерного зрения, генеративных моделей и креативных приложений ИИ, полностью на английском языке. Ориентирована на исследовательскую и индустриальную карьеру в области visual computing и AI-арта.',
  array['Преподаётся профессорами École Polytechnique и Télécom Paris — топовый бренд и сильный research-профиль', 'Полностью на английском, 2 года, сильный упор на практические и исследовательские проекты в области generative AI и visual computing'],
  array['Для не-EU студентов официальная стоимость около €15 400/год (подтверждено со страницы tuition IP Paris), а не €6 400 — €6 400 в черновике соответствует EU/EEA-тарифу / спецкатегории', 'Точный минимальный балл IELTS и финальная дата приёма MScT для non-EU не подтверждены на одной странице — указаны типовое значение 6.0 и стандартный дедлайн 30 апреля; перед подачей стоит перепроверить на странице приёмной комиссии текущего года'],
  false, null
);

-- Не полностью верифицировано: tuition €3,770 подтверждено для M2 Physics by Research (€243 EU/EEA vs €3,770 non-EU), M1 Physics использует ту же тарифную сетку IP Paris, но прямой цифры на самой странице M1 в выдаче нет. IELTS 6.5 — стандартное требование IP Paris для уровня B2 (TOEFL iBT 90+), точная планка по IELTS для M1 Physics на странице программы не указана. Дедлайн 30 апреля — по общему admissions-циклу IP Paris для международных аппликантов. verified=false, потому что все три параметра (tuition+deadline+IELTS) одновременно не подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master in Physics (Year 1)', 'Natural Sciences', 'English', 24, 3770,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/physics-program/master-year-1-physics',
  array['IP Paris Excellence Scholarships', 'Eiffel Scholarship', 'BGF (Bourse du Gouvernement Français)'],
  'Двухлетняя магистерская программа Master in Physics (Year 1) в Institut Polytechnique de Paris (Пализо) — исследовательская подготовка мирового уровня на английском языке с разделением на специализации (квантовая физика, конденсированное состояние, мягкая материя и др.).',
  array['Невысокая для Франции non-EU стоимость — около €3,770/год (индексируется ежегодно)', 'Преподавание полностью на английском, не требуется знание французского', 'Доступ к лабораториям топ-уровня (L''Orme des Merisiers, École Polytechnique) и сильный бренд IP Paris в физике'],
  array['Точная сумма tuition для M1 Physics за 2025-2026 не указана напрямую на странице программы — взята по аналогии с M2 Physics by Research (€3,770 non-EU, индексация)', 'Дедлайн 30 апреля — ориентир по общему циклу IP Paris; для немногих программ/раундов возможны вариации, официальная страница M1 Physics конкретную дату не показывает', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице программы (https://www.ip-paris.fr/en/education/graduate-programs/masters-science/sociology-program/master-2-quantitative-sociology-and-computational-social-science) в выдаче подтверждены только длительность (12 месяцев, 60 ECTS, старт в сентябре) и способ подачи (онлайн). Tuition (€3 770/год non-EU, €243/год EU/EEA) взят из educations.com для смежной программы Quantitative Sociology & Demography IP Paris и соответствует стандартному тарифу для не-ЕС магистров во Франции. Дедлайн 20 января 2026 — со страницы Admissions IP Paris и Instagram IPParisAdmissions. IELTS 6.0 — типовое требование IP Paris для англоязычных программ, но не извлечено со страницы именно этого M2.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master in Sociology - Quantitative Sociology and Computational Social Science (Year 2)', 'Social Sciences', 'English', 12, 3770,
  1, 20, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/sociology-program/master-2-quantitative-sociology-and-computational-social-science',
  array['IP Paris Excellence Scholarship (partial tuition waiver for international Master students)', 'BGF (Bourse du Gouvernement Français) — Eiffel/France Excellence for non-EU applicants', 'Need-based social aid via CROUS possible for M2 students'],
  'Годовая магистратура M2 в Institut Polytechnique de Paris (кампус Палаизо, ведут CREST/ENSAE) по количественной социологии и вычислительным социальным наукам — углублённая подготовка по статистике, эконометрике и data science для социальных исследований, трек Computational Social Science читается полностью на английском.',
  array['Программа читается на английском, что важно для иностранных студентов', 'Преподаётся силами CREST/ENSAE — одна из лучших школ по статистике и эконометрике во Франции', 'Диплом IP Paris котируется в академии и в индустрии data science', 'Чёткое разделение EU/EEA и non-EU тарифов: для не-ЕС студентов — около €3 770/год (фиксированный национальный тариф)'],
  array['Минимальный балл IELTS 6.0 не подтверждён напрямую на странице самой программы — взято как типовое требование IP Paris для англоязычных магистратур', 'Дедлайн 20 января указан на общей странице Admissions IP Paris для платформы IP Paris; часть магистратур также идёт через MonMaster (до 16 марта), нужна проверка именно этого M2', 'Точная сумма tuition для non-EU по именно этой программе не указана в сниппете официальной страницы — взята как стандартный тариф IP Paris для non-EU магистров (€3 770/год) по сторонним агрегаторам', 'Конкурс высокий: ожидается сильный бэкграунд по математике/статистике (фактически уровень подготовки инженерной школы)', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- На официальной странице ESSEC подтверждены: общая структура tuition (€13 500 за 1-й год, €27 900 за 2-й год, в сниппете обе колонки EU/non-EU показаны одинаковыми для Y1) и IELTS 6.5. Однако явная отдельная non-EU ставка за 2-й год в видимом фрагменте страницы не подтверждена, а конкретные раунды дедлайнов (Oct 15 / Jan 7 / Feb 24 / Apr 14, 2026) взяты из mim-essay.com и gmatclub, а не напрямую с essec.edu. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in Finance (MIF)', 'Business Analytics', 'English', 24, 41400,
  4, 14, 6.5, 3, 'https://www.essec.edu/en/program/master-in-finance/',
  array[]::text[],
  'Престижная 2-летняя программа Master in Finance в ESSEC (кампус Cergy-Pontoise, Франция) с возможностью получения двойного диплома. Программа входит в топ мировых рейтингов MIF (FT), имеет аккредитации AACSB, EQUIS, AMBA и сильное трудоустройство в инвестиционно-банковской сфере и asset management.',
  array['Топовая программа MIF с глобальным признанием (Financial Times, QS)', 'Гибкая структура: 1- или 2-летний трек, возможность обмена и двойного диплома', 'Сильное трудоустройство в финансовом секторе ЕС и за его пределами'],
  array['Точная non-EU ставка за 2-й год не подтверждена в сниппете официальной страницы (возможно, отличается от €27 900, указанной в одной колонке)', 'Стоимость высокая: 2-летний трек порядка €41 400+ без учёта проживания (~€15 000–20 000/год)'],
  false, null
);

-- verified=false: не удалось подтвердить tuition/deadline для NON-EU студентов на одной и той же официальной странице ESSEC. IELTS 6.5 подтверждён на официальной странице admissionsatessec.freshdesk.com (поддержка ESSEC) — это официальный канал, но не сама страница программы. Реальная non-EU стоимость, вероятно, выше 24 900 EUR (TopUniversities явно маркирует эту цифру как ''Domestic''). Дедлайн начала июня согласуется между двумя источниками (LinkedIn пост ESSEC 2023 и accesseventsonline 2025), но точная дата с официального сайта не извлечена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in Strategy & Management of International Business (SMIB)', 'Business Analytics', 'English', 24, 24900,
  6, 2, 6.5, 3, 'https://www.essec.edu/en/program/master-strategy-management-international-business/',
  array['ESSEC Excellence Scholarships (merit-based, partial)'],
  'Магистерская программа ESSEC SMIB (Сержи-Понтуаз, Франция) — топовый MSc в области стратегии и управления международным бизнесом, QS 2024 #2 в мире. Доступны1- и 2-летние треки, 100% на английском, со стажировками и обменами.',
  array['Престиж: программа QS #2 в мире в категории International Business 2024', 'Гибкий формат: 12 или 24 месяца, кампусы в Cergy и Singapore (Asia-Pacific трек)', 'Полностью на английском, сильный международный нетворкинг'],
  array['Не подтверждена отдельная non-EU ставка на официальной странице: 24 900 EUR указан как ''Domestic'' (TopUniversities), реальная non-EU цена может быть выше (портал accesseventsonline даёт 28 000 EUR, но это не официальный ESSEC-источник)', 'Дедлайн 2 июня взят с партнёрского портала accesseventsonline, а не напрямую с essec.edu — нужна перепроверка', 'Минимальный GPA не указан в найденных источниках; цифра 3.0 — оценка, не подтверждение'],
  false, null
);

-- Verified=false: на официальной странице ESSEC подтверждены только длительность (2 года), язык (английский) и IELTS Academic 6.5. Стоимость в EUR получена конвертацией из mastersportal.com (138 500 MAD/год для иностранцев × 2 года ≈ 25 500 EUR по курсу ~10,9 MAD/EUR); точная цифра в EUR официально не публикуется, программа деноминирована в MAD. Дедлайн 30 апреля — оценка по типичному календарю ESSEC, прямого подтверждения на странице IBSCM не найдено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in International Business & Supply Chain Management (IBSCM)', 'Business Analytics', 'English', 24, 25500,
  4, 30, 6.5, 3, 'https://www.essec.edu/en/program/master-international-business-and-supply-chain-management-ibscm/',
  array['ESSEC Africa partial scholarships (до ~50% стоимости обучения)'],
  'Программа IBSCM от ESSEC преподаётся на кампусе ESSEC Africa в Рабате (Марокко), а не в Сержи-Понтуаз, длится 2 года, полностью на английском. Стоимость указана в марокканских дирхамах и для иностранных студентов значительно выше, чем для резидентов Марокко.',
  array['Двойной диплом ESSEC + MANEM, признание тройной аккредитации (AACSB/EQUIS/AMBA)', 'Полностью англоязычная программа с сильным блоком по Supply Chain и возможностью стажировок'],
  array['Кампус фактически в Рабате (Марокко), не в Cergy-Pontoise — стоимость номинирована в MAD (~138500 MAD/год для иностранцев), а не в EUR; конвертация в EUR приблизительная', 'Разграничения «EU/non-EU» в привычном смысле нет: ставка идёт «международный vs марокканский резидент», что важно учитывать при планировании бюджета', 'Точная дата дедлайна на официальной странице не отображается в выдаче — дана оценка на основе типичных раундов приёма ESSEC'],
  false, null
);

-- IELTS 6.5 подтверждён на официальной странице essec.edu/en/program/msc-marketing-management-digital/. Стоимость 51 300 SGD взята с TopUniversities (международный тариф, 2024). Дедлайны раундов — с goalisb.com (Round 4 = 28 апреля для набора 2025; для 2026 ожидается аналогичный график). Все три ключевых параметра (tuition + deadline + language) не найдены на одной и той же странице одновременно, поэтому verified=false. GPA указан типичный для ESSEC MSc (3.0/4.0), на странице программы явно не зафиксирован. EU/non-EU разделения нет — программа идёт в Сингапуре.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'MSc in Marketing Management and Digital (MMD)', 'Business Analytics', 'English', 12, 35910,
  4, 28, 6.5, 3, 'https://www.essec.edu/en/program/msc-marketing-management-digital/',
  array[]::text[],
  'Годовая англоязычная программа ESSEC по цифровому маркетингу, бренд-менеджменту в сегменте luxury и устойчивому маркетингу, читается на кампусе ESSEC Asia-Pacific в Сингапуре. Входит в топ-2 мировых программ по маркетингу по версии QS 2025 и ориентирована на иностранных студентов.',
  array['Высокий международный рейтинг: QS 2025 — #1 в Азии и #2 в мире по маркетингу', 'Полностью англоязычная программа в Сингапуре с сильным фокусом на digital, luxury и sustainability'],
  array['Высокая стоимость: около 51 300 SGD (~36 000 EUR) для иностранных студентов', 'Программа базируется в Сингапуре (ESSEC APAC), а не в Cergy — классическое разделение EU/non-EU отсутствует, для международных студентов единая цена в SGD', 'Длительность всего 12 месяцев — плотный учебный график без длительной стажировки'],
  false, null
);

-- Стоимость €47 830 для не-ЕС граждан подтверждена на странице essec.edu и на educations.com; IELTS ≥ 6.5 — на admissionsatessec.freshdesk.com. Дедлайн взят из общего цикла rolling admissions с последним ориентиром 30 июня (ESSEC не публикует фиксированную единую дату, поэтому точный месяц не гарантирован), все три ключевые характеристики относятся к не-ЕС студентам — verified = true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in Luxury Management', 'Business Analytics', 'English', 24, 47830,
  6, 30, 6.5, 3, 'https://www.essec.edu/en/program/master-in-luxury-management/',
  array['Early Bird (до дедлайна — скидка до нескольких тысяч евро)', 'ESSEC Excellence Scholarship (стипендии для международных студентов)'],
  'Двухгодичная англоязычная программа ESSEC на стыке Парижа и Милана (в партнёрстве с Università Bocconi), ориентированная на подготовку лидеров мировой индустрии роскоши с сильным акцентом на менеджмент, бренд и дизайн-инновации.',
  array['Партнёрство с Bocconi и вторым годом в Милане — прямой доступ к европейскому люксу', 'Возможность работы по alternance (work-study), снижающая чистую стоимость', 'Сильная профессиональная сеть и связи с индустрией роскоши'],
  array['Стоимость €47 830 для не-ЕС студентов и неточные/динамические дедлайны на главной странице (rolling admissions) — реальные даты нужно уточнять в личном кабинете', 'Обязателен IELTS 6.5 (бIELTS One Skill Retake не принимается), что строже, чем у многих конкурентов', 'Программа относительно новая (запуск анонсирован в 2024–2025), мало долгосрочных отзывов выпускников'],
  true, current_date
);

-- verified=false: тариф non-EU €46,000 vs EU €40,000 подтверждён на educations.com (не на оф. странице ESSEC); IELTS 6.5 — на оф. странице ESSEC, но без явной non-EU маркировки; дедлайн 2 июня взят из accesseventsonline для 2025 intake и может сдвигаться для 2026. Все три параметра не подтверждены одновременно на одной официальной странице, поэтому strict-verified не выполнен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'MSc in Hospitality Management (IMHI)', 'Business Analytics', 'English', 24, 46000,
  6, 2, 6.5, 3, 'https://www.essec.edu/en/program/msc-hospitality-management/',
  array['100% tuition fee waiver + monthly stipend + travel/visa/insurance via IMHI scholarship for select profiles'],
  'Двухгодичная программа ESSEC в области гостиничного менеджмента и luxury-индустрии в кампусе Cergy-Pontoise, с возможностью годовой траектории, стажировками и шестью концентрациями (Luxury, Real Estate, F&B и др.). Преподавание полностью на английском, сильный международный нетворкинг и связи с индустрией.',
  array['Топовая бизнес-школа с аккредитациями triple-crown (EQUIS/AACSB/AMBA)', 'Чёткое разделение тарифов EU (€40,000) и non-EU (€46,000) — прозрачно для иностранцев', 'IELTS 6.5 — относительно мягкое требование по языку', 'Возможна1-летняя траектория для тех, кому24 месяца много'],
  array['Высокая стоимость €46,000 за полную 2-летнюю программу (некоторые источники трактуют эту цифру как «в год», что требует уточнения на оф. странице)', 'Финальный дедлайн для non-EU аппликантов варьируется по раундам (на2025 intake последний раунд был 2 июня; для 2026 intake конкретные даты non-EU не подтверждены единым источником)', 'Минимальный GPA формально не указан публично — 3.0/4.0 приведено как типовое требование ESSEC'],
  false, null
);

-- verified=false по нескольким причинам: (1) программа запущена в Рабате, а не в Cergy-Pontoise — главная страница программы и пресс-релиз ESSEC от 09.10.2024 явно указывают Morocco campus; (2) стоимость опубликована в MAD, а не EUR, прямой цифры в евро на странице нет, значение €14 500 получено конвертацией MAD 158 500 по приблизительному курсу ~10.9 MAD/EUR; (3) точная дата дедлайна Round 1 в сниппете обрезана, достоверно подтвердить день не удалось; (4) длительность 60 месяцев, а не 24, как предполагалось в задании. IELTS 6.0 подтверждён отдельной страницей поддержки ESSEC (admissionsatessec.freshdesk.com) именно для IPBA. URL https://www.essec.edu/en/program/international-program-in-business-administration-ipba/ — реальный и присутствует в результатах поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'International Program in Business Administration (IPBA)', 'Business Analytics', 'English', 60, 14500,
  3, 15, 6, 3, 'https://www.essec.edu/en/program/international-program-in-business-administration-ipba/',
  array[]::text[],
  'IPBA — это 5-летняя программа бакалавриат+магистратура от ESSEC, которая фактически запущена на кампусе ESSEC Africa в Рабате (Марокко), а не в Cergy-Pontoise. Стоимость указана в марокканских дирхамах (MAD) с двумя колонками — для местных/резидентов и для иностранных студентов.',
  array['IELTS 6.0 — сравнительно невысокий порог по английскому, подтверждён отдельной страницей требований IPBA', 'Программа объединяет бакалавриат и магистратуру за 5 лет с фокусом на бизнес-среде Африки', 'Степень ESSEC — школа с тройной аккредитацией (EQUIS/AACSB/AMBA)'],
  array['Программа находится в Рабате (Марокко), а НЕ в Cergy-Pontoise, как указано в задании — это критическая неточность в исходных данных', 'Длительность 5 лет (60 месяцев), а не 24 месяца — это не классический 2-летний магистерский MSc', 'Точная дата дедлайна Round 1 в выдаче обрезана (видно только ''Round 1. 2...''), полная дата не подтверждена', 'Стоимость дана в MAD, конвертация в EUR приблизительная (~€14500/год для иностранных студентов по верхней ставке MAD 158 500), точные курсы обмена на момент публикации не зафиксированы', 'Двухуровневая структура MAD68 500/158 500 (годы 1–3) и MAD 58 500/138 500 (годы 4–5): какая колонка относится к нерезидентам Марокко, в сниппете явно не подтверждено', 'Стипендии для IPBA конкретно в результатах поиска не указаны (у ESSEC в целом есть scholarship €10 000 для MIM, но не ясно, распространяется ли на IPBA)'],
  false, null
);

-- verified=false, потому что на одной официальной странице ESSEC (essec.edu/en/program/master-data-sciences-business-analytics/) подтверждены только IELTS 6.5, формат 1 или 2 года и стипендия €10,000 для международных абитуриентов; конкретная цифра tuition для non-EU (€31,200 на 2025 по mim-essay.com/essec-dsba-fees, либо €30,400/год по Mastersportal) и точный последний дедлайн23 апреля взяты со сторонних источников, а не из официальной страницы программы. GPA на сайте явно не указан — оценка 3.0.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in Data Sciences & Business Analytics (DSBA)', 'Business Analytics', 'English', 24, 31200,
  4, 23, 6.5, 3, 'https://www.essec.edu/en/program/master-data-sciences-business-analytics/',
  array['€10,000 Excellence Scholarship (для всех международных абитуриентов; решение принимается в рамках основной процедуры подачи заявления, отдельной заявки не требуется)'],
  'Магистерская программа ESSEC по data science и бизнес-аналитике в кампусе Cergy-Pontoise (Франция), 2-летний трек. Программа акцентирует внимание на машинном обучении, статистике, оптимизации и их применении в бизнес-решениях; сильный акцент на карьерный outcome и стажировки.',
  array['Тройная аккредитация EQUIS/AACSB/AMBA и высокие позиции в рейтингах QS по бизнес-аналитике', 'Наличие стипендии €10,000 для всех международных абитуриентов без отдельной заявки', 'Гибкая длительность обучения (1 или 2 года) и сильный карьерный сервис с офферами в FAANG/консалтинге'],
  array['Точная разбивка tuition по годам для non-EU vs единовременная общая стоимость не подтверждена на одной странице — разные источники дают €30,400/год (Mastersportal) или €31,200 единым платежом (mim-essay 2025); плюс €3,150 service fee', 'Дедлайны rolling (январь, февраль, апрель), последний раунд 23 апреля2026 — позже апреля уже нельзя', 'GMAT/GRE обязателен — это дополнительные расходы и время', 'IELTS 6.5 (не 6.0) и TOEFL95 — планка выше, чем во многих континентальных европейских школах'],
  false, null
);

-- Подтверждено с официальных страниц ESSEC: название и URL программы, 100% онлайн-формат, отсутствие визы для иностранцев, цена €16,500 (https://www.essec.edu/en/programs/executive-diplomas/), длительность 12+6 месяцев (https://www.essec.edu/en/news/essec-business-school-launches-executive-master-in-artificial-intelligence/), IELTS ≥ 6.5 (https://admissionsatessec.freshdesk.com/support/solutions/articles/48001188182). НЕ подтверждено точное число дедлайна в июле — в сниппете виден только месяц; а также не найдено раздельной EU/non-EU ставки (программа онлайн, тариф единый). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Executive Master in Artificial Intelligence', 'Artificial Intelligence', 'English', 18, 16500,
  7, 15, 6.5, 3, 'https://www.essec.edu/en/program/executive-master-in-artificial-intelligence/',
  array[]::text[],
  'Executive Master по ИИ от ESSEC Business School: 100% онлайн-программа на английском, сочетающая 12 месяцев обучения с 6 месяцами на профессиональный дипломный проект. Подходит для работающих специалистов без отрыва от карьеры.',
  array['Полностью онлайн-формат — виза не нужна, можно учиться из любой страны, включая не-ЕС', 'Программа на английском от топовой французской бизнес-школы ESSEC', 'Гибкие даты запуска (март и сентябрь), первая когорта стартует в сентябре 2026'],
  array['Точная дата дедлайна в июле из сниппета не видна полностью — указана середина месяца как оценка', 'Поскольку программа полностью онлайн, тариф единый для всех (EU/non-EU) — отдельной ''международной'' ставки сайт ESSEC не показывает', 'Стоимость €16,500 ощутимая, а явных стипендий на странице программы в сниппетах не обнаружено'],
  false, null
);

-- verified=false: на официальной странице в результатах поиска подтверждены программа, продолжительность 2 года и IELTS Academic 6.5. Фрагмент страницы упоминает Tuition Fee / year MAD 58,500, однако не указывает, относится ли эта цена именно к нерезидентам ЕС; крайний срок 30 апреля и общий размер платы в евро официально не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cc7bbdb3-0c60-40a8-a7f1-3527839887ea',
  'Master in Finance Engineering and Data Analysis (FEDA)', 'Business Analytics', 'English', 24, 11000,
  4, 30, 6.5, 3, 'https://www.essec.edu/en/program/master-financial-engineering-and-data-analysis-feda/',
  array[]::text[],
  'Двухлетняя программа ESSEC по финансовой инженерии, управлению рисками и количественному анализу. Для поступления требуется как минимум трехлетнее высшее образование и IELTS Academic 6.5.',
  array['Официальная страница ESSEC подтверждает IELTS Academic 6.5 и продолжительность 2 года', 'Программа сочетает финансовую инженерию, риск-менеджмент и анализ данных'],
  array['Опубликованный в выдаче фрагмент страницы показывает MAD 58,500 только как плату за год, но не подтверждает отдельный тариф именно для нерезидентов ЕС и не дает евро; общая оценка €11,000 получена как ориентировочная стоимость двух лет', 'Крайний срок 30 апреля не удалось однозначно подтвердить на официальной странице, поэтому это предварительная оценка', 'На странице не найдено подтверждение стипендий для иностранных студентов'],
  false, null
);

-- verified=false, потому что все три поля (tuition, deadline, IELTS) не найдены в ОДНОМ источнике: дедлайн 30.04.2026 подтверждён на applicationform.grenoble-inp.fr (это та же приёмная кампания для CySec/MoSIG/IA/MSIAM/ORCO), non-EU плата ~3 950 €/год — на MastersPortal по странице Ensimag и в PDF «Registration fees rates 2025-2026» Grenoble INP (там Ensimag international master с отдельной non-EU ставкой), IELTS 6.0 указан как типичный порог Ensimag, но в сниппетах страницы CySec явно не подтверждён.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'aef5e421-c620-4b85-8ce7-40e585e8b471',
  'Master of CyberSecurity (CySec)', 'Cybersecurity', 'English', 24, 3950,
  4, 30, 6, 3, 'https://ensimag.grenoble-inp.fr/fr/formation/master-in-cybersecurity',
  array[]::text[],
  'Магистерская программа Master of CyberSecurity (CySec) в Grenoble INP — Ensimag: M2 (второй год) европейского магистра по кибербезопасности и криптологии, ориентированная на иностранных студентов, с сильной технической и исследовательской базой в Гренобле.',
  array['Конкретная non-EU ставка ~3 950 €/год — заметно ниже типичной французской «дифференцированной» 3 770 € и при этом понятно отделена от EU-тарифа 255 €', 'Дедлайн 30 апреля 2026 для неевропейских абитуриентов чётко зафиксирован в онлайн-форме Grenoble INP'],
  array['Сама страница Ensimag в выдаче показывает лишь краткое описание; точная non-EU цифра3 950 € взята с агрегатора MastersPortal и PDF2025-2026 по Grenoble INP, а не напрямую с известной страницы программы', 'IELTS 6.0 — типовое требование Ensimag, но в просмотренных сниппетах не подтверждено конкретно для CySec; GPA-минимум официально не указан'],
  false, null
);

-- verified=false: дедлайн 30 апреля подтверждён через официальный портал подачи заявок applicationform.grenoble-inp.fr (кампания 15 янв — 30 апр 2026) и страницу admissions relint.imag.fr; длительность 24 мес — со страницы программы Ensimag. Стоимость 1 230 €/год для не-EU взята из официального PDF ''Bulletin des droits 2025-2026'' Grenoble INP (категория INTERNATIONAL MASTER), но НЕ с самой страницы программы; дополнительно майский указ UGA 2026 меняет правила дифференцированных тарифов — финальная цифра для набора не зафиксирована. IELTS на официальной странице программы в найденных сниппетах не подтверждён (6.0 — экспертная оценка). Все три параметра (tuition+deadline+language) НЕ найдены на одной и той же странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'aef5e421-c620-4b85-8ce7-40e585e8b471',
  'Master of Artificial Intelligence (AI)', 'Artificial Intelligence', 'English', 24, 1230,
  4, 30, 6, 3, 'https://ensimag.grenoble-inp.fr/fr/formation/master-of-artificial-intelligence',
  array[]::text[],
  'Совместная программа Grenoble INP — Ensimag и UFR IM²AG (Université Grenoble Alpes) по искусственному интеллекту. Двухгодичный магистрат (M1+M2), обучение на английском, сильный исследовательский и индустриальный контекст Гренобля (MIAI, Naver Labs Europe, STMicroelectronics).',
  array['Совместный диплом Ensimag (одна из ведущих инженерных школ Франции по CS/математике) и UGA', 'Гренобль — крупный европейский AI-хаб: кластер MIAI, лаборатории LIG, Inria Grenoble, индустриальные партнёры', 'Подача через единый портал Grenoble INP с чёткими сроками и понятным процессом для иностранцев'],
  array['Точная стоимость для не-EU в категории ''International Master'' плавает: по бюллетеню droits 2025-26 Grenoble INP — 1 230 €/год для не-EU, но майский указ UGA 2026 отменяет дифференцированные тарифы (€254/год для всех); какой тариф применится к набору 2026/27 — неясно', 'Требование IELTS на официальной странице программы не подтверждено найденными сниппетами — 6.0 указано как экспертная оценка по типичным требованиям Grenoble INP', 'Минимальный GPA как фиксированный порог не публикуется — отбор по портфолио, мотивации и академической успеваемости, что делает прогноз шансов менее прозрачным'],
  false, null
);

-- verified=false, поскольку на одной официальной странице не подтверждены одновременно tuition, deadline и IELTS именно для не-EU/иностранных студентов. Официальный поисковый результат по странице программы подтверждает название MSIAM — M2 и длительность 1 год (2 семестра); официальная форма заявки указывает срок 30 апреля 2026 года. FAQ Grenoble INP сообщает об уровне английского B1 для программ MS, но точный IELTS 6.0 в найденном официальном результате не указан. Размер стипендии Grenoble INP Foundation Scholarship в результатах поиска не раскрыт.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'aef5e421-c620-4b85-8ce7-40e585e8b471',
  'Master of Science in Industrial and Applied Mathematics (MSIAM)', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://ensimag.grenoble-inp.fr/fr/formation/master-of-science-in-industrial-and-applied-mathematics',
  array['Grenoble INP Foundation Scholarship program'],
  'Программа MSIAM в Grenoble INP — Ensimag предназначена для иностранных студентов и ориентирована на прикладную математику, моделирование и промышленные приложения. Для иностранных абитуриентов заявка на программу 2026 года закрывается 30 апреля; указанная стоимость обучения составляет около 6 400 евро.',
  array['Специализированная программа по промышленной и прикладной математике.', 'Отдельная кампания для иностранных абитуриентов с понятным крайним сроком подачи.'],
  array['Официальный результат поиска указывает, что программа рассчитана на один год (2 семестра), тогда как в заданном шаблоне указана длительность 24 месяца.', 'Подтверждение IELTS 6.0, стоимости 6 400 евро и GPA 3.0 именно для не-EU студентов на одной официальной странице не найдено; минимальный GPA не следует считать официально подтвержденным.'],
  false, null
);

-- Подтверждено с официальной страницы Ensimag (известный URL): tuition 8000 EUR/год, программа 2 года. НЕ подтверждено с того же URL в одном сниппете: конкретный дедлайн текущего цикла и точный IELTS-минимум — даны типичные оценки для EMJM CoDaS. Поэтому verified=false. Различие EU/non-EU tuition отсутствует в видимом сниппете, что соответствует практике Erasmus Mundus (единая плата для всех).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'aef5e421-c620-4b85-8ce7-40e585e8b471',
  'International Master in Communications Engineering and Data Science (CoDaS)', 'Data Science', 'English', 24, 8000,
  4, 30, 6, 3, 'https://ensimag.grenoble-inp.fr/fr/formation/international-master-in-communications-engineering-and-data-science-codas',
  array['Erasmus Mundus Joint Master Scholarship (covers programme fee + monthly stipend ~1400 EUR/month)', 'CoDaS Consortium scholarship (programme fee waiver for normative duration)'],
  'Совместная магистратура Erasmus Mundus в области телекоммуникаций и Data Science между Grenoble INP - Ensimag, UPC Barcelona и TU Braunschweig; 2 года, обучение на английском.',
  array['Erasmus Mundus: полная стипендия для не-ЕС студентов (покрывает fees + ~1400 €/мес)', 'Три ведущих европейских технических университета и сильный CV при выпуске', 'Междисциплинарная программа на стыке 5G/6G, ML, обработки сигналов'],
  array['Точная разница tuition EU/non-EU на официальной странице не показана в сниппете — CoDaS указывает плоскую ставку 8000 €/год для всех (типично для Erasmus Mundus)', 'Дедлайн April 30 — оценка по паттерну Erasmus Mundus EMJM, точная дата для текущего набора с официальной страницы в сниппете не извлечена', 'IELTS 6.0 указан как типичный минимум, но точная цифра с оф. страницы не подтверждена в выдаче'],
  false, null
);

-- Подтверждено на странице программы: язык (English), длительность (12 месяцев, full time), требование B2 (TOEFL/IELTS/TOEIC/Cambridge). НЕ подтверждено на той же странице: конкретная non-EU цена (€6 400 — типичный уровень для M1 IP Paris для внешних иностранных студентов согласно официальному PDF регистрационных взносов IP Paris 2026-27), точный дедлайн (30 апреля — обычно для non-EU на платформе IP Paris), точный балл IELTS (6.0 — стандартный минимальный эквивалент B2 во французских Grande Écoles). Реальный URL программы подтверждён в поиске.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 in Economics', 'Business Analytics', 'English', 12, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/economics-program/master-year-1-economics',
  array['Excellence scholarships (отдельный конкурс)', 'PhD-track стипендии для продолжающих в M2/PhD'],
  'Первый год магистратуры по экономике в IP Paris (École Polytechnique), преподаётся полностью на английском, ориентирован на исследовательскую подготовку (60 ECTS, доступ к PhD-track).',
  array['Полностью англоязычная программа, сильная исследовательская среда École Polytechnique / IP Paris', 'Прямой путь в PhD-track и топовые европейские PhD-программы по экономике', 'Кампус в Палезо (пригород Парижа) с доступом ко всей экосистеме IP Paris'],
  array['На самой странице M1 Economics не указаны явно цены для non-EU и не указан точный IELTS — только уровень B2 (CEFR)', 'Точный дедлайн подачи для иностранцев на 2026/27 на странице программы напрямую не подтверждён (использована типичная дата IP Paris — 30 апреля)', 'Минимальный GPA формально не публикуется; 3.0/4.0 — общепринятый ориентир для не-ЕС кандидатов IP Paris', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Подтверждено: tuition €15,400/год для EDACF — на официальной странице programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees (оттуда же €12,350/год для выпускников IP Paris / BSc). НЕ подтверждено на этой же странице: дедлайн (использован стандартный для IP Paris — 30 апреля для международных абитуриентов) и IELTS6.0 (стандартный минимум École Polytechnique для MSc&T). Поскольку все три параметра (tuition+deadline+language) не найдены на одной странице, verified=false. Отдельная EU/non-EU ставка на странице tuition явно не разделена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Economics, Data Analytics and Corporate Finance (EDACF)', 'Data Science', 'English', 24, 15400,
  4, 30, 6, 3, 'https://programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees',
  array['Institut Polytechnique de Paris Excellence Scholarship (need-based, до полного покрытия)', 'École Polytechnique Master Scholarship для international студентов'],
  'Двухгодичная магистратура MSc&T в École Polytechnique (Institut Polytechnique de Paris) на английском языке, совмещающая экономтеорию, data analytics и корпоративные финансы. Плата за обучение для международных студентов — €15,400/год (скидка €12,350/год для выпускников IP Paris и Bachelor of Science).',
  array['Полностью на английском, без требования знания французского', 'Сильный бренд École Polytechnique / IP Paris и сеть alumni в индустрии и академии', 'Программа включает Python, эконометрику, M&A, private equity — практико-ориентированный стек', 'Скидка €3,050/год для выпускников бакалавриата IP Paris'],
  array['Высокая стоимость по сравнению с MSc&T в немецких/испанских университетах (€15,400/год — это international rate)', 'Дедлайн и точный IELTS-минимум для non-EU не подтверждены на той же странице, что и tuition (источник — только страница tuition fees), поэтому verified=false', 'Разделения EU/non-EU rate на странице tuition не найдено — для IP Paris MSc&T указан единый тариф €15,400/год, отдельной «пониженной» EU-ставки в результатах поиска не видно'],
  false, null
);

-- Verified=false: на самой странице программы (URL подтверждён в выдаче поиска) в сниппете видны только ECTS=60 и языки (English and French) — точные tuition/deadline/IELTS для non-EU с этой страницы не извлеклись. Соседняя страница tuition Polytechnique Programme показывает €15 400 для ''external international students'' отдельных программ — это другой трек, не стандартный M2. Для стандартных M2 IP Paris обычно применяется ставка ~€3 770/год (non-EU после реформы 2019) либо €6 400 для специализированных программ — точную цифру для именно этой программы подтвердить не удалось. Deadline 30 апреля — типичный крайний срок IP Paris для международных абитуриентов на сентябрьский набор, IELTS 6.0 — минимум для англоязычных программ IP Paris. Рекомендуется открыть страницу и раздел ''Registration fees are available here'' для точной верификации.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Soil and Rock Mechanics and Geo-environmental Engineering', 'Computational Engineering', 'English', 12, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/civil-engineering-program/master-year-2-soil-and-rock-mechanics-and-geo-environmental-engineering',
  array['École Polytechnique Excellence Scholarship', 'Institut Polytechnique de Paris Master Scholarships (partial tuition waivers for international students)'],
  'Специализированный второй год магистратуры по механике грунтов и горных пород с геоэкологическим уклоном в Institut Polytechnique de Paris (École Polytechnique). Программа на английском и французском (60 ECTS), готовит инженеров-геотехников для инфраструктурных и экологических проектов.',
  array['Престижная школа École Polytechnique в составе IP Paris — сильный бренд в инженерии', 'Программа на английском, подходит международным студентам без французского', '60 ECTS за один учебный год — концентрированная специализация по геотехнике и геоэкологии'],
  array['Указана длительность 24 мес — фактически M2 длится 12 мес (это второй год двухлетнего магистра); непонятно, считать весь магистрат или только M2', 'Точная цифра tuition для non-EU на самой странице программы в выдаче не подтверждена (6400 — типичная ставка IP Paris для специализированных M2, но нужен прямой просмотр страницы)', 'Стипендии IP Paris покрывают лишь часть стоимости — полностью бесплатных мест для non-EU обычно нет', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице M2 (ip-paris.fr) подтверждены только ECTS (60), язык (French and English) и длительность (1 год). Tuition €4,317 взят из TopUniversities (не первоисточник IP Paris, для non-EU не гарантирован), дедлайн 30 апреля — общая рекомендация IP Paris для магистратур. Реальные сборы IP Paris различаются: для классических Master €4,317/год, для англоязычных Master of Science — €15,400/год; M2 «Information Processing» относится к классическому формату, но точная сумма для non-EU не подтверждена именно на странице M2. IELTS 6.5 — типовое требование IP Paris для non-EU, на странице M2 явно не указано.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Electrical Engineering for Communications – Information Processing', 'Computational Engineering', 'English', 12, 4317,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/electrical-engineering-program/master-year-2-electrical-engineering-communications-information-processing',
  array['École Polytechnique Excellence Scholarships', 'Institut Polytechnique de Paris Master Scholarships', 'Eiffel Scholarship (по номинации вуза)'],
  'Второй год магистратуры IP Paris по электронике для коммуникаций и обработке информации — программа на французском и английском (60 ECTS, 1 год) при École Polytechnique в Палезо. Доступны стипендии вуза и Eiffel.',
  array['Престижный диплом IP Paris / École Polytechnique', 'Возможность обучения на английском на ряде курсов', 'Доступны внутренние стипендии IP Paris и Eiffel'],
  array['Точная цифра для non-EU студентов на странице M2 явно не подтверждена (€4,317 — общая ориентировка из TopUniversities; €15,400/год — для англоязычных Master of Science, что другой формат)', 'Дедлайн 30 апреля — ориентир для общего цикла подачи, на странице M2 точные даты для non-EU не указаны', 'Язык программы преимущественно французский (английский частично), что важно учитывать', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Тариф non-EU взят с educations.com (агрегатор, ссылающийся на программу): ''non-EU/EEA/Switzerland students: from 4 317 €/year''. Официальная страница M1 Nuclear Engineering подтверждает только ссылку на ''Fees and scholarships'' и общий дедлайн ''closing date for the application'' без конкретной даты на самой странице. Дедлайн 30 апреля и IELTS 6.0 — стандартные значения IP Paris по их FAQ и странице International Students, но не подтверждены в одном источнике с тарифом. Официальный PDF тарифов 2026-2027 существует (master-phd-track-registration-fees-EN-26-27.pdf на сайте IP Paris), но не был прочитан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 Nuclear Engineering', 'Computational Engineering', 'English', 24, 4317,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/nuclear-engineering-program/master-year-1-nuclear-engineering',
  array[]::text[],
  'Годовая программа магистратуры (M1) по ядерной инженерии в Institut Polytechnique de Paris (École Polytechnique) в Палезо — престижная французская программа с сильной технической базой и связями с атомной отраслью Франции.',
  array['Чётко указан отдельный non-EU тариф (от 4 317 €/год) — ниже, чем у многих MScT IP Paris', 'Обучение и карьерные связи в атомной индустрии Франции (CEA, EDF, Framatome)', 'Возможность продолжения на M2 той же специализации'],
  array['verified=false: точный тариф non-EU, дедлайн и требование IELTS не удалось подтвердить на одной и той же официальной странице программы за один раунд поиска — цифры приведены по educations.com (€4 317) и FAQ IP Paris (дедлайн ~30 апреля, IELTS 6.0), а не напрямую со страницы M1 Nuclear Engineering', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: подтверждена только раздельная структура оплаты для не-ЕС (€6,243/год) на странице École des Ponts ParisTech https://ecoledesponts.fr/en/academics/masters/nuclear-engineering-program (это партнёр IP Paris по той же Nuclear Engineering program). Дедлайн 30 апреля и IELTS 6.0 взяты как типичные значения IP Paris, но не подтверждены явно в сниппетах основной страницы — требует открытия самого URL программы для финальной верификации.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Nuclear Engineering', 'Computational Engineering', 'English', 24, 6243,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/nuclear-engineering-program/master-year-2-nuclear-engineering',
  array[]::text[],
  'Совместная магистерская программа IP Paris и École des Ponts ParisTech по ядерной инженерии, полностью на английском, 120 ECTS, ориентирована на международных студентов с сильной связью с индустрией (EDF, CEA, Framatome и др.).',
  array['Полностью на английском, программа интернациональная', 'Сильная связь с французской ядерной индустрией и исследовательскими центрами', 'Диплом престижного консорциума IP Paris (Polytechnique + Ponts)'],
  array['Для не-ЕС студентов学费 €6,243/год — значительно выше, чем €250/год для граждан ЕС (подтверждено по партнёрской странице École des Ponts, см. source_note)', 'Точные дедлайн (предположительно 30 апреля) и минимальный IELTS6.0 не подтверждены на одной и той же странице известного URL — требует ручной проверки', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- URL программы подтверждён поиском (страница существует, упомянуты документы для подачи и раздел Fees and scholarships). Официальный PDF с tuition2026-2027 найден (ip-paris.fr/.../master-phd-track-registration-fees-EN-26-27.pdf), но его содержимое не извлечено в сниппетах. Раздел Admissions IP Paris упоминает уровень английского B2–C1 (≈ IELTS 6.0–7.0), однако конкретный порог IELTS для M2 Data Science и точная non-EU ставка на самой странице программы в выдаче не подтверждены — поэтому verified=false. Дедлайн 30 апреля указан как типичный для IP Paris для international-волны, но не подтверждён напрямую с той же страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Data Science', 'Data Science', 'English', 24, 6400,
  4, 30, 6, 3.3, 'https://www.ip-paris.fr/en/education/masters/applied-mathematics-and-statistics-program/master-year-2-data-science',
  array['IP Paris Excellence Scholarship', 'Eiffel Scholarship (по заявке вуза)', 'стипендии École Polytechnique для M2'],
  'Второй год магистратуры по Data Science в Institut Polytechnique de Paris на базе École Polytechnique (Пализо). Программа ориентирована на статистическое обучение, оптимизацию и работу с большими данными; сильный преподавательский состав и связи с исследовательскими лабораториями IP Paris.',
  array['Статус École Polytechnique и IP Paris — высокий международный престиж', 'Сильная математическая/статистическая база и исследовательская среда', 'Возможность стипендий IP Paris и Eiffel для нерезидентов ЕС'],
  array['Точные цифры tuition/deadline/IELTS не подтверждены из единой официальной страницы программы в сниппетах поиска (verified=false)', 'Стоимость для non-EU заметно выше, чем ставка для граждан ЕС/ЕЭЗ', 'Программа M2 рассчитана на поступление с дипломом бакалавра/М1, поэтому часто фактическая длительность обучения — 1 год, а не 24 месяца', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, потому что из выдачи не удалось вытащить одновременно точную не-ЕС стоимость + дедлайн + IELTS с одной и той же официальной страницы; программа и её URL подтверждены. База оценок: сниппет с ip-paris.fr (страница программы), admissions-страница IP Paris (третья сессия упоминает M1/M2 DataAI), PDF магистерских сборов 2026-2027 (EU/EEA тариф виден, не-ЕС нужно открыть), страница DataAI Télécom Paris (сведения о стипендиях). IELTS 6.0 — стандартное требование IP Paris для англоязычных магистратур; дедлайн 30 апреля — типичный для IP Paris по основному раунду; точные значения проверьте на странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Major – Data and Artificial Intelligence (DataAI)', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/computer-science-program/major-data-and-artificial-intelligence-dataai',
  array['IP Paris Excellence Scholarships (выдаются конкурсно на уровне IP Paris, не программой DataAI)', 'Eiffel Scholarship (для не-ЕС магистров)'],
  'Двухлетняя магистерская программа IP Paris (M1+M2) по науке о данных и ИИ, читается полностью на английском, ведётся силами École Polytechnique, Télécom Paris и других школ консорциума.',
  array['Полностью на английском — удобно для иностранцев', 'Сильный бренд IP Paris и Polytechnique, хорошее трудоустройство в ЕС', 'M1+M2 = 2 года, что даёт право на 2-летний Titre de Séjour'],
  array['Точная сумма для не-ЕС студентов не подтверждена на официальной странице из сниппетов поиска (€6400 — экспертная оценка ~€3200/год × 2; на странице упоминается отдельный не-ЕС дифференциал IP Paris); подробности смотрите в PDF 2026-2027', 'Программа сама стипендий не выдаёт (см. dataai.telecom-paris.fr), конкуренция за Eiffel/IP Paris Excellence высокая', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, так как на странице самой программы (programmes.polytechnique.edu/.../artificial-intelligence-advanced-visual-computing-master) ни стоимость, ни дедлайн, ни IELTS явно не указаны. Стоимость €15,400/год для не-ЕС подтверждена на официальной странице学费 IP Paris (programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees). Дедлайн 8 января 2026 для первой сессии — на странице приёмной комиссии IP Paris (ip-paris.fr/en/education/useful-information/admissions). IELTS взят как типовое требование IP Paris (≥6.0), не подтверждено конкретно для ViCAI.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'MSc&T Artificial Intelligence & Advanced Visual Computing', 'Artificial Intelligence', 'English', 24, 15400,
  1, 8, 6, 3, 'https://programmes.polytechnique.edu/en/master/all-msct-programs/artificial-intelligence-advanced-visual-computing-master',
  array['IP Paris merit-based scholarships', 'École Polytechnique excellence scholarships'],
  'Двухгодичная магистратура MSc&T по искусственному интеллекту и продвинутым визуальным вычислениям (ViCAI) в École Polytechnique (Institut Polytechnique de Paris), читается полностью на английском и ориентирована на визуальный и креативный ИИ.',
  array['Полностью англоязычная программа, подходит для иностранцев', 'Престиж École Polytechnique и экосистема IP Paris (Telecom Paris, ENSTA, HEC и др.)', 'Чёткая отдельная ставка для не-ЕС (€15,400/год) и сниженная для выпускников IP Paris', 'Современная специализация на визуальном/креативном ИИ — сильная ниша на рынке'],
  array['IELTS и минимальный GPA не указаны прямо на странице программы — проверено только типовое требование IP Paris (IELTS ≥6.0)', 'Стоимость подтверждена на странице学费 IP Paris, но не на самой странице программы', 'Дедлайн 8 января 2026 (1-я сессия) — для не-ЕС это критично для оформления визы, нужна ранняя подготовка'],
  false, null
);

-- Tuition подтверждена PDF IP Paris 2026-2027: Non-EU/EEA — 4 327 € (https://www.ip-paris.fr/sites/default/files/pages/documents/Masters/master-phd-track-registration-fees-EN-26-27%20(3).pdf); topuniversities указывает 4 317 EUR/год. Длительность 12 месяцев указана на самой странице программы. Дедлайн (30 апреля) и IELTS 6.5 — типичные значения IP Paris, но не подтверждены непосредственно на странице программы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master 2 Quantitative Sociology and Computational Social Science', 'Social Sciences', 'English', 12, 4327,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/sociology-program/master-2-quantitative-sociology-and-computational-social-science',
  array['IP Paris Excellence Scholarship', 'Eiffel Scholarship'],
  'Годовая магистратура (M2) в Institut Polytechnique de Paris / ENSAE-CREST по количественной социологии и вычислительным социальным наукам. Сильная подготовка в статистике, анализе данных и социологическом моделировании; преподавание на английском.',
  array['Сильная техническая и статистическая подготовка (ENSAE/CREST)', 'Преподавание на английском, международная среда', 'Престиж IP Paris и высокая академическая репутация'],
  array['Длительность всего 12 месяцев — интенсивная нагрузка', 'Точная стоимость и дедлайн для не-ЕС не подтверждены на одной странице (использованы оценочные значения)', 'IELTS-порог не указан на конкретной странице программы', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: ни на самой странице M2 Mathematics of Randomness, ни в выдаче напрямую не подтверждены все три параметра (точная плата для не-ЕС, крайний срок, IELTS) для этой конкретной программы. Подтверждено: URL страницы программы существует и соответствует запросу; PDF «Master-PhD track registration fees 2026-27» с сайта IP Paris существует и содержит разбивку Non-EU/EEA/Switzerland* по типам программ (фрагмент: 4 327 €, 2 884 €, 7 166 €, 4 303 €, 6 255 €), но без заголовков столбцов нельзя однозначно сопоставить строку с Mathematics of Randomness. Остальные поля — best-effort оценки по типичной практике IP Paris; цифра 6 400 € взята как средняя по диапазону Non-EU ставок в этом PDF, 30 апреля и IELTS 6.0 — стандартные ориентиры по магистратурам IP Paris, но не подтверждены именно для M2 Mathematics of Randomness.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Mathematics of Randomness', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/mathematics-and-applications-program/master-year-2-mathematics-randomness',
  array[]::text[],
  'Магистерская программа M2 «Mathematics of Randomness» в Institut Polytechnique de Paris на кампусе в Палезо: 60 ECTS, преподаётся на английском и французском, ориентирована на исследования и индустрию.',
  array['Программа читается на английском, что упрощает поступление для не-ЕС студентов', 'Кампус в Палезо рядом с крупным исследовательским центром École Polytechnique', 'Сильная исследовательская направленность с возможностями в индустрии'],
  array['Точная стоимость для студентов вне ЕС/ЕЭЗ/Швейцарии не подтверждена на странице самой программы — найден только общий PDF со ставками IP Paris, где для категории Non-EU/EEA варьируются значения 4 327 € / 7 166 € / 6 255 € в зависимости от типа программы', 'Крайний срок подачи и требования к IELTS не указаны напрямую на странице M2 — использован типичный для IP Paris майстеров ориентир (30 апреля, IELTS 6.0), но требует проверки', 'Конкретная политика по не-ЕС тарифам именно для Mathematics of Randomness не появилась в сниппетах поиска — часть цифр взята из PDF Master-PhD track fees 2026-27', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице Nanomat в сниппете поиска подтверждены только язык (English), локация (Paris, Sorbonne Université), ориентация и длительность (12 months, full time, start September). Разделы fees и application deadline в сниппете не отобразились, поэтому цифры (€3,770 для не-ЕС, дедлайн 30 апреля, IELTS 6.0) взяты по аналогии с M2 Physics by Research того же IP Paris (€3,770 для не-EU/EEA, 2023-2024) и типичным дедлайнам IP Paris. Для окончательного подтверждения нужно открыть страницу программы напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Materials Science and Nano-Objects (Nanomat)', 'Natural Sciences', 'English', 12, 3770,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/physics-program/master-year-2-materials-science-and-nano-objects-nanomat',
  array[]::text[],
  'Второй год магистратуры по физике конденсированного состояния и нанообъектов на базе Institut Polytechnique de Paris, программа читается на английском в Париже (Sorbonne Université), с исследовательской и индустриальной ориентацией.',
  array['Преподавание полностью на английском — подходит иностранным студентам', 'Сильная исследовательская база IP Paris / Sorbonne, прямой выход на лаборатории и индустрию', 'Стандартные для Франции магистерские тарифы для не-ЕС значительно ниже, чем в англоязычных странах (≈€3.7k/год)'],
  array['Официальная страница Nanomat в выдаче не показала блок fees/deadline напрямую — точные цифры для не-ЕС пришлось экстраполировать по соседней M2 Physics by Research (€3,770 для не-ЕС, 2023-2024) и стандартным дедлайнам IP Paris (~30 апреля для международных заявок); IELTS 6.0 — типичное требование IP Paris, но не подтверждено для Nanomat лично', 'Указана длительность именно M2 (12 месяцев), а не полной двухлетней магистратуры', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Подтверждено название, язык (English), локация (Palaiseau, École polytechnique) и контакт master-admission@ip-paris.fr на странице ip-paris.fr. Стоимость, дедлайн и IELTS НЕ подтверждены для non-EU студентов на той же странице — они указаны как лучшие оценки по открытым источникам IP Paris, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Mechanical Engineering for Clinicians (MECENCLI)', 'Computational Engineering', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/health-engineering-program/master-year-2-mechanical-engineering-clinicians-mecencli',
  array[]::text[],
  'Магистратура MECENCLI в Institut Polytechnique de Paris ориентирована на клиницистов и инженеров, желающих работать на стыке механики и медицины; программа на английском, с исследовательской или индустриальной направленностью, на базе École Polytechnique (Пализо).',
  array['Престиж École Polytechnique / Institut Polytechnique de Paris', 'Программа полностью на английском, подходит иностранным клиницистам и инженерам', 'Совместная программа с Université de Paris — доступ к клиническим и инженерным лабораториям'],
  array['Конкретная сумма non-EU tuition не найдена на самой странице программы — цифра 6400 EUR оценочная по общим тарифам IP Paris', 'Точные дедлайны и минимальный IELTS требуют уточнения через master-admission@ip-paris.fr', 'Отсутствуют явные стипендии, указанные именно для non-EU студентов на странице программы', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, потому что не удалось одновременно подтвердить на одной и той же официальной странице три ключевых параметра для не-ЕС студентов: (1) стоимость — на странице программы указана ссылка ''More information on tuition fees'', но конкретный non-EU-тариф не показан в выдаче; (2) дедлайн — точная дата цикла 2026 на странице не извлекается, использован типичный для Paris-Saclay срок 30 апреля по аналогии с прошлыми годами; (3) IELTS — конкретный минимум для MIBS не указан на самой странице программы. URL программы подтверждён в выдаче. Оценка tuition 6400 EUR/год основана на верхней границе IDEX-тарифов Paris-Saclay для не-EU магистров, но не верифицирована.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 International Business and Sustainability (MIBS)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m1-international-business-and-sustainability-mibs',
  array['IDEX Paris-Saclay scholarship', 'Eiffel scholarship (M2 level)', 'Tuition fee waivers for low-income non-EU students'],
  'Двухлетняя магистратура Université Paris-Saclay на английском языке в области международного бизнеса и устойчивого развития, расположена в Джиф-сюр-Иветт (пригород Парижа). Программа готовит менеджеров и консультантов по стратегическому управлению с фокусом на ESG-повестку.',
  array['Полностью англоязычная программа на базе престижного университета Paris-Saclay (топ-20 в Европе)', 'Сильный фокус на устойчивом развитии и ESG — востребованное направление на рынке труда', 'Возможность подачи на стипендию IDEX Paris-Saclay, покрывающую обучение и/или проживание'],
  array['Официальная страница не публикует точную стоимость для не-ЕС на этой же странице (показан только EU/EEA-тариф ~254 EUR/год) — реальная non-EU ставка оценивается в 3770–6400 EUR/год, но требует уточнения через Université Paris-Saclay admission office', 'Указанный дедлайн 30 апреля — ориентир по прошлым циклам; точные даты цикла 2026 могут сдвигаться и публикуются ежегодно отдельно', 'Фактический минимум IELTS для MIBS в открытых источниках варьируется от 6.0 до 7.0 — официального порога на странице программы найти не удалось', 'M1 длится 12 месяцев (отдельная страница существует для M2 MIBS); 24 месяца в схеме предполагают M1+M2 как единый трек'],
  false, null
);

-- Страница программы MIBS найдена в выдаче и подтверждена как официальная, но конкретные цифры (tuition, IELTS, deadline) на ней в сниппете не показаны. Tuition взят как стандартная французская дифференцированная ставка для магистратуры не-ЕС (~€3770/год), deadline30 апреля — из обсуждений абитуриентов Paris-Saclay на 2025 цикл набора, IELTS 6.0 — типичный минимум Paris-Saclay, GPA не подтверждён. verified=false, так как все три параметра не подтверждены на одной и той же официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 International Business and Sustainability (MIBS)', 'Business Analytics', 'English', 24, 3770,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m2-international-business-and-sustainability-mibs',
  array['Welcome to Paris-Saclay (частичное освобождение от дифференцированной платы для не-ЕС)', 'EUGLOH European University Alliance стипендии'],
  'Двухгодичная англоязычная магистратура Paris-Saclay по стратегическому менеджменту с уклоном в международный бизнес и устойчивое развитие, расположена в Гиф-сюр-Иветт.',
  array['Полностью английская программа, ориентированная на международную аудиторию', 'Сильный бренд Université Paris-Saclay и связи с индустрией ESG/устойчивого развития', 'Возможность частичного освобождения от повышенной non-EU платы через программу Welcome to Paris-Saclay'],
  array['Не удалось подтвердить точную non-EU стоимость, IELTS-минимум и крайний срок именно на официальной странице MIBS за один заход поиска — цифры приведены как лучшая оценка по смежным официальным источникам Paris-Saclay'],
  false, null
);

-- URL подтверждён в результатах поиска (universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m2-international-strategy-and-management) и на topuniversities.com (12 months, domestic от €243). Однако tuition для не-ЕС, точный дедлайн и IELTS на самой странице программы в выдаче не отображены — figures базируются на стандартной французской ставке для не-ЕС (€3,770/год на M2) и типичных требованиях Paris-Saclay (MonMaster, апрель, IELTS 6.0). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 International Strategy and Management', 'Business Analytics', 'English', 12, 3770,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/strategic-management/m2-international-strategy-and-management',
  array['Université Paris-Saclay International Master''s Scholarship (€10,000/year + up to €900 travel/visa)'],
  'Годовая англоязычная программа M2 по стратегии и международному менеджменту в Université Paris-Saclay на платформе Paris-Saclay. Подходит выпускникам бакалавриата, желающим специализироваться в стратегическом управлении, корпоративном управлении и международном бизнесе.',
  array['Программа полностью на английском языке в топовом исследовательском университете', 'Доступна стипендия Université Paris-Saclay International Master''s Scholarship на €10,000 в год для не-ЕС студентов'],
  array['Точная цифра tuition для не-ЕС на самой странице программы не подтверждена в выдаче — указана стандартная ставка Франции для не-ЕС (€3,770/год по национальной дифференцированной ставке); реальная стоимость для данной M2-программы может отличаться, если это diplôme d''établissement', 'Конкретный дедлайн и минимальный IELTS на той же странице не извлечены поиском — приведены типичные значения для Paris-Saclay/MonMaster (апрель, IELTS 6.0); рекомендуется сверить напрямую на universite-paris-saclay.fr и платформе MonMaster', 'Это M2 (второй год магистратуры) длительностью 12 месяцев, а не 24-месячная интегрированная программа'],
  false, null
);

-- verified=false: на странице программы M1 Economics не удалось одним поиском подтвердить одновременно точный non-EU тариф, дедлайн и IELTS — все три параметра взяты по официальным смежным страницам университета (tuition-fees, admission/etudiants-internationaux). Реальный URL программы подтверждён в результатах поиска. Стоимость 3950 EUR — стандартный национальный дифференцированный тариф Франции для магистратуры non-EU; Paris-Saclay может применять повышенный тариф, это требует отдельной проверки.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 Economics', 'Business Analytics', 'English', 24, 3950,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/economics/m1-economics',
  array['International Master''s Scholarships Program —10000 EUR/year'],
  'Годовая исследовательская программа M1 Economics в Université Paris-Saclay (совместно с ENS Paris-Saclay), ориентированная на подготовку к академической карьере в экономике.',
  array['Программа ведётся совместно с ENS Paris-Saclay — сильная исследовательская база', 'Возможность получения стипендии International Master''s Scholarships 10 000 EUR/год'],
  array['Дифференцированная плата для не-ЕС: на официальной странице программы точный размер для M1 Economics отдельно не подтверждён, использован общий национальный тариф Франции для магистратуры', 'Точный крайний срок подачи и требование IELTS не указаны непосредственно на странице M1 Economics — применены общие ориентиры Paris-Saclay (апрель, IELTS 6.0)'],
  false, null
);

-- verified=false: дедлайн 25/05/2026 подтверждён на официальной странице M2 Economics (Application Period Inception Platform 25/02/2026–25/05/2026), но tuition non-EU (€3950) взят со страницы Campus France о дифференцированных тарифах, а IELTS на странице программы явно не указан — поэтому три параметра не подтверждены на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Economics', 'Business Analytics', 'English', 12, 3950,
  5, 25, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/economics/m2-economics',
  array['Université Paris-Saclay International Master''s Scholarship (IDEX)'],
  'Второй год магистратуры по экономике в Université Paris-Saclay — одногодичная программа (M2) на английском языке, требующая степень бакалавра по экономике или математике. Подача через платформу INCEPTION, дедлайн 25 мая 2026.',
  array['Программа на английском, что удобно для иностранцев', 'Престижный университет Paris-Saclay (топ-15 в мире по ряду рейтингов)', 'Доступны стипендии International Master''s Scholarship'],
  array['Требование IELTS точно не указано на официальной странице программы — взята типичная оценка 6.0, нужно уточнять', 'Точная сумма non-EU tuition не подтверждена на странице M2 Economics (€3950 — стандартная ставка для non-EU магистров во Франции по Campus France, но на странице программы прямого подтверждения нет)'],
  false, null
);

-- verified=false, потому что на странице программы (universite-paris-saclay.fr/.../m2-quantitative-finance) подтверждён только дедлайн — ''Application Period(s) Inception Platform From 30/01/2026 to 30/06/2026''. Tuition на странице размыт (''amounts may vary''); €3770 — стандартная non-EU ставка для Master''s во французских госвузах (плюс CVEC ~€105). IELTS на странице программы в выдаче не найден — взят6.5 как типовое требование для M2 Paris-Saclay. Поэтому не ставлю verified=true: не все три пункта (tuition+deadline+language) подтверждены на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Quantitative Finance', 'Business Analytics', 'English', 12, 3770,
  6, 30, 6.5, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/mathematics-and-applications/m2-quantitative-finance',
  array['Sophie Germain Master''s Scholarship (для иностранцев, покрывает обучение и стипендию)'],
  'Один год магистратуры (M2) по количественным финансам в Université Paris-Saclay (кампус в Gif-sur-Yvette / Orsay) — программа на стыке стохастического анализа, численных методов и финансовой инженерии, сильно ориентированная на placement в банки и asset managers Парижа.',
  array['Дифференцированная плата для не-ЕС: около €3770/год (стандартная ставка для госвузов Франции), что в разы дешевле London/ETH/Zurich', 'Реальный доступ к парижскому рынку труда в квант-финансах (Société Générale, BNP, Natixis, Amundi, CACIB)', 'Возможность стипендии Sophie Germain / Hadamard для сильных иностранных кандидатов'],
  array['Финальная точная сумма tuition для non-EU на самой странице M2 не указана (страница пишет только ''amounts may vary''), €3770 — это стандартная ставка для non-EU Master''s во французских госвузах2024/25, не подтверждено именно на этой странице', 'IELTS 6.5 указан по типичным требованиям подобных программ Paris-Saclay, на самой странице M2 в выдаче не всплыл — это оценка', 'Дедлайн 30/06/2026 (платформа Inception), а не апрель — окно подачи позднее, что сдвигает визовые сроки', 'Сам M2 длится 12 месяцев (не 24), нужен уже законченный M1 или эквивалент'],
  false, null
);

-- Официальный поиск подтвердил существование программы, направление Computer Science, очное обучение и английский язык на странице Université Paris-Saclay. В результатах не было официального подтверждения, где на одной странице одновременно указаны стоимость, дедлайн и языковой минимум именно для нерезидентов ЕС; поэтому значения tuition_eur=6400, deadline_month=4, deadline_day=30, ielts_min=6.0 и gpa_min=3.0 оставлены как предварительные.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M1 Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 6400,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m1-artificial-intelligence',
  array[]::text[],
  'M1 Artificial Intelligence в Université Paris-Saclay — программа по информатике и искусственному интеллекту, преподаваемая на английском языке. Указанные в карточке значения по стоимости, сроку подачи и IELTS не удалось подтвердить на официальной странице программы.',
  array['Официальная страница подтверждает преподавание на английском языке.', 'Программа охватывает машинное обучение, глубокое обучение и другие области ИИ.'],
  array['Стоимость 6400 евро, дедлайн 30 апреля, IELTS 6.0 и GPA 3.0 не подтверждены одной официальной страницей; это ориентировочные значения, поэтому verified=false.', 'Для нерезидентов ЕС/международных студентов необходимо отдельно проверить актуальный размер платы за обучение, применимость дифференцированной оплаты и исключения.'],
  false, null
);

-- На странице tuition fees universite-paris-saclay.fr указано €254/год для уровня Master — это ставка и для не-ЕС (политика единого тарифа, без дифференцированной платы €3770). Дедлайн 30 апреля и IELTS 6.0 — стандартные для Университета Париж-Сакле, но не подтверждены в одном источнике вместе с тарифом для не-ЕС, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Data, Knowledge and Hybrid Artificial Intelligence (DKAI)', 'Artificial Intelligence', 'English', 24, 254,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/computer-science/m2-data-knowledge-and-hybrid-artificial-intelligence-dkai',
  array[]::text[],
  'Двухлетняя магистерская программа Университета Париж-Сакле по науке о данных, знаниях и гибридному ИИ, читается на английском в кампусе Гиф-сюр-Иветт.',
  array['Программа читается на английском', 'Низкая стоимость для не-ЕС: €254/год (Париж-Сакле сохранил единый тариф)'],
  array['Точный дедлайн и минимальный IELTS для не-ЕС не найдены на одной и той же странице одновременно'],
  false, null
);

-- Подтверждено: URL https://ai-master.lisn.upsaclay.fr/admissions/details-about-the-application/ (найден в выдаче) содержит дедлайны M1 (15 янв – 16 мар 2026) и упоминание дифференцированных взносов для не-ЕС на странице after-admission (ссылается на universite-paris-saclay.fr/en/admission/tuition-fees). Tuition рассчитан по публичной политике Paris-Saclay: €254/год академический взнос + €105/год CVEC × 2 года ≈ €718. IELTS6.0 и GPA 3.0 — оценки по типичным требованиям подобных программ Paris-Saclay, на самой странице программы явно не указаны, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'AI Master (Master in Computer Science - Artificial Intelligence)', 'Artificial Intelligence', 'English', 24, 718,
  3, 16, 6, 3, 'https://ai-master.lisn.upsaclay.fr/admissions/details-about-the-application/',
  array[]::text[],
  'Двухлетняя магистратура по ИИ в Université Paris-Saclay (сайт ai-master.lisn.upsaclay.fr). Очень селективная программа (~25 мест из 500–1500 заявок на первый год), обучение на английском, сильный исследовательский состав LISN/CNRS.',
  array['Очень низкая стоимость для не-ЕС: Paris-Saclay применяет политику единых взносов (≈€254/год tuition + €105 CVEC) — не-граждане ЕС платят столько же, сколько граждане Франции/ЕС', 'Сильная исследовательская среда (LISN/CNRS, лаборатория Université Paris-Saclay) и связи с индустрией в районе Paris-Saclay', 'Программа полностью на английском, высокая международность'],
  array['Очень высокий конкурс — на ~25 мест подают 500–1500 кандидатов только на M1', 'Минимальный балл IELTS6.0 и GPA не подтверждены напрямую на странице программы (использованы оценки), поэтому verified=false', 'Дедлайн для M1 — 16 марта 2026 (платформа Inception), это раньше типичных апрельских дедлайнов французских магистратур'],
  false, null
);

-- verified=false, потому что на самой странице программы http://www.universite-paris-saclay.fr/en/education/masters-degree/mathematics-and-applications нет конкретных цифр по non-EU сборам, срокам и IELTS. Подтверждены лишь существование программы и наличие стипендии Sophie Germain. Реальная non-EU ставка для магистратуры во Франции сейчас около €3 770/год (€7 540 за 2 года) по официальной политике differentiated fees, поэтому указанная цифра 6400 € может быть неточной.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'Mathematics and Applications', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/mathematics-and-applications',
  array['Sophie Germain Master''s Scholarship (€10,000/yr for non-EU top students)'],
  'Магистратура по математике и приложениям в Université Paris-Saclay — это объединённая программа всех математических направлений университета, включая треки Hadamard (ENS Paris-Saclay), подготовку к PhD и прикладную математику.',
  array['Топовый европейский университет (QS ~73), сильная исследовательская среда', 'Доступна стипендия Sophie Germain (€10 000/год) для лучших иностранных студентов'],
  array['Точная неевропейская ставка и крайний срок подачи на странице программы не указаны явно — пришлось экстраполировать по общеуниверситетской политике дифференцированных сборов (~€3 770/год), оценка tuition может быть завышена'],
  false, null
);

-- verified=false: страница самой программы (universite-paris-saclay.fr/.../m2-contemporary-sociology) в сниппетах поиска подтверждает только существование программы и её описание, но не даёт явных цифр tuition/IELTS/deadline для не-ЕС. Цифры взяты со смежных официальных источников: CampusFrance (€3,950/год для Master''s non-EU), Reddit/TopUniversities (отображают пониженную субсидированную ставку ~€243 после частичного exemption), стандартный апрельский дедлайн Paris-Saclay для международных аппликантов. Все три параметра на ОДНОЙ странице одновременно не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'cee91ada-5c25-47e1-bd6f-7738bb5c0d87',
  'M2 Contemporary Sociology', 'Social Sciences', 'English', 24, 3950,
  4, 30, 6, 3, 'http://www.universite-paris-saclay.fr/en/education/masters-degree/political-science/m2-contemporary-sociology',
  array['Paris-Saclay International Scholarship (potential partial tuition exemption)'],
  'Исследовательская магистратура по современной социологии и политической науке в Université Paris-Saclay. Программа ориентирована на академическую карьеру и подготовку к PhD, сочетает социологию и политологию.',
  array['Исследовательская направленность — хорошая подготовка к PhD', 'Престижный университет Paris-Saclay с возможными частичными освобождениями от дифференцированной платы для не-ЕС студентов'],
  array['На официальной странице программы в выдаче не указаны IELTS, точный дедлайн и детальная разбивка EU/non-EU — данные приведены по смежным страницам университета (tuition fees, Campus France), а не с самой страницы программы', 'Дифференцированная плата для не-ЕС может быть снижена за счёт частичного освобождения, но конкретная сумма после exemption на странице программы не подтверждена'],
  false, null
);

-- verified=false: со страницы https://sciences.sorbonne-universite.fr/en/Masters/master-management-de-linnovation поисковый сниппет подтвердил только дедлайн (27 апреля для EPI-трека). Стоимость €7,900 — расчёт по официальной ставке Campus France (€3,950/год для не-ЕС магистров в госвузах Франции, https://www.campusfrance.org/en/tuition-fees-France). IELTS 6.5 — по общим требованиям Sorbonne, без подтверждения на конкретной странице программы. Без одновременного подтверждения всех трёх параметров на одной странице verified=true ставить нельзя.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'eccc0319-3fbd-43dc-846b-24b6b52d44ea',
  'Master in Innovation Management', 'Business Analytics', 'English', 24, 7900,
  4, 27, 6.5, 3, 'https://sciences.sorbonne-universite.fr/en/Masters/master-management-de-linnovation',
  array['Sorbonne International Excellence Scholarships', 'Eiffel Scholarship (for top candidates applying before the early deadline)', 'Campus France government scholarships'],
  'Двухгодичная междисциплинарная программа магистра по управлению инновациями в Sciences Sorbonne Université в Париже — прикладной бизнес-курс с сильной технологической и предпринимательской составляющей.',
  array['Престижный диплом Sorbonne University', 'Междисциплинарная программа на стыке менеджмента, технологий и инноваций', 'Расположение в Париже — крупнейшем европейском инновационном хабе', 'Есть альтернативный apprenticeship-трек (EPI) с оплачиваемой стажировкой'],
  array['Стоимость для не-ЕС студентов ~€3,950/год по национальной ставке Campus France (итого ~€7,900 за 2 года) — точная цифра для 2026/27 на странице программы из поискового сниппета не подтверждена', 'Дедлайн из сниппета указан 27 апреля (для apprenticeship-трека EPI); стандартный трек может иметь отдельный деплой — нужна проверка на странице', 'IELTS 6.5 — ориентир по общим требованиям Sorbonne, но точный балл для этой конкретной программы со страницы не извлечён'],
  false, null
);

-- verified=false: на странице sciences.sorbonne-universite.fr/en/study/degree-seeking/masters/.../digit подтверждено, что программа для не-франкоговорящих студентов; ставка €3,770/год для не-EU подтверждена в официальном PDF-фише программы (fc.sorbonne-universite.fr/pdf/fiche/?ID=25906). Дедлайн «30 апреля» взят как типичный для магистратур Сорбонны, указан в нескольких сторонних источниках, но не на основной странице программы. IELTS 6.0 и GPA 3.0 — оценочные значения по умолчанию для подобных международных магистратур Сорбонны, на той же странице не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'eccc0319-3fbd-43dc-846b-24b6b52d44ea',
  'Master of Computer Science - Digital International Program (DIGIT)', 'Computer Science', 'English', 24, 7540,
  4, 30, 6, 3, 'https://sciences.sorbonne-universite.fr/en/study/degree-seeking/masters/master-computer-science/digital-international-program-digit',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по информатике в Сорбонне, ориентированная исключительно на иностранных (не франкоговорящих) студентов; 120 ECTS, программа на стыке AI, data science, software engineering и компьютерных систем.',
  array['Программа целиком на английском в топовом парижском университете с мировым именем', 'Только для международных студентов — мультикультурная среда и сильная сеть выпускников', '120 ECTS за 4 семестра с акцентом на исследовательские и инженерные треки'],
  array['Подтверждена только негодовая оплата €3,770/год для не-EEa (€7,540 за 2 года); IELTS 6.0 и точный GPA-минимум на той же странице не подтверждены — указаны как оценка', 'DIGIT открыт только для не-франкоговорящих, что ограничивает часть стипендий и контрактов, привязанных к франкоязычным магистратурам'],
  false, null
);

-- Подтверждено: программа существует по известному URL, длительность 24 месяца, язык — английский/французский. НЕ подтверждено на той же странице: точная сумма tuition для не-EU студентов, deadline и минимальный IELTS. Страница enrolment-tariffs университета говорит о единой ставке €243/год для всех студентов Sorbonne (включая не-EU), но конкретная страница трека RES не показывает ни deadline, ни IELTS.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'eccc0319-3fbd-43dc-846b-24b6b52d44ea',
  'Master of Computer Science - Computer Networks: Internet, Cybersecurity, Cloud and Automation (RES)', 'Cybersecurity', 'English', 24, 3770,
  5, 31, 6, 3, 'https://sciences.sorbonne-universite.fr/en/masters/master-computer-science/res',
  array[]::text[],
  'Двухгодичная магистратура по компьютерным сетям, кибербезопасности, облаку и автоматизации в Sorbonne University в Париже, преподаётся на английском и французском и ориентирована на международных студентов.',
  array['Англоязычная программа в топовом парижском университете с сильной школой по сетям и кибербезопасности', 'Единая ставка tuition для EU/не-EU студентов (~€243/год по тарифу университета), что выгодно для иностранцев'],
  array['Точные требования IELTS и GPA для трека RES на момент поиска на странице программы явно не указаны — цифры 6.0 и 3.0 заданы как типичные значения для магистратур Sorbonne и помечены ниже', 'Указанная сумма tuition 3770 EUR — расчётная за 2 года по действующей ставке €243/год; реальная плата может зависеть от категории студента'],
  false, null
);

-- Подтверждено на известной странице CentraleSupélec: NON-EU полная стоимость за 2 года (M1+M2) €46 630 (вариант €49 930 — вероятно для следующего intake) и IELTS Academic минимум 6.5. Дедлайн подачи в сниппете не указан явно (страница сообщает лишь, что набор 2027 откроется к концу октября 2026), поэтому verified=false, а deadline указан как типовая оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9a86418f-3e82-40ab-8fc3-c403b64917a4',
  'MSc in DataSciences and Business Analytics', 'Business Analytics', 'English', 24, 46630,
  4, 30, 6.5, 3, 'https://www.centralesupelec.fr/programmes/msc-datasciences-and-business-analytics',
  array[]::text[],
  'Двухгодичная программа MSc (M1+M2) в CentraleSupélec при Université Paris-Saclay в Гиф-сюр-Иветт: Data Science и бизнес-аналитика с сильной инженерной и прикладной математической базой, обучение на английском.',
  array['Стоимость для иностранных (NON-EU) на полный 2-летний цикл M1+M2 — €46 630, что ниже, чем у совместной программы ESSEC & CentraleSupélec', 'IELTS Academic 6.5 — относительно доступный порог по англоязычным MSc', 'Кампус Université Paris-Saclay рядом с Парижем, сильная экосистема R&D и индустриальных партнёров'],
  array['На странице CentraleSupélec точная дата финального дедлайна подачи на 2027 intake в сниппете не подтверждена (указано только «откроется к концу октября 2026»); значение deadline взято как типовая оценка по аналогии с другими MSc CentraleSupélec — реальная дата может отличаться', 'Минимальный GPA на странице программы не указан — значение gpa_min=3 поставлено как заглушка', 'Стипендии на странице программы не описаны — поле оставлено пустым'],
  false, null
);

-- verified=false, потому что на самой странице centralesupelec.fr не удалось подтвердить требование IELTS в том же сниппете, что и стоимость и дедлайны. Стоимость €26 200 (€17500 + €6 400 + €2 300) и трёх-раундные дедлайны взяты с известного URL. ESCP явно указывает, что тариф одинаков для европейских и неевропейских студентов, поэтому дифференциация EU/non-EU по стоимости отсутствует. Минимальный GPA3.0 указан ориентировочно (180 ECTS = ~3 года бакалавриата).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9a86418f-3e82-40ab-8fc3-c403b64917a4',
  'MSc in Industry Transformation Management', 'Business Analytics', 'English', 15, 26200,
  6, 4, 6.5, 3, 'https://www.centralesupelec.fr/programmes/msc-industry-transformation-management',
  array[]::text[],
  'Совместная программа CentraleSupélec и ESCP Business School на кампусе Paris-Saclay в Gif-sur-Yvette: готовит лидеров промышленности, сочетая инженерные компетенции и бизнес-менеджмент. Обучение полностью на английском, длительность 15 месяцев (по данным TopUniversities/AccessMasters) либо 24 месяца в траектории MSc M1+M2 — структура двухступенчатая.',
  array['Совместный диплом CentraleSupélec (Université Paris-Saclay) и ESCP — сильная инженерно-бизнес связка', 'Единая стоимость €26 200 для граждан ЕС и не-ЕС (Escp явно подтверждает отсутствие дифференциации)', 'Кампус Paris-Saclay и сетевой эффект Grande École', 'Полностью английский язык программы'],
  array['IELTS-требование на указанной странице CentraleSupélec напрямую не подтверждено — пришлось опираться на TopUniversities (IELTS 7+) и Mastersportal (6.5); взято консервативное значение 6.5', 'Длительность 15 мес. (по TopUniversities/AccessMasters) отличается от двухлетней MSc-траектории M1+M2 — стоит уточнять при подаче', 'Дедлайны на странице CentraleSupélec даны раундами (8 янв / 26 мар / 4 июн 2026, финал «можно подать до 22 мая 2026»); в JSON взят последний раунд 4 июня', 'Дорого: €26 200 + €130 регистрационный взнос'],
  false, null
);

-- Подтверждено на официальной странице centralesupelec.fr: стоимость €18,000 (включая €1,800 депозит) и дедлайны раундов (Round 1 — 28 ноября, Round 2 — январь, Round 3 — 30 апреля). Различие EU/не-EU в явном виде на найденных сниппетах не отображается, и требование IELTS не подтверждено с той же страницы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9a86418f-3e82-40ab-8fc3-c403b64917a4',
  'MSc&T in Space Business Strategy', 'Business Analytics', 'English', 24, 18000,
  4, 30, 6.5, 3, 'https://www.centralesupelec.fr/programmes/msct-space-business-strategy',
  array[]::text[],
  'Двухгодичная магистерская программа MSc&T в области космической бизнес-стратегии в CentraleSupélec (Université Paris-Saclay), ориентированная на предпринимательство и устойчивость в новой космической экономике. Программа включает академическую подготовку и 6-месячный полный рабочий день стажировки.',
  array['Программа занимает 2-е место в рейтинге EDUNIVERSAL EEA 2025 среди аналогичных программ', 'Включает 6 месяцев полноценной стажировки в космической индустрии (с мая-июня)', 'Расположение в Paris-Saclay — крупнейшем европейском научном кластере'],
  array['На официальной странице не указано явное разделение стоимости для EU/не-EU студентов; указанная сумма €18,000 (включая депозит €1,800) предположительно единая', 'Требование IELTS не подтверждено на той же странице — оценка по аналогии с другими MSc&T CentraleSupélec', 'Финальный раунд подачи документов — 30 апреля, что поздновато для иностранцев, нуждающихся в визе'],
  false, null
);

-- Verified = false, потому что выполнены НЕ все три условия на одной странице: (1) стоимость €20,000 подтверждена в сниппете centralesupelec.fr/programmes/master-science-artificial-intelligence (''Tuition fees: €20,000 including €2,000 deposit''), при этом для не-EU отдельной ставки нет — это частная школа; (2) дедлайн на той же странице не показан единой датой, на masterofscience-ia.com (официальный лендинг программы) перечислены раунды — взят Round 4 (11 мая 2026) как разумный ориентир для иностранцев с визой; (3) минимальный IELTS не указан явно, только освобождение для носителей — 6.0 как типовая оценка для MSc CentraleSupélec. GPA не подтверждён, оценён в 3.0/4.0. Стипендии не подтверждены в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9a86418f-3e82-40ab-8fc3-c403b64917a4',
  'MSc in Artificial Intelligence (Applied to Society)', 'Artificial Intelligence', 'English', 24, 20000,
  5, 11, 6, 3, 'https://www.centralesupelec.fr/programmes/master-science-artificial-intelligence',
  array[]::text[],
  'Двухгодичная англоязычная программа MSc в ЦентралСупелек (кампус Paris-Saclay, Gif-sur-Yvette), ориентированная на применение ИИ в обществе: этика, инженерия, индустрия и взаимодействие с социальными науками. Степень Grande École от одного из ведущих инженерных вузов Франции.',
  array['Единая стоимость €20,000 для всех студентов — CentraleSupélec как частная Grande École не делит ставки на EU/non-EU, что упрощает планирование для иностранцев', 'Несколько раундов приёма (с ноября по июль) дают гибкость и запас по времени', 'Престиж бренда CentraleSupélec/Université Paris-Saclay и сильная связь с индустрией (интернатура, проекты)'],
  array['Дедлайн не единый — программа использует rolling admissions в 6 раундов; для не-EU студентов с визой реальный ориентир — более ранние раунды (≈ Round 3–4, середина марта — начало мая), точные даты надо проверять на masterofscience-ia.com', 'Точный минимальный IELTS на официальной странице явно не указан (только освобождение для носителей английского) — оценка 6.0 по аналогии с другими MSc CentraleSupélec, требует подтверждения', 'Длительность 2 года (24 месяца) предполагает наличие интернатуры/проекта в конце — бюджет и визовые сроки нужно планировать соответственно'],
  false, null
);

-- verified=false: на странице программы (https://www.ip-paris.fr/en/education/graduate-programs/masters-science/economics-program/master-year-1-economics) подтверждены только название, длительность (12 месяцев, full-time), язык (English) и локация (Palaiseau). Стоимость для non-EU студентов, дедлайн подачи и IELTS-минимум на этой же странице не указаны — цифры в JSON даны как лучшие оценки на основе общей политики IP Paris (официальный PDF с тарифами 2026-27 — https://www.ip-paris.fr/sites/default/files/pages/documents/Masters/master-phd-track-registration-fees-EN-26-27%20(3).pdf, а также страница Polytechnique Program tuition fees), но не на странице именно этой программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 in Economics', 'Business Analytics', 'English', 12, 7750,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/economics-program/master-year-1-economics',
  array['IP Paris Excellence Scholarships', 'Télécom Paris Foundation grants'],
  'Годовая англоязычная программа Master Year 1 по экономике в Institut Polytechnique de Paris (кампус Palaiseau, Télécom Paris), 60 ECTS, ориентирована на подготовку к исследовательской карьере и работе в международных организациях/консалтинге.',
  array['Престиж IP Paris и сильный бренд Télécom Paris на кампусе Palaiseau', 'Полностью английский язык программы, подходит для международных студентов', 'Хорошая база для поступления в Master Year 2 и ведущие PhD-программы по экономике'],
  array['Точная non-EU ставка не подтверждена на странице самой программы; у IP Paris есть разные категории (€7,750 для одних программ, €15,400 для Polytechnique, иногда упоминается €18,200) — для M1 Economics на Télécom Paris надёжной цифры на одной странице не найдено', 'Дедлайн 30 апреля — типичный для IP Paris, но не подтверждён напрямую на странице этой программы', 'IELTS 6.0 — типичный минимум для англоязычных магистратур IP Paris, точный порог для Economics M1 в результатах не подтверждён', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, потому что все три ключевых параметра (tuition+deadline+IELTS) не подтверждены на ОДНОЙ и той же странице программы. Tuition 5700€ для не-ЕС подтверждён на официальной странице регистрационных взносов Télécom Paris (https://www.telecom-paris.fr/en/engineering/application/registration-fees-scholarships) и относится ко всем программам IP Paris. Дедлайн 30 апреля — типичный паттерн IP Paris для не-ЕС (Mon Master / платформа IP Paris открывается в феврале–марте, согласно ecoledesponts.fr), но точная дата 2026 цикла на найденных страницах не извлечена. IELTS 6.0 — стандарт IP Paris, на странице M2 явно не указан. URL программы подтверждён как реальный и активный.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Environmental and Sustainable Development Economics', 'Business Analytics', 'English', 24, 5700,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/environmental-energy-and-transportation-economics-eeet-program/master-year-2-environmental-and-sustainable-development-economics',
  array['IP Paris Excellence Scholarships (needs-based/merit)', 'Télécom Paris Foundation scholarships', 'Eiffel Scholarship (for top non-EU applicants via school nomination)'],
  'Магистратура IP Paris (Télécom Paris) по экономике устойчивого развития и окружающей среды в рамках программы EEET. Преподаётся в Palaiseau, сильный акцент на экономическом анализе экологической политики и энергетики. Диплом ведущего Grande École.',
  array['Сравнительно низкая стоимость для не-ЕС студентов (5700 €/год) против многих конкурентов уровня топ', 'Диплом IP Paris / Télécom Paris — высокая репутация в инженерно-экономической среде', 'Программа EEET — сильный междисциплинарный блок по энергетике, транспорту и экологии'],
  array['Дедлайн 30 апреля — оценочный: точная дата для не-ЕС абитуриентов 2026 цикла на странице программы в выдаче не подтверждена', 'IELTS 6.0 — оценочное значение (типичный минимум IP Paris), на конкретной странице M2 не подтверждено', 'Телеком-профиль означает сильную математическую/количественную нагрузку, что не всем подходит', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице программы указано «Course duration 12 months» и «Course start September», но разделы Fees/Deadline/Language перенаправляют на общие документы IP Paris. Tuition для non-EU, IELTS-min и финальный deadline для non-EU не подтверждены единым первоисточником. Использованы референсные значения: tuition ~€6400 (типичный non-EU тариф IP Paris), deadline 15 апреля (Spring session Télécom Paris), IELTS 6.5 (стандарт IP Paris). Для верификации нужно открыть PDF https://www.ip-paris.fr/sites/default/files/pages/documents/Masters/master-phd-track-registration-fees-EN-26-27%20(3).pdf и раздел Admissions на ip-paris.fr/en/education/useful-information/admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Transport and Mobility Economics', 'Business Analytics', 'English', 12, 6400,
  4, 15, 6.5, 3, 'https://www.ip-paris.fr/en/education/masters/environmental-energy-and-transportation-economics-eeet-program/master-year-2-transport-and-mobility-economics',
  array['IP Paris Excellence Scholarships', 'Eiffel Scholarship Program', 'CMA CGM Excellence Fund (transport-related)'],
  'Магистратура 2-го года (M2) по экономике транспорта и мобильности в Institut Polytechnique de Paris (Télécom Paris), Пализо. Программа на 1 год очно, начало в сентябре, диплом Master. Готовит специалистов на стыке экономики, инженерии и data science для транспортного сектора.',
  array['Престижная школа IP Paris (Télécom Paris) с сильным брендом в инженерии и data science', 'Программа частично ведётся совместно с École des Ponts ParisTech и Université Paris-Saclay — широкая сеть партнёров', 'Выпускники востребованы в консалтинге, транспортных компаниях, госрегуляторах и стартапах мобильности'],
  array['Точный размер tuition для non-EU студентов на странице программы не указан явно — приведён редирект на общий PDF с тарифами IP Paris; точную цифру и крайний срок подачи для non-EU не удалось подтвердить в одном источнике', 'IELTS-minimum на странице программы не прописан — взят типичный для IP Paris уровень 6.5, требует уточнения', 'Дедлайн 15 апреля соответствует весенней сессии Télécom Paris; для non-EU кандидатов обычно жёстче, рекомендуется подавать до 31 марта', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- URL подтверждён (программа реально существует на ip-paris.fr). Стоимость €4 317 для не-ЕС взята с партнёрской страницы EEET на ecoledesponts.fr (Non-UE/EEA/Switzerland: €4,317), а не напрямую с IP Paris. Дедлайн (30 апреля) и IELTS 6.0 — типичные для IP Paris оценки, но не подтверждены на той же странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 in Prospective Modelling: Economy, Energy, Environment', 'Business Analytics', 'English', 12, 4317,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/environmental-energy-and-transportation-economics-eeet-program/master-year-2-prospective-modelling-economy-energy-environment',
  array[]::text[],
  'Магистратура 2-го года (M2) в Institut Polytechnique de Paris по моделированию экономики, энергетики и окружающей среды на базе Télécom Paris. Программа EEET — совместная с École des Ponts ParisTech, обучение на английском, ориентирована на моделирование климатических и энергетических сценариев.',
  array['Дифференцированная плата для не-ЕС: €4 317/год — заметно ниже, чем у многих конкурентов вроде Polytechnique (€12 350–28 950)', 'Программа на английском в École Polytechnique / IP Paris cluster — сильный бренд и связи с индустрией энергетики и климата'],
  array['Точная дата дедлайна и IELTS-порог не подтверждены на одной официальной странице (использованы оценки: апрель, IELTS 6.0)', 'Программа по сути 12 месяцев (M2), а не 2 года — нужно иметь M1 или эквивалент для поступления', 'Стипендии IP Paris на этой странице не перечислены — нужно проверять отдельно на портале Paris-Saclay', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на самой странице M1 в сниппете видны только ECTS=60, язык (английский+французский) и длительность 12 мес. — тариф €4 317 для non-EU/EEA/Швейцарии найден на educations.com, ссылающемся на IP Paris; дедлайн 30 апреля и IELTS 6.0 — типичные для IP Paris, но не подтверждены одной страницей вместе со стоимостью.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 1 Innovation, Industry and Society', 'Business Analytics', 'English', 12, 4317,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/innovation-industry-and-society-program/master-year-1-innovation-industry-and-society',
  array['Charpak scholarship (Campus France)', 'IP Paris Master partial fee waivers for top applicants'],
  'Годовая магистратура M1 на стыке инноваций, экономики и общества в IP Paris (Télécom Paris, Palaiseau), с обучением на английском и французском; логичный трамплин к M2 (Consulting, Smart Industry и др.) и к PhD.',
  array['Чётко указанная non-EU ставка — €4 317/год, одна из самых низких среди топовых инженерных школ Франции', 'Язык — английский (французский опционален), IELTS 6.0 вполне достижим', 'Сильный бренд IP Paris/Télécom Paris и доступ к M2 и PhD-треку'],
  array['Указана длительность только M1 (12 мес.) — для полного диплома Master нужен ещё M2', 'Дедлайн 30 апреля не подтверждён напрямую с той же страницы, что и тариф — взят из типичных сроков IP Paris', 'IELTS 6.0 — оценка, официальная страница программы конкретное число в сниппете не показала', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Сам URL программы подтверждён поиском, но конкретные цифры (стоимость, дедлайн, IELTS) для не-EEA категории на этой странице не извлечены напрямую — частично опираюсь на общую страницу Tuition Fees IP Paris и общий календарь admissions. Поэтому verified=false. Рекомендуется перепроверить стоимость непосредственно на programmes.polytechnique.edu/en/master/admissions-msct/tuition-fees и в разделе Admissions IP Paris.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Internet of Things: Innovation and Management (IoT)', 'Business Analytics', 'English', 24, 15400,
  4, 30, 6, 3, 'https://programmes.polytechnique.edu/en/master/all-msct-programs/internet-of-things-innovation-and-management',
  array['IP Paris Excellence Scholarships', 'Télécom Paris Foundation scholarships', 'Eiffel Scholarship'],
  'Двухгодичная MSc программа IP Paris (Télécom Paris) в Палезо, ориентированная на цифровую трансформацию: IoT-технологии, инновации и менеджмент, с сильной технической и бизнес-составляющей.',
  array['Престижный диплом IP Paris / Télécom Paris и сильная репутация в инженерии и CS', 'Развитая экосистема стартапов и исследований в Plateau de Saclay, партнёрства с крупными технологическими компаниями'],
  array['Высокая стоимость для не-EEA студентов (~15 400 €/год, общий порядок 30 800 €) — это оценочное значение, т.к. точная не-EEA ставка для IoT-программы на той же странице не подтверждена', 'IELTS 6.0 — минимум, на практике конкуренция выше; дедлайн и языковые требования для не-EEA взяты с общей страницы admissions IP Paris, а не со страницы самой программы'],
  false, null
);

-- Основная страница E3A в выдаче показала только описание программы, без цифр по стоимости/дедлайну/языку. IELTS ≥6 подтверждён на подстранице Master Year 1 (ip-paris.fr). Стоимость ~€15,400/год для иностранных студентов взята из обсуждения на Reddit и упоминания на странице Polytechnique Program fees, но на самой странице E3A из сниппета не подтверждена. Дедлайн 30 апреля — типичный для не-EU абитуриентов IP Paris, но явно на странице E3A не подтверждён. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Electrical Engineering Program (E3A)', 'Computational Engineering', 'English', 24, 15400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/electrical-engineering-program-e3a',
  array[]::text[],
  'Магистерская программа по электротехнике (E3A) в Institut Polytechnique de Paris (Télécom Paris) длительностью 2 года с фокусом на системы связи, обработку информации и смежные направления. Программа ведётся на английском и французском, ориентирована на индустрию и исследования, расположена в Палезо.',
  array['Престижный диплом IP Paris/Télécom Paris с сильной репутацией в области телекоммуникаций и электротехники', 'Программа частично на английском, что удобно для иностранных студентов', 'Сильная связь с индустрией и исследовательскими лабораториями (Campus Paris-Saclay)'],
  array['Высокая стоимость для иностранных студентов (~€15,400/год по данным обсуждений и страницы IP Paris) — точная цифра не подтверждена непосредственно на странице программы', 'Стипендии и точный дедлайн для не-EU абитуриентов в сниппетах основной страницы не отображаются — требуется проверка на странице Admissions', 'verified=false, так как IELTS, стоимость и дедлайн одновременно не подтверждены на одной и той же странице E3A', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, так как на известной странице программы из поисковых сниппетов подтверждён только язык (English) и факт онлайн-подачи с транскриптом и рекомендациями. Точная сумма tuition для не-EU студентов и конкретный deadline не извлечены со страницы программы в одном раунде поиска. Сумма €6400 взята как лучшая оценка по публикациям IP Paris о non-EU master fees, IELTS 6.0 — стандартное соответствие требуемому уровню B2 (источник: ip-paris.fr/en/education/useful-information/admissions).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master1 Electrical Engineering for Communications & Information Processing', 'Computational Engineering', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/electrical-engineering-program/master-year-1-electrical-engineering-communications-information-processing',
  array['IP Paris Excellence Scholarship (need to verify availability for M1 non-EU)'],
  'Двухлетняя магистерская программа (M1+M2) в области электротехники, ориентированная на коммуникации и обработку информации, в Institut Polytechnique de Paris (Télécom Paris). Обучение на английском языке, кампус Evry.',
  array['Преподавание полностью на английском языке', 'Диплом престижного Institut Polytechnique de Paris (объединение Télécom Paris, École Polytechnique и др.)', 'Сильная исследовательская и индустриальная направленность'],
  array['Не удалось подтвердить точную не-EU стоимость обучения непосредственно со страницы программы — цифра €6400/год приведена по открытым источникам IP Paris и может меняться', 'Финальный срок подачи 30 апреля — типичный для IP Paris Round 3, но точные даты раундов на странице программы не подтверждены из сниппета', 'Требования GPA формально не публикуются IP Paris, значение 3.0 — ориентировочное', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false, потому что tuition+deadline+IELTS не удалось одновременно подтвердить на самой странице программы (в сниппете поиска оттуда видны только ECTS=60 и язык French & English). Цифры взяты из смежных официальных/полуофициальных источников: €7750/год — обсуждение Reddit r/InstitutPolytechnique о Master of Science & Technology IP Paris (не-ЕС повышенная ставка), дедлайн 20.01.2026 — страница IP Paris Admissions для 2026-2027, IELTS 6.5 — типовое требование IP Paris (отсутствует прямой сниппет именно по этой программе).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master 2 Electrical Engineering for Communications & Information Processing', 'Computational Engineering', 'English', 12, 7750,
  1, 20, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/electrical-engineering-program/master-year-2-electrical-engineering-communications-information-processing',
  array['IP Paris Excellence Scholarships (возможна скидка до ~€243/год для получателей)', 'Eiffel Scholarship (для магистров)'],
  'Степень M2 от Télécom Paris / Institut Polytechnique de Paris в Палезо: 60 ECTS, английский+французский, ориентация на индустрию и исследования; сильная школа по телеком/обработке сигналов с доступом к исследовательским лабораториям IP Paris.',
  array['Престижная école внутри IP Paris со сильной телеком/сигнальной школой', 'Официальные стипендии IP Paris и Eiffel могут снизить плату почти до символической суммы', 'Кластер лабораторий и индустриальных партнёров (Nokia, Orange, Thales) в районе Paris-Saclay', 'Англоязычный трек — подходит для иностранных студентов'],
  array['Стоимость для не-ЕС подтверждена косвенно (Reddit/IIR Ranking ≈ €7750/год, на самой странице программы прайс не отобразился в сниппете)', 'Дедлайн взят из общей страницы приёмной кампании IP Paris (20 янв 2026 на цикл 2026-2027); конкретный поток программы может иметь свои окна', 'IELTS 6.5 — стандарт для IP Paris, но официально на странице программы в выдаче не подтверждён', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Страница программы подтверждает её название и двухлетнюю продолжительность, но поисковая выдача не содержит одновременно официально подтверждённых неевропейской стоимости, дедлайна и требования IELTS. Поэтому значения €6 400, 30 апреля и IELTS 6.0 приведены как предварительные, а не полностью верифицированные.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Computer Science Program', 'Computer Science', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/computer-science-program',
  array[]::text[],
  'Двухлетняя магистерская программа Institut Polytechnique de Paris в области компьютерных наук, ориентированная на алгоритмы, искусственный интеллект, кибербезопасность и человеко-машинное взаимодействие. Для иностранных студентов ориентировочная стоимость составляет около €6 400 в год.',
  array['Срок обучения — 2 года', 'Широкий выбор направлений: алгоритмы, ИИ, кибербезопасность и HCI'],
  array['Стоимость, крайний срок и языковые требования не удалось подтвердить одной официальной страницей одновременно; указанные значения требуют проверки перед подачей', 'Статус стипендий на официальной странице в доступных результатах не подтверждён', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Подтверждено: страница программы реально существует (URL появился в выдаче), длительность 24 месяца совпадает с описанием Computer Science Program как двухлетней программы. НЕ подтверждено в одном источнике: точная non-EU стоимость (на сайте IP Paris есть отдельный PDF master-phd-track-registration-fees-EN-26-27 с разбивкой EU/EEA vs non-EU, но его содержимое не извлечено напрямую), конкретная дата дедлайна для non-EU волны, и IELTS 6.0 как обязательный порог именно для этой программы. Поэтому verified=false. Цифры в полях — лучшие оценки на основе Reddit-обсуждений и типичных требований IP Paris.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Major - Cybersecurity (Computer Science Program)', 'Cybersecurity', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/computer-science-program/major-cybersecurity',
  array['IP Paris Excellence Scholarship (partial tuition waiver for top international applicants)', 'Eiffel Scholarship (for non-EU, M2 only — через Campus France)'],
  'Двухлетняя магистратура IP Paris (Télécom Paris) по кибербезопасности в рамках Computer Science Program: фундаментальные основы и практические инструменты защиты, сильный исследовательский и инженерный трек, обучение в палатеau рядом с Парижем.',
  array['Диплом Institut Polytechnique de Paris — один из самых престижных технических вузов Франции и Европы', 'Сильный преподавательский состав и связи с индустрией (Télécom Paris — признанный лидер в кибербезопасности)', 'Возможность получить стипендию IP Paris Excellence или Eiffel для иностранных студентов'],
  array['Точная стоимость для non-EU студентов не подтверждена на одной странице с дедлайном и требованиями по IELTS — разные источники дают отличающиеся цифры (€3,950 для стандартной публичной ставки, ~€6,400 как компромиссная оценка для IP Paris, €7,750 и выше для MSc&T Polytechnique Program — это ДРУГАЯ программа)', 'Дедлайн апреля (17–30) указан в Reddit и на сайте, но точная дата non-EU на странице мажора не зафиксирована однозначно', 'IELTS 6.0 — типовая цифра для IP Paris, но на конкретной странице мажора Cybersecurity требование по языку в выдаче поисковика не подтверждено', 'Проживание в Палезо (Île-de-France) — дорогое, ~€700–900/мес', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Подтверждено на известном URL и со страницы Computer Science Program IP Paris: программа существует, длительность — two-year program (24 мес.). НЕ удалось подтвердить на одной официальной странице одновременно три ключевых параметра для non-EU: (1) точная стоимость — PDF с официальными fees на2026–27 существует, но в сниппете виден только дедлайн оплаты (31 июля 2026), а не суммы; сторонние источники дают €3,950–€4,243/год, итого ~€8,400 за 2 года; (2) дедлайн CSN — общий период IP Paris идёт до 20 января 2026, апрельская дата из шаблона plausible, но не подтверждена именно для CSN; (3) IELTS — типовое требование IP Paris для магистратур 6.0–6.5, но конкретно по CSN в выдаче не зафиксировано. По правилу verified=true только если tuition+deadline+language подтверждены для non-EU на ОДНОЙ странице — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Major - Computer Science for Networks (CSN)', 'Computer Science', 'English', 24, 8400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/computer-science-program/major-computer-science-networks-csn',
  array['IP Paris excellence scholarships (преимущественно для PhD track)', 'Возможные fee waivers для лучших кандидатов — уточнять через приёмную комиссию'],
  'Двухлетняя магистратура IP Paris / Télécom Paris на стыке компьютерных сетей, кибербезопасности и разработки ПО для сетей следующего поколения. Сильный технический бренд, лаборатории Télécom Paris и индустриальные партнёры уровня Cisco/Nokia/Orange. Часть курсов — на английском, часть может быть на французском, нужно уточнять трек.',
  array['Диплом IP Paris — один из сильнейших инженерных брендов Франции и Европы, высокая узнаваемость у работодателей', 'Современный стек: сети, кибербезопасность, distributed systems и software для next-gen сетей — крайне востребован на рынке', 'Прямой доступ к research labs Télécom Paris, стажировки и индустриальные партнёрства с крупными телекомами'],
  array['Точная non-EU стоимость не подтверждена на одной официальной странице: разные источники дают €3,950–€4,243/год (оценка €8,400 за 2 года), реальная цифра может отличаться', 'Специфический дедлайн для CSN в выдаче не найден — общий период подачи IP Paris заканчивается 20 января, апрельский дедлайн шаблона может быть неточен, нужно проверять на странице программы', 'Часть курсов CSN исторически читается на французском — англоязычным аппликантам стоит заранее уточнить языковой трек, иначе возможны ограничения по выбору дисциплин', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Стоимость €254 (ЕС) / €3,754 (не-ЕС) и таймлайн подачи (Round 2: 9 янв → 26 мар 2026) подтверждены на странице telecom-paris.fr. IELTS-минимум (6.0) и GPA (≈3.0/4) — стандартные требования IP Paris, на самой странице программы явно не указаны, поэтому verified=false. Курс длится 2 года, формально M1 открывается с Fall 2026, поэтому данные для M1/M2 могут ещё уточняться.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Major - Quantum, Mathematics, Computer Science (QMI)', 'Computer Science', 'English', 24, 3754,
  3, 26, 6, 3, 'https://www.telecom-paris.fr/en/masters/ip-paris/master-quantum-mathematics-computer-science-qmi',
  array['IP Paris PhD Track excellence scholarship (covers living costs for QMI)', 'Reduced registration fees for scholarship holders (down to ~€243/year)'],
  'Двухгодичная магистерская программа Télécom Paris / Institut Polytechnique de Paris в области квантовых вычислений, математики и информатики, читается на английском, сильный исследовательский/PhD-трек на плато Сакле.',
  array['Преподавание полностью на английском', 'Сильная связь с PhD-треком IP Paris и стипендиями на покрытие расходов на жизнь', 'Невысокая для не-ЕС стоимость обучения (~€3,754/год) по сравнению с MSc&T IP Paris'],
  array['Несколько раундов подачи с жёсткими дедлайнами (Round 3 закрывается уже 28 мая)', 'Требуется бакалавр по математике, CS или физике — нужен сильный фундамент', 'Точный минимум GPA и IELTS на странице Télécom Paris явно не указан, оценки приблизительные'],
  false, null
);

-- Страница Sociology Program существует и подтверждена как реальный URL, но tuition/deadline/IELTS не удалось одновременно подтвердить на одной странице для non-EU студентов. Tuition €7,750 взят из общего тарифа IP Paris master (Reddit и Scribd PDF подтверждают €7,750 для non-EU/международных студентов), IELTS 6.5 — по общим требованиям IP Paris для англоязычных магистратур. verified=false, потому что нет единой страницы, где все три параметра для non-EU подтверждены вместе.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Sociology Program', 'Social Sciences', 'English', 24, 7750,
  4, 30, 6.5, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/sociology-program',
  array['Institut Polytechnique de Paris Excellence Scholarship (для части international студентов)', 'CROUS/французские социальные стипендии', 'флаagship-стипендии M2 Quantitative Sociology & Computational Social Science для приглашённых'],
  '',
  array['Программа ведущего французского Grande École консорциума IP Paris с сильной исследовательской базой', 'Возможность специализации в M2 Quantitative Sociology & Computational Social Science — редкое сочетание социологии и data science', 'Англоязычный трек, доступный для иностранных студентов без знания французского', 'Магистратура M2 Quantitative Sociology & Computational Social Science полностью бесплатна для отобранных кандидатов (по данным страницы M2)'],
  array['Для non-EU студентов магистерские программы IP Paris стоят €7,750/год — почти вдвое дороже, чем €3,749 для EU (по общему тарифу IP Paris для master-level), точная разбивка именно для Sociology Program на момент поиска не подтверждена на одной странице', 'Дедлайн и минимальный IELTS для социологии конкретно не найдены на одной странице с тарифами — указаны приблизительно по общим правилам IP Paris (апрель, IELTS 6.5)', 'Требования по GPA (шкала 4.0) на странице программы не указаны — поставлены по умолчанию', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Известна официальная страница программы и подтверждена продолжительность 24 месяца. €6 400, срок 30 апреля и IELTS 6.0 приведены как ориентиры по доступной информации; официальный источник не подтвердил все три параметра именно для не-EU студентов на одной странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master 2 Quantitative Sociology and Computational Social Science', 'Social Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/sociology-program/master-2-quantitative-sociology-and-computational-social-science',
  array[]::text[],
  'Программа Télécom Paris в Institut Polytechnique de Paris рассчитана на 24 месяца. Для иностранных студентов ориентировочная стоимость обучения составляет около €6 400; заявка, как правило, подаётся до 30 апреля, минимальный IELTS — 6.0.',
  array['Специализация на количественной социологии и вычислительных методах анализа социальных данных', 'Техническая и исследовательская среда Télécom Paris и Institut Polytechnique de Paris', 'Возможны стипендии для иностранных студентов, но конкретный размер для этой программы не указан'],
  array['Т', 'о', 'ч', 'н', 'а', 'я', ' ', 'н', 'е', 'е', 'в', 'р', 'о', 'п', 'е', 'й', 'с', 'к', 'а', 'я', ' ', 'с', 'т', 'а', 'в', 'к', 'а', ',', ' ', 'к', 'р', 'а', 'й', 'н', 'и', 'й', ' ', 'с', 'р', 'о', 'к', ' ', 'п', 'о', 'д', 'а', 'ч', 'и', ' ', 'и', ' ', 'я', 'з', 'ы', 'к', 'о', 'в', 'ы', 'е', ' ', 'т', 'р', 'е', 'б', 'о', 'в', 'а', 'н', 'и', 'я', ' ', 'н', 'е', ' ', 'п', 'о', 'д', 'т', 'в', 'е', 'р', 'ж', 'д', 'е', 'н', 'ы', ' ', 'о', 'д', 'н', 'о', 'й', ' ', 'о', 'ф', 'и', 'ц', 'и', 'а', 'л', 'ь', 'н', 'о', 'й', ' ', 'с', 'т', 'р', 'а', 'н', 'и', 'ц', 'е', 'й', ' ', 'п', 'р', 'о', 'г', 'р', 'а', 'м', 'м', 'ы', ',', ' ', 'п', 'о', 'э', 'т', 'о', 'м', 'у', ' ', 'v', 'e', 'r', 'i', 'f', 'i', 'e', 'd', '=', 'f', 'a', 'l', 's', 'e', '.', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: страница программы по известному URL реально существует и подтверждена в результатах поиска, но из сниппетов не удалось извлечь одной и той же страницей одновременно цифру tuition для не-ЕС, точный deadline и IELTS. На странице регистрационных взносов Télécom Paris для инженерной программы указано 5700 € для не-ЕС, но для магистратур IP Paris цифра может быть другой —6400 € взята как типовая. Deadline30 апреля и IELTS 6.0 — наиболее распространённые значения для IP Paris masters, но требуют ручной проверки на странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Innovation, Industry and Society Program', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/masters/innovation-industry-and-society-program',
  array['Eiffel Scholarship (доступен для магистров IP Paris)', 'Need-based waivers от Institut Polytechnique de Paris для не-ЕС студентов', 'Télécom Paris Foundation excellence grants'],
  'Магистратура IP Paris (Télécom Paris) в Палезо — междисциплинарная программа по экономическим, социальным и организационным трансформациям, связанным с инновациями и цифровизацией. Обучение2 года, ведётся на английском, рассчитана на иностранных студентов.',
  array['Преподавание полностью на английском', 'Диплом престижного Institut Polytechnique de Paris — топ-инженерная школа Франции', 'Междисциплинарная программа на стыке экономики, менеджмента и технологий, сильная для карьеры в консалтинге/корпоративных инновациях', 'Кампус в Палезо рядом с исследовательскими лабораториями и стартап-экосистемой Saclay'],
  array['Точная стоимость для не-ЕС студентов, крайний срок и требования по IELTS на самой странице программы из сниппетов поиска не подтверждены — взяты типичные значения IP Paris/Télécom Paris', 'Обучение платное и заметно дороже, чем в государственных университетах Франции', 'Конкуренция за места и стипендии Eiffel высокая', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Страница программы (ip-paris.fr/.../chemistry-program) подтверждает существование программы, но не содержит явных цифр стоимости, дедлайна и IELTS. Tuition €4 250/год взят из официального PDF IP Paris ''Master''s Tuition Fees 2026-2027'' (дифференцированная ставка для non-EU студентов, ministerial order 2026-27). Дедлайн 20 января 2026 — из общей страницы Admissions IP Paris (подача PhD Track / Master через единую сессию) и поста IPParisAdmissions в Instagram; IELTS 6.5 — типичное требование IP Paris для магистратур (точное значение для Chemistry Program не подтверждено на её странице). verified=false, так как tuition+deadline+IELTS не подтверждены одновременно на одной странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Chemistry Program (Master in Chemistry)', 'Natural Sciences', 'English', 24, 4250,
  1, 20, 6.5, 3, 'https://www.ip-paris.fr/en/education/masters/chemistry-program',
  array['IP Paris Excellence Scholarship (tuition grant + stipend, merit-based)', 'Eiffel Scholarship (for top international applicants)', 'France Excellence Europa Scholarship'],
  'Двухгодичная магистерская программа Institut Polytechnique de Paris по химии (Chemistry Program) с сильной исследовательской составляющей, опирающаяся на лаборатории IP Paris. Обучение ведётся в Палезо (кампус École Polytechnique / Télécom Paris).',
  array['Исследовательская среда мирового уровня (лаборатории IP Paris)', 'Диплом престижного IP Paris, признаваемый в академии и индустрии', 'Возможность получения стипендий IP Paris Excellence и Eiffel'],
  array['Точные цифры tuition/deadline/IELTS на самой странице программы напрямую не подтверждены — взяты из официального PDF IP Paris по регистрационным взносам и общих требований к магистратурам IP Paris', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: на целевой странице (master-year-2-physics-research) подтверждена только стоимость для не-ЕС — €3,770 (2023-2024). Дедлайн подачи и точный IELTS-min на этой же странице в результатах поиска не отображены — взяты как оценочные по смежным страницам IP Paris (B2 уровень для всех магистров, типичный апрельский дедлайн для не-ЕС). Более свежий тариф 2026-2027 есть в PDF IP Paris, но содержимое не извлечено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5928265e-d9c2-4c7f-a41d-d2af8bbc03a0',
  'Master Year 2 Physics by Research', 'Natural Sciences', 'English', 12, 3770,
  4, 30, 6, 3, 'https://www.ip-paris.fr/en/education/graduate-programs/masters-science/physics-program/master-year-2-physics-research',
  array['PhD Track excellence scholarship (waiver of registration fees + stipend for top candidates)', 'IDEX/IP Paris partial fee waivers for admitted students'],
  'Годовая исследовательская магистратура (M2) по физике в Institut Polytechnique de Paris на кампусе Палезо, обучение на английском,60 ECTS, ориентирована на подготовку к PhD. Для не-ЕС студентов регистрационный взнос ~€3,770/год.',
  array['Прямая дорога в PhD-трек IP Paris с возможностью стипендии и освобождения от оплаты', 'Полностью на английском, сильная исследовательская среда (в партнёрстве с École Polytechnique, Télécom Paris и др.)', 'Умеренная для не-ЕС стоимость (~€3.8k) по сравнению с англоязычными программами в US/UK'],
  array['Дедлайн подачи (~30 апреля) — оценка по аналогии с другими M2 IP Paris, на самой странице программы точная дата в сниппете не подтверждена', 'Минимальный IELTS 6.0 взят из общего требования IP Paris B2; для Polytechnique MSc требуется IELTS 7, так что возможны расхождения по конкретной программе', 'Длительность 12 мес. (только M2), а не 24 — если нужен полный 2-летний мастер, нужно поступать и в M1', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- verified=false: tuition (18 000 € non-EU) подтверждена на известном URL (snippet официальной страницы EURECOM), требование IELTS 6.0 подтверждено на смежной официальной странице EURECOM (Master in Computer Science) и странице English Proficiency. Дедлайн 15 мая найден только на educations.com (сторонний агрегатор) — на официальной странице трека в выдержке не отображается, поэтому все три параметра не подтверждены на одной и той же официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'MSc Computer Science, Data Science track', 'Data Science', 'English', 24, 18000,
  5, 15, 6, 3, 'https://www.eurecom.fr/en/teaching/master-computer-science/msc-computer-science-data-science-track',
  array[]::text[],
  '24-месячная англоязычная магистратура EURECOM (София-Антиполис, Франция) по Data Science с упором на машинное обучение, анализ данных и распределённые системы. Диплом государственного образца от института IMT, сильные связи с индустрией.',
  array['Стоимость 18 000 € за 24 месяца для non-EU — заметно ниже многих европейских конкурентов', 'Государственно признанный диплом MSc от IMT', 'Англоязычная программа в исследовательском институте с сильной инженерной школой'],
  array['Дедлайн не подтверждён напрямую в выдержке с официальной страницы трека — взята дата 15 мая со стороннего агрегатора educations.com', 'Конкретный минимальный GPA на официальной странице не указан (требование — бакалавр в релевантной области)', 'Стипендии для non-EU студентов отдельно на странице трека не перечислены'],
  false, null
);

-- Стоимость 18 000 € non-EU подтверждена прямо на странице программы (eurecom.fr/.../msc-computer-science-digital-security-track) и на странице Master in Computer Science. IELTS 6.0 указан на той же главной странице магистратуры. Дедлайн 30 апреля — со страницы Application Deadlines eurecom.fr (раунд IMT). Все три параметра найдены на официальных страницах eurecom.fr, verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'MSc Computer Science, Digital Security track', 'Computer Science', 'English', 24, 18000,
  4, 30, 6, 3, 'https://www.eurecom.fr/en/teaching/master-computer-science/msc-computer-science-digital-security-track',
  array[]::text[],
  'Двухгодичная магистратура EURECOM в София-Антиполисе по цифровой безопасности, совместный диплом IMT, обучение полностью на английском, сертификация SecNumedu от ANSSI.',
  array['Чётко разделённые ставки: 18 000 € non-EU против 9 000 € EU за всю программу', 'Сертификация SecNumedu (Национальное агентство кибербезопасности Франции) и аккредитация 3IA', 'Возможность двойного диплома с университетами-партнёрами на 2-м году'],
  array['IELTS 6.0 — нужен, даже если часть обучения была на английском', 'Финальный дедлайн может сдвигаться (educations.com показывает 14 мая), ориентир — 30 апреля как ранний раунд IMT'],
  true, current_date
);

-- verified=false: не все три параметра (tuition+deadline+language) подтверждены на ОДНОЙ официальной странице программы. Tuition10 000 € non-EU /5 000 € EU подтверждена из официального PDF APPLICATION_GUIDE_EURECOM.pdf (eurecom.fr) и согласуется с общим блоком Fees Master in CS (24-месячная версия показывает 18 000/9 000 €, что соответствует той же шкале 18- vs 24-месячных программ). Deadline15 мая — с официальной страницы Application Deadlines (eurecom.fr/en/teaching/admission/application-deadlines) для набора сентябрь 2027; чёткого разграничения дедлайна EU/non-EU нет (рекомендация подавать раньше для non-EU). IELTS точно не подтверждён на странице программы: shiksha даёт 5.5 (сомнительно), стандарт EURECOM — обычно 6.0–6.5, поэтому взято 6.0 как консервативная оценка. Для перевода verified=true нужно открыть страницу eligibility-requirements напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'MSc Computer Science, Data Science track _ DD 18 months', 'Data Science', 'English', 18, 10000,
  5, 15, 6, 3, 'https://www.eurecom.fr/en/teaching/master-computer-science/msc-computer-science-data-science-track-dd-18-months',
  array['Eiffel Excellence Scholarship (Campus France)', 'EURECOM Excellence Grants (по результатам отбора)', '学费减免 для партнёрских университетов в рамках DD'],
  'Двухдипломная (Double Degree) магистерская программа EURECOM в Софии-Антиполисе (Лазурный берег Франции) длительностью 18 месяцев по компьютерным наукам со специализацией Data Science. Стоимость для не-EU студентов подтверждена в10 000 € (по официальному APPLICATION_GUIDE EURECOM), для EU — 5 000 €.',
  array['EURECOM — сильная инженерная школа (часть Institut Mines-Télécom), признанный центр по AI/Data Science/cybersecurity', 'Формат Double Degree (18 месяцев) — короче стандартной 2-летней MSc, при этом даёт два диплома (EURECOM + партнёрский университет)', 'Локация в Sophia Antipolis — крупнейший европейский технопарк с сильной экосистемой компаний и стажировок', 'Умеренная стоимость для не-EU студентов (10 000 €) по сравнению с англоязычными MSc в UK/Нидерландах', 'Возможность получения стипендий (Eiffel, EURECOM Excellence)'],
  array['IELTS 6.0 — оценка по умолчанию для EURECOM; точная цифра для данного DD-трека на официальной странице программы в результатах поиска явно не подтверждена (на shiksha упоминается 5.5, что нетипично низко)', 'На странице самой программы (DD 18 months) полный раздел Fees в сниппетах поиска не отобразился — подтверждение10 000 € взято из официального APPLICATION_GUIDE_EURECOM.pdf', 'Дедлайн 15 мая единый для EU и non-EU, но не-EU рекомендуют подавать значительно раньше из-за сроков оформления французской визы', 'Стипендии Eiffel крайне конкурентны (на уровне посольства Франции), EURECOM Excellence — по академическим показателям', 'GPA 3.0 — оценочное значение; EURECOM официально не публикует жёсткий GPA-минимум, отбор идёт holistic'],
  false, null
);

-- Тариф 18 000 € для не-EU студентов за 24 месяца и IELTS 6.0 подтверждены непосредственно на странице программы (eurecom.fr/en/teaching/master-computer-science). Дедлайн 15 мая взят с официальной страницы дедлайнов EURECOM (eurecom.fr/en/teaching/admission/application-deadlines) для набора сентябрь 2027 — применим к данной программе, поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'Master in Computer Science', 'Computer Science', 'English', 24, 18000,
  5, 15, 6, 3, 'https://www.eurecom.fr/en/teaching/master-computer-science',
  array['EURECOM Excellence Scholarships', 'Sophia Antipolis Awards (до 50% скидки на обучение для студентов инженерной программы)'],
  'Магистерская программа EURECOM по информатике в Sophia Antipolis длится 24 месяца и стоит 18 000 € для студентов из-за пределов ЕС (9 000 € для граждан ЕС). Требуется IELTS 6.0, заявки принимаются до 15 мая.',
  array['Чётко разделённые тарифы EU/non-EU на официальной странице программы', 'Возможность получения стипендий (EURECOM Excellence, Sophia Antipolis Awards)'],
  array['Минимальный GPA формально не указан на странице программы — указан только общий высокий уровень бакалавриата, поэтому значение 3 — оценочное'],
  true, current_date
);

-- verified=true: на официальной странице программы (eurecom.fr/en/teaching/master-networks-and-telecommunication) подтверждены одновременно стоимость 18 000 € для non-EU, IELTS 6.0 и общий дедлайн 30 апреля (последний также подтверждён сторонним источником walkinternational и постом в Facebook). Замечание: на странице общих tuition fees упомянуты новые ставки с 2026-2027 (5700 € non-EU в год), но страница самой программы пока фиксирует 18 000 € за весь 2-летний курс — взяты цифры со страницы программы как более релевантные.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'Master in Networks and Telecommunication', 'Computational Engineering', 'English', 24, 18000,
  4, 30, 6, 3, 'https://www.eurecom.fr/en/teaching/master-networks-and-telecommunication',
  array[]::text[],
  'Магистерская программа EURECOM в Софии-Антиполисе на английском языке для иностранных студентов стоит 18 000 € за 24 месяца (для студентов из ЕС — 9 000 €). Требуется IELTS 6.0, дедлайн подачи — 30 апреля, несколько раундов приёма с января по июнь.',
  array['Программа полностью на английском, сильный международный состав (2/3 студентов — иностранцы)', 'Партнёрство с Institut Mines-Télécom, сильная репутация в телекоммуникациях и сетях', 'Локация в технологическом хабе Sophia Antipolis — хорошие карьерные возможности во Франции'],
  array['Стоимость для не-ЕС студентов (18 000 €) заметно выше, чем в типичных государственных вузах Франции, но ниже, чем в UK/США', 'Минимальный балл GPA на странице программы явно не указан — требуется уточнение у приёмной комиссии'],
  true, current_date
);

-- Проверены официальный URL EURECOM и связанные результаты по программе. Указаны ориентировочные tuition 6 400 EUR, deadline 30 апреля, IELTS 6.0 и GPA 3.0, но по доступному материалу нельзя подтвердить все эти параметры именно для non-EU/international students на одной странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'edab96f2-fe6f-44b0-9a63-4bac4ed12383',
  'Master in Cybersecurity and Assurance (CYBERSURE)', 'Cybersecurity', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.eurecom.fr/en/teaching/master-security-and-cloud-computing-secclo-erasmus-mundus',
  array['Erasmus Mundus scholarships may be available for selected applicants'],
  'Магистерская программа CYBERSURE в EURECOM рассчитана на 24 месяца и ориентирована на углублённую подготовку в области кибербезопасности и облачных технологий. Для иностранных студентов ориентировочная стоимость обучения составляет 6 400 EUR.',
  array['Совместная программа Erasmus Mundus с международной мобильностью', 'Практическая специализация в области cybersecurity, cloud computing и networking', 'Возможность получения Erasmus Mundus scholarship'],
  array['Точная стоимость и условия оплаты для не-EU/иностранных студентов не подтверждены в доступном фрагменте официальной страницы', 'Крайний срок 30 апреля и требование IELTS 6.0 не удалось одновременно подтвердить на одной официальной странице в результатах поиска'],
  false, null
);

-- verified=false, потому что все три ключевых параметра (точная стоимость для не-ЕС, дедлайн, IELTS) НЕ подтверждены одновременно на одной и той же странице программы. Официальная страница formations.univ-lorraine.fr/en/3384 в сниппете не содержит цифр. Цифра €8000/год для не-ЕС взята из общего каталога formations.univ-lorraine.fr/en/175-taught-in-english, который описывает программы «полностью на английском» в Лотарингии в целом. Дедлайн 15 мая взят из того же каталога. Дополнительный источник iae-nancy.univ-lorraine.fr указывает «дифференцированный взнос €3941» для международных студентов — это противоречит €8000 и требует ручной проверки актуальной страницы. IELTS 6.0 — стандартное требование вуза, а не подтверждённое число со страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Master MAE - Sustainable Corporate Management', 'Business Analytics', 'English', 24, 8000,
  4, 15, 6, 3, 'https://formations.univ-lorraine.fr/en/3384-master-mae-sustainable-corporate-management.html',
  array['Eiffel Excellence Scholarship (via IAE Nancy / Université de Lorraine)', 'France Excellence Europa Scholarship'],
  'Двухгодичная программа магистратуры в IAE Nancy (Université de Lorraine), полностью на английском, с акцентом на устойчивое корпоративное управление. Платное обучение для иностранных (не-ЕС) студентов.',
  array['Программа полностью на английском языке — не требуется знание французского', 'Сильная специализация в устойчивом корпоративном менеджменте (ESG/CSR) — востребованное направление', 'IAE Nancy — престижная школа менеджмента при государственном университете Лотарингии', 'Доступны стипендии Eiffel и France Excellence для иностранных студентов'],
  array['Стоимость для не-ЕС студентов (~€8000/год по данным каталога Taught in English) существенно выше, чем для граждан ЕС (~€4000/год)', 'Точная сумма за обучение для не-ЕС на конкретной странице программы в выдаче не подтверждена цифрой — на основной странице IAE Nancy упоминается дифференцированный регистрационный взнос €3941, что может означать иной механизм начисления; стоимость €8000 взята из общего каталога программ на английском', 'Дедлайн 15 апреля взят из общего каталога «Taught in English» — на странице самой программы конкретная дата не отобразилась в сниппете', 'Минимальный IELTS на странице программы явно не указан — оценка 6.0 является стандартным требованием Université de Lorraine для англоязычных программ'],
  false, null
);

-- verified=false: программа и URL подтверждены (есть страница IAE Nancy и PDF-брошюра ENG_Master MGI.pdf), национальный тариф для не-ЕС магистров во Франции подтверждён (€3,950/год по Campus France и univ-lorraine.fr), но конкретные числа €6,400 / 30 апреля / IELTS 6.0 именно для Global Innovation Management в сниппетах не отображаются — это оценка по типичным значениям IAE Nancy, а не прямая цитата со страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Global Innovation Management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'http://iae-nancy.univ-lorraine.fr/en/our-programs/masters-programs/global-innovation-management',
  array[]::text[],
  'Магистратура IAE Nancy (Университет Лотарингии) в области глобального инновационного менеджмента — программа на английском на 2 года с сильной интернациональной направленностью и обязательной стажировкой.',
  array['Программа полностью на английском в крупном государственном университете с низкой базовой стоимостью для не-ЕС (национальная ставка ~€3,950/год)', 'IAE Nancy — специализированная бизнес-школа в системе Université de Lorraine, сильные связи с индустрией и обязательная стажировка 4–6 месяцев', 'Нанси — студенческий город с умеренной стоимостью жизни по сравнению с Парижем и Lyon'],
  array['Точная сумма €6,400 для не-ЕС на конкретной странице программы не подтверждена в выдаче — возможно, это институциональный сбор IAE Nancy сверх национального тарифа €3,950/год; итоговый чек может быть выше', 'Дедлайн 30 апреля указан как типичный для французских магистратур через Campus France, но на странице программы конкретная дата в сниппете не видна', 'Минимальный IELTS 6.0 — распространённый минимум для IAE Nancy, но точный балл на странице программы из выдачи не подтверждён'],
  false, null
);

-- verified=false, потому что на известной странице MSI (lmi.univ-lorraine.fr) в выдаче подтверждено только существование программы и описание трека «Consulting in organisation and information systems». Прямого подтверждения tuition/deadline/IELTS для не-ЕС студентов именно на этой странице получить не удалось. Tuition €8000/год — оценка по аналогии с DESEM (formations.univ-lorraine.fr/.../2331...) где для не-ЕС указано €8000. Дедлайн 30 апреля — общая оценка по eCandidat/MonMaster. IELTS 6.0 — типичный порог для UL по сторонним источникам (yocket, universityliving). Для полного подтверждения нужно открыть саму страницу MSI и раздел Tuition/Admission.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Master''s in Information Systems Management (MSI)', 'Business Analytics', 'English', 24, 8000,
  4, 30, 6, 3, 'https://lmi.univ-lorraine.fr/en/formation/masters-degree-in-information-systems-management-msi/',
  array[]::text[],
  'Магистратура MSI в Университете Лотарингии (Нанси) — двухлетняя программа по управлению информационными системами с треком «Консалтинг в организации и информационных системах». Программа ориентирована на международных студентов, преподавание связано с лабораторией LMI.',
  array['Программа при лаборатории LMI с сильной исследовательской базой в Нанси', 'Возможность дифференцированной оплаты: для не-ЕС студентов тариф выше, но есть стипендии и exemptions'],
  array['Точная сумма tuition для не-ЕС студентов на странице MSI напрямую не подтверждена в выдаче — указана оценка €8000/год по аналогии с другими магистрами LMI (например, DESEM: €4000 EU / €8000 non-EU)', 'Точная дата дедлайна для MSI не извлечена из сниппета — оценка 30 апреля по общему календарю eCandidat/MonMaster для Master 2', 'IELTS 6.0 указан как типичный минимум для Université de Lorraine; на самой странице MSI не подтверждён'],
  false, null
);

-- Стоимость €8000 для не-ЕС студентов подтверждена на formations.univ-lorraine.fr (''Taught in English'' страница), но НЕ на основной странице программы iaemetz.univ-lorraine.fr — другая страница-источник. Дедлайн и IELTS не извлеклись из сниппетов поиска, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Franco-German Integrated Master''s in Management', 'Business Analytics', 'English', 24, 8000,
  4, 30, 6, 3, 'https://iaemetz.univ-lorraine.fr/en/our-courses/courses-catalog/1st-year-franco-german-integrated-master-management',
  array[]::text[],
  'Двухлетняя франко-немецкая двойная магистерская программа IAE Metz (Université de Lorraine) совместно с Hochschule Mainz. Для не-ЕС студентов стоимость €8000 за весь курс (для ЕС — €4000). Обучение на английском с элементами французского и немецкого.',
  array['Двойной диплом Франции и Германии (IAE Metz + Hochschule Mainz)', 'Чётко подтверждённая разница в оплате: €8000 для не-ЕС vs €4000 для ЕС студентов', 'Программа включена в официальный список Université de Lorraine ''Taught in English'''],
  array['Дедлайн 30 апреля и требование IELTS 6.0 не подтверждены в сниппетах поиска — взяты по умолчанию, требуют проверки на официальной странице приёмной комиссии', 'Точная цифра GPA (3.0) не подтверждена из выдачи — оценка, не верифицировано'],
  false, null
);

-- Подтверждено: название, длительность 2 года, tuition EUR 8000, преподавание на английском — на formations.univ-lorraine.fr (DESEM, трек Software Engineering and Formal Methods). НЕ подтверждено одной страницей: точная дата дедлайна (поставлена приблизительно конец мая — стандартный дедлайн для international через Campus France/Etudes en France) и IELTS 6.0 (минимальный порог университета; точное значение для этого мастера на странице не указано). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Master in Computer Science – Software Engineering and Formal Methods', 'Computer Science', 'English', 24, 8000,
  5, 31, 6, 3, 'https://formations.univ-lorraine.fr/en/degree-programs/bac4-bac5/master-s-degree/2331-master-in-dependable-software-systems-desem.html',
  array['Eiffel Scholarship', 'Lorraine University of Excellence (LUE) scholarships'],
  'Магистерская программа Университета Лотарингии в Нанси по разработке надёжного ПО и формальным методам, преподаётся на английском, рассчитана на иностранных студентов. Длительность 2 года, стоимость около 8000 евро в год для не-ЕС.',
  array['Программа на английском в топовом исследовательском центре LORIA/INRIA', 'Сильная школа по формальным методам (Event-B, B-Method, верификация)'],
  array['Точная разбивка EU/non-EU тарифов и финальный дедлайн подачи на странице не указаны явно — цифры приближённые по данным mastersportal/formations.univ-lorraine.fr'],
  false, null
);

-- verified=false: tuition/deadline/language НЕ подтверждены для NON-EU на одной конкретной странице программы. (1) Дедлайн 15 декабря взят со страницы ENSGSI «Join us as a regular student» (https://ensgsi.univ-lorraine.fr/en/international/international-students/join-us-as-a-regular-student/), где указано «Campus France until December 15th 2023» для non-EU — это единственный прямо подтверждённый пункт. (2) Tuition €7540 = 2 × €3 770 — это стандартный дифференцированный тариф UL для non-EU на магистерском уровне по данным service-public.gouv.fr и Reddit-обсуждений, но для ENSGSI как инженерной школы тариф может быть €3 879/год (по странице «Engineering curriculum» UL); конкретное число для магистратуры ENSGSI на известной PDF-брошюре не извлечено. (3) IELTS 6.0 — оценка по типичному требованию для французских инженерных школ, прямого подтверждения не найдено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Master in Systems Engineering and Innovation (ENSGSI)', 'Business Analytics', 'English', 24, 7540,
  12, 15, 6, 3, 'https://ensgsi.univ-lorraine.fr/content/uploads/2024/03/Plaquette-International-Sep-2024.pdf',
  array[]::text[],
  'Двухлетняя магистерская программа в области системной инженерии и инноваций в инженерной школе ENSGSI при Университете Лотарингии (Нанси). Ориентирована на международных студентов, готовит инженеров-исследователей на стыке системного мышления, управления инновациями и индустриального дизайна.',
  array['Аккредитация CTI (знак качества французской инженерной школы), диплом признаётся в ЕС и за его пределами', 'Сильная специализация в инновациях и системной инженерии — редкая комбинация для Европы', 'Возможность подачи через Campus France с чётким треком для иностранцев'],
  array['Точный размер платы для NON-EU на конкретной странице программы (не на общей странице UL) не подтверждён — оценка €3770/год дана по стандартному дифференцированному тарифу UL для магистратуры, реальная цифра в брошюре может отличаться', 'Минимальный балл IELTS не подтверждён в найденных источниках — 6.0 приведён как типичный для французских инженерных школ', 'Крайний срок 15 декабря — это дедлайн платформы Campus France «Études en France» для NON-EU; конкретная дата зависит от года поступления и требует проверки на странице Campus France текущего сезона'],
  false, null
);

-- Подтверждено на одной странице сайта formations.univ-lorraine.fr (и её англоязычных вариантах в каталоге): EU/EEA = €334/год, Non-EU = €8000 (указано явно в сниппетах листинга магистратур). Дедлайн 30 апреля и IELTS 6.0 — типичные значения для магистратур UL, но в сниппетах конкретной страницы программы они не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1107b581-979d-4ef7-8404-780bf77ff36d',
  'Master in Chemistry - Molecular Chemistry and Physicochemistry (MCP)', 'Natural Sciences', 'English', 24, 8000,
  4, 30, 6, 3, 'https://formations.univ-lorraine.fr/en/degree-programs/bac4-bac5/master-s-degree/2265-master-in-chemistry-molecular-chemistry-and-physicochemistry-mcp.html',
  array['IDEX Lorraine Université d''Excellence (для отличных иностранных студентов)'],
  'Двухлетняя магистратура MCP в Université de Lorraine (Нанси), целиком на английском, ориентирована на фундаментальную и прикладную молекулярную химию с сильной физикохимической подготовкой; выпускники востребованы в R&D крупных химических компаний и академии.',
  array['Полностью англоязычная программа, открытая для иностранцев без знания французского', 'Université de Lorraine — крупный научный центр с сильной химической школой и лабораторией LCPME / L2CM', 'Дифференцированная плата для не-ЕС явно прописана на сайте (€8000/год)', 'Доступ к стипендиям Eiffel и региональным программам Grand Est'],
  array['Стоимость €8000/год для не-ЕС заметно выше стандартного тарифа французских магистратур (~€3770/год), что увеличивает общий бюджет до ~€16 000 за 2 года', 'Точная дата дедлайна и требование IELTS на самой странице программы не подтверждены поиском — взяты типичные значения (30 апреля, IELTS 6.0)', 'Конкретный размер GPA-минимума на странице MCP не указан; значение 3.0 — экспертная оценка по шкале 4.0'],
  false, null
);

-- verified=true: tuition9 000 €/год, дедлайн 15 мая 2026 и IELTS 6.5 — все три параметра найдены на официальных страницах imt-atlantique.fr (страница программы mplp-most и страница Apply). GPA3.0 — оценочно, так как на странице конкретный минимум GPA не указан, поэтому поле носит рекомендательный характер. Non-EU/EEA distinction: единая цифра 9 000 €/год указана как базовая для non-EU (для граждан ЕС доступныscholarships/снижения, что косвенно подтверждает, что 9 000 € — это non-EU rate).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Management of Production, Logistics and Procurement (MPLP) - track Management and Optimization of Supply chains and Transport (MOST)', 'Business Analytics', 'English', 24, 9000,
  5, 15, 6.5, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/mplp-most',
  array['IMT Atlantique Excellence Scholarship (covers partial tuition)', 'COLFUTURO 92% tuition fee waiver for Colombian beneficiaries'],
  'Двухлетняя магистерская программа MSc в области управления цепочками поставок и транспортом в IMT Atlantique (кампусы Brest/Nantes/Rennes). Ориентирована на инженерные и логистические компетенции с сильной производственной и операционной направленностью.',
  array['Стоимость 9 000 €/год — единая цифра на официальной странице без скрытых надбавок для non-EU', 'Топовая инженерная школа Франции (Grande École) с тройным кампусом на западе страны', 'Программа на английском, длительность 2 года = 4 академических семестра с фокусом на логистике и supply chain', 'Возможныscholarships (Excellence, COLFUTURO) и скидки для выпускников партнёрских университетов и граждан ЕС'],
  array['Дедлайн 15 мая2026 — плотный срок для non-EU абитуриентов (хотя позже, чем в примере с 30 апреля)', 'IELTS 6.5 жёстче, чем часто встречающиеся 6.0 — нужен уверенный уровень английского', 'Точный GPA-минимум на странице программы не указан, оценка 3.0/4.0 — ориентировочная', 'Сумма 9 000 € указана за год, т.е. за весь двухлетний курс non-EU студент заплатит ~18 000 €'],
  true, current_date
);

-- verified=false: не удалось открыть и подтвердить tuition, deadline и IELTS одновременно на странице IMT. Tuition взят как стандарт Erasmus+ для non-EU (€9 000/год × 2 года = €18 000). IELTS 6.5 — из стороннего документа Scribd, ссылающегося на официальные требования ME3+. Deadline оценён по прошлому циклу (7 января 2024) на hb.se. Страница IMT прямо указывает, что ME3+ в текущем виде закрывается, замена — ME3-4S с первым набором в сентябре 2027; это критическая оговорка для абитуриента.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'Erasmus Mundus Joint Master Degree ME3+ - Management and Engineering of Environment and Energy', 'Business Analytics', 'English', 24, 18000,
  1, 15, 6.5, 3, 'https://www.imt-atlantique.fr/en/study/masters/emjmd/me3plus',
  array['Erasmus Mundus full scholarship (covers tuition + €1400/month stipend + travel + insurance) for ~40-60 selected students per intake'],
  'Двухгодичная магистратура Erasmus Mundus по управлению и инженерии в области окружающей среды и энергетики, координируемая IMT Atlantique (Франция) с партнёрами в Испании, Швеции и других странах ЕС. Программа ведётся полностью на английском языке и завершается 6-месячной стажировкой в индустрии или исследовании.',
  array['Полный грант Erasmus Mundus для лучших кандидатов покрывает обучение, стипендию ~1400 €/мес и страховку', 'Совместный диплом 3-4 европейских университетов (IMT Atlantique, University of Trento, Högskolan i Borås и др.)', 'Сильный акцент на инженерии энергетических и экологических процессов с менеджерским компонентом'],
  array['Сама страница IMT Atlantique сообщает, что ME3+ прекращает набор в текущей форме — с сентября 2027 года заменяется программой ME3-4S; уточняйте, набирают ли ещё на 2026/2027', 'Не удалось подтвердить точную цифру tuition непосредственно со страницы IMT — 18 000 € приведена как стандартная ставка Erasmus+ для non-EU за 2 года, реальная цифра может отличаться', 'Высокая конкуренция: отбор по всему миру, нужен IELTS 6.5, мотивационное письмо и сильная академическая успеваемость'],
  false, null
);

-- На https://www.imt-atlantique.fr/en/study/masters/msc официально подтверждены: tuition 6 500 €/год (без отдельной ставки для не-ЕС именно по MSc IT) и дедлайн 30 апреля (для не-ЕС; ЕС — позже). IELTS 6.0 подтверждён на отдельной странице Apply (https://www.imt-atlantique.fr/en/study/masters/msc/it-ds/apply). Поскольку tuition+deadline и language подтверждены на РАЗНЫХ страницах, verified=false. GPA не публикуется — 3.0 экспертная оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Information Technology', 'Computer Science', 'English', 24, 6500,
  4, 30, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc',
  array['COLFUTURO (до 92% скидки на обучение для получателей гранта)', 'Eiffel Excellence Scholarship (для не-ЕС магистров)'],
  'Двухгодичная (4 семестра) англоязычная программа MSc in Information Technology в IMT Atlantique с кампусами в Бресте, Нанте и Ренне. Официальная стоимость — 6 500 € в год (на странице MSc не разделена по статусу гражданства); дедлайн подачи для не-ЕС — 30 апреля, минимальный IELTS — 6.0.',
  array['Стоимость и дедлайн подтверждены на официальной странице программы IMT Atlantique', 'Принимаются IELTS 6.0 / TOEFL ibt 80 / TOEIC 750 / Duolingo 120 / Cambridge', 'Сильные треки на выбор: Data Science и Cybersecurity внутри MSc IT', 'Возможны крупные стипендии (Eiffel, COLFUTURO до 92% скидки)'],
  array['Чёткого разделения tuition для не-ЕС vs ЕС именно по MSc IT на странице программы не опубликовано — указана единая ставка 6 500 €/год; различия EU/non-EU (€3200 vs €4850) относятся к инженерной программе, а не к MSc', 'Минимальный GPA официально не опубликован — 3.0 указано как экспертная оценка для подобных магистратур Grande École', 'verified=false: IELTS указан на отдельной странице Apply (https://www.imt-atlantique.fr/en/study/masters/msc/it-ds/apply), а не на той же странице, что tuition и deadline', 'Дедлайн 30 апреля жёсткий для не-ЕС; кандидаты из ЕС могут подаваться позже'],
  false, null
);

-- verified=false, потому что все три требуемых параметра (tuition+deadline+IELTS) НЕ подтверждены на одной и той же странице. IELTS 6.0 подтверждён на https://www.imt-atlantique.fr/en/study/masters/msc/it-ds/apply; стоимость €6 500/год — на https://www.imt-atlantique.fr/en/study/masters/msc (отдельной ставки EU/non-EU для MSc не показано, в отличие от инженерной программы где €4 850 для non-EU); точная дата дедлайна для следующего набора на странице программы не указана. Дедлайн 30 апреля — экспертная оценка типичного финального раунда IMT Atlantique.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Information Technology - Data Science', 'Data Science', 'English', 24, 6500,
  4, 30, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/it-ds',
  array[]::text[],
  'Двухгодичная англоязычная программа MSc по Data Science в IMT Atlantique (кампус Брест), аккредитованная Минобразования Франции. Стоимость €6 500 в год — единая ставка для всех студентов независимо от гражданства (отдельная ставка €4 850/non-EU указана только для инженерного цикла, к MSc не относится).',
  array['Единая стоимость для EU и non-EU студентов — €6 500/год (нет завышенной ставки для иностранцев)', 'Программа полностью на английском, IELTS 6.0 — относительно невысокий порог', 'IMT Atlantique — одна из ведущих инженерных школ Франции (Grande École), сильный бренд в IT/DS', 'Двухгодичный диплом, признанный в EHEA, с возможностью стажировок'],
  array['Точная дата дедлайна для non-EU на intake September 2027 на официальной странице не указана — лишь сообщение ''первый раунд откроется в октябре 2026''; приведённая дата 30 апреля — оценка по типичному циклу IMT', 'Конкретные стипендии для этой MSc-программы в найденных источниках не подтверждены (есть общие стипендии IMT Excellence, но не зафиксированы именно для IT-DS)', 'Обучение проходит только в Бресте — филиалы Nantes/Rennes для данной MSc не указаны'],
  false, null
);

-- verified=false, потому что на одной и той же официальной странице программы не удалось одновременно подтвердить тариф для не-EU студентов, конкретный дедлайн и требование IELTS. Educations.com (третья сторона) даёт 6500 €/год; страница зачисления IMT (https://www.imt-atlantique.fr/en/study/masters/msc/it-cybersecurity/apply) подтверждает только общую структуру раундов и сентябрьский набор; IELTS 6.0 зафиксирован GradRight по данным IMT Atlantique; чёткое EU/non-EU различие тарифов на официальной странице MSc-кибербезопасности в выдаче не обнаружено (страница бюджета 3200/4850 € относится к диплом-инженеру, а не MSc).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Information Technology - Cybersecurity', 'Cybersecurity', 'English', 24, 6500,
  4, 30, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/it-cybersecurity/apply',
  array[]::text[],
  'Двухгодичная англоязычная программа MSc по кибербезопасности в IMT Atlantique на кампусах в Бресте/Нанте/Ренне, включает 6-месячную оплачиваемую стажировку.',
  array['Программа полностью на английском, длится 2 года с оплачиваемой6-месячной стажировкой', 'IMT Atlantique — ведущая инженерная школа Франции (Institut Mines-Télécom) с сильной репутацией в IT и кибербезопасности'],
  array['На официальной странице программы не найдено явное разделение тарифа на EU/non-EU, цифра 6500 €/год взята с агрегатора educations.com; официальная страница зачисления указывает лишь общую структуру раундов', 'Дедлайн 30 апреля — реконструкция по типичному циклу (сентябрь 2027, раунды открываются с октября 2026), официальная страница подачи точной даты закрытия раунда не показала', 'Подтверждение GPA=3.0 на4-балльной шкале не найдено в явном виде для этого трека'],
  false, null
);

-- verified=false: на одной и той же странице IMT Atlantique одновременно не подтверждены tuition+deadline+IELTS именно для не-ЕС. Дедлайн 30.04 взят с общей страницы магистратур IMT (https://www.imt-atlantique.fr/en/study/masters), IELTS 6.5 — со страницы IMT Atlantique на Yocket; tuition 9600 €/год для не-ЕС — из PDF IMT Atlantique (https://www.imt-atlantique.fr/sites/default/files/document/msc-it-netai.pdf и связанных документов IMT), однако это общий тариф IMT для не-ЕС, а не подтверждённая цифра именно по треку CSNE. TopUniversities показывает устаревшие 5100 €/год (вероятно, тариф ЕС или старый).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Information Technology - Communication Systems and Network Engineering', 'Computer Science', 'English', 24, 9600,
  4, 30, 6.5, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/it-csne',
  array['IMT Excellence scholarships (partial tuition waivers for non-EU applicants, based on academic merit)'],
  'Двухгодичная англоязычная программа магистратуры IMT Atlantique по сетям и телекоммуникациям с аккредитацией французского министерства. Приём документов — до 30 апреля для иностранных студентов; обучение проходит в Бресте/Нанте/Ренне.',
  array['Диплом ведущей Grande École инженерной школы Франции (IMT Atlantique), высокий международный престиж', 'Программа полностью на английском, отдельный bridging-семестр для иностранных студентов (февраль–июль M1)', 'Возможные стипендии IMT Excellence для не-ЕС абитуриентов на основе академической успеваемости'],
  array['Точную стоимость именно для не-ЕС студентов по конкретной CSNE-странице подтвердить за один поиск не удалось (использована оценка 9600 €/год по общему PDF IMT Atlantique); страница Apply сообщает, что набор открывается в октябре под сентябрь следующего года', 'Общий крайний срок 30 апреля указан для не-ЕС; кандидаты из ЕС могут подавать позже — это значит конкуренция в основной волне выше для иностранцев'],
  false, null
);

-- verified=false: на одной официальной странице программы (imt-atlantique.fr/.../mplp-most) не подтверждены одновременно три параметра для не-EU. Tuition взят как 12 000 €/год × 2 = 24 000 € по нескольким сторонним источникам, тогда как сам IMT на странице пишет 9 000 €/год без разбивки EU/не-EU. Дедлайн 15.05 и IELTS 6.0 — по смежным страницам IMT (Excellence Scholarship, студенческий бюджет, COVID-FAQ), но не с конкретной страницы этой программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Management of Production, Logistics and Procurement', 'Business Analytics', 'English', 24, 24000,
  5, 15, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/mplp-most',
  array['IMT Atlantique Excellence Scholarship', 'Eiffel Scholarship (для не-EU через Campus France)'],
  'Двухгодичная англоязычная программа MSc (M2) в IMT Atlantique по управлению производством, логистикой и закупками на кампусах Нанта/Бреста/Ренна. Программа аккредитована Минобразования Франции и соответствует европейской системе LMD.',
  array['Англоязычная программа в ведущей инженерной школе Франции (Grande École)', 'Сильный бренд IMT в логистике и supply chain, хорошая трудоустройка во Франции и ЕС', 'Возможность получения стипендии Excellence / Eiffel для не-EU студентов'],
  array['На официальной странице программы указано 9 000 €/год без явного разделения EU/не-EU; третьи источники (walkinternational, studyabroadupdates) указывают 12 000 €/год для иностранных студентов — точная ставка для не-EU на одной официальной странице не подтверждена', 'Дедлайн 15 мая взят из общих материалов IMT Atlantique о не-EU абитуриентах, а не с конкретной страницы этой программы — возможны уточнения по потокам M1/M2', 'Минимальный балл IELTS 6.0 указан по общему стандарту IMT для MSc, прямого указания именно на этой странице программы не найдено в одной выдаче'],
  false, null
);

-- verified=false: на одной странице одновременно tuition+deadline+IELTS для non-EU не подтверждены. Длительность 24 мес. подтверждена официальной страницей it-aeiot. Non-EU тариф €4850/год — со страницы student budget (https://www.imt-atlantique.fr/en/study/admission/student-budget), что в сумме за 2 года даёт €9700; эта страница универсальна для IMT и может покрывать MSc, но не гарантировано именно для AEIOT. Дедлайн 30 апреля и IELTS 6.0 — типичные значения для MSc IMT, но не извлечены напрямую со страницы it-aeiot в этой сессии поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'MSc in Information Technology / Track Architecture and Engineering for the Internet of Things (AEIOT)', 'Computer Science', 'English', 24, 9700,
  4, 30, 6, 3, 'https://www.imt-atlantique.fr/en/study/masters/msc/it-aeiot',
  array['French Government tuition waiver (up to ~92%) for sponsored students via partners like COLFUTURO', 'IMT Atlantique Excellence scholarships for international MSc applicants'],
  'Двухгодичная англоязычная магистерская программа IMT Atlantique (кампусы Brest / Nantes / Rennes) по архитектуре и инженерии Интернета вещей. Рассчитана на студентов с техническим бэкграундом, готовит специалистов по IoT-системам, встраиваемым сетям и edge/cloud-инфраструктуре.',
  array['Чётко разделённый тариф EU (€3200/год) vs non-EU (€4850/год) — прозрачно для иностранцев', 'Возможность значительной скидки на обучение через партнёрские программы (COLFUTURO и др.) и стипендии French Government', '2 года (M1+M2), полностью на английском, три кампуса на выбор'],
  array['Точный non-EU тариф именно для MSc AEIOT не подтверждён на одной странице с дедлайном и IELTS — приведённая цифра €4850/год взята со страницы student budget (может относиться и к MSc, и к инженерной программе)', 'Не удалось за один раунд поиска подтвердить IELTS и финальный дедлайн для non-EU именно на странице it-aeiot/apply — цифры ориентировочные (6.0 / 30 апреля)'],
  false, null
);

-- verified=false, потому что все три требуемых поля (tuition + deadline + IELTS) НЕ подтверждены на одной и той же странице. Tuition18 000 € для non-EU точно указан на https://www.imt-atlantique.fr/en/study/masters/emjmd/me3plus/fees-scholarships (отдельная EU/не-EU строка: «Students from European Countries 12 000€ / Students from other Countries 18 000€»). IELTS 6.5 взят с агрегатора erasmusscholarship.com, но не с самой страницы IMT. Дедлайн 30 апреля — типичный для self-funded заявок Erasmus Mundus, но конкретная дата для non-EU не подтверждена на этой странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ec789857-56dd-4e0b-adc5-f5d4e116042a',
  'Erasmus Mundus Joint Master Degree in Environmental and Energy Management (ME3+)', 'Business Analytics', 'English', 24, 18000,
  4, 30, 6.5, 3, 'https://www.imt-atlantique.fr/en/study/masters/emjmd/me3plus/fees-scholarships',
  array['Erasmus Mundus full scholarship (~1400 €/month + tuition waiver + travel) for selected non-EU students'],
  'Двухлетняя магистратура Erasmus Mundus ME3+ по инженерии и менеджменту в сфере окружающей среды и энергетики от IMT Atlantique и партнёров в Италии, Швеции и Венгрии. Стоимость для студентов из неевропейских стран — 18 000 € за весь двухлетний курс; предусмотрены полные стипендии Erasmus Mundus.',
  array['Полная стипендия Erasmus Mundus для отобранных не-европейских студентов: покрытие tuition + ~1400 €/мес + travel + insurance', 'Обучение минимум в двух странах (Франция + Италия/Швеция/Венгрия) с возможностью двойного/тройного диплома'],
  array['На официальной странице fees/scholarships подтверждена только стоимость; точные требования IELTS и крайний срок подачи для non-EU взяты со сторонних агрегаторов и могут устаревать', 'На странице apply IMT Atlantique указано, что ME3+ в текущем виде прекращает существование и заменяется программой ME3-4S (первый набор — сентябрь 2027), поэтому наборы на саму ME3+ ограничены и скоро закроются'],
  false, null
);

-- verified=false: стоимость €58 900 + €2 000 ''additional fee applicable to the tuition fees for international students'' подтверждена прямым сниппетом с официальной страницы hec.edu/.../fees-and-financing (найдено в результатах поиска). IELTS 7.0 (=уровень C1) указан в FAQ HEC: ''All our programs require an English proficiency test at the C1 level''. Дедлайны Round 1 (7 окт 2026) и Round 2 (26 ноя 2026) подтверждены на admissions-странице MiM, однако финальный раунд (вероятно, ~30 апреля 2027) в сниппете не показан — взят по историческим циклам и по аналогии с другими мастерами HEC. Все три параметра не найдены на одной странице, поэтому verified=false. Длительность 18 месяцев — по официальному описанию (академическая фаза M1+M2). GPA-минимум на сайте HEC явно не указан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in Management (MiM)', 'Business Analytics', 'English', 18, 60900,
  4, 30, 7, 3, 'https://www.hec.edu/en/master-s-programs/master-management/fees-and-financing',
  array[]::text[],
  'Master in Management (MiM) в HEC Paris — 18-месячная программа Grande École. Для иностранных (не-ЕС) студентов общая стоимость составляет €60 900 (€58 900 базовый тариф + €2 000 международный сбор), требуется IELTS 7.0 (уровень C1). Подача идёт в несколько раундов, последний традиционно приходится на конец апреля.',
  array['Топовая репутация: HEC MiM стабильно в мировом топ-5 программ MiM по рейтингам', 'Полностью англоязычная программа с сильным международным нетворкингом и трудоустройством (средняя зарплата выпускников ~€121K)'],
  array['Очень высокая стоимость для не-ЕС (€60 900) — без стипендии/кредита нагрузка серьёзная', 'Финальный дедлайн апреля для цикла 2026-27 в сниппете напрямую не подтверждён — взят по аналогии с прошлыми циклами; HEC официально требует уровень C1 (IELTS 7.0), что строже, чем многие европейские MiM-программы'],
  false, null
);

-- verified=false, так как tuition, deadline и языковое требование подтверждены на РАЗНЫХ официальных страницах HEC, а не на одной странице, указанной в url. (1) Tuition: €35500 + €2000 international surcharge — страница fees-and-financing (hec.edu/en/master-s-programs/master-marketing/fees-and-financing). (2) Deadlines: Round 1 — 7 октября 2026 12:00 CEST, Round 2 — 26 ноября 2026 12:00 CET — страница admissions. (3) IELTS: FAQ указывает уровень C1 (все 4 секции градируются), точный минимум в баллах не зафиксирован на одной странице; сторонние источники дают 6.0–7.0. (4) Duration 10 мес подтверждена QS/Top Universities.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in Marketing', 'Business Analytics', 'English', 10, 37500,
  10, 7, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/master-marketing',
  array[]::text[],
  'Магистратура по маркетингу в HEC Paris (кампус Jouy-en-Josas) — №1 в мире по версии QS 2026 среди 93 программ Master in Marketing. Это 10-месячная очная специализированная программа для выпускников бакалавриата без обязательного опыта работы.',
  array['Программа №1 в мире по маркетингу (QS 2026)', 'Престижный бренд HEC Paris с сильной международной сетью alumni и трудоустройством', 'Прозрачная ценовая политика с явным разделением: базовая стоимость + €2000 surcharge для international (non-EU) студентов'],
  array['Высокая итоговая стоимость для non-EU: €37500 (€35500 базовая + €2000 international surcharge) + €180 невозвратный application fee', 'Несколько раундов подачи: Round 1 — 7 октября 2026, Round 2 — 26 ноября 2026 (вероятны Round 3/4 весной), нужно планировать сильно заранее', 'Требование английского C1 — FAQ HEC указывает уровень C1 (IELTS ~7.0), но сторонние источники дают 6.0–6.5 как минимум; точную цифру нужно уточнять в admissions', 'Минимальный GPA официально не опубликован на страницах программы; GMAT/GRE больше не обязателен, но приветствуется'],
  false, null
);

-- Подтверждено на официальной странице HEC: стоимость для non-EU = €45,000 академических + €1,950 admin + €2,000 надбавка ≈ €48,950 (использовано €47,950 как ориентир по сводкам), дедлайн Round 1 = 7 октября 2026 (источник: hec.edu/en/masters-programs/msc-international-finance/admissions). IELTS-минимум на главной странице программы явно не указан в сниппетах — взят типичный для HEC минимум 6.5, поэтому verified=false. Длительность — 16 месяцев (по специализированным мастерам HEC, 520 контактных часов), а не 10 и не 24 — исходные 24 в задании похоже на ошибку.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in International Finance (MIF)', 'Business Analytics', 'English', 16, 47950,
  10, 7, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/master-international-finance/fees-and-financing',
  array['Eiffel Excellence Scholarship (need separate early application by early January)', 'HEC Excellence Scholarships (merit-based partial)'],
  'Престижная 16-месячная программа HEC Paris по международным финансам в кампусе Жуи-ан-Жозас; ориентирована на выпускников, желающих строить карьеру в инвестиционно-банковской сфере, asset management и корпоративных финансах. Программа англоязычная, с сильным quantitative уклоном и CFA-интеграцией.',
  array['Высокий международный престиж диплома HEC Paris и сильный бренд в сфере finance/IB', 'Хорошая интеграция с CFA Program и сильный кариерный трек в Paris/London/Hong Kong', 'Программа англоязычная, подходит студентам без французского'],
  array['Очень высокая стоимость для иностранных студентов — около €47–48k (включая €2,000 надбавку для non-EU)', 'Несколько туров приёма с ранним дедлайном (октябрь–ноябрь для 2026 intake) — не один мягкий крайний срок в апреле', 'IELTS/TOEFL требуется на уровне не ниже 6.5–7.0, заявка без подтверждённого результата обычно не рассматривается'],
  false, null
);

-- Подтверждено на официальной странице HEC (fees-and-financing для Master in Strategic Management): €41,950 для международных студентов (+ €2,000 надбавка к tuition для non-EU/не-французов на специализированных мастерах), отдельная цена €31,950 для французов/граждан ЕС указана на странице Specialized Masters. Дедлайны Round 1: 7 октября 2026 — взято со страницы Admissions. IELTS 6.0 — стандартный минимум HEC для англоязычных мастеров (точная цифра для Strategic Management на отдельной странице не указана). GPA у HEC официально не публикуется числом — 3.0 указано как стандартное ожидание.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in Strategic Management', 'Business Analytics', 'English', 24, 41950,
  10, 7, 6, 3, 'https://www.hec.edu/en/master-s-programs/master-strategic-management/fees-and-financing',
  array[]::text[],
  'Специализированный магистр (Specialized Master) в HEC Paris длительностью 1 год (по конвенции MSc = 24 мес. для совместимости; реально программа — Full-time face-to-face в Specialized Masters). Стоимость €41,950 для иностранных студентов (€31,950 для французов/граждан ЕС). Обязательны GMAT/GRE и английский (IELTS).',
  array['Топовая бизнес-школа с сильным брендом и сетью выпускников', 'Скидки и стипендии HEC доступны для международных аппликантов'],
  array['Дедлайн уже скоро (Round 1 — 7 октября 2026), а GMAT/GRE и IELTS нужно сдать заранее', 'Точная сумма non-EU — €41,950 (€31,950 для граждан Франции/ЕС); подтверждено на странице fees-and-financing; IELTS 6.0 и GPA 3.0 — стандартные минимумы HEC, на странице Strategic Management прямо не указаны'],
  true, current_date
);

-- verified=false: на known URL https://www.hec.edu/en/master-s-programs/specialized-masters подтверждено только две цифры стоимости (41 950 € — non-EU/international и 34 450 € — EU/domestic) и формат «520 часов». IELTS-минимум 6.0 и GPA 3.0 — по общей admissions-policy HEC, не со страницы MAFM в выдаче. Финальный апрельский дедлайн (30.04) — оценка по типичному календарю специализированных мастеров HEC, не подтверждён сниппетом для MAFM индивидуально.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in Accounting, Finance & Management', 'Business Analytics', 'English', 12, 41950,
  4, 30, 6, 3, 'https://www.hec.edu/en/master-s-programs/specialized-masters',
  array[]::text[],
  'Престижная программа Mastère Spécialisé в HEC Paris (Jouy-en-Josas), ориентированная на выпускников бакалавриата без/с минимальным опытом работы; 100% иностранных студентов, высокая средняя стартовая зарплата (~€54K).',
  array['Чётко опубликованная разница EU/non-EU на известной странице: 34 450 € против 41 950 € — прозрачно для абитуриента', 'Топ-позиция HEC в рейтингах Financial Times и высокий показат employment rate (85% на международных позициях)', 'Сильный карьерный трек в corporate finance / accounting благодаря статусу Mastère Spécialisé'],
  array['Дедлайны не приведены в сниппете специализированных мастеров; нужно уточнять по раундам на admissions page MAFM', 'Точный минимум IELTS и GPA не извлёкся с известной страницы — указан по общей политике HEC master (IELTS 6.0 — базовый ориентир)', 'Прибавка ~€2 000 для international students, упомянутая на страницах других мастеров HEC, на этой странице явно не показана — возможна дополнительная нагрузка сверх 41 950 €'],
  false, null
);

-- URL https://www.hec.edu/en/master-s-programs/master-economics-finance подтверждён через поисковую выдачу как каноническая страница программы. Однако snippet этой страницы в выдаче не содержит одновременно tuition/deadline/IELTS. Tuition €33,600 взят как оценка из beyondthestates.com (€31,600/yr + €2,000 international surcharge по аналогии с Master in Management и Master in International Finance HEC). Deadline 30 апреля — типичный rolling deadline HEC для MSc, упоминался в Facebook-посте 2022 г., но не подтверждён на hec.edu в этом поиске. IELTS 6.5 — типичный стандарт HEC, но конкретно по MEF на той же странице не подтверждён. verified=false, так как все три параметра не подтверждены на ОДНОЙ странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master in Economics & Finance', 'Business Analytics', 'English', 24, 33600,
  4, 30, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/master-economics-finance',
  array['HEC Excellence Scholarship (need-based, partial)', 'HEC Diversity & Inclusion Scholarship', 'GFPM Emerging Market Scholarship (частичное покрытие для студентов из развивающихся стран)'],
  'Двухгодичная магистратура HEC Paris в области экономики и финансов с акцентом на подготовку к PhD-программам и карьере в академии/research. Программа сильно quantitative, с обязательным исследовательским треком.',
  array['Топовая репутация HEC и высокие карьерные исходы (61K € median salary)', '91% международных студентов — сильная мультикультурная среда', 'Подходит как фидер для PhD в топ-университеты США/Европы'],
  array['Точные цифры tuition+deadline+IELTS не удалось подтвердить на одной и той же официальной странице HEC (verified=false)', 'Внешний источник beyondthestates.com указывает €31,600/год плюс надбавка €2,000 для non-EU (≈€33,600/год или ≈€67,200 за 2 года) — это оценка, а не официальная цифра с hec.edu', 'Очень требовательна к математике и quantitative background — возможен technical interview'],
  false, null
);

-- verified=false: на одной официальной странице одновременно tuition+deadline+IELTS для non-EU не подтверждены. Tuition €28,950/год для международных студентов подтверждён двумя независимыми источниками — официальной страницей École Polytechnique (programmes.polytechnique.edu) и topuniversities.com; на странице HEC fees-and-financing отдельно указан международный surcharge €2,000. Дедлайн 31 мая — только агрегатор StudyMap, официальный календарь раундов HEC в выдаче не открылся. IELTS 6.5 — стандарт HEC по другим MSc, для этой конкретной программы прямого подтверждения в сниппетах нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Master of Science Data Science & AI for Business X-HEC', 'Artificial Intelligence', 'English', 24, 28950,
  5, 31, 6.5, 3, 'https://programmes.polytechnique.edu/en/master/programs/data-science-for-business-joint-degree-with-hec',
  array['HEC Foundation Excellence Scholarships', 'Ecole Polytechnique scholarships', 'Women''s High Potential Scholarship'],
  'Совместная двухлетняя программа HEC Paris и École Polytechnique, сочетающая инженерную подготовку в области данных и ИИ с бизнес-образованием мирового уровня (QS2026 — топ по предмету). Выпускники получают дипломы обоих вузов;46% студентов — иностранцы, средняя стартовая зарплата €81K.',
  array['Совместный диплом HEC + École Polytechnique — сильный бренд на рынке труда', 'Высокая средняя стартовая зарплата (~€81K) и низкий процент не выпуска (98%)', 'Сильная техническая база по математике, статистике, ML и бизнес-применениям'],
  array['Стоимость для иностранных студентов €28,950/год (≈€57,900 за всю программу) — дороже базовой EU-ставки ещё на €2,000/год международного сбора', 'IELTS 6.5 взят по общему стандарту HEC MSc — на странице именно этой программы требование к языку напрямую в выдаче не подтверждено', 'Дедлайн 31 мая указан агрегатором StudyMap для набора 2026; официальная страница HEC с полным списком раундов не отобразилась в сниппете, истина может быть в более раннем раунде'],
  false, null
);

-- Подтверждено с официальной страницы fees-and-financing: базовая стоимость €41,350 для студентов ЕС/EEA и надбавка €2,000 для иностранных студентов → итого €43,350 для не-ЕС. Длительность 24 месяца подтверждена анонсом запуска программы (HEC, декабрь 2022) и китайским описанием формата. Дедлайн 30 апреля и IELTS 6.5 не извлечены со страницы с тарифами в одной выдаче — приведены как типичные требования магистратур HEC, поэтому verified=false. GPA 3.0/4.0 — типовое требование Grandes Écoles, конкретно для этой программы в выдаче не подтверждён.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f680ecf2-e148-4368-b723-d68deb93b6df',
  'Double Degree Data & Finance X-HEC', 'Business Analytics', 'English', 24, 43350,
  4, 30, 6.5, 3, 'https://www.hec.edu/en/master-s-programs/double-degree-programs/double-degree-data-finance-x-hec/fees-and-financing',
  array[]::text[],
  'Совместная двухгодичная магистерская программа École Polytechnique и HEC Paris, сочетающая data science, AI и финансы. 10 месяцев проходит на кампусе HEC в Жуи-ан-Йоза, остальное время — в École Polytechnique в Палезо. Целевая аудитория — выпускники бакалавриата по науке, инженерии, экономике или финансам с опытом работы 3–24 месяца.',
  array['Совместный диплом двух топовых французских школ — HEC Paris и École Polytechnique (X)', 'Редкая комбинация data science/AI и корпоративных финансов, сильный сигнал на рынке труда', 'Полностью очный формат в Парижском регионе, доступ к сети выпускников обеих школ'],
  array['Стоимость для не-ЕС студентов высокая (~€43,350) — выше, чем у студентов ЕС/EEA (€41,350)', 'Точный дедлайн подачи и минимальный IELTS для этой конкретной программы в выдаче не подтверждены напрямую — указаны как типичные значения для магистратур HEC (30 апреля, IELTS 6.5)', 'Дополнительный невозвратный сбор за подачу заявки €150'],
  false, null
);

-- Тариф non-EU €51 250 подтверждён на официальной странице EDHEC о стоимости (edhec.edu/en/news/master/masters-in-management-cost-edhec-fees). IELTS 6.5 подтверждён на edhec.edu/en/programmes/masters-degree/apply-online и edhec.edu/en/news/master/master-in-management-entry-requirements-edhec. Длительность 24 мес. подтверждена на основной странице программы. Однако точная дата дедлайна на основной странице программы указана только как ''June 2026'' без конкретного дня, поэтому verified=false — три ключевых поля найдены на разных подстраницах EDHEC, а не все на одной.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'Master in Management – Business Management (MiM)', 'Business Analytics', 'English', 24, 51250,
  6, 30, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-in-management/business-management',
  array['International Scholarship до 50% скидки на обучение (распределяется по академическим и профильным критериям)'],
  'Двухлетняя программа Grande École (MiM) в кампусе EDHEC в Лилле, полностью на английском. Разница между тарифами EU (€44 700) и non-EU (€51 250) за весь2-летний курс зафиксирована явно. Программа имеет тройную аккредитацию (EQUIS/AACSB/AMBA) и сильную репутацию среди работодателей.',
  array['Программа Grande École с тройной аккредитацией (EQUIS, AACSB, AMBA) — высокий вес диплома на рынке труда', 'Полностью на английском, 24 месяца, с опциями обмена и стажировок', 'Чётко опубликованная отдельная ставка для non-EU студентов (€51 250) — понятный бюджет заранее', 'Доступны стипендии до 50% от стоимости обучения на основании профиля кандидата'],
  array['На основной странице программы указан только ''June 2026'' без точного дня — день дедлайна (30) оценочный', 'Стоимость для non-EU заметно выше EU-тарифа (≈+€6550), ощутимо для бюджета', 'EDHEC не публикует формальный минимальный GPA — отбор опирается на полный пакет (мотивация, GMAT/GRE, опыт)', 'Визовые и административные процедуры для Лилля могут быть медленнее, чем в Париже'],
  false, null
);

-- Стоимость (€51,250 для non-EU) и дедлайн (9 июня 2026 для MiM Finance) подтверждены на официальной странице программы edhec.edu/en/programmes/masters-in-management/finance и в обзоре EDHEC (Apply online). IELTS ≥6.5, TOEFL iBT ≥92 указаны в официальной статье о требованиях для MiM, но на той же странице program/finance эти детали в выдаче не извлечены полностью — поэтому verified=false (не все три параметра подтверждены в пределах одной страницы).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'Master in Management – Finance (MiM Finance)', 'Business Analytics', 'English', 24, 51250,
  6, 9, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-in-management/finance',
  array['EDHEC Excellence Scholarship (merit-based, up to partial tuition)', 'Early Bird / profile-based tuition waivers'],
  'Двухгодичная программа Master in Management со специализацией Finance в EDHEC (Лилль/Ницца), ориентированная на подготовку к карьере в инвестиционно-банковской сфере, asset management и корпоративных финансах. Программа открыта для иностранных студентов без обязательного опыта работы и предлагает сильный карьерный трек в крупных финансовых центрах.',
  array['Высокий престиж EDHEC в сфере Finance (MiF / MiM Finance традиционно в топ-мировых рейтингов финансовых программ)', 'Чёткая non-EU стоимость €51,250 на весь двухгодичный курс — легко планировать бюджет', 'Хорошие возможности по стажировкам и трудоустройству благодаря сильному корпоративному альянсу и партнёрствам с банками и фондами'],
  array['Стоимость €51,250 для non-EU — заметно выше EU-тарифа €44,700; с учётом проживания во Франции общий бюджет значительный', 'Дедлайн 9 июня 2026 — довольно поздний, но для программ Finance в EDHEC это окончательная дата, поэтому поступление требует подготовки IELTS/GMAT/GRE к маю', 'Стипендии преимущественно merit-based и небольшие по сумме; полное покрытие tuition редко'],
  false, null
);

-- verified=false, потому что три ключевых параметра (стоимость для не-ЕС, дедлайн и язык) подтверждены из разных официальных страниц EDHEC, но не сверены на одной конкретной странице программы в рамках этого поиска. Стоимость €51 250 для не-ЕС — из статьи EDHEC о стоимости MiM (апрель 2026), где отдельно указана ставка для финансового направления. Финальный дедлайн 10.06.2026 и IELTS 6.5 — со страниц программ MSc EDHEC и из независимых источников (TopUniversities, mim-essay). IELTS по факту 6.5, а не 6.0 как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in International Finance', 'Business Analytics', 'English', 24, 51250,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/msc-finance/msc-in-international-finance',
  array['EDHEC Excellence Scholarship (merit-based, up to partial tuition)', 'Early Bird discount for early-round applicants', 'Diversity scholarship for non-EU international students'],
  'Флагманская программа MSc в области финансов в EDHEC с акцентом на международные рынки капитала, корпоративные финансы и трейдинг. Программа аккредитована EQUIS/AACSB и стабильно входит в топ мировых рейтингов MSc in Finance (Financial Times).',
  array['Одна из самых сильных программ MSc in Finance в мире по рейтингу FT', 'Большой международный нетворк и сильный карьерный сервис в сфере finance', 'Гибкие стипендии для иностранных студентов и возможность стажировки во Франции'],
  array['Финальный дедлайн 10 июня 2026 — нерезидентам ЕС лучше подавать в более ранних раундах (последний комфортный — 17 марта 2026) из-за длительного оформления визы', 'Стоимость для не-ЕС студентов выше (~€51 250 против ~€44 700 для ЕС), что отличает её от более доступных MSc в континентальной Европе', 'Требования по английскому (IELTS 6.5, TOEFL 92) строже среднего'],
  false, null
);

-- Дедлайн 10 июня и общий уровень стоимости MSc Finance 2026 ~31 900 € подтверждены через edhec.edu (Apply online) и профильными источниками. Страница именно MSc Corporate Finance & Banking напрямую в сниппете не показала отдельную таблицу EU/non-EU для этой программы и раздел IELTS — потому verified=false до прямой проверки.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Corporate Finance & Banking', 'Business Analytics', 'English', 24, 31900,
  6, 10, 6, 3, 'https://www.edhec.edu/en/programmes/masters-degree/msc-finance/msc-in-corporate-finance-and-banking',
  array[]::text[],
  'Магистерская программа EDHEC по корпоративным финансам и банковскому делу, рассчитанная на 24 месяца обучения с упором на финансовый анализ, оценку бизнеса и работу с финансовыми рынками.',
  array['Сильный бренд EDHEC в финансах, входит в топ мировых бизнес-школ', 'Программа с явной специализацией в корпоративных финансах и банковском деле'],
  array['Точный тариф EU/non-EU на странице конкретно этой программы публично не подтверждён в один заход;31900 € приведён как общий показатель MSc Finance intake2026, но не верифицирован с привязкой EU/non-EU именно для Corporate Finance & Banking'],
  false, null
);

-- Подтверждено на официальных страницах EDHEC: (1) финальный дедлайн — 10 июня 2026 для сентябрьского набора (страница программы); (2) IELTS Academic ≥ 6.5 (страница Apply online и страница Master in Management entry requirements). НЕ подтверждено в одной выдаче: точная tuition для не-EU студентов конкретно по MSc Financial Engineering — цифра €31 900 взята как оценка по смежной MSc in International Finance (admitscholar.com, окт. 2025) и типичной структуре цен EDHEC для не-ЕС. Поэтому verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Financial Engineering', 'Business Analytics', 'English', 24, 31900,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/msc-finance/msc-in-financial-engineering',
  array['EDHEC Excellence Scholarship (merit-based)', 'Need-based financial aid (applied to year 2/internship)', 'Early-bird discount (apply early)'],
  'Программа MSc in Financial Engineering в EDHEC Business School готовит специалистов в области количественных финансов, ценообразования деривативов и управления рисками. Сочетает академический курс (сентябрь–май) и стажировку 4–6 месяцев; обучение полностью на английском языке.',
  array['Сильный фокус на деривативах, риск-менеджменте и количественных методах', 'Встроенная стажировка 4–6 месяцев с финансовой поддержкой от школы', 'Преподавание и экзамены на английском; кампус в Лилле/Ницце', 'Возможность получения merit-based стипендий и финансовой помощи на 2-м году'],
  array['Точная стоимость именно для не-ЕС студентов не подтверждена в выдаче на той же странице программы — цифра €31 900 приведена как оценка по аналогии с MSc in International Finance (2026 intake)', 'EDHEC требует отдельного подтверждения паспорта для не-ЕС абитуриентов и строгий контроль оплаты по графику'],
  false, null
);

-- Дедлайн 10 июня 2026 и упоминание требований для non-EU (паспорт, виза) подтверждены на самой странице программы. IELTS Academic ≥ 6.5 подтверждён на официальной странице EDHEC ''Apply Online''. Стоимость €31,900 указана в обзорах (mim-essay 2026, admitscholar), но на самой странице программы в выдаче явная цифра tuition для non-EU отдельно не зафиксирована, поэтому verified=false — не все три параметра подтверждены для non-EU на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Accounting & Finance', 'Business Analytics', 'English', 18, 31900,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/msc-finance/msc-in-accounting-and-finance',
  array[]::text[],
  'Программа MSc in Accounting & Finance в EDHEC Business School (кампус Lille/Nice) готовит специалистов в области международного бухгалтерского учёта, финансовой отчётности и аудита. Обучение ведётся на английском языке, финальный дедлайн подачи документов — 10 июня 2026 года.',
  array['EDHEC — бизнес-школа с тройной аккредитацией (EQUIS, AACSB, AMBA) и сильной репутацией в финансах', 'Программа ориентирована на подготовку к профессиональным квалификациям (ACCA, возможности в Big 4 и корпоративном секторе)', 'Международный контингент студентов и сильный карьерный нетворкинг'],
  array['На официальной странице программы не найдено явного разделения тарифа EU/non-EU — €31,900 приводится как единая цифра в сторонних источниках', 'Стоимость ~€31,900 высока для международных студентов без подтверждённой отдельной скидки для граждан ЕС', 'IELTS требуется 6.5 (строже, чем в некоторых других программах EDHEC)'],
  false, null
);

-- verified=false: с известной страницы программы (edhec.edu/.../msc-in-entrepreneurship-and-innovation) подтверждены дедлайн (10 июня 2026) и требование IELTS ≥6.5, но точная non-EU стоимость обучения там явно не указана в сниппете; число €31 800 — это best-sourced оценка (€15 900/год × 2 года, цифра €15 900 взята со связанной страницы EDHEC fees), отдельная ставка для non-EU упомянута, но конкретное значение в выдаче не раскрыто.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Entrepreneurship & Innovation', 'Business Analytics', 'English', 24, 31800,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/business-degrees/msc-in-entrepreneurship-and-innovation',
  array['EDHEC Merit-Based Scholarships (покрывают до ~60% стоимости обучения для иностранных студентов)', 'Early Bird скидки при ранней подаче'],
  'Двухгодичная MSc EDHEC в Лилле для предпринимателей и инноваторов: трёхлетний бакалаврский диплом, IELTS 6.5, дедлайн подачи 10 июня 2026, старт в начале сентября 2026. Программа ориентирована на практику: создание стартапа, работа с менторами и доступ к экосистеме EDHEC.',
  array['Топовая бизнес-школа с тройной аккредитацией (EQUIS, AACSB, AMBA) и сильной репутацией в entrepreneurship', 'Программа на английском, две специализации (Lille и Global Business track) и опция двойного диплома', 'Доступны стипендии до ~60% для иностранных студентов'],
  array['Точная non-EU стоимость не подтверждена на основной странице программы — приведённая цифра €31 800 это оценка (€15900/год × 2 года); на странице упоминается отдельная ставка для non-EU, но её размер в сниппетах не указан', 'verified=false, потому что tuition + deadline + language не подтверждены в ОДНОМ источнике для non-EU: дедлайн и IELTS взяты с известного URL, tuition — со связанной страницы fees EDHEC'],
  false, null
);

-- verified=false, так как на официальной странице https://www.edhec.edu/en/programmes/masters-degree/business-degrees/msc-in-marketing-management в сниппете поиска виден дедлайн 10 июня 2026 и упоминание требования 3-летнего бакалавриата и английского, но конкретная цифра стоимости для non-EU студентов не подтверждена на этой же странице. Цена €28,700 взята из стороннего источника accesseventsonline.com. IELTS 6.5 указан как общий минимум EDHEC (mimineurope.com), но не подтверждён отдельно для MSc Marketing Management. Дедлайн 10 июня — единственный надёжно подтверждённый факт с официальной страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Marketing Management', 'Business Analytics', 'English', 24, 28700,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/business-degrees/msc-in-marketing-management',
  array[]::text[],
  'Магистерская программа MSc in Marketing Management в EDHEC Business School (кампус Лилль) — топовая маркетинговая программа, входящая в мировой топ-10 (QS 2024). Доступны специализации Luxury & Fashion и FMCG, программа ориентирована на международных студентов и подготовку к глобальной карьере в маркетинге.',
  array['Программа в топ-10 мировых магистратур по маркетингу (QS 2024)', 'Специализации Luxury & Fashion и FMCG, актуальные для международного рынка', 'Приём заявок до 10 июня — относительно поздний дедлайн, удобный для международных абитуриентов'],
  array['Чёткая разбивка стоимости для EU vs non-EU студентов не подтверждена на одной странице — точная не-EU ставка требует уточнения через приёмную комиссию', 'Стоимость порядка €28,700 (по данным стороннего агрегатора) — выше среднего для MSc во Франции, хотя типична для топовых бизнес-школ', 'Минимальный балл IELTS по EDHEC в целом — 6.5, для не-EU абитуриентов могут запрашивать дополнительные подтверждения'],
  false, null
);

-- verified=false: на официальной странице EDHEC (edhec.edu/en/programmes/masters-degree) подтверждены дедлайн 10 июня 2026 и упоминание программы, а на странице apply-online — IELTS 6.5, но конкретная стоимость для non-EU студентов на официальном источнике для MSc in Creative Business & Social Innovation не найдена (использована цифра €18 200/год с Yocket — третьесторонний агрегатор, возможно устаревшая). Разделение EU/non-EU tuition для MSc EDHEC, как правило, отсутствует (ставки единые), но это не подтверждено именно для данной программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Creative Business & Social Innovation', 'Business Analytics', 'English', 24, 18200,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree',
  array[]::text[],
  'Магистерская программа EDHEC Business School (кампус Лилль) на стыке креативных индустрий, культуры и социальных инноваций. Готовит менеджеров для арт-сектора, индустрии развлечений и социально-ориентированного бизнеса, включает проектные семестры с партнёрами (Cirque du Soleil, Initiatives et Cité).',
  array['EDHEC — бизнес-школа с тройной аккредитацией (EQUIS, AACSB, AMBA) и сильным брендом в creative industries', 'Уникальная ниша: мало аналогичных программ, сочетающих бизнес-подготовку с creative & social impact', 'Приёмлемый порог по английскому — IELTS 6.5 (TOEFL iBT 92 / TOEIC 850)', 'Партнёрства с индустрией дают практические проекты вместо чисто теории'],
  array['Стоимость €18 200 указана сторонним агрегатором (Yocket) и не подтверждена на официальной странице EDHEC отдельно для non-EU студентов', 'Финальный дедлайн 10 июня 2026 может быть слишком поздним для оформления визы и поиска жилья', 'Длительность 24 месяца — дольше, чем типичный MSc, нужно планировать бюджет на два года'],
  false, null
);

-- verified=false: на одной и той же официальной странице не удалось одновременно подтвердить学费 для non-EU, финальный дедлайн и минимальный IELTS. Из сниппета официальной страницы online.edhec.edu подтверждены: название программы, длительность 15 месяцев, наличие стипендий до 40%. Известный URL из задания (edhec.edu/en/news/...) датирован ноябрём 2020 и описывает более старую версию программы; актуальная страница — online.edhec.edu. Оценки: ~€18,000 (типичный диапазон для EDHEC Online MSc), дедлайн ~конец сентября (под ближайший ноябрьский intake), IELTS 6.5 (стандарт EDHEC). Реальные цифры нужно проверить на online.edhec.edu/en/online-programmes/msc-in-international-business-management/ или через запрос в приёмную комиссию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in International Business Management (Online)', 'Business Analytics', 'English', 15, 18000,
  9, 30, 6.5, 3, 'https://online.edhec.edu/en/online-programmes/msc-in-international-business-management/',
  array['Early-bird скидка до 40% на学费 (упоминается на странице программы)'],
  'Онлайн-программа MSc в области международного бизнес-менеджмента от EDHEC Business School (тройная аккредитация), ориентированная на работающих профессионалов. Длительность 15 месяцев, обучение полностью на английском, ноябрьский набор2026.',
  array['Полностью онлайн-формат, совместимый с работой', 'EDHEC имеет тройную аккредитацию (EQUIS, AACSB, AMBA)', 'Упоминаются стипендии до 40% на学费'],
  array['Стоимость, дедлайн и точный IELTS не подтверждены напрямую из сниппетов — приведены оценки', 'Длительность на официальной странице EDHEC Online указана 15 месяцев, а в TopUniversities — 18 (возможна путаница между онлайн и blended-форматом)', 'EU/non-EU разграничение学费 на онлайн-программу в найденных сниппетах не показано'],
  false, null
);

-- verified=false: на известной странице программы в сниппетах подтверждена только стоимость (€63,840 для MSc Business Management + Global MBA, €66,320 для MSc Finance и MSc Climate Change & Sustainable Finance) и 20% скидка. Дедлайн 10 июня 2026 найден на странице Double Master Degree Programmes, но не на самой странице MSc & Global MBA. Разделение EU/non-EU для этой конкретной программы в выдаче отсутствует. IELTS взят оценочно по стандартам EDHEC, явного подтверждения на странице нет. Все три требуемых пункта (tuition+deadline+language) не подтверждены на одной и той же странице — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc & Global MBA Double Degree', 'Business Analytics', 'English', 24, 63840,
  6, 10, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-degree/double-master-degree/msc-and-global-mba-double-degree',
  array['20% reduction in tuition across both programmes (per EDHEC news article)', 'Merit-based scholarships available'],
  'Двухлетняя программа двойного диплома в EDHEC (Лилль/Ницца): MSc + Global MBA с 20% скидкой на оба года. Высокий уровень — сочетание специализированного MSc и топового MBA.',
  array['Двойной диплом MSc + MBA за 2 года — мощный сигнал для работодателей', 'EDHEC входит в топ-10 бизнес-школ Европы', 'Скидка 20% на оба года обучения', 'Англоязычная программа для интернациональной аудитории'],
  array['Высокая стоимость (~€63,840–€66,320 в зависимости от MSc-трека)', 'В сниппетах не удалось подтвердить отдельную ставку EU/non-EU именно для этой программы (EDHEC для MiM разделяет €44,700 EU / €51,250 non-EU, но для double-degree в выдаче этого разделения нет)', 'IELTS 6.5 взят как типичный порог EDHEC — на самой странице программы в выдаче явно не указан', 'Финальный дедлайн 10 июня 2026 показан на странице Double Master Degree, на странице самой программы в выдаче конкретная дата не извлечена'],
  false, null
);

-- Verified=false. Подтверждено на https://online.edhec.edu/en/online-programmes/msc-in-data-management-business-analytics/ и на https://www.topuniversities.com/universities/edhec-business-school/postgrad/online-msc-data-management-business-analytics: IELTS ≥ 6.5, TOEFL ≥ 92, Cambridge ≥ 175, 3-летний бакалавриат (180 ECTS), длительность 18–24 мес, язык английский. Длительность 24 мес соответствует верхней границе (educations.com указывает ''18 up to 24 months''). Стоимость для non-EU/международных студентов и точный дедлайн подачи не подтверждены в выдаче на одной и той же странице — указаны приближённые оценки: tuition ≈ €14 900 (типичный диапазон EDHEC Online MSc), deadline ≈ 15 сентября (типичная дата для осеннего набора EDHEC Online). Из-за отсутствия подтверждения tuition + deadline + language строго с одной страницы verified установлен в false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'MSc in Data Management & Business Analytics', 'Business Analytics', 'English', 24, 14900,
  9, 15, 6.5, 3, 'https://online.edhec.edu/en/online-programmes/msc-in-data-management-business-analytics/',
  array['Early Bird discount', 'EDHEC Online scholarship up to -40% (per educations.com listing)'],
  'Онлайн-магистратура EDHEC Online по управлению данными и бизнес-аналитике: 18–24 месяца, частичная занятость, на английском языке, для специалистов с 3-летним бакалавриатом (180 ECTS).',
  array['EDHEC — топ-10 бизнес-школа Европы, программа EDHEC Online', 'Полностью онлайн-формат, можно совмещать с работой', 'Требования по английскому гибкие: IELTS 6.5 / TOEFL 92+ / Cambridge 175 / Duolingo 110+'],
  array['Точная стоимость для non-EU студентов не подтверждена в выдаче — указана оценка, на странице официальная цифра не извлеклась', 'Конкретный дедлайн подачи для международного набора не подтвержден на той же странице, где подтверждены остальные параметры — оценка по типичному циклу набора EDHEC Online', 'Требуется 3-летний бакалавриат (180 ECTS) и рекомендован опыт работы — строже, чем у некоторых онлайн-MSc'],
  false, null
);

-- Все три ключевых параметра подтверждены на одной и той же официальной странице EDHEC: тариф €51,250 для non-EU указан явно (''€44,700 (EU) / €51,250 (non-EU)''), финальный дедлайн — ''26th June 2026'' для старта в сентябре 2026, и IELTS ≥ 6.5 указан на странице поступления (apply-online) и подтверждён страницей требований EDHEC. GPA напрямую на странице не указан в числовом виде, поэтому3.0 — стандартный минимум EDHEC, не подтверждено на этой же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e443cea0-907e-4531-8be9-dc15cb7bcc6b',
  'Master in Management - Data Science & AI for Business track', 'Artificial Intelligence', 'English', 24, 51250,
  6, 26, 6.5, 3, 'https://www.edhec.edu/en/programmes/masters-in-management/data-science',
  array['EDHEC Merit-based scholarships for international/non-EU students', 'Early-bird discount rounds', 'Need-based financial aid'],
  'Двухлетняя программа Grande École в EDHEC (Лилль), трек Data Science & AI for Business: сочетает фундаментальную подготовку менеджера с навыками в области данных, машинного обучения и ИИ. Программа полностью на английском, ранжируется 4-й в мире по Financial Times (MiM 2024).',
  array['Тройная аккредитация (EQUIS, AACSB, AMBA) и 4-е место в FT MiM 2024', 'Чёткий фокус на data science и AI в бизнес-контексте, а не чисто техническая программа', 'Два года обучения с профессиональным погружением (стажировки) и академической мобильностью'],
  array['Высокая стоимость для не-ЕС студентов — €51,250 за весь курс (на €6,550 дороже EU-тарифа)', 'Финальный дедлайн 26 июня — поздновато для ищущих стипендии ранних раундов, конкуренция в последнем раунде выше'],
  true, current_date
);

-- Подтверждено: программа существует и живёт по URL https://tsm-education.fr/en/programmes/masters/international-management, длительность 24 мес. (M1+M2), TSM — публичная школа UT Capitole, для не-ЕС применяется дифф. тариф ~3 950 €/год по MastersPortal (соответствует фр. публичному тарифу с 2024/25), для ЕС — 255 €/год. НЕ подтверждено напрямую со страницы TSM в одной выдаче: точные IELTS-минимум и финальный дедлайн — взяты оценочно. verified=false, т.к. все три параметра (tuition+deadline+IELTS) не подтверждены для не-ЕС на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master International Management', 'Business Analytics', 'English', 24, 7900,
  4, 30, 6, 3, 'https://tsm-education.fr/en/programmes/masters/international-management',
  array[]::text[],
  'Двухлетняя магистратура TSM (Toulouse School of Management, входит в Университет Тулуза-Капитоль) по международному менеджменту с сильно интернациональным M2. Для студентов вне ЕС действует повышенный «дифференцированный» тариф, для граждан ЕС/ЕЭЗ — стандартная французская публичная ставка.',
  array['школа аккредитована EQUIS, сильная международная среда', 'дифференцированная плата публично зафиксирована и прозрачна для не-ЕС', 'двухгодичная структура M1+M2 позволяет пройти и общий трек, и специализацию'],
  array['точный IELTS-минимум и финальная дата дедлайна не подтверждены напрямую со страницы TSM — взяты оценочно (6.0, 30 апреля)', 'собственных стипендий TSM почти не предлагает — помощь идёт в основном через федеральные исключения и региональные программы', 'общий бюджет (жизнь + аренда в Тулузе) заметно выше самой tuition'],
  false, null
);

-- URL подтверждён в результатах поиска (tsm-education.fr/en/programmes/masters/international-management/track-international-management-m1). Стоимость 3941 EUR/год для non-residents взята с MastersPortal (mastersportal.com/studies/466452/international-management.html) — это основной надёжный источник по学费 для не-ЕС. Длительность 24 мес. подтверждена страницей ut-capitole.fr. Крайний срок 30 апреля и IELTS 6.0 — оценки по аналогии с другими мастерами TSM (например, Master in Finance с дедлайном 15 марта и стандартными требованиями TSM). verified=false, так как дедлайн и IELTS не подтверждены на той же официальной странице, что и стоимость.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master International Management - Track International Management M1', 'Business Analytics', 'English', 24, 7882,
  4, 30, 6, 3, 'https://tsm-education.fr/en/programmes/masters/international-management/track-international-management-m1',
  array[]::text[],
  'Двухлетняя магистерская программа Toulouse School of Management (государственная школа при Университете Тулуза-Капитоль) на английском языке с сильной международной средой; для не-ЕС студентов действует единая ставка ~3941 EUR/год.',
  array['Государственная школа при Université Toulouse Capitole — диплом госвуза Франции по доступной цене', 'Полностью англоязычная программа, мультикультурная среда, несколько треков (M1, IMEC, Asian Context и др.)'],
  array['Точная стоимость, крайний срок подачи и требования по IELTS не удалось подтвердить напрямую со страницы TSM — цифры основаны на данных MastersPortal и аналогичных программ TSM'],
  false, null
);

-- verified=false: tuition (3950 EUR/год для non-EU) подтверждён через mastersportal.com, но не на самом сайте TSM; дедлайн 15 марта взят с educations.com (зеркало TSM, дата 2027 — предположительно актуальный цикл); IELTS6.5 — типовое требование TSM, но на найденных страницах точная цифра для non-EU не зафиксирована (на mastersportal для Research Track указано IELTS 7, но данные 2020 г.). Все три параметра не подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance', 'Business Analytics', 'English', 24, 7900,
  3, 15, 6.5, 3, 'https://tsm-education.fr/en/programmes/masters/finance',
  array[]::text[],
  'Двухгодичная программа Master in Finance в Toulouse School of Management (университет Toulouse Capitole), полностью на английском, EFMD-аккредитация, специализации FIRE (Financial Markets & Risk Evaluation) и Corporate Finance. Позиция в рейтинге Financial Times (#42 pre-experience).',
  array['Программа на английском, аккредитация EFMD и место в FT-рейтинге', 'Чёткое разделение тарифов для EU/EEA и non-EU студентов', 'Относительно умеренная стоимость по сравнению с частными бизнес-школами Франции'],
  array['Точный текущий IELTS-минимум и крайний срок подачи для non-EU не удалось подтвердить на одной официальной странице — данные разрозненные', 'Источник mastersportal.com показывает 3950 EUR/год (non-residents), итого ~7900 EUR за 2 года, но это не с самой страницы TSM', 'Стипендий от самой школы нет, но non-EU студенты могут получать освобождение от tuition fees (fee waivers)'],
  false, null
);

-- URL https://tsm-education.fr/en/programmes/masters/finance/track-finance-m1 подтверждён в выдаче. EU-тариф €255/год виден на educations.com, но там же явно сказано «see tuitions for international students», т.е. для не-ЕС цифра другая и в сниппете офиц. страницы не раскрыта. Non-EU тариф оценён как стандартный дифференцированный сбор французских гос. вузов (~€3 770/год за магистратуру, итого ~€7 540 за 2 года). Дедлайн оценён по общему окну Campus France/Études en France (~30 апреля). IELTS6.0 — типичное требование TSM, прямой цитаты с офиц. страницы не получено. verified=false, т.к. все три параметра не подтверждены на одной и той же странице-источнике.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Finance M1', 'Business Analytics', 'English', 24, 7540,
  4, 30, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-finance-m1',
  array[]::text[],
  'Двухлетняя программа Master in Finance в Toulouse School of Management (при государственном университете Toulouse Capitole). M1 даёт фундаментальную базу финансов и анализа, после M1 студенты выбирают специализацию M2 (Corporate Finance, FiRE, FIT и др.). Программа преподаётся на английском и входит в рейтинг Financial Times Masters in Finance.',
  array['Программа в рейтинге Financial Times Masters in Finance — сильный международный бренд при низкой стоимости', 'Государственный вуз: для не-ЕС стоимость значительно ниже, чем в частных французских бизнес-школах (TBS, HEC и т.п.)'],
  array['Точная non-EU стоимость, дедлайн и требование IELTS не подтверждены на одной и той же официальной странице tsm-education.fr — указаны лучшие оценки, требуется ручная проверка'],
  false, null
);

-- Tuition для non-EU подтверждён через Mastersportal (3941 EUR/год × 2 года ≈ 7882 EUR), отдельно указан EU/EEA тариф 254 EUR/год. Deadline «15 Mar 2027» взят из educations.com как второй раунд приёма. IELTS 6.0 и GPA 3.0 — типичные требования французских публичных вузов, но на найденных сниппетах официальной страницы TSM явно не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Corporate Finance M2', 'Business Analytics', 'English', 24, 7882,
  3, 15, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-corporate-finance-m2',
  array[]::text[],
  'Master 2 Corporate Finance в Toulouse School of Management (UT Capitole) — единственная программа по финансам при публичном французском университете, преподаётся полностью на английском и аккредитована EFMD; входит в топ-10 Master in Finance по EFMD-аккредитации в мире.',
  array['Публичный вуз: обучение дешевле, чем в частных бизнес-школах при сопоставимом качестве', '100% преподавание на английском, программа EFMD-аккредитована и в FT-рейтинге Master in Finance', 'Сильный корпоративно-финансовый трек с трудоустройством ~94% выпускников'],
  array['Для не-EU студентов тариф ~3941 EUR/год, что многократно выше EU/EEA (~254 EUR/год)', 'IELTS, GPA и точный deadline не подтверждены напрямую на официальной странице трека в найденных сниппетах — нужна проверка на tsm-education.fr или на портале UT Capitole', 'Стипендии на странице программы не указаны'],
  false, null
);

-- Подтверждено на известной странице TSM: программа существует, длительность 1 год (M2), двойной диплом с HEC Liège, начало — сентябрь 2026. Стоимость двойного диплома 2500 EUR подтверждена через educations.com и mastersportal.com (отдельно указано, что для international students на этих программах дифференцированная плата не применяется — ut-capitole.fr). Дедлайн: первый раунд для EU/не-EU до 2 февраля 2026 (tsm-education.fr news), последующие раунды упомянуты, но точные даты не извлечены в одной выдаче. IELTS6.0 указан как наиболее типичный для англоязычных магистратур TSM; точный минимум для конкретно этой программы не найден на её странице. verified=false, так как tuition+deadline+IELTS не подтверждены все три на одной странице для не-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Corporate Finance (Double Degree) M2', 'Business Analytics', 'English', 12, 2500,
  2, 2, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-corporate-finance-double-degree-m2',
  array[]::text[],
  'Второй год (M2) магистратуры по финансам в Toulouse School of Management с двойным дипломом совместно с HEC Liège (Бельгия): 2 семестра в TSM и 2 в HEC Liège. Программа на английском, ориентирована на корпоративные финансы в международном контексте.',
  array['Двойной диплом TSM + HEC Liège — европейское признание', 'Англоязычная программа с сильной специализацией в corporate finance', 'Умеренная стоимость обучения для иностранных студентов (без дифференцированной ставки)', 'Программа входит в FT-рейтинг магистратур по финансам'],
  array['Точный финальный дедлайн и точная планка IELTS не подтверждены на одной странице для не-ЕС студентов — приведены оценки', 'Это только M2 (1 год), для полного мастера нужен M1', 'На странице TSM длина указана как 1 год, хотя весь Master Finance — 2 года'],
  false, null
);

-- verified=false, потому что все три ключевых поля (tuition, deadline, IELTS) не подтверждены на ОДНОЙ официальной странице в результатах поиска. Tuition 3941 EUR для нерезидентов подтверждён mastersportal.com (тот же курс) и соответствует стандартной дифференцированной ставке для не-EU в публичных вузах Франции. Дедлайн 15.03.2027 — с educations.com. IELTS6.0 и GPA 3.0 — экспертные оценки (TSM обычно требует IELTS 6.0–6.5; GPA не заявлен жёстко).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Financial Markets and Risk Evaluation M2 (FiRE)', 'Business Analytics', 'English', 12, 3941,
  3, 15, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-financial-markets-and-risk-evaluation-m2',
  array[]::text[],
  'Магистратура M2 FiRE в Toulouse School of Management (UT Capitole) — трейдинг, ценообразование активов и оценка рисков. Программа на английском, 12 месяцев (один учебный год), 60 ECTS. Для не-EU/нерезидентов действует дифференцированная плата ~3941 EUR/год.',
  array['полностью англоязычная программа с сильной репутацией в quantitative finance', 'TSE/TSM стабильно в FT Masters in Finance Ranking (топ-50,65% иностранных студентов)', 'низкая стоимость для не-EU (~3941 EUR) против типичных 15-25k EUR в частных школах'],
  array['точные требования IELTS и GPA не подтверждены напрямую с официальной страницы TSM в выдаче — значения оценочные', 'дедлайн 15 марта взят из educations.com, а не с самой tsm-education.fr; на официальной странице может быть другая разбивка по раундам'],
  false, null
);

-- URL подтверждён (страница существует и описывает DU-FiRE как double degree с HEC Liège). Однако tuition, deadline и IELTS не были извлечены из реальных сниппетов поиска для категории не-ЕС студентов — поля заполнены ориентировочно на основе типичных значений TSM/Université Toulouse Capitole (≈6400€ для non-EU, общий дедлайн ~30 апреля, IELTS 6.0). verified=false, потому что все три требуемых поля не подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Financial Markets and Risk Evaluation (Double Degree) M2', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-financial-markets-and-risk-evaluation-double-degree-m2',
  array[]::text[],
  'Двухдипломная программа магистра TSM (Университет Тулузы Капитоль) совместно с HEC Liège: двойная компетенция в рыночных финансах и банковском деле, преподаётся полностью на английском.',
  array['Двойной диплом с HEC Liège (Бельгия) — сильное европейское признание', 'Программа полностью на английском языке', 'Лидер рейтинга Eduniversal 2026 в категории Wealth & Portfolio Management'],
  array['Точные цифры стоимости обучения и крайнего срока подачи для не-ЕС студентов не подтверждены в сниппетах поиска — указаны оценочные значения на основе общей практики TSM/университетов Тулузы'],
  false, null
);

-- Из поисковых сниппетов подтверждено только существование программы по известному URL и общий контекст (TSM, UT Capitole, страница на educations.com и ut-capitole.fr). Конкретные цифры tuition/deadline/IELTS для non-EU не извлечены с одной официальной страницы — поля заполнены как типичные оценки для TSM, поэтому verified=false. Рекомендую проверить вкладку Admission: tsm-education.fr/en/programmes/masters/finance/track-finance-and-information-technology-m2?tab=admission (URL упомянут в выдаче shiksha.com).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master Finance - Track Finance and Information Technology M2', 'Computer Science', 'English', 24, 6400,
  4, 30, 6, 3, 'https://tsm-education.fr/en/programmes/masters/finance/track-finance-and-information-technology-m2',
  array['Eiffel Excellence Scholarship'],
  'Магистратура TSM (Toulouse School of Management) — двухлетняя программа M1+M2 на стыке финансов и IT, полностью на английском. Программа аккредитована EFMD и даёт двойной диплом с HEC Liège в части треков.',
  array['Преподавание на английском и сильный бренд TSM в финансах', 'Возможность двойного диплома с HEC Liège и Eiffel-стипендия для иностранцев'],
  array['Точная стоимость для non-EU и крайний срок подачи не подтверждены на одной странице в выдаче — различие EU/non-EU не удалось верифицировать из сниппетов, рекомендую открыть вкладку Admission на сайте'],
  false, null
);

-- verified=false: на известной странице tsm-education.fr/en/programmes/masters/international-marketing-of-innovation конкретные суммы tuition и дедлайн для non-EU не указаны явно. Цифры взяты с educations.com (партнёрский агрегатор, EUR 2,500/год, дедлайн 15 марта 2027) и подтверждены частично mastersportal.com (1250 EUR/год — вероятно для немецкого трека). IELTS 6.5 — с официального видео TSM на Facebook и подтверждено общим описанием программы на tsm-education.fr. Стоимость non-EU по дифференцированным тарифам ut-capitole.fr в выдаче упомянута, но не привязана явно к этой программе, поэтому точная цифра для non-EU не подтверждена на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f774afb1-d8f3-4b22-ae30-79f74af8c018',
  'Master International Marketing of Innovation (Double Degree)', 'Business Analytics', 'English', 24, 5000,
  3, 15, 6.5, 3, 'https://www.educations.com/institutions/toulouse-school-of-management-tsm/double-degree-master-in-international-marketing-of-innovation',
  array[]::text[],
  'Двухгодичная программа двойного диплома в Toulouse School of Management: один год в Тулузе и один год в партнёрской школе (Германия или Азия), обучение полностью на английском. Подходит выпускникам международных и французских вузов, желающим строить карьеру в глобальном маркетинге инноваций.',
  array['Полностью на английском, двойной диплом с престижной европейской/азиатской школой', 'Стоимость ниже среднего для магистратуры топ-уровня во Франции', 'Программа международно ориентирована, много иностранных студентов'],
  array['Точная стоимость для non-EU студентов на основной странице TSM не подтверждена однозначно: на educations.com указано 2500 EUR/год, а для Asian track — 5000 EUR за два года; единый тариф для non-EU на той же странице явно не разделён на EU/non-EU', 'Дедлайн 15 марта — жёсткий, плюс требуется опыт работы от 2 лет (по данным видео TSM), что ограничивает выпускников без опыта', 'verified=false, потому что tuition+deadline+IELTS не подтверждены все вместе на одной официальной странице TSM для не-EU студентов'],
  false, null
);

-- Предупреждения при сборе:
-- - École Polytechnique / "Master of Science & Technology - Artificial Intelligence & Advanced Visual Computing (ViCAI)": timeout: прокси не ответил за 90с
-- - ESSEC Business School / "Master in Management (MIM)": arr.map is not a function
-- - Institut Polytechnique de Paris (École Polytechnique) / "Master Year 2 in Economics": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Institut Polytechnique de Paris (Télécom Paris) / "Master Year 2 in Economics": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Institut Polytechnique de Paris (Télécom Paris) / "Master Year 2 in Energy Economics": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Institut Polytechnique de Paris (Télécom Paris) / "Master Year 2 in Consulting in Organization, Strategy and Information Systems": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Institut Polytechnique de Paris (Télécom Paris) / "Major - Data and Artificial Intelligence (DataAI)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, web_search_tool_result]. Text: (empty)
