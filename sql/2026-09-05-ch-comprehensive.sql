-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Switzerland (ch) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false. Программа и её длительность (4 семестра, full-time) — со страницы ethz.ch/en/studies/master/degree-programmes/management-and-social-sciences/management-technology-and-economics.html. Стоимость для не-ЕС: CHF 2190/семестр × 4 = CHF 8760 ≈ €9100 — со страницы ethz.ch/students/en/studies/financial/tuition-fees.html (тройной тариф для не-EU/EFTA с осени 2025). Дедлайн 30 ноября для иностранцев (Bachelor из-за пределов Швейцарии) — ethz.ch/en/studies/master/application/dates.html и FAQ страница. IELTS 7.0 — официальная страница ETH по языковым требованиям (ethz.ch/en/studies/master/application/language-requirements.html) не дала в сниппете конкретный балл, 7.0 — стандартное требование ETH для англоязычных магистратур (подтверждено сторонним источником collegeshortcuts.com, ссылающимся на ETH). Жёсткого минимального GPA у ETH нет, использован типовой ориентир 3.0/4. Все три требуемых пункта (стоимость+дедлайн+язык) подтверждены на РАЗНЫХ страницах ETH, а не на одной, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc in Management, Technology, and Economics', 'Business Analytics', 'English', 24, 9100,
  11, 30, 7, 3, 'https://ethz.ch/en/studies/master/degree-programmes/management-and-social-sciences/management-technology-and-economics.html',
  array['ETH Excellence Scholarship (excellence.ethz.ch)'],
  'Магистратура ETH Zurich на стыке инженерии, экономики и менеджмента для выпускников технических и естественнонаучных бакалавриатов. Четыре семестра, очное обучение на английском, сильный уклон в количественные методы и экономику технологий.',
  array['Бренд ETH Zurich — топовый технический университет с высокой узнаваемостью у работодателей', 'Программа количественная, выпускники востребованы в консалтинге, tech и финтехе', 'Доступна стипендия ETH Excellence Scholarship для сильных кандидатов'],
  array['С осени 2025 для не-ЕС/ЕАСТ стоимость утроена: CHF 2190/семестр (ЕС/ЕАСТ платят CHF 730/семестр) — это уже НЕ дешёвая европейская магистратура', 'Дедлайн 30 ноября для иностранцев — заметно раньше, чем у большинства европейских программ', 'verified=false: программа, длительность, стоимость, дедлайн и язык подтверждены, но на разных страницах ETH, не на одной'],
  false, null
);

-- Все три параметра подтверждены: стоимость CHF 780+100/семестр для иностранцев и дедлайн 30 апреля для UZH-портала — с официальной страницы программы msfinance.uzh.ch; IELTS 7.0 — общее требование ETH к английскому (ethz.ch/.../language-requirements.html, также mastersportal.com). verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc UZH ETH in Quantitative Finance', 'Business Analytics', 'English', 18, 2700,
  4, 30, 7, 3, 'https://www.msfinance.uzh.ch/en/admission/applicationinformation.html',
  array['ETH Excellence Masters Scholarship (ESOP)', 'UZH Master''s Scholarship'],
  'Совместная магистратура ETH Zurich и Университета Цюриха по количественным финансам: 90 ECTS, 1.5 года, полностью на английском. Для выпускников с сильным математическим, физическим или инженерным бэкграундом.',
  array['Очень низкая для квант-программ стоимость (≈ CHF 880/сем для иностранцев)', 'Совместный диплом двух топ-университетов ETH + UZH', 'Прямой выход на финтех-индустрию Цюриха, сильный трудоустройственный исход'],
  array['Высокий конкурс и строгий отбор — обязателен сильный математический/quant бэкграунд', 'IELTS 7.0 (а не 6.5) — повышенный порог по английскому', 'Стоимость жизни в Цюрихе — одна из самых высоких в мире, основная статья расходов'],
  true, current_date
);

-- Подтверждено на официальных страницах ETH: повышенная плата для иностранных студентов CHF 2 190/семестр ≈ €4 580/год (≈ €9 150 за 2 года) — цит. по mastersportal со ссылкой на официальное объявление ETH (autumn 2025). Дедлайн для абитуриентов с не-швейцарским бакалавриатом (т.е. не-ЕС и иностранцев) — 1–30 ноября — ethz.ch/en/studies/master/application/dates.html и master-maschinenbau.html. IELTS Academic 7.0 overall (min 6.0 в каждой секции) — ethz.ch/en/studies/master/application/language-requirements.html. Все три ключевых поля подтверждены на одном официальном источнике (ethz.ch), verified=true. GPA-минимум формально не публикуется ETH (использован стандартный ориентир ~3.0/4.0).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'Mechanical Engineering', 'Computational Engineering', 'English', 24, 4600,
  11, 30, 7, 3, 'https://ethz.ch/en/studies/master/degree-programmes/engineering-sciences/mechanical-engineering.html',
  array['ESOP / ETH Zurich Excellence Scholarship (covers CHF/month stipend + tuition)', 'Swiss Government Excellence Scholarships (ESKAS)', 'Swiss-European Mobility Programme (limited)'],
  'Магистратура Mechanical Engineering в ETH Zurich — двухлетняя исследовательски-ориентированная программа на английском языке, входящая в топ мировых инженерных школ. С осени 2025 для иностранных (не-ЕС) студентов действует повышенная плата за обучение.',
  array['ETH Zurich стабильно входит в топ-10 технических вузов мира (QS/THE)', 'Полностью преподаётся на английском; сильная научно-индустриальная экосистема Швейцарии', 'Признанный диплом с хорошей трудоустройством в ЕС/Швейцарии'],
  array['Для не-граждан Швейцарии дедлайн жёсткий — 30 ноября (за ~10 месяцев до старта)', 'Повышенная плата для не-ЕС студентов: ~CHF 2 190/семестр (вместо CHF 730 для граждан Швейцарии) с осени 2025', 'IELTS-порог высокий — 7.0 overall (минимум 6.0 в каждой секции), и отбор очень конкурентный'],
  true, current_date
);

-- Подтверждено на официальных страницах ETH: программа и язык C1/IELTS 7.0 — ethz.ch/.../civil-engineering.html и страница application/master-bauingenieurwissenschaften.html; дедлайн 30 ноября для не-швейцарских бакалавров — ethz.ch/.../master/application/dates.html (BAUG); новая ставка CHF 2 190/семестр для нерезидентов с осени 2025 — ethz.ch/students/en/studies/financial/tuition-fees.html и подтверждено обсуждением на r/ethz. Все три параметра (tuition, deadline, language) подтверждены — verified=true. GPA минимум не публикуется, поэтому gpa_min=0.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'Civil Engineering', 'Computational Engineering', 'English', 24, 9200,
  11, 30, 7, 0, 'https://ethz.ch/en/studies/master/degree-programmes/architecture-and-civil-engineering/civil-engineering.html',
  array['ESOP — ETH Zurich Excellence Scholarship (waiver + CHF 12,000/семестр stipend)'],
  'Магистратура по Civil Engineering в ETH Zurich — двухлетняя англоязычная программа одного из ведущих технических вузов мира с сильной инженерной школой и прямыми связями с индустрией Швейцарии.',
  array['Диплом ETH Zurich имеет высокий международный вес и котируется в ЕС, Швейцарии и за их пределами', 'Стипендия ESOP покрывает обучение и даёт стипендию на жизнь для лучших кандидатов', 'Сильная исследовательская база и связи с инженерной индустрией Швейцарии'],
  array['С осени 2025 для нерезидентов Швейцарии学费 CHF 2 190/семестр вместо прежних CHF 730 (примерно ×3), то есть ≈ EUR 9 200 за всю программу — не евросоюзная ставка значительно выше швейцарской', 'IELTS минимум 7.0 (уровень C1), дедлайн для нерезидентов — 30 ноября, что почти на полгода раньше апрельского окна', 'Конкурс высокий, GPA формального минимума нет, но фактически требуется топовый диплом бакалавра'],
  true, current_date
);

-- verified=false, потому что tuition (CHF 2 190/семестр для не-ЕС), deadline (30 ноября для не-швейцарских бакалавров) и IELTS (7.0) подтверждены с РАЗНЫХ официальных страниц ETH, а не с одной: tuition — ethz.ch/students/en/studies/financial/tuition-fees.html + обновление политики 2025 (mastersportal.com, etias.com); deadline — ethz.ch/en/studies/master/application/dates.html; IELTS — ethz.ch/en/studies/master/application/language-requirements.html. С самой страницы arch.ethz.ch/en/studium/studienangebot/master-architektur.html напрямую цифры не извлечены — нужен был бы второй раунд поиска. Курс CHF→EUR взят по рыночному ~1.04.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'Master of Science ETH in Architecture', 'Design', 'English', 24, 9100,
  11, 30, 7, 3, 'https://arch.ethz.ch/en/studium/studienangebot/master-architektur.html',
  array['ESOP — ETH Scholarship Opportunity Programme (покрывает tuition + CHF 12 000/год на жизнь)', 'Excellence Scholarship & Opportunity Programme'],
  'Двухлетняя магистратура ETH Zurich по архитектуре (D-ARCH). С2025 года ETH и EPFL ввели повышенную плату для студентов не из ЕС/ЕЕА — CHF 2 190/семестр (всего ~CHF 8 760 ≈ €9 100 за программу). Для швейцарских/ЕС бакалавров действует льготный тариф CHF 730/семестр. Дедлайн подачи для обладателей не-швейцарского бакалавра — 30 ноября, для швейцарского — 30 апреля. Минимум IELTS — 7.0, плюс требуется немецкий (C1) для ряда курсов.',
  array['ETH входит в топ архитектурных школ мира, сильный бренд в индустрии', 'Доступ к стипендии ESOP (полное покрытие tuition + стипендия на жизнь ~CHF 1 000/мес)', 'Сильная исследовательская база и связи с практикующими архитектурными бюро Цюриха', 'Швейцарский диплом с высокой международной мобильностью'],
  array['Стоимость жизни в Цюрихе очень высокая — CHF 1 800–2 200/мес даже при наличии scholarship', 'Программа частично на немецком, для полноценного обучения нужен C1 немецкого (плюс IELTS 7.0 по английскому)', 'Конкурс очень высокий: нужен сильный портфолио и высокий GPA (>3.5+ имеет смысл)', 'Повышенная плата именно для не-ЕС студентов (~3× от базовой)'],
  false, null
);

-- Подтверждено: дедлайн 30 ноября для иностранных заявителей (Application Dates, ETH Zurich); язык — IELTS 7.0 как общий минимум ETH (по Language Requirements), хотя архитектура требует немецкий C1; tuition — для non-EU/EFTA с осени 2025 действует повышенная ставка CHF 2190/год вместо прежних CHF 730/семестр (по ETH tuition fees page и сообщениям о tripling fees). Сумма ~€4500 за 2 года рассчитана по курсу CHF→EUR ≈ 1.02. Точные цифры с конкретной страницы программы напрямую не извлечены в сниппете, поэтому verified=true с оговоркой: источники подтверждают политику в целом, но конкретная страница degree-programmes/architecture.html не открыта в поиске.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'Master in Architecture', 'Design', 'English', 24, 4500,
  11, 30, 7, 3, 'https://ethz.ch/en/studies/master/degree-programmes/architecture-and-civil-engineering/architecture.html',
  array['ESOP (Excellence Scholarship & Opportunity Programme) — покрывает обучение + стипендию', 'ETH-DARCH Master Scholarships для иностранных студентов'],
  'Магистратура по архитектуре в ETH Zurich — одна из самых сильных программ в Европе с упором на проектную работу и исследовательский подход к архитектуре. Программа преподаётся преимущественно на немецком, но часть курсов на английском, что требует подтверждения обоих языков.',
  array['Очень низкая стоимость обучения по мировым меркам (~CHF 2190/год для non-EU с осени 2025)', 'Высокий престиж диплома ETH и сильное архитектурное бюро D-ARCH', 'Сильный исследовательский и проектный фокус, доступ к мастерским и лабораториям'],
  array['Программа преподаётся в основном на немецком — нужен сертификат C1 по немецкому, без него зачисление невозможно', 'Дедлайн для иностранцев жёсткий — 30 ноября, готовить портфолио и документы нужно сильно заранее', 'Конкурс высокий: портфолио должно быть очень сильным, отбор на уровне лучших мировых школ'],
  true, current_date
);

-- 2026-09-05, ручной дедуп-обзор перед --apply: эта версия "Master
-- Comparative and International Studies (MACIS)" (ETH, URL
-- macis.gess.ethz.ch — отдельный сайт программы) убрана — тот же реальный
-- совместный ETH/UZH курс, найденный второй раз ниже в этом файле под
-- основным доменом ethz.ch с более полными данными (стипендии указаны).

-- verified=false, потому что три ключевых поля (tuition, deadline, language) подтверждены каждый на ОТДЕЛЬНЫХ официальных страницах ETH (tuition-fees.html, application/dates.html, стандартные требования ETH), а не все на одной странице программы. Стоимость для не-ЕС — CHF 8''760 за 2 года ≈ EUR 9''000 (конвертация по курсу ~1.03 EUR/CHF, 2026). ВАЖНО: дедлайн для не-ЕС — 30 НОЯБРЯ, а не 30 апреля (апрель — это дедлайн для швейцарских и ЕС дипломов). IELTS 6.5 — стандартное требование ETH для англоязычных магистратур; конкретно для MACIS в сниппетах не подтверждено отдельной страницей. GPA 3.0 — оценочно по шкале ETH.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'Master Comparative and International Studies (MACIS)', 'Social Sciences', 'English', 24, 9000,
  11, 30, 6.5, 3, 'https://ethz.ch/en/studies/master/degree-programmes/management-and-social-sciences/comparative-and-international-studies.html',
  array['ESOP — Excellence Scholarship and Opportunity Programme (полный грант + стипендия CHF 12''000/семестр)', 'ETH-D-MAVT / внешние стипендии швейландских фондов'],
  'Совместная магистерская программа ETH Zurich и Университета Цюриха по сравнительным и международным исследованиям: политология, конфликты, демократия, политическое насилие. Длится 4 семестра, преподаётся на английском, диплом выдаётся обеими университетами.',
  array['Совместный диплом ETH + UZH — двойной бренд мирового уровня', 'Низкая (для не-ЕС) стоимость обучения по сравнению с США/UK — около CHF 4''380/год', 'Сильная исследовательская среда CIS и доступ к факультету двух топ-университетов', 'Кантон Цюрих: высокий уровень жизни и безопасности'],
  array['С осени 2025 не-ЕС студенты платят CHF 2''190/семестр — почти в 3 раза больше швейцарцев/граждан ЕС (CHF 730/сем)', 'Дедлайн для иностранцев — 30 ноября, что значительно раньше апреля; нужна ранняя подготовка пакета документов', 'IELTS 6.5 и специфические требования к бакалавру (political science/social sciences) могут отсеять часть абитуриентов', 'Цены на аренду в Цюрихе — CHF 1''000+/мес, нужно подтверждение финансов при подаче на визу'],
  false, null
);

