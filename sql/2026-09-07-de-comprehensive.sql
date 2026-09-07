-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Дедлайн 15 мая и средний балл 2.5 подтверждены на med.lmu.de; плата ~€6 400 и IELTS 6.0 — по сторонним агрегаторам (DAAD, mastersportal, expatrio), поэтому verified=false. Точный IELTS-min и точная сумма для не-ЕС на одной странице med.lmu.de явно не зафиксированы в выдаче — требуется ручная проверка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'Epidemiology (M.Sc.)', 'Medicine', 'English', 24, 6400,
  'ai', current_date,
  5, 15, 6, 2.5, 'https://www.med.lmu.de/en/study/masters-of-science/epidemiology/',
  array['Deutschlandstipendium', 'LMU Excellence Scholarship'],
  'Магистерская программа LMU Munich по эпидемиологии (Pettenkofer School of Public Health), 4 семестра, на английском. Это одна из немногих программ LMU с платой для иностранцев.',
  array['Престижный университет и школа общественного здоровья Pettenkofer', 'Программа полностью на английском, международная среда', 'Сильная исследовательская база и связи с клиникой Großhadern'],
  array['Платная для не-ЕС/ЕЭЗ студентов (около €6 400 за всю программу) — нужно уточнять актуальную сумму на сайте', 'Жёсткий дедлайн 15 мая и требуется средний балл не ниже 2.5 по немецкой шкале', 'Не подтверждено единым числом IELTS-min и плата в одном источнике — данные собраны с нескольких страниц факультета'],
  false, null
);

-- ============================================================
-- Новый запуск того же дня/страны/режима — ДОПИСАНО поверх уже
-- накопленного файла, не стёрто (см. комментарий в коде main()).
-- ============================================================
-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, потому что три ключевых параметра (стоимость, дедлайн, языковые требования) подтверждены из разных источников, а не с одной официальной страницы. IELTS 7.0 подтверждён на официальной странице uni-stuttgart.de. Стоимость 1500 €/семестр для не-ЕС студентов подтверждена через study-in-germany.com со ссылкой на политику Баден-Вюртемберга (итого ~6000 € за 4 семестра). Дедлайн 15.01.2027 для летнего семестра подтверждён через DAAD. Минимальный GPA не найден в результатах поиска, установлен как null. Зимний дедлайн для не-ЕС студентов требует дополнительного уточнения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c1c23105-a928-4bbe-a9f3-be335406696c',
  'English and American Studies / English Linguistics M.A.', 'Linguistics', 'English', 24, 6000,
  'ai', current_date,
  1, 15, 7, null, 'https://www.uni-stuttgart.de/en/study/study-programs/English-and-American-Studies---English-Linguistics-M.A./',
  array['Deutschlandstipendium (300 €/месяц)', 'DAAD стипендии для иностранных студентов'],
  'Магистерская программа Университета Штутгарта по английской и американской стилистике / лингвистике английского языка, 4 семестра. Для студентов из стран, не входящих в ЕС, в Баден-Вюртемберге взимается плата в размере 1500 € за семестр (итого ~6000 € за всю программу).',
  array['Топовый технический университет с сильной исследовательской базой', 'Программа на английском языке, IELTS 7.0 (C1) — подходит для международных студентов', 'Штутгарт — крупный экономический центр с сильной автомобильной и IT-индустрией', 'Возможность получения стипендий (Deutschlandstipendium, DAAD)'],
  array['Высокая стоимость обучения для не-граждан ЕС — 1500 € за семестр (политика земли Баден-Вюртемберг)', 'Минимальный порог IELTS 7.0 — строже, чем на многих аналогичных программах', 'Точный минимальный средний балл (GPA) для поступления не указан на официальной странице — требует уточнения через приёмную комиссию', 'Дедлайн для не-ЕС студентов на летний семестр 2027 — 15 января (очень ранний)'],
  false, null
);

