-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- ============================================================
-- Новый запуск того же дня/страны/режима — ДОПИСАНО поверх уже
-- накопленного файла, не стёрто (см. комментарий в коде main()).
-- ============================================================
-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: tuition для non-EU на странице самой программы не подтверждён (только общая страница tuition-fees и упоминания прочих магистратур), IELTS 5.5 и deadline 30 апреля подтверждены для архитектурного блока через официальные страницы polito.it (scadenze-area-architettura-aa-202627 и требования a.y. 2025/26). Чтобы verified=true, нужно увидеть все три параметра на одной и той же странице программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5b0df094-b9f9-40df-bbd9-83de0d015214',
  'Architecture for Heritage', 'Architecture', 'English', 24, null,
  'unknown', null,
  4, 30, 5.5, null, 'https://www.polito.it/en/education/master-s-degree-programmes/architecture-for-heritage',
  array[]::text[],
  'Магистерская программа MSc в Politecnico di Torino на английском языке, посвящённая сохранению архитектурного наследия. Длительность 2 года, проводится в Турине.',
  array['Престижный итальянский технический университет, программа полностью на английском', 'Специализация на наследии — узкая и сильная ниша'],
  array['Не удалось подтвердить точную стоимость именно для non-EU студентов на официальной странице программы (поэтому tuition_eur = null) — реальная сумма зависит от дохода семьи и варьируется, уточняйте через Apply@polito и страницу tuition fees', 'Требование по IELTS на программах архитектурного блока — 5.5 (CEFR B2), что мягче, чем у топовых вузов', 'Минимальный GPA на странице не указан'],
  false, null
);

-- verified=false: страница программы (polito.it/.../landscape-architecture) найдена и подтверждена, длительность 24 мес. — стандарт. Дедлайн 24 марта 2027 для не-итальянских квалификаций взят со страницы polito.it/en/education/.../applicants-with-a-non-italian-qualification (цикл 2026/27). Точная сумма tuition для non-EU на странице программы не указана — Politecnico применяет flat-range по ВВП страны (см. регламент contribuz_immatricolati_post CDA 2025/2026), конкретная цифра для Landscape Architecture не извлечена, поэтому tuition_eur оставлен null. IELTS-минимум для конкретно этой магистратуры также не подтверждён в выдаче — указана оценка 5.5 по общеуниверситетской практике Polito.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5b0df094-b9f9-40df-bbd9-83de0d015214',
  'Landscape Architecture', 'Architecture', 'English', 24, null,
  'unknown', null,
  3, 24, 5.5, null, 'https://www.polito.it/en/education/master-s-degree-programmes/landscape-architecture',
  array[]::text[],
  'Магистерская программа по ландшафтной архитектуре в Политехническом университете Турина на английском языке, направленная на подготовку ландшафтных архитекторов с инструментами для решения современных и будущих задач проектирования открытых пространств.',
  array['Преподавание на английском языке в ведущем итальянском техническом университете', 'Сильная архитектурная школа и связи с индустрией ландшафтного проектирования в Италии и ЕС'],
  array['Точный размер tuition для non-EU студентов на странице программы не подтверждён — Politecnico использует систему flat-range, привязанную к ВВП страны студента (по регламенту ~€2 800–3 800/год, но точная цифра для Landscape Architecture не найдена)', 'Минимальный балл IELTS не подтверждён для конкретно этой программы (5.5 — общеуниверситетский ориентир Polito, но для архитектурного блока может быть 6.0)', 'Средний балл (GPA) официально не публикуется'],
  false, null
);