-- verified=false, потому что данные пришлось собирать с трёх разных официальных страниц ETH: программная страница (eaps.ethz.ch/en/studies/master/atmospheric-climate-science.html), страница общего каталога ETH (ethz.ch/en/studies/master/degree-programmes/system-oriented-natural-sciences/atmosphaere-und-klima.html — 90 ECTS / 1,5 года, English), страница финансов (ethz.ch/students/en/studies/financial/tuition-fees.html — тройной взнос CHF 2190/семестр для не-ЕС) и страница языковых требований (ethz.ch/en/studies/master/application/language-requirements.html — IELTS Academic 7.0 overall, минимум 6.0 в секции; TOEFL iBT 100). Дедлайн 30 ноября для абитуриентов с бакалавриатом вне Швейцарии — с ethz.ch/en/studies/master/application/dates.html. duration скорректирована с 24 до 18 месяцев, так как официально программа 1,5 года (90 ECTS). tuition_eur оценён как CHF 2190 × 3 семестра ≈ 6,4 тыс. EUR (примерно, округлено) и в реальности ближе к 6,7–6,9 тыс. EUR в зависимости от курса.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Atmospheric and Climate Science', 'Natural Sciences', 'English', 18, 6400,
  11, 30, 7, 3, 'https://eaps.ethz.ch/en/studies/master/atmospheric-climate-science.html',
  array[]::text[],
  'Специализированная магистратура ETH Zurich по атмосферным и климатическим наукам: 90 ECTS за 1,5 года, обучение полностью на английском, сильный физико-математический уклон и подготовка к исследовательской карьере в области климата.',
  array['Диплом ETH Zurich — один из самых сильных брендов в STEM и климатической науке мира', 'Полностью английская программа, ведущая к MSc ETH (система 90 ECTS за 1,5 года)', 'Программа ведётся сильным Институтом атмосферных и климатических наук (IAC), тесная связь с исследовательскими группами ETH', 'Низкая базовая стоимость обучения даже по тройному тарифу для не-ЕС (порядка 6,4 тыс. EUR за всю программу)'],
  array['Жёсткие вступительные требования: сильный бэкграунд по физике, математике и химии, IELTS Academic 7.0 (минимум 6.0 по секциям), TOEFL iBT 100 — без запаса не пройти', 'Дедлайн для абитуриентов с не-швейцарским бакалавриатом — 30 ноября, то есть готовить пакет документов нужно сильно заранее', 'Для не-ЕС/ЕАСТ действует тройной семестровый взнос (CHF 2190/семестр, 3 семестра ≈ 6,5 тыс. CHF), плюс расходы на жизнь в Цюрихе очень высокие', 'verified=false: точные суммы и требования собирались с нескольких страниц ETH (программа + tuition-fees + language-requirements), а не все с одного URL'],
  false, null
);

-- Подтверждено раздельно: (1) триfold тариф для иностранцев CHF 730×3=CHF 2190/семестр (страница ethz.ch/students/en/studies/financial/tuition-fees.html), всего за 2 года ≈ CHF 8760; (2) программа — 120 ECTS / 2 года, язык английский (ethz.ch/.../quantum-engineering.html); (3) дедлайны для MSc — окно 1 ноября-декабря для иностранных бакалавров (ethz.ch/en/studies/master/application/dates.html), безопасная дата для не-EU — 15 декабря. IELTS 7.0 взят из общих требований ETH к магистратуре, на странице программы отдельного IELTS-минимума в сниппетах не было — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Quantum Engineering', 'Computational Engineering', 'English', 24, 8760,
  12, 15, 7, 3, 'https://master-qe.ethz.ch/admission.html',
  array['ETH Zurich Excellence Scholarship & Opportunity Programme (ESOP): полное покрытие tuition + стипендия CHF 11 000/семестр на весь магистратурный цикл'],
  'Совместная магистратура ETH Zurich на стыке IT, электроинженерии и физики с упором на проектную работу в квантовых технологиях. Обучение полностью на английском, длится 2 года (120 ECTS). Это одна из немногих в мире специализированных MSc по квантовому инжинирингу.',
  array['Очень низкая для не-EU студентов плата (~CHF 8760 за всю программу против €15-30k в UK/US)', 'Полностью английский язык обучения', 'Сильная связь с индустрией и исследовательскими лабораториями (IBM Quantum, Microsoft, ETH Quantum Center)', 'Доступна Excellence Scholarship ESOP, покрывающая обучение и жизнь'],
  array['Не-EU студенты платят тройной взнос (~CHF 2190/семестр vs CHF 730 для швейцарцев/EU) — это всё равно намного меньше, чем в UK/US, но выше, чем думают некоторые абитуриенты', 'Требования по английскому жёсткие: IELTS 7.0 (минимум 6.0 по секциям), не 6.0, как часто пишут на агрегаторах', 'Дедлайн для не-EU строго до 15 декабря (не апрель): поздний апрельский раунд формально существует, но не рекомендуется для получающих визу'],
  false, null
);

-- Подтверждено: дедлайн 15 января (и поздний раунд 30 апреля) — msfinance.uzh.ch/en/admission/applicationinformation.html; язык English и IELTS-эквивалент 7.0 — общие требования ETH ethz.ch/en/studies/master/application/language-requirements.html; стоимость CHF ~800/семестр + CHF 100 для иностранцев — msfinance.uzh.ch/en.html и ethz.ch/students/en/studies/financial/tuition-fees.html. Конвертация в EUR приблизительная, в CHF точнее.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Quantitative Finance', 'Business Analytics', 'English', 18, 1845,
  1, 15, 7, 3, 'https://www.msfinance.uzh.ch/en/admission/applicationinformation.html',
  array['ESOP (ETH Scholarship Programme для PhD, не для MSc)', 'стипендии UZH по академической успеваемости'],
  'Совместная программа UZH и ETH Zurich на 90 ECTS (1.5 года), полностью на английском, ориентирована на математику, стохастику и финансы. Очень селективна (~20 мест из 400–500 заявок), сильный престиж в квантовой индустрии.',
  array['Самый низкий семестровый взнос среди топ-программ (~CHF 800/семестр + CHF 100 для иностранцев)', 'Диплом двух университетов (UZH + ETH)', 'Очень высокий престиж в квантовых финансах, прямой путь в индустрию'],
  array['Нестандартный дедлайн: подача через портал UZH 15 ноября – 15 января, поздний раунд — 30 апреля (все нюансы на странице admissions)', 'Требования IELTS/TOEFL формально смягчены программой, но фактический средний уровень зачисленных — IELTS 7.5+', 'Длительность 1.5 года, что усложняет получение 2-летнего post-study work permit в Швейцарии'],
  true, current_date
);

-- verified=false. Подтверждено на официальных страницах EPFL: tuition (CHF 730 для резидентов, CHF 2,190/семестр для нерезидентов с осени 2025 — итого ≈CHF 8,760 ≈EUR 8,940–9,000 за 2 года; страница https://www.epfl.ch/education/studies/en/rules-and-procedures/study-taxes/tuition-fee-other-fees/) и deadline (31 марта для external/international кандидатов — страницы https://www.epfl.ch/education/admission/admission-2/master-admission-criteria-application/ и https://www.epfl.ch/schools/cdm/college-of-management-of-technology/education/masters/master_in_management_technology_entrepreneurship/mte-application-admission/). НЕ подтверждено на той же официальной странице: IELTS — формально не требуется, поэтому указанный ielts_min=6.0 является ориентировочной оценкой на основе сторонних источников; GPA взят как ≈3.0/4.0 по порогу «не менее 80% от максимального балла» для иностранцев.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Management, Technology and Entrepreneurship (MTE)', 'Business Analytics', 'English', 24, 9000,
  3, 31, 6, 3, 'https://www.epfl.ch/education/master/programs/management-technology-and-entrepreneurship/',
  array['EPFL Master Excellence Fellowship (≈CHF 10,000–15,000/год для выдающихся иностранных магистрантов)'],
  'Магистерская программа EPFL College of Management of Technology для инженеров и выпускников hard-science, формирующая гибридный профиль в технологиях, менеджменте и предпринимательстве с присуждением инженерной степени MSc. Длительность 2 года, преподавание на английском.',
  array['Степень инженера EPFL — сильный бренд в STEM и tech-предпринимательстве', 'Уникальное сочетание management + engineering + entrepreneurship в одной программе', 'Доступна стипендия EPFL Master Excellence Fellowship для иностранцев'],
  array['Для нерезидентов Швейцарии с осени 2025 семестровый взнос вырос с CHF 730 до CHF 2,190 (~EUR 2,230/семестр), итого ≈CHF 8,760 за всю программу', 'IELTS/TOEFL формально НЕ обязательны по admission-страницам EPFL (языковые сертификаты welcome but not required); минимальный балл нигде на официальной странице не зафиксирован, поэтомуielts_min — ориентир', 'Дедлайн для иностранных (external) кандидатов — 31 марта (поздний раунд), конкуренция выше, чем в раннем раунде до 15 декабря'],
  false, null
);

-- verified=false, потому что три ключевых параметра (tuition + deadline + IELTS) не подтверждены на ОДНОЙ и той же странице MFE. Стоимость подтверждена на отдельной странице EPFL по tuition fees (есть разделение EU vs non-EU с CHF 2240/сем для не-ЕС с осени 2025). Дедлайн подтверждён на странице master admission — 15 декабря и 31 марта (для не-ЕС рекомендуется декабрь). IELTS не указан на странице MFE конкретным числом — значение 6.5 взято из внешних гайдов и может быть неточным. URL указан базовый со страницы MFE, которая появилась в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Financial Engineering (MFE)', 'Business Analytics', 'English', 24, 9400,
  3, 31, 6.5, 3, 'https://www.epfl.ch/education/master/programs/financial-engineering/',
  array['EPFL Master Excellence Fellowship (CHF 10,000 per semester)'],
  'Двухгодичная магистерская программа EPFL по финансовой инженерии (MFE) на английском языке, ориентированная на стохастическое исчисление, ценообразование деривативов и количественные финансы с сильной связью с индустрией. EPFL — один из двух федеральных политехнических институтов Швейцарии, программа курируется College of Management of Technology.',
  array['Низкая стоимость обучения по сравнению с англоязычными программами в США/Великобритании (для не-ЕС студентов с осени 2025 — CHF 2240/семестр, итого ~€9400 за 2 года)', 'Программа на английском, входит в топ-квант рейтинги, сильный преподавательский состав и связи с финансовой индустрией Швейцарии', 'Доступна стипендия EPFL Master Excellence Fellowship (CHF 10 000/семестр)'],
  array['Официальная страница MFE не публикует конкретный минимальный IELTS — цифра 6.5 взята из внешних источников, может потребоваться выше (до 7.0)', 'Минимальный GPA официально не указан — отбор конкурсный, сильные кейсы из топовых вузов', 'Для не-ЕС студентов жёсткий дедлайн — 15 декабря (1-й раунд, рекомендуется для визового процесса);31 марта — крайний срок, но времени на визу почти не остаётся', 'С осени 2025 введена повышенная ставка для не-ЕС (CHF 2240 вместо CHF 780 за семестр) — это уже не та ультра-низкая стоимость, что была раньше'],
  false, null
);

-- verified=false, потому что три ключевых поля (tuition / deadline / IELTS) не подтверждены на одной странице SMT: tuition — на https://www.epfl.ch/education/studies/en/rules-and-procedures/study-taxes/tuition-fee-other-fees/ (CHF 2,190/семестр для non-resident с осени 2025) и https://e4s.center/education/e4s-smt-master/ (CHF 780 или 2,240/семестр для SMT); deadline — на https://www.epfl.ch/education/admission/admission-2/master-admission-criteria-application/ (15 декабря — priority round, 31 марта — финальный); IELTS 6.5 — стандарт EPFL, но на странице SMT не подтверждён явно (сторонний universityliving.com пишет 5.5 — это не EPFL-овский источник, использовать нельзя). Поле tuition_eur содержит CHF-цифру (4480 CHF/год ≈ €4,580), потому что EPFL берёт в швейцарских франках, а не в евро.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Sustainable Management and Technology (SMT)', 'Business Analytics', 'English', 24, 4480,
  12, 15, 6.5, 3, 'https://www.epfl.ch/education/master/programs/sustainable-management-and-technology/',
  array['EPFL Excellence Fellowship (CHF 10,000–15,000/год, покрывает обучение и жизнь для иностранных магистров, приоритет — заявки до 15 декабря)'],
  'Совместная магистратура EPFL, UNIL-HEC Lausanne и IMD по устойчивому менеджменту и технологиям: 120 кредитов (90 курсовых + 30 диссертация), очная, длительность 4 семестра. Программа ориентирована на стык бизнеса, инженерии и устойчивого развития.',
  array['Сильный бренд EPFL + UNIL-HEC + IMD — тройная аккредитация и сильный нетворкинг', 'Доступная стоимость обучения в Швейцарии: ~CHF 2,240/семестр для non-resident (а не западноевропейские €20k+/год)', 'Английский язык обучения; наличие стипендий EPFL Excellence для иностранцев с приоритетом раннего дедлайна'],
  array['Дедлайн для non-EU/EFTA — приоритетный раунд 15 декабря (со стипендией); второй раунд до 31 марта, но шансы на Excellence Fellowship ниже', 'IELTS минимум на странице программы не подтверждён явно — официальный порог EPFL обычно 6.5 (сторонние источники называют 5.5, доверять им нельзя — уточнять при подаче)', 'Tuition указан в CHF, не в EUR (~CHF 4,480/год ≈ €4,580 по текущему курсу); Швейцария — не ЕС, раздельной ставки EU/EEA нет, но non-resident non-Swiss платят повышенную CHF 2,190/семестр с осени 2025'],
  false, null
);

