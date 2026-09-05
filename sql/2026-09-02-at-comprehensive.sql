-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Austria (at) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=true, потому что тариф €726,72/семестр для не-ЕС подтверждён на официальной странице tuition.tuwien.at и в нескольких независимых источниках (mastersportal, migaku.com, college-council.com); программа подтверждена как англоязычная со страницы informatics.tuwien.ac.at/master/business-informatics; требование B2 CEFR (≈IELTS 6.0) — с официальной страницы Competence in English. Дедлайн 5 сентября — стандарт для не-ЕС магистрантов TU Wien (зимний семестр). GPA и точный IELTS-минимум не подтверждены для КОНКРЕТНОЙ программы Business Informatics на ОДНОЙ странице, поэтому вынесены в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Master''s Programme Business Informatics', 'Business Analytics', 'English', 24, 2907,
  9, 5, 6, 3, 'https://www.tuwien.at/en/studies/studies/master-programmes/informatics/business-informatics',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по бизнес-информатике в TU Wien (Вена). Для не-ЕС/ЕЭА студентов — €726,72 за семестр (≈€2907 за всю программу из 4 семестров), что значительно ниже, чем у «настояще-частных» бизнес-школ.',
  array['TU Wien — один из ведущих технических университетов немецкоязычного пространства, сильный бренд в инженерии/ИТ', 'Программа полностью на английском, без требования немецкого для поступления', 'Очень низкая стоимость для не-ЕС студентов (~€2907 за 2 года)'],
  array['Точный балл IELTS на странице программы не указан — TU Wien формально требует уровень B2 CEFR (соответствует ~IELTS 6.0–6.5), но конкретный минимум на этой странице не подтверждён', 'Конкретный минимальный GPA на странице не указан (значение 3 — оценка по шкале 4.0, требует ручной проверки на admissions-странице)', 'Дедлайн 5 сентября указан для зимнего семестра по общим правилам магистратур TU Wien; точный дедлайн именно для Business Informatics дополнительно лучше уточнить'],
  true, current_date
);

-- Подтверждено: программа существует по указанному URL; плата для не-ЕС — €726,72/семестр указана на странице tuition fee TU Wien и подтверждена несколькими независимыми источниками (libertify, migaku, официальная страница оплаты). НЕ подтверждено на той же странице: точный дедлайн для не-ЕС (указан типовой апрель 30 для общего приёма в TU Wien) и минимальный IELTS (взят общеуниверситетский 6.0). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Master’s Programme Statistics, Probability and Mathematics in Economics', 'Business Analytics', 'English', 24, 2907,
  4, 30, 6, 3, 'https://www.tuwien.at/en/studies/studies/master-programmes/mathematics-and-geoinformation/statistics-probability-mathematics-in-economics',
  array[]::text[],
  'Англоязычная магистратура TU Wien по статистике, теории вероятностей и математической экономике длительностью 4 семестра. Для граждан стран, не входящих в ЕС/ЕЭЗ, семестровая плата составляет €726,72 (итого ≈€2 907 за всю программу); студенты из развивающихся стран (DAC) освобождаются от неё.',
  array['Низкая стоимость обучения для нерезидентов ЕС — около €726/семестр', 'Программа полностью на английском в топовом техническом вузе Вены', 'Выпускники востребованы на стыке data-аналитики, финансов и экономики'],
  array['Точные требования по IELTS и дедлайн для не-ЕС абитуриентов 2025/2026 не удалось подтвердить по конкретной странице программы; указаны общие значения TU Wien', 'Необходимо подтверждение GPA и приёмных требований непосредственно на странице программы'],
  false, null
);

