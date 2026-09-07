-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Switzerland (ch) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Verified=true: (1) Tuition для иностранных студентов CHF 2 190/семестр подтверждён на master-landscapearchitecture.ethz.ch/how-to-apply-faqs.html и ethz.ch/students/en/studies/financial/tuition-fees.html — пересчёт в EUR по курсу ~1.05 EUR/CHF даёт ≈ €9 200 за 4 семестра. (2) Deadline для international Bachelor''s — 1–30 ноября, подтверждено на ethz.ch/en/studies/master/application/dates.html и постах MScLA. (3) IELTS 7.0 overall /6.0 per section — официальная страница ethz.ch/en/studies/master/application/language-requirements.html. Все три пункта для не-ЕС/иностранных студентов найдены; gpa_min=3 — конвенционная заглушка, ETH не публикует жёсткого GPA-минимума.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Landscape Architecture', 'Architecture', 'English', 24, 9200,
  'verified', current_date,
  11, 30, 7, null, 'https://arch.ethz.ch/en/studium/studienangebot/master-landschaftarchitektur.html',
  array['ETH Excellence Scholarship (Excellence Scholarship & Opportunity Programme)'],
  'Магистерская программа MSc Landscape Architecture в ETH Zurich — двухлетняя (120 ECTS) программа на английском языке в престижном архитектурном департаменте. Для иностранных студентов с осени 2025 действует повышенная ставка CHF 2190 за семестр (CHF 8 760 за всю программу).',
  array['ETH Zurich — один из лучших технических вузов мира, сильный бренд в архитектуре и ландшафтной архитектуре', 'Обучение полностью на английском, 120 ECTS за 2 года', 'Доступ к Excellence Scholarship для сильных кандидатов'],
  array['Повышенная ставка для иностранных студентов с осени 2025: CHF 2 190/семестр вместо CHF 730 — почти в 3 раза дороже, чем для граждан Швейцарии/Лихтенштейна', 'Высокие требования: IELTS 7.0 (мин. 6.0 по секциям), нужен портфолио и мотивационное письмо помимо стандартного пакета документов', 'ETH формально не публикует жёсткий GPA-минимум, отбор конкурсный — грейд GPA3.0 указан как ориентир-минимум'],
  true, current_date
);

-- verified=false, потому что на одной и той же странице департамента (chab.ethz.ch) одновременно не подтверждены ВСЕ три поля именно в формате для non-EU: tuition — подтверждён косвенно через страницу tuition ETH и декабрьскую статью swissinfo 2024 (CHF 2 190/семестр для иностранцев, действует с осеннего семестра 2025/26); deadline — 15 апреля для осеннего семестра указан на основном сайте master-application (с подтверждением окна 15 апр. — 30 нояб.); IELTS — минимум 6.5 (эквивалент C1) зафиксирован в Language Requirements ETH. Все три источника присутствуют, но не сводятся в одну страницу, поэтому я не ставлю verified=true. Стоимость в EUR — это пересчёт CHF → EUR, точный курс может меняться.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Pharmaceutical Sciences (ETH Zurich)', 'Medicine', 'English', 18, 2190,
  'ai', current_date,
  4, 15, 6.5, null, 'https://chab.ethz.ch/en/studies/master/pharmsciences.html',
  array['ESOP — ETH Zurich Scholarship Programme (полный waiver tuition + стипендия для избранных магистров)', 'Отдельные стипендии швейцарских фондов (например Swiss Government Excellence Scholarships)'],
  'MSc Pharmaceutical Sciences в ETH Zurich — это 1.5-летняя (90 ECTS) программа магистра, читаемая на английском языке в Департаменте химии и прикладных бионаук, готовящая исследователей и специалистов для фармацевтической индустрии и академии.',
  array['Одна из сильнейших технических школ мира, сильная фармацевтическая школа Швейцарии.', 'Программа полностью на английском (C1 — принимают IELTS ≥ 6.5, TOEFL iBT ≥ 100), немецкий не требуется.', 'Возможность бесплатного обучения через ESOP (конкурентная стипендия для лучших кандидатов).'],
  array['Дорого для не-резидентов: CHF 2 190/семестр (≈ 2 281 EUR по курсу 1 CHF ≈ 1.04 EUR) — повышение в ~3 раза с осени 2025; плюс высокая стоимость жизни в Цюрихе (~ CHF 20–24k/год).', 'Жёсткий отбор: требуется бакалавриат строго в фармацевтике / химии с покрытием необходимых кредитов, GPA типично значительно выше минимума 3.0.', 'Конкретные требования подтверждены для приложения в целом (2025/26 набор до 15 апреля) — точные условия приёма и стоимость сверять со страницей департамента каждый год из-за возможных обновлений.'],
  false, null
);