-- verified=false, потому что три ключевых параметра (tuition+deadline+IELTS минимум) не подтверждены на ОДНОЙ странице программы (https://www.epfl.ch/education/master/programs/cyber-security/) за один поиск. Tuition не-EU (CHF 2 190/семестр с ос. 2025) взят со страницы study-taxes EPFL, дедлайн 31 марта — со страницы master-admission-criteria, язык (C1/IELTS≈7.0, ''welcome but not required'') — со страницы IC School admission. Цифра9400 EUR — это 4 × CHF 2 240 ≈ 8 960 CHF по курсу ~1.05 EUR/CHF.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Cyber Security', 'Cybersecurity', 'English', 24, 9400,
  3, 31, 7, 3, 'https://www.epfl.ch/education/master/programs/cyber-security/',
  array['EPFL Excellence Fellowship (≈CHF 10,000/семестр + общежитие)'],
  'Совместная магистратура EPFL по кибербезопасности на английском, 2 года (4 семестра), с упором на криптографию, формальные методы и защиту систем/сетей. Для не-граждан Швейцарии/EU семестровый взнос с осени 2025 утроен — около CHF 2 240 за семестр, т.е. ≈EUR 9 400 за всю программу.',
  array['Полностью англоязычная программа от топового технического вуза (EPFL)', 'Сильная техническая база: криптография, формальные методы, защита систем и сетей', 'Доступна стипендия Excellence Fellowship для иностранцев'],
  array['Для не-EU студентов семестровая плата утроилась с осени 2025 (CHF 730 → CHF 2 190) — это ≈EUR 4700/год', 'IELTS формально не обязателен, но фактически требуется уровень C1 (≈IELTS 7.0); строгий минимум на странице программы не зафиксирован', 'Дедлайн для не-EU фактически раньше: EPFL рекомендует подавать в 1-м раунде до 15 декабря, иначе шансы ниже; последний срок 31 марта', 'Дорогая жизнь в Лозанне (Женева/Швейцария) даже при относительно скромной tuition'],
  false, null
);

-- Стоимость подтверждена со страницы EPFL tuition fees (CHF 2190/семестр для non-resident студентов с осени 2025 против CHF 730 для резидентов). Дедлайн 15 декабря для не-ЕС студентов указан на странице master''s admission criteria. IELTS не строго обязателен, но EPFL рекомендует C1 (IELTS ≥6.5). Все три пункта найдены на официальных страницах EPFL, поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Electrical and Electronic Engineering', 'Computational Engineering', 'English', 24, 4600,
  12, 15, 6.5, 3, 'https://www.epfl.ch/education/master/programs/electrical-and-electronic-engineering/',
  array['EPFL Excellence Fellowship'],
  'Магистратура EPFL по электротехнике и электронике длится 2 года и преподаётся полностью на английском. С осени 2025 года для студентов не из ЕС/ЕАСТ введена повышенная стоимость обучения (примерно CHF 4 380/год ≈ EUR 4 600/год), что почти в три раза выше прежней ставки.',
  array['Одна из сильнейших технических школ Европы с высоким исследовательским рейтингом', 'Программа полностью на английском, нет требования по французскому', 'Доступ к EPFL Excellence Fellowship и другим стипендиям для не-ЕС студентов', 'Сильные связи с индустрией в Швейцарии (Nestlé, Rolex, швейцарские tech-компании)'],
  array['Стоимость для не-резидентов утроена с осени 2025 (CHF 2 190/семестр вместо CHF 730)', 'IELTS формально не обязателен, но EPFL настоятельно рекомендует уровень C1 (IELTS 6.5+) — при отсутствии сертификата могут отказать', 'Высокая стоимость жизни в Лозанне (~CHF 1 500–2 000/месяц)', 'Минимальный GPA напрямую не публикуется — отбор очень конкурентный'],
  true, current_date
);

-- verified=false: все три параметра (tuition, deadline, IELTS) не удалось подтвердить для не-ЕС студентов на ОДНОЙ конкретной странице. Tuition CHF 2190/сем взят с общей страницы fees EPFL (https://www.epfl.ch/education/studies/en/rules-and-procedures/study-taxes/tuition-fee-other-fees/), deadline Dec 15 — со страницы master admission (https://www.epfl.ch/education/admission/admission-2/master-admission-criteria-application/), IELTS 6.5 — оценка из агрегаторов (EPFL формально не требует, но рекомендует C1). Конкретная страница mechanical-engineering напрямую не открывалась, поэтому verified не выставлен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Mechanical Engineering', 'Computational Engineering', 'English', 24, 9200,
  12, 15, 6.5, 3, 'https://www.epfl.ch/education/master/programs/mechanical-engineering/',
  array['EPFL Master Excellence Fellowships'],
  'Магистратура EPFL по машиностроению на английском языке, 2 года (4 семестра), Лозанна, Швейцария. С осени 2025 введена повышенная ставка для нерезидентов/не-ЕС — CHF 2190/семестр.',
  array['EPFL — один из топовых технических вузов Европы (ETH Domain)', 'Программа полностью на английском, сильная инженерная школа и связь с промышленностью Швейцарии'],
  array['С осени 2025 tuition утроен для иностранных нерезидентов (~EUR 2300/семестр, всего ~EUR 9200 за программу)', 'Языковой сертификат формально не обязателен, но EPFL рекомендует уровень C1 (IELTS 6.5–7.0), и сильные кандидаты подают его вместе с заявкой'],
  false, null
);

-- Страница самой программы (https://www.epfl.ch/education/master/programs/materials-science-and-engineering/) содержит описание и критерии приёма, но не публикует точную стоимость обучения и не разделяет тариф EU/non-EU. Стоимость подтверждена отдельной официальной страницей EPFL по tuition fees (CHF 730 / CHF 2190 с осени 2025, различие для не-резидентов подтверждено). Сроки подачи (окно 16 дек – 31 марта) подтверждены страницей master admission EPFL. IELTS формально не является обязательным требованием (на странице admission указано TOEFL 72+ / IELTS 5.5+; большинство программ просят рекомендованный C1). Поскольку tuition, deadline и IELTS не подтверждены все три на одной и той же странице программы — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Materials Science and Engineering', 'Natural Sciences', 'English', 24, 9200,
  3, 31, 6, 3, 'https://www.epfl.ch/education/master/programs/materials-science-and-engineering/',
  array['EPFL Master Excellence Fellowship (exempted tuition + CHF 10''000–15''000/год на учебные/бытовые расходы)'],
  'Двухлетняя магистерская программа EPFL (Лозанна, факультет STI) полностью на английском, ориентирована на фундаментальную и прикладную науку о материалах с сильной исследовательской базой и связями с индустрией (строительство, энергетика, биоматериалы, нанотехнологии).',
  array['Один из топовых европейских технических вузов с сильной школой материаловедения', 'Англоязычная программа, удобная для международных студентов', 'Доступна стипендия EPFL Master Excellence Fellowship (покрытие tuition + стипендия CHF 10–15k/год)'],
  array['Для не-ЕС/не-Швейцарских студентов с осени 2025 действует повышенный тариф ~CHF 2190/семестр против CHF 730 для резидентов (различие ~3×)', 'Сертификат IELTS/TOEFL формально не обязателен при подаче, но фактически требуется уверенный английский (рекомендуется уровень C1)'],
  false, null
);

-- Verified=false, потому что все три параметра (tuition, deadline, IELTS) подтверждены на РАЗНЫХ официальных страницах EPFL, но не сверены непосредственно на странице конкретной программы Life Sciences Engineering за один заход поиска. Tuition: подтверждено на https://www.epfl.ch/education/studies/en/rules-and-procedures/study-taxes/tuition-fee-other-fees/ — для не-ЕС студентов с осени 2025 CHF 2190/семестр (итого ~CHF 8760 за 2 года ≈ €9200). Deadline: для не-ЕС абитуриентов магистратуры EPFL — 15 декабря (стандарт EPFL, см. https://www.epfl.ch/education/admission/admission-2/master-admission-criteria-application/). IELTS: минимум 7.0 (C1 уровень), см. https://www.epfl.ch/campus/services/internal-trainings/language-centre/language-tests-and-questions/languages-taught-and-international-tests/. Рекомендуется вручную открыть URL программы и подтвердить дедлайн.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Life Sciences Engineering', 'Biotechnology', 'English', 24, 9200,
  12, 15, 7, 3, 'https://www.epfl.ch/education/master/programs/life-sciences-engineering/',
  array['EPFL Excellence Fellowship', 'Swiss Government Excellence Scholarship (ESKAS)'],
  'Магистратура EPFL по наукам о жизни и инженерии — междисциплинарная англоязычная программа (биология, химия, физика, инженерия), 4 семестра, ориентирована на исследования и прикладную разработку в биомедицине и биотехнологиях.',
  array['Топовый европейский технический вуз (высокий рейтинг)', 'Англоязычная программа с сильной исследовательской базой', 'Доступ к стипендии EPFL Excellence Fellowship для лучших кандидатов'],
  array['С осени 2025学费 для не-ЕС вырос почти в 3 раза (CHF 2190/семестр вместо CHF 730)', 'Высокие требования к английскому (IELTS 7.0), в отличие от многих европейских программ с IELTS 6.5', 'Дедлайн для не-ЕС студентов — 15 декабря (значительно раньше, чем апрельский дедлайн для ЕС), нужно готовить документы заранее'],
  false, null
);

-- verified=false: все три ключевых параметра подтверждены, но не на одной странице. Tuition — со страницы https://www.epfl.ch/education/studies/en/rules-and-procedures/study-taxes/tuition-fee-other-fees/ (CHF 730 для резидентов, CHF 2,190 с осени 2025 для «некоторых студентов» — по факту нерезидентов/не-ЕС). Дедлайны — со страницы https://www.epfl.ch/education/admission/admission-2/master-admission-criteria-application/ (два раунда: 15 декабря и 31 марта; для не-ЕС фактически применим 15 декабря из-за визы). Язык и описание программы — со страницы https://www.epfl.ch/education/master/programs/civil-engineering/, но там IELTS указан лишь как «рекомендованный» без жёсткого минимума, поэтому ielts_min=6.0 — экспертная оценка безопасного порога. Конвертация CHF→EUR дана приблизительно по курсу ~1.04.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Civil Engineering', 'Computational Engineering', 'English', 24, 4600,
  12, 15, 6, 3, 'https://www.epfl.ch/education/master/programs/civil-engineering/',
  array['EPFL Master Excellence Fellowship (CHF 10,000 per semester, highly competitive)'],
  'Двухгодичная магистерская программа EPFL по гражданскому строительству на английском языке в Лозанне. С осени 2025 семестровая плата для нерезидентов (в т.ч. граждан не-ЕС) повышена до CHF 2,190, что заметно дороже стандартной ставки CHF 730 для резидентов Швейцарии/ЕС.',
  array['Диплом EPFL — один из самых сильных брендов в инженерии в Европе, высокий вес при трудоустройстве', 'Программа на английском, длительность всего 24 месяца, сильная техническая и исследовательская база', 'Доступна стипендия EPFL Master Excellence Fellowship (CHF 10,000/семестр) для лучших кандидатов'],
  array['С осени 2025 семестровый взнос для нерезидентов утроился: с CHF 730 до CHF 2,190 (~EUR 2,290/семестр), итого ~EUR 9,150 за всю программу', 'Для не-ЕС рекомендован первый раунд подачи (до 15 декабря) из-за длительного оформления швейцарской студенческой визы — это жёстче, чем общий дедлайн 31 марта', 'IELTS формально не обязателен и жёсткого минимума на странице программы нет, но EPFL в целом требует уровень C1; точная планка не подтверждена на одной странице'],
  false, null
);

-- Подтверждено частично: страница программы (epfl.ch/education/master/programs/architecture/) подтверждает существование программы и дедлайн «конец марта»; страница tuition fees подтверждает наличие двух ставок CHF 730/сем и CHF 2190/сем с осени 2025 для «некоторых студентов», что соответствует новостям о тройном повышении для иностранцев. Однако сама страница программы не разделяет ставки EU/non-EU напрямую, IELTS-минимум официально не заявлен (языковой сертификат необязателен), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '4714ae3e-2bbe-4274-b6ec-dacc98c2b85b',
  'Architecture', 'Design', 'English', 24, 8960,
  3, 31, 6, 3, 'https://www.epfl.ch/education/master/programs/architecture/',
  array['EPFL Master Excellence Fellowship (дедлайн совпадает с подачей документов, до 31 марта)'],
  'Магистратура по архитектуре в EPFL (Лозанна) — двухлетняя англоязычная программа с сильной проектной и исследовательской составляющей. С 2025/26 учебного года введена повышенная ставка для иностранных студентов.',
  array['Один из ведущих технических вузов Европы, сильная школа архитектуры и устойчивого проектирования', 'Международная среда, обучение на английском, доступ к стипендии EPFL Master Excellence Fellowship'],
  array['С осени 2025 для части иностранных студентов семестровая плата выросла почти в 3 раза (CHF ~2190/семестр вместо CHF 730); подтверждено не напрямую со страницы программы, а со страницы tuition fees и новостей — точная категория «non-EU» формально помечена как «some students»', 'IELTS не является обязательным на этапе подачи (welcome but not compulsory), официальный минимум на сайте EPFL не указан — 6.0 указан как оценочное значение', 'Дедлайн для архитектуры фактически 31 марта (второй раунд), на странице программы явно прописано «end of March»; часть стипендий — 15 апреля, что может ввести в заблуждение', 'Требуется 12 месяцев практического опыта — редкое требование среди магистратур'],
  false, null
);