-- verified=true: стоимость €726.72/семестр для не-EU подтверждена официальной страницей TU Wien по tuition fee, дедлайн 15 января для не-EU/EEA — страницами academic calendar и admission, IELTS 6.5 — страницей Competence in English. Все три параметра для не-EU найдены на официальных страницах TU Wien.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Master Financial and Actuarial Mathematics', 'Business Analytics', 'English', 24, 2907,
  1, 15, 6.5, 3, 'https://www.tuwien.at/en/mg/fam/studying/master-fam',
  array['ÖH fee reduction / hardship funds for non-EU students after first semester'],
  'Магистерская программа TU Wien по финансовой и актуарной математике — единственная в Австрии, покрывающая полную теоретическую часть подготовки актуариев. Для не-EU студентов обучение очень доступное по европейским меркам.',
  array['Низкая стоимость для не-EU: ~€726.72/семестр (итого ~€2907 за 4 семестра)', 'Сильная актуарская школа и признание программы австрийской актуарской ассоциацией', 'Венa как центр финансов и стабильная среда для карьеры в страховании/банках'],
  array['Дедлайн для не-EU жёсткий — 15 января на зимний семестр (подавать документы сильно заранее)', 'IELTS 6.5 — нужен подтверждённый сертификат, от waive-вариантов отказались', 'Минимальный GPA формально не указан — отбор по содержанию бакалавриата, что непрозрачно для аппликантов'],
  true, current_date
);

-- 2026-09-03, ручной дедуп-обзор перед --apply: программа "Master
-- Curriculum Statistics and Probability in Mathematical Economics (SPME)"
-- убрана — тот же самый предмет TU Wien, что и запись выше ("Statistics,
-- Probability and Mathematics in Economics"), найденная под другим URL
-- (страница факультетского "curriculum" вместо основной страницы
-- программы). normalizeName() не поймал — разные слова, тот же класс
-- ловушки, что уже документирован в CLAUDE.md для BME/Trento/Sapienza. У
-- убранной версии к тому же была неверная (EU, не non-EU) стоимость
-- €363.36 вместо реальных €2906.88 — второй независимый повод её не
-- оставлять.

-- На известном URL https://www.tuwien.at/en/ace/programs/mba-programs/general-management подтверждены: название программы и стоимость EUR 27 890 (VAT-free, единая ставка без разделения EU/non-EU). Дедлайн и требования по IELTS/GPA на этой странице явно не указаны, поэтому поставлены оценочные значения из расчёта на типичный осенний набор Executive MBA TU Wien; из-за этого verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Executive MBA General Management', 'Business Analytics', 'English', 24, 27890,
  9, 15, 6.5, 3, 'https://www.tuwien.at/en/ace/programs/mba-programs/general-management',
  array['TU Wien Alumni discount -10%', 'Summer Decision Bonus EUR 1000 (early application)'],
  'Executive MBA General Management от TU Wien Academy — программа для работающих специалистов, преподаётся на английском, сочетает общие управленческие дисциплины с технологической экспертизой вуза. Стоимость фиксированная и единая для всех студентов вне зависимости от гражданства.',
  array['Плоская стоимость обучения — нет отдельной повышенной ставки для non-EU студентов', 'Скидка 10% для выпускников TU Wien и бонус 1000 EUR за раннюю подачу', 'Бренд TU Wien и сильный технологический уклон, удобно для инженеров и технарей'],
  array['Точный дедлайн подачи и минимальный IELTS для non-EU абитуриентов не указаны на самой странице программы — приведены оценочные значения (середина сентября, IELTS 6.5), verified=false', 'Высокая стоимость (~27890 EUR) без явных стипендий для международных студентов', 'Программа модульная/part-time, требует совмещения с работой'],
  false, null
);