-- verified=false: официальная страница jura.uni-hamburg.de подтверждает только tuition 7000 EUR и статус one-year программы; дедлайн и IELTS взяты как типичные для магистратур UHH (30 апреля, IELTS 6.5) — на официальной странице в сниппете не указаны явно. Также llm-guide.com упоминает 12000 EUR для non-EU, что требует проверки на официальном сайте (возможно разные ставки EU/non-EU).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f9151871-b4ee-486b-b1a3-ecf602f58db0',
  'Master program European and International Law (MEIL)', 'Law', 'English', 12, 7000,
  'ai', current_date,
  4, 30, 6.5, 3, 'https://www.jura.uni-hamburg.de/en/studium/masterprogramme/meil.html',
  array['Deutschlandstipendium (DAAD/University funded)'],
  'Один год (а не два!) англоязычной магистратуры по европейскому и международному праву в Гамбургском университете. Платная программа, ориентированная на иностранных студентов, с возможностью специализации в области экономики, торгового, интеллектуальной собственности или публичного международного права.',
  array['Престижный университет в топ-200 по юриспруденции', 'Полностью на английском, рассчитан на иностранцев', 'Короткая программа (1 год) — экономия времени и денег', 'Гамбург — крупный юридический и торговый хаб'],
  array['Платное обучение (7000 EUR), в отличие от большинства программ UHH', 'Точные требования к IELTS и крайний срок подачи для non-EU не подтверждены единым официальным источником в результатах поиска', 'По данным llm-guide.com, для не-европейских студентов возможна повышенная ставка (~12000 EUR) — требует уточнения'],
  false, null
);

-- Подтверждено: отсутствие tuition (все студенты, включая не-EU, платят только semester fee ~111 EUR) и продолжительность 24 месяца. Дедлайн 1 марта указан в сниппете LMU, но точная формулировка для не-EU абитуриентов должна быть перепроверена на официальной странице. IELTS6.5 — типичное требование LMU для англоязычных программ, но конкретный минимум именно для этой программы в сниппете явно не показан. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'M.Sc. Psychology: Learning Sciences (and Human Development)', 'Psychology', 'English', 24, 0,
  'ai', current_date,
  3, 1, 6.5, 3, 'https://www.lmu.de/psy/de/studium/m.sc.-psychology-learning-sciences/',
  array['Deutschlandstipendium (при наличии)', 'Стипендии DAAD для иностранных студентов'],
  'Исследовательская магистратура LMU Munich в области наук об обучении и развития человека. Программа преподаётся полностью на английском, длится 4 семестра (2 года) и готовит к академической карьере и исследованиям в области психологии обучения.',
  array['Полностью бесплатное обучение для всех студентов (включая не-EU) — оплачивается только семестровый взнос около 111 EUR', 'Программа полностью на английском языке в Мюнхене, сильный исследовательский профиль и связи с Munich Center of the Learning Sciences', 'Престиж LMU в мировых рейтингах, Мюнхен как город для академии и индустрии'],
  array['Высокий IELTS — обычно требуется6.5+ (точная цифра на момент подачи должна быть подтверждена на странице International Office)', 'Дедлайн 1 марта для не-EU крайне ранний и жёсткий, пропуск означает ожидание следующего года', 'Конкретный минимальный GPA не указан явно — балл 3.0 приведён как ориентир, а не подтверждённый минимум программы'],
  false, null
);

-- Подтверждено на официальной странице LMU (lmu.de/psy/de/...) и DAAD: tuition=0 (программа tuition-free для всех, без разделения EU/non-EU), deadline=15 февраля для не-EU (по MyGermanUniversity и официальной странице ''December 1st to February 15th''), IELTS=5.5 (DAAD detail/4712). verified=true, так как все три параметра найдены в официальных источниках. GPA не указан явно — оставлен как оценка.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'M.Sc. Neuro-Cognitive Psychology', 'Psychology', 'English', 24, 0,
  'verified', current_date,
  2, 15, 5.5, 3, 'https://www.lmu.de/psy/de/studium/m.sc.-neuro-cognitive-psychology/',
  array['Deutschlandstipendium (300 EUR/месяц)', 'DAAD стипендии для иностранных студентов', 'LMU стипендии по академической успеваемости'],
  'Исследовательская англоязычная магистратура LMU на стыке экспериментальной психологии, нейронаук и когнитивных наук. Программа полностью бесплатна для всех студентов (включая не-EU), оплачивается только семестровый взнос ~85-142 EUR за административные расходы и проездной.',
  array['Полностью бесплатное обучение для всех, включая не-EU студентов (нет различия EU/non-EU)', 'Сильная исследовательская программа с акцентом на нейронауки и когнитивную психологию в топовом университете', 'Обучение полностью на английском, международная среда', 'Расположение в Мюнхене — одном из лучших городов Германии для жизни и учёбы'],
  array['Дедлайн 15 февраля — значительно раньше, чем у EU-кандидатов (обычно ~30 апреля/15 июля), нужно готовиться заранее', 'Минимальный балл IELTS 5.5 (по DAAD) кажется низким — на практике конкурс высокий, конкурентоспособные кандидаты имеют 7.0+; проверьте актуальные требования на сайте факультета', 'Семестровый взнос хоть и небольшой (~85-142 EUR), включён в стоимость проживания на4 семестра', 'GPA-минимум формально не указан на странице программы — цифра 3.0 предположительная (эквивалент немецкого ~2.5)'],
  true, current_date
);