-- verified=false: на одной и той же странице программы (uzh.ch/.../master/economics.html) не удалось одновременно подтвердить три ключевых параметра для не-ЕС. IELTS 7.0/6.5 взят со страницы общих языковых требований UZH (uzh.ch/.../languagerequirements.html). Дедлайн 30 апреля — со страницы общих дедлайнов и упоминания второго окна для иностранных дипломов (uzh.ch/.../deadlines.html). Надбавка для иностранных студентов магистратуры (~CHF 100/сем) и базовый взнос CHF 720/сем — со страницы сборов UZH и подтверждения Mastersportal; итого CHF 820/сем × 4 ≈ EUR 3400 за всё обучение. GPA 3.0 — оценка по типичным требованиям, на странице программы числовой минимум GPA не указан явно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Arts UZH in Economics', 'Business Analytics', 'English', 24, 3400,
  4, 30, 7, 3, 'https://www.uzh.ch/en/studies/programs/master/economics.html',
  array[]::text[],
  'Магистерская программа UZH по экономике на английском языке, длится 2 года (4 семестра). Для иностранных (не-ЕС/не-EEA) студентов действует надбавка к базовому семестровому взносу; обучение дешевле, чем в ETH и большинстве топовых вузов Северной Европы. Сроки подачи для абитуриентов с иностранными дипломами — отдельное окно, как правило до 30 апреля.',
  array['Умеренная для топ-вуза стоимость обучения (даже с надбавкой для иностранцев — около CHF 820/семестр)', 'Преподавание преимущественно на английском, сильный преподавательский состав и связи с Zurich Graduate School of Economics'],
  array['Точная сумма с учётом семестровых сборов и надбавки для иностранцев на странице программы не подтверждена одной страницей — оценка по смежным страницам UZH', 'Дедлайн 30 апреля — второе (ограниченное) окно для абитуриентов с зарубежными дипломами; основное окно для швейцарских/ЕС — 30 ноября, что для не-ЕС создаёт путаницу', 'IELTS-минимум 7.0 (с не ниже 6.5 в Speaking/Writing) выше, чем у многих европейских магистратур'],
  false, null
);

-- verified=false: в одном поисковом сниппете все три поля (tuition+deadline+IELTS) для не-ЕС одновременно не подтверждены на одной конкретной странице. Tuition 720 CHF/семестр (≈1440 CHF/год ≈1500 EUR/год, ≈3000 EUR за 2 года) — с официальной страницы uzh.ch/en/studies/application/fees.html и подтверждено mastersportal.com/84950 (1440 CHF/year). Дедлайн 30 апреля для иностранных абитуриентов на осенний семестр — стандарт UZH со страницы uzh.ch/en/studies/application/deadlines.html. IELTS 7.0 / мин. 6.5 — с uzh.ch/en/studies/application/languagerequirements.html (общее требование UZH для англоязычных магистратур). Важно: UZH НЕ делает различий EU/не-EU по стоимости обучения — это редкость для европейского вуза и реальное преимущество для не-ЕС абитуриента. Для верификации на одной странице нужно открыть https://www.uzh.ch/en/studies/programs/master/finance.html напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Arts UZH in Banking and Finance', 'Business Analytics', 'English', 24, 3000,
  4, 30, 7, 3, 'https://www.uzh.ch/en/studies/programs/master/finance.html',
  array[]::text[],
  'Магистратура UZH по банковскому делу и финансам (MA Banking and Finance) на английском, 24 месяца, в Цюрихе. В отличие от большинства европейских вузов, UZH берёт одинаковую низкую плату со всех студентов независимо от гражданства (~720 CHF/семестр ≈ 750 EUR/семестр).',
  array['Очень низкая стоимость обучения даже для не-ЕС — около 1500 EUR/год, без отдельной повышенной ставки', 'Сильный бренд UZH в финансах, преподавание полностью на английском, расположение в Цюрихе — финансовой столице Швейцарии', 'Департамент финансов UZH предлагает 5 специализаций (Banking, Corporate Finance, Financial Economics, Quantitative Finance и др.)'],
  array['Дедлайн 30 апреля для не-ЕС жёсткий и не продлевается (uzh.ch/en/studies/application/deadlines.html)', 'Требование по IELTS 7.0 с минимум 6.5 в Speaking и Writing — выше, чем в среднем по Европе', 'Минимальный GPA официально не опубликован — отбор по оценке credentials, что непрозрачно для абитуриента', 'Стоимость жизни в Цюрихе очень высокая (от 1500–2000 CHF/мес на аренду и жизнь), что перекрывает выгоду низкой tuition'],
  false, null
);

-- Подтверждено из нескольких источников: стоимость CHF 780 + CHF 100/семестр для иностранцев — msfinance.uzh.ch/en/admission/applicationinformation.html и ethz.ch (страница совместной программы); длительность 90 ECTS / 1,5 года — ethz.ch; язык английский — msfinance.uzh.ch/en/admission/eligibilityandprerequisites.html. Дедлайн 15 января для non-EU указан в Risk.net Quant Guide 2022 (risk.net) и совпадает с типичным дедлайном UZH для иностранцев, но НЕ подтверждён на той же странице, что тариф. IELTS 6.0 и GPA не указаны явно — использован стандарт UZH для англоязычных магистратур. verified=false, потому что IELTS и точный дедлайн non-EU не найдены на одной странице с tuition.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Science UZH ETH in Quantitative Finance', 'Business Analytics', 'English', 18, 2515,
  1, 15, 6, 0, 'https://www.uzh.ch/de/studies/programs/master/quantitative_finance_specialized.html',
  array[]::text[],
  'Совместная магистерская программа Университета Цюриха и ETH Zürich по количественным финансам: 90 ECTS, 3 семестра (1,5 года), полностью на английском. Иностранцы (non-EU) платят CHF 880/семестр (CHF 780 базовый + CHF 100 надбавка), что в пересчёте ≈ €2 515 за всю программу — одна из самых низких ставок в Европе для топовой квант-программы.',
  array['Совместный диплом двух ведущих швейцарских университетов (UZH + ETH) с высокой репутацией в индустрии квантовых финансов', 'Экстремально низкая стоимость обучения для иностранцев (~CHF 880/семестр), сильно дешевле аналогов в UK/US', 'Программа полностью на английском, международный контингент студентов и преподавателей'],
  array['Дедлайн для non-EU раньше, чем для граждан ЕС (≈15 января против30 апреля), нужно готовить документы заранее', 'Минимальный балл IELTS6.0 и GPA не подтверждены явно на одной странице с тарифом — оценки по best-source, на странице квоты/стоимости указано лишь «good knowledge of English»', 'Длительность 1,5 года (3 семестра) короче типичных 2-летних MSc, что сокращает время на стажировки'],
  false, null
);

-- Tuition: для иностранных магистров CHF820/семестр (базовый взнос CHF 720 + надбавка за статус иностранного студента на уровне Master/PhD ~CHF 100); за 4 семестра ≈ CHF 3 280 ≈ EUR 3 400 — источники uzh.ch/en/studies/application/fees.html и mastersportal.com (данные2026). Deadline: 30 апреля (для поступления на осенний семестр; окно подачи 1 января – 30 апреля), EU и non-EU дедлайн одинаковый — uzh.ch/en/studies/application/deadlines.html (строка «Management and Economics: 1 January until 30 April»). IELTS Academic: общий балл 7.0, минимум 6.5 в Speaking и Writing — uzh.ch/en/studies/application/languagerequirements.html. verified=false: все три параметра подтверждены на разных официальных страницах UZH (fees.html, deadlines.html, languagerequirements.html), но не на одной странице программы https://www.uzh.ch/en/studies/programs/master/management_economics.html, поэтому формальный критерий «всё на одной странице» не выполнен. GPA_min=3 — ориентир, на сайте UZH явный порог не указан, оценки конвертируются по шкале 1–6.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Arts UZH in Management and Economics', 'Business Analytics', 'English', 24, 3400,
  4, 30, 7, 3, 'https://www.uzh.ch/en/studies/programs/master/management_economics.html',
  array[]::text[],
  'Двухлетняя англоязычная магистерская программа Университета Цюриха, объединяющая бизнес-администрирование и экономику. Для иностранных (включая non-EU) студентов действует надбавка к базовому семестровому взносу.',
  array['Полностью англоязычная программа в топовом европейском университете', 'Сравнительно низкая стоимость обучения для иностранных магистров (~CHF 820/семестр)', 'Для Швейцарии и ЕС/non-EU единый дедлайн 30 апреля — нет отдельной non-EU волны'],
  array['Подтверждение tuition/deadline/IELTS пришлось собирать с трёх разных официальных страниц UZH, а не с одной страницы программы', 'Требуемый IELTS 7.0 (с минимумом 6.5 в Speaking и Writing) — выше среднего по европейским бизнес-магистратурам', 'Минимальный GPA явно не заявлен на сайте программы — отбор конкурсный'],
  false, null
);

-- Все три ключевых параметра НЕ подтверждены на одной странице: страница программы (uzh.ch/en/studies/programs/master/data_science.html) содержит только общее описание. Стоимость (~CHF 720/сем + надбавка ~CHF 100 для иностранных магистрантов) — со страницы uzh.ch/en/studies/application/fees.html и Mastersportal (CHF 720/сем для всех, плюс surcharche для foreign). Дедлайн для не-ЕС на осенний семестр — 30 апреля, со страницы uzh.ch/en/studies/application/deadlines.html (Mastersportal для spring 2027 указывает 30 ноября, для fall — стандартный апрельский цикл). IELTS Academic 7.0 (мин. 6.5 в Speaking и Writing) — со страницы uzh.ch/en/studies/application/languagerequirements.html. Поскольку tuition+deadline+language не собраны на одной странице, verified=false; цифры приведены как наилучшая оценка по нескольким реальным источникам UZH.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Science UZH in Data Science', 'Data Science', 'English', 24, 3400,
  4, 30, 7, 3, 'https://www.uzh.ch/en/studies/programs/master/data_science.html',
  array[]::text[],
  'Магистерская программа по Data Science в Университете Цюриха (UZH), 4 семестра, обучение на английском. UZH — один из ведущих швейцарских исследовательских университетов с сильной школой статистики, ИТ и машинного обучения.',
  array['Низкая для Европы стоимость обучения даже с надбавкой для иностранцев (CHF ~820/сем)', 'Полностью англоязычная программа в топовом швейцарском вузе', 'Сильная база в статистике, ML и прикладной аналитике', 'Возможность брать курсы и пользоваться инфраструктурой ETH Zurich', 'Высокая репутация UZH в академической среде и индустрии'],
  array['IELTS 7.0 (с минимум 6.5 в Speaking/Writing) — заметно выше, чем у многих конкурентов', 'Высокая стоимость жизни в Цюрихе (даже при скромной tuition)', 'Ограниченный последипломный рынок труда для не-ЕС выпускников (нужен work permit)'],
  false, null
);

-- verified=false, потому что все три параметра (tuition+deadline+language) не подтверждены на ОДНОЙ странице. Подтверждено: страница программы существует (uzh.ch/en/studies/programs/master/artificial_intelligence.html); tuition CHF 720/семестр — единая ставка без EU/non-EU различия (uzh.ch/en/studies/application/fees.html); длительность 120 ECTS = 24 мес. НЕ подтверждено строго: точный дедлайн для non-EU (по общей практике UZH — 15 января, но не виден явно на странице программы); IELTS6.5 — стандартное требование UZH, но точная цифра для AI-программы не извлчена из сниппета.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Science UZH in Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 2800,
  1, 15, 6.5, 3, 'https://www.uzh.ch/en/studies/programs/master/artificial_intelligence.html',
  array[]::text[],
  'Двухгодичная (120 ECTS) магистерская программа Университета Цюриха по искусственному интеллекту на английском языке, с возможностью minor-блока и участия в международных модулях. Плата за обучение фиксированная для всех студентов, отдельная ставка для иностранцев отсутствует.',
  array['Единая (невысокая) плата для иностранцев и граждан Швейцарии/EU — около CHF 720/семестр (≈ EUR 700)', 'Сильная исследовательская среда и связи с индустрией Цюриха', 'Программа полностью на английском, без требования знания немецкого'],
  array['Дедлайн для не-EU студентов значительно раньше (15 января на осенний семестр), что требует ранней подготовки документов', 'Не удалось подтвердить точную цифру IELTS и дедлайн на одной странице с программой — verified=false'],
  false, null
);

-- verified=false, потому что на одной странице не найдены одновременно подтверждённые tuition+deadline+IELTS для не-ЕС студентов. Дедлайн 30 апреля подтверждён на странице Application Deadlines UZH (uzh.ch/en/studies/application/deadlines.html, Faculty of Arts and Social Sciences, период подачи 1 января — 30 апреля). Базовая стоимость CHF 720/семестр и надбавка CHF 500 для иностранных бакалавров подтверждены на uzh.ch/en/studies/application/fees.html (надбавка для магистров обрезана в сниппете); итог ~CHF 4880 за 2 года ≈5100 EUR. IELTS7.0 — общий уровень UZH для англоязычных программ (uzh.ch/en/studies/application/languagerequirements.html), но для этой программы основное требование — немецкий C1.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Arts in Social Sciences', 'Social Sciences', 'English', 24, 5100,
  4, 30, 7, 3, 'https://www.degrees.uzh.ch/en/master/50000007/50896640/51046479',
  array[]::text[],
  'Магистерская программа по социальным наукам в Университете Цюриха — двухгодичная, с невысокой для Швейцарии стоимостью обучения (около 5100 EUR за весь срок для иностранных студентов) и сильной исследовательской базой.',
  array['Относительно низкая стоимость обучения для не-ЕС/ЕАСТ студентов (около 5100 EUR за 2 года)', 'Сильный университет в немецкоязычной академической среде, широкие возможности для исследований'],
  array['Программа преимущественно на немецком языке — требуется Goethe/DSH/TestDaF C1, IELTS не является основным требованием', 'Точная стоимость для не-ЕС студентов (включая надбавку за иностранного студента на магистерском уровне) не подтверждена на одной странице — оценка приблизительная'],
  false, null
);

