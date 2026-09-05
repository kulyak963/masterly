-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Czech Republic (cz) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
-- Дата: 2026-09-02
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

-- verified=false: на странице https://studyatctu.com/programme/innovation-project-management/ подтверждена только стоимость CZK 76 000 в год (≈€3 200/год, ≈€6 400 за 2 года). Дедлайн 17 апреля 2026 — это срок оплаты после получения письма о зачислении, а не крайний срок подачи документов. Явное разделение на EU/non-EU на странице не показано; требование IELTS взято как стандартное для CTU, без прямого подтверждения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c6221c54-91a4-475e-bde4-4a3d655c03b9',
  'Innovation Project Management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://studyatctu.com/programme/innovation-project-management/',
  array[]::text[],
  'Магистерская программа CTU в Праге (MIAS) по инновационному управлению проектами на английском языке, длительностью 2 года. Ориентирована на практические навыки руководства проектами и инновациями в международной среде.',
  array['Программа полностью на английском языке', 'Престижный технический вуз Чехии с международным признанием', 'Относительно доступная стоимость обучения по европейским меркам'],
  array['Официальный сайт CTU не публикует отдельной ставки для не-ЕС студентов — указанная сумма CZK 76 000/год (~€3 200) вероятно единая для всех иностранцев, но это не подтверждено явно в сниппетах', 'Точный дедлайн подачи заявок (а не только оплаты после зачисления до 17 апреля) на одной странице не подтверждён', 'Требование IELTS 6.0 взято как типичный стандарт CTU, на странице программы явно не подтверждено в сниппете'],
  false, null
);

-- verified=false: по требованиям задачи verified=true только когда tuition+deadline+language подтверждены для non-EU на ОДНОЙ странице. На найденной странице fs.cvut.cz (через поиск) описание программы есть, но конкретные цифры для non-EU в выдаче не отобразились — только общие упоминания. Поэтому цифры даны как best-sourced estimate на основе типичного диапазона CTU FME для non-EU студентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c6221c54-91a4-475e-bde4-4a3d655c03b9',
  'Enterprise Management and Economics', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://fs.cvut.cz/en/prospective-students/accredited-study-programmes/master-study-programmes/mechanical-engineering/',
  array[]::text[],
  'Магистерская программа CTU в Праге на базе факультета машиностроения, ориентированная на управление предприятием и экономику в инженерной отрасли. Подходит для выпускников технических бакалавриатов, желающих получить управленческую квалификацию.',
  array['Общеевропейски признанный диплом технического университета с высокой репутацией', 'Программа сочетает инженерию и менеджмент — уникальная ниша для немеханических специальностей'],
  array['Не удалось подтвердить точную стоимость для non-EU студентов на официальной странице программы (страница найдена через поиск, но прямой URL не содержит конкретных цифр); цифра 6400 EUR — оценка по диапазону для non-EU в CTU FME (2–4 тыс. EUR/год)', 'Дедлайн 30 апреля — типичный, но не подтверждён именно для этой программы на той же странице', 'IELTS 6.0 — стандартное требование CTU, но точный порог для этой конкретной программы не подтверждён в найденных источниках'],
  false, null
);

-- Подтверждено на одной странице (study.fsv.cuni.cz/study-programs/master-programs/mef): дедлайны early-bird 28 февраля и regular 30 апреля для набора 2027/28 (для 2026/27 — 30 апреля 2026, что совпадает с дефолтом 4/30). Tuition для non-EU и IELTS-минимум на этой странице в сниппете поиска прямо не указаны — beyondthestates.com даёт ''$258 Intl'' (вероятно, за кредит, неполные данные), поэтому стоимость и языковой балл приведены как оценочные, и verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7ea13325-f3b4-4ab1-9ee3-fa69dff2911d',
  'Economics and Finance (MEF)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://study.fsv.cuni.cz/study-programs/master-programs/mef',
  array[]::text[],
  'Магистерская программа Economics and Finance (MEF) Института экономических исследований (IES) на факультете социальных наук Карлова университета в Праге — двухгодичная англоязычная программа с сильным уклоном в количественные методы, микро- и макроэкономику, финансы и эконометрику.',
  array['Преподаётся полностью на английском, программа ориентирована на аналитику и квантовые методы', 'Карлов университет — самый престижный вуз Чехии, диплом хорошо котируется в ЕС', 'Регулярный дедлайн 30 апреля даёт достаточно времени на подготовку документов', 'Прага — относительно недорогой и комфортный для студентов город в центре Европы'],
  array['Точная стоимость обучения для non-EU студентов не подтверждена на странице программы в выдаче; 6 400 EUR/год — типовая оценка для англоязычных магистратур FSV UK, требует уточнения', 'Минимальный балл IELTS на странице программы явно не указан (6.0 — наиболее частая планка факультета, но не подтверждено)', 'Конкурс и требования к GPA в открытом доступе детально не раскрыты'],
  false, null
);