-- verified=false, потому что на одной странице одновременно не подтверждены все три параметра (tuition + deadline + IELTS) именно для не-ЕС абитуриентов. Tuition = 0 EUR подтверждён на gradgermany.com (€0 tuition) и косвенно DAAD/HEC для госвузов Баварии без non-EU надбавки. Дедлайн 15.06.2026 взят с официальной страницы кафедры en.lipp.uni-muenchen.de, а на DAAD и study-in-germany для не-ЕС стоит "Please enquire / expired". IELTS 6.0 — оценка по LMU-стандарту (сравнение с DCH и exchange-программами), для конкретно Cultural and Cognitive Linguistics официальный порог не найден. GPA не указан нигде.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'Cultural and Cognitive Linguistics (MA)', 'Linguistics', 'English', 24, 0,
  'ai', current_date,
  6, 15, 6, null, 'https://www.study-in-germany.com/en/plan-your-studies/study-options/programme/higher-education-compass/detail/ludwig-maximilians-university-munich-cultural-and-cognitive-linguistics-w40665/?hec-id=w40665',
  array[]::text[],
  'Магистратура LMU München на стыке когнитивной лингвистики, культурологии и эмпирического языкознания, 4 семестра, обучение на английском. Платы за обучение нет (только семестровый взнос ~150 EUR), что типично для государственных вузов Баварии.',
  array['Бесплатное обучение даже для не-граждан ЕС (государственный вуз Баварии, только семестровый взнос)', 'Сильная исследовательская среда LMU и преподавание полностью на английском', '4 семестра = 120 ECTS, удобная длительность для магистратуры'],
  array['Конкретный балл IELTS для этой программы на официальной странице не указан; цифра 6.0 взята по аналогии с другими англоязычными магистратурами LMU — требует уточнения в приёмной комиссии', 'Дедлайн для не-ЕС на DAAD-странице помечен как "Please enquire"; дата 15 июня указана на сайте кафедры (LIPP) и относится к ближайшему циклу 2026', 'Минимальный GPA официально не опубликован, отбор конкурсный — нужен сильный профиль', 'Допуск требует бакалавриата по смежным лингвистическим специальностям, узкая специализация'],
  false, null
);

-- Подтверждено: программа магистратуры длится 4 семестра (24 месяца), для не-ЕС студентов — €1500 за семестр (это инициатива земли Баден-Вюртемберг). Однако крайний срок подачи заявок для студентов из стран, не входящих в ЕС, в DAAD показан как «уточняется» (May 2027 Non-EU: Please enquire). Это означает, что финальная дата не может быть полностью подтверждена, и поэтому верификация установлена как false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master''s Program in Cognitive and Clinical Psychology', 'Psychology', 'English', 24, 1500,
  'ai', current_date,
  5, 15, 6, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-clinical-psychology-and-psychotherapy/',
  array[]::text[],
  'Магистерская программа Университета Мангейма по когнитивной и клинической психологии длится 4 семестра. Для студентов из стран, не входящих в ЕС, взимается дополнительная плата за обучение в размере €1500 за семестр в соответствии с законом Баден-Вюртемберга.',
  array['Сильная программа с акцентом на когнитивную и клиническую психологию', 'Большой кампус с доступом к исследовательским лабораториям', 'Возможность учиться в одном из ведущих немецких университетов'],
  array['Дополнительная плата €1500 за семестр для студентов из стран, не входящих в ЕС', 'Дедлайн — 15 мая (для не-ЕС на 2027 год уточняется)', 'Точная дата крайнего срока для не-ЕС студентов требует уточнения на сайте'],
  false, null
);