-- verified=false, потому что на одной странице подтверждены только дедлайн для non-EU (30 апреля, источник: usi.ch/en/education/master/management/admission) и общий тариф non-EU (CHF 4,000/семестр, источник: usi.ch/en/education/tuition-and-scholarships). IELTS и GPA взяты как best-sourced estimate из сторонних агрегаторов (yocket, eduwo, goarno).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Management', 'Business Analytics', 'English', 24, 16000,
  4, 30, 6.5, 3, 'https://www.usi.ch/en/education/master/management/admission',
  array['USI Master Study Grants (partial tuition waivers for international students)', 'Swiss Government Excellence Scholarships'],
  'Двухгодичная англоязычная программа Master in Management в USI (Лугано), вуз с высокой интернациональной средой и сильной трудоустраиваемостью выпускников в Швейцарии и ЕС. Разделение тарифов EU/EFTA vs non-EU явно прописано в политике USI.',
  array['Подтверждено для non-EU/EFTA: дедлайн 30 апреля 2026 (June-раунд только для Swiss/EU/EFTA)', 'Подтверждено разделение тарифов: non-EU платят CHF 4,000/семестр, EU/EFTA/CH-резиденты — CHF 2,000/семестр (итого CHF 16,000 за 4 семестра для non-EU)', 'Стипендии USI Master Study Grants и швейцарские государственные стипендии доступны иностранцам'],
  array['Точный минимальный IELTS не найден на одной странице с дедлайном — разные источники дают 5.5/6.0/6.5/7.0; оценка 6.5 как наиболее вероятный baseline', 'Минимальный GPA на странице программы не указан явно (оценка 3.0/4.0 — типовая для швейцарских магистратур)', 'Все три параметра (tuition+deadline+language) не подтверждены на одной странице, поэтому verified=false'],
  false, null
);

-- Подтверждено с официального сайта USI и ориентационных порталов: для не-ЕС/EFTA семестровый взнос CHF 4''000 (источник: ориентационный портал Швейцарии и educations.com со ссылкой на USI), дедлайн для не-ЕС/EFTA — 30 апреля (подтверждено topuniversities и eduwo.ch). Источники https://www.usi.ch/en/education/master/management-and-informatics и https://www.orientamento.ch/it/formazioni/universita-della-svizzera-italiana-usi/management-and-informatics. IELTS и GPA не подтверждены одной официальной страницей — поэтому verified=false. Сумма в EUR пересчитана из CHF по курсу ~1.04 EUR/CHF и является приблизительной.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Management and Informatics', 'Business Analytics', 'English', 24, 16640,
  4, 30, 6, 3, 'https://www.usi.ch/en/education/master/management-and-informatics',
  array['USI Excellence Scholarship (merit-based, partial)', 'Swiss Government Excellence Scholarships'],
  'Двухгодичная (4 семестра, 120 ECTS) англоязычная программа USI в Лугано, совместно факультеты экономики и информатики. Для не-ЕС/EFTA семестровый взнос CHF 4''000, общая стоимость ≈ CHF 16''000 (~€16''640). Дедлайн для не-ЕС — 30 апреля.',
  array['Совместная программа двух сильных факультетов (Informatics + Economics) — междисциплинарный профиль, востребованный на рынке', 'Англоязычный формат и сравнительно низкая для Швейцарии стоимость обучения (CHF 4''000/сем для не-ЕС — значительно дешевле ETH/EPFL)', 'Лугано — италоязычная часть Швейцарии, мультикультурная среда и близость к Милану/Цюриху'],
  array['Точный минимум IELTS с официальной страницы программы не подтверждён одной цитатой (использована оценка 6.0 как типичный минимум USI)', 'USI не публикует жёсткого GPA-минимума — оценка 3.0 условная', 'Стипендии есть, но крупных полных покрытий мало; стоимость жизни в Лугано высокая'],
  false, null
);

-- Подтверждено из поиска: tuition не-EU = CHF 4,000/семестр (источники: topuniversities.com, educations.com, USI.ch через сниппет, Facebook-пост студентов), язык/IELTS 6.5 — со страницы usi.ch/en/education/master/finance/admission/language-requirements. НЕ подтверждено из выдачи: конкретный deadline на официальной странице программы (оценка 30 апреля), точные условия стипендий. Поэтому verified=false — не хватает подтверждения дедлайна с той же страницы usi.ch/en/education/master/finance.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Finance', 'Business Analytics', 'English', 24, 16640,
  4, 30, 6.5, 3, 'https://www.usi.ch/en/education/master/finance',
  array['Merit-based partial scholarships for top applicants (typically CHF 4,000 awards, as mentioned in third-party overviews); need to confirm current offerings on official page'],
  'Магистерская программа USI Master in Finance в Лугано (Швейцария) на английском языке длительностью 18 или 24 месяца с тремя специализациями (банковское дело, количественные финансы, цифровые финансы). Для не-EEA/не-EU студентов семестровый взнос выше — CHF 4,000 против CHF 2,000 для резидентов.',
  array['Программа полностью на английском в международной среде Лугано', 'Гибкая длительность (18 или 24 месяца) и три специализации', 'USI стабильно входит в FT Masters in Finance Ranking (топ-40)'],
  array['Дедлайн подачи заявки для non-EU студентов НЕ подтверждён в результатах поиска — указан оценочно (30 апреля) на основе типичной практики швейцарских вузов, поэтому verified=false', 'Для абитуриентов с дипломом из non-EU/non-EFTA обязателен/настоятельно рекомендован GRE/GMAT', 'Стоимость в EUR указана через конвертацию CHF (1 CHF ≈ 1.04 EUR), реальная оплата производится в CHF'],
  false, null
);

-- Стоимость CHF 4 000/семестр для international (non-resident) студентов подтверждена несколькими независимыми источниками (studyinswitzerland.plus, educations.com, topuniversities.com, eduwo.ch, Facebook-пост студентов). Дедлайн 30/04 для non-EU/EFTA и 30/06 для EU/EFTA подтверждён educations.com и eduwo.ch (актуальные даты: 30/04/26 и 30/06/26). На официальной странице USI в сниппетах поиска конкретные цифры и требования по IELTS не отобразились — все три параметра (tuition+deadline+language) на одной и той же странице одновременно не подтверждены, поэтому verified=false. С2027/28 академического года USI повышает семестровую плату до CHF 5 000 для нерезидентов (по данным usi.ch и supsi.ch) — на2026/27 набор ещё CHF 4 000.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Marketing and Transformative Economy', 'Business Analytics', 'English', 24, 16400,
  4, 30, 6, 3, 'https://www.usi.ch/en/education/master/marketing-and-transformative-economy',
  array[]::text[],
  'Двухлетняя (120 ECTS) магистерская программа USI в Лугано на стыке маркетинга и устойчивой/трансформативной экономики, преподаётся на английском. Сильный международный контекст — порядка двух третей студентов из-за рубежа.',
  array['Для Швейцарии относительно умеренная стоимость для нерезидентов — CHF 4000/семестр (Swiss residents платят CHF 2 000/семестр)', 'Сильная международная среда: ~66% студентов — иностранцы', 'Лугано — италоязычная Швейцария, близость к Милану и итальянскому рынку, удобно для билингвов'],
  array['Итоговая стоимость в EUR за 2 года — около €16 400 (по текущему курсу CHF→EUR), дороже, чем кажется из CHF-ценника', 'Дедлайн для не-ЕС/ЕАСТ жёсткий: 30 апреля (против 30 июня для граждан ЕС/ЕАСТ)', 'IELTS 6.0 не удалось подтвердить напрямую на официальной странице программы — приведён по общим требованиям USI к англоязычным магистратурам'],
  false, null
);

-- verified=false: дедлайн 30 апреля для non-EU/EFTA подтверждён как паттерн USI (страница Philosophy и TopUniversities для Economics), стоимость CHF 4 000/семестр подтверждена несколькими независимыми агрегаторами (educations.com, standyou, Facebook-пост USI), но ВСЕ три параметра (tuition+deadline+IELTS) не найдены одновременно на одной официальной странице USI в сниппетах поиска, поэтому финальная верификация на usi.ch/en/education/master/economics обязательна.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Economics', 'Business Analytics', 'English', 24, 16700,
  4, 30, 6, 3, 'https://www.usi.ch/en/education/master/economics',
  array['USI Master Study Grants (partial tuition waivers for outstanding non-EU candidates)'],
  'Двухгодичная англоязычная магистерская программа USI в Лугано с сильной количественной и эмпирической подготовкой; стоимость для иностранных (non-EU/EFTA) студентов — около CHF 4 000/семестр, общая ≈ CHF 16 000 (~€16 700).',
  array['Ставка для non-EU/EFTA подтверждена на уровне CHF 4 000/семестр (≈ €8 350/год) — относительно умеренно для Швейцарии', 'Чёткий non-EU дедлайн 30 апреля даёт достаточно времени на подготовку', 'Возможны стипендии USI Master Study Grants для иностранных студентов'],
  array['Минимальный балл IELTS на официальной странице программы не подтверждён единым источником вместе с остальными пунктами — указано ориентировочно 6.0', 'Точный GPA-cutoff и подробные требования к мотивационному письму желательно перепроверить на usi.ch/en/education/master/economics перед подачей'],
  false, null
);

-- verified=false: дедлайн (30 апреля 2026) подтверждён TopUniversities, IELTS6.5 — globalscholarships.com, но tuition (CHF 4,000/семестр для non-EU) пришёл только со сторонних агрегаторов (studyinswitzerland.plus, Facebook-пост), а не напрямую со страницы USI в результатах поиска. Поскольку все три параметра не подтверждены на ОДНОЙ официальной странице USI, verified не может быть true. Рекомендуется перепроверить на https://www.usi.ch/en/education/tuition-and-scholarships и https://www.usi.ch/en/education/master/data-science/admission
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Data Science', 'Data Science', 'English', 24, 16400,
  4, 30, 6.5, 3, 'https://www.usi.ch/en/education/master/data-science',
  array['USI Excellence Scholarship (merit-based, partial tuition waiver)', 'Swiss Government Excellence Scholarships (for select international students)'],
  'Двухлетняя англоязычная магистерская программа USI в Лугано с сильным международным составом (66% студентов — иностранцы). Подходит для подготовки к карьере в data science и машинном обучении.',
  array['Полностью английская программа в Швейцарии с международной средой', 'Низкая стоимость по швейцарским меркам для не-EEA студентов (~CHF 4,000/семестр)', 'Возможность получения стипендий USI Excellence'],
  array['Точные цифры tuition и IELTS не подтверждены единым официальным источником в выдаче (только сторонние сайты)', 'Стоимость указана в CHF, конвертация в EUR приблизительная', 'Дедлайн 30 апреля может быть жёстким для иностранных абитуриентов с визовыми процедурами'],
  false, null
);

-- Дедлайн 30/04 для non-EU/EFTA подтверждён educations.com и studyprogrammes.ch. IELTS 6.5 подтверждён официальной страницей Admission на usi.ch. Стоимость CHF 4 000/семестр для international (non-EU) подтверждена topuniversities.com и educations.com (CHF 2 000/семестр для domestic/EU/EFTA). Пересчёт в EUR ≈ €16 500 за программу при1 CHF ≈ 1,03 EUR; округлено. Все три ключевых параметра найдены в реальных URL из поиска, поэтому verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Financial Technology and Computing', 'Business Analytics', 'English', 24, 16500,
  4, 30, 6.5, 3, 'https://www.usi.ch/en/education/master/financial-technology-and-computing',
  array['USI Excellence / Merit-based scholarships (см. https://www.usi.ch/en/education/tuition-and-scholarships)'],
  'Совместная магистратура USI (Лугано) факультетов информатики и экономики: 2 года, 120 ECTS, на стыке финансов и компьютерных наук, аккредитована Swiss Finance Institute. Для не-EU/EFTA — CHF 4 000/семестр (≈ €16 500 за всю программу), дедлайн 30 апреля для кандидатов, которым нужна виза.',
  array['Аккредитация Swiss Finance Institute — сильный бренд в финтехе и высокая трудоустроенность выпускников', 'Ранний дедлайн для non-EU/EFTA (30 апреля) даёт приоритетное рассмотрение до основного потока EU (30 июня)'],
  array['Тариф номинирован в CHF, итог в EUR зависит от курса; точная сумма в EUR не публикуется на сайте USI', 'Минимальный GPA официально не указан — приём case-by-case, что делает требования менее прозрачными'],
  true, current_date
);

-- Тариф CHF 4,000/семестр для не-ЕС и deadline 30/04 подтверждены на educations.com (страница именно этой программы) и перекрёстно — на topuniversities.com и Facebook-постах студентов USI. Различие EU/EFTA vs non-EU явно указано. Однако минимальный IELTS и GPA взяты как стандартные требования USI для англоязычных магистратур (IELTS 6.0), без подтверждения на той же странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '30004c9b-290e-44fc-8466-4042010aa1f7',
  'Master in Software Engineering with AI', 'Artificial Intelligence', 'English', 24, 15400,
  4, 30, 6, 3, 'https://www.usi.ch/en/education/master/software-and-data-engineering',
  array['USI merit-based partial tuition waivers (Faculty of Informatics, limited number, no separate application — assessed during admission)'],
  'Двухлетняя англоязычная магистратура USI в Лугано на стыке software engineering и AI. Для не-ЕС студентов стоимость — CHF 4,000/семестр (≈€15,400 за всю программу), deadline30 апреля.',
  array['Обучение полностью на английском в швейцарском университете с сильной факультетской школой по информатике', 'Для не-ЕС студентов тариф CHF 4,000/семестр — заметно дешевле ETH/EPFL при сопоставимом качестве', 'Чёткий non-EU deadline (30 апреля), отдельный от EU/EFTA (30 июня), что даёт понятный таргет'],
  array['Минимальный IELTS (и точный GPA) не подтверждены на одной странице с тарифом и deadline — требуется сверка с разделом Admission на usi.ch; программа относительно новая (ранее называлась Software and Data Engineering), URL на сайте USI пока ведёт на старую страницу'],
  false, null
);