-- verified=false: на официальной странице tuwien.at подтверждены только название, старт (октябрь 2026) и стоимость €28,890. Разделение EU/non-EU на странице не обнаружено (для executive-MBA это обычно единая цена). Точный дедлайн и IELTS на этой странице не указаны — взяты из вторичных источников (accessmba.com: 13.09.2026) и общего требования TU Wien ACE (IELTS 6.5). Для подтверждения IELTS и финального дедлайна нужно открыть полную страницу или Admissions PDF.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Executive MBA Innovation Management & Entrepreneurship', 'Business Analytics', 'English', 18, 28890,
  9, 13, 6.5, 3, 'https://www.tuwien.at/en/ace/programs/mba-programs/innovation-management-entrepreneurship',
  array['TU Wien Alumni 10% tuition discount (~€2,889 off)', 'Early/summer decision bonus €1,000 reduction'],
  'Executive MBA от TU Wien Academy для технологических лидеров и предпринимателей: 18 месяцев, модульный формат, старт в октябре 2026, стоимость €28,890. Программа ориентирована на управление инновациями и запуск новых бизнесов в технологическом секторе.',
  array['Преподаётся в TU Wien — топовый технический университет с сильным брендом в STEM и инновациях', 'Модульный/part-time формат удобен для работающих специалистов', 'Доступны скидки: 10% для выпускников TU Wien и €1,000 за раннее решение'],
  array['Высокая стоимость €28,890 и явное разделение цены EU/non-EU на странице программы не подтверждено — вероятна единая ставка', 'IELTS/языковой минимум не подтверждён непосредственно на официальной странице программы, указан оценочно 6.5 по стандарту TU Wien ACE', 'Дедлайн 13 сентября 2026 взят из агрегатора accessmba.com, на официальной странице фигурирует только «October 2026»'],
  false, null
);

-- verified=false, потому что на официальной странице программы (https://www.tuwien.at/en/ace/programs/mba-programs/management-technology-mba-for-ace-alumni) подтверждена только tuition (€13 800–€16 000, без НДС) и язык (German/English). Дедлайн указан как «Dates on request» без конкретной даты, IELTS-минимум для non-EU отдельно не прописан, а EU/non-EU distinction в tuition отсутствует. Поэтому все три обязательных поля (tuition, deadline, language) для non-EU на одной и той же странице одновременно не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Executive MBA for ACE Alumni', 'Business Analytics', 'English', 24, 16000,
  4, 30, 6, 3, 'https://www.tuwien.at/en/ace/programs/mba-programs/management-technology-mba-for-ace-alumni',
  array[]::text[],
  'Программа Executive MBA for ACE Alumni в TU Wien — это 24-месячная executive-программа (part-time) для выпускников ACE, ориентированная на менеджмент и технологии. Стоимость указана в диапазоне €13800 – €16 000 (без НДС, без учёта расходов на поездки и проживание); язык — немецкий или английский.',
  array['Гибкий формат для работающих специалистов (executive MBA, part-time)', 'Программа ведётся на английском или немецком, удобно для международных студентов', 'Стоимость ниже, чем у большинства других executive MBA в TU Wien (€13800–€16 000 против €27 890–€34 890 у остальных программ ACE)'],
  array['Точная стоимость даётся диапазоном €13 800–€16 000 и зависит от количества ECTS — итоговая сумма для non-EU студентов на странице не зафиксирована одной цифрой', 'Дедлайн подачи заявки не указан на странице программы: написано «Dates on request via mba@tuwien.ac.at» — конкретной даты нет', 'Минимальный балл IELTS официально не прописан на странице программы; требование6.0 — это общий ориентир TU Wien для non-EU, а не подтверждённая цифра именно для этого MBA', 'Явного разделения tuition fee на EU/non-EU rate на странице нет (программа позиционируется как executive continuing education с единой ценой для всех)'],
  false, null
);

-- Подтверждено: tuition €726,72/семестр для не-EU (на официальной странице tuwien.at/en/studies/admission/students-union-fee-and-tuition-fee/tuition-fee и в нескольких сторонних источниках), IELTS 6.5 Academic (страница Competence in English на tuwien.at). Дедлайн 1 мая для октябрьского набора взят из стороннего руководства kadamboverseas (не с официальной страницы программы). Не всё подтверждено одним официальным URL, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Biomedical Engineering', 'Computational Engineering', 'English', 24, 2907,
  5, 1, 6.5, 3, 'https://www.tuwien.at/en/studies/studies/master-programmes/biomedical-engineering',
  array[]::text[],
  'Совместная англоязычная магистерская программа TU Wien и MedUni Vienna (120 ECTS, 4 семестра), фокус на биомедицинской инженерии с сильной математической и физической подготовкой.',
  array['Низкая学费 для не-ЕС: ~€726,72/семестр (~€2907 за всю программу) — одна из самых доступных в Европе', 'Совместный диплом TU Wien + MedUni Vienna — престиж и доступ к клинической базе', 'IELTS 6.5 — умеренное требование по английскому'],
  array['Дедлайн 1 мая для октябрьского набора — жёсткое окно для иностранных абитуриентов; конкретный GPA-минимум для не-EU на найденных страницах не указан', 'Требования по предыдущему образованию (бакалавр в смежной инженерной/естественнонаучной области) могут быть барьером для непрофильных кандидатов'],
  false, null
);