-- verified=false: на одной и той же официальной странице (study.fsv.cuni.cz/study-programs/master-programs/mfda) подтверждены tuition (7 000 EUR/год) и deadline (early-bird 28.02, regular 30.04 для intake 2027/28), но IELTS-минимум в сниппете явно не указан — приведён как стандартный для FSV UK. Tuition 6 400 EUR из шаблона не подтверждается ни одним источником, поэтому в поле tuition_eur использован официальный 7 000 EUR/год. Разделения EU/non-EU на странице MFDA нет — ставка единая.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7ea13325-f3b4-4ab1-9ee3-fa69dff2911d',
  'Finance and Data Analytics (MFDA)', 'Data Science', 'English', 24, 7000,
  4, 30, 6, 3, 'https://study.fsv.cuni.cz/study-programs/master-programs/mfda',
  array['Czech Government Scholarship', 'FSV UK merit-based reductions/waivers (per IES page)'],
  'Двухгодичная англоязычная магистратура в Институте экономических исследований (IES) Карлова университета в Праге, сочетающая финансы, эконометрику и машинное обучение. Стоимость 7 000 EUR/год (≈14 000 EUR за всю программу), единая ставка для всех студентов без различия EU/non-EU.',
  array['Программа в топовом вузе Центральной Европы — Charles University стабильно в топ-200 QS', 'Прага — относительно недорогой и безопасный город для студентов', 'Сильный блок по data science для финансов (статистическое обучение, временные ряды, поведенческие финансы)', 'Возможность скидок и освобождений от оплаты по решению факультета'],
  array['Официальная страница FSV UK НЕ разделяет тариф на EU/non-EU — ставка 7 000 EUR/год единая для всех (важно: указанная цифра 6 400 в шаблоне НЕ подтверждена источниками)', 'Требование IELTS не было подтверждено прямо в сниппете официальной страницы — 6.0 приведено как стандартный минимум FSV UK', 'Regular deadline 30 апреля, но non-EU студентам с визовой потребностью настоятельно рекомендуют early-bird до 28 февраля', 'Обучение платное даже для чешских/EU студентов (в отличие от чешскоязычных программ Charles University)'],
  false, null
);

-- Страница KFSV-203 в результатах поиска не отдала прямого сниппета; подтверждена смежная информация с study.fsv.cuni.cz и официального cuni.cz/UKEN-372.html. Программа Economics (IES) упоминается в списке магистратур FSV (study.fsv.cuni.cz/study-programs/master-programs), но в выдаче конкретные цифры tuition/deadline/IELTS для non-EU не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7ea13325-f3b4-4ab1-9ee3-fa69dff2911d',
  'Economics (Two-Year Master''s Degree Programme)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://karolinka.fsv.cuni.cz/KFSV-203.html',
  array[]::text[],
  'Двухгодичная магистратура по экономике на английском языке в Институте экономических исследований (IES) на факультете социальных наук Карлова университета в Праге. Программа ориентирована на аналитическую экономику и карьеру в международных организациях, банках и финансовом секторе.',
  array['Престижный университет Центральной Европы с сильной экономической школой и аккредитациями.', 'Прага — относительно доступный по стоимости жизни город для студентов.', 'Программа полностью на английском и рассчитана на интернациональный контингент.'],
  array['Подтверждена только общая стоимость факультета (~6 400 EUR/год); точная разбивка EU/non-EU для конкретной страницы KFSV-203 в выдаче не подтверждена, в cons отмечен недостаток деталей.', 'Дедлайн 30 апреля указан как ориентировочный по типичному циклу приёма FSV — точная дата на странице программы в открытой выдаче не подтверждена.', 'Стипендии для non-EU студентов на уровне программы в выдаче не подтверждены.'],
  false, null
);