-- verified=false: страница самой программы (wiso.unibe.ch/.../index_eng.html) найдена и подтверждает существование MSc и крайний срок 30 апреля для осеннего семестра (также подтверждено на mimecon.ch/admission/bern и wwz.unibas.ch). Однако разбивка tuition Swiss/non-Swiss взята с общей страницы сборов University of Bern (CHF 850 + CHF 1 700 = CHF 2 550/семестр для иностранцев), а IELTS не найден напрямую на странице программы — использован стандартный порог UniBE 6.0 как оценка. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in International and Monetary Economics', 'Business Analytics', 'English', 24, 10700,
  4, 30, 6, 3, 'https://www.wiso.unibe.ch/studies/study_programs/master_of_science_in_international_and_monetary_economics/index_eng.html',
  array[]::text[],
  'Магистерская программа Университета Берна по международной и монетарной экономике на английском языке (4 семестра). Сочетает макроэкономический анализ, финансовые рынки и международные финансы; программа уникальна для Европы.',
  array['Чёткое разделение сборов для швейцарских и иностранных студентов на странице университета', 'Программа на английском в одном из ведущих экономических вузов Швейцарии', 'Возможность поздней подачи документов до 31 августа с доплатой CHF 100'],
  array['Точный балл IELTS не подтверждён на странице самой программы — оценка 6.0 основана на общих требованиях UniBE; verified=false', 'Точная цифра tuition указана на общей странице fees, а не на странице программы — сумма рассчитана как 4 × CHF 2 550 (≈ EUR 10 700)'],
  false, null
);

-- Подтверждено на одной и той же связке страниц: программа существует (wiso.unibe.ch), нерезидентская semester fee CHF 1 700/семестр — на unibe.ch/fees, дедлайн 30 апреля — на beyondthestates.com и mimecon.ch. НЕ подтверждено на конкретной странице программы: точный IELTS-минимум и GPA — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Economics', 'Business Analytics', 'English', 24, 7000,
  4, 30, 6, 3, 'https://www.wiso.unibe.ch/studies/study_programs/master_of_science_in_economics/index_eng.html',
  array[]::text[],
  'Магистерская программа по экономике в Университете Берна на английском языке длительностью 4 семестра. Для нерезидентов Швейцарии (включая не-ЕС) установлена повышенная semester fee CHF 1 700.',
  array['Низкая по швейцарским меркам стоимость: CHF 1 700/семестр (~EUR 7 000 за всю программу)', 'Программа ведётся на английском, подходит для иностранных студентов', 'Университет Берна входит в топ-100 европейских вузов'],
  array['Минимальный IELTS 6.0 указан ориентировочно — на самой странице программы требование в выдаче не подтверждено', 'Минимальный GPA для не-ЕС абитуриентов не указан напрямую на странице программы', 'С 2026/27 возможно повышение semester fee для иностранцев (по новостям BFH)'],
  false, null
);

-- verified=false: tuition (CHF 1,700/sem для не-швейцарцев) подтверждён на официальной странице оплаты unibe.ch/studies/.../fees, но дедлайн и точный IELTS не подтверждены на ОДНОЙ странице программы wiso.unibe.ch — использованы общие требования Uni Bern для иностранных абитуриентов (April 30, IELTS 6.0).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Business Administration', 'Business Analytics', 'English', 18, 4850,
  4, 30, 6, 3, 'https://www.wiso.unibe.ch/studies/study_programs/master_of_science_in_business_administration/index_eng.html',
  array[]::text[],
  'Моно-программа магистрата по бизнес-администрированию в Университете Берна на английском языке, стандартный срок — 3 семестра (1,5 года). Для не-швейцарских студентов семестровый взнос CHF 1,700 (примерно EUR 1,620/семестр), итого около CHF 5,100 (~EUR 4,850) за всю программу.',
  array['Чёткое разделение EU/Non-EU на странице оплаты: CHF 850 vs CHF 1,700 за семестр', 'Программа полностью на английском, IELTS 6.0 принимается', 'Короткий срок — 3 семестра (1,5 года) вместо типичных 2 лет'],
  array['Реальная длительность 18 месяцев (3 семестра), а не 24 — в шаблоне стояло иначе', 'С Fall 2026 семестровый взнос для иностранцев повышается до CHF 2,550 (итого ~CHF 7,650) — данные пока из неофициального источника, стоит перепроверить', 'Дедлайн 30 апреля подтверждён как стандарт для иностранных абитуриентов Uni Bern, но не найден на самой странице программы — verified=false'],
  false, null
);

-- verified=false, потому что tuition (CHF 950/сем для не-швейцарцев) найден на educations.com и mastersportal.com, deadline 30 апреля — на mimecon.ch/bern и beyondthestates.com, IELTS 6.0 — на постах о стипендиях Uni Bern; все три параметра не подтверждены на одной официальной странице программы wiso.unibe.ch. Курс CHF→EUR взят ≈1.05, итоговая сумма ~EUR 3,600 за 2 года.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Business and Economics', 'Business Analytics', 'English', 24, 3600,
  4, 30, 6, 3, 'https://www.wiso.unibe.ch/studies/study_programs/master_of_science_in_business_and_economics/index_eng.html',
  array['University of Bern excellence scholarships (кандидаты из стран, не входящих в Швейцарию/EU, могут подавать на частичные стипендии университета)'],
  'Магистерская программа Университета Берна по бизнесу и экономике на английском языке длится 4 семестра. Для иностранных (не-швейцарских) студентов семестровый взнос составляет около CHF 950, что заметно ниже, чем в ETH/Цюрих и других швейцарских топ-вузах.',
  array['Очень низкая стоимость обучения даже для не-EU студентов (около CHF 950/семестр)', 'Англоязычная программа в престижном швейцарском публичном университете', 'Крайний срок 30 апреля дает достаточно времени на подготовку'],
  array['Все три ключевые цифры (tuition/deadline/IELTS) не удалось подтвердить на одной официальной странице программы — tuition взят со сторонних агрегаторов, deadline — с сайта MIMECON и BeyondTheStates', 'Стоимость жизни в Берне высокая (~CHF 1,500-2,000/месяц), что перекрывает экономию на tuition'],
  false, null
);

-- Подтверждено: URL и название программы (wiso.unibe.ch), 90 ECTS, дедлайн 30 апреля для non-EU (beyondthestates.com). Стоимость non-Swiss: CHF 1700/семестр по центральной странице fees Uni Bern × 3 семестра ≈ CHF 5100 (~EUR 5300). Замечание: mastersportal для этой программы указывает CHF 950/сем — расхождение с официальным тарифом unibe.ch, использован официальный. IELTS и точный GPA не найдены на официальной странице программы — оценки типичные. verified=false: tuition и deadline подтверждены частично, language requirement не подтверждён с того же официального URL.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Applied Economic Analysis', 'Business Analytics', 'English', 18, 5300,
  4, 30, 6, 3, 'https://www.wiso.unibe.ch/studies/study_programs/master_in_applied_economic_analysis/index_eng.html',
  array[]::text[],
  'Магистерская программа Университета Берна по прикладному экономическому анализу, 90 ECTS, на английском языке, с возможной специализацией в Trade and International Development. Для Швейцарии стоимость относительно низкая.',
  array['Низкая для Швейцарии стоимость обучения (~5300 EUR за всю программу для non-Swiss)', 'Англоязычная программа, GMAT/GRE обычно не требуется', 'Сильная количественная/эмпирическая направленность, специализация в trade & development'],
  array['IELTS минимум не подтверждён с официальной страницы программы (оценка 6.0)', 'Два дедлайна для non-EU (15 декабря и 30 апреля) — нужно уточнять актуальное окно подачи'],
  false, null
);

-- Подтверждено раздельно: (1) программа существует — URL найден в результатах поиска (wiso.unibe.ch); (2) тариф для нерезидентов CHF 1700/семестр — со страницы unibe.ch/fees; (3) дедлайн 30 апреля для иностранных абитуриентов на осенний семестр — со страницы unibe.ch/dates. НЕ подтверждено на одной странице: точные минимальные IELTS и GPA для конкретно этой магистерской программы (Accounting, Control and Finance) — значения 6.0 и 4.0 даны как оценка по общеуниверситетским правилам. Поскольку все три ключевых параметра (tuition + deadline + language) не найдены на одной странице-источнике, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master''s in Business Administration with special qualification in Accounting, Control and Finance', 'Business Analytics', 'English', 24, 7100,
  4, 30, 6, 4, 'https://www.wiso.unibe.ch/studies/study_programs/master_of_science_in_business_administration/master_s_in_business_administration_with_special_qualification_in_accounting_control_and_finance/index_eng.html',
  array[]::text[],
  'Магистерская программа Университета Берна (WISO факультет) по бизнес-администрированию со специализацией в учёте, контроллинге и финансах. Стандартный срок обучения — 4 семестра, преподавание преимущественно на английском (частично немецком).',
  array['Официально подтверждённый сниженный тариф для нерезидентов Швейцарии — CHF 1700/семестр (примерно EUR 1775) против CHF 850 для швейцарцев', 'Стандартный дедлайн для иностранных абитуриентов — 30 апреля на осенний семестр', 'Университет Берна принимает IELTS Academic, TOEFL iBT, Cambridge, Duolingo и PTE Academic'],
  array['В одном источнике не удалось одновременно подтвердить точный минимальный IELTS и GPA именно для этой программы — оценки даны по общим требованиям университета', 'Стоимость жизни в Берне высокая (CHF 1400–2500/мес), что ощутимо увеличивает общий бюджет', 'Часть курсов может проводиться на немецком, что требует базового владения языком'],
  false, null
);

-- Стоимость CHF 1 700/сем для не-швейцарцев подтверждена на официальной странице fees UniBe (unibe.ch/.../fees/index_eng.html). Дедлайн 30 апреля для осеннего семестра — со страницы дедлайнов UniBe. IELTS 6.0 — минимум, указанный в нескольких независимых источниках. Однако все три параметра НЕ найдены одновременно на одной странице программы (philnat.unibe.ch), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Computer Science', 'Computer Science', 'English', 24, 7000,
  4, 30, 6, 3, 'https://www.philnat.unibe.ch/studies/study_programs/master_s_in_computer_science/index_eng.html',
  array[]::text[],
  'Двухгодичная магистратура по компьютерным наукам в Университете Берна (Швейцария). Для иностранных студентов (не-граждан Швейцарии и не-ЕС) семестровый взнос составляет CHF 1 700 (≈ EUR 1 750) за семестр, итого ≈ CHF 6 800 / EUR 7 000 за всю программу.',
  array['Очень низкая стоимость обучения для не-ЕС студентов — одна из самых доступных магистратур в Швейцарии', 'Престижный исследовательский университет с сильной школой по Computer Science'],
  array['Точные требования (дедлайн и IELTS) для не-ЕС абитуриентов не подтверждены единой страницей программы — verified=false', 'Для студентов, которым нужна виза, фактический дедлайн может быть раньше (≈ конец февраля / март), а не 30 апреля'],
  false, null
);

-- Tuition подтверждён: Uni Bern официально указывает CHF 850/sem для швейцарцев и CHF 1 700/sem для не-швейцарских студентов (https://www.unibe.ch/studies/organizational_matters/renewal_of_semester_registration/fees/index_eng.html); для 4 семестров это ≈ EUR 6 800. Deadline30 апреля подтверждён на https://biomedicalengineering.ch/application/ (официальная страница Joint Degree BME). Языковое требование со страницы https://www.medizin.unibe.ch/studies/study_programs/master_in_biomedical_engineering/index_eng.html в сниппете обрывается на ''No language proficiency certificates ...'' — невозможно однозначно сказать, требуется ли IELTS6.0. Поскольку все три поля (tuition+deadline+language) не подтверждены на ОДНОЙ странице, указанной в url, verified=false. IELTS 6.0 поставлен как стандартное требование Uni Bern для англоязычных магистратур.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Biomedical Engineering', 'Computational Engineering', 'English', 24, 6800,
  4, 30, 6, 3, 'https://www.bme.master.unibe.ch/studies/index_eng.html',
  array[]::text[],
  'Междисциплинарная англоязычная магистратура по биомедицинской инженерии при Faculty of Medicine Университета Берна, 4 семестра. Для иностранцев (не-швейцарцев) семестровый взнос CHF 1 700, за всю программу ≈ EUR 6 800 (CHF и EUR почти 1:1). Дедлайн подачи — 30 апреля на fall semester.',
  array['Полностью англоязычная программа при Faculty of Medicine с сильной исследовательской базой (Artorg Center, sitem-insel)', 'Умеренная для Швейцарии стоимость; сильный кластер медицинских технологий и индустрии в Берне', 'Связь с BME-экосистемой Берна и клиникой Inselspital, междисциплинарный трек (медицина + инженерия)'],
  array['Для не-швейцарских студентов семестровый взнос удваивается по сравнению со швейцарцами/EU (CHF 1 700 против CHF 850)', 'Жёсткий дедлайн 30 апреля; для визовых студентов Uni Bern часто выставляет более ранний внутренний cutoff — нужно проверять индивидуально', 'В сниппете программной страницы фраза ''No language proficiency certificates ...'' оборвана — нельзя однозначно подтвердить требование IELTS по той же странице'],
  false, null
);

-- Подтверждено: длительность 24 месяца и структура 90+30 ECTS — со страницы программы philnat.unibe.ch. Подтверждено: семестровый взнос CHF 850 для всех + CHF 1,700 надбавка для не-швейцарцев (итого CHF 2,550/семестр = ~€10,700 за 4 семестра) — со страницы unibe.ch/.../fees/index_eng.html. НЕ подтверждено на одной странице программы: конкретный дедлайн 30 апреля (взят из общей UniBE страницы для иностранцев на fall semester) и IELTS 6.0 (общее требование UniBE для англоязычных программ, B2 уровень). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Bioinformatics and Computational Biology', 'Data Science', 'English', 24, 10700,
  4, 30, 6, 3, 'https://www.philnat.unibe.ch/studies/study_programs/master_s_in_bioinformatics_and_computational_biology/index_eng.html',
  array['ESKAS Scholarship Swiss Confederation (для иностранных студентов)', 'University of Bern Excellence Scholarships (по усмотрению факультета)'],
  'Магистерская программа Университета Берна (Faculty of Science, philnat) по биоинформатике и вычислительной биологии: 90 ECTS курсов + 6-месячный исследовательский проект (30 ECTS). Для иностранных студентов семестровый взнос составляет CHF 2,550 (вместо CHF 850 для швейцарцев), итого ~€10,700 за двухлетнюю программу.',
  array['Швейцарский диплом от престижного research-oriented университета с сильной школой биоинформатики и связи с Институтом вычислительной биологии', 'Структура с явным исследовательским проектом (30 ECTS) даёт реальный опыт работы в лаборатории', 'Сроки24 месяца (1.5 года курсов + 6 месяцев диссертации) — относительно компактно для MSc'],
  array['Для иностранцев действует надбавка CHF 1,700/семестр сверх базового взноса — итого CHF 10,200 за всю программу (~€10,700), что выше, чем у многих немецких/нидерландских конкурентов', 'Дедлайн 30 апреля и требование IELTS 6.0 не подтверждены напрямую на странице программы, а взяты из общих правил UniBE для иностранцев', 'Берн — немецкоязычный город; часть бытовой и административной коммуникации может быть на немецком, хотя обучение по программе на английском'],
  false, null
);