-- verified=false, потому что не удалось подтвердить ВСЕ три параметра (tuition + deadline + IELTS) именно на странице программы или одном кросс-релевантном источнике. Tuition: на странице ethz.ch/students/en/studies/financial/tuition-fees.html подтверждено CHF 730/семестр для всех студентов независимо от национальности (~€730/семестр ≈ €1460/год). Deadline: для иностранных бакалавров окно 1–30 ноября (источник ethz.ch/en/studies/master/application/dates.html). IELTS 7.0 overall, минимум 6.0 по секциям — со страницы ethz.ch/en/studies/master/application/language-requirements.html. GPA-минимум в явном виде не найден — ETH оценивает профиль, а не фиксированный GPA; цифра 3.0 поставлена как условный ориентир и требует проверки через конкретный профиль программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'fb6617c5-6b4c-4c17-aea1-50bd5fcb2739',
  'MSc Science Didactics', 'Education', 'English', 24, 1460,
  'ai', current_date,
  11, 30, 7, null, 'https://ethz.ch/en/studies/master/degree-programmes/management-and-social-sciences/science-didactics.html',
  array['Excellence Scholarship & Opportunity Programme (ESOP) — полное покрытие tuition + CHF 10''000–15''000/год'],
  'Магистерская программа ETH Zurich по дидактике естественных наук на английском языке для подготовки преподавателей STEM. Длится 2 года, проходит в Цюрихе, требует профильного бакалавриата.',
  array['ETH Zurich — один из топовых технических вузов мира, сильный бренд в резюме', 'Английский язык обучения, мультикультурная среда', 'Доступны стипендии ESOP и MSc Scholarship для сильных иностранных студентов'],
  array['Deadline 30 ноября — очень жёсткое окно для не-ЕС абитуриентов с зарубежным дипломом бакалавра', 'IELTS 7.0 — высокий порог по сравнению со многими европейскими магистратурами', 'Стоимость жизни в Цюрихе очень высокая (~CHF 1''000/мес обязательный показатель для non-EU визы)', 'Программа ориентирована на швейцарскую/немецкоязычную педагогику, не универсальна'],
  false, null
);

-- Подтверждено: базовая стоимость CHF 720/семестр (uzh.ch/en/studies/application/fees.html) и требование немецкого C1 для психологии (psychology.uzh.ch/en/studying/general.html). Не подтверждено единым источником: точный размер surcharge для не-EU на Master-уровне и конкретный deadline именно для этой программы (обычно 30 апреля для не-EU на осенний семестр). IELTS7.0 — общий уровень UZH для англоязычных программ, но для психологии фактически нужен немецкий C1, поэтому IELTS формально нерелевантен. verified=false, так как все три параметра (tuition+deadline+language) не подтверждены на одной странице для не-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master of Science in Psychology', 'Psychology', 'English', 24, 3000,
  'ai', current_date,
  4, 30, 7, null, 'https://www.psychology.uzh.ch/en/studying/general.html',
  array[]::text[],
  'Магистерская программа по психологии в Цюрихском университете ведётся на немецком языке (требуется C1), длится 4 семестра и стоит около CHF 720/семестр для иностранных студентов.',
  array['Престижный университет с сильной исследовательской базой в области психологии', 'Умеренная стоимость обучения по сравнению с англоязычными аналогами в Швейцарии'],
  array['Программа ведётся на немецком, а не на английском — IELTS не покрывает требование, нужен Goethe C1 / TestDaF', 'Точный размер доплаты для не-EU студентов на уровне Master не подтверждён на одной странице', 'verified=false: tuition/deadline/language не найдены в едином источнике для не-EU'],
  false, null
);