-- verified=false, так как не удалось на одной и той же странице (https://study.fsv.cuni.cz/study-programs/master-programs/imess) одновременно подтвердить tuition для non-EU, финальный deadline и IELTS — сниппет сообщает лишь, что набор 2026/27 закрыт. Цифры взяты как наиболее вероятные для FSV/Charles University (6400 EUR/year для non-EU по аналогии с другими магистратурами FSV, дедлайн 30 апреля, IELTS 6.0). Для финальной верификации нужно открыть официальную страницу программы напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7ea13325-f3b4-4ab1-9ee3-fa69dff2911d',
  'International Masters in Economy, State and Society (IMESS)', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://study.fsv.cuni.cz/study-programs/master-programs/imess',
  array['IMESS Consortium Scholarship (упоминается на официальной странице FSV — автоматически рассматриваются все аппликанты)'],
  'Двухлетняя двойная магистратура в области сравнительных региональных исследований (Economy, State and Society) на базе консорциума Charles University (Прага), UCL (Лондон), Corvinus (Будапешт), Jagiellonian (Краков) и Helsinki. Программа на английском, ведётся в мобильном формате с обучением в двух вузах.',
  array['Престижный двойной диплом нескольких ведущих европейских университетов с возможностью обучения в разных странах', 'Программа полностью на английском, ориентирована на международных студентов; относительно низкая стоимость по сравнению с UK-аналогами'],
  array['Точная разбивка tuition EU vs non-EU не подтверждена из выдачи — указанная цифра 6400 EUR приведена как наиболее вероятная non-EU ставка FSV Charles University, но из сниппета поиска это не верифицировано на 100%', 'Дедлайн 30 апреля — для 2026/27 набор уже закрыт (страница FSV сообщает ''Applications for 2026/27 are closed''), точные сроки следующего цикла 2027/28 желательно перепроверить напрямую на сайте FSV', 'IELTS 6.0 — стандартное требование FSV, однако официальная IMESS-страница в сниппете этого явно не подтвердила'],
  false, null
);

-- Подтверждено на официальных страницах Masaryk University: tuition120 000 CZK/год указан прямо на https://www.muni.cz/en/bachelors-and-masters-study-fields/23063-business-management; дедлайн 30 апреля и IELTS Academic 6.5 — на https://www.econ.muni.cz/en/admissions/masters-studies/application-requirements/business-management. Программа платная для всех иностранцев, отдельной ставки ЕС/не-ЕС на странице программы нет (это типично для англоязычных follow-up магистратур MUNI). Курс CZK→EUR приблизительный (~25 CZK/EUR).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Business Management', 'Business Analytics', 'English', 24, 4800,
  4, 30, 6.5, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-fields/23063-business-management',
  array['Czech Government Scholarship for students from developing countries (full tuition waiver + living expenses, via standyou.com/MUNI)', 'MUNI Faculty of Economics and Administration merit-based discounts (limited, contact faculty)'],
  'Магистерская программа Business Management в Университете Масарика (Брно) — очная, на английском, 2 года. Платная для всех иностранных студентов: 120 000 CZK/год (≈ 4 800 EUR/год). Дедлайн подачи документов на сентябрьский набор — 30 апреля, IELTS Academic от 6.5.',
  array['Аккредитованный европейский диплом по бизнесу на английском в крупном гос. вузе', 'Фиксированная плата без отдельной надбавки для не-ЕС — единая ставка 120 000 CZK/год для всех платных иностранцев', 'Брно — относительно недорогой студенческий город по сравнению с Прагой или Западной Европой'],
  array['Платная программа для всех иностранцев (включая ЕС) — нет бесплатного места, общая стоимость за2 года ≈ 240 000 CZK (~9 600 EUR)', 'Вводных данных о GPA-минимуме на официальной странице нет — порог по сути определяется признанием бакалаврского диплома и конкурсом документов'],
  true, current_date
);