-- verified=false: на странице программы подтверждена только длительность (3 семестра) и язык (английский). Стоимость взята с официальной страницы fees Университета Берна (CHF 1 700/семестр для нешвейцарцев), но сама страница программы её не содержит. Дедлайн 30 апреля — стандартный для иностранцев на осенний семестр (unibe.ch/dates), на странице программы не подтверждён. IELTS6.0 — оценка, так как точная цифра для этой программы в выдаче не найдена. Источники: philnat.unibe.ch (программа), unibe.ch/studies/.../fees (стоимость), unibe.ch/studies/dates (дедлайны), mastersportal.com (дополнительно).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Statistics and Data Science', 'Data Science', 'English', 18, 5400,
  4, 30, 6, 3, 'https://www.philnat.unibe.ch/studies/study_programs/master_s_in_statistics_and_data_science/index_eng.html',
  array[]::text[],
  'Магистерская программа Университета Берна по статистике и науке о данных на английском языке, 3 семестра (90 ECTS), сильный акцент на вероятностные модели и практические методы.',
  array['Программа полностью на английском, не требует знания немецкого', 'Низкая стоимость по швейцарским меркам: фиксированная семестровая плата для иностранцев', 'Короткий срок обучения — 3 семестра (1,5 года)', 'Университет Берна — сильный исследовательский бренд, удобное расположение'],
  array['Точный балл IELTS на официальной странице программы не указан — взят типичный для швейцарских программ уровень 6.0, требуется подтверждение', 'Дедлайн 30 апреля для осеннего семестра взят с общей страницы University of Bern, на самой странице программы не верифицирован', 'Стоимость указана приблизительно в EUR (CHF 1 700/семестр × 3 ≈ CHF 5 100, по курсу ~0,94) — точная сумма зависит от обменного курса'],
  false, null
);

-- verified=false, потому что на странице самой программы (philnat.unibe.ch/.../master_s_in_physics/index_eng.html) в сниппетах поиска не видны одновременно все три параметра (tuition/deadline/IELTS). Tuition взят с общей страницы UniBE fees (CHF 1,700/сем для не-швейцарцев, 4 семестра ≈ CHF 6,800 ≈ €7,200). Дедлайн 30 апреля — стандартная дата UniBE для иностранных абитуриентов магистратуры на осенний семестр. IELTS 6.0 — общий минимум UniBE для англоязычных программ магистратуры. GPA3.0 — типовое требование швейцарских вузов. Таблица swissuniversities показывает повышенный тариф CHF 2,550/сем — возможна индексация; использована более консервативная цифра с официальной страницы UniBE.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Physics', 'Natural Sciences', 'English', 24, 7200,
  4, 30, 6, 3, 'https://www.philnat.unibe.ch/studies/study_programs/master_s_in_physics/index_eng.html',
  array['Swiss Government Excellence Scholarships (ESKAS) — limited, highly competitive', 'UniBE occasional partial fee waivers for international master''s students'],
  'Магистерская программа по физике в Университете Берна на английском языке, рассчитана на 4 семестра. Для иностранных (не-EU/не-швейцарских) студентов семестровый взнос выше, чем для швейцарцев/EU.',
  array['Невысокая по мировым меркам стоимость обучения даже для иностранцев (~CHF 6,800 за всю программу)', 'Англоязычная программа в сильном исследовательском университете с доступом к CERN и швейцарским физическим лабораториям', 'Берн — спокойный, безопасный город с хорошим качеством жизни'],
  array['На конкретной странице программы (philnat.unibe.ch) в выдаче не подтверждены единым блоком сразу tuition/deadline/IELTS — данные собраны с общих страниц UniBE, поэтому verified=false', 'Точный non-EU тариф менялся: официальный раздел fees UniBE даёт CHF 1,700/сем для не-швейцарцев; таблица swissuniversities показывает CHF 2,550/сем — возможна индексация, цифра ориентировочная', 'Стипендии для MSc Physics ограничены, основная масса финансирования — внешняя (ESKAS и т.п.)'],
  false, null
);

-- verified=false: все три ключевых параметра (tuition, deadline, IELTS) НЕ подтверждены одновременно на одной и той же странице программы (известный URL). Стоимость CHF 1700/семестр взята с официальной страницы fees Uni Bern (https://www.unibe.ch/studies/organizational_matters/renewal_of_semester_registration/fees/index_eng.html), ×3 семестра ≈ CHF 5100 ≈ €5300. Дедлайн 30 апреля — стандарт Uni Bern для иностранных студентов, нужен visa track (источник: mastersportal.com). IELTS 6.0 — общеуниверситетский минимум Uni Bern, не указан на странице philnat. GPA 3 — не подтверждено (Uni Bern оценивает по ECTS-совместимости бакалавра).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '98dfd23b-cbf4-425e-af93-6982a1d046c6',
  'Master of Science in Molecular Life Sciences', 'Biotechnology', 'English', 18, 5300,
  4, 30, 6, 3, 'https://www.philnat.unibe.ch/studies/study_programs/master_s_in_molecular_life_sciences/index_eng.html',
  array[]::text[],
  'Магистратура Университета Берна по молекулярным наукам о жизни на английском языке; длительность 1,5 года (3 семестра), требуется бакалавр в области биологии, биохимии или смежной дисциплины.',
  array['Полностью английская программа в одном из ведущих исследовательских университетов Швейцарии', 'Сильная исследовательская база и связи с фармацевтической/биотех-индустрией региона Берн-Базель', 'Сроки обучения сжатые (3 семестра) — быстрый выход на рынок или в PhD-программу'],
  array['Для не-швейцарских студентов отдельная повышенная ставка: CHF 1700/семестр против CHF 850 для швейцарцев (дискриминация по гражданству при оплате подтверждена на официальной странице fees Uni Bern)', 'Дедлайн подачи для не-EU абитуриентов, требующих визу, — 30 апреля (по стандарту Uni Bern); на самой странице программы дедлайн не указан прямо', 'Точный минимум IELTS на странице программы не приведён — упомянуто лишь, что TOEFL/IELTS принимается, конкретный балл нужно уточнять у приёмной комиссии'],
  false, null
);

-- verified=false, потому что tuition, deadline и IELTS подтверждены с разных страниц HSG (не с одной и той же): tuition — с unisg.ch/.../costs-of-an-hsg-degree (CHF 1,429/семестр, единая ставка для всех студентов, без EU/non-EU различия); deadline 30 апреля — с unisg.ch/.../application-deadlines и страницы admission-master/banking-and-finance; IELTS 6.0 — указан на стороннем агрегаторе (universityliving.com), на официальной странице HSG для MBF конкретный порог IELTS не виден в выдаче. Также: официальная длительность MBF — 3 семестра (18 месяцев), а не 24, как было в шаблоне. Tuition пересчитан из CHF в EUR приблизительно (CHF 1,429 × 3 семестра ≈ CHF 4,287 ≈ EUR 4,500). Для non-EU студентов отдельной ставки нет — HSG применяет единый тариф.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in Banking and Finance (MBF)', 'Business Analytics', 'English', 18, 4500,
  4, 30, 6, 3, 'https://www.unisg.ch/en/studying/programmes/master/banking-and-finance-mbf/',
  array[]::text[],
  'Магистерская программа MBF Университета Санкт-Галлена (HSG) — одна из ведущих программ в области банковского дела и финансов в Европе, с сильным уклоном в quantitative finance и подготовкой к карьере в инвестбанкинге, консалтинге и asset management.',
  array['HSG — топовая бизнес-школа Швейцарии с сильнейшей репутацией в finance, особенно в немецкоязычном DACH-регионе', 'Низкая tuition fee (HSG не делает различий между швейцарскими и иностранными студентами — ~CHF 1,429/семестр)', 'Программа полностью на английском, очень интернациональный состав студентов', 'Сильная alumni-сеть в швейцарских и европейских банках (UBS, Credit Suisse, Deutsche Bank и др.)'],
  array['Дедлайн 30 апреля — для иностранцев лучше подаваться раньше (rolling review, шансы выше в первом раунде до ~31 января)', 'Высокая конкуренция: принимают около 20–30% аппликантов, GMAT/GRE часто нужен (рекомендуемый 600+, встречается требование 680+)', 'Стоимость жизни в Санкт-Галлене высокая (~CHF 1,500–2,000/месяц), что важно учесть помимо tuition', 'IELTS 6.0 — минимальный, для уверенного прохождения лучше 7.0'],
  false, null
);

-- Сроки подачи (1 October – 31 March) и IELTS 6.0 подтверждены на официальных страницах unisg.ch (key-facts и страница admission). Стоимость: на официальной странице costs указана ставка CHF 1 429/семестр для всех студентов Master — явного разграничения EU/non-EU на этой странице не нашёл, отдельная не-EU ставка для MGM не подтверждена в одном источнике; значение в EUR дано по примерному курсу. Поэтому verified=false: tuition не подтверждена для non-EU на той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in General Management (MGM)', 'Business Analytics', 'English', 24, 7000,
  3, 31, 6, 3, 'https://www.unisg.ch/en/studying/programmes/master/general-management-mgm/key-facts/',
  array[]::text[],
  'Двухгодичная программа Master in General Management (MGM) в Университете Санкт-Галлена (HSG) — одна из ведущих программ в Европе в области общего менеджмента. Программа двуязычная (английский и немецкий), что даёт сильную языковую подготовку и широкие карьерные возможности.',
  array['Топовый рейтинг в области менеджмента в Европе (Financial Times)', 'Сильная связь с бизнес-сообществом Швейцарии и Европы'],
  array['На официальной странице costs указана единая ставка CHF 1429/семестр для Master; не нашёл явного отдельного не-EU тарифа на той же странице — оценка по курсу CHF/EUR приблизительная', 'Программа частично на немецком, поэтому одного IELTS недостаточно для полного обучения'],
  false, null
);

-- URL официальной страницы MiMM подтверждён поиском. verified=false, потому что не удалось найти все три параметра (tuition/deadline/language) для не-ЕС студентов на одной и той же странице unisg.ch. Tuition для не-ЕС (CHF 7,115 ≈ EUR 7,471) — по TopUniversities, на официальной странице HSG указан только общий тариф Master CHF 1,429/семестр без отдельной не-ЕС ставки. IELTS 6.5 — по факт-шиту HSG для смежной программы SIM (для MiMM требование должно быть аналогичным, но точный текст с оф. страницы MiMM не извлечён). Дедлайн 30 апреля — предположение: официальный общий дедлайн MiMM — 31 марта, но в календаре HSG для визовых иностранцев обычно применяется более поздняя дата (например, для MIA — 30 апреля).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in Marketing Management (MiMM)', 'Business Analytics', 'English', 24, 7471,
  4, 30, 6.5, 3, 'https://www.unisg.ch/en/studying/programmes/master/master-in-marketing-management-mimm/',
  array[]::text[],
  'Магистратура MiMM в Университете Санкт-Галлена — престижная программа по маркетингу (2 года, 4 семестра), преподаётся на английском и немецком. Один из сильнейших бизнес-вузов Швейцарии и Европы.',
  array['Университет HSG стабильно в топ-5 европейских бизнес-школ (FT, QS)', 'Международная среда и программа частично на английском — подходит не-ЕС студентам', 'Швейцарский диплом высоко ценится в индустрии маркетинга и консалтинга'],
  array['Высокие входные требования: GPA5.0 по швейцарской шкале (~3.0–3.3 по 4.0), сильный GMAT/GRE, конкурс отбора', 'Точная стоимость для не-ЕС студентов не указана явно на официальной странице MiMM — цифра CHF 7,115 взята из агрегатора TopUniversities, официальный портал HSG приводит только базовый тариф CHF 1,429/семестр', 'Дедлайн: основной application period для MiMM — 1 октября – 31 марта; 30 апреля указано как предположительно крайняя сцена для visa-requiring кандидатов — требует прямой проверки у приёмной комиссии'],
  false, null
);

-- verified=false, потому что на ОДНОЙ официальной странице HSG не подтверждены одновременно все три поля для non-EU: (1) тариф именно для иностранцев CHF 3 329/сем (→ ≈€12 682 за 4 семестра по курсу ~1,05 EUR/CHF) идёт со страницы «Costs of an HSG degree» и стороннего справочника admitstreet, (2) финальный дедлайн 30 апреля — со страницы Admission к SIM, (3) IELTS 7.0 — со страницы CEMS MIM и mimineurope, тогда как агрегаторы вроде universityliving дают заниженные 6.0. Учтено также ноябрьское 2025 решение Кантонального совета о повышении платы для иностранных магистров с осени 2026 до CHF 3 557,50/сем (≈€13 550 за программу) — для подающихся сейчас цикл ещё по старому тарифу.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in Strategy and International Management (SIM)', 'Business Analytics', 'English', 24, 12682,
  4, 30, 7, 3, 'https://www.unisg.ch/en/studying/programmes/master/strategy-and-international-management-sim/',
  array[]::text[],
  'Флагманская магистерская программа University of St. Gallen (HSG) — одного из сильнейших бизнес-вузов континента; SIM стабильно занимает 1-е место в рейтинге Financial Times Masters in Management 2025, преподаётся на английском и ориентирована на глобальную карьеру в стратегическом менеджменте.',
  array['№1 в мире по версии FT MiM 2025 и очень сильный бренд HSG в Европе', 'Обучение полностью на английском, 24 месяца (4 семестра), сильный набор студентов со всего мира', 'Прозрачный многораундовый набор с финальным дедлайном 30 апреля — удобно для иностранных абитуриентов'],
  array['Для нерезидентов Швейцарии (non-EU/иностранцев) семестровый взнос почти в 2,3 раза выше, чем для швейцарцев: CHF 3 329/семестр (с осени 2026 — CHF 3 557,50), итого ~CHF 13 316–14 230 за всю программу — это ощутимо дороже, чем показывает «общий» тариф на сайте вуза', 'Требуется IELTS Academic 7.0 (или эквивалент TOEFL iBT ~95/C1 Advanced), а не «скромные» 6.0, которые встречаются в сторонних агрегаторах — ориентироваться нужно именно на пороговый7.0', 'Все три ключевых параметра (тариф для иностранцев, финальный дедлайн, точный IELTS-минимум) разбросаны по разным официальным страницам HSG; на одной странице они одновременно не подтверждены, поэтому verified=false'],
  false, null
);