-- В официальном результате поиска найдена страница программы Politecnico di Torino, но в доступном результате отсутствуют числовые сведения о tuition, deadline и IELTS именно для NON-EU/international applicants. Значения не заменялись предположениями; tuition_eur, deadline_month, deadline_day и ielts_min оставлены null. GPA также не указан.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5b0df094-b9f9-40df-bbd9-83de0d015214',
  'Architecture for Sustainability', 'Architecture', 'English', 24, null,
  'unknown', null,
  null, null, null, null, 'https://www.polito.it/en/education/master-s-degree-programmes/architecture-for-sustainability',
  array[]::text[],
  'Официальная страница подтверждает магистерскую программу Architecture for Sustainability в Политехническом университете Турина продолжительностью 2 года. Точные актуальные значения стоимости, срока подачи и минимального IELTS для неевропейских студентов на этой странице не опубликованы.',
  array['Программа официально представлена на сайте Политехнического университета Турина', 'Продолжительность программы — 2 года', 'Страница описывает архитектурную подготовку в контексте устойчивого развития'],
  array['Не найдено подтверждение конкретной стоимости для неевропейских студентов; возможные сторонние цифры нельзя считать официальными', 'Страница программы не подтверждает точный срок подачи и минимальный балл IELTS для неевропейских студентов', 'Поскольку tuition+deadline+language не подтверждены на одной странице, verified=false'],
  false, null
);

-- verified=false, так как на одной и той же странице не подтверждены одновременно все три параметра (tuition+deadline+IELTS) для не-ЕС студентов. Сумма €7,500 за полный курс взята со страницы santannapisa.it/en/tuition-fee (там указано ''tuition fee for the full Master Programme is 7.500,00 Euro... of non-OECD countries''), но из-за неоднозначности фрагмента (два взноса по €3,250 дают €6,500, а не €7,500) цифра требует верификации. Дедлайн (30 апреля) и IELTS 6.0 — экспертные оценки по типичной практике итальянских магистратур, не подтверждены документально.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '02815259-4827-4e75-bedc-0f5752495996',
  'MSc in Nursing and Midwifery Sciences', 'Medicine', 'English', 24, 7500,
  'ai', current_date,
  4, 30, 6, null, 'http://www.santannapisa.it/en/formazione/msc-nursing-and-midwifery-sciences-nursing-profile',
  array[]::text[],
  'Магистерская программа по сестринскому делу и акушерству в Школе передовых исследований Сант''Анна в Пизе (совместно с Пизанским университетом), 2 года, на английском языке. Программа ориентирована на практикующих медсестёр и акушерок, желающих получить академическую квалификацию магистра.',
  array['Престижная школа с высоким академическим статусом (Scuola Superiore Sant''Anna)', 'Программа ведётся на английском языке, подходит для иностранных студентов', 'Возможность совмещения клинической практики и исследовательской деятельности'],
  array['Точная стоимость для не-ЕС студентов указана на странице tuition fee как €7,500 за полный курс, но во фрагменте с сайта есть несостыковка с двумя взносами по €3,250 (= €6,500) — возможно, речь о разных категориях (OECD/non-OECD); требует уточнения на официальной странице', 'Конкретный дедлайн подачи для не-ЕС абитуриентов и точный требуемый балл IELTS не подтверждены в выдаче — оценки (апрель, 6.0) приблизительные', 'Минимальный GPA официально не опубликован на найденных страницах'],
  false, null
);

-- Подтверждено: программа существует на unibocconi.it, длительность 24 мес. Сторонние источники дают общую стоимость €36,000 за 2 года (accessmasterstour.com — без явного разделения EU/non-EU), дедлайн 30 апреля для non-EU (пост Facebook admissions 2025) и GPA 3.0. IELTS 6.0 — общеуниверситетский минимум Bocconi для магистратуры, но конкретный минимум для этой MA не подтверждён. Все три ключевых параметра (tuition/deadline/language) НЕ найдены на одной официальной странице программы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a4ea4764-901f-4cc1-abbe-7ef94dd184b0',
  'MA in Global Law for Organizations, Business Enterprises and Institutions', 'Law', 'English', 24, 36000,
  'ai', current_date,
  4, 30, 6, null, 'https://www.unibocconi.it/en/programs/law/master-arts-global-law-organizations-business-enterprises-and-institutions',
  array['Bocconi Merit-based International Awards (partial tuition waivers for non-EU students)'],
  'Двухгодичная магистерская программа Bocconi на английском для юристов и выпускников смежных специальностей с акцентом на международное корпоративное, коммерческое и регуляторное право. Сильная репутация в Европе, хорошая трудоустройство в транснациональные компании и юрфирмы.',
  array['Престижная бизнес-школа с глобальной сетью выпускников', 'Программа полностью на английском в центре Милана', 'Сильная интеграция права и бизнеса (cross-disciplinary)'],
  array['Точные данные по нерезидентам ЕС (tuition/IELTS минимум) не удалось подтвердить на одной официальной странице программы — цифры взяты из сторонних агрегаторов (accessmasterstour.com) и постов о приёме 2025 года, поэтому verified=false'],
  false, null
);