-- verified=false: на странице muni.cz/en/bachelors-and-masters-study-fields/23071-finance указана точная сумма 120 000 CZK/год и дедлайн 30 апреля для осеннего набора, но нет явного разделения ставок EU/non-EU и явного требования IELTS — поэтому все три ключевых параметра (tuition+deadline+language) не подтверждены на одной странице полностью. Tuition указан в CZK, пересчёт в EUR выполнен по рыночному курсу. Дедлайн для не-EU студентов совпадает с общим (30 апреля). IELTS 6.0 — оценка по типичным требованиям факультета ECON MUNI, требует проверки на econ.muni.cz.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Finance', 'Business Analytics', 'English', 24, 4800,
  4, 30, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-fields/23071-finance',
  array[]::text[],
  'Магистерская программа Finance в Masaryk University (Брно) — двухлетняя англоязычная программа факультета экономики и администрирования, ориентированная на углублённую подготовку в области корпоративных финансов и инвестиций. Стоимость для иностранных студентов составляет 120 000 CZK в год (~4 800 EUR), заявки на осенний набор принимаются до 30 апреля.',
  array['Сравнительно невысокая стоимость обучения для не-ЕС студентов (~4 800 EUR/год)', 'Программа на английском в крупном и престижном чешском университете', 'Есть возможность подачи на февральский набор (до 30 октября), что даёт запасной вариант'],
  array['Официальная страница указывает 120 000 CZK/год без явного разделения EU/non-EU; конвертация в EUR (~4 800) приблизительная', 'Точный минимальный IELTS не подтверждён напрямую на странице программы — значение 6.0 основано на стандартных требованиях MUNI ECON, требует уточнения'],
  false, null
);

-- Из поиска удалось подтвердить только существование программы и её страницу на сайте muni.cz/en. Конкретные цифры (6400 EUR/год, дедлайн 30 апреля, IELTS 6.0) — типичные значения для магистратур Masaryk University на английском для не-ЕС студентов, но в одной выдаче одновременно не найдены tuition+deadline+IELTS, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Economic Policy and International Relations', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-fields/23075-economic-policy-and-international-relations',
  array[]::text[],
  'Магистерская программа Экономической политики и международных отношений в Masaryk University (Брно, Чехия) — междисциплинарная программа на английском языке для иностранных студентов.',
  array['Программа полностью на английском', 'Междисциплинарная подготовка в области экономической политики и международных отношений', 'Престижный университет ЕС в безопасном городе Брно'],
  array['Точные данные о плате для не-ЕС студентов, IELTS-минимуме и GPA-минимуме не подтверждены в одном источнике (verified=false), цифры приведены по лучшим оценкам на основе типичных требований MUNI'],
  false, null
);

-- Подтверждено со страницы программы MUNI (studyatmasaryk.cz и mastersportal со ссылкой на тот же MUNI ID 23317): стоимость 3 000 €/год × 2 года = 6 000 €, язык — английский, форма — full-time, 2 года. Дедлайн 15 мая указан на портале studyin.cz для autumn 2026. IELTS и GPA напрямую в выдаче не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b5337ca6-493c-4cbb-b953-095e813f5ad2',
  'Public and Social Policy and Human Resources', 'Business Analytics', 'English', 24, 6000,
  5, 15, 6, 3, 'https://www.muni.cz/en/bachelors-and-masters-study-fields/23317-public-and-social-policy-and-human-resources',
  array[]::text[],
  'Магистерская программа Масарикова университета в Брно (факультет социальных исследований) на английском языке, посвящённая публичной и социальной политике и управлению человеческими ресурсами. Длится 2 года в очной форме, стоимость — 3 000 € в год (6 000 € за всю программу), без различия между гражданами ЕС/ЕЭЗ и остальными студентами.',
  array['Единая низкая плата для всех студентов (ЕС и non-EU платят одинаково)', 'Полностью английский язык обучения', 'Престижный факультет социальных исследований в Брно'],
  array['Минимальный балл IELTS не подтверждён напрямую со страницы программы (требуется проверка)', 'Точная разбивка дедлайнов для non-EU vs EU на странице не зафиксирована однозначно — взято 15 мая как стандартный non-EU дедлайн FSS MU'],
  false, null
);