-- verified=false, потому что tuition, deadline и language подтверждены на РАЗНЫХ официальных страницах unisg.ch, а не все три на одной странице программы: тариф CHF 3,329/сем — unisg.ch/en/studying/studying-at-hsg/costs-of-an-hsg-degree/ (с оговоркой Cantonal Council об индексации ~7% с осени 2026); дедлайн 31 марта — unisg.ch/en/studying/admission/application-deadlines/; IELTS 6.0 — unisg.ch admission-master/accounting-and-corporate-finance/ и подтверждено Universityliving. GPA-минимум HSG официально не публикует, 3.0 — разумная оценка для не-EU абитуриентов. Длительность18 мес (3 семестра, 90 ECTS) подтверждена MIM Compass. Различие EU/non-EU по tuition в HSG отсутствует — Швейцария вне ЕС, ставка единая.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in Accounting and Corporate Finance (MACFin)', 'Business Analytics', 'English', 18, 10300,
  3, 31, 6, 3, 'https://www.unisg.ch/en/studium/programme/master/accounting-and-corporate-finance-macfin/',
  array[]::text[],
  'Магистратура Университета Санкт-Галлена (HSG) по бухгалтерскому учёту и корпоративным финансам: 3 семестра (90 ECTS), преподаётся полностью на английском или немецком, фокус на финансовый менеджмент, контроллинг и налоговое право.',
  array['Возможность полностью английского трека без обязательного GMAT', 'Сильный бренд HSG в DACH-регионе и плотная сеть выпускников в швейцарском финансовом секторе'],
  array['В HSG нет разделения тарифов EU/non-EU — все (включая швейцарцев) платят одинаково CHF 3,329/сем; указанная сумма в EUR — пересчёт по текущему курсу CHF→EUR и может колебаться', 'Дедлайн не30 апреля, а 31 марта (раньше, чем у MBF/SIM); IELTS 6.0 и GPA-минимум не указаны на странице программы — взяты со страницы admission/deadlines HSG и сторонних агрегаторов, точный GPA-порог не публикуется'],
  false, null
);

-- Подтверждено из официальных источников unisg.ch: стоимость для иностранных студентов CHF 3,329/семестр (факт-шит https://www.unisg.ch/en/studium/programme/master/mcs/factsheet/ и страница costs https://www.unisg.ch/en/studying/studying-at-hsg/costs-of-an-hsg-degree/), дедлайн подачи 30 апреля (https://www.unisg.ch/en/studying/admission/admission-master/computer-science/). IELTS не отобразился в сниппетах официальных страниц HSG — взята типичная для HSG оценка 6.5 как наилучшая оценка. verified=false, так как требование по языку не подтверждено на той же странице, что tuition и deadline.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in Computer Science (MCS)', 'Computer Science', 'English', 24, 14000,
  4, 30, 6.5, 3, 'https://www.unisg.ch/en/studium/programme/master/mcs/factsheet/',
  array[]::text[],
  'Двухлетняя магистратура по компьютерным наукам в Университете Санкт-Галлена (HSG), где CS преподаётся в контексте бизнеса и экономики. Для иностранных студентов установлена повышенная ставка CHF 3,329 за семестр (≈ CHF 13,316 за всю программу), что почти в 2,3 раза дороже, чем для граждан Швейцарии (CHF 1,429/семестр).',
  array['Сильная репутация HSG в бизнесе и менеджменте — редкое сочетание CS + бизнес-среда', 'Преподавание полностью на английском, интернациональный контингент', 'Степень Master of Science HSG (M.Sc. HSG), признаваемая в ЕС и Швейцарии'],
  array['Точный минимальный IELTS на страницах unisg.ch в выдаче не показан — указан типичный для HSG минимум 6.5 (требует отдельной проверки на admission-master/computer-science)', 'Для иностранных студентов тариф почти в 2,3 раза выше, чем для швейцарцев (явное разграничение EU vs non-EU в обратную сторону — non-EU платит больше)', 'По решению кантонального совета от 05.11.2025 возможно повышение тарифа для иностранцев до CHF 3,557.50/семестр', 'Высокая стоимость жизни в Швейцарском городе Санкт-Галлен дополнительно к tuition'],
  false, null
);

-- verified=false, потому что не все три параметра (tuition+deadline+language) подтверждены на одной и той же странице программы. Подтверждено на unil.ch/unil/en/home/menuinst/etudier/masters/management.html: дедлайн 30 апреля для общего enrolment и 28 февраля для кандидатов, которым нужна виза (то есть для большинства не-ЕС). Стоимость подтверждена на отдельной странице unil.ch о fees: CHF 580/семестр для всех + CHF 200 административный сбор для не-швейцарцев (источник: unil.ch/unil/en/home/menuinst/etudier/immatriculations-et-inscriptions/etudiants-unil/taxes.html и mimineurope.com). Годовая стоимость ≈ CHF 1,260 ≈ €1,300; за 2 года ≈ €2,650. Точный IELTS-минимум на странице MSc in Management из сниппетов не извлечён — взята типичная планка HEC Lausanne7.0 как оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37a9ea04-6e67-44cf-85d1-37d4030f0db5',
  'Master of Science (MSc) in Management', 'Business Analytics', 'English', 24, 1300,
  2, 28, 7, 3, 'https://www.unil.ch/unil/en/home/menuinst/etudier/masters/management.html',
  array['UNIL Master''s Excellence Scholarship (CHF 1,600/month + tuition fee exemption, deadline 1 November)'],
  'Двухлетняя магистратура MSc in Management в HEC Lausanne (факультет UNIL) на английском языке. Программа отличается одной из самых низких стоимостей обучения в Европе для не-ЕС студентов и сильной академической репутацией в области менеджмента.',
  array['Очень низкая стоимость обучения для иностранцев (~€1,300/год) — Швейцария и UNIL не делают надбавки для не-ЕС', 'Престиж HEC Lausanne и высокая международная аккредитация (EQUIS/AACSB)', 'Доступна стипендия UNIL Master''s Excellence: CHF 1,600/мес + освобождение от оплаты обучения'],
  array['Для не-ЕС студентов (нужна швейцарская виза) дедлайн жёсткий — 28 февраля, а не 30 апреля', 'Очень высокая стоимость жизни в Лозанне (~CHF 2,000/мес по данным FBM UNIL)', 'Требования к английскому высокие (IELTS предположительно 7.0, не подтверждено напрямую на странице программы)', 'Не опубликован минимальный GPA — отбор комплексный, без формального порога'],
  false, null
);

-- Подтверждено на указанной странице economie.html (актуально на 16.02.2026): длительность 4 семестра, язык — английский (уровень C1), крайний срок — 30 апреля. Однако размер платы за обучение на этой же странице не указан — данные о CHF 580/семестр взяты с отдельной официальной страницы unil.ch/.../taxes.html и из сторонних сводок (unipage.net, mastersportal), поэтому verified=false. Требование IELTS 6.5 подтверждено требованием C1 на странице HEC Admissions и базами yocket/ymgrad. UNIL не делает различий между резидентами, гражданами ЕС и не-ЕС — это единая ставка для всех.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37a9ea04-6e67-44cf-85d1-37d4030f0db5',
  'Master of Science (MSc) in Economics', 'Business Analytics', 'English', 24, 2400,
  4, 30, 6.5, 4, 'https://www.unil.ch/unil/en/home/menuinst/etudier/masters/economie.html',
  array['UNIL Master''s Grant (excellence scholarship, deadline ~1 November, covers CHF 1''600/month living allowance)'],
  'Двухгодичная англоязычная магистерская программа по экономике в UNIL (Лозанна). Обучение ведётся полностью на английском (требуется уровень C1). Важно: UNIL не различает ставки для граждан Швейцарии, ЕС/ЕЭЗ и остальных стран — семестровый взнос фиксированный (CHF 580).',
  array['Единая низкая стоимость для всех студентов (резидентов и нерезидентов): ~CHF 580/семестр, ~CHF 2''320 за всю программу — значительно дешевле ETH/EPFZ и большинства европейских non-EU ставок.', 'Полностью английский язык обучения, без требований к знанию французского.', 'Престижное расположение в Лозанне, рядом с HEC Lausanne и международными организациями.', 'Доступна стипендия UNIL Master''s Grant для иностранных студентов с отличными оценками.'],
  array['Точная стоимость обучения не указана непосредственно на странице программы (она находится на отдельной странице taxes.html), поэтому verified=false.', 'Высокий языковой порог: требуется C1 (IELTS 6.5+), что строже многих континентальных программ.', 'Крайний срок подачи — 30 апреля, что для не-ЕС студентов может быть рискованно с учётом долгого оформления швейцарской студенческой визы (рекомендуется подавать на стипендию к 1 ноября за год до поступления).', 'Дополнительное условие: минимум 4.00/6.00 по 12 ECTS экономических дисциплин в бакалавриате.'],
  false, null
);

-- Verified=false: дедлайн (30 апреля) и язык (English, C1) подтверждены на основной странице программы unil.ch/.../finance.html, но стоимость обучения (CHF 580/семестр) взята со страницы общих такс UNIL (unil.ch/.../taxes.html) и из сторонних источников (mimineurope.com, fed-group.ch) — то есть НЕ на той же странице, что требует критерий verified. IELTS 6.5 — из стороннего источника fed-group.ch, на официальной странице указан только уровень C1 без числового эквивалента. Важно: для MSc Finance в UNIL НЕТ различия между EU/EEA и non-EU студентами — все платят одинаково (CHF 580/семестр), что является исключением и подтверждено несколькими источниками.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37a9ea04-6e67-44cf-85d1-37d4030f0db5',
  'Master of Science (MSc) in Finance', 'Business Analytics', 'English', 24, 2470,
  4, 30, 6.5, 3, 'https://www.unil.ch/unil/en/home/menuinst/etudier/masters/finance.html',
  array['UNIL Master''s Excellence Scholarship (неподтверждено — упомянуто в сторонних источниках)'],
  'Магистратура MSc in Finance в UNIL (HEC Lausanne) — 4 семестра, обучение полностью на английском (уровень C1). Стоимость фиксированная для всех студентов независимо от гражданства: CHF 580/семестр (≈ EUR 620/семестр), всего около CHF 2320 (≈ EUR 2470) за всю программу.',
  array['Единая низкая стоимость для всех студентов (EU и non-EU платят одинаково) — редкое преимущество для Швейцарии', 'Программа на английском с требованием C1, подходит для иностранцев без знания французского', 'HEC Lausanne стабильно в топ-40 рейтинга FT Masters in Finance Pre-Experience'],
  array['Дедлайн 30 апреля на официальной странице, но для аппликантов, нуждающихся в швейцарской визе, реальное окно подачи раньше (≈ февраль) — проверяйте у Admissions Office', 'На странице программы не указан точный балл IELTS; C1 формально соответствует IELTS 7.0, третий источник даёт 6.5 — уточняйте при подаче', 'Минимальный GPA официально не опубликован на странице программы; значение указано как оценочное'],
  false, null
);

-- verified=false: дедлайн 31 марта (и ранний раунд 15 декабря) подтверждён в сниппете самой UNIL-страницы; tuition для не-ЕС (CHF 2,240/сем, итого ~CHF 8,960 ≈ €9,400) подтверждён со страниц EPFL и E4S, но не напрямую с UNIL URL. IELTS 6.5 — экспертная оценка по стандартам EPFL (официально на найденных страницах не указан). GPA 3.0 — типичное требование, явного подтверждения в выдаче нет. Все три обязательных поля (tuition/deadline/language) не подтверждены на ОДНОЙ странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '37a9ea04-6e67-44cf-85d1-37d4030f0db5',
  'Master of Science (MSc) in Sustainable Management & Technology', 'Business Analytics', 'English', 24, 9400,
  3, 31, 6.5, 3, 'https://www.unil.ch/unil/en/home/menuinst/etudier/masters/management-durable-et-technologie.html',
  array['UNIL Master''s Grants for foreign students (~CHF 1,600/месяц, дедлайн ~1 ноября)', 'E4S Excellence Scholarship (через E4S Center)'],
  'Совместная магистратура UNIL-HEC Lausanne, IMD и EPFL (E4S Center) на английском языке, 120 ECTS / 4 семестра. Готовит специалистов на стыке устойчивого управления, технологий и инноваций; выпускники получают степень MSc.',
  array['Тройной бренд: UNIL-HEC + IMD + EPFL — сильнейшая комбинация Швейцарии', 'Полностью на английском, специально ориентирована на иностранных студентов', 'Доступ к сети E4S и сильный акцент на практических кейсах и устойчивом развитии'],
  array['Для не-ЕС студентов学费 CHF 2,240/семестр против CHF 780 для швейцарцев/ЕС — почти в 3 раза дороже', 'Подача через платформу EPFL, фактический дедлайн (31 марта или 15 декабря) и итоговая стоимость подтверждены не с самой UNIL-страницы, а со страниц EPFL/E4S', 'Минимальный IELTS 6.5 — оценён по типичным требованиям EPFL/UNIL, на самой странице явно не указан'],
  false, null
);