-- Официальная страница программы подтверждена поисковым результатом. В результатах не содержится явного подтверждения неевропейской tuition fee, дедлайна и IELTS на одной странице; поэтому tuition_eur — предварительная оценка, deadline_month/day — предварительная оценка, а ielts_min оставлен null. gpa_min не найден.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f2126c07-5036-4fdd-89ac-1c448dc88422',
  'International Relations and European Studies (RISE)', 'International Relations', 'English', 24, 6400,
  'ai', current_date,
  4, 30, null, null, 'https://apply.unifi.it/courses/course/53-relazioni-internazionali-e-studi-europei',
  array[]::text[],
  'Магистерская программа Университета Флоренции рассчитана на 2 года. Для нерезидентов ЕС, проживающих за рубежом, ориентировочная стоимость указана как около €6 400, однако конкретная неевропейская ставка на официальной странице в доступном результате поиска не подтверждена.',
  array['Отдельная программа для международных отношений и европейских исследований', 'Срок обучения — 24 месяца'],
  array['На официальной странице в доступном результате поиска не подтверждены точный срок подачи для нерезидентов ЕС и минимальный IELTS; указанные здесь €6 400 и 30 апреля являются предварительными оценками, поэтому verified=false.'],
  false, null
);

-- verified=false: программа и URL подтверждены, длительность 24 мес. подтверждена на apply.unimi.it, но tuition/deadline/IELTS не подтверждены единым официальным источником в одном поисковом раунде. tuition оценён по globaladmissions.com (~$4489/год ≈ €4100/год ×2 = ~€8200 за всю программу), дедлайн — типичный для non-EU абитуриентов итальянских вузов (конец апреля), IELTS — общий порог Unimi 6.0 (topuniversities агрегатор указал 5.5+, что может быть устаревшим). gpa_min=null: европейские программы, как правило, не публикуют GPA-порог.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '53f4265a-a5bb-47a3-92ad-4fe0f7693863',
  'Theatre, Arts, Literatures. International Studies in Intermediality', 'International Relations', 'English', 24, 8200,
  'ai', current_date,
  4, 30, 6, null, 'https://www.unimi.it/en/education/master-programme/theatre-arts-literatures-international-studies-intermediality',
  array[]::text[],
  'Междисциплинарная магистратура Университета Милана (La Statale) по театру, искусствам и литературам в перспективе интермедиальности. Два года (120 ECTS), обучение на комбинации итальянского и английского, требуется итальянский B1.',
  array['Престижный государственный университет Милана с сильной гуманитарной школой', 'Междисциплинарная программа с уникальным фокусом на интермедиальности', 'Открытый доступ (open access) — отдельного вступительного экзамена нет'],
  array['Стоимость, дедлайн и точный порог IELTS не удалось подтвердить на официальной странице unimi.it в одном раунде поиска — цифры основаны на сторонних агрегаторах (globaladmissions ~$4489/год, topuniversities IELTS 5.5+). Проверьте страницу unimi.it и портал apply.unimi.it лично.', 'Программа заявлена как англо-итальянская, требуется итальянский минимум B1 — чисто англоязычного обучения нет', 'Стипендии и точная non-EU ставка tuition на официальной странице в сниппетах не раскрыты'],
  false, null
);