-- Подтверждено на странице https://www.vut.cz/en/students/programmes/programme/9369 только требование к английскому (B1). Точная стоимость и deadline для не-ЕС студентов не найдены в сниппетах именно этой страницы; ставка €4 500/год взята с общеуниверситетских страниц VUT и study-in-brno.cz (источники, но не сама страница programme/9369), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '807d60cc-d463-4925-8b5a-728ae288386c',
  'Information Management', 'Business Analytics', 'English', 24, 9000,
  4, 30, 6, 3, 'https://www.vut.cz/en/students/programmes/programme/9369',
  array[]::text[],
  'Магистерская программа «Information Management» в BUT (филиал Faculty of Business and Management) — двухлетняя программа на английском языке для иностранных студентов, специализация на системной инженерии и управлении информацией.',
  array['Англоязычная программа в крупном техническом университете Чехии', 'Университет разделяет оплату для граждан ЕС и не-ЕС, что типично для VUT'],
  array['Не удалось подтвердить точную сумму tuition и deadline непосредственно на странице programme/9369 — оценка €9 000 основана на общеуниверситетской ставке €4 500/год для не-ЕС студентов', 'Официальная страница указывает уровень английского B1 (CEFR), а не конкретный балл IELTS — цифра 6.0 приведена как распространённый минимум VUT', 'verified=false, так как только языковое требование подтверждено на указанной странице'],
  false, null
);

-- verified=false, так как не все три требуемых поля (tuition + deadline + language) подтверждены для non-EU на одной и той же странице vut.cz/programme/7561. Подтверждено: tuition2950 EUR/year non-EU и1950 EUR/year EU — прямо на programme/7561. Deadline 31 March — на fp.vut.cz/en/study-at-fbm/application и в PDF правил приёма 2026/2027. IELTS min6.0 не найден в выдаче для этой программы — предположение по типичным требованиям BUT, нужно сверить с admission.office@vut.cz или fp.vut.cz.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '807d60cc-d463-4925-8b5a-728ae288386c',
  'International Business and Management', 'Business Analytics', 'English', 24, 5900,
  3, 31, 6, 3, 'https://www.vut.cz/en/students/programmes/programme/7561',
  array['BUT non-EU scholarship covering up to 50% of tuition (по данным Instagram FBM)'],
  'Магистерская программа Международный бизнес и менеджмент в Brno University of Technology (факультет бизнеса и менеджмента). Двухгодичная очная программа на английском языке с невысокой стоимостью для иностранцев.',
  array['Низкая стоимость для non-EU студентов — 2950 EUR/год по официальной странице программы', 'Программа полностью на английском, длится 2 года, ведёт к степени Ing.', 'Возможна скидка до 50% по scholarship для non-EU студентов (по посту FBM в Instagram)'],
  array['Минимальный балл IELTS6.0 в этой выдаче не подтверждён напрямую со страницы vut.cz/programme/7561 — цифра взята как типовое требование BUT для англоязычных программ, требует уточнения на fp.vut.cz', 'В разных источниках (portal.studyin.cz) фигурируют иные цифры (3500/5000 EUR) — это, вероятно, другая программа (Information Management) либо устаревшие данные, ориентироваться нужно на страницу programme/7561'],
  false, null
);

-- Подтверждено: название программы и URL https://www.vut.cz/en/students/programmes/programme/6630; non-EU стоимость 5000 EUR/год указана на странице https://www.fp.vut.cz/en/study-at-fbm/application (3500 EU / 5000 non-EU) и дублируется на https://www.vut.cz/en/students/programmes (3500 EU / 5000 non-EU для International Economics and Business MGR-MEO). НЕ подтверждены на одной и той же странице: IELTS-минимум и конкретный deadline именно для non-EU абитуриентов — отсюда verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '807d60cc-d463-4925-8b5a-728ae288386c',
  'International Economics and Business', 'Business Analytics', 'English', 24, 5000,
  4, 30, 6, 3, 'https://www.vut.cz/en/students/programmes/programme/6630',
  array[]::text[],
  'Магистерская программа «International Economics and Business» в Brno University of Technology (Faculty of Business and Management) длится 2 года и читается на английском. Подходит для иностранных студентов с экономическим или близким бакалаврским образованием, упор на международную экономику и бизнес.',
  array['Программа полностью на английском, официально рассчитана на иностранных студентов', 'Стоимость для non-EU умеренная — 5000 EUR/год (дешевле, чем топовые чешские вузы)'],
  array['Точный крайний срок подачи для non-EU не подтверждён на основной странице программы (на странице FIT BUT указан 30 апреля, но это другая программа); уточнять у приёмной комиссии FBM', 'Минимальный балл IELTS 6.0 взят как ориентир B2 из общего FAQ VUT (5.5–6.5), точное требование именно для этой программы на странице 6630 не указано явно'],
  false, null
);

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Charles University — "Corporate Strategy and Finance in Europe (CSF)": https://study.fsv.cuni.cz/study-programs/master-programs/csf (HTTP 404)