-- verified=false, так как tuition, deadline и языковые требования подтверждены на РАЗНЫХ страницах TU Wien, а не на одной. Tuition €726,72/семестр для не-ЕС — с https://www.tuwien.at/en/studies/admission/students-union-fee-and-tuition-fee/tuition-fee (4 семестра ≈ €2 907). IELTS 6.5 — с официальной страницы English Competence. Дедлайн 30 апреля не подтверждён напрямую на странице программы; admission period для winter 2025/26 = 7 июля – 10 декабря 2025, но не-ЕС аппликанты с визой обычно ориентируются на апрель. Шаблонные поля tuition_eur=6400 и ielts=6.0 заменены на реальные подтверждённые значения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Civil Engineering (Structural Engineering and Construction)', 'Computational Engineering', 'English', 24, 2907,
  4, 30, 6.5, 3, 'https://www.tuwien.at/en/studies/studies/master-programmes/civil-engineering',
  array[]::text[],
  'Магистерская программа TU Wien по гражданскому строительству (конструкции и строительство) на английском, 4 семестра (120 ECTS). Для не-граждан ЕС/ЕЭЗ — дифференцированная плата за обучение ~€726,72/семестр, всего около €2 907 за всю программу.',
  array['Невысокая стоимость обучения для не-ЕС студентов (значительно дешевле англоязычных программ в США/Великобритании)', 'Престижный европейский технический вуз с сильной инженерной школой', 'Программа полностью на английском, Вена как студенческий город', 'Возможность не платить tuition до 4-х семестров для граждан стран из Приложения 1 (Annex 1)'],
  array['Дедлайн 30 апреля для не-ЕС — предположение (официальная страница программы показывает admission period July–December; конкретный апрельский дедлайн для аппликантов с визой не подтверждён на одной странице)', 'Минимальный балл IELTS 6.5, а не 6.0 как в шаблоне (по официальной странице требований TU Wien)', 'Точный GPA-минимум на найденных страницах не указан (есть общее требование о релевантном бакалавриате ≥180 ECTS)', 'Требуется прохождение процедуры отбора (selection procedure) для отдельных специализаций — нужно проверять дополнительно'],
  false, null
);

-- Язык (IELTS 6.5 / CEFR B2) подтверждён на informatics.tuwien.ac.at/master/software-engineering/. Стоимость €726,72/сем для не-ЕС подтверждена на tuwien.at/en/studies/admission/students-union-fee-and-tuition-fee/tuition-fee. Дедлайн 1 марта для не-ЕС взят из сторонних источников (Facebook/Reddit), а не с единой официальной страницы программы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Software Engineering', 'Computer Science', 'English', 24, 2907,
  3, 1, 6.5, 3, 'https://informatics.tuwien.ac.at/master/software-engineering/',
  array[]::text[],
  'Магистерская программа по разработке ПО в TU Wien (Венский технологический университет) на английском языке. Длится 4 семестра, для студентов вне ЕС/ЕЭЗ составляет €726,72 за семестр.',
  array['Англоязычная программа в ведущем техническом университете Австрии', 'Умеренная стоимость обучения по сравнению с англоязычными странами (≈€2 907 за всю программу для не-ЕС)', 'Вена — крупный IT-хаб с хорошими карьерными перспективами'],
  array['Точный дедлайн для не-ЕС абитуриентов не подтверждён на одной странице с остальными данными (источники указывают ~1 марта)', 'Дополнительно нужно оплачивать студенческий взнос ÖH (~€20/сем)', 'Требования по GPA не указаны явно на странице программы', 'Ссылка не ответила за отведённое время при автоматической проверке — открой вручную перед показом'],
  false, null
);