-- verified=false: дедлайн 30 апреля подтверждён на официальной подстранице для обладателей иностранных дипломов (rel.cdl.unimi.it/en/enrolment/candidates-holding-foreign-degree), IELTS 5.5 указан на стороннем агрегаторе TopUniversities со ссылкой на требования программы. Точный размер платы для не-ЕС на официальной странице программы не найден — указана оценка ~€3 300/год (типичный фиксированный тариф Миланского университета для не-ЕС на магистратуре), суммарно ~€6 600 за 2 года. GPA не публикуется нигде, оставлен null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '53f4265a-a5bb-47a3-92ad-4fe0f7693863',
  'International Relations (REL)', 'International Relations', 'English', 24, 6600,
  'ai', current_date,
  4, 30, 5.5, null, 'https://rel.cdl.unimi.it/en/enrolment/candidates-holding-foreign-degree',
  array['Invest Your Talent in Italy (Italian Government scholarship for non-EU students)', 'DSU Lombardia regional scholarship'],
  'Двухгодичная магистратура по международным отношениям в государственном Миланском университете (Università degli Studi di Milano Statale), полностью на английском. Для иностранных (не-ЕС) студентов действует фиксированная повышенная плата за обучение, отличная от льготной шкалы для граждан ЕС.',
  array['Программа целиком на английском — без требования итальянского', 'Милан — крупный международный хаб, много стажировок в НКО, бизнесе и при ЕС-структурах', 'Государственный университет с сильной школой политических и правовых наук', 'Доступ к стипендиям правительства Италии и региона Ломбардия для не-ЕС студентов'],
  array['Дедлайн 30 апреля для не-ЕС студентов — заметно раньше, чем для граждан ЕС (обычно до конца августа)', 'Точный размер платы для не-ЕС не подтверждён на официальной странице программы — цифра оценочная', 'Минимальный GPA не публикуется — приёмная комиссия оценивает академическую подготовку по портфолио', 'IELTS 5.5 формально опубликован TopUniversities, но фактический порог может быть выше на конкурсе'],
  false, null
);

-- verified=false: на основной странице unimi.it/en/education/master-programme/law-and-sustainable-development в сниппетах подтверждены только название, язык (English), длительность (2 года, 120 ECTS) и формат (open with entry requirements examination, in-person, Milan). Конкретная сумма tuition для non-EU студентов, точный deadline и IELTS-score на этой странице в открытых сниппетах не обнаружены — приведены best-sourced оценки по типичной практике Университета Милана для non-EU без ISEE. Для подтверждения нужно открыть страницу fees/contributions и портал apply.unimi.it напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '53f4265a-a5bb-47a3-92ad-4fe0f7693863',
  'Law and Sustainable Development', 'Law', 'English', 24, 6400,
  'ai', current_date,
  4, 30, 6, null, 'https://www.unimi.it/en/education/master-programme/law-and-sustainable-development',
  array[]::text[],
  'Магистерская программа «Право и устойчивое развитие» Университета Милана на английском языке (120 ECTS, 2 года). Доступна для иностранных выпускников бакалавриата; проводится в Милане с экзаменом при поступлении.',
  array['Полностью английская программа в крупном государственном университете Италии', 'Длительность 2 года и 120 ECTS — полноценная магистратура, признаваемая в ЕС', 'Тематика устойчивого развития — востребованное направление с перспективами в ESG, международных организациях и корпоративном праве', 'Милан — крупный деловой и юридический центр с возможностями стажировок'],
  array['Точная стоимость для non-EU студентов не подтверждена на официальной странице; приведённая цифра €6 400 — оценка по типичным ставкам итальянских госвузов без ISEE (≈€3 000–3 500/год × 2 года), verified=false', 'Конкретный дедлайн для non-EU абитуриентов на странице программы не указан явно (указан типичный для Италии — 30 апреля), требует уточнения на apply.unimi.it / портале Universitaly', 'По IELTS есть расхождение: llm-guide указывает 7.0 для LL.M., официальная страница — лишь «proficient in English» без балла; 6.0 — оценка по общему минимуму Университета Милана, требует подтверждения', 'GPA-minimum не публикуется — итальянские программы оценивают документы индивидуально (поэтому gpa_min = null)'],
  false, null
);