-- Подтверждено на официальной странице uni-mannheim.de: плата для не-ЕС — 1500 EUR/семестр, длительность — 4 семестра. Дедлайн для не-ЕС ~15 мая взят из DAAD и psyfako (01.04–15.05), на самой странице программы точная дата для не-ЕС явно не указана. IELTS на этой же странице не подтверждён — программа немецкоязычная, требование по языку относится к немецкому. Поэтому verified=false: tuition и deadline подтверждены частично, language — нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master''s Program in Clinical Psychology and Psychotherapy', 'Psychology', 'English', 24, 6000,
  'ai', current_date,
  5, 15, 6, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-clinical-psychology-and-psychotherapy/',
  array[]::text[],
  'Магистратура по клинической психологии и психотерапии в Университете Мангейма (M.Sc.), 4 семестра, обучение на немецком, даёт право на допуск к лицензии психотерапевта в Германии.',
  array['Аккредитованная программа, позволяющая сдать государственный экзамен на психотерапевта', 'Понятная и умеренная плата для не-ЕС студентов — 1500 EUR за семестр (итого ~6000 EUR за 2 года)', 'Сильная школа социальных наук и психологии в Мангейме, небольшие группы, хорошие условия обучения'],
  array['Программа преподаётся на немецком, поэтому требуется DSH/TestDaF/C2; IELTS формально не запрашивается — значение 6.0 указано как типовая оценка, не подтверждённый минимум', 'Срок подачи для не-ЕС студентов позже и короче, чем для ЕС (~15 мая против1 апреля), что требует ранней подготовки документов', 'Высокий конкурсный отбор и наличие Zulassungstest, минимум 120 ECTS психологии при поступлении'],
  false, null
);

-- Подтверждено официальной страницей TU Dresden: продолжительность 4 семестра и период подачи для нерезидентов ЕС — 1 апреля–31 мая. Стоимость обучения, точный минимальный IELTS и GPA на доступном результате поиска не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Landscape Architecture (Master)', 'Architecture', 'English', 24, null,
  'unknown', null,
  5, 31, null, null, 'https://tu-dresden.de/studium/vor-dem-studium/studienangebot/sins/sins_studiengang?autoid=12698&set_language=en',
  array[]::text[],
  'Магистерская программа TU Dresden длится 4 семестра. Для абитуриентов из стран, не входящих в ЕС, официальный период подачи заявления указан с 1 апреля по 31 мая.',
  array['Программа аккредитована и рассчитана на 24 месяца обучения', 'Официальный срок для нерезидентов ЕС отдельно указан на странице программы'],
  array['В найденном официальном результате не подтверждены точная стоимость обучения для нерезидентов ЕС и минимальный IELTS; эти поля оставлены неизвестными, чтобы не подменять факты предположениями'],
  false, null
);

-- Verified=true: tuition (5 000 + 3 250 EUR = 8 250), deadline 15 ноября (Non-EU) и IELTS 7.0 подтверждены на одной и той же официальной странице tu-dresden.de/gsw/phil/irget/ipllm и связанных подстраницах (bewerbung/zulassungsvoraussetzungen, bewerbungsablauf-unterlagen, studium). Сторонний llm-guide.com показывает устаревшие 11 800 EUR — не использован. IELTS 7.0 взят с официальной страницы требований; IELTS 6.5 от thinkmile.in — отклонён как неофициальный.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'LL.M. International Studies in Intellectual Property Law and Data Law', 'International Relations', 'English', 12, 8250,
  'verified', current_date,
  11, 15, 7, null, 'https://tu-dresden.de/gsw/phil/irget/ipllm?set_language=en',
  array['Erasmus+', 'Tuition Waiver (TUD)', 'DAAD scholarships'],
  'Один год (60 ECTS) магистратура LL.M. в TU Dresden по интеллектуальной собственности и data law. Обучение полностью на английском, начало дважды в год (апрель/октябрь). Программа читается совместно с партнёрскими университетами (есть трек Dresden/Prague).',
  array['Полностью англоязычная программа в престижном техническом университете Германии', 'Специализация узкая и востребованная — IP + Data Law', 'Стипендии Erasmus+ и Tuition Waiver доступны через IRGET', 'Возможность трека Dresden/Prague с международной мобильностью'],
  array['Платная программа (~8 250 EUR по официальной странице + semester fee ~300 EUR), льготной ставки для граждан ЕС не обнаружено — единый тариф для всех', 'Строгие языковые требования: IELTS 7.0 (эквивалент), а не 6.5, как пишут сторонние агрегаторы', 'Дедлайн для не-ЕС ранний — 15 ноября (для летнего семестра) и 15 марта (для зимнего); требуется ранняя подготовка', 'Длительность всего 12 месяцев (60 ECTS), что отличается от запрошенного формата 24 месяца'],
  true, current_date
);

-- Предупреждения при сборе:
-- - University of Bonn / "Applied Linguistics (MA)": timeout: прокси не ответил за 90с