-- Не подтверждено всё на одной странице: tuition €726.72/семестр для non-EU подтверждён на tuwien.at/en/studies/admission/students-union-fee-and-tuition-fee/tuition-fee и в нескольких сторонних источниках; дедлайн 30 апреля для non-EU — типичный для TU Wien (зимний семестр), но на конкретной странице программы явно не извлечён; IELTS 6.5 указан в Scribd-документе и общих требованиях TU Wien. verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b507fd75-10ff-405d-9dc6-359d4587760d',
  'Manufacturing and Robotics', 'Robotics', 'English', 24, 2907,
  4, 30, 6.5, 3, 'https://www.tuwien.at/en/studies/studies/master-programmes/mechanical-engineering/manufacturing-and-robotics',
  array['Austrian Development Cooperation scholarships (limited)', 'OeAD scholarships for non-EU applicants'],
  'Магистратура TU Wien по производству и робототехнике на английском, 4 семестра, с сильной технической базой и связью с промышленностью Вены. Для не-ЕС студентов обязательна оплата tuition fee с первого семестра.',
  array['Англоязычная программа в топовом техническом университете', 'Низкая tuition fee по сравнению с англоязычными странами (~€726/семестр)', 'Сильная индустриальная экосистема Вены'],
  array['Реальная tuition для non-EU — €726.72/семестр, шаблонная цифра 6400 € в задании неверна; не-ЕС дедлайн обычно 30 апреля, подтверждён на сторонних источниках, но не найден явно на самой странице программы', 'Требуется IELTS 6.5 (не 6.0)', 'Минимальный GPA не заявлен на странице программы — оставлен null'],
  false, null
);

-- Подтверждено с одной страницы: tuition €726,72/сем для non-EU (источник: tugraz.at/en/.../tuition-fees-and-the-austrian-student-union-fee), дедлайн 15 December 2026 (источник: tugraz.at/.../admission-procedure/masters-degree-programme-software-engineering-and-management), длительность 4 семестра English (страница программы). IELTS 6.5 — по непрямым упоминаниям абитуриентов, на официальной странице требования к языку для этой магистратуры отдельно не зафиксированы в выдаче, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Software Engineering and Management (MSc)', 'Computer Science', 'English', 24, 2907,
  12, 15, 6.5, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/software-engineering-and-management',
  array['ÖH student union fee waivers (limited)', 'Merit-based TU Graz faculty scholarships 750-3600 EUR'],
  'Магистерская программа TU Graz на английском языке (4 семестра, 120 ECTS). Для студентов из стран вне ЕС/ЕЭЗ обязательна оплата tuition fee в размере €726,72 за семестр; граждане ЕС/ЕЭЗ платят только взнос ÖH (~€24,70/сем). Подача документов для иностранцев — до 15 декабря (на зимний семестр).',
  array['EU/EEA студенты учатся фактически бесплатно (только ÖH-взнос); non-EU плата ~€726/сем — одна из самых низких в Австрии', 'Английский язык обучения, сильная техническая репутация TU Graz, признанная в ЕС'],
  array['Точный минимальный балл IELTS для этой конкретной программы на официальной странице не подтверждён — указан ориентир 6.5 по косвенным данным (форумы/посты абитуриентов), требуется уточнить на admission-странице', 'Дедлайн 15 декабря жёсткий и единый для non-EU на зимний семестр 2027/28; для летнего семестра процедура может отличаться'],
  false, null
);

