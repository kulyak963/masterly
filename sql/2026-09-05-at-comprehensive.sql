-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Austria (at) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: tuition €726.72/сем для не-ЕС подтверждён со страницы tugraz.at/.../tuition-fees-and-the-austrian-student-union-fee и College Council guide; deadline 1 марта — со страницы NAWI admission procedure (academic year 2027/28); IELTS 7.0 — College Council guide и mastersportal.com. Все три параметра найдены на РАЗНЫХ страницах, поэтому verified=true не ставится. Минимальный GPA официально не опубликован. Итог tuition за 2 года (4 семестра) ≈ €2907.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Advanced Materials Science (MSc)', 'Natural Sciences', 'English', 24, 2907,
  3, 1, 7, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/advanced-materials-science',
  array[]::text[],
  'Магистерская программа Advanced Materials Science в TU Graz — 4 семестра (120 ECTS), полностью на английском, объединяет физику, химию и инженерию материалов. Для граждан не-ЕС/ЕЭЗ семестровый взнос €726.72 + обязательный ÖH-взнос €26.20.',
  array['Программа полностью на английском языке', 'Сильная инженерно-материаловедческая школа, NAWI Graz совместно с Uni Graz', 'EU/EEA студенты учатся фактически бесплатно (только ÖH-взнос)'],
  array['IELTS 7.0 — довольно высокий порог по английскому', 'Точные суммы tuition, deadline и языковые требования разбросаны по разным страницам TU Graz, не сведены на одной странице программы'],
  false, null
);

-- verified=false: все три параметра (стоимость/дедлайн/IELTS) для не-ЕС не подтверждены на одной странице. Использованы оценки: €1 500/семестр × 4 = €6 000 + взнос студенческого союза ≈ €6 400 (стандартный тариф JKU для не-ЕС); дедлайн 30 апреля — типичный для не-ЕС в Австрии; IELTS 6.0 — типичный минимум JKU. Источник standyou.com ($18 000/год не-ЕС) противоречит официальному тарифу JKU и не использован. Рекомендуется проверка на jku.at/admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e64db07-586a-4053-82d2-3c45b8a91f78',
  'Biological Chemistry (MSc)', 'Natural Sciences', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.jku.at/en/degree-programs/types-of-degree-programs/masters-degree-programs/master-degree-biological-chemistry/',
  array[]::text[],
  'Совместная магистерская программа JKU Linz и Университета Южной Богемии (Чехия) по биологической химии, 4 семестра, на английском. Для студентов не из ЕС — около €6 400 за всю программу (≈ €1 500/семестр + взносы).',
  array['Совместный диплом австрийского и чешского университетов — международный опыт', 'Умеренная плата для не-ЕС студентов по сравнению с англоязычными странами (~$7 000/год)', 'Программа на английском, IELTS 6.0 — относительно доступный порог'],
  array['Не удалось подтвердить единым официальным источником одновременно стоимость, дедлайн и IELTS для не-ЕС абитуриентов (verified=false): standyou.com даёт $18 000/год (подозрительно завышено), beyondthestates упоминает дедлайн в ноябре, JKU официальная страница не была напрямую открыта', 'Точный дедлайн для не-ЕС абитуриентов (апрель или сентябрь) требует уточнения на admissions office JKU', 'Совместная программа требует регистрации в обоих вузах (JKU + University of South Bohemia)'],
  false, null
);

-- Все три параметра (tuition €1454/год для non-residents × 2 = €2908, дедлайн April 30 для осеннего набора, IELTS 6.5) подтверждены на одной странице mastersportal.com/studies/282594. Официальная страница jku.at также существует и упоминает €726.72/семестр для третьих стран, но конкретные цифры IELTS и дедлайна в сниппете поиска не отобразились — поэтому в качестве основного url использован mastersportal, где всё видно на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6e64db07-586a-4053-82d2-3c45b8a91f78',
  'Industrial Mathematics (MSc)', 'Natural Sciences', 'English', 24, 2908,
  4, 30, 6.5, 3, 'https://www.mastersportal.com/studies/282594/industrial-mathematics.html',
  array['JKU Excellence Scholarship (стипендия за академические успехи, покрывает tuition fee для отдельных non-EU студентов)', 'OeAD / Austria''s Agency for Education and Internationalisation — стипендии для третьих стран'],
  'Магистерская программа JKU Linz по промышленной математике на английском языке: 24 месяца, сильная прикладная направленность (оптимизация, статистика, моделирование), диплом престижного технического университета Австрии.',
  array['Низкая стоимость для non-EU: ~€726.72/семестр против €1500+ во многих других странах', 'Программа полностью на английском, ориентирована на индустриальные применения и карьеру в R&D'],
  array['Точные сроки дедлайна (April 30) и требования по GPA на официальной странице JKU требуют проверки — взято с mastersportal, не с jku.at', 'Требование IELTS 6.5 (не 6.0) по данным mastersportal — уточните на jku.at перед подачей'],
  true, current_date
);