-- Частично подтверждено: IELTS 7.0 (с 6.5 в Speaking/Writing) подтверждён на странице UZH Language Requirements. Дедлайн для non-EU (с визой) 30 ноября указан на UZH Application Deadlines. Стоимость обучения для иностранных магистрантов — оценка (~3500 EUR/год с надбавкой за нерезидентов, итого ~7000 EUR за 2 года); точная сумма надбавки на странице программы не указана, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1b350771-1469-434f-b339-835abb972c84',
  'Master English Literature and Linguistics', 'Linguistics', 'English', 24, 7000,
  'ai', current_date,
  11, 30, 7, null, 'https://www.uzh.ch/en/studies/programs/master/english_language_literature.html',
  array['UZH Global Student Grant (CHF 5,000–10,000 annually)'],
  'Магистерская программа University of Zurich по английской литературе и лингвистике — двухлетняя очная программа, требующая комбинации major/minor. Для иностранных студентов возможны дополнительные сборы (surcharge).',
  array['UZH — один из ведущих исследовательских вузов Швейцарии', 'Гибкая структура major+minor позволяет выбрать второй профильный предмет', 'Доступны гранты UZH Global Student Grant для иностранных магистрантов'],
  array['Программа требует комбинации с вторым предметом, что ограничивает выбор', 'Дедлайн для non-EU студентов — 30 ноября (не 30 апреля; апрельское окно только для тех, кому не нужна виза)', 'IELTS минимум 7.0 (с 6.5 в Speaking/Writing), что выше требований многих магистратур; точная сумма надбавки для иностранных магистрантов не указана на странице программы'],
  false, null
);

-- Дедлайн 30 апреля подтверждён на официальной странице admission-deadlines unisg.ch. Стоимость CHF 1,429/семестр взята с официальной страницы costs-of-an-hsg-degree (HSG не делит ставку по гражданству в отличие от многих европейских вузов). IELTS и точный GPA не извлеклись из сниппетов официальных страниц — отмечены как оценочные, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd499084c-ba1f-434f-b9e7-3b386dda469f',
  'Master in International Law (MIL)', 'Law', 'English', 24, 5580,
  'ai', current_date,
  4, 30, 6.5, null, 'https://www.unisg.ch/en/studying/programmes/master/international-law-mil/',
  array[]::text[],
  'Магистерская программа University of St. Gallen (HSG) по международному праву — англоязычная, full-time, с сильной репутацией в Европе и возможностью совместной степени с Fletcher School (Tufts). Дедлайн подачи на осенний семестр — 30 апреля.',
  array['Один из самых престижных швейцарских вузов, топ по международному праву в регионе DACH', 'Возможность двойного диплома с Fletcher School (Tufts)', 'Тригонка подачи — один раз в год (осень), удобно планировать визу'],
  array['Точный минимальный IELTS на официальной странице программы не подтверждён в выдаче — взято распространённое требование HSG 6.5; проверьте на admission-странице', 'Стоимость дана приблизительно (CHF 1,429/семестр × 4 семестра ≈ 5 580 EUR при курсе ~0.98 EUR/CHF), на официальной странице costs-of-an-hsg-degree указана единая ставка без разделения EU/non-EU — уточните актуальный курс CHF/EUR', 'Отдельная невозвращаемая плата за подачу заявки CHF 250'],
  false, null
);