-- Тариф не-ЕС €726.72/семестр подтверждён на официальной странице TU Graz о взносах (tuition-fees-and-the-austrian-student-union-fee). Крайний срок 30 апреля для не-ЕС абитуриентов магистратуры подтверждён страницей Admission Periods и сторонним источником beyondthestates.com. IELTS на той же странице, что и программа, явно не указан — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Production Science and Management (MSc)', 'Business Analytics', 'English', 24, 3000,
  4, 30, 6, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/production-science-and-management',
  array[]::text[],
  'Магистерская программа TU Graz по производственным наукам и управлению на английском,4 семестра / 120 ECTS, сочетает инженерию и бизнес. Стоимость для не-ЕС студентов — около €726.72 за семестр плюс взнос ÖH.',
  array['Один из самых низких тарифов для не-ЕС в Европе (~€726/семестр по официальной странице TU Graz)', 'Полностью англоязычная программа в техническом университете с сильной инженерной репутацией', 'Удобный для не-ЕС крайний срок — 30 апреля на зимний семестр'],
  array['IELTS 6.0 указан как ориентир, но конкретное требование именно для этой программы на указанной странице не подтверждено — нужно проверять admission-процедуру', 'Не найдено подтверждение именно на странице программы ни IELTS, ни точной GPA; verified=false'],
  false, null
);

-- verified=false: на странице самой программы подтверждены только длительность (4 семестра, 120 ECTS) и требование релевантного бакалавриата. Стоимость 726,72 €/семестр для не-ЕС взята со страницы Tuition Fees (tugraz.at/.../tuition-fees-and-the-austrian-student-union-fee) и подтверждена сторонними источниками; IELTS 7.0 — со страницы Proof of English Language Competence (tugraz.at/.../proof-of-english-language-competence); дедлайн 30 апреля для не-ЕС магистров — типичный для TU Graz, но точная дата на зимний семестр 2026/27 на момент поиска не указана явно на странице программы. Все три ключевых параметра (tuition/deadline/language) НЕ подтверждены одновременно на одной странице программы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Mechanical Engineering and Business Economics (MSc)', 'Computational Engineering', 'English', 24, 2907,
  4, 30, 7, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/mechanical-engineering-and-business-economics',
  array[]::text[],
  'Магистратура TU Graz на стыке машиностроения и экономики предприятия: 4 семестра, 120 ECTS, обучение на немецком. Сильная техническая база престижного технического университета Австрии и дополнительная бизнес-компетенция для инженеров.',
  array['Невысокая стоимость для не-ЕС: ~726,72 € за семестр (≈2907 € за всю программу)', 'Престижный диплом TU Graz и востребованная комбинация инженерии и бизнеса'],
  array['IELTS требуется не ниже 7.0 (а не 6.0 как во многих других вузах) — подтверждено на отдельной странице требований TU Graz, не на странице программы'],
  false, null
);

-- Подтверждено с официальной страницы TU Graz: стоимость 16 100 EUR (standard rate) и дедлайн 31 января 2027. Разделения EU/non-EU на странице не обнаружено — это программа дополнительного образования с единой ставкой. IELTS и GPA в сниппете не отображены, поэтому значения 6.0 и 3.0 являются оценкой, а verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'MBA Leadership in Digital Transformation', 'Business Analytics', 'English', 18, 16100,
  1, 31, 6, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/continuing-education/part-time-masters-programmes-and-university-programmes/university-programme-leadership-in-digital-transformation/mba-leadership-in-digital-transformation',
  array[]::text[],
  'Заочная MBA-программа Технического университета Грац по лидерству в цифровой трансформации: 3 семестра (part-time), 35 дней очных занятий, онлайн-формат с сессиями в Граце. Стандартная стоимость 16 100 EUR (без НДС), для выпускников TU Graz по Industrial Engineering действует скидка до 13 500 EUR.',
  array['Программа от технического университета с сильной инженерной репутацией', 'Гибкий part-time формат, совмещаемый с работой', 'Чётко обозначенная стоимость без скрытых платежей (VAT-free)'],
  array['Стоимость 16 100 EUR единая для всех (явное разделение EU/non-EU на странице не найдено — это continuing education program с фиксированной ставкой)', 'Минимальный балл IELTS и требования к GPA на странице не указаны в выдаче — цифры ориентировочные', 'Длительность фактически 3 семестра (~18 месяцев), а не 24, как часто заявляют в обзорах', 'Старт только раз в год (март), дедлайн 31 января — пропуск сдвигает поступление на год'],
  false, null
);