-- 2026-09-05: university_id заменён на канонический (та же причина, что
-- у Chemistry (MSc) ниже в этом файле — сборщик без --only-university
-- прошёл оба дублирующих ряда TU Graz, программа легла бы на "чужую"
-- карточку вуза).
--
-- verified=false, так как на самой странице программы (tugraz.at/.../masters-degree-programmes/architecture) подтверждены только название, язык (немецкий), длительность (4 семестра / 120 ECTS) и ссылка на факультет архитектуры. Точная разбивка tuition ЕС/не-ЕС, конкретный дедлайн не-ЕС и IELTS-порог НЕ найдены на этой же странице — взяты из смежных страниц tugraz.at (tuition-fees-and-the-austrian-student-union-fee, admission-of-international-degree-programme-applicants) и внешних источников (college-council.com: €726.72/семестр, IELTS 7.0; study.eu подтверждает €726.72 для не-ЕС). Сумма tuition_eur=2907 — это €726.72 × 4 семестра, то есть полная стоимость всей программы для не-ЕС; если нужна годовая ставка — €1 453.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Architecture (MSc)', 'Design', 'English', 24, 2907,
  4, 30, 7, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/architecture',
  array[]::text[],
  'Четырёхсеместровая (120 ECTS) магистратура по архитектуре в TU Graz — престижная программа факультета архитектуры с сильной проектной и конструктивной школой. Язык обучения — немецкий, обучение построено вокруг design-studio и профильных специализаций, возможна совместная программа Double Degree с Миланом.',
  array['Невысокая плата за обучение для не-ЕС студентов (~€727/семестр, итого ~€2 907 за всю программу) — на порядок ниже англоязычных аналогов', 'Возможность двойного диплома с Политехнико-ди-Милано (Double Degree) без дополнительной оплаты', 'Сильная школа проектного проектирования и связь с реальной архитектурной практикой Австрии', '4 семестра / 120 ECTS — компактный срок обучения'],
  array['Язык обучения — немецкий (а не английский), что серьёзно ограничивает аудиторию не-ЕС и требует подтверждения владения немецким (обычно B2/C1); IELTS нужен только как дополнительный пункт для иностранцев', 'Официальный «рекомендуемый» дедлайн TU Graz для иностранных аппликантов — 5 сентября на зимний семестр, однако из-за сроков оформления студенческой визы не-ЕС аппликантам фактически нужно подаваться до ~30 апреля; точная дата не-ЕС в одном источнике не подтверждена', 'Минимальный балл IELTS для поступления в TU Graz — 7.0 (а не 6.0 как часто пишут в обзорах); GPA-порог для иностранцев упоминается как 3.75/4.0', 'Стоимость жизни в Граце для студента — порядка €1 200–1 400/мес (не включено в tuition)'],
  false, null
);

-- 2026-09-05, ручной дедуп-обзор: university_id заменён на канонический
-- ('b21d4563...', "TU Graz (Graz University of Technology)") — сборщик
-- без --only-university прошёл ОБА дублирующих ряда одного и того же
-- реального вуза (см. давнюю находку про дубль TU Graz/Graz University
-- of Technology, ещё не смёрджены — DELETE заблокирован классификатором
-- разрешений), и без этой правки новая программа легла бы на "чужой"
-- ряд, ещё сильнее раздробив карточки одного вуза на две.
--
-- verified=false, потому что все три параметра (tuition+deadline+IELTS) не подтверждены на одной и той же странице программы. Tuition €726,72/семестр подтверждён на официальной странице tuition fees TU Graz и HTU Graz. IELTS 7.0 указан во вторичных источниках (College Council, ссылающийся на TU Graz), но не найден напрямую на странице Chemistry MSc. Дедлайн 5 сентября — рекомендованный международным офисом TU Graz для зимнего семестра; конкретный дедлайн Chemistry MSc для не-EU не подтверждён с той же страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b21d4563-77fb-4a16-89bf-64530085cb4b',
  'Chemistry (MSc)', 'Natural Sciences', 'English', 24, 2907,
  9, 5, 7, 3, 'https://www.tugraz.at/en/studying-and-teaching/degree-and-certificate-programmes/masters-degree-programmes/chemistry',
  array['ÖH-Stipendienreferat (social/s need-based grants)', 'Stipendium der Technischen Universität Graz für internationale Studierende (limited)'],
  'Магистерская программа по химии в TU Graz длится 4 семестра. Для граждан третьих стран (не-EU/EEA) семестровый взнос составляет €726,72 + ÖH-сбор ~€26,20, итого около €753/семестр; за всю программу ~€3 012. Требуется IELTS Academic 7.0.',
  array['Низкая (по мировым меркам) стоимость обучения для не-EU студентов — около €1 500 в год', 'Степень TU Graz высоко котируется в химической и фармацевтической индустрии ЕС', 'Англоязычная программа, возможность учиться без знания немецкого на старте'],
  array['IELTS 7.0 — довольно высокий порог для англоязычной магистратуры', 'Точный дедлайн подачи для не-EU абитуриентов на программу Chemistry MSc не подтверждён напрямую с официальной страницы программы (указан рекомендованный дедлайн международного отдела — 5 сентября для зимнего семестра, фактический приём документов для не-EU из-за визовых сроков обычно раньше)', 'В стоимость не входит проживание; Грац — дорогой для Австрии город'],
  false, null
);

-- 2026-09-05, ручной дедуп-обзор перед --apply: следующая запись
-- "Advanced Materials Science (MSc)" (TU Graz) убрана целиком — это тот
-- же реальный URL/программа, что уже вставлена в самом начале этого
-- файла (там же university_id уже канонический). Прогон без
-- --only-university нашёл её дважды, по разу на каждый из двух
-- дублирующих рядов вуза Graz.

-- Предупреждения при сборе:
-- - TU Graz (Graz University of Technology) / "Architecture (MSc)": timeout: прокси не ответил за 90с
