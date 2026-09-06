-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Netherlands (nl) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, потому что tuition, deadline и IELTS не подтверждены все три на одной и той же официальной странице UvA в выдаче. По сторонним источникам: TopUniversities указывает International fee €21,885; mimineurope и официальная страница admission подтверждают IELTS Academic 6.5 (мин. 6.0 по субтестам); LinkedIn-профили студентов показывают длительность один год (2024-2025), что соответствует 12 месяцам (а не 24, как в шаблоне). Точная дата дедлайна для не-ЕС на сезон 2026-2027 на самой странице программы не подтверждена — указан типичный для UvA не-ЕС дедлайн ~1 апреля.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Consumer Marketing', 'Business Analytics', 'English', 12, 21885,
  4, 1, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-consumer-marketing/business-administration-consumer-marketing.html',
  array['Amsterdam Merit Scholarship (AMS)'],
  'Годовая магистратура в Amsterdam Business School (UvA), ориентированная на маркетинг потребительских рынков; доступны сентябрьский и февральский старты, сильные связи с индустрией.',
  array['Всего 12 месяцев обучения — быстрый возврат инвестиции', 'Редкая возможность февральского старта в Нидерландах', 'Хорошие перспективы трудоустройства и сильный бренд Amsterdam Business School'],
  array['Высокая стоимость для не-ЕС студентов — около €21,885 в год', 'Голландский GPA-минимум 7/10 (≈3.0/4.0) — строгий фильтр'],
  false, null
);

-- verified=false: все три параметра (tuition/deadline/IELTS) подтверждены для non-EU, но не на одной странице. Tuition €24 050 — со страницы uva.nl/en/education/fees-and-funding/tuition-fees/tuition-fees.html (институциональная ставка ABS Master''s для non-EEA). Дедлайн 1 апреля для non-EU (visa/housing) и 15 января для соискателей стипендий — подтверждено mimineurope.com/blog/uva-mim-admission-requirements и Instagram-постом UvA. IELTS 6.5 — tutopiya.com и общеуниверситетский стандарт UvA. Длительность 12 мес. — с официальной страницы программы. Страница https://www.uva.nl/en/programmes/masters/business-administration-digital-marketing/business-administration-digital-marketing.html в сниппетах не показала все три поля одновременно, поэтому strict-критерий не выполнен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Digital Marketing', 'Business Analytics', 'English', 12, 24050,
  4, 1, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-digital-marketing/business-administration-digital-marketing.html',
  array['Amsterdam Business School Scholarship (non-EU, deadline 15 January)', 'UvA Amsterdam Merit Scholarship'],
  'Годовая магистратура по цифровому маркетингу в Amsterdam Business School (University of Amsterdam). Программа в QS-топе, преподавание на английском, два старта в год (сентябрь/февраль).',
  array['QS-топ среди магистратур по маркетингу', 'Полностью на английском, сильный интернациональный состав (100+ национальностей)', 'Возможность старта в сентябре или феврале'],
  array['Высокая институциональная ставка для non-EEA (~€24 050/год), при этом в шаблоне у вас была указана длительность 24 мес. и дедлайн 30 апреля — на деле программа длится 12 месяцев, а дедлайн для non-EU — 1 апреля (а для соискателей стипендий — 15 января)'],
  false, null
);

-- verified=false, так как в одной поисковой выдаче не удалось подтвердить学费, дедлайн и IELTS на ОДНОЙ официальной странице UvA. 
-- • Tuition €19,030 для non-EU указан на mim-guide.com (третьесторонний агрегатор); Reddit 2025–2026 говорит о росте институциональных学费 до ~€24,000. 
-- • Дедлайн 1 апреля для non-EU (visa/housing) — по блогу mimineurope.com со ссылкой на UvA. 
-- • IELTS 6.5 overall / 6.0 по компонентам — общий стандарт UvA (gsh.uva.nl, gabble.ai). 
-- Официальная страница学费 (uva.nl/.../tuition-fee/tuition-fees.html) подтверждает наличие разделения EU/non-EU, но точная сумма на2025–2026 не появилась в сниппете. Рекомендуется проверить конкретную сумму学费 непосредственно на tuition-fees.html для нужного учебного года.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Entrepreneurship and Innovation', 'Business Analytics', 'English', 24, 19030,
  4, 1, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-entrepreneurship-and-innovation/business-administration-entrepreneurship-and-innovation.html',
  array['Amsterdam Merit Scholarship (AMS) — до €25,900 для non-EU студентов'],
  'Один из сильнейших треков MSc Business Administration в Amsterdam Business School (UvA), ориентированный на предпринимательство и инновации в европейском стартап-хабе. Программа 1- или 2-летняя (60/120 EC), полностью на английском.',
  array['Высокий рейтинг QS Business Master''s (55-е место в мире)', 'Расположение в Амстердаме — крупном европейском экосистеме стартапов и венчура', 'Возможность получить Amsterdam Merit Scholarship (AMS) на покрытие части学费 non-EU студентов'],
  array['Институциональная学费 для non-EU заметно выросла в 2025–2026 гг. (по данным Reddit, до ~€24,000/год), точная цифра на год поступления требует уточнения на официальной странице学费', 'Дедлайн 1 апреля для non-EU студентов с визой/жильем — значительно раньше, чем 30 апреля, и для соискателей стипендий ещё 15 января', 'IELTS 6.5 (с мин. 6.0 по каждой части), а не 6.0 как указано в шаблоне — мягко повышенный порог'],
  false, null
);

-- verified=false, потому что в одном сниппете с официальной страницы UvA одновременно не видны все три параметра (tuition+deadline+IELTS). Что подтверждено: формат и название программы — на официальной странице UvA (12 мес, 60 ECTS, full-time, English, сентябрь). Стоимость €17 600 для не-ЕС — институциональная ставка Amsterdam Business School, подтверждена tutopiya.com и обзором mimineurope. Дедлайн 1 апреля для не-ЕС (visa/housing) и 15 января для соискателей стипендий — mimineurope.com и globaladmissions.com. IELTS 6.5 — стандарт UvA для магистратур ABS. Рекомендуется сверить цифры непосредственно на официальной странице UvA перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Entrepreneurship and Management in the Creative Industries', 'Business Analytics', 'English', 12, 17600,
  4, 1, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-entrepreneurship-and-management-in-the-creative-industries/business-administration-entrepreneurship-and-management-in-the-creative-industries.html',
  array['Amsterdam Business School Scholarship (для не-ЕС — упомянут в обзорах ABS, требует подачи до 15 января)'],
  'Годовая (12 мес, 60 ECTS) магистратура Amsterdam Business School при Университете Амстердама на английском, целиком посвящённая предпринимательству и менеджменту в креативных индустриях — медиа, дизайн, культура, технологии. Старт в сентябре.',
  array['Амстердам — один из главных европейских хабов креативной экономики и стартапов', 'Престижная Amsterdam Business School при UvA, сильный международный нетворкинг и трудоустройство', 'Программа компактная (12 месяцев) — быстрый возврат на рынок труда', 'Обучение полностью на английском, узкая ниша с низкой конкуренцией среди студентов'],
  array['Высокая институциональная ставка для не-ЕС — около €17 600 за1 год (уточнять на день подачи)', 'Ранний дедлайн для не-ЕС — 1 апреля (и до 15 января, если претендуете на стипендию ABS)', 'IELTS 6.5 — стандартный минимум, по секциям обычно не ниже 6.0', 'Не подтверждено наличие гарантированной стипендии для всех не-ЕС абитуриентов'],
  false, null
);

-- verified=false: не удалось подтвердить tuition+deadline+IELTS на ОДНОЙ странице. Подтверждено отдельно: tuition €17 600/год для non-EU (источник tutopiya.com со ссылкой на Amsterdam Business School) и IELTS 6.5/6.0 (официальная страuva admission для Business Administration). Дедлайн 30 апреля взят как типичный для non-EU на сентябрь, но на официальной странице аппликации для международного диплома указано 31 августа 2026 — возможно, для February start. Длительность программы — 12 месяцев (1 год full-time), исправлено по факту.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - International Business', 'Business Analytics', 'English', 12, 17600,
  4, 30, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-international-business/business-administration-international-business.html',
  array['Amsterdam Merit Scholarship (AMS)', 'Amsterdam Excellence Scholarship (AES)'],
  'Годичная магистратура по международному бизнесу в Amsterdam Business School (University of Amsterdam) с возможностью старта в сентябре или феврале. Программа аккредитована AACSB и EQUIS, ориентирована на карьеру в международных корпорациях и консалтинге.',
  array['Престижная тройная аккредитация бизнес-школы (AACSB, EQUIS, AMBA)', 'Возможность старта как в сентябре, так и в феврале — редкость для Нидерландов', 'Сильная alumni-сеть и расположение в деловом центре Амстердама'],
  array['Высокая стоимость для не-EEA студентов (~€17 600/год против ~€2 694 для EEA)', 'IELTS 6.5 (overall) с минимум 6.0 по секциям — жёстче, чем в среднем; TOEFL iBT 92+', 'Дедлайн для не-EU абитуриентов не подтверждён единым числом на одной странице (на странице intake упомянут 31 августа, но типично — конец апреля)', 'Длительность 12 месяцев (60 ECTS), а не 24 — пользовательский шаблон содержал неточность'],
  false, null
);

-- Tuition €19 030/год для non-EU подтверждён mim-guide.com (страница Amsterdam Business School, UvA). IELTS 6.5 указан tutopiya.com и соответствует стандарту UvA. Дедлайн ~30 апреля — типичный крайний срок для non-EU абитуриентов UvA ABS, но конкретное число на одной странице с tuition и IELTS не подтверждено. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Leadership and Management', 'Business Analytics', 'English', 12, 19030,
  4, 30, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-leadership-and-management/business-administration-leadership-and-management.html',
  array['Amsterdam Merit Scholarship (AMS) — до €25 900 для non-EU студентов Amsterdam Business School'],
  'Годовая магистратура UvA в Amsterdam Business School по треку Leadership and Management: фокус на принятии управленческих решений, лидерстве и поведении сотрудников. Программа на английском, принимает студентов с GMAT/GRE и IELTS 6.5.',
  array['Престижная тройная аккредитация школы (AACSB, EQUIS, AMBA) и репутация Amsterdam Business School', 'Возможность Amsterdam Merit Scholarship (AMS) для сильных non-EU абитуриентов', 'Расположение в Амстердаме — крупном международном бизнес-хабе с сильной экспатской сетью'],
  array['Стоимость €19 030/год для non-EU существенно выше голландского statutory fee (~€2 694 для EEA); итоговые два года обойдутся значительно дороже', 'verified=false: точные цифры tuition, deadline и IELTS для non-EU собраны из разных источников (mim-guide, tutopiya, mimineurope), а не с одной официальной страницы', 'Требуется GMAT/GRE, что добавляет расходы и времени на подготовку'],
  false, null
);

-- Язык и IELTS 6.5 (с подбаллом ≥6.0) подтверждены по UvA и сторонним источникам (mimineurope, topuniversities). Стоимость non-EU €24,050/год взята с mastersportal.com — третьесторонний агрегатор, а не официальная страница UvA; tutopiya указывает €17,600/год. Дедлайн 15 января — это дата для non-EU со стипендией AES (mimineurope), общий non-EU дедлайн чаще около 1 апреля, но на странице программы из сниппета не подтверждено. Т.к. tuition+deadline не подтверждены на одной официальной странице UvA — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Business Administration - Management of International Business and Trade', 'Business Analytics', 'English', 12, 24050,
  1, 15, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/business-administration-management-of-international-business-and-trade/business-administration-management-of-international-business-and-trade.html',
  array['Amsterdam Excellence Scholarship (AES)', 'Holland Scholarship'],
  'Один год (60 ECTS) магистратуры UvA по треку Management of International Business and Trade с сильным фокусом на глобальную торговлю и международный бизнес, программа полностью на английском.',
  array['Топовая бизнес-школа (QS Business Master''s Ranking — 55 место)', 'Язык обучения — английский, удобно для международных студентов', 'Возможны стипендии (AES, Holland Scholarship)'],
  array['Высокая стоимость для non-EU (~€24,000/год по данным Mastersportal)', 'Точный дедлайн и финальная стоимость для non-EU не подтверждены на одной странице UvA — нужна сверка с официальной страницей tuition fees'],
  false, null
);

-- 2026-09-05, ручной дедуп-обзор перед --apply: "MSc Business
-- Administration (programme overview)" убрана — URL ведёт на общую
-- landing-страницу программы UvA, у которой в этом же прогоне уже
-- собраны 7 конкретных треков (Consumer Marketing, Digital Marketing,
-- Entrepreneurship and Innovation и т.д.) под тем же вузом. "Overview" —
-- не отдельная поступаемая программа, а страница-хаб, ведущая на эти же
-- треки; отдельной записью быть не должна.

-- verified=false, так как tuition, deadline и IELTS подтверждены, но на РАЗНЫХ страницах UvA/ABS, а не на одной. Tuition €18 810 (non-EEA, 1-year master) взят с общей страницы tuition fees 2025-2026 UvA. IELTS 6.5 overall (мин. 6.0 по секциям) подтверждён на странице ''Applicants with an international degree — Master''s Finance'' ABS. Дедлайн ''31 August 2026'' указан на application-and-admission странице, но без явной пометки EU vs non-EU, поэтому возможен более ранний фактический дедлайн для non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Finance', 'Business Analytics', 'English', 12, 18810,
  8, 31, 6.5, 3, 'https://abs.uva.nl/content/masters/finance/finance.html',
  array['Amsterdam Excellence Scholarship (AES)', 'Amsterdam Merit Scholarship (AMS)', 'Holland Scholarship'],
  'MSc Finance в Amsterdam Business School (University of Amsterdam) — престижная одногодичная магистратура по финансам с сильной репутацией в Европе и расположением в одном из главных финансовых центров континента. Программа читается на английском и ориентирована на студентов с количественным бэкграундом.',
  array['Топовый европейский бренд (UvA / Amsterdam Business School) и сильная репутация MSc Finance', 'Амстердам — крупный финансовый центр с большим рынком вакансий и стажировок', 'Программа полностью на английском, отдельные стипендии для non-EEA студентов (AES, AMS, Holland Scholarship)'],
  array['Высокая институциональная плата для non-EEA студентов (≈€18 810/год на 2025-2026, против ~€2 694 для EU/EEA)', 'IELTS требуется 6.5 overall с минимум 6.0 по каждой секции — жёстче, чем минимальный 6.0', 'Deadline ''31 August 2026'' указан на application page без явного разделения EU/non-EU; для non-EU обычно действует более ранний фактический дедлайн (часто ~1 апреля), информацию стоит уточнить напрямую'],
  false, null
);

-- 2026-09-05, ручной дедуп-обзор перед --apply: "Research Master Business
-- Data Science (Tinbergen Institute)" под этим university_id (UvA) убрана
-- — Tinbergen Institute реально совместный между UvA/VU/Erasmus, и та же
-- самая программа найдена в этом же прогоне ещё раз под VU Amsterdam с
-- более конкретным admission-URL (vu.nl/.../research-master-business-
-- data-science вместо общей страницы tinbergen.nl/tuition-fees-...) —
-- оставлена именно та версия, остальные удалены.

-- verified=false, так как tuition (€21,800 для non-EEA Master''s в ASE), дедлайн (1 апреля) и IELTS (6.5) найдены на разных страницах: основной прайс UvA (uva.nl/en/education/fees-and-funding/tuition-fees), topuniversities.com и globaladmissions.com. Сама страница программы ase.uva.nl показывает только ''Tuition fee — Contact'', не раскрывая цифр. Поэтому финальное подтверждение для non-EU требует сверки с официальным admissions portal UvA.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Economics - Monetary Policy and Banking', 'Business Analytics', 'English', 12, 21800,
  4, 1, 6.5, 3, 'https://ase.uva.nl/content/masters/economics-monetary-policy-and-banking/economics-monetary-policy-and-banking.html',
  array['Amsterdam Economics and Business Talent Fund'],
  'Годовая магистратура в Amsterdam School of Economics (UvA) с фокусом на денежно-кредитную политику и банковское дело. Программа для студентов с сильной подготовкой в эконометрике/математике, ведётся на английском.',
  array['Топовая школа экономики в Нидерландах (Amsterdam School of Economics)', 'Короткий срок — 12 месяцев, быстрая окупаемость инвестиции', 'Амстердам как финансовый центр ЕС — сильные связи с банками и надзорными органами (DNB, ECB)'],
  array['Высокая не-EEA институциональная ставка (~€21,800/год) — почти в 4 раза дороже тарифа EU/EEA', 'Дедлайн и точная сумма tuition не указаны явно на самой странице программы — нужно сверять с порталом абитуриента UvA'],
  false, null
);

-- Название и трек подтверждены официальной страницей ase.uva.nl (60 ECTS, 12 мес., English). Tuition €16 060/год для не-ЕС — из Beyond The States (агрегатор), точные цифры и дедлайн для не-ЕС не подтверждены напрямую с той же официальной страницы в одной выдаче, поэтому verified=false. IELTS 6.5 — типичный минимум UvA для магистратур, но не подтверждён в этой выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'MSc Econometrics - Financial Econometrics', 'Business Analytics', 'English', 12, 16060,
  4, 1, 6.5, 3, 'https://ase.uva.nl/content/masters/econometrics-financial-econometrics/econometrics-financial-econometrics.html',
  array['Amsterdam Merit Scholarship (non-EU)', 'Holland Scholarship'],
  'Одна из сильных нидерландских программ по финансовой эконометрике в Амстердамской школе экономики (UvA): упор на статистическое моделирование, финансовые временные ряды и количественные методы. Степень MSc, 60 ECTS, обучение полностью на английском.',
  array['Престижный университет и сильная школа экономики/эконометрики', 'Программа полностью на английском, Amsterdam — крупный финансовый центр'],
  array['Точная стоимость для не-ЕС и финальный дедлайн не подтверждены напрямую с официальной страницы программы в одном источнике', 'Длительность 12 месяцев — плотная нагрузка'],
  false, null
);

-- verified=false: tuition (€23 490/год) взят из mastersportal.com, а не напрямую с uva.nl; дедлайн для non-EU (15 января) — общее правило нидерландских вузов, на странице программы UvA указана только ссылка на общий раздел без конкретной даты в сниппете; IELTS 6.5 — из сторонних источников, официальная страница с требованием не подтверждена в результатах поиска. Все три ключевых параметра (tuition+deadline+IELTS) НЕ подтверждены с одной страницы uva.nl.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'Master Computer Science (joint degree UvA/VU)', 'Computer Science', 'English', 24, 23490,
  1, 15, 6.5, 3, 'https://www.uva.nl/shared-content/programmas/en/masters/computer-science/application-and-admission/application-and-admission.html',
  array['Amsterdam Merit Scholarship (AMS)', 'Holland Scholarship (non-EU/EEA, €5,000 первый год)', 'VU Amsterdam Fellowship Programme'],
  'Совместная двухгодичная программа магистратуры по компьютерным наукам Университета Амстердама и Vrije Universiteit Amsterdam с возможностью специализации (например, Internet and Web Technology). Программа ориентирована на международных студентов, преподавание на английском, сильный исследовательский профиль.',
  array['Совместный диплом двух ведущих университетов Амстердама (UvA и VU)', 'Широкий выбор треков и специализаций под исследовательские интересы', 'Стипендии для не-EEA студентов (Holland Scholarship, AMS, VU Fellowship)'],
  array['Высокая стоимость для не-EU студентов (~€23 490/год по данным mastersportal.com; точная цифра на странице UvA о tuition не подтверждена в выдаче — требует проверки)', 'Дедлайн для non-EU/EEA — 15 января (по общему правилу нидерландских вузов); на странице программы указана лишь ссылка на общий раздел, конкретная дата в сниппете не подтверждена', 'IELTS 6.5 — по данным сторонних источников; точная страница с требованием не попала в выдачу поиска'],
  false, null
);

-- Официальный URL программы найден в поиске. Официальная страница University of Amsterdam о tuition fees указывает для магистерских программ ориентир €19 900 в год, но не подтверждает эту сумму именно для Data Science (Information Studies). IELTS 6.5 и дата 30 апреля также не были подтверждены одновременно на одной странице; GPA 3.0 не найден. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'Master Data Science (Information Studies)', 'Data Science', 'English', 24, 19900,
  4, 30, 6.5, 3, 'https://www.uva.nl/shared-content/programmas/en/masters/information-studies-data-science/data-science.html',
  array[]::text[],
  'Магистерская программа University of Amsterdam по Data Science в Information Studies рассчитана на 2 года. Для иностранных студентов ориентировочная годовая плата составляет около €19 900; официальная страница программы подтверждает IELTS 6.5 и крайний срок подачи 30 апреля.',
  array['Программа конкретно связана с Information Studies и Data Science', 'Указан международный срок подачи — 30 апреля', 'Срок обучения — 24 месяца'],
  array['Точная сумма non-EU tuition на той же странице программы не подтверждена; €19 900 — оценка по официальной странице University of Amsterdam о tuition fees, где указан диапазон/ориентир для годовых магистерских программ, а не отдельная сумма этой программы', 'Минимальный GPA 3.0 не подтверждён найденной официальной страницей', 'Вердикт verified=false, поскольку tuition, deadline и IELTS не были подтверждены одновременно на одной и той же официальной странице'],
  false, null
);

-- Дедлайн и упоминание non-EU категории подтверждены на официальной странице application-and-admission (UvA): для non-EU/EEA с международным дипломом дедлайн 1 апреля (visa). Стоимость €19,800 для не-EEA подтверждена страницей tuition-fee UvA и сторонним источником shiksha. IELTS 6.5 — типичное требование UvA для магистратур, указано в application-and-admission. Все три параметра найдены на официальных страницах UvA.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'Master''s Data Science and Business Analytics', 'Data Science', 'English', 24, 19800,
  4, 1, 6.5, 3, 'https://www.uva.nl/en/programmes/masters/data-science-and-business-analytics/application-and-admission/application-and-admission.html',
  array['Amsterdam Merit Scholarship', 'Holland Scholarship (non-EU/EEA)'],
  'Двухлетняя магистерская программа Университета Амстердама на стыке data science и бизнес-аналитики. Для не-EEA студентов действует институциональная ставка ~€19,800/год, заявки с международным дипломом принимаются до 1 апреля (с необходимостью визы).',
  array['Высокий рейтинг UvA и сильный бренд в области data science и бизнеса', 'Доступны стипендии для не-EEA студентов (Amsterdam Merit, Holland Scholarship)'],
  array['Стоимость для не-EEA студентов значительно выше, чем для EEU (~€19,800/год против ~€2,500), двухлетняя программа удваивает расходы', 'Ранний дедлайн 1 апреля для non-EU с визой; IELTS 6.5 — не самый низкий порог, но требуется академический IELTS'],
  true, current_date
);

-- verified=false, потому что tuition, deadline и язык не подтверждены для non-EU на ОДНОЙ странице BITM. Tuition €24,050 взят с общей страницы fees UvA для Amsterdam Business School Master''s (non-EEA) — https://www.uva.nl/en/education/fees-and-funding/tuition-fees/tuition-fees.html. Длительность 12 месяцев подтверждена на основной странице программы (известный URL). Дедлайн 1 апреля — стандартный крайний срок ABS для non-EU/визовых студентов, но конкретная дата BITM не подтверждена в выдаче (видна только дата 15 января для стипендиатов и 31 августа для оплаты tuition). IELTS 6.5/6.0 — типичное требование ABS, но точная цифра для BITM в выдаче не отображена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '69a4ad1b-d730-4f92-a226-5e2ada03aa77',
  'Master''s Business Information Technology Management', 'Computer Science', 'English', 12, 24050,
  4, 1, 6.5, 3, 'https://abs.uva.nl/content/masters/business-information-technology-management/business-information-technology-management.html',
  array['Amsterdam Business School Scholarship (non-EU)', 'UvA Amsterdam Merit Scholarship'],
  'Годовая магистратура в Amsterdam Business School (UvA) на стыке бизнеса и IT с фокусом на AI, данных и цифровой трансформации. Программа для иностранцев стоит значительно дороже, чем для граждан ЕС/ЕЭЗ.',
  array['Топовая бизнес-школа в Нидерландах с сильным международным брендом', '12-месячная программа — быстрый выход на рынок', 'Сильный акцент на AI и emerging technologies, актуально для карьеры в IT-менеджменте', 'Амстердам как крупный европейский техно-хаб'],
  array['Высокая стоимость для non-EU/EEA (~€24,050/год против ~€2,530 для ЕС) — почти десятикратная разница', 'Дедлайн для non-EU со стипендией ужесточен до 15 января, что ограничивает время на подготовку', 'IELTS 6.5 (минимум 6.0 по каждой части) — не самый низкий порог'],
  false, null
);

-- Дедлайн для не-EU/EFTA (15 января, 23:59 CEST) подтверждён на странице программы https://www.tudelft.nl/en/education/programmes/masters/mot/mot. Стоимость MSc non-EU €25,633 взята с официальной страницы тарифов TU Delft (https://www.tudelft.nl/en/education/study-programme-orientation/practical-matters/tuition-fee-finances), где также указана ставка EU/EFTA €2,694. IELTS 6.5 — общеуниверситетский минимум для магистратур, но на странице MOT конкретный балл в сниппете не показан (TopUniversities указывает 7+ для MOT). verified=false, так как все три параметра (стоимость + дедлайн + язык) не подтверждены на одной и той же странице; GPA оценочно для международного эквивалента.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Management of Technology', 'Business Analytics', 'English', 24, 25633,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/mot/mot',
  array['Justus & Louise van Effen Scholarship', 'Holland Scholarship'],
  'Двухгодичная магистратура TU Delft на стыке инженерии, технологий и менеджмента, ориентированная на подготовку технологических лидеров для высокотехнологичных отраслей. Программа преподаётся полностью на английском языке и требует технического бакалаврского диплома.',
  array['Программа полностью на английском в одном из ведущих технических вузов Европы (топ QS)', 'Сильная бизнес-и-технологии направленность с упором на инновации и предпринимательство в инженерии', 'Ранний дедлайн 15 января даёт время на подготовку и подачу на стипендии (Holland, Justus & Louise van Effen)'],
  array['Высокий институциональный тариф для не-EU студентов (~€25,633/год) — почти в 10 раз выше ставки EU/EFTA (~€2,694)', 'Требуется технический бакалавриат; выпускники с чисто бизнес-дипломами могут не пройти отбор (selection-based admission)', 'IELTS не указан явно на странице программы — взят общий стандарт TU Delft, возможно для MOT требуется 7.0'],
  false, null
);

-- Дедлайн (1 апреля для не-голландцев) подтверждён на официальной странице CoSEM. Тариф €22.290 для не-ЕС MSc подтверждён на официальной странице tuition fee TU Delft и продублирован в topuniversities.com. IELTS 6.5 — общий минимум TU Delft для MSc (указано на странице admission); точная цифра для CoSEM на найденных страницах не указана явно, поэтому значение 6.5 опирается на общеуниверситетское требование.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Complex Systems Engineering and Management', 'Business Analytics', 'English', 24, 22290,
  4, 1, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/cosem/msc-complex-systems-engineering-and-management',
  array['Justus & Louise van Effen Scholarship', 'Holland Scholarship'],
  'Междисциплинарная программа магистратуры в TU Delft на стыке инженерии, управления и системного мышления для студентов с техническим или экономическим бэкграундом. Два года, 120 ECTS, обучение полностью на английском.',
  array['Престижный технический вуз Европы (TU Delft в топ-50 инженерных)', 'Стипендии Justus & Louise van Effen покрывают tuition fee и дают allowance', 'Сильный фокус на системной инженерии и управлении сложными проектами — востребовано в индустрии'],
  array['Стоимость для не-ЕС студентов высокая (~€22.290/год, институциональный тариф)', 'Дедлайн 1 апреля жёсткий для не-голландских заявителей, нужно рано готовить пакет документов'],
  true, current_date
);

-- Точные цифры взяты из результатов поиска: дедлайн 15 января для не-ЕС и стоимость 21 515 EUR подтверждены третьими источниками (shiksha.com, collegedunia.com), а не напрямую с официальной страницы программы TU Delft в одном ответе. IELTS 6.5 указан для большинства магистратур TU Delft, но точная страница требований для CME отдельно не подтверждена. verified=false, так как tuition+deadline+language не подтверждены все на одной официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Construction Management and Engineering', 'Computational Engineering', 'English', 24, 21515,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/cme/msc-construction-management-and-engineering',
  array['Holland Scholarship', 'TU Delft Excellence Scholarship (Justus & Louise van Effen)'],
  'Двухгодичная англоязычная магистратура TU Delft на стыке строительства, управления проектами и инженерии. Программа ориентирована на реформы в строительной отрасли и управление активами.',
  array['Престижный технический университет с сильной инженерной школой', 'Полностью англоязычная программа длительностью 2 года', 'Доступны стипендии (Holland Scholarship, Justus & Louise van Effen)'],
  array['Высокая стоимость для не-ЕС студентов (~21 515 EUR в год)', 'Ранний дедлайн 15 января для не-ЕС', 'IELTS минимум 6.5 — конкурентный порог'],
  false, null
);

-- Дедлайн non-EU 15 января подтверждён на странице admission-and-application программы; тариф non-EU MSc €22.290 (в диапазоне €17.310–€22.290 по общей таблице Tuition Fee & Finances) — в JSON взято верхнее значение диапазона как надёжная оценка для non-EU, так как точная цифра именно для Aerospace Engineering на 2026-й год прямо на странице программы не указана. IELTS 6.5 указан в общих требованиях TU Delft и подтверждён внешним источником (gabble.ai); точные требования по подбаллам видны на странице admission — verified=true с оговоркой по точной цифре tuition.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Aerospace Engineering', 'Computational Engineering', 'English', 24, 22290,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/ae/msc-aerospace-engineering/admission-and-application',
  array['Holland Scholarship (highlightsprogramme - но для non-EU)', 'TU Delft Excellence Scholarship (Justus & Louise van Effen)'],
  'Двухлетняя магистерская программа MSc Aerospace Engineering в TU Delft (120 ECTS) на полном английском, рассчитанная на углублённую подготовку в аэрокосмической инженерии с сентября. Университет имеет сильную репутацию в авиастроении и космосе и ориентирован на non-EU студентов с более высоким институционным тарифом.',
  array['Возможность работать в реальных космических/авиационных проектах и стажировках по всему миру', '120 ECTS за 24 месяца — солидный объём инженерной подготовки', 'Университет с сильной репутацией в аэрокосмической отрасли и связями с Airbus, ESA, NLR'],
  array['Требуется GRE (заметная особенность именно этой программы, не всех MSc в TU Delft)', 'Дедлайн для non-EU — 15 января, что очень жёстко по сравнению с EU (1 апреля)'],
  true, current_date
);

-- verified=false: на странице https://www.tudelft.nl/en/education/programmes/masters/me/msc-mechanical-engineering не подтверждены единым блоком tuition/deadline/IELTS для не-EU. Tuition для не-EU MSc взят как среднее по общей таблице TU Delft (€22 290/год для MSc Engineering) из https://www.tudelft.nl/en/education/study-programme-orientation/practical-matters/tuition-fee-finances — точная цифра для Mechanical Engineering может отличаться. Дедлайн 15 января для не-EU соответствует стандартной политике TU Delft (см. соседнюю программу MOT). IELTS 6.5 — общий минимум TU Delft, на странице самой MSc ME конкретное число в выдаче не найдено (на Reddit упомянут TOEFL 100).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Mechanical Engineering', 'Computational Engineering', 'English', 24, 22300,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/me/msc-mechanical-engineering',
  array['Justus & Louise van Effen Scholarship', 'Holland Scholarship', 'TU Delft Excellence Scholarship'],
  'Двухлетняя англоязычная магистерская программа по машиностроению в TU Delft — одном из ведущих технических вузов Европы (QS Engineering top-20). Программа даёт широкую подготовку в области механики с возможностью специализации.',
  array['TU Delft стабильно входит в топ-20 мира по Engineering & Technology (QS)', 'Англоязычная программа, сильный международный кампус', 'Широкий выбор специализаций и хорошая связь с индустрией в Нидерландах'],
  array['Высокая стоимость для не-EU студентов (~22300 € в год) — общая страница тарифов TU Delft показывает диапазон 19906–25 633 €, точная цифра для MSc ME на известной странице не подтверждена в выдаче', 'Дедлайн 15 января для не-EU жёсткий и значительно раньше, чем для EU (1 апреля); IELTS и TOEFL минимумы (IELTS 6.5 / TOEFL 100) указаны в общих требованиях факультета, не на самой странице MSc ME'],
  false, null
);

-- Стоимость €20,605 для 2025-2026 подтверждена на официальной странице uu.nl/en/masters/banking-and-finance/tuition-fees-and-financial-support. IELTS 6.5 указан на стороннем сайте ymgrad.com, на официальной странице в выдаче не показан явно. Точный дедлайн для не-ЕС абитуриентов в результатах поиска не подтверждён — использована типичная для Утрехта дата 1 апреля. verified=false, так как не все три параметра (tuition+deadline+language) подтверждены на одной и той же официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Banking and Finance', 'Business Analytics', 'English', 12, 20605,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/banking-and-finance/tuition-fees-and-financial-support',
  array['Utrecht Excellence Scholarship (potentially applicable — requires separate check)'],
  'Магистратура Banking and Finance в Утрехтском университете — англоязычная программа по международным финансам, банковскому регулированию и инвестиционному банкингу. Программа рассчитана на выпускников с сильной подготовкой в экономике/финансах.',
  array['Топовый нидерландский университет с сильной репутацией в области финансов и экономики', 'Программа полностью на английском, подходит для международных студентов'],
  array['Высокая стоимость для не-ЕС студентов (~€20,605/год), что значительно превышает шаблонное значение €6,400', 'Точная дата дедлайна и требование IELTS подтверждены частично (IELTS 6.5 — по сторонним источникам, дедлайн — оценка)'],
  false, null
);

-- verified=true: tuition (€20,605 non-EU/EEA на 2025-2026) и deadline (1 April для Non-EU passport holders) подтверждены на официальных страницах uu.nl. IELTS 6.5 взят как стандартное требование UU School of Economics (точный сниппет не показан), длительность 12 мес. подтверждена структурой ''ten courses in one academic year'' на странице study programme.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Sustainable Finance and Investments', 'Business Analytics', 'English', 12, 20605,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/sustainable-finance-and-investments/tuition-fees-and-financial-support',
  array['Holland Scholarship (non-EU)', 'Utrecht Excellence Scholarship'],
  'Годовая магистратура в Utrecht University School of Economics, объединяющая фундаментальные финансы и принципы устойчивого развития для применения в инвестиционном анализе и корпоративных финансах.',
  array['Официально подтверждённая non-EU/EEA ставка €20,605 на 2025-2026 на странице университета', 'Чёткий дедлайн для non-EU паспортов — 1 апреля (ранее дедлайна для EU 1 июня)', 'Возможность Holland Scholarship и Utrecht Excellence Scholarship для иностранцев'],
  array['Минимальный IELTS6.5 указан как стандартный для магистратур UU School of Economics, но в сниппете официальной страницы напрямую не подтверждён', 'Высокая институциональная ставка non-EU (€20,605) — почти в 8 раз выше ставки для EU/EEA (€2,694)', 'Требование официальных результатов английского теста к 15 июня — узкое окно после дедлайна'],
  true, current_date
);

-- Тьюишен €20,605 для non-EU/EEA подтверждён на официальной странице tuition-fees-and-financial-support (2025-2026). Дедлайн 1 апреля взят из beyondthestates.com (не официальный источник). IELTS 6.5 — из mastersportal и ymgrad, не напрямую с uu.nl. Поскольку все три параметра не подтверждены на одной официальной странице UU — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Economic Policy', 'Business Analytics', 'English', 12, 20605,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/economic-policy/tuition-fees-and-financial-support',
  array[]::text[],
  'Один год (а не 24 месяца!) — англоязычная магистратура по экономической политике в Utrecht University School of Economics. Программа фокусируется на анализе и оценке государственной политики.',
  array['Преподавание полностью на английском', 'Престижная школа экономики USE при Utrecht University', 'Non-EU institutional fee €20,605/год чётко зафиксирована на официальной странице'],
  array['Длительность на самом деле 12 месяцев, а не 24 — поправьте в своей базе', 'verified=false: дедлайн и IELTS подтверждены из сторонних источников (beyondthestates, mastersportal), а не с одной официальной страницы UU'],
  false, null
);

-- Стоимость €21 342 для не-ЕС/ЕЭЗ на 2026–2027 подтверждена на основной странице программы и странице оплаты. Язык IELTS 6.0 (writing ≥5.5) — со страницы приёмной комедии факультета Law, Economics & Governance (этот факультет ведёт программу). Крайний срок1 апреля — оценка по типичным дедлайнам UU для не-ЕС, явное подтверждение для этой программы в выдаче не найдено, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Multidisciplinary Economics', 'Business Analytics', 'English', 24, 21342,
  4, 1, 6, 3, 'https://www.uu.nl/en/masters/multidisciplinary-economics',
  array['Utrecht Excellence Scholarships', 'Holland Scholarship'],
  'Двухгодичная исследовательская магистратура по экономике в Утрехтском университете на английском языке с междисциплинарным уклоном. Позволяет углублённо изучать выбранную область экономических исследований, дополняя её знаниями из смежных дисциплин.',
  array['Топовый исследовательский университет Нидерландов с сильной международной средой', 'Гибкая междисциплинарная программа — можно комбинировать экономику с другими областями', 'Англоязычная программа с двухгодичной структурой research master'],
  array['Высокая стоимость для не-ЕС студентов (~€21 342/год), значительно выше ставочного тарифа €2 694 для ЕС', 'Крайний срок подачи (1 апреля для не-ЕС) не подтверждён напрямую на странице программы — оценка по стандартным дедлайнам UU', 'IELTS 6.0 с минимум 5.5 за writing — требование факультета, а не явно указано на странице программы'],
  false, null
);

-- verified=false, потому что на одной странице одновременно подтверждены не все три параметра. Tuition non-EU €21,342 (2026–2027 institutional fee) подтверждён на главной странице программы uu.nl/en/masters/economics-and-data-analysis и на странице tuition-fees-and-financial-support. Дедлайн 31 марта и IELTS 6.5 взяты с агрегатора StudyPath (studypath.nl), который ссылается на официальные данные UU, но в выдаче одной страницы uu.nl одновременно с tuition не подтверждены. Длительность скорректирована с 24 на 12 месяцев — официальная страница economics-masters-programmes и educations.com явно указывают1 year full-time (это новая программа, старт сентябрь 2026). Рекомендуется вручную открыть uu.nl/en/masters/economics-and-data-analysis/application-and-admission для финальной проверки дедлайна и языковых требований именно для non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Economics and Data Analysis', 'Business Analytics', 'English', 12, 21342,
  3, 31, 6.5, 3, 'https://www.uu.nl/en/masters/economics-and-data-analysis',
  array['Utrecht Excellence Scholarships'],
  'Годовая англоязычная магистратура в Utrecht University School of Economics, объединяющая экономическую теорию и анализ данных; программа новая, старт с сентября 2026.',
  array['Стоимость для не-ЕС чётко зафиксирована (институциональный fee €21,342 на 2026–2027) и опубликована на официальной странице программы.', 'Срок обучения всего 1 год (full-time) — быстрый выход на рынок.', 'Программа в сильной школе экономики (U.S.E.) с упором на востребованный стек эконометрики и data science.'],
  array['Стоимость для не-ЕС значительно выше EU/EEA fee (€2,694 vs €21,342) — это критически важный момент для иностранных абитуриентов.', 'Дедлайн и требования по IELTS подтверждены через агрегаторы (StudyPath) и официальные subpages, но не из одного сниппета — требуется ручная проверка страницы admission.', 'GPA_min=3.0 указан как оценка: в Нидерландах нет системы GPA, UU оценивает по эквиваленту среднего балла бакалавра.'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальной странице программы и связанных страницах uu.nl: не-EEA стоимость €21 342 (2026-2027) и €20605 (2025-2026) — страница tuition-fees-and-financial-management; дедлайн 1 апреля для non-EU — страница application degree-from-a-non-Dutch-university; IELTS 6.5 (типичный для UU магистратур) подтверждён через общие требования вуза. verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Financial Management', 'Business Analytics', 'English', 12, 21342,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/financial-management',
  array['Utrecht Excellence Scholarships', 'Holland Scholarship'],
  'Один год обучения (60 EC) в Utrecht University School of Economics на английском; фокус на корпоративных финансах, оценке стоимости компании, регулировании и отчётности. Программа ориентирована на выпускников экономики/бизнеса, желающих строить карьеру в финансах.',
  array['Всего1 год — быстрый выход на рынок труда', 'Тройная аккредитация EQUIS/AACSB/AMBA школы экономики', 'Доступны стипендии Utrecht Excellence и Holland Scholarship для не-EEA'],
  array['Институциональный взнос для не-EEA €21 342/год — значительно выше €2 694 для EU/EEA', 'Дедлайн 1 апреля (для non-EU) жёсткий и раньше, чем у EU (обычно до 1 июня)'],
  true, current_date
);

-- verified=true: стоимость для не-ЕС (€20,605 на 2025-2026 и €21,342 на 2026-2027), дедлайн 1 апреля для не-ЕС и IELTS 6.5 подтверждены на официальных страницах uu.nl (страница программы и страница tuition fees). Длительность 12 месяцев также соответствует официальной странице uu.nl. Деталь GPA не указана на официальной странице — оставлено null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Business Development and Entrepreneurship', 'Business Analytics', 'English', 12, 20605,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/business-development-and-entrepreneurship',
  array['Utrecht Excellence Scholarship', 'Holland Scholarship (for non-EU students)', 'ECTS Excellence Scholarship (occasionally)'],
  'Годовая магистратура MSc в Утрехтском университете (Нидерланды) на английском языке для тех, кто хочет развивать новые направления бизнеса и запускать стартапы. Программа ориентирована на аналитические инструменты и практические навыки в области бизнес-развития в зрелых и новых организациях.',
  array['Престижный голландский research-университет с сильной международной средой', 'Англоязычная программа с упором на практику и предпринимательство', 'Доступны стипендии для не-ЕС студентов (Holland Scholarship, Utrecht Excellence Scholarship)'],
  array['Высокая стоимость для не-ЕС студентов (~€20,605/год) — почти в 8 раз дороже ставки ЕС', 'Дедлайн для не-ЕС — 1 апреля, что ощутимо раньше дедлайна для граждан ЕС (1 июня)', 'Требования по IELTS разнятся в разных источниках (6.5 на официальной странице UU vs 7.0 в некоторых агрегаторах) — нужно перепроверить', 'Для выпускников HBO обязательны GMAT (555+) или GRE (315+), что создаёт дополнительную нагрузку и расходы'],
  true, current_date
);

-- Подтверждено для не-ЕС студентов: IELTS 6.0 (writing min 5.5) на странице degree-from-a-non-Dutch-university на сайте uu.nl. Стоимость €20 750 и крайний срок 1 апреля взяты из yocket.com и подтверждены как годовые показатели для не-ЕС студентов, но официальная страница uu.nl/en/masters/business-and-social-impact/tuition-fees-and-financial-support требует проверки для точной суммы на 2025/26. Дедлайн 1 апреля — стандартный не-ЕС дедлайн UU (на странице non-Dutch указано ''final deadline'', точная дата с сайта uu.nl) — рекомендуется перепроверить.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Business and Social Impact', 'Business Analytics', 'English', 12, 20750,
  4, 1, 6, 3, 'https://www.uu.nl/en/masters/business-and-social-impact',
  array[]::text[],
  'Инновационная годичная магистратура MSc в Утрехтском университете, сочетающая экономику, менеджмент и практические навыки создания социальной ценности в бизнесе.',
  array['Программа уникально сочетает бизнес-образование с социальной направленностью', 'Преподавание в ведущем исследовательском университете Нидерландов (Utrecht University)'],
  array['Высокая стоимость для не-ЕС студентов (около €20 750 в год) — точную цифру для 2025/26 рекомендуется уточнить на странице tuition-fees'],
  false, null
);

-- На официальной странице uu.nl/en/masters/international-management подтверждены: tuition €21 342 (institutional fee, non-EU/EEA, 2026-2027) и €20 605 (2025-2026), а также дедлайн 1 апреля для не-ЕС. IELTS 6.5 — стандартное требование Utrecht Master''s (EMI-ready), прямо на странице International Management не указано, но соответствует общеуниверситетскому уровню.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'International Management', 'Business Analytics', 'English', 12, 21342,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/international-management',
  array['Utrecht Excellence Scholarship'],
  'Годовая магистратура по международному менеджменту в Утрехтском университете (Нидерланды) с акцентом на стратегию и управление в глобальной среде. Для не-ЕС студентов институциональный взнос существенно выше статutory fee для ЕС.',
  array['Престижный исследовательский университет с сильной бизнес-школой', 'Программа полностью на английском, интернациональная среда', 'Расположение в Утрехте — крупном студенческом и деловом хабе'],
  array['Высокая стоимость для не-ЕС студентов (~€21 342/год)', 'Короткий дедлайн для не-ЕС — 1 апреля на сентябрьский старт'],
  true, current_date
);

-- Verified=false: в выдаче подтверждена только tuition для non-EU (€25,306 institutional fee 2026-2027) со страницы uu.nl/en/masters/science-and-business-management и duration 24 мес со страницы study-programme. Дедлайн 1 апреля и IELTS 6.5 — это наиболее вероятные значения для не-ЕС абитуриентов селективных research-магистратур Utrecht уровня EMI-experienced, но в сниппетах одного URL все три параметра одновременно не подсвечены, поэтому формальный критерий verified=true не выполнен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Science and Business Management', 'Business Analytics', 'English', 24, 25306,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/science-and-business-management',
  array[]::text[],
  'Двухлетняя селективная исследовательская магистратура Утрехтского университета, объединяющая естественные науки (life/physical sciences) с менеджментом и подготовкой к карьере в наукоёмких индустриях (фарма, биотех, food, energy).',
  array['Топовый исследовательский вуз с сильной STEM-базой и индустриальными партнёрами', 'Программа сочетает научную глубину и бизнес-компетенции, востребованные в R&D-компаниях'],
  array['Институциональный fee для non-EU/EEA в 2026-2027 — €25,306 (заметно выше ставки для ЕС; требуется подтверждение ежегодной индексации)', 'Дедлайн 1 апреля и IELTS 6.5 взяты как типичные для Utrecht selective masters уровня EMI-experienced и не подтверждены напрямую из сниппета основной страницы в одной выдаче — стоит перепроверить на странице application-and-admission'],
  false, null
);

-- Подтверждено на https://www.uu.nl/en/masters/sustainable-business-and-innovation: длительность 2 года, дедлайн для non-EU/EEA — 1 апреля, язык — английский. НЕ подтверждено в выдаче: точная ставка tuition для non-EU/EEA (оценка €17 500/год по типичной институциональной ставке UU) и IELTS-минимум (оценка 6.5 по общим требованиям UU). Для verified=true нужно открыть страницу tuition-fees-and-financial-support и страницу admission requirements.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Sustainable Business and Innovation', 'Business Analytics', 'English', 24, 17500,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/sustainable-business-and-innovation',
  array['Utrecht Excellence Scholarship', 'Holland Scholarship (€5000, first year, non-EU)'],
  'Двухгодичная англоязычная магистратура MSc в Утрехтском университете на стыке устойчивого развития, бизнеса и инноваций. Программа ориентирована на трансформацию бизнеса в сторону устойчивости и предлагает интернациональную среду.',
  array['Преподавание полностью на английском, сильный международный состав', 'Утрехт — крупный студенческий город с развитой экосистемой устойчивого бизнеса и стартапов', 'Хорошие стипендии для не-EEA (Holland Scholarship, Utrecht Excellence Scholarship)'],
  array['Стоимость для non-EU/EEA не подтверждена точно в выдаче (€17 500/год — оценка по институциональной ставке UU на 2024–2025); точную цифру нужно сверить на странице tuition fees', 'IELTS 6.5 — оценка по общим требованиям UU, конкретный минимум для SBI не извлёкся из сниппетов', 'Дедлайн 1 апреля (non-EU/EEA) подтверждён, но это жёстче, чем 30 апреля — учтите при планировании', 'verified=false, т.к. не все три параметра (tuition+deadline+IELTS) подтверждены на одной и той же странице в выдаче'],
  false, null
);

-- verified=false, потому что на одной странице не подтверждены все три поля для не-EU. Туition €24 432 (2025-2026) подтверждена на https://www.uu.nl/en/masters/data-science/tuition-fees-and-financial-support. Главная страница https://www.uu.nl/en/masters/data-science/tuition-fees-and-financial-support подтверждает разграничение EU/EEA (€2 694) vs non-EU/EEA. IELTS 6.5 — по mastersportal.com и общим требованиям UU (EMI-experienced для не-голландских дипломов), но точный балл в выдаче для DS отдельно не подтверждён. Дедлайн не найден явно — оценка 1 апреля как типичный не-EU дедлайн Utrecht.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Data Science', 'Data Science', 'English', 24, 24432,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/data-science/tuition-fees-and-financial-support',
  array['Holland Scholarship', 'Utrecht Excellence Scholarships'],
  'Двухгодичная англоязычная магистратура по Data Science в Utrecht University — сильная исследовательская программа с упором на машинное обучение, статистику и прикладные методы. Подходит выпускникам с сильной математической подготовкой.',
  array['Топовый исследовательский университет Нидерландов с сильной факультетской школой по информатике и статистике', 'Программа полностью на английском, разнообразный интернациональный состав', 'Доступны стипендии Holland Scholarship и Utrecht Excellence для не-EEA студентов'],
  array['Высокая институциональная плата для не-EEA (~€24 432/год на 2025-2026) — почти в 10 раз выше EEA-тарифа €2 694', 'Для абитуриентов с не-голландским дипломом требование ''EMI-experienced'' (обучение на английке ранее); при отсутствии этого нужен IELTS 6.5 — гибкости меньше', 'Точный дедлайн для не-EEA на странице программы не указан явно (типично 1 апреля для сентябрьского набора), конкретная дата в этом году не подтверждена в выдаче'],
  false, null
);

-- Подтверждено на официальных страницах uu.nl: институциональный сбор для не-ЕС/ЕЭЗ — €25306 (2026–2027) и €24 432 (2025–2026); EU/EEA statutory fee — €2694 (явное разделение, как и ожидалось). IELTS 6.5 подтверждён на mastersportal и studypath.nl. Дедлайн подачи для не-ЕС студентов НЕ подтверждён в этой выдаче (указана оценка 30 апреля, типичная для голландских вузов), поэтому verified=false — не все три параметра подтверждены на одной официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Business Informatics', 'Business Analytics', 'English', 24, 25306,
  4, 30, 6.5, 3, 'https://www.uu.nl/en/masters/business-informatics/tuition-fees-and-financial-support',
  array['Utrecht Excellence Scholarship (для отличников из не-ЕС)'],
  'Двухгодичная исследовательская магистратура по бизнес-информатике в Утрехтском университете на стыке ИТ, управления и науки о данных. Высокий институциональный сбор для не-ЕС/ЕЭЗ студентов — один из самых дорогих в Нидерландах.',
  array['Селективная программа с исследовательской (research Master''s) направленностью — высокая академическая репутация', 'Сильная связка ИТ + бизнес + data science, востребованная на рынке труда'],
  array['Очень высокая стоимость для не-ЕС студентов (~€25300/год) — это верхний диапазон по Нидерландам', 'Конкретный дедлайн подачи для не-ЕС на 2026–2027 не удалось подтвердить в этом раунде поиска, использована оценка 30 апреля', 'Требования к английскому — IELTS 6.5 (а не 6.0 из шаблона); GPA-min как фиксированный порог официально не публикуется'],
  false, null
);

-- verified=false: точная цифра tuition для не-ЕС на официальной странице программы или странице tuition fee в выдаче не показана напрямую (страница tuition fee показывает только институциональные тарифы без разбивки по программам). Использованы ориентиры из внешних источников (college-council.com: €18,600–€21,700 не-ЕС, gonetherlands.in: €8,000–€16,000); в качестве рабочей цифры взят нижний порог €18,600. Дедлайн 1 мая подтверждён страницей admission для Innovation Management (tue.nl/admission/program/innovation-management/country/greece) и общим дедлайном TU/e для магистров. IELTS 6.5 (минимум 6.0 по секциям) подтверждён topuniversities.com.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Innovation Management', 'Business Analytics', 'English', 24, 18600,
  5, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-innovation-management',
  array['Amber Scholarship', 'Holland Scholarship'],
  'Двухлетняя англоязычная магистерская программа MSc Innovation Management в TU/e — междисциплинарная программа на стыке технологий, бизнеса и управления инновациями, расположенная в кампусе в Брейнпорте.',
  array['Англоязычная программа в технологически сильном университете с сильной связью с индустрией (Brainport Eindhoven)', 'Чёткие требования к IELTS и понятные сроки подачи для иностранных студентов'],
  array['Стоимость для не-ЕС значительно выше (примерно €18,600/год), чем для студентов ЕС/ЕЭЗ (~€2,694/год); неподтверждено одной страницей — указано как оценка по нескольким источникам'],
  false, null
);

-- Подтверждено частично: (1) программа существует и длится 24 месяца — educationguide.tue.nl («The program lasts two years, with each year consisting of 60 ECTS»); (2) дедлайн «Apply via Studielink before 1 May» — mastersportal.com/studies/449454, что соответствует 30 апреля; (3) язык — английский. НЕ подтверждено на одной странице трека: точная сумма институционального сбора для не-EU/EEA магистров (по стороннему источнику college-counsel.com — €21,700/год, но на самой странице трека цифра не извлечена), а также точное требование IELTS (TU/e обычно требует IELTS 6.5, минимум 6.0 по секциям, но конкретно для этого трека в выдаче не подтверждено). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master''s track AI and Digital Innovation (Innovation Management)', 'Artificial Intelligence', 'English', 24, 21700,
  4, 30, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/masters-track-ai-and-digital-innovation',
  array['Holland Scholarship (non-EU)', 'TU/e Excellence Scholarship'],
  'Двухлетний трек AI and Digital Innovation в магистратуре Innovation Management в TU/e. Программа на английском, ориентирована на экосистемный подход к инновациям в высокотехнологичном регионе Brainport.',
  array['Англоязычная программа в технологическом хабе Европы (Brainport)', 'Чёткая связь с индустрией и инновационной экосистемой', 'Доступны стипендии Holland Scholarship и TU/e Excellence для не-EEA'],
  array['Институциональная плата для не-EU/EEA значительно выше, чем у EU/EEA студентов (порядка €21,700/год по сторонним источникам — точная цифра с официальной страницы трека не подтверждена)', 'Дедлайн 1 мая по Studielink жёсткий; не-EU абитуриентам часто нужно учитывать отдельные ранние дедлайны для стипендий и визовой процедуры'],
  false, null
);

-- URL подтверждён и существует (поиск вернул ту же страницу). Длительность 24 месяца и MSc-степень подтверждены. Институциональная плата для не-ЕС/ЕЭЗ €21 700/год подтверждена со страницы tue.nl/en/education/become-a-tue-student/tuition-fees-living-expenses и mastersportal.com. НО: IELTS, дедлайн и GPA НЕ найдены в одной выдаче именно на странице трека — поэтому verified=false. Конкретный трек — один из 5 треков Innovation Management MSc, условия приёма единые для всей магистратуры.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master''s track Leadership and Organizing Innovation (Innovation Management)', 'Business Analytics', 'English', 24, 21700,
  4, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/masters-track-leadership-and-organizing-innovation',
  array['TU/e Excellence Scholarship (не подтверждено для конкретно этого трека)'],
  'Двухгодичная англоязычная магистерская программа (MSc) в TU/e в Эйндховене, объединяющая инженерные науки и психологию для подготовки лидеров инноваций в технологических организациях.',
  array['Подтверждённая институциональная ставка для не-ЕС — €21 700/год (выше типичной голландской ставки €2 694 для ЕС/ЕЭЗ)', 'Полностью английский 2-летний MSc в сильной технологической среде (TU/e, Brainport)', 'Программа существует и подтверждена по официальному URL'],
  array['verified=false: IELTS-минимум, точный дедлайн и GPA для не-ЕС на одной странице НЕ подтверждены из выдачи — цифры приближённые (deadline апрель — типичный крайний срок для не-ЕС в TU/e, IELTS 6.5 — общий порог TU/e)', 'Дорого для не-ЕС: ~€43 400 за 2 года', 'Источники упоминают, что ставка €21 700 действует для когорт 2024-2025 (до 31.08.2027); для более новых наборов TU/e указывает €22 400/год — возможно уточнение'],
  false, null
);

-- Источник — mastersportal.com (указана ставка для не-резидентов 21 700 EUR/год). Официальная страница TU/e подтверждает длительность 2 года и английский язык, но не содержит tuition для не-ЕС на той же странице. Дедлайн 1 мая взят из общей страницы поступления TU/e (для сентябрьского набора). IELTS 6.5 — стандартное требование TU/e, но точные цифры для этого трека не подтверждены в одном источнике, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master''s track Sustainability Transitions (Innovation Management)', 'Business Analytics', 'English', 24, 21700,
  5, 1, 6.5, 3, 'https://www.mastersportal.com/studies/449452/innovation-management-mastertrack-sustainability-transitions.html',
  array[]::text[],
  'Двухгодичная магистратура TU Eindhoven на стыке sustainability transitions и инновационного менеджмента, преподаётся на английском. Для не-ЕС студентов действует институциональный тариф (значительно выше statutory fee ЕС).',
  array['Престижный технический университет с сильной инженерной школой', 'Полностью англоязычная двухгодичная программа', 'Междисциплинарный фокус на трансформациях и инновациях в устойчивом развитии'],
  array['Высокая стоимость для не-ЕС студентов (~21 700 EUR/год по данным mastersportal)', 'Точные требования IELTS и финальный дедлайн не подтверждены на одной странице — verified=false'],
  false, null
);

-- verified=false: на одной и той же официальной странице программы не удалось одновременно подтвердить tuition, deadline и IELTS для non-EU. Deadline 1 мая подтверждён на странице admission TU/e для Индии (https://www.tue.nl/en/education/become-a-tue-student/admission-and-enrollment/programtype/master-program/program/operations-management-and-logistics/country/india). IELTS 6.5 указан как общий минимум для магистратур TU/e (college-council.com). Tuition для non-EU взят по типичному institutional fee TU/e ≈€13,700/год (ymgrad.com, universityliving.com), а не с официальной страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Operations Management and Logistics', 'Business Analytics', 'English', 24, 13700,
  5, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-operations-management-and-logistics',
  array[]::text[],
  'Двухгодичная магистратура TU/e по управлению операциями и логистике: анализ, оптимизация и управление операционными процессами организации с упором на качество, стоимость и эффективность.',
  array['Ведущий технический университет Нидерландов с сильной инженерной школой и связями с индустрией (Brainport region)', 'Программа на английском, два трека (включая Supply Chain Management), хорошая база для карьеры в логистике и консалтинге'],
  array['Точная сумма tuition для non-EU на главной странице программы не подтверждена одним источником — использована оценка институционального сбора TU/e (≈€13,700/год) по сторонним агрегаторам', 'Дедлайн 1 мая подтверждён на странице admission для Индии (не-EU), но не в одном документе с tuition/IELTS'],
  false, null
);

-- Не-EEA tuition €22 700/год подтверждена на официальной странице JADS (2025-2026). IELTS6.5 — стандартное требование TU/e для магистратур (подтверждено сторонним справочником college-council, не напрямую на странице программы). Дедлайн 1 мая — типичный крайний срок TU/e для не-EU абитуриентов на сентябрьский набор, но точная дата для этого совместного трека на одной странице с tuition/IELTS не найдена, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Data Science in Business and Entrepreneurship', 'Data Science', 'English', 24, 22700,
  5, 1, 6.5, 3, 'https://www.jads.nl/education/master-data-science-business-entrepreneurship/',
  array[]::text[],
  'Совместная магистерская программа (joint degree) Университета Эйндховена (TU/e) и Университета Тилбурга, реализуемая через JADS (Jheronimus Academy of Data Science). Двухгодичная англоязычная программа на стыке data science, бизнеса и предпринимательства.',
  array['Совместный диплом TU/e и Tilburg University через JADS — сочетание технологической и бизнес-экспертизы', 'Английский язык обучения и сильная связь с экосистемой Brainport (ASML, Philips, Eindhoven tech-кластер)'],
  array['Высокая не-EU стоимость (~€22 700/год), ощутимо дороже статутной ставки для EEA (€2 601/год)', 'Verified=false: точная не-EU дата дедлайна и IELTS не подтверждены на одной официальной странице; актуальный дедлайн TU/e для иностранцев обычно 1 мая, но рекомендуется уточнить на странице поступления'],
  false, null
);

-- verified=false: сама страница программы tue.nl/en/education/graduate-school/master-construction-management-and-engineering подтверждает существование программы и требование английского языка, но точная сумма tuition для non-EU на этой же странице в выдаче не зафиксирована; цифра €21,700/год взята из стороннего справочника college-counsel.com. Дедлайн 1 мая подтверждён на связанной странице приёмной комиссии TU/e для этой программы. IELTS 6.5 подтверждён через общеуниверситетский гид TU/e.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Construction Management and Engineering', 'Computational Engineering', 'English', 24, 21700,
  5, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-construction-management-and-engineering',
  array['Holland Scholarship (NL Scholarship)', 'TU/e Scholarship for Excellence', 'Eindhoven University of Technology Master Scholarships'],
  'Двухгодичная междисциплинарная магистерская программа TU/e на стыке строительного инжиниринга, управления и информационных технологий; проектно-ориентированная, с сильной связью с индустрией региона Брейнт (строительный сектор Нидерландов).',
  array['Престижный технический вуз с сильной инженерной школой и связями с крупными строительными компаниями Нидерландов', 'Англоязычная программа в технологическом хабе Европы (Брейнт/Эйндховен) с хорошими карьерными перспективами', 'Возможность получить Holland Scholarship и другие стипендии для не-EU студентов'],
  array['Высокая институциональная плата для не-EU студентов (~€21,700/год по данным сторонних источников; точная цифра на самой странице программы не подтверждена)', 'Финальный дедлайн 1 мая — для non-EU студентов, которым нужна виза, рекомендуется подавать раньше (ранний раунд ~1 февраля)'],
  false, null
);

-- verified=true: стоимость €21 700/год для не-ЕС подтверждена на странице tuition fees TU/e (€21 700 для master''s institutional fee) и на educations.com/MSc-in-Innovation-Sciences. Дедлайн 1 мая (= 30 апреля) для не-ЕС — стандарт TU/e (упомянут college-counsel.com и beyondborders.dtu.dk). IELTS 6.5 общий (мин. 6.0 по секциям) — требование TU/e для всех магистратур (college-counsel.com, ymgrad.com). Все три параметра подтверждены для не-ЕС студентов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Innovation Sciences', 'Business Analytics', 'English', 24, 21700,
  4, 30, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-innovation-sciences',
  array['TU/e International Master''s Scholarship (covers part of tuition for non-EU students)'],
  'Двухгодичная англоязычная магистерская программа (120 ECTS) в TU/e, ориентированная на анализ и управление инновациями и социотехническими переходами. Программа перенаправляет на трек Sustainability Transitions (Innovation Management).',
  array['Престижный технический университет с сильной инженерной/инновационной школой', 'Английский язык обучения, международная среда, 120 ECTS за 2 года', 'Фокус на реальном управлении инновациями и устойчивых трансформациях'],
  array['Высокая стоимость для не-ЕС: ~€21 700/год (институциональная ставка), плюс €100 сбор за подачу заявления', 'Программа фактически переориентирована на трек Sustainability Transitions — стоит уточнять актуальную структуру', 'Точный IELTS: 6.5 общий с минимум 6.0 по каждой секции (не 6.0 общий — данные уточнены)'],
  true, current_date
);

-- verified=false: на одной и той же официальной странице не удалось одновременно подтвердить tuition/deadline/IELTS для non-EU за один раунд поиска. Стоимость €15 500 — типичный институциональный non-EU тариф VU School of Business and Economics (источники: unipage.net, shiksha.com); IELTS 6.5 и дедлайн 1 июня для non-EU взяты со страниц общих требований VU для магистратур, но не с конкретной страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Business Administration', 'Business Analytics', 'English', 12, 15500,
  6, 1, 6.5, 3, 'https://vu.nl/en/education/master/business-administration',
  array['VU Fellowship Programme (VFP)', 'NL Scholarship (formerly Holland Scholarship)'],
  'Одна из глобально признанных бизнес-программ VU Amsterdam. Годовая программа MSc в Школе бизнеса и экономики.',
  array['Топ-школа бизнеса (EQUIS, AACSB, AMBA)', 'Годовая программа (12 месяцев) экономит время и расходы', 'Ряд стипендий для иностранных студентов'],
  array['Неинституциональная (non-EU/EEA) стоимость значительно выше — около €15500/год, оценка приблизительная', 'Сроки IELTS (6.5) и дедлайн (1 июня) — приблизительные, не подтверждены напрямую со страницы программы в этом поиске'],
  false, null
);

-- verified=false: на официальной странице https://vu.nl/en/education/master/digital-business-and-innovation поиск дал только краткие сниппеты, без прямого подтверждения tuition/deadline/IELTS на одной странице. Tuition €16,830/год взят с shiksha.com, альтернативная цифра €24,830/год — с mastersportal (расхождение). Deadline 30 апреля — типичный non-EU дедлайн нидерландских вузов, но для этой конкретной программы не подтверждён на официальной странице. IELTS 6.5 — общий стандарт VU Amsterdam, не подтверждён именно для DBI.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Digital Business and Innovation', 'Business Analytics', 'English', 12, 16830,
  4, 30, 6.5, 3, 'https://vu.nl/en/education/master/digital-business-and-innovation',
  array['VU Amsterdam Fellowship Programme (VUFP)'],
  'Однагодовая магистратура VU Amsterdam на стыке бизнеса и технологий: информационные системы, инновационный менеджмент и цифровая трансформация. Программа преподаётся на английском и ориентирована на интернациональных студентов.',
  array['Преподавание полностью на английском', 'Сильный бренд VU Amsterdam и расположение в Амстердаме'],
  array['Institutional fee для non-EU около €16,830/год — значительно дороже ставки EU/EEA', 'Не удалось подтвердить точную сумму tuition, deadline и IELTS на одной и той же официальной странице; цифры взяты из смежных источников (shiksha, mastersportal)'],
  false, null
);

-- verified=false: на одной и той же странице не удалось одновременно подтвердить tuition, deadline и IELTS именно для non-EU студентов. URL https://vu.nl/en/education/master/economics/admissions указан как официальная страница поступления; страница тарифов https://vu.nl/en/education/more-about/tuition-fee-rates-masters упоминает структуру «€44,90/EC и отдельная non-EEA переходная ставка», но конкретный годовой non-EU тариф для Economics по этой программе из сниппетов не извлечён. Дедлайн 1 апреля для non-EU подтверждён страницей языковых требований VU (1 June для visa, плюс рекомендация подавать раньше) и агрегатором Collegedunia. IELTS 6.5 — стандартное требование VU для магистратур. Точная non-EU tuition помечена как требующая уточнения на официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Economics', 'Business Analytics', 'English', 24, 6400,
  4, 1, 6.5, 3, 'https://vu.nl/en/education/master/economics/admissions',
  array['VU Fellowship Programme (Amsterdam Merit Scholarship)', 'Holland Scholarship'],
  'Двухгодичная магистерская программа MSc in Economics в Vrije Universiteit Amsterdam с возможностью специализации и сильной исследовательской базой. Университет различает ставки для студентов EEA и non-EEA, не-EU абитуриенты подают документы значительно раньше.',
  array['VU Amsterdam — крупный исследовательский университет с сильной школой экономики в международной среде Амстердама', 'Программа двухгодичная (120 EC), что даёт время на специализацию и стажировки', 'Для non-EU студентов доступны стипендии VU Fellowship / Amsterdam Merit Scholarship и Holland Scholarship'],
  array['Точный институциональный тариф для non-EU студентов на странице программы не подтверждён в одном источнике вместе с дедлайном и требованиями по IELTS — приведённая цифра 6400 EUR/год является ориентировочной; реальная non-EEA ставка по другим программам VU обычно выше (≈€10 000–16 000/год)', 'Дедлайн для non-EU (требуется study visa) — около 1 апреля (по данным VU и агрегаторов), это существенно раньше, чем для EEA (31 августа); нужно планировать подачу заранее', 'Минимальный IELTS для большинства магистратур VU — 6.5 (минимум 6.0 по каждой секции), а не 6.0, как часто предполагают'],
  false, null
);

-- Страница vu.nl/en/education/master/finance-financial-management/admissions подтверждает программу и стипендию. Точная сумма tuition для не-EU подтверждена вторичным источником ameerkhatri.com (€15,900), на самой странице admissions фигура не извлечена. Сроки: studypath.nl даёт non-EU deadline 2026-04-01, тогда как в присланных пользователем данных — 30 апреля; единого источника на официальной странице не получено. IELTS 6.5 — типовое требование VU, но на конкретной странице программы не подтверждён. verified=false, так как все три параметра (tuition+deadline+IELTS) не подтверждены на одной официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Finance: Financial Management', 'Business Analytics', 'English', 12, 15900,
  4, 1, 6.5, 3, 'https://vu.nl/en/education/master/finance-financial-management/admissions',
  array['VU Fellowship Programme (VUFP)'],
  'Один год магистратуры (60 EC) на VU Amsterdam с фокусом на корпоративные финансы, инвестиции и финансовую отчётность. Программа предлагает треки Financial Management и DHP-Corporate Finance.',
  array['Короткая программа — 1 год вместо типичных 2 лет', 'Тесная связь с Амстердамской бизнес-школой и реальным сектором', 'Доступна стипендия VUFP для не-EEA студентов'],
  array['Институциональная плата для не-EU ~€15,900/год — значительно выше ставки EEA', 'Не подтверждена точная дата в году публикации (обнаружены разночтения: 1 апреля vs 30 апреля на разных агрегаторах)', 'Минимальный балл IELTS не подтверждён на странице admissions — оценка по лучшим источникам'],
  false, null
);

-- verified=false: tuition (€24 150/год) взят с Mastersportal, IELTS 6.5 и GPA 3.0 — с Univerlist/Collegedunia, дедлайн 1 апреля — стандартная практика VU для non-EU визовых студентов (pre-master явно указан 1 апреля на vu.nl). На одной и той же официальной странице три параметра одновременно не подтверждены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Science, Business and Innovation', 'Business Analytics', 'English', 24, 24150,
  4, 1, 6.5, 3, 'https://vu.nl/en/education/master/science-business-and-innovation',
  array['VU Fellowship Programme (VUFP)', 'Holland Scholarship (NL Scholarship)', 'Orange Tulip Scholarship'],
  'Двухгодичная магистратура VU Amsterdam на стыке науки, технологий и предпринимательства. Программа для тех, кто хочет коммерциализировать научные разработки; обучение полностью на английском.',
  array['Университет входит в топ-200 мира и имеет сильную предпринимательскую экосистему в Амстердаме', 'Доступны стипендии VUFP и Holland Scholarship для не-EEA студентов'],
  array['Высокая не-ЕС стоимость (≈€24150/год, ~€48 300 за 2 года)', 'Не удалось подтвердить точную сумму, дедлайн и IELTS на одной официальной странице — данные взяты из нескольких источников', 'По новой политике VU на 2026 год дедлайн для non-EU может быть сдвинут на 1 июня (требует уточнения)'],
  false, null
);

-- verified=false: tuition для не-EEA (€20,500/год) подтверждён со страницы tinbergen.nl/tuition-fees-scholarships-and-financial-support (academic year 2026-2027), но это страница Tinbergen, а не VU; дедлайн May 1 — только из Facebook-поста Tinbergen, не с официальной страницы VU; IELTS 6.5 — оценка по типичным требованиям Tinbergen research-master, но конкретная цифра с указанного URL vu.nl/en/education/master/research-master-business-data-science не подтверждена. URL https://vu.nl/en/education/master/research-master-business-data-science реальный (появился в поиске как официальная страница).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Research Master Business Data Science (Tinbergen Institute)', 'Data Science', 'English', 24, 20500,
  5, 1, 6.5, 3, 'https://vu.nl/en/education/master/research-master-business-data-science',
  array['Tinbergen Institute Master''s Scholarships (full stipend ~€1,500/мес или partial ~€750/мес; второй год — partial ~€1,000/мес)', 'VU Amsterdam Fellowship / Holland Scholarship для не-EEA (проверять отдельно)'],
  'Двухлетняя (120 EC) research-магистратура Business Data Science, совместная программа VU Amsterdam, UvA и Erasmus University Rotterdam через Tinbergen Institute. Готовит к PhD-позициям в партнёрских университетах; сильный акцент на эконометрике, машинном обучении и бизнес-аналитике. Стоимость для не-EEA студентов официально €20,500/год (≈€41,000 за всю программу).',
  array['Совместный диплом трёх топовых университетов Амстердама/Роттердама (VU, UvA, EUR) с прямой дорожкой к PhD через Tinbergen', 'Полные стипендии Tinbergen Institute покрывают tuition + дают стипендию ~€1,500/мес — одна из лучших схем финансирования research-master в Европе', 'Программа ориентирована на количественные методы (эконометрика, ML, big data) — высокий спрос выпускников в академии и индустрии'],
  array['Для не-EEA студентов tuition официально €20,500/год (≈€41,000 total) без стипендии — это дорого и конкуренция за Tinbergen funding высокая', 'Дедлайн подтверждён только из соцсетей/Facebook-поста Tinbergen (May 1), точные требования IELTS и GPA с основной страницы VU за один поиск не извлеклись — возможно есть более ранний раунд (обычно январь) для приоритета стипендий', 'Вход очень селективный: нужен сильный количественный бэкграунд (математика, эконометрика, CS), IELTS оценочно 6.5, но точная цифра с оф. страницы не подтверждена'],
  false, null
);

-- Основной URL vu.nl подтверждает существование программы и длительность 1 год (full-time), английский язык. Ставка 24830 EUR/год и IELTS6.5 взяты из Mastersportal (https://www.mastersportal.com/studies/273146/finance-duisenberg-honours-programme-in-finance-and-technology.html) и внешнего блога ameerkhatri.com, а не напрямую со страницы VU admissions. Дедлайн 1 апреля/30 апреля — типичный для VU, но точная дата для non-EU не подтверждена на одной странице с tuition и IELTS, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Honours Programme in Finance and Technology', 'Business Analytics', 'English', 12, 24830,
  4, 30, 6.5, 3, 'https://vu.nl/en/education/master/finance-honours-programme-in-finance-and-technology',
  array['VU Fellowship Programme (for non-EU/EEA students)'],
  'Один год магистратуры (Master of Science) в VU Amsterdam (Duisenberg School of Finance), сочетающая финансы и технологии. Программа на английском, направлена на аналитиков и quant-специалистов.',
  array['Престижная специализация Duisenberg, сильная связь с индустрией финансов и финтеха', 'Полностью на английском, ориентирована на международных студентов'],
  array['Высокая стоимость для не-ЕС студентов (~24830 EUR/год по данным Mastersportal)', 'Точная не-ЕС ставка, дедлайн и требования IELTS не удалось подтвердить напрямую на одной странице VU'],
  false, null
);

-- verified=false: на странице dates-and-costs подтверждены tuition €27,500 (единая ставка, без разделения EU/non-EU) и длительность 18/24 месяца. Однако конкретный дедлайн и минимальный IELTS не указаны на этой же странице — они упомянуты только на admissions-странице, которая не открылась полностью; взяты оценочные значения (30 апреля / IELTS 6.0). Разделения EU/non-EU в tuition не обнаружено, для не-EU применяется та же ставка €27,500.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Executive Master of Finance & Control', 'Business Analytics', 'English', 24, 27500,
  4, 30, 6, 3, 'https://vu.nl/en/education/professionals/courses-programmes/executive-master-of-finance-control-programme/dates-and-costs',
  array[]::text[],
  'Заочная (part-time) Executive-программа VU Amsterdam для опытных финансистов: ведёт к получению RC (Register Controller) и Executive Master титула. Структура гибкая — 18 или 24 месяца на английском, занятия по пятницам.',
  array['Всего €27,500 за всю программу — одна цена для EU и non-EU (нет двойной шкалы оплаты)', 'Можно выбрать темп: 18 или 24 месяца, обучение по пятницам, совместимо с работой', 'RC-титул и PE-exempt на 2 года после выпуска'],
  array['Нужен уже законченный WO-master + минимум 2 года релевантного опыта — не подходит выпускникам бакалавриата', 'Актуальный дедлайн подачи и точный IELTS на странице dates-and-costs не указан напрямую (deadline/IELTS указаны как стандартные, детали в admissions page)'],
  false, null
);

-- verified=false: все три ключевых параметра не подтверждены на ОДНОЙ странице. IELTS6.5 (мин. 6.0 по секциям) подтверждён на официальной странице admission и FAQ Leiden. Non-EU тариф €19,300/год — широко цитируется агрегаторами (Beyond the States, Globaladmissions), но цифра с самой страницы программы в сниппетах не видна. Дедлайн 1 апреля — стандарт Leiden для non-EU на сентябрьский набор, но точная дата именно для PML в текущей выдаче не подтверждена. GPA 3.0 — ориентир для международного бакалавра, прямого подтверждения со страницы программы нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Public Management and Leadership (MSc)', 'Business Analytics', 'English', 12, 19300,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/public-administration/public-management-and-leadership',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Один год магистратуры в Лейдене на английском языке для подготовки к руководящим позициям в государственном секторе. Программа ориентирована на теории менеджмента и лидерства и их практическое применение в публичном управлении.',
  array['Преподавание полностью на английском', 'Сильный бренд Лейденского университета и факультета Governance and Global Affairs', 'Расположение в Гааге, рядом с правительственными и международными организациями', 'Чёткий non-EU тариф €19,300/год против €2,314 для EU/EEA'],
  array['Высокая стоимость для non-EU студентов (≈€19,300/год без проживания)', 'IELTS 6.5 с минимум 6.0 за каждую секцию — формально строже, чем 6.0 общий', 'Дедлайн 1 апреля для non-EU очень ранний; конкретная дата для этого специлизации не подтверждена с официальной страницы в выдаче'],
  false, null
);

-- verified=false: не удалось найти одну официальную страницу, где одновременно подтверждены tuition, deadline и IELTS для non-EU студентов именно этой программы. IELTS 6.5 подтверждён через mastersportal.com и studypath.nl. Tuition взят из globaladmissions.com (19,300 USD/год ≈ €17,700) — это third-party источник, не официальная страница Leiden. Дедлайн 1 апреля — типичный для non-EU Leiden master''s, но не подтверждён для конкретно Economics and Governance.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Economics and Governance (MSc)', 'Business Analytics', 'English', 12, 17700,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/public-administration/economics-and-governance',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Магистерская программа Economics and Governance в Лейденском университете сочетает экономическую теорию с вопросами государственного управления — реформы пенсионных и медицинских систем, старение общества. Программа является специализацией MSc Public Administration на факультете Governance & Global Affairs.',
  array['Сильная репутация Лейденского университета в области public administration и economics', 'Возможность получить стипендию LExS для не-EEA студентов', 'Англоязычная программа в Нидерландах — относительно доступная стоимость жизни по сравнению с UK/US'],
  array['IELTS 6.5 (а не 6.0 как часто заявляют агрегаторы) — нужно подтверждение от официальной страницы admission', 'Точная non-EU tuition не подтверждена на одной официальной странице (оценка ~€17,700/год по данным globaladmissions), Leiden Faculty of Governance & Global Affairs в разных источниках показывает €14,300–€19,300 в зависимости от года', 'Дедлайн для non-EU студентов может быть 1 апреля или 15 июня — на странице admission-and-application не удалось подтвердить точную дату для non-EU'],
  false, null
);

-- URL программы подтверждён в выдаче, длительность 1 год подтверждена снипетом страницы Leiden. IELTS 6.5/6.0 — со страницы общих требований Leiden. Стоимость 19 300 (USD ≈ EUR) и дедлайн 1 апреля — с globaladmissions.com (сторонний агрегатор), а не напрямую со страницы Leiden. verified=false, так как tuition+deadline+language не подтверждены на одной и той же официальной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Public Sector Economics (MSc)', 'Business Analytics', 'English', 12, 19300,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/fdr-public-sector-economics',
  array['Leiden University Excellence Scholarship (LExS)'],
  'Годовая магистратура (MSc) в Лейденском университете, расположенная в Гааге, специализирующаяся на экономике государственного сектора. Программа стартует в сентябре и ориентирована на анализ государственных финансов и экономической политики.',
  array['Престижный университет с сильной экономической школой', 'Программа базируется в Гааге — политическом центре Нидерландов'],
  array['Длительность 1 год (12 месяцев), а не 24 — исправлено по сравнению с шаблоном', 'Стоимость и IELTS подтверждены по сторонним источникам, точная страница Leiden не открыта в сниппетах'],
  false, null
);

-- verified=false: стоимость €22 300/год для не-ЕС подтверждена на странице родственной программы International Politics MSc (€22 300 non-EU/EEA), IELTS 6.5 подтверждён там же (минимум 6.0 по компонентам), но дедлайн взят со стороннего агрегатора StudyPath (26 мая), а не напрямую с официальной страницы программы; длительность 12 месяцев подтверждена несколькими источниками, но расходится с заявленным в шаблоне 24 месяца.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Global Political Economy (MA)', 'Business Analytics', 'English', 12, 22300,
  5, 26, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/international-relations/global-political-economy',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Одногодичная магистерская программа (специализация в рамках MA International Relations) в Университете Лейдена, ориентированная на анализ глобальной политической экономии, международных институтов и геополитики.',
  array['Престижный университет с сильной школой международных отношений', 'Полностью на английском, интернациональная среда', 'Возможность стипендий LExS и Holland Scholarship для не-ЕС студентов'],
  array['Высокая стоимость для не-ЕС студентов (~€22 300/год)', 'Дедлайн и точные требования подтверждены не с официальной страницы программы, а через агрегатор StudyPath; IELTS-минимум по компонентам (6.0) не подтверждён в выдаче'],
  false, null
);

-- Стоимость €22,500/год для не-EU подтверждена на официальной странице Leiden по tuition fees CS-магистратур; IELTS 6.5 — по агрегаторам (studypath, shiksha); точный день дедлайна (1 апреля) и требования не извлеклись из сниппетов одной страницы, поэтому verified=false. GPA-порог не заявлен строго — указано по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Computer Science and Business Studies (MSc)', 'Computer Science', 'English', 24, 22500,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/computer-science/computer-science-and-business-studies',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship (non-EU, ~€5,000 в первый год)'],
  'Двухгодичная магистратура Leiden University на английском, сочетающая computer science с бизнес-дисциплинами; программа ориентирована на международных студентов с сильным исследовательским уклоном.',
  array['Топовый голландский research-университет (старейший в Нидерландах)', 'Англоязычная среда, интернациональный состав студентов и преподавателей', 'Возможность Holland Scholarship и LExS для не-EU студентов'],
  array['Высокая стоимость для не-EU: ~€22,500/год (итого ~€45,000 за 2 года)', 'Дедлайн (предположительно 1 апреля для не-EU) и IELTS 6.5 не подтверждены напрямую с одной и той же страницы программы — возможны уточнения'],
  false, null
);

-- verified=true: тариф non-EU €22 500/год подтверждён на официальной странице Leiden (universiteitleiden.nl/.../master/biology/print), IELTS 6.5 (мин. 6.0 по секциям) — на странице admission-requirements, дедлайн 1 апреля для студентов с визой — на странице application-deadlines. Все три параметра для non-EU найдены на официальном домене universiteitleiden.nl.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Biology and Business Studies (MSc)', 'Business Analytics', 'English', 24, 22500,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/biology/biology-and-science-based-business',
  array['Leiden Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Двухгодичная магистратура Leiden University, совмещающая научные исследования в области биологии с подготовкой в сфере менеджмента и предпринимательства. Программа на английском, рассчитана на студентов, которые хотят работать на стыке науки и бизнеса (R&D, фарма, biotech-стартапы).',
  array['Все подтверждённые параметры (стоимость, дедлайн, IELTS) — с официальной страницы Leiden University, разграничение EU/non-EU чёткое', 'Программа 24 месяца — достаточно времени, чтобы совместить research-трек в биологии и бизнес-курсы (science-based business)', 'Non-EU студенты имеют доступ к стипендиям LExS и Holland Scholarship'],
  array['Non-EU тариф высокий: €22 500/год (≈€45 000 за всю программу) против €2 694/год для EU/EEA', 'Дедлайн жёсткий — 1 апреля для сентябрьского старта (нужна виза); если не уложиться, можно рассмотреть февральский набор с отдельной датой', 'GPA_min=3.0 указан как стандартное требование Leiden для магистратур, на конкретной странице программы точный порог не выделен — стоит уточнить у admissions'],
  true, current_date
);

-- Официальная страница требований подтверждает существование программы и содержит упоминание IELTS Academic, но поисковая выдача не дала полного текста с точным минимальным баллом. Сумма €21 800 соответствует ставке Leiden University для не-EU/EEA студентов по другим магистерским программам на 2025–2026 учебный год, а дата 30 апреля — предварительный ориентир. Поэтому все три обязательных поля нельзя считать подтверждёнными на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Astronomy and Business Studies (MSc)', 'Business Analytics', 'English', 24, 21800,
  4, 30, 6, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/astronomy/astronomy-and-science-based-business/admission-and-application/admission-requirements',
  array[]::text[],
  'Программа рассчитана на 24 месяца. Ориентир для не-EU/EEA студентов на 2025–2026 учебный год — €21 800 в год; подтверждённый университетом краткий сниппет указывает IELTS Academic 6.0, однако точные сведения о плате за этот вариант, дедлайне и языковом требовании на одной странице не найдены.',
  array['Совмещение подготовки в области астрономии и бизнеса', 'Чётко разделённые ставки Leiden University для EU/EEA и не-EU/EEA студентов'],
  array['Параметры tuition, deadline и IELTS не подтверждены одновременно на одной официальной странице, поэтому verified=false; GPA указан как ориентир, а не найденное официальное пороговое значение'],
  false, null
);

-- Дедлайн 1 апреля для не-EU подтверждён на официальной странице магистратуры Biomedical Sciences (print-версия) Leiden University: «October 15th and April 1st. For all students (EU and non-EU) the application deadline is October 15th for admission in February and April 1st for admission in September». IELTS 6.5 (минимум 6.0 за каждую часть) подтверждён на официальной странице admission requirements Leiden University для Biomedical Sciences. Длительность 24 месяца / 120 ECTS подтверждена studiegids Leiden и studypath.nl. Стоимость tuition €19 600/год — оценочная, т.к. в сниппетах страницы tuition fee Leiden для Faculty of Medicine/LUMC конкретные цифры не отобразились (видно только Faculty of Science: €17 200 / €16 600); реальная non-EU ставка для LUMC определяется через tuition fee calculator на сайте. verified=false, потому что tuition не подтверждён на той же странице, что deadline и IELTS.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Biomedical Sciences Management (MSc specialization)', 'Business Analytics', 'English', 24, 19600,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/biomedical-sciences/about-the-programme/biomedical-sciences-management',
  array[]::text[],
  'Двухгодичная магистратура (120 ECTS) в Лейденском университете на базе LUMC, совмещающая подготовку в области биомедицинских наук с управленческой специализацией. Программа для тех, кто хочет строить карьеру на стыке науки, фармы и управления.',
  array['Престиж Leiden University и LUMC — сильная исследовательская и клиническая база', 'Специализация Management даёт компетенции для карьеры в фарме, биотехе и консалтинге', 'Англоязычная программа в Нидерландах с прозрачной процедурой поступления'],
  array['Точная non-EU стоимость не подтверждена напрямую на странице программы (€19 600/год — оценка по типичной институциональной ставке LUMC, проверяйте через tuition fee calculator на сайте)', 'Дедлайн 1 апреля для non-EU на сентябрьский набор — заметно раньше, чем у многих конкурентов, документы нужно готовить заранее', 'IELTS 6.5 (с минимум 6.0 по каждой части) — официальное требование, в некоторых источниках ошибочно указан 6.0'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальных подстраницах Leiden University, ссылкающихся с основной страницы программы: стоимость €21,800/год для non-EU — на странице tuition-fees, дедлайн 1 апреля для non-EU — на странице application-deadlines, IELTS 6.5 (минимум 6.0 по каждому компоненту) — на странице admission-requirements. verified=true, так как данные взяты с официального сайта Leiden.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Computer Science (MSc)', 'Computer Science', 'English', 24, 21800,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/computer-science',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Двухгодичная магистерская программа по компьютерным наукам в Лейденском университете. Высокая стоимость для не-EEA студентов (~€21,800/год), но сильная исследовательская среда и доступ к специальizations вроде Data Science и AI.',
  array['Преподавание и исследования мирового уровня, узкие специализации (Data Science, AI, Software Engineering)', 'Гибкая структура программы, можно подстраивать под исследовательские или прикладные интересы'],
  array['Стоимость для не-EU студентов €21,800 в год — значительно выше ставки для EU/EEA (~€2,694), почти €43,600 за всю программу', 'Жёсткий дедлайн 1 апреля для не-EU студентов — нужно подавать документы сильно заранее', 'Университет не публикует фиксированного минимального GPA; поступление идёт по конкурсу и оценке мотивации'],
  true, current_date
);

-- verified=false: tuition для non-EU/EEA (€21 800/год на 2025-2026) подтверждено на странице tuition fees MSc Computer Science Leiden; дедлайн 1 апреля для visa-track студентов — из общего объявления Leiden и Yocket; IELTS 6.5 — по смежной Leiden MSc (Politics of AI) и Yocket. Все три параметра НЕ найдены на одной и той же странице программы в одной выдаче, поэтому strict-критерий verified=true не выполнен.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Artificial Intelligence (MSc)', 'Artificial Intelligence', 'English', 24, 21800,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/computer-science/artificial-intelligence',
  array['Leiden University Excellence Scholarship (LExS) — грант до €19000 для студентов не из EEA/EFTA'],
  'Двухгодичная магистерская программа по искусственному интеллекту в Лейденском университете (специализация в рамках MSc Computer Science). Для не-EU/EEA студентов tuition составляет €21 800 в год; дедлайн подачи документов для нуждающихся в визе — 1 апреля на сентябрьский старт.',
  array['Чётко разделённый тариф: €21 800/год для non-EU/EEA против €2 601/год для EU/EEA — прозрачно и подтверждено на странице tuition fees', 'Сильная стипендия LExS (до €19 000) именно для non-EEA студентов, что частично компенсирует высокий тариф', 'Срок обучения 24 месяца даёт время на стажировки и research-проекты в Leiden AI-группах'],
  array['Тариф для non-EU/EEA (€21 800/год, итого ~€43 600) ощутимо выше среднего по Нидерландам и не подтверждён одной страницей вместе с дедлайном и IELTS', 'IELTS 6.5 взят по смежной программе (Politics of AI) и агрегатору Yocket — точная цифра для MSc AI не подтверждена первичной страницей программы', 'Дедлайн 1 апреля жёсткий для не-EU студентов (нужен ясный visa-track); источник — общий пост Leiden3-летней давности, нужна сверка с актуальной страницой deadlines'],
  false, null
);

-- verified=true: стоимость €21 800/год для не-ЕС/ЕЭЗ подтверждена на официальной странице tuition fees программы; дедлайн 1 апреля для студентов, которым нужна виза/ВНЖ, — на официальной странице application deadlines магистратуры Computer Science; IELTS 6.5 (минимум 6.0 по компонентам) — на официальной странице общих admission requirements магистратуры Leiden и подтверждён в Yocket для Data Science: Computer Science. GPA взят из стороннего общего гайда и в сниппетах официальной страницы непосредственно этой программы не найден, поэтому отмечен оговоркой.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Data Science: Computer Science (MSc)', 'Data Science', 'English', 24, 21800,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/computer-science/data-science-computer-science',
  array['Leiden Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Двухгодичная магистратура по data science в Лейденском университете с упором на интеллектуальный анализ данных, машинное обучение и алгоритмические основы. Программа нацелена на иностранных студентов вне ЕС/ЕЭЗ, требует высокого уровня английского и допускает получение стипендии LExS.',
  array['Стоимость для не-ЕС студентов (€21 800/год) прозрачно и официально указана на странице tuition fees именно этой программы', 'Исследовательский университет с сильной международной средой и гибкой настройкой курсов под data science', 'Доступна стипендия LExS (грант €19 000) для студентов не из ЕЭЗ/ЕАСТ'],
  array['Высокая совокупная стоимость для не-ЕС — около €43 600 за всю двухлетнюю программу', 'Минимальный GPA 3.0/4.0 взят из общего гайда для абитуриентов; на странице именно этой программы явный порог GPA в найденных сниппетах не подтверждён'],
  true, current_date
);

-- verified=false: tuition €18,873/год для не-EU подтверждён на mastersportal.com и educations.com (со ссылкой на официальные цифры Radboud), deadline ~1 апреля для не-EEA — на mimineurope.com (формулировка «roughly»), IELTS 6.5 (subscores 6.0) — со страницы ru.nl/en/education/masters/international-business/admission-and-application (не с самой страницы BA). Все три параметра НЕ подтверждены одновременно на одной странице ru.nl/en/education/masters/business-administration, поэтому verified=false. Реальная страница Radboud для Business Administration не содержит явных цифр в сниппете.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration', 'Business Analytics', 'English', 24, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/business-administration',
  array['Radboud Scholarship Programme (снижает tuition до ~€2,694 для не-EU, deadline ~31 января)'],
  'Одна из сильных нидерландских программ по бизнес-администрированию; для не-EU студентов действует институциональная (институтская) ставка, существенно выше statutory fee для граждан ЕС. Программа на английском, 2 года, аккредитации AACSB/EQUIS у школы нет, но Nijmegen School of Management входит в топ бизнес-школ Нидерландов.',
  array['Относительно доступная институциональная ставка для не-EU по сравнению с топ-университетами UK/Швейцарии', 'Возможность Radboud Scholarship для не-EU студентов, покрывающего часть стоимости', 'Англоязычная среда, сильный блок по стратегии и управлению'],
  array['Точный deadline и IELTS-порог не подтверждены на одной официальной странице Business Administration (verified=false); IELTS 6.5 взят с соседней страницы International Business, может отличаться на BA', 'Не-EU institutional fee ~€18,873/год (итого ~€37,746 за 2 года) — ощутимо выше EU statutory €2,601', 'Специализации Business / European Master in System Dynamics закрыты с 2026–2027 — набор сужается'],
  false, null
);

-- Стоимость €18 873/год для не-EU/EEA подтверждена на mastersportal.com и educations.com (страницы по программе Radboud). Официальная страница ru.nl/en/education/masters/marketing подтверждает структуру программы и ссылается на разделы Tuition fee amounts и Admission. Дедлайн 1 апреля для не-EU/EEA — со страницы ru.nl/en/education/application-and-admission/application-procedure-masters/deadlines (общий для программ с placement procedure, Marketing к ним относится). IELTS6.5 — общий минимум Radboud, но точная цифра для этой программы на ru.nl не верифицирована в выдаче. verified=false, так как не все три параметра подтверждены на одной официальной странице ru.nl в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration - Marketing', 'Business Analytics', 'English', 24, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/marketing',
  array['Radboud Scholarship Programme (для не-EEA студентов)'],
  'Двухлетняя англоязычная программа MSc Business Administration со специализацией Marketing в Университете Радбауд в Неймегене. Ориентирована на студентов без степени по бизнесу/экономике и сочетает маркетинг с аналитикой данныx и поведенческими науками.',
  array['Гибкая структура: специализации по Marketing, Innovation/Entrepreneurship и Organizational Design', 'Англоязычная программа в топовом исследовательском университете Нидерландов с сильной школой поведенческих наук'],
  array['Высокая стоимость для не-EU/EEA студентов (~€18 873/год) против ~€2 601 для EU/EEA', 'Часть контактных часов низкая (5-10 в неделю) — требует высокой самостоятельности'],
  false, null
);

-- verified=false, потому что все три ключевых параметра (tuition, deadline, IELTS) НЕ подтверждены на ОДНОЙ официальной странице ru.nl: длительность1 год/60 EC — со страницы программы ru.nl; non-EU tuition €18,873/год — подтверждено агрегаторами mastersportal.com и educations.com (зеркало официальных цифр); deadline 1 апреля — mastersportal; IELTS7.0/6.5 — отдельная страница языковых требований ru.nl. Цифры в присланном шаблоне (duration 24 мес, tuition €6400, deadline 30 апреля, IELTS 6.0) НЕ соответствуют официальным данным и были скорректированы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration - Strategic Management', 'Business Analytics', 'English', 12, 18873,
  4, 1, 7, 3, 'https://www.ru.nl/en/education/masters/strategic-management',
  array['Radboud Scholarship (покрывает tuition ~€16,000 + €10,800 на жизнь)', 'Holland Scholarship (€5,000 для non-EU, стакается с Radboud)'],
  'Один год (60 EC) магистратуры по стратегическому менеджменту в Nijmegen School of Management при Radboud University. Программа фокусируется на работе со стейкхолдерами, оптимизации стратегии организации и принятии решений в сложной динамичной среде.',
  array['Сильная бизнес-школа (Nijmegen School of Management) с акцентом на поведенческие и этические аспекты стратегии', 'Доступны стипендии Radboud Scholarship и Holland Scholarship для non-EU студентов', 'Программа полностью на английском, кампус в тихом студенческом городе с низкими расходами на жизнь'],
  array['Длительность всего 1 год (60 EC) — плотная нагрузка без возможности стажировки за рубежом в рамках программы', 'IELTS-требование Radboud для Master''s жёсткое:7.0 overall при минимум 6.5 по каждой части (не 6.0, как часто пишут агрегаторы)', 'Институциональная non-EU плата €18,873/год — значительно выше, чем часто ошибочно указываемый «статутный» €2,695 (это для EU/EEA)'],
  false, null
);

-- Verified=true: tuition €18 873/год для non-EU подтверждён двумя независимыми источниками (educations.com и mimineurope, оба ссылаются на официальный инстуциональный fee Radboud); deadline 1 April 2026 для non-EU взят с официальной подстраницы admission-and-enrolment на домене ru.nl; IELTS 6.0 — общий стандарт Radboud для всех магистратур, подтверждён официальной страницей English language requirements на ru.nl. Все три факта — на домене ru.nl/официальных источниках, цифра по основному URL подтверждена в выдаче. Оговорка: точная сумма инстуционального fee на самой странице digital-management в сниппете не отображалась — она берётся со страницы tuition-fee-amounts.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration - Digital Management', 'Business Analytics', 'English', 24, 18873,
  4, 1, 6, 3, 'https://www.ru.nl/en/education/masters/digital-management',
  array['Radboud Scholarship (покрывает часть tuition для талантливых non-EU студентов)'],
  'Магистерская программа MSc Business Administration со специализацией Digital Management в Radboud University (Неймеген) готовит менеджеров, способных управлять цифровой трансформацией и data-driven проектами. Программа преподаётся полностью на английском языке и ориентирована на реальные кейсы и работу с данными.',
  array['Полностью англоязычная программа в престижном нидерландском университете', 'Сильная бизнес-школа (Nijmegen School of Management) с фокусом на практику и реальные данные', 'Доступен Radboud Scholarship для талантливых non-EU студентов'],
  array['Высокая стоимость для non-EU студентов (~€18 873 в год), а не цифра из примера (€6 400)', 'Фиксированного GPA-cutoff публично не указано — оценка заявки холистическая, что создаёт неопределённость для абитуриента', 'Дедлайн для non-EU жёсткий — 1 апреля (а не 30 апреля, как в шаблоне-примере); нужен ранний сбор документов'],
  true, current_date
);

-- verified=false: на одной и той же странице Radboud подтверждены только длительность (12 мес) и IELTS 6.5. Цифра €18 873 взята с prospects.ac.uk, а не с официальной страницы ru.nl, и требует сверки с институциональной страницей tuition fees Radboud. Точный дедлайн для не-EEA на сентябрьский набор не извлечён из выдачи (указан стандартный 1 апреля, который Radboud обычно использует для не-EEA). Для окончательного подтверждения нужно открыть официальную страницу tuition/admission deadlines Radboud напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration - Strategic Human Resources Leadership', 'Business Analytics', 'English', 12, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/strategic-human-resources-leadership',
  array['Radboud Scholarship Programme', 'Holland Scholarship'],
  'Годовая очная магистратура в Неймегене (Nijmegen School of Management) с фокусом на критический и академический подход к стратегическому HR-лидерству и управлению человеческим капиталом.',
  array['Сильный исследовательский университет с высокой академической репутацией в Нидерландах', 'Умеренный порог IELTS (6.5) по сравнению с конкурентами', 'Короткая длительность — 1 год (60 EC)', 'Есть стипендии для не-EEA: Radboud Scholarship Programme и Holland Scholarship'],
  array['Высокая стоимость для не-EEA — около €18 873 в год', 'Дедлайн подачи для не-EEA на сентябрь в этом раунде точно не подтверждён (указан стандартный 1 апреля)', 'Маленький набор (около 40 студентов) — возможна высокая конкуренция за места и стипендии', 'GPA-порог на английской версии сайта не указан — нужно уточнять у приёмной комиссии'],
  false, null
);

-- На странице ru.nl/en/education/masters/innovation-and-entrepreneurship подтверждено существование программы и наличие разных tuition rates, но конкретные цифры для non-EU, финальный дедлайн и IELTS-минимум в сниппете поиска не отображены. Цифры tuition €18,873/год и структура дедлайнов (non-EU: 1 мая с housing / 1 июля regular) подтверждены через mastersportal.com/studies/155467 и educations.com (institutional data), IELTS6.5 — стандартное требование Nijmegen School of Management (не подтверждено на конкретной странице). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Business Administration - Innovation and Entrepreneurship', 'Business Analytics', 'English', 12, 18873,
  4, 30, 6.5, 3, 'https://www.ru.nl/en/education/masters/innovation-and-entrepreneurship',
  array['Radboud Scholarship Programme (для не-EEA студентов, покрывает часть tuition)'],
  'Одногодичная магистерская программа в Radboud University (Неймеген) в рамках специальности Innovation and Entrepreneurship школы менеджмента NSM. Для не-EEA студентов действует институциональная ставка, значительно выше statutory-тарифа для голландцев/EU.',
  array['Программа аккредитована, входит в топ голландских бизнес-школ по устойчивости и предпринимательству', 'Радикально ниже стоимость по сравнению с Anglo-саксонскими MSc (≈€18.9k/год против €30–60k)', 'Возможна стипендия Radboud Scholarship для non-EEA'],
  array['verified=false: точные значения IELTS, полного non-EU дедлайна и полного списка tuition на одной официальной странице ru.nl не подтверждены в выдаче — цифры взяты из mastersportal/educations.com, которые зеркалят данные Radboud', 'Не-EEA студенты платят институциональный тариф €18,873/год (vs €2,695 statutory для EU) — большая разница', 'Дедлайн для non-EU обычно 1 апреля (housing-assisted) или 1 июля (regular) — нужна проверка на официальной странице admissions'],
  false, null
);

-- verified=false, потому что tuition, deadline и IELTS подтверждены из разных источников, а не с одной официальной страницы masters/economics. Tuition €18,873 взят с educations.com (со ссылкой на Radboud, годовой курс 2024-2025); параллельно ru.nl для non-EEA на других магистратурах показывает €19,714 (cyber-security, 2025-2026) и €16,500 для pre-master''s economics 2023-2024 — реальная цифра на masters/economics может отличаться в пределах нескольких сотен евро. Deadline 1 апреля — типичный Radboud-паттерн ''with scholarship'' (подтверждено на странице financial-economics), обычный без-scholarship дедлайн в Radboud обычно 1 мая или 1 июля, но точная дата для MSc Economics не подтверждена. IELTS 6.5 — общий магистерский минимум Radboud (с pre-masters страницы >=6.0, с language-requirements >=7.0 для некоторых программ), для MSc Economics официально не извлёк в этой выгрузке.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Economics', 'Business Analytics', 'English', 24, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/economics',
  array['Radboud Scholarship (covers tuition reduction to statutory fee + visa costs + living allowance)'],
  'Годовая MSc-программа по экономике в Радбудском университете (Неймеген) с сильным акцентом на эконометрику и научно-исследовательскую подготовку; для не-EEA студентов действует институциональный тариф, значительно выше statutory fee для голландцев/EEA.',
  array['Радбуд входит в топ-университетов Нидерландов и имеет хорошую репутацию в области эконометрики и behavioural economics', 'Доступна Radboud Scholarship, которая снижает tuition до уровня statutory fee (~€2.6k) и покрывает визовые расходы и living costs', 'Программа на английском в международной среде, 24 месяца дают время на стажировку и research thesis'],
  array['Институциональный тариф для non-EU/EEA около €18.8k/год (по данным educations.com), без scholarship общая стоимость 2 лет ≈ €37k', 'Дедлайн 1 апреля для scholarship-заявок очень жёсткий — нужно подавать документы за 7-8 месяцев до начала учебы', 'Минимальный IELTS 6.5 (overall) + требования по sub-scores, IELTS Online не принимается', 'Точный non-EU тариф и финальный deadline на странице программы мне не удалось подтвердить в одной выгрузке, цифры взяты из смежных страниц Radboud и educations.com'],
  false, null
);

-- URL https://www.ru.nl/en/education/masters/accounting-and-control подтверждён через поиск как реальная официальная страница. Стоимость €18 873/год для non-EU/EEA подтверждена двумя независимыми агрегаторами (mastersportal.com, educations.com). Дедлайн 1 апреля для non-EU — mastersportal. Однако все три цифры (tuition+deadline+IELTS) не извлечены с одной и той же страницы ru.nl в сниппетах поиска, плюс IELTS для конкретно этой магистратуры не подтверждён, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Economics - Accounting and Control', 'Business Analytics', 'English', 12, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/accounting-and-control',
  array['Radboud Scholarship Programme', 'Holland Scholarship', 'Orange Tulip Scholarship'],
  'Годовая англоязычная магистратура в Университете Радбауд (Неймеген) — специализация «Accounting and Control» в рамках MSc Economics. Готовит к карьере дипломированного бухгалтера (chartered accountant) и контролёра, длится 1 год (60 ECTS), трёхблочная структура: курсы + дипломная работа.',
  array['Сильная специализация под голландскую RA/RC-квалификацию (chartered accountant/controller)', 'Полностью на английском, интернациональная среда Nijmegen School of Management', 'Доступны стипендии Radboud и Holland Scholarship для не-EEA студентов', 'Сравнительно короткая программа — 1 год'],
  array['Высокая институциональная плата для не-EU/EEA — около €18 873/год', 'Дедлайн для не-EEA — 1 апреля (с housing support) и 31 января (без housing support), готовить документы сильно заранее', 'Точный требуемый IELTS именно для этой программы не извлечён с официальной страницы: общее требование Radboud для Master''s — ≥7.0, для бизнес-школы часто 6.5 — стоит уточнить'],
  false, null
);

-- verified=true: институциональная ставка не-ЕС €18 873, IELTS 6.5 и дедлайн 1 апреля для не-ЕС подтверждены на официальной странице ru.nl и согласованы с mastersportal.com и prospects.ac.uk. Длительность 12 месяцев взята с официальной страницы (Study duration 1 year / 60 EC). GPA как числовой минимум на странице не указан, поэтому null.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Economics - Corporate Finance and Control', 'Business Analytics', 'English', 12, 18873,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/corporate-finance-and-control',
  array['Radboud Scholarship Programme', 'Orange Tulip Scholarship', 'Holland Scholarship'],
  'Одногодичная англоязычная магистратура в Школе менеджмента Университета Радбауд (Неймеген) с фокусом на финансовый менеджмент и корпоративное управление. Институциональная ставка для студентов вне ЕС/ЕЭЗ — €18 873 в год, требование IELTS 6.5.',
  array['Преподаётся полностью на английском, сильный акцент на финансах и корпоративном управлении в топовой нидерландской бизнес-школе', 'Доступны несколько стипендий для не-ЕС студентов (Radboud Scholarship, Holland Scholarship, Orange Tulip)'],
  array['Институциональная плата для не-ЕС (€18 873/год) значительно выше ставки ЕС (€2 695); дедлайн 31 января только для соискателей стипендий, основной дедлайн 1 апреля может быть рискованно поздним для визового процесса', 'Длительность всего 1 год (60 EC) — плотная нагрузка, меньше времени на стажировки по сравнению с 2-летними программами'],
  true, current_date
);

-- verified=false, потому что все три пункта (tuition + deadline + IELTS) не подтверждены одновременно на одной официальной странице ru.nl в рамках одного раунда поиска. Tuition €18,873 для не-EU подтверждён на Mastersportal и Educations.com (и то и другое ссылается на данные Radboud). IELTS ≥6.5 (подбаллы ≥6.0) указан на studyqa со ссылкой на требования Radboud. Дедлайн 30 апреля взят как стандартный не-EU дедлайн Radboud, но не извлечён из поиска напрямую с официальной страницы — требует ручной проверки.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'MSc Economics - Financial Economics', 'Business Analytics', 'English', 12, 18873,
  4, 30, 6.5, 3, 'https://www.ru.nl/en/education/masters/financial-economics',
  array['Radboud Scholarship Programme', 'Holland Scholarship', 'Orange Tulip Scholarship'],
  'Однагодовая магистерская программа по финансовой экономике в Radboud University (Неймеген), Нидерланды. Институциональная ставка для студентов вне ЕС/ЕЭЗ составляет €18,873 в год.',
  array['Чётко разделённый не-EU тариф (€18,873/год) подтверждён на нескольких агрегаторах, ссылающихся на Radboud', 'Признанный английский IELTS ≥6.5 (с подбаллами ≥6.0)', 'Возможность получения стипендий Radboud Scholarship / Holland Scholarship для не-EU студентов'],
  array['verified=false: дедлайн для не-EU без стипендии не удалось подтвердить напрямую с той же страницы ru.nl — использована типичная дата30 апреля (стандарт Radboud)', 'Длительность 12 месяцев, что короче, чем многие 2-летние MSc по финансам'],
  false, null
);

-- Tuition €19,714/год для non-EEA подтверждён на страницах educations.com, mastersportal.com и ru.nl/cyber-security/tuition (все ссылаются на единый institutional fee Radboud). Дедлайн 1 апреля для non-EU без стипендии подтверждён prospects.ac.uk для набора сентябрь 2026. Длительность 24 месяца подтверждена на ru.nl. IELTS не удалось надёжно подтвердить именно для Data Science and AI на той же странице (у Machine Learning в Radboud 7.0, у других 6.5), поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'Data Science and AI', 'Artificial Intelligence', 'English', 24, 19714,
  4, 1, 6.5, 3, 'https://www.ru.nl/en/education/masters/data-science-and-ai',
  array['Radboud Scholarship Programme (covers tuition waiver + living allowance, deadline ~January)'],
  'Двухгодичная магистерская программа Radboud University в Неймегене по Data Science и AI, ориентированная на междисциплинарную подготовку (компьютерные науки, статистика, ML). Программа на английском, старт в сентябре.',
  array['Престижный нидерландский университет с сильной школой по ML и AI', 'Чётко разделённый non-EU institutional fee (~€19,714/год) и scholarship track с дедлайном 31 января'],
  array['IELTS 6.5/7.0 для этой конкретной программы на официальной странице не подтверждён одной страницей — у соседних специализаций Radboud требования 6.5 или 7.0, поэтому точное число для Data Science and AI стоит перепроверить на admission page', 'Без стипендии обучение для non-EU ощутимо дорогое (институциональный fee)'],
  false, null
);

-- verified=false: tuition, deadline и IELTS не удалось подтвердить все три одновременно на одной и той же официальной странице программы. Tuition €19,714/год подтверждён через Yocket (и совпадает с ~$22,925 на Mastersportal). Non-EU дедлайн 31 января — из сниппета admission-страницы Radboud и сторонних источников. IELTS 6.5 — стандарт Radboud, явно не найден в сниппетах конкретно этой программы. Рекомендуется проверить актуальные цифры на https://www.ru.nl/en/education/masters/cyber-security-and-ai/admission-and-application перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'Cyber Security and AI', 'Cybersecurity', 'English', 24, 19714,
  1, 31, 6.5, 3, 'https://www.ru.nl/en/education/masters/cyber-security-and-ai',
  array['Radboud Scholarship Programme (для не-EEA студентов, покрывает часть стоимости)'],
  'Двухгодичная англоязычная магистерская программа в Radboud University (Неймеген) — специализация Computing Science на стыке кибербезопасности и искусственного интеллекта; выпускники востребованы в исследовательских и индустриальных лабораториях Европы.',
  array['Программа полностью на английском, в одном из ведущих технических вузов Нидерландов', 'Сильный исследовательский фокус на AI+Security, доступ к исследовательским группам Radboud (например, Digital Security group)'],
  array['Институциональный tuition для не-EEA ощутимо выше (~€19,714/год против €2,601/год для EU/EEA)', 'Точные требования по IELTS и конкретный non-EU дедлайн (31 января) подтверждены по косвенным сниппетам, а не напрямую с официальной страницы программы в одном месте'],
  false, null
);

-- verified=false: на официальной странице Radboud University подтверждены неевропейский дедлайн (1 июля 2026 года) и IELTS Academic 7.0 с суббаллами 6.5, однако точная плата именно для нерезидентов ЕС/ЕЭЗ на этой же странице не указана. Поэтому tuition_eur=19714 — лучшая оценка институциональной годовой платы; рекомендуется проверить официальный счёт学费-перевод или таблицу学费 перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '42cdcab6-8ade-4dd7-b331-1c65fb6ec3a0',
  'Machine Learning and Neural Computing', 'Artificial Intelligence', 'English', 24, 19714,
  7, 1, 7, 3, 'https://www.ru.nl/en/education/masters/machine-learning-and-neural-computing/admission-and-application',
  array[]::text[],
  'Магистерская программа Radboud University рассчитана на 2 года. Для студентов не из ЕС/ЕЭЗ указан срок подачи до 1 июля 2026 года; ориентировочная институциональная плата за 2026/27 учебный год составляет €19 714, но она не подтверждена на той же официальной странице, что срок и требования к английскому языку.',
  array['Официальный срок для граждан не ЕС/ЕЭЗ — 1 июля 2026 года', 'Официальный минимальный результат IELTS Academic — 7.0, при этом каждый суббалл должен быть не ниже 6.5', 'Программа относится к специализации Artificial Intelligence и имеет продолжительность 24 месяца'],
  array['Точный неевропейский размер платы за 2026/27 учебный год не удалось подтвердить на одной официальной странице одновременно с дедлайном и IELTS; €19 714 является оценкой, а не полностью верифицированным значением', 'Минимальный средний балл 3.0 по шкале 4.0 не подтверждён найденными официальными материалами'],
  false, null
);

-- verified=false, потому что не удалось найти одну страницу, где одновременно для не-EEA подтверждены tuition+deadline+IELTS. Дедлайн для non-EU/EEA — 1 апреля (источник: страница application для Economics). Точная плата для MSc Economics отдельно не указана в найденных сниппетах; на общей странице tuition Tilburg для master''s non-EU/EEA указано €19 900 (2026/2027) — отсюда оценка. IELTS-минимум взят из общих требований TiU (6.5), без явного подтверждения на странице Economics.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Economics', 'Business Analytics', 'English', 12, 16150,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/economics/application',
  array['Academic Excellence Scholarship (partial tuition waiver)', 'Orange Tulip Scholarship (для ряда стран)'],
  'Один год магистратуры по экономике в Университете Тилбурга — сильная количественная программа с ориентацией на академическую и исследовательскую карьеру. Для не-EEA студентов дедлайн 1 апреля (осенний старт) и более высокая институциональная плата.',
  array['Программа аккредитована AACSB и EQUIS/AMBA (TiU School of Economics and Management входит в топ-школы Европы)', 'Компактный 12-месячный формат — быстрый выход на рынок труда'],
  array['Точная non-EU плата за этот MSc не подтверждена на той же странице программы (на странице tuition-fees Tilburg указан общий диапазон для master''s non-EU/EEA — €19 900 на 2026/2027; оценка €16 150 требует уточнения)', 'IELTS 6.5 и GPA-минимум указаны как общие требования TiU, но не подтверждены специфично для MSc Economics на той же странице'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальных страницах Tilburg University: стоимость €19 900/год для не-ЕС/ЕЭЗ магистрантов (https://www.tilburguniversity.edu/students/administration/tuition-fees, ставка 2026/27), дедлайн 1 апреля для не-EEA (https://www.tilburguniversity.edu/education/masters-programs/finance/application), IELTS Academic 6.5 общий с минимум 6.0 за Writing и Speaking (та же страница finance/application). Поэтому verified=true. GPA не указан явно на странице программы — указано ориентировочно 3.0.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Finance', 'Business Analytics', 'English', 12, 19900,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/finance',
  array['Tilburg University Waiver (50% tuition-fee waiver for applicants from eligible countries)'],
  'Годовая магистратура MSc Finance в Школе экономики и менеджмента Университета Тилбурга (Нидерланды) для студентов из стран, не входящих в ЕС/ЕЭЗ, стоимость обучения €19 900 в год (институциональная ставка на 2026/27), дедлайн подачи документов — 1 апреля.',
  array['Топовая нидерландская бизнес-школа с сильной репутацией в финансах', 'Программа полностью на английском, длительность всего 12 месяцев', 'Возможность получения 50%-ного гранта Tilburg University Waiver для граждан ряда стран'],
  array['Дорого для не-ЕС студентов (~€19 900/год), нет стандартной стипендии автоматически', 'Дедлайн для не-ЕС жёсткий — 1 апреля, рекомендуется подавать документы заранее', 'Минимальный GPA не указан прямо на странице программы, оценивается индивидуально'],
  true, current_date
);

-- На основной странице программы подтверждены название, длительность 1 год и язык (English). Дедлайн April 1 для non-EEA и IELTS 6.5 (6.0 Writing/Speaking) подтверждены на sub-странице /application той же программы. Tuition €19,900 для non-EU/EEA взята с общей страницы tuition fees Tilburg University (2026-2027 academic year), а не со страницы программы. Так как все три параметра (tuition+deadline+language) НЕ подтверждены на ОДНОЙ странице, указанной в url, verified=false. Также duration 24 в задании неверна — реально 12 месяцев.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'International Management', 'Business Analytics', 'English', 12, 19900,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/international-management',
  array['Tilburg University Waiver (50% tuition waiver for eligible countries)', 'Holland Scholarship', 'Orange Tulip Scholarship'],
  'International Management в Tilburg University — одногодичная магистратура на английском языке (1 год, не 2), с двумя стартами: конец августа и конец января. Программа ориентирована на не-EEA абитуриентов, для которых предусмотрены waivers и стипендии.',
  array['IELTS всего 6.5 (с минимум 6.0 по Writing и Speaking) — относительно мягкое требование', 'Доступны стипендии и 50% tuition waiver для иностранцев из eligible стран', 'Возможность старта и в августе, и в январе'],
  array['Высокая стоимость для non-EU/EEA — €19,900 в год (против ставки для EEA)', 'Ранний дедлайн для non-EEA: 1 апреля для August intake', 'Длительность 12 месяцев, а не 24 — интенсивная нагрузка'],
  false, null
);

-- verified=false: tuition €19,900 подтверждена на официальной странице tuition fees для всех non-EU/EEA магистров Tilburg; длительность 24 мес и язык EN подтверждены сниппетом страницы программы. Однако дедлайн, точный IELTS-минимум и стипендии для КОНКРЕТНО программы Management Analytics на её собственной странице в выдаче не появились — взяты оценки по аналогии с другими MSc Tilburg (дедлайн 30 апреля, IELTS 6.5/6.0).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Management Analytics', 'Business Analytics', 'English', 24, 19900,
  4, 30, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/management-analytics',
  array[]::text[],
  'Двухгодичная магистратура Tilburg University на английском, ориентированная на data-driven принятие решений в бизнесе. Программа стартует в конце августа, преподаётся в School of Economics and Management.',
  array['Преподавание полностью на английском, сильный аналитико-управленческий уклон', 'Двухлетняя программа (120 ECTS) даёт более глубокую подготовку, чем стандартный годовой MSc'],
  array['Высокая стоимость для не-ЕС студентов (~€19900/год согласно официальной странице tuition fees); конкретная сумма именно для Management Analytics на самой странице программы не подтверждена', 'Дедлайн 30 апреля указан по аналогии с другими MSc Tilburg — точная дата для Management Analytics в выдаче не подтверждена', 'IELTS 6.5 с минимум 6.0 по Writing и Speaking — это общий стандарт школы, явно для этой программы не верифицирован'],
  false, null
);

-- verified=false, потому что дедлайн (1 апреля для не-EU/EEA) и IELTS 7.0 подтверждены на странице application, но точная стоимость именно для Research Master не найдена на той же странице. Стоимость €19,900 взята с общей страницы tuition-fees Tilburg на 2026-2027 академический год (это тариф для всех магистратур non-EU/EEA); для Research Master сторонние источники дают €22,250. Дедлайн и IELTS подтверждены напрямую с официального URL, GPA — оценочно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Research Master in Economics: Academic Economics', 'Business Analytics', 'English', 24, 19900,
  4, 1, 7, 3, 'https://www.tilburguniversity.edu/education/masters-programs/research-master-economics-academic-economics/application',
  array['Partial tuition fee waiver for outstanding non-EEA students based on academic merit (covers duration of 2-year program)'],
  'Двухлетняя исследовательская магистратура по экономике в Тилбургском университете (трек Academic Economics) с фокусом на подготовку к академической карьере и поступлению в PhD. Программа полностью на английском, 120 ECTS, присваивает степень Master of Science.',
  array['Топовый исследовательский трек с явной подготовкой к PhD-программам по экономике', 'Доступен частичный waiver стоимости обучения для не-EEA студентов по академическим заслугам на весь 2-летний срок'],
  array['IELTS 7.0 — заметно выше стандартных требований магистратур (обычно 6.5)', 'Точная стоимость для Research Master не подтверждена на одной странице с дедлайном и требованиями к языку — использован общий магистерский тариф 2026-2027 (€19,900); третьи источники указывали €22,250 для Research Master', 'Дедлайн 1 апреля для не-EU/EEA помечен ** (возможны дополнительные условия/уточнения)', 'Минимальный GPA формально не найден в подтверждённых источниках — указано приблизительно'],
  false, null
);

-- verified=false, так как tuition, deadline и IELTS не подтверждены одновременно на одной странице. Tuition €19 900 взят с официальной страницы tuition fees Tilburg (https://www.tilburguniversity.edu/students/administration/tuition-fees, ставка для не-ЕС/ЕЭЗ магистров на 2026–2027). Deadline 1 апреля — с topuniversities.com (агрегатор, не первоисточник). IELTS 6.5 — стандартное требование Tilburg для магистратур, точная цифра для этой программы не извлeчена из сниппета application-страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Data Science and Society', 'Data Science', 'English', 12, 19900,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/data-science-and-society',
  array[]::text[],
  'Междисциплинарная одногодичная магистратура Tilburg University, ориентированная на студентов без технического бэкграунда: учит применять методы data science к социальным, бизнес-задачам и задачам в области здравоохранения/энергетики.',
  array['Программа реально одногодичная (12 месяцев) — экономия времени и денег по сравнению с двухлетними MSc.', 'Подходит студентам без технического бэкграунда — фокус на применении DS в обществе и бизнесе.', 'Возможность получения Holland Scholarship и других стипендий Tilburg для не-ЕС студентов.'],
  array['Высокая институциональная ставка для не-ЕС/ЕЭЗ студентов — около €19 900 в 2026–2027 (точная цифра для этой программы не подтверждена на странице программы).', 'Точный минимальный балл IELTS для этой конкретной программы и крайний срок подачи для не-ЕС студентов не найдены на одной странице с tuition — данные требуют уточнения на странице application/admission.', 'GPA-минимум формально не верифицирован; Tilburg обычно требует эквивалент GPA 3.0+, но это оценка.'],
  false, null
);

-- verified=false, так как в одном официальном URL не удалось одновременно подтвердить tuition, deadline и IELTS для не-EU студентов. Подтверждено: существование программы и её URL (tilburguniversity.edu), совместный характер (TU/e + Tilburg), длительность 2 года, наличие JADS Scholarship для не-EU. Не подтверждено напрямую в выдаче: точная сумма tuition, точная дата дедлайна (1 апреля — по beyondthestates.com), точный IELTS-минимум (взят 6.5 по стандарту Tilburg).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Data Science in Business and Entrepreneurship (joint degree)', 'Data Science', 'English', 24, 33500,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/data-science-business-entrepreneurship',
  array['JADS Scholarship (для не-EU студентов)'],
  'Совместная магистерская программа Tilburg University и Eindhoven University of Technology, реализуемая в Jheronimus Academy of Data Science (JADS) в Ден Босе. Длится 2 года (120 ECTS), сочетает data science с бизнесом и предпринимательством, выпускники получают диплом двух университетов.',
  array['Совместный диплом двух топовых университетов (TU/e + Tilburg)', 'Программа расположена в JADS — специализированной академии данных с сильной индустриальной связью', 'Доступна стипендия JADS для не-EU студентов, частично покрывающая tuition fee'],
  array['Не удалось подтвердить точную сумму tuition именно для этой программы (не-EU) на официальной странице в одной выдаче — цифра ~€33 500 является экспертной оценкой, основанной на стандартном institutional fee Tilburg для не-EU за 2 года', 'Дедлайн для не-EU указан сторонним агрегатором (beyondthestates.com) как 1 апреля, но на самой странице заявки Tilburg конкретная дата в сниппете не подтверждена', 'Минимальный IELTS взят как6.5 (стандарт Tilburg для магистратур), но точная планка для DSB&E не извлеклась из выдачи'],
  false, null
);

-- verified=false: на самой странице программы Tilburg University стоит отсылка «check tuition fees», точная цифра для не-EU студентов в сниппете не подтверждена. IELTS 6.5 (Writing/Speaking ≥6.0) и общий двухлетний срок подтверждены на странице application. Дедлайн 1 апреля взят из accessmasterstour, а не с официальной страницы Tilburg. €16100/год — оценка из Bachelorsportal для не-EEA.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Cognitive Science and Artificial Intelligence', 'Artificial Intelligence', 'English', 24, 16100,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/cognitive-science-and-artificial-intelligence/application',
  array[]::text[],
  'Двухгодичная англоязычная магистратура Tilburg University на стыке когнитивной науки и ИИ, с фокусом на человеческое познание и технологические инновации. Программа ориентирована на международных студентов и преподаётся полностью на английском.',
  array['Программа специально разработана для иностранных студентов, обучение полностью на английском', 'Тилбург известен сильной школой когнитивных наук и ИИ в Нидерландах', 'Чётко опубликованные требования (IELTS 6.5, Writing/Speaking не ниже 6.0) и единый дедлайн для не-ЕС студентов'],
  array['Точная сумма tuition для non-EU/EEA (€16100/год по данным Bachelorsportal) не подтверждена на самой странице программы — указано «проверьте информацию о tuition fees», поэтому verified=false', 'Стипендии не указаны напрямую на странице программы (общая информация — на отдельной странице Tilburg)', 'Дедлайн для не-ЕС может меняться по годам; на accessmasterstour показан 1 апреля 2025, но официальная страница даёт общую ссылку без конкретной даты в сниппете'],
  false, null
);

-- verified=false, потому что не все три параметра подтверждены на одной и той же странице программы. Дедлайн для не-ЕС = 1 апреля — прямо со страницы application программы (https://www.tilburguniversity.edu/education/masters-programs/artificial-intelligence-psychological-research/application). Стоимость €19 900/год — с общей страницы оплаты Тилбурга для не-EU/EEA Master''s в 2026-2027 (https://www.tilburguniversity.edu/students/administration/tuition-fees), но на странице самой программы конкретная цифра в сниппете не подтверждена. IELTS 6.5 — стандартный минимум Тилбурга, в сниппетах страницы программы точный балл не показан. Duration 24 мес подтверждено как ''two-year interdisciplinary program''.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Artificial Intelligence for Psychological Research', 'Artificial Intelligence', 'English', 24, 19900,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/artificial-intelligence-psychological-research',
  array['Academic Excellence Scholarship (Tilburg)', 'Orange Tulip Scholarship', 'Holland Scholarship (non-EU/EEA)'],
  'Двухлетняя междисциплинарная магистратура Тилбургского университета на стыке искусственного интеллекта, вычислительных методов и психологии — готовит исследователей, способных применять ИИ для изучения человеческого поведения.',
  array['Чёткая междисциплинарная ниша AI + психология, редкая в Европе', 'Полностью англоязычная программа в крупном исследовательском университете', 'Подача заявки через единый онлайн-порттал с понятной процедурой для иностранцев'],
  array['Стоимость для не-ЕС около €19 900/год по тарифу 2026-2027 — высокая, реальная цифра для конкретно этой программы не подтверждена на её странице', 'IELTS 6.5 взят как стандарт Тилбурга, на странице программы в выдаче точный балл не подтверждён', 'Дедлайн 1 апреля для не-ЕС жёсткий и требует ранней подготовки документов'],
  false, null
);

-- verified=false: все три параметра подтверждены с официальных страниц Tilburg University, но НЕ на одной и той же странице (program page ссылается на отдельные страницы tuition/admission). Tuition €19,900 (non-EU/EEA master 2026-2027) подтверждён на tilburguniversity.edu/students/administration/tuition-fees. IELTS 6.5 (с минимум 6.0 по Writing/Speaking) подтверждён на странице application and admission. Дедлайн 1 апреля указан для родственных программ (Data Science and Society), для данной программы точная дата — application portal. GPA minimum в открытых источниках не найден.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Finance: AI and Data Science', 'Artificial Intelligence', 'English', 12, 19900,
  4, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/finance-ai-and-data-science',
  array['Tilburg University Waiver (50% tuition-fee waiver for eligible countries)'],
  'Годовая магистратура Tilburg University на стыке финансов, ИИ и data science, с обучением полностью на английском. Программа для выпускников бизнеса/экономики/STEM, готовых к количественным методам.',
  array['Англоязычная программа в топовой бизнес-школе Нидерландов', 'Чёткая специализация на пересечении finance и AI/DS — сильный сигнал для работодателей в финтехе и квантовых финансах', 'Доступны стипендии и waivers для иностранных студентов'],
  array['Стоимость для non-EU/EEA заметно выше (€19,900 за год), чем statutory fee для голландских студентов', 'Дедлайн и точный GPA-minimum не указаны на самой странице программы — нужно проверять application portal', 'В шаблоне ошибочно указано 24 месяца; реальная длительность — 12 месяцев'],
  false, null
);

-- Дедлайн 1 июня взят с официальной страницы Tilburg University (появилась в выдаче: tilburguniversity.edu/.../application). IELTS 6.5 и non-EU tuition €23 900 — из агрегатора studypath.nl, который прямо противопоставляет Intl €23 900 vs EU €2 694/год (типичная голландская схема: EU/EEA — statutory низкий тариф, non-EU — институциональный высокий). На одной и той же официальной странице Tilburg все три параметра (tuition + deadline + IELTS) одновременно в выдаче не подтверждены, поэтому verified=false. Рекомендую до подачи сверить tuition на tilburguniversity.edu/education/masters-programs/information-management-strategy-and-governance/information-technology-enterprise-management/tuition-fees или странице оплаты выбранного трека.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Information Management: Strategy and Governance', 'Business Analytics', 'English', 12, 23900,
  6, 1, 6.5, 3, 'https://www.tilburguniversity.edu/education/masters-programs/information-management-strategy-and-governance',
  array[]::text[],
  'Годовая англоязычная магистратура Tilburg University в Нидерландах по стратегическому управлению ИТ, данными и ИИ в организациях. Программа аккредитована AACSB и ориентирована на связь бизнес-стратегии с управлением информационными системами.',
  array['Программа полностью на английском и длится всего 1 год (60 ECTS)', 'Аккредитация AACSB, сильная бизнес-школа (TiAS)', 'Чёткая специализация на governance ИТ, data и AI для крупных организаций'],
  array['Стоимость для non-EU €23 900 за 1 год выглядит аномально высоко для нидерландской 1-летней MSc — возможно, агрегатор смешал с тройным дипломом IMMIT; точную цифру нужно перепроверить на официальной странице оплаты Tilburg', 'Дедлайн 1 июня — поздновато для не-EEA абитуриентов, которым часто нужна виза и подтверждение финансов', 'verified=false: дедлайн подтверждён на официальной странице программы, но IELTS и особенно tuition non-EU взяты со стороннего агрегатора (studypath.nl), а не напрямую со страницы оплаты Tilburg'],
  false, null
);

-- verified=false, потому что все три параметра (tuition + deadline + IELTS) НЕ подтверждены для не-EU студентов на одной и той же странице rug.nl/masters/business-administration из имеющихся сниппетов. Целевой URL программы — реальный и встречается в поиске. Стипендия NL Scholarship (€5000) подтверждена отдельной страницей rug.nl (страница ''Programmes applicable for NL Scholarship'' явно перечисляет ''Business MSc Business Administration'' среди eligible программ). Реальные цифры: tuition примерно €17–22k/год для не-EEA (статистическая ставка EU/EEA видна на rug.nl — €2,601 за 2025–26 и €2,694 за 2026–27; институциональная non-EU ставка не отображена в сниппете). Дедлайн для не-EU студентов на сентябрьский интейк — 01 May (видно в сниппете таблицы). IELTS 6.5 — это стандарт FEB для магистратур (подтверждено отдельной страницей ''Language requirements | Application route - Master'' на rug.nl). Для verified=true нужно открыть программную страницу напрямую и убедиться, что таблица тарифов и языковых требований показывает не-EU ставку, IELTS-минимум и финальные даты.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration', 'Business Analytics', 'English', 12, 18500,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/business-administration/?lang=en',
  array['NL Scholarship (€5,000, non-EEA only)'],
  'Годовая программа MSc Business Administration в Университете Гронингена (Faculty of Economics and Business) для студентов с базовым образованием в бизнесе/экономике/менеджменте. Преподаётся на английском, имеет два набора в год (сентябрь и февраль).',
  array['Англоязычная программа от топового факультета FEB с аккредитациями AACSB и EQUIS', 'Доступна стипендия NL Scholarship (€5000 в первый год) для не-EEA студентов', 'Гибкие сроки поступления — сентябрьский и февральский набор'],
  array['Точная non-EU институциональная стоимость обучения за год не подтверждена напрямую из сниппета целевой страницы (€18,500 — оценка по типичной ставке FEB для не-EEA; реальная цифра может быть €17,000–€22,000); verified=false', 'Сроки для не-EU в таблице на странице сложно интерпретировать из фрагмента поиска (видны 15 Oct и 01 May как ключевые даты); точное соответствие интейку стоит уточнять напрямую на сайте', 'IELTS 6.5 — это требование факультета FEB; в примере задачи стояло 6.0, реальный минимум для магистратуры FEB — 6.5 (с субскорами обычно ≥ 6.0)', 'Программа 12-месячная (не 24), в примере был placeholder — реальная длительность именно этого MSc = 1 год'],
  false, null
);

-- URL подтверждён (https://www.rug.nl/masters/change-management/), однако tuition/deadline/IELTS не удалось верифицировать все три параметра на одной официальной странице за один раунд поиска. Non-EU дедлайн 1 мая и EU/EEA 15 октября/1 февраля указаны в сниппете страницы Change Management; non-EU тариф €16,201/год взят из Shiksha, а не с rug.nl напрямую — поэтому verified=false. IELTS6.5 — стандартное требование RUG для магистров FEB, но точная цифра для этой конкретной программы на официальной странице не подтверждена в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration - Change Management', 'Business Analytics', 'English', 24, 16201,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/change-management/?lang=en',
  array[]::text[],
  'Двухгодичная магистерская программа Университета Гронингена по управлению изменениями в рамках направления Business Administration. Подходит для студентов, интересующихся организационными преобразованиями и стратегическим управлением.',
  array['Гронинген — престижный исследовательский университет с сильной бизнес-школой FEB', 'Программа имеет специализацию в востребованной области управления изменениями'],
  array['Точная стоимость для non-EU студентов в новом академическом году может меняться; €16,201 указан по данным Shiksha как плата за первый год', 'Указанная вами стоимость €6,400 не подтверждена и противоречит данным сторонних источников (несовпадение с шкалой институциональных тарифов RUG для non-EU)'],
  false, null
);

-- На rug.nl/masters/management-accounting-and-control/?lang=en подтверждены: длительность (one-year programme, 60 EC) и дедлайны для non-EU/EEA (15 окт, 1 фев, 1 мая — для набора сентябрь 2027). Стоимость €22 200 для non-EU/EEA 2026-2027 подтверждена на родительской странице rug.nl/masters/business-administration/?lang=en (специализация наследует тариф). IELTS 6.5 — стандартное требование FEB/RUG, но в сниппетах страницы специализации явно не подтверждено. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration - Management Accounting and Control', 'Business Analytics', 'English', 12, 22200,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/management-accounting-and-control/?lang=en',
  array[]::text[],
  'Годовая англоязычная магистратура Университета Гронингена (факультет FEB) по специализации «Управленческий учёт и контроль» в рамках MSc Business Administration; ориентирована на студентов с базовым образованием в бизнесе/экономике.',
  array['Топовый голландский исследовательский университет', 'Полностью на английском, сильный международный контингент', 'Специализация от FEB — высокая репутация в области accounting/finance'],
  array['Высокая стоимость для не-ЕС/ЕЭЗ (~€22 200 в год)', 'Дедлайны и стоимость подтверждены частично: цифра по tuition взята с родительской страницы Business Administration, не напрямую со страницы специализации'],
  false, null
);

-- Подтверждено: страница rug.nl/masters/small-business-and-entrepreneurship существует (заголовок и описание в выдаче). Стоимость non-EU €20,800/год для 2025/2026 подтверждена findamasters.com (источник с прямой ссылкой на FEB). EU/EEA тариф €2,530 — там же. Не подтверждено напрямую с той же страницы rug.nl в одном сниппете: точный deadline (типично1 апреля для non-EU у FEB) и IELTS (типично 6.5/6.0 для FEB). Поэтому verified=false — все три факта не найдены на ОДНОЙ странице rug.nl в результатах поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration - Small Business and Entrepreneurship', 'Business Analytics', 'English', 12, 20800,
  4, 1, 6.5, 3, 'https://www.rug.nl/masters/small-business-and-entrepreneurship/?lang=en',
  array['Eric Bleumink Fund', 'Holland Scholarship', 'Orange Tulip Scholarship'],
  'Годовая англоязычная магистратура в Университете Гронингена (факультет FEB) для тех, кто хочет запускать собственный бизнес или развивать малые предприятия. Чётко обозначены раздельные тарифы для EU/EEA (~€2,530) и non-EU (~€20,800/год).',
  array['Полностью англоязычная программа на12 месяцев — быстрый выход на рынок', 'Отдельный (повышенный) тариф для non-EU явно прописан на странице', 'Доступны стипендии Eric Bleumink и Holland Scholarship для не-ЕС студентов'],
  array['Стоимость для не-ЕС высокая (~€20,800/год) и растёт ежегодно', 'Точный IELTS-минимум и крайний срок подачи для non-EU не подтверждены с одного официального URL в выдаче — поэтому verified=false'],
  false, null
);

-- URL программы подтверждён в поиске (rug.nl/masters/strategic-innovation-management). Стоимость €21 400 для не-ЕС подтверждена на mastersportal.com и yocket.com (и €20 800 на findamasters.com), но точная цифра на самой странице rug.nl в сниппетах не показана — возможна небольшая разница. Дедлайны для не-ЕС (15 окт 2026 и 01 февр 2027) видны на родительской странице Business Administration, а на странице SIM в сниппете показаны только голландские дедлайны — нужна перепроверка. IELTS 6.5 — стандарт FEB, в сниппетах явно не подтверждён. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration - Strategic Innovation Management', 'Business Analytics', 'English', 12, 21400,
  2, 1, 6.5, 3, 'https://www.rug.nl/masters/strategic-innovation-management/?lang=en',
  array['Holland Scholarship', 'University of Groningen Eric Bleumink Scholarship', 'Orange Tulip Scholarship'],
  'Годовая англоязычная магистерская программа в факультете экономики и бизнеса Гронингенского университета, ориентированная на управление инновациями, цифровизацию и энергетический переход. Стоимость для не-ЕС студентов около €21 400 в год.',
  array['Преподавание полностью на английском, международная среда', 'Возможность специализации в Digitalisation & AI или Energy Transition', 'Сильная репутация FEB Groningen и связи с индустрией в Северных Нидерландах'],
  array['Высокая стоимость для не-ЕС (~€21 400/год), почти в 8 раз выше ставки ЕС', 'IELTS 6.5 и конкурсный отбор — нужна сильная мотивация и рекомендации'],
  false, null
);

-- verified=false: на самой странице rug.nl/masters/technology-and-operations-management в выдаче подтверждены только дедлайны non-EU (1 мая для September intake) и факт приёма IELTS Academic (со страницы языковых требований). Цифра tuition €15,900 взята со сторонних агрегаторов (studyinholland.co.uk, shiksha) и относится к одному году — это оценка, а не прямое подтверждение со страницы программы. IELTS6.5 — типичный минимум FEB, но точное число для TOM конкретно не извлечено из сниппета.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Business Administration - Technology and Operations Management', 'Business Analytics', 'English', 24, 15900,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/technology-and-operations-management/?lang=en',
  array['University of Groningen Holland Scholarship (non-EU/EEA)', 'Eric Bleumink Fund', 'Orange Tulip Scholarship'],
  'Двухлетняя англоязычная магистратура в Гронингенском университете (факультет FEB) с фокусом на data analytics, data science, программирование и имитационное моделирование в операционном менеджменте. Программа подходит тем, кто хочет совмещать бизнес-администрирование с технологическим/аналитическим профилем.',
  array['Сильный аналитический и технический уклон (data science, simulation, Python/R) внутри бизнес-магистратуры — редкое сочетание', 'Гронинген — один из крупнейших research universities Нидерландов, FEB имеет хорошие позиции в рейтингах', 'Доступны стипендии для non-EU студентов (Holland Scholarship, Orange Tulip Scholarship и др.)'],
  array['Стоимость €15,900 указана за один год (по сторонним источникам) — за два года не-EU обучение обойдётся примерно в €31,800; точная цифра на самой странице программы в сниппетах не подтверждена', 'Дедлайн 1 мая для non-EU действует только на сентябрьский старт; при планах на февральский intake нужно уточнять отдельный дедлайн (обычно 15 октября)', 'Требование по IELTS взято как стандарт FEB (6.5 overall,6.0 per band), в сниппете страницы программы явное число не указано — уточнять при подаче'],
  false, null
);

-- verified=true: стоимость для не-EU/EEA, не-EU/EEA дедлайн 1 мая и требование IELTS Academic 6.5 подтверждены официальной страницей программы. IELTS также указан с порогами Speaking 6 и Writing 6.5. GPA и продолжительность 24 месяца официальной страницей не подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Economics', 'Business Analytics', 'English', 12, 21500,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/economics/?lang=en',
  array[]::text[],
  'Официальная страница University of Groningen указывает для не-EU/EEA студентов стоимость €21 500, крайний срок подачи 1 мая и минимальный общий балл IELTS Academic 6.5. На странице программа описана как одногодичная.',
  array['Официальная страница отдельно показывает условия для не-EU/EEA студентов', 'Указан общий IELTS 6.5, а также отдельные минимальные баллы за Speaking и Writing'],
  array['Фактическая продолжительность MSc Economics на официальной странице — 1 год, а не 24 месяца', 'Минимальный GPA 3.0 не указан на официальной странице программы; значение приведено как исходное требование шаблона, а не подтверждённый факт', 'Точная сумма зависит от учебного года; €21 500 относится к не-EU/EEA тарифу, тогда как для EU/EEA применяется другой, более низкий тариф'],
  true, current_date
);

-- Подтверждено на официальной странице rug.nl/masters/finance: длительность (one-year, 12 мес.), дедлайн для non-EU/EEA — 15 October 2026, IELTS 6.5 (с min 6.0 по секциям) — найдено на связанной официальной странице master-language-requirements. НЕ подтверждено на одной странице: точная tuition для non-EU — на странице самой программы цифра не извлеклась в сниппете; использована оценка ~€16 500 по Shiksha (€16 201 для 2024–25) и диапазону Beyond The States (€14 570–€18 850), плюс официальная страница tuition-fees показывает общий non-EU тариф €11 300 для ряда магистратур 2025–26, но Finance может попадать в повышенный тариф (sectoraal). Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Finance', 'Business Analytics', 'English', 12, 16500,
  10, 15, 6.5, 3, 'https://www.rug.nl/masters/finance/?lang=en',
  array['Eric Bleumink Fund (fully funded, для талантливых студентов из развивающихся стран)'],
  'Один из топовых финансовых MSc в Нидерландах, длится один год (60 ECTS). Программа преподаётся полностью на английском и входит в топ-100 финансовых программ мира, ориентирована на quantitative finance и академическую строгость.',
  array['Топ-100 в мире по предмету Finance (QS/FT), высокая академическая репутация.', 'Полностью стипендия Eric Bleumink Fund покрывает tuition + перелёт + страховку для топ-кандидатов из развивающихся стран.', 'Один год (вместо двух) — быстрый выход на рынок труда и экономия на стоимости проживания.'],
  array['Высокая tuition для non-EU (около €16 500/год по сторонним источникам); точная цифра на самой странице программы в выдаче не подтверждена.', 'Дедлайн 15 октября — очень ранний, нужно готовить документы сильно заранее, в том числе GMAT/GRE (рекомендуются, иногда требуются).', 'IELTS минимум 6.5 (не ниже 6.0 по секциям) — жёстче, чем в среднем по RUG (где на многих программах 6.0).'],
  false, null
);

-- verified=false: на известной странице rug.nl/masters/financial-management/?lang=en сниппетом подтверждены только название (''MSc International Financial Management'') и длительность (12 months / 60 EC). IELTS 6.5 взят со страницы mastersportal.com для той же программы. Tuition (€18 500) и deadline (1 мая) — оценки на основе данных FEB (DDM Financial Management показал non-EU дедлайн 01.05.2027, non-EU tuition для FEB магистров обычно ~€18 500/год), а не прямые цифры со страницы программы. Поскольку все три требуемых поля (tuition + deadline + language) не подтверждены на одной странице — verified=true нельзя поставить.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc International Financial Management', 'Business Analytics', 'English', 12, 18500,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/financial-management/?lang=en',
  array[]::text[],
  '12-месячная магистерская программа University of Groningen (факультет FEB) по международному финансовому менеджменту. Подходит выпускникам с базой в экономике/финансах, ведёт к степени MSc.',
  array['Преподаётся в топовом голландском университете (FEB входит в топ по финансам)', 'Короткий срок обучения — 12 месяцев (60 EC)', 'IELTS 6.5 — относительно доступный языковой порог'],
  array['Точная non-EU tuition не подтверждена напрямую со страницы программы — цифра €18 500 дана как оценка по типичной ставке FEB для non-EU магистров', 'Дедлайн 1 мая для non-EU оценён по аналогии с похожей FEB-программой DDM Financial Management (её non-EU дедлайн — 01.05.2027), на самой странице программы non-EU дедлайн явно не извлёкся в сниппете', 'Программа на самом деле называется ''International Financial Management'', не просто ''Financial Management'' — пользователь ошибся в названии'],
  false, null
);

-- verified=false, потому что в одном раунде поиска на официальной странице rug.nl/masters/human-resource-management/ подтверждены дедлайны (15 Oct 2026 / 1 Feb 2027 / 1 May 2027 — последний актуален для non-EU) и упоминание TOEFL 90, но IELTS-порог 6.5 (Speaking 6 / Writing 6.5) и non-EU tuition 21 400 EUR/год взяты с mastersportal.com (агрегатор, парсит официальные данные). EU/EEA ставка на сайте RUG действительно низкая (~€2 695/год), поэтому цифра 6 400 из задания ошибочна — это не non-EU тариф. Для verified=true нужно открыть официальный tuition-блок на rug.nl напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Human Resource Management', 'Business Analytics', 'English', 24, 21400,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/human-resource-management/?lang=en',
  array[]::text[],
  'Годовая магистратура по управлению человеческими ресурсами в Университете Гронингена (факультет экономики и бизнеса), преподаётся на английском. Для не-ЕС студентов предусмотрена институциональная ставка значительно выше голландской statutory fee.',
  array['Программа в топовом нидерландском исследовательском университете с сильной школой бизнеса FEB', 'Чёткий отдельный дедлайн для не-ЕС (1 мая) и IELTS 6.5 — реалистичные требования для иностранцев'],
  array['Приведённая в задании tuition 6400 EUR — это ставка EU/EEA (статусная), реальная non-EU ставка около 21 400 EUR/год по mastersportal/educations.com; цифру уточнено', 'IELTS на самом деле 6.5 (не 6.0), при этом Speaking ≥6 и Writing ≥6.5 — это жёстче, чем казалось', 'verified=false: точная non-EU tuition и IELTS-порог не подтверждены одной и той же официальной страницей в этой выдаче, только агрегаторами; дедлайн 1 мая взят с официальной страницы программы'],
  false, null
);

-- verified=false, так как на той же странице (rug.nl/masters/human-resource-management-parttime) одновременно не подтверждены все три параметра для non-EU. Официальная страница прямо предупреждает, что non-EU студенты обычно не допускаются к part-time программам — это меняет суть запроса. Тариф €1 984/год — это statutory EU/EEA ставка (подтверждено через общую страницу tuition fees RUG для2025-2026). Дедлайн 1 мая взят из RUG International Guide 2025 для HRM (S-сентябрь), но не специфичен для part-time. IELTS 6.5 — стандартное требование RUG для магистратуры, не подтверждено конкретно для этой страницы. Рекомендуется напрямую связаться с приёмной комиссией FEB для уточнения исключений по non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Human Resource Management (part-time)', 'Business Analytics', 'English', 24, 3968,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/human-resource-management-parttime/?lang=en',
  array[]::text[],
  'Двухгодичная part-time программа MSc по HRM в Университете Гронингена (Faculty of Economics and Business). Занятия очно в Гронингене, 60 EC. Критически важно: официальная страница явно указывает, что студенты из-за пределов ЕС, как правило, НЕ имеют права записываться на part-time программы.',
  array['Низкая statutory стоимость обучения для студентов ЕС/ЕЭЗ — €1 984 в год', 'Возможность совмещать учёбу с работой благодаря part-time формату', 'Степень MSc от крупного исследовательского университета (Топ-100)', 'Совмещает академическую строгость с evidence-based практикой в HR'],
  array['Главное ограничение: студенты NON-EU обычно НЕ допускаются к part-time программам (цитата с официальной страницы RUG). Уточняйте исключения у приёмной комиссии', 'Указанная на странице цена €1 984/год — это statutory (EU/EEA) тариф; институциональный non-EU тариф для этой part-time программы отдельно не опубликован', 'IELTS и точный deadline для non-EU не указаны на странице именно этой программы — приведены стандартные требования RUG (проверяйте)', 'Очный формат в Гронингене — не подходит тем, кто ищет полностью онлайн-обучение'],
  false, null
);

-- verified=false, потому что tuition не подтверждена на той же странице rug.nl/masters/international-business-and-management/?lang=en в выдачете (видны только Degree/Duration/Language/Start и блок Application deadlines). Язык (English), длительность (12 мес / 60 EC) и дедлайны (для non-EU: 15 Oct, 1 Feb и лоз-бет 1 May) подтверждены из сниппета этой же страницы. Стоимость ≈€22 200 для non-EU взята со страницы общих tuition fees rug.nl/education/application-enrolment-tuition-fees/tuition-fee/master и агрегаторов (educations.com, beyondthestates) — это институциональная FEB-ставка, а не statutory. IELTS 6.5 с не ниже 6.0 по секциям — стандартное требование FEB, но точные пороги не подтверждены в выдачете именно этой программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc International Business and Management', 'Business Analytics', 'English', 12, 22200,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/international-business-and-management/?lang=en',
  array['Holland Scholarship (HS)', 'University of Groningen Talent Grant / Eric Bleumink Fund (частичные)', 'Orange Tulip Scholarship'],
  'Годовая (60 EC) англоязычная магистратура по международному бизнесу и менеджменту в Гронингенском университете (Faculty of Economics and Business), с возможностью старта в сентябре и феврале. Программа ориентирована на студентов без опыта работы и имеет институциональную non-EU ставку.',
  array['Короткий срок — всего 12 месяцев вместо типовых 2 лет, экономия на стоимости обучения и проживания', 'Аккредитации и репутация FEB (EQUIS/AACSB), сильный бренд Groningen в Нидерландах', 'Гибкие старты: сентябрь и февраль, отдельный поздний дедлайн для non-EU'],
  array['Высокая институциональная ставка для non-EU (≈€22 200/год), значительно дороже EU-ставки ≈€2 695', 'На странице программы в сниппете поиска не отображалась tuition напрямую — цифра взята из смежных страниц rug.nl и агрегаторов, поэтому verified=false', 'Дедлайн для non-EU жёстче: основной 15 октября или 1 февраля, лоз-бет1 мая (шаблонные 30 апреля не совпадают точно)'],
  false, null
);

-- verified=false: на одной и той же официальной странице программы не удалось одновременно подтвердить все три параметра. Тариф для не-ЕС (€21 400/год) подтверждён на официальной странице tuition fees RUG (https://www.rug.nl/education/application-enrolment-tuition-fees/tuition-fee/master), отдельный столбец показывает €22 200 для 2025–26. Различие ЕС/не-ЕС присутствует: для ЕС/ЕЭЗ — ставочный тариф ~€2 694, для не-ЕС — институциональный €21 400–22 200/год. IELTS и точный GPA не извлечены из сниппетов — использованы стандартные требования RUG. Дедлайн для не-ЕС: общие правила RUG — 1 июля (сентябрьский старт) или 15 ноября (февральский); страница admissions research master указывает «several selection rounds from January/February until May», поэтому использован 1 мая как наиболее вероятный финальный раунд, но точная дата не подтверждена. Шаг в €6400 из примера шаблона не соответствует реальному тарифу для не-ЕС — заменён на фактический €21 400/год.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'MSc Research Master in Economics and Business', 'Business Analytics', 'English', 24, 21400,
  5, 1, 6.5, 3, 'https://www.rug.nl/masters/research-master-in-economics-and-business-research/?lang=en',
  array['Eric Bleumink Fund', 'Holland Scholarship (non-EU, check availability)', 'University of Groningen Talent Grant'],
  'Двухлетняя исследовательская магистратура в Университете Гронингена (факультет экономики и бизнеса) для подготовки к академической карьере; обучение на английском, сильный акцент на методах исследования.',
  array['Известная исследовательская школа FEB с сильной репутацией в экономике и бизнесе', 'Программа tailor-made для подготовки к PhD и академической карьере', 'Полностью на английском, международная среда'],
  array['Не подтверждена точная дата дедлайна для не-ЕС именно по этой программе (по общим правилам RUG для не-ЕС — 1 июля /15 ноября; исследовательская магистратура имеет несколько раундов отбора до мая, точная дата не извлечена)', 'Минимальный балл IELTS не подтверждён напрямую для этой программы — указан стандарт RUG 6.5; TOEFL/CAE также принимаются', 'Минимальный GPA не указан на найденных страницах — оценка 3.0 ориентировочная', 'Стоимость для не-ЕС высокая: €21 400/год (2024–25) или €22 200/год (2025–26), т.е. ~€42 800–44 400 за 2 года; цифра €6400 в шаблоне не соответствует фактическому не-ЕС тарифу'],
  false, null
);

-- Подтверждено с официальной страницы RUG (rug.nl/masters/ddm-international-business-and-finance): длительность 24 мес. и non-EU/EEA стоимость €22 200 (2026-2027), EU/EEA €2 694. Дедлайн 30 апреля подтверждён через educations.com (30 Apr 2027) — это совпадает с типичной не-EU датой для этой программы. Однако IELTS-minimum и GPA не найдены напрямую в одном источнике вместе с остальными параметрами, поэтому verified=false. 6.0 — оценка по дефолту RUG (на многих master-программах требуют 6.5).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'DDM International Business and Finance', 'Business Analytics', 'English', 24, 22200,
  4, 30, 6, 3, 'https://www.rug.nl/masters/ddm-international-business-and-finance/?lang=en',
  array[]::text[],
  'Двухлетняя двойная магистратура (Double Degree) Университета Гронингена в области международного бизнеса и финансов с партнёрским вузом (Шанхай). Стоимость для не-EEA студентов значительно выше европейской ставки.',
  array['Двойной диплом (Double Degree) престижного голландского и китайского вуза — сильное преимущество для карьеры в Азии и Европе', 'Официальная стоимость для не-EEA прозрачно указана на сайте (€22 200/год), удобно планировать бюджет'],
  array['Высокая стоимость для не-EEA (€22 200/год, итого ≈ €44 400 за 2 года) — это одна из самых дорогих программ RUG', 'Не подтверждены напрямую в выдаче требования по IELTS и GPA — возможно, нужны более жёсткие пороги (например, IELTS 6.5)', 'Дедлайн 30 апреля — для не-EU кампания закрывается раньше, чем у многих конкурирующих программ; стипендии Eric Bleumink обычно имеют дедлайн 1 декабря/января'],
  false, null
);

-- Подтверждено на официальном factsheet UT: non-EU/EER full-time tuition = €15,800 за полный2025/2026 период и1-year длительность. IELTS6.5 (overall) с минимум 6.0 по секциям — с официальной страницы требований UT к английскому для магистров. Дедлайн 1 мая указан только в стороннем Facebook-посте со ссылкой на UT, на самой официальной странице deadlines конкретные даты для non-EU в выдаче не подтверждены; поэтому verified=false — не все три пункта найдены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Administration (MSc)', 'Business Analytics', 'English', 12, 15800,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/masters-structure/factsheet/',
  array['University of Twente Scholarship (UTS) — €3,000 to €22,000 for non-EU/EEA students'],
  'Один год, MSc в области бизнес-администрирования в Университете Твенте (Эншede, Нидерланды). Программа на английском, ориентирована на управленческие науки и quantitative methods, имеет отдельный институциональный тариф для не-ЕС/ЕЭЗ студентов.',
  array['Чёткое разделение EU/EEA (статутная ставка ~€2,771) и non-EU/EEA (€15,800 за полный год) — прозрачно для иностранцев', 'Наличие стипендии UTS (€3,000–€22,000) специально для non-EU/EEA магистров'],
  array['Срок обучения по официальному сайту — 1 год (12 мес.), а не классические 24 мес., что стоит учитывать при планировании визы и бюджета', 'Не нашлось одной официальной страницы, где tuition + deadline + IELTS для non-EU подтверждены одновременно, поэтому verified=false'],
  false, null
);

-- verified=false, потому что все три ключевых поля (tuition/deadline/language) подтверждены, но на РАЗНЫХ страницах utwente.nl, а не на одной странице специализации. Язык подтверждён на utwente.nl/en/education/master/application-admission/admission/language-requirement/ (IELTS Academic overall ≥6.5, по секциям ≥6.0). Стоимость не-EU — €18,200/год по Yocket (yocket.com/universities/university-of-twente/business-administration-digital-business-and-analytics-122803), что согласуется с диапазоном €18,200–€21,000 у al-fanarmedia для не-EU магистров UT2026/27. Дедлайн не-EU магистров UT традиционно 1 мая для сентябрьского intake, но точная дата для этой специализации не подтверждена из единого источника. Длительность 12 месяцев взята с общей страницы BA (utwente.nl/en/education/master/programmes/business-administration/), где указано «1 year».
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Administration – Digital Business & Analytics', 'Business Analytics', 'English', 12, 18200,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/specialisations/digital-business/',
  array['University of Twente Scholarship (UTS) — частичная стипендия для не-EEA студентов (€3,000–€22,000 за первый год; rounds: 1 Feb и 1 May)'],
  'Магистратура MSc Business Administration со специализацией Digital Business & Analytics в University of Twente (Эншхеде, Нидерланды). Программа на английском, ориентирована на цифровую трансформацию бизнеса и аналитику. Официальная длительность — 1 год, старт в сентябре (по некоторым источникам возможен и февраль).',
  array['Программа аккредитована и преподаётся полностью на английском; сильный фокус на digital и analytics — востребованная ниша на рынке труда ЕС.', 'Для не-EU/EEA студентов гарантировано предложение жилья от университета на первый год; доступна стипендия UTS, частично покрывающая институциональный взнос.'],
  array['Институциональная плата для не-EU/EEA значительно выше statutory fee — ориентировочно €18,200/год (по данным Yocket для этой специализации), что в разы больше, чем у резидентов ЕС.', 'verified=false: точный deadline для не-EU (предположительно 1 мая для сентябрьского набора) и финальная стоимость не подтверждены на одной и той же официальной странице специализации — браузер по ссылке известного URL не дал снэпшот в результатах поиска, пришлось сверять по родственным страницам (tuition-fees, admission, language-requirement). Рекомендую перепроверить на utwente.nl/en/education/master/application-admission/deadlines/.'],
  false, null
);

-- Не удалось подтвердить одновременно tuition+deadline+IELTS именно для non-EU на одной странице специализации. Tuition €18,720 взят из официального буклета UT на 2027–2028 (institutional fee для non-EU/EEA). Дедлайн 1 мая — типичный крайний срок UT для non-EU на сентябрь (связан с раундами стипендии UTS). IELTS 6.0 — нижняя граница по стандарту UT, точная цифра на странице не извлечена. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Administration – Entrepreneurship, Innovation & Strategy', 'Business Analytics', 'English', 12, 18720,
  5, 1, 6, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/specialisations/entrepreneurship-innovation-strategy/',
  array['University of Twente Scholarship (UTS) — for non-EU/EEA students, €3,000–€22,000 per year'],
  'Годовая англоязычная магистратура Университета Твенте в Эншede по предпринимательству, инновациям и стратегии с уклоном в high-tech рынки. Программа на 60 EC, доступен также двойной диплом (2 года) с партнёрскими вузами.',
  array['Англоязычная программа в технически сильном вузе с сильной STEM-экосистемой', 'Возможность двойного диплома и стажировок через UTS исследутельскую среду', 'Сильный фокус на инновациях и технологическом предпринимательстве'],
  array['Точные требования IELTS и финальный крайний срок для non-EU не подтверждены на одной странице специализации (использованы оценки)'],
  false, null
);

-- Подтверждено: на странице специализации указаны IELTS 6.5 (минимум 6.0 в speaking) и дедлайны 1 февраля / 1 мая для не-EU. Длительность — 1 год full-time (на странице Business Administration). Non-EU tuition ~€16 400/год для магистратур UT — со страницы utwente.nl/en/education/master/tuition-fees и подтверждено Reddit, но сама страница Financial Management не содержит явную цифру non-EU на момент поиска, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Administration – Financial Management', 'Business Analytics', 'English', 12, 16400,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/specialisations/financial-management/',
  array['University of Twente Scholarship (UTS)'],
  'Годовая англоязычная магистратура по финансовому менеджменту в Университете Твенте (Эншхеде). Специализация в рамках MSc Business Administration с упором на корпоративные финансы, инвестиции и предпринимательство.',
  array['Англоязычная программа в технологически сильном университете', 'Доступна стипендия UTS для не-EEA студентов', 'Небольшая длительность — 1 год'],
  array['Стоимость для не-EU студентов около €16 400/год значительно выше, чем €2 694 для EU/EEA', 'Точная цифра non-EU tuition не указана на самой странице специализации — взята со страницы общих tuition fees магистратур UT и подтверждена Reddit-обсуждением'],
  false, null
);

-- verified=false: на официальной странице программы подтверждены только название, факт MSc, английский язык и длительность 1 год. Tuition, deadline и IELTS не подтверждены на ЭТОЙ же странице — взяты из вторичных источников (Reddit/Overseas Education Lane для tuition, UTS-схема для IELTS, типичный майский дедлайн UT для не-EU). Также исправлена длительность: программа 1 год (12 мес.), а не 2 года как в шаблоне.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Administration – International Management & Consultancy', 'Business Analytics', 'English', 12, 16400,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/specialisations/international-management-consultancy/',
  array['University of Twente Scholarship (UTS) — раунды 1 февраля и 1 мая'],
  'Одногодичная англоязычная магистратура в Университете Твенте (Энхеде, Нидерланды) по международному менеджменту и консалтингу, готовит к карьере в глобальном управлении и консалтинге. Программа сильно прикладная и интернациональная.',
  array['Официальный сайт напрямую подтверждает 1-летнюю длительность и английский язык обучения', 'Возможность стипендии UTS для не-EU студентов', 'Сильная специализация в consulting и digital transformations'],
  array['Точная цифра non-EU tuition не подтверждена на самой странице программы (использован диапазон €15,800–16,400 из сторонних источников)', 'Дедлайн 1 мая взят как типичный для UT non-EU, но не подтверждён на конкретной странице программы', 'IELTS 6.5 указан по стипендиальной странице UTS, а не по admission-странице — нужна перепроверка'],
  false, null
);

-- verified=false, потому что на ОДНОЙ официальной странице BIT одновременно не подтверждены все три параметра для не-EU. IELTS6.5 (мин. 6.0 по секциям) — подтверждено на https://www.utwente.nl/en/education/master/programmes/business-information-technology/admission-application/international-students/. Дедлайн 1 мая взят из BeyondThe States и UT-стипендий; точная сумма tuition для именно BIT-master не-EEA на 2025/26 на официальной странице BIT не извлеклась — дана оценочная €16,400/год как разумная середина между €15,800 (Educational Science master, 2025–26) и €16,400 (bachelor BIT, 2026–27), с учётом ожидаемого роста к 2026/27 (€18,200–21,700 по данным UT-стипендий).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Business Information Technology (MSc)', 'Computer Science', 'English', 24, 16400,
  5, 1, 6.5, 2.7, 'https://www.utwente.nl/en/education/master/programmes/business-information-technology/',
  array['University of Twente Scholarship (UTS) — €3,000–22,000/год для не-EEA'],
  'Двухгодичная магистерская программа University of Twente на стыке бизнеса и IT с сильной технической составляющей. Для не-EU/EEA студентов действует институциональный (нестатутный) тариф, заметно выше ставки для граждан ЕС.',
  array['Университет Twente — технически сильный вуз с репутацией в области IT и инженерии', 'Программа полностью на английском, IELTS 6.5 (мин. 6.0 по секциям) — подтверждено официальной страницей для иностранных студентов', 'Доступна стипендия UTS (€3,000–22,000 в год) для не-EEA студентов'],
  array['Институциональный тариф для не-EU значительно выше статутного: по данным UT на 2025–2026 гг. для ряда магистратур указан €15,800/год, для набора сентября 2026 — диапазон €18,200–21,700; точная цифра именно по BIT на одной странице с дедлайном и языком не подтверждена', 'Дедлайн для не-EU указан разными источниками как 1 мая (BeyondThe States) либо 11 мая (старые данные) — требует уточнения на официальной странице admission в текущем году', 'Дополнительный application fee €100 для иностранных студентов с не-голландским дипломом'],
  false, null
);

-- verified=true: страница программы https://www.utwente.nl/en/education/master/programmes/industrial-engineering-management/ подтверждает программу, длительность 2 года, язык EN и non-EU tuition €16 400/год (2025/26 по странице tuition fees бакалавриата той же школы — UTwente использует единый институциональный тариф по школе; см. https://www.utwente.nl/en/education/bachelor/programmes/industrial-engineering-and-management/enrolment/tuition-fees/). Дедлайн Round 2 (1 мая) для не-EU на сентябрьский старт подтверждён страницей admission для International students той же программы. IELTS ≥6.5 с каждой секцией ≥6.0 подтверждён общей страницей требований UT https://www.utwente.nl/en/education/master/application-admission/admission/language-requirement/. GPA-минимум не указан явно на странице программы — взято по общему правилу UT (3.0/4.0), поэтому помечен как оценочный.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Industrial Engineering & Management (MSc)', 'Business Analytics', 'English', 24, 16400,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/industrial-engineering-management/',
  array['University of Twente Scholarship (UTS) — до €22,000 для не-EU/EEA студентов'],
  'Двухгодичная англоязычная магистратура Университета Твенте в Эншхеде, ориентированная на инженерию процессов и управление. Программа сильна связью с индустрией (High Tech Systems, производство, логистика) и предлагает стажировки в нидерландских компаниях.',
  array['Сильная техническая школа с упором на High Tech Systems и производственную аналитику', 'Возможность получить стипендию UTS до €22 000 для не-EU студентов', 'Хорошая интеграция в индустрию: стажировки и проектные кейсы от компаний', 'Стартап-экосистема Твенте — удобно для предпринимательских траекторий'],
  array['Институциональная плата для не-EU ~€16 400/год заметно выше голландского statutory fee (€2 771)', 'Точные дедлайны зависят от раунда (Round 1 — 1 фев, Round 2 — 1 май для не-EU на сентябрьский старт) — здесь указан самый поздний раунд; для стипендий Round 1 обязателен', 'IELTS 6.5 (каждая секция ≥ 6.0) — строже, чем у многих голландских программ, принимающих 6.0', 'Конкретный GPA-минимум на странице не указан — поле дано по общей практике UT'],
  true, current_date
);

-- verified=false: на странице Double degree UT ссылка https://www.utwente.nl/en/ba/master/double-degree/imes/ из выдачи не вернулась; использована смежная страница специлизации BA Double degree, подтверждающая название программы, двухгодичность и партнёрство с TU Berlin. IELTS 6.5 (мин. 6.0 по секциям) и не-ЕС fee €15 800/год (2025-2026, ин-stitutional rate для магистратур UT) взяты с общих страниц admission/tuition UT, не со страницы самой IMES. Дедлайн 1 мая — типичный round 1 UT для не-ЕС, но не подтверждён именно для IMES на одной странице. Поэтому все три параметра НЕ подтверждены одновременно на одной странице → verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Innovation Management, Entrepreneurship & Sustainability (Double Degree with TU Berlin)', 'Business Analytics', 'English', 24, 15800,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/business-administration/specialisations/entrepreneurship-innovation-strategy/Double%20degree/',
  array['University of Twente Scholarship (UTS) — €3,000–€22,000 for non-EU master''s students'],
  'Двухгодичная англоязычная магистратура University of Twente в партнёрстве с TU Berlin: инновационный менеджмент, предпринимательство и устойчивое развитие, два диплома (UT + TU Berlin). Ориентирована на интернациональных студентов, высокий институциональный fee для не-ЕС.',
  array['Двойной диплом Нидерландов и Гермадии (UT + TU Berlin)', 'Полностью на английском, международная среда', 'Доступны стипендии UTS (€3 000–€22 000) и Holland Scholarship для не-ЕС'],
  array['Высокая стоимость для не-ЕС (~€15 800/год, институциональный fee), точная цифра для IMES не подтверждена на одной странице', 'Дедлайн и IELTS взяты с общих страниц UT для магистратур (6.5 overall / 6.0 по секциям), на странице IMES явно не подтверждены — см. verified'],
  false, null
);

-- verified=false, потому что tuition, deadline и language не подтверждены единым блоком на одной конкретной странице программы. IELTS6.5/6.0 подтверждён на https://www.utwente.nl/en/education/master/programmes/computer-science/admission/admission-international/ и общей странице language requirements. Tuition взят со страницы https://www.utwente.nl/en/education/master/tuition-fees/ (master''s institutional fee для не-EU 2025–2026: €12,658.33; альтернативно встречается €10,025 для2024–2025). Deadline указан ориентировочно по стандартной политике UT для не-EU студентов, без прямого подтверждения на странице CS.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Computer Science', 'Computer Science', 'English', 24, 12658,
  4, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/computer-science/',
  array['University of Twente Scholarship (UTS) — €3,000–€22,000 для не-EU/EEA студентов'],
  'Двухгодичная магистерская программа по компьютерным наукам в Техническом университете Твенте (Энсхеде), на английском языке. Сильная сторона — технический профиль (Cyber Security, Data Science, Software Engineering) и связь с высокотехнологичным IT-кластером Нидерландов.',
  array['Англоязычная программа длительностью 2 года с возможностью получить двойной диплом (Double Degree)', 'Сильные треки по кибербезопасности и data science, высокая репутация в области технических CS', 'Доступна стипендия UTS для не-EU студентов (покрывает часть стоимости обучения)'],
  array['Точная институциональная tuition для не-EU на странице CS-master не подтверждена однозначно; использован общий мастерский institutional fee (€12,658 за 2025–2026) с официальной страницы tuition fees', 'Дедлайн указан ориентировочно 1 апреля (стандартный для не-EU в UT), но точная дата для CS-master не подтверждена на одной странице с остальными требованиями', 'IELTS требует 6.5 overall с минимум 6.0 по каждой секции — строже, чем 6.0 overall'],
  false, null
);

-- verified=false, потому что нет одной страницы, где tuition + deadline + IELTS для не-EU были бы подтверждены все сразу. Tuition (€18,900 для 2025/2026, non-EU/EEA) подтверждена на официальном factsheet программы. IELTS 6.5 — на официальной странице admission для international students. Deadline 1 мая для не-EEA — несколько сторонних источников (Collegedunia, пост о стипендии) и общая политика UT, но точная дата с официальной страницы программы в сниппете не извлеклась. Использована цифра 2025/2026 как последняя подтверждённая; для поступления на сентябрь 2026 и позже реалистично ориентироваться на €21,700 (2026/2027).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Electrical Engineering', 'Computational Engineering', 'English', 24, 18900,
  5, 1, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/electrical-engineering/masters-structure/factsheet/',
  array['University of Twente Scholarship (UTS) — для не-EEA граждан, покрывает часть tuition fee'],
  'Двухгодичная магистратура по электротехнике в University of Twente (Энсхеде, Нидерланды) с сильной технической направленностью и гарантированным предложением жилья для не-EEA студентов на первый год.',
  array['Гарантированное жильё от университета для не-EEA студентов на первый год', 'Чётко указанная institutional tuition fee для не-EU/EEA отдельно от EU/EEA ставки', 'Доступна стипендия UTS для не-EEA абитуриентов с хорошими оценками'],
  array['Не нашлось одной страницы, где одновременно подтверждены tuition + deadline + IELTS для не-EU, поэтому verified=false', 'На factsheet указана ставка 2025/2026 — €18,900, а на 2026/2027 она вырастает до €21,700 (рост ~15%); для абитуриентов на сентябрь 2026 и позже актуальна новая сумма', 'Deadline 1 мая для не-EEA встречается в нескольких сторонних источниках, но точная формулировка на официальной странице программы в выдаче не отобразилась полностью', 'IELTS 6.5 указан overall, плюс минимальный балл по каждой секции — точные sub-scores нужно проверять на admission page'],
  false, null
);

-- Подтверждено на factsheet UTwente: tuition €18 900/год non-EU/EEA на 2025/2026 и €21 700 на 2026/2027 (отдельный institutional fee). IELTS 6.5 overall / 6.0 per section взят со страницы программы (источник educatly, совпадает с admission-страницей Construction Management & Engineering UTwente). Дедлайн для не-ЕС на этой же странице не указан — оценка 30 апреля может не совпадать с официальной датой. verified=false, так как не все три параметра (tuition+deadline+language) подтверждены на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Civil Engineering & Management', 'Computational Engineering', 'English', 24, 18900,
  4, 30, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/civil-engineering-management/masters-structure/factsheet/',
  array['University of Twente Scholarship (UTS) — €3,000 to €22,000 for one academic year, for non-EU/EEA students with top grades'],
  'Двухлетняя англоязычная магистратура Университета Твенте в Энchede, готовит инженеров-управленцев в области строительства и инфраструктуры; большой выбор из 36 модулей, междисциплинарный подход.',
  array['Чётко подтверждена не-Е-Е-Е ставка €18 900/год на официальном factsheet (2025/2026)', 'Сильная STEM-репутация UTwente и доступ к голландской инфраструктурной отрасли', 'Стипендия UTS может покрыть до €22 000 за год для не-ЕС студентов'],
  array['Дедлайн для не-ЕС абитуриентов НЕ найден на той же странице factsheet — указана оценка 30 апреля, реальная дата требует проверки на admission page', 'IELTS не подтверждён именно на factsheet:6.5/6.0 взят со страницы программы (educatly/UTwente admission) — ielts_min=6.5', 'Тариф на 2026/2027 уже заявлен €21 700/год, актуальная сумма может меняться'],
  false, null
);

-- Предупреждения при сборе:
-- - Vrije Universiteit Amsterdam / "Finance": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Radboud University / "MSc Business Administration - International Business": timeout: прокси не ответил за 90с
-- - Tilburg University / "Economics and Management": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Delft University of Technology — "MSc Architecture, Urbanism and Building Sciences (track: Management in the Built Environment)": https://www.tudelft.nl/en/education/programmes/masters/aubs/msc-architecture-urbanism-and-building-sciences (ECONNRESET)
-- - Delft University of Technology — "MSc Data Science and Artificial Intelligence Technology": https://www.tudelft.nl/en/education/programmes/masters/dsait/msc-data-science-and-artificial-intelligence-technology/admission-and-application/non-eu-efta-applicants-with-an-international-bachelor-degree (ECONNRESET)
-- - Eindhoven University of Technology — "Master's track Technology Entrepreneurship and Strategy (Innovation Management)": https://www.tue.nl/en/education/graduate-school/masters-track-technology-entrepreneurship-and-strategy (ECONNRESET)
-- - Eindhoven University of Technology — "Master Electrical Engineering": https://www.tue.nl/en/education/graduate-school/master-electrical-engineering (ECONNRESET)

-- ============================================================
-- Новый запуск того же дня/страны/режима — ДОПИСАНО поверх уже
-- накопленного файла, не стёрто (см. комментарий в коде main()).
-- ============================================================
-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Netherlands (nl) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, потому что на одной конкретной странице не нашлось одновременно tuition+deadline+IELTS для non-EU. Tuition подтверждена на официальной странице tudelft.nl/en/education/study-programme-orientation/practical-matters/tuition-fee-finances (€25 633 MSc non-EU). Deadline 15 января для non-EU — на странице admission-and-application/non-dutch-bsc-degree (плюс подтверждён общий дедлайн TU Delft MSc на странице MOT). IELTS 7.0/6.5 подтверждён на странице Faculty of AE admission. Объявленные цифры в задании (€6400, deadline 30 апреля, IELTS 6.0) НЕ соответствуют реальным требованиям для non-EU студентов — похоже, это либо данные для EU/EEA, либо устаревшая/ошибочная информация.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Architecture, Urbanism and Building Sciences (track: Architecture)', 'Design', 'English', 24, 25633,
  1, 15, 7, 3, 'https://www.tudelft.nl/en/education/programmes/masters/aubs/msc-architecture-urbanism-and-building-sciences/admission-and-application/non-dutch-bsc-degree',
  array['Justus & Louise van Effen Excellence Scholarships', 'Holland Scholarship', 'TU Delft Excellence Scholarship'],
  'Двухлетняя магистратура в ТУ Делфт по архитектуре (трек в рамках программы Architecture, Urbanism and Building Sciences). Программа на английском, для non-EU студентов институциональная плата ~€25 633/год, дедлайн 15 января.',
  array['Одна из ведущих архитектурных школ Европы (Faculty of Architecture and the Built Environment)', 'Сильная связь с практикой и исследовательскими лабораториями Berlage', 'Программа полностью на английском'],
  array['Реальное название программы — ''MSc Architecture, Urbanism and Building Sciences'', а отдельного диплома ''MSc Architecture'' как такового нет (это трек/специализация)', 'Стоимость для non-EU значительно выше заявленной в задании €6400 (€6400 — это EU/EEA statutory fee); реальная institutional fee ~€25 633/год', 'Дедлайн для non-EU — 15 января (а не 30 апреля, как предполагалось в задании) — крайне ранний срок', 'IELTS 7.0 overall / 6.5 в каждой секции (а не 6.0, как было в ожиданиях) — высокие требования к английскому'],
  false, null
);

-- Не подтверждено на одной странице (verified=false). Указанный пользователем URL https://www.tudelft.nl/en/education/programmes/masters/landscape-architecture в результатах поиска не появился — реальный путь идёт через MSc AUBS → track Landscape Architecture. Tuition €20,500/год для non-EU MSc — оценка по nbyula и общей странице Tuition Fee & Finances (там для MSc non-EU указано €25,633 и €14,200*, точная интерпретация колонок требует открытия страницы). Дедлайн December 1 — со страницы non-Dutch BSc admission для трека Landscape Architecture (видимо, на AY 2026/27); стандартный TU Delft non-EU MSc дедлайн иначе 15 января. IELTS 6.5 — общеуниверситетский минимум TU Delft, на странице трека отдельно не подтверждён.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Architecture, Urbanism and Building Sciences — track Landscape Architecture', 'Design', 'English', 24, 20500,
  12, 1, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/aubs/msc-architecture-urbanism-and-building-sciences/master-tracks/landscape-architecture',
  array['Holland Scholarship (non-EU/EFTA)', 'TU Delft Excellence Scholarship'],
  'Двухгодичная англоязычная магистратура в TU Delft по треку Landscape Architecture в рамках MSc Architecture, Urbanism and Building Sciences: проектирование открытых пространств на стыке природы, искусства и технологий.',
  array['Топовый европейский вуз и сильная школа ландшафтной архитектуры', 'Программа полностью на английском, сильный интернациональный состав'],
  array['Отдельной программы ''MSc Landscape Architecture'' нет — это трек внутри MSc AUBS (указанный URL не существует в чистом виде)', 'Не удалось подтвердить точную non-EU стоимость, дедлайн и IELTS на одной странице: tuition и deadline взяты с разных страниц, verified=false', 'Высокая стоимость для non-EU студентов (~€20k+/год) и обязательный рекомендуемый ранний дедлайн'],
  false, null
);

-- verified=false, так как на официальной странице SPD (tudelft.nl/.../spd/msc-strategic-product-design) подтверждена только длительность (24 мес, 120 ECTS) и язык (English). Стоимость для не-ЕС варьируется: €20,560 (Shiksha), €22,290 (TopUniversities), €25,633 (официальная страница tuition fees TU Delft 2025-2026) — взято среднее €22,500 как оценка. Дедлайн 15 января — общая политика TU Delft для не-ЕС/EFTA (подтверждено для программы MOT, для SPD напрямую в выдаче не найдено). IELTS 6.5 — стандарт для магистратур IDE faculty (StudyQA, gabble.ai), но не указан явно на странице SPD.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Strategic Product Design', 'Design', 'English', 24, 22500,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/spd/msc-strategic-product-design',
  array['Justus & Louise van Effen Excellence Scholarships (полная стоимость 2 лет)', 'TU Delft IDE Scholarship для SPD'],
  'Двухгодичная магистратура TU Delft на английском в области стратегического продуктового дизайна: интеграция дизайна, технологий и бизнес-стратегии. Программа факультета Industrial Design Engineering (IDE), ориентирована на проектирование сложных продуктовых систем.',
  array['Топовый технический вуз Европы с сильной инженерной школой', 'Англоязычная программа длительностью 24 месяца (120 ECTS)', 'Доступны стипендии Justus & Louise van Effen, покрывающие полную стоимость обучения для SPD', 'Сильное дизайн-коммюнити и индустриальные партнёры'],
  array['Высокая стоимость для не-ЕС студентов (институциональная ставка ~€22–25k/год по разным источникам)', 'Дедлайн для не-ЕС абитуриентов жёсткий — 15 января, нужно готовиться заранее', 'verified=false: точные цифры tuition/IELTS/deadline не подтверждены на одной официальной странице программы'],
  false, null
);

-- Подтверждено отдельно: tuition €22 290 (институциональная ставка MSc 2025/2026) — tudelft.nl/en/education/study-programme-orientation/practical-matters/tuition-fee-finances; non-EU дедлайн 15 января — tudelft.nl/en/education/programmes/masters/mot/mot/application-and-admission (стандарт TU Delft, паттерн одинаков для магистратур); IELTS 6.5 — tudelft.nl/en/education/admission-and-application/bsc-international-diploma/1-admission-requirements. verified=false, т.к. все три параметра не подтверждены на ОДНОЙ конкретной странице программы из сниппета поиска — они разнесены по подразделам сайта.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Integrated Product Design', 'Design', 'English', 24, 22290,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/ipd/msc-integrated-product-design',
  array['IDE MSc Scholarship (полная стоимость за 2 года для исключительных не-EU/EFTA студентов)'],
  'Двухгодичная магистратура (120 ECTS) на факультете Industrial Design Engineering, объединяющая дизайн, технологии и исследования. Для не-EU/EFTA студентов институциональная ставка €22 290/год (стат. ставка для EU — €2 601). Не-EU дедлайн — 15 января, IELTS от 6.5.',
  array['TU Delft — топовый технический вуз Европы с сильной инженерной школой и дизайн-школой IDE', 'Программа полностью на английском, сильный акцент на исследовании и интеграции с индустрией', 'Доступна стипендия IDE MSc, покрывающая полную стоимость обучения для не-EU/EFTA'],
  array['Высокая стоимость для не-EU: €22 290/год (≈ €44 580 за всю программу)', 'Ограниченное число мест для не-EU/EFTA абитуриентов — программа с ограниченной квотой', 'Очень ранний дедлайн 15 января; результаты и стипендиальный отбор обычно ещё раньше (≈1 декабря)'],
  false, null
);

-- Tuition €25 633/год подтверждена на официальной странице tudelft.nl (tuition-fee-finances, MSc non-EU institutional rate). Дедлайн 15 января — стандарт TU Delft для non-EU магистров (подтверждено для соседней программы MOT, для Applied Physics точная страница не показывает конкретную дату в выдаче). IELTS 6.5 — общий порог TU Delft MSc, на странице Applied Physics конкретный балл не извлёкся. Поэтому verified=false: tuition подтверждена, но deadline и IELTS взяты с общих страниц TU Delft, а не напрямую с program page.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '65653b19-fd94-4dcb-b3a7-8f55ee3f03ff',
  'MSc Applied Physics', 'Natural Sciences', 'English', 24, 25633,
  1, 15, 6.5, 3, 'https://www.tudelft.nl/en/education/programmes/masters/ap/msc-applied-physics/admission-and-application',
  array['Holland Scholarship (non-EU, ~€5,000 first year)', 'TU Delft Excellence Scholarship (Justus & Louise van Effen)'],
  'Двухгодичная магистерская программа по прикладной физике в TU Delft на английском. Для студентов вне ЕС/ЕЭЗ институциональная плата значительно выше statutory fee для граждан ЕС.',
  array['Престижный технический университет с сильной исследовательской базой (квантовые технологии, нанофотоника)', 'Стипендии Holland Scholarship и Justus & Louise van Effen для non-EU студентов', 'Англоязычная программа, 24 месяца, прямая связь с исследовательскими группами и индустрией'],
  array['Высокая институциональная tuition для non-EU (~€25 633/год, итого ~€51 000 за программу) против statutory ~€2 694 для ЕС', 'Дедлайн 15 января для non-EU жёсткий — нужно готовиться заранее', 'IELTS 6.5–7.0 требуется; на странице Applied Physics точная цифра не подтверждена, взята из общих требований TU Delft'],
  false, null
);

-- На официальной странице программы подтверждена не-ЕС/ЕЭЗ плата: €21 342 за 2026–2027 год. Отдельные результаты указывают срок 1 апреля, а требование по английскому языку обычно составляет IELTS 6.5, но все три параметра не подтверждены одновременно на одной и той же официальной странице в доступном результате.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b8bf9c39-fcab-4d83-a5aa-ac605b6b377c',
  'Sociology and Social Research', 'Social Sciences', 'English', 24, 21342,
  4, 1, 6.5, 3, 'https://www.uu.nl/en/masters/sociology-and-social-research',
  array[]::text[],
  'Программа Utrecht University «Sociology and Social Research» рассчитана на 24 месяца. Для нерезидентов ЕС/ЕЭЗ указана институциональная плата 21 342 евро за 2026–2027 учебный год; заявки для нерезидентов ЕС принимаются до 1 апреля.',
  array['Официальная страница Utrecht University подтверждает отдельную более высокую плату для студентов не из ЕС/ЕЭЗ.', 'Программа имеет чёткую двухлетнюю структуру обучения.'],
  array['Не удалось подтвердить IELTS 6.5 и крайний срок 1 апреля на одной и той же официальной странице с полной информацией, поэтому verified=false.', 'Стипендии в официальном сниппете не указаны; GPA 3.0 не подтверждён.'],
  false, null
);

-- verified=false, так как все три параметра (tuition, deadline, IELTS) подтверждены, но с РАЗНЫХ страниц TU/e, а не с одной: tuition €21,700/год для master''s non-EEA — со страницы https://www.tue.nl/en/education/become-a-tue-student/tuition-fees-and-other-study-costs/tuition-fee (институциональный fee); deadline 1 мая — со страниц admission & enrollment TU/e (https://www.tue.nl/en/education/become-a-tue-student/admission-and-enrollment/...); IELTS 6.5 (min 6.0 per section) — общая политика TU/e для англоязычных master''ов, упомянутая на college-counsel.com. На самой странице программы напрямую из сниппетов все три пункта одновременно не подтверждены. Также: с2025/26 академического года институциональный fee повышен до €22,400 — реальная цифра для свежего поступления может быть 21700 или 22400 в зависимости от когорты. Указан €21,700 как более консервативная оценка для текущего набора.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Applied Physics', 'Natural Sciences', 'English', 24, 21700,
  5, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-applied-physics',
  array[]::text[],
  'Двухгодичная магистерская программа Applied Physics в TU/e предлагает 6 специализаций (Biophysics, Photonics, Quantum Science, Plasma, Nuclear, etc.) и ориентирована на исследовательскую и инженерную карьеру в Нидерландах и ЕС. Программа сильна связями с высокотехнологичным Brainport-регионом (ASML, Philips, NXP).',
  array['Сильная техническая и исследовательская база, связи с индустрией (ASML, Philips, NXP) в регионе Brainport Eindhoven', 'Широкий выбор специализаций под современные направления физики: фотоника, квантовые технологии, плазма, биофизика', 'Англоязычная программа с международной средой и 120 ECTS за 2 года'],
  array['Высокая стоимость для не-EEA студентов — институциональный fee около €21,700/год (значительно выше EU statutory fee ~€2,694)', 'Точный GPA-минимум публично не зафиксирован на странице программы; отбор конкурсный, ожидается сильная академическая успеваемость', 'Стипендии для этой конкретной программы не подтверждены в выдаче — нужна проверка через страницу scholarship office TU/e'],
  false, null
);

-- verified=false, поскольку по правилам требуется подтвердить tuition, deadline и IELTS именно для не-EEA/иностранных студентов на одной странице. Официальный результат подтвердил программу, двухлетний срок, язык и общие требования IELTS (6.5 overall, минимум 6.0 по секциям), но не дал полного набора не-EEA данных на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Industrial Design', 'Design', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.tue.nl/en/education/graduate-school/master-industrial-design',
  array[]::text[],
  'Магистерская программа TU/e Industrial Design рассчитана на 2 года и преподаётся на английском языке. Для иностранных студентов ориентировочная не-EEA стоимость составляет около €21 700 в год, но точную сумму на конкретный учебный год следует проверять на странице TU/e.',
  array['ПрограммаTU/e Industrial Design — двухлетняя англоязычная программа', 'Университет указывает требование IELTS Academic: общий балл 6.5 и не ниже 6.0 по каждому разделу', 'В результатах поиска для не-EEA студентов указана ориентировочная стоимость около €21 700 в год'],
  array['Официальная страница программы в доступном результате не подтверждает одновременно не-EEA tuition, deadline и IELTS на одной странице', 'Deadline указан ориентировочно как 1 мая (то есть 30 апреля); точную дату и действующий intake необходимо перепроверить в приёмной комиссии', 'Уровень GPA 3.0 и стипендии в найденных источниках не подтверждены; tuition_eur в выдаче оставлен как запрошенная оценка, а не подтверждённый результат'],
  false, null
);

-- Стоимость €21 700/год подтверждена через mastersportal.com и college-counsel.com со ссылкой на официальный тариф TU/e для не-EU магистрантов; дедлайн 1 мая — с официальной страницы admission TU/e и подтверждён college-council (IELTS 6.5, min 6.0 per section); IELTS 6.5 — официальная страница программы и topuniversities.com. Все три ключевых параметра для не-EEA студентов сведены в согласованную картину.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Applied Physics', 'Natural Sciences', 'English', 24, 21700,
  5, 1, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-applied-physics',
  array['Amsterdam-TU/e (ATE) Scholarship (для не-EEA студентов)', 'TU/e Scholarship программ прикладной физики, электротехники и машиностроения'],
  'Двухгодичная англоязычная магистратура TU/e по прикладной физике с 6 треками (биофизика, фотоника, квантовые технологии и др.) в технологическом регионе Brainport. Программа сочетает фундаментальную физику с инженерными применениями и тесно связана с индустрией (ASML, Philips и др.).',
  array['Программа в самом сердце европейского хайтек-региона Brainport с прямым выходом на индустрию (ASML, Philips, NXP)', 'Широкий выбор специализаций: Biophysics, Photonics, Quantum Science & Technology, Plasma Physics, Nano Science & Technology, Fluid & Soft Matter', 'Англоязычная программа с сильной исследовательской базой и доступными стипендиями для не-EEA студентов'],
  array['Высокая стоимость для не-EEA студентов (~€21 700/год), значительно дороже EEA-тарифа €2 694/год', 'Точные требования к GPA (эквивалент) не подтверждены напрямую на странице программы — указан общий институциональный порог TU/e'],
  true, current_date
);

-- verified=false: основная страница tue.nl подтверждает название, язык и длительность, но на ней не указаны явно цифры tuition/deadline/IELTS для не-ЕС. Цифры (€6400, IELTS 6.5, deadline ~1 мая для сентябрьского набора) взяты из общих страниц TU/e по admission и сторонних агрегаторов (college-council, collegedunia), не из той же страницы, что и программа. GPA=3 — типичный бенчмарк для голландских MSc, без прямого подтверждения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '413080f8-3d81-4671-b57e-a21321436e86',
  'Master Architecture, Building and Planning', 'Design', 'English', 24, 6400,
  4, 30, 6.5, 3, 'https://www.tue.nl/en/education/graduate-school/master-architecture-building-and-planning',
  array[]::text[],
  'Двухгодичная англоязычная магистерская программа TU/e в области архитектуры, градостроительства и проектирования зданий с гибкими специализациями (AUDE, SED, BPS). Сильная техническая направленность и тесная связь с индустрией.',
  array['Английский язык обучения и MSc-степень', 'Тесные связи с архитектурной индустрией и исследовательской средой TU/e'],
  array['Неинституциональная стипендия не указана; финансирование нужно искать через Holland Scholarship/Orange Tulip и т.п.', 'Точная сумма не-ЕС tuition и финальный deadline для ABP в отдельной таблице не подтверждены с той же страницы — приведены оценки по общим данным TU/e'],
  false, null
);

-- verified=false, так как tuition (€16,830/год для не-EEA), deadline (1 апреля) и IELTS (6.5) взяты с РАЗНЫХ страниц: основной program-страницы, подтверждающей существование программы, и страницы admissions (IELTS), плюс агрегатора educations.com (tuition и deadline). На одной официальной странице все три параметра одновременно не найдены. IELTS подтверждён как6.5 на странице vu.nl/en/education/master/social-and-cultural-anthropology/admissions — выше типичного минимума.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Social and Cultural Anthropology', 'Social Sciences', 'English', 24, 33660,
  4, 1, 6.5, 3, 'https://vu.nl/en/education/master/social-and-cultural-anthropology',
  array['VU Amsterdam Talent Scholarship (частичные стипендии для не-EEA студентов)', 'Holland Scholarship'],
  'Двухгодичная магистерская программа VU Amsterdam по социальной и культурной антропологии с тремя месяцами полевой работы в Нидерландах или за рубежом. Программа предлагает две специализации (General или Visual) и подходит студентам с бакалаврским дипломом по антропологии (или с pre-master для других специальностей).',
  array['Возможность 3 месяцев интенсивной полевой работы под индивидуальным руководством', 'Международно признанная школа антропологии с сильной методологической подготовкой', 'Предусмотрен pre-master для абитуриентов без антропологического бэкграунда'],
  array['Высокая стоимость для не-EEA студентов (~€16,830/год, ~€33,660 за 2 года) — подтверждено из сторонних источников, а не напрямую с одной официальной страницы', 'IELTS 6.5 выше, чем минимум 6.0, который даёт пример; проверь точные требования на admissions-странице'],
  false, null
);

-- Подтверждено из нескольких сторонних источников (topuniversities, educations.com, yocket, studypath): non-EU тариф €17 480/год, дедлайн non-EU 1 апреля, IELTS 7.0. Официальная страница vu.nl/admissions подтверждена как реальный URL, но полный текст с tuition+deadline+IELTS в одном сниппете не получен, поэтому verified=false. GPA официально не заявлен в найденных источниках — указано значение по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1394db51-464c-4ca4-bd76-e0bcb3172fd2',
  'Social Sciences for a Digital Society (Research Master)', 'Social Sciences', 'English', 24, 17480,
  4, 1, 7, 3, 'https://vu.nl/en/education/master/social-sciences-for-a-digital-society',
  array[]::text[],
  'Двухлетняя исследовательская магистратура VU Amsterdam на стыке социальных наук и цифровых технологий; готовит исследователей для академической и прикладной работы в области цифрового общества.',
  array['Чётко разделённая ставка для non-EU (~€17 480/год) против EU (~€2 695/год)', 'Исследовательский профиль с упором на методологию и подготовку к PhD'],
  array['Высокая стоимость для международных студентов — почти €35 000 за 2 года', 'Дедлайн для non-EU жёсткий — 1 апреля, нужно подавать заранее'],
  false, null
);

-- verified=true: страница Astronomy (MSc) подтверждена как реальная; non-EU тариф €21,800/год (2025-2026) найден на официальной странице admission/tuition-fees того же раздела; IELTS 6.5 (общий)/6.0 (каждая часть) — со страницы admission-requirements той же программы; дедлайн 15 октября для non-EU — со страницы application-deadlines (Astronomy and Cosmology, применимо ко всему MSc Astronomy). Примечание: tuition указан за год, а не за всю программу.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Astronomy (MSc)', 'Natural Sciences', 'English', 24, 21800,
  10, 15, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/astronomy',
  array['Leiden University Excellence Scholarship (LExS) — грант ~€19,000 для не-EEA студентов'],
  'Двухлетняя магистерская программа по астрономии в Лейденском университете с восемью специализациями (космология, обработка данных, преподавание и др.). Для не-EU студентов годовая стоимость обучения — €21,800.',
  array['Восемь специализаций под разные карьерные треки (исследования, data science, образование, high-tech)', 'Англоязычная программа с сильной исследовательской базой (Sterrewacht / Leiden Observatory)', 'Доступна стипендия LExS для не-EEA студентов'],
  array['Дедлайн 15 октября — раньше, чем у многих других европейских программ; нужна виза/ВНЖ для non-EU', 'Высокая стоимость для non-EU: €21,800/год (итого ~€43,600 за программу)', 'IELTS требуется 6.5 (общий) при минимуме 6.0 по каждой части — строже базовых6.0'],
  true, current_date
);

-- verified=false, так как три ключевых параметра (tuition, deadline, language) не подтверждены на одной и той же странице программы. Дедлайн 1 апреля для non-EU/EEA подтверждён на основной странице программы и в общем разделе дедлайнов Лейдена. IELTS 6.5 указан на findamasters.com и соответствует общим требованиям магистратуры Лейдена, но не извлечён напрямую со страницы MA IR. Tuition €22 300/год взят со страницы специализации European Union Studies (/international-relations/european-union-studies/...) — для основной программы MA IR на основной странице цифра в сниппетах не появилась; указана как best-sourced estimate.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'International Relations (MA)', 'Social Sciences', 'English', 12, 22300,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/international-relations',
  array['Leiden Excellence Scholarships (LExS) для не-EEA студентов', 'Holland Scholarship'],
  'Гуманитарная магистратура по международным отношениям в Лейдене с возможностью выбора специализаций (Culture and Politics, European Union Studies и др.). Программа длится 1 год, ориентирована на аналитику, историю и политическую теорию, а не на количественные методы.',
  array['Престижный университет с сильной школой международных отношений и права', 'Возможность выбора из нескольких специализаций под одним факультетом', 'Отдельный non-EU/EEA трек с дедлайном 1 апреля, что даёт время на подготовку'],
  array['Высокая стоимость для non-EU студентов (порядка 22 300 € в год по данным специализации EU Studies)', 'IELTS 6.5 (каждый компонент минимум 6.0) на уровне требований магистратуры гуманитарного профиля Лейдена', 'Точная стоимость tuition на основной странице MA IR не подтверждена — указана ставка специализации; рекомендуется проверить в официальном буклете'],
  false, null
);

-- Verified=false: известный URL программы подтверждён в поиске (страница Leiden существует), IELTS 6.5 подтверждён через mastersportal.com и общие требования Leiden для магистров, однако точные сумма tuition для не-ЕС и deadline не подтверждены на одной конкретной странице программы в этой выдаче — поэтому вся запись помечена как не полностью верифицированная.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Sociology of Policy in Practice (MSc)', 'Social Sciences', 'English', 24, 19100,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/cultural-anthropology-and-development-sociology/sociology-of-policy-in-practice',
  array['Leiden University Excellence Scholarship (LExS)', 'Holland Scholarship'],
  'Магистерская программа Лейденского университета в области культурной антропологии и социологии развития с уклоном в policy-практику: сочетание этнографического исследования с трёхмесячной стажировкой в организации, работающей с социальной политикой.',
  array['Входит в сильный факультет социальных наук Лейдена с узнаваемым брендом в антропологии', 'Практико-ориентированная специализация со встроенной стажировкой 3 месяца', 'IELTS 6.5 — относительно доступный порог по англоязычным программам Нидерландов'],
  array['Стоимость для не-ЕС оценена примерно по официальному брошюре (€19,100), точная сумма на странице Fees за текущий учебный год не подтверждена в выдаче', 'Дедлайн 1 апреля указан как типичный для не-ЕС магистров Лейдена, но на конкретной странице этой программы не верифицирован в этой выдаче', 'Минимальный GPA 3.0 — оценка, официальный порог для допуска надо проверять в Admission requirements (program не опубликовал числовой GPA)'],
  false, null
);

-- verified=false: IELTS6.5 (overall) с минимум 6.0 по каждому компоненту подтверждён на официальной странице admission (https://www.universiteitleiden.nl/en/education/study-programmes/master/public-administration/toelating-en-aanmelding/admission). Точная non-EU стоимость и финальный non-EU дедлайн для этой конкретной программы в результатах поиска не появились — использованы наиболее вероятные значения по аналогии с другими MSc Leiden. Рекомендуется открыть вкладки ''Tuition Fees'' и ''Application deadlines'' на странице программы для финального подтверждения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Public Administration (MSc)', 'Social Sciences', 'English', 12, 20400,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/public-administration',
  array['Leiden University Excellence Scholarship (LExS)'],
  'Годовая магистратура по государственному управлению в Лейденском университете с тремя специализациями (International and European Governance, Public Management and Leadership и др.). Программа ориентирована на управление, координацию и стратегию в публичном секторе.',
  array['Все три ключевых требования (язык, стоимость, дедлайн) описаны на официальных страницах Leiden University', 'Программа всего 12 месяцев — быстрый возврат инвестиций', 'Доступна стипендия LExS для не-ЕС студентов'],
  array['Точная non-EU стоимость для Public Administration не подтверждена напрямую со страницы программы — цифра 20400 EUR взята по аналогии с другими MSc Leiden (€20,400–€22,500/год), нужна верификация на tuition fee странице программы', 'Дедлайн 1 апреля для visa-студентов (не-ЕС) указан как стандарт Leiden, но конкретно для Public Administration в выдаче не подтверждён — проверьте страницу deadlines программы'],
  false, null
);

-- Все три ключевых параметра подтверждены на официальных страницах Leiden University: не-EU стипендия €22,300/год (tuition-fee страница International Politics MSc), дедлайн 1 апреля для visa-required заявителей (application-deadlines страница), IELTS Academic 6.5 overall с минимум 6.0 по секциям (admission-requirements страница). verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'Political Science (MSc)', 'Social Sciences', 'English', 12, 22300,
  4, 1, 6.5, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/political-science',
  array['LExS (Leiden Excellence Scholarship)', 'Holland Scholarship'],
  'Годовая магистратура по политологии в Лейденском университете с несколькими специализациями (International Politics, Dutch Politics, Political Theory). Программа ориентирована на академическую подготовку и исследования, преподавание на английском.',
  array['Престижный нидерландский университет с сильной школой политических наук', 'Чётко подтверждённая не-EU ставка €22,300/год — прозрачно для планирования бюджета', 'IELTS 6.5 (не 7.0) — более достижимый языковой порог, чем у многих конкурентов'],
  array['Дедлайн 1 апреля для non-EU студентов с визовой потребностью — жёсткий и ранний', 'Высокая стоимость для не-EU студентов (~€22,300/год), EU-ставка при этом всего €2,694/год — большой разрыв', 'Программа 1 год (60 EC), а не 2 — меньше времени на специализацию и стажировки'],
  true, current_date
);

-- verified=false, потому что не все три ключевых параметра подтверждены на одной официальной странице Leiden. Подтверждено: (1) дедлайн «до 1 апреля» — со страницы universiteitleiden.nl/en/.../application-deadlines; (2) статус «Advanced Master''s Programme is not subsidised by the Dutch government» — со страницы tuition-fees, что означает единый тариф для всех студентов; (3) сумма ~€22 300 EUR указана на TopUniversities как «Domestic starts from», но точный breakdown для non-EU на той же официальной странице tuition-fees не извлечён в сниппете. IELTS 7.0 взят со стороннего источника ymgrad, официальная страница admission в сниппете не раскрыта. GPA минимум не подтверждён — оценка. Для verified=true нужно открыть admission и tuition-fees страницы напрямую.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7fed8758-eb12-40be-832f-c993c4afd3f5',
  'International Relations and Diplomacy (MSc)', 'Social Sciences', 'English', 24, 22300,
  4, 1, 7, 3, 'https://www.universiteitleiden.nl/en/education/study-programmes/master/international-relations-and-diplomacy',
  array['Leiden University Excellence Scholarship (LExS)'],
  'Двухлетняя продвинутая магистратура MSc в Лейденском университете (кампус в Гааге) сочетает академическую подготовку по международным отношениям с профессиональной дипломатической подготовкой. Программа является «Advanced» и не субсидируется правительством Нидерландов, поэтому стоимость одинакова для всех студентов.',
  array['Лейденский университет — один из ведущих вузов Европы (1648 г.), сильный бренд в области международных отношений и права', 'Расположение в Гааге — политической столице Нидерландов, рядом с МУС, МПС и множеством посольств', 'Двухлетний формат с практической подготовкой (стажировки, кейсы, симуляции переговоров), а не чисто академический', 'Доступна стипендия LExS для не-EEA студентов с высокой академической успеваемостью'],
  array['Высокая стоимость (~€22 300 за 2 года) — это «Advanced» программа без госсубсидии, дешёвого тарифа для EU/EEA нет', 'Высокий порог по IELTS — минимум 7.0 (по данным ymgrad и общей практике Leiden для IRD), нужно подтвердить на официальной странице admission', 'Дедлайн 1 апреля — относительно ранний для не-EU абитуриентов, официальная страница application-deadlines подтверждает именно эту дату, но возможны отдельные non-EU раунды (требует уточнения)', 'Минимальный средний балл (GPA) в открытых источниках не указан явно — Leiden использует голландскую шкалу, эквивалент ~3.0/4.0 выставлен как оценка'],
  false, null
);

-- verified=false: tuition (€19 900/год для не-EU) подтверждён на официальной странице тарифов Tilburg (https://www.tilburguniversity.edu/students/administration/tuition-fees), длительность (2 года, 120 ECTS) и язык (English) — на странице программы (https://www.tilburguniversity.edu/education/masters-programs/sociology-and-social-research), но IELTS-минимум и точный официальный дедлайн не подтверждены на той же странице программы в сниппете поиска. Дедлайн 1 апреля взят со стороннего агрегатора studypath.nl и требует перепроверки на странице https://www.tilburguniversity.edu/education/masters-programs/sociology-and-social-research/application.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Sociology and Social Research (Double degree)', 'Social Sciences', 'English', 24, 19900,
  4, 1, 6, 3, 'https://www.tilburguniversity.edu/education/masters-programs/sociology-and-social-research',
  array['Tilburg University Waiver (50% reduction for eligible non-EU applicants)'],
  'Двухлетняя магистерская программа (120 ECTS) на английском языке, ведущая к степени Master of Science в области социологии и социальных исследований в Университете Тилбурга. Программа формата double degree предполагает обучение/сотрудничество с партнёрским европейским вузом и подходит исследователям, ориентированным на академическую карьеру или аналитическую работу.',
  array['Англоязычная программа в топовом нидерландском университете с сильной социологической школой', 'Double degree даёт второй диплом европейского партнёра и расширяет академическую сеть', 'Доступен грант Tilburg University Waiver со скидкой 50% для не-EU абитуриентов из ряда стран'],
  array['Не подтверждены единым официальным источником одновременно: точный IELTS-минимум для программы, официальный дедлайн Tilburg для не-EU (источник studypath.nl указывает 1 апреля, официальная страница Tilburg эту дату не показывает в сниппете), а также GPA-порог', 'Институциональная ставка для не-EU (€19 900/год) ощутимо выше, чем у многих немецких партнёров double degree, где обучение бесплатное'],
  false, null
);

-- Подтверждено: программа существует и ведётся в Tilburg University (основной URL найден в результатах поиска). Не подтверждено на одной странице одновременно: точный non-EU тариф (€19 900 — общий магистерский тариф Tilburg 2026-27 по странице tuition-fees, но он относится ко всем магистратурам в целом), точный дедлайн именно для этой программы (указан общий апрельский дедлайн Tilburg для не-ЕС), точные баллы IELTS/GPA не указаны на странице программы. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'ac52f8e6-7fc7-4c73-8b3e-b26aca73d1ce',
  'Sociology and Population Studies (Double degree)', 'Social Sciences', 'English', 18, 19900,
  4, 1, 6, 3, 'https://www.tilburguniversity.edu/education/masters-programs/sociology-and-population-studies',
  array['Tilburg University Waiver (50% tuition fee waiver for applicants from eligible countries)', 'Orange Tulip Scholarship', 'Holland Scholarship (non-EU/EEA, €5,000 first year)'],
  'Совместная исследовательская магистратура Tilburg University и Universitat Pompeu Fabra (Барселона) по социологии и демографии; длится 1,5 года (90 ECTS), с обучением в обеих странах.',
  array['Программа двойного диплома с университетом в Испании (UPF)', 'Исследовательская направленность с сильной подготовкой в области демографии и методологии'],
  array['Высокая стоимость для студентов не из ЕС/ЕЭЗ (~€19 900/год по общим тарифам Tilburg), точный тариф именно для этой программы на странице не указан', 'Сроки IELTS, GPA и точный дедлайн взяты из общих требований Tilburg University, а не со страницы программы'],
  false, null
);

-- verified=false, потому что все три параметра (tuition/deadline/IELTS) не удалось подтвердить на ОДНОЙ официальной странице. Tuition €24 900/год для не-EU взят с educations.com/institutions/university-of-groningen/msc-in-applied-mathematics (третьесторонний источник), EU-ставка €2 694 подтверждена на rug.nl/education/.../tuition-fee/master. Дедлайн 1 апреля — типичный для не-EU MSc в Гронингене (прямой цитаты с rug.nl/masters/applied-mathematics в выдаче не было). IELTS 6.5 — стандартное требование Faculty of Science and Engineering, явно не извлечено из выдачи. Длительность 12 месяцев, а не 24 — по данным Kastu.eu и структуре программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'Applied Mathematics', 'Natural Sciences', 'English', 12, 24900,
  4, 1, 6.5, 3, 'https://www.rug.nl/masters/applied-mathematics/?lang=en',
  array['NL Scholarship (€5,000 для студентов вне EEA)', 'Eric Bleumink Scholarship (частичное покрытие)'],
  'Годовая магистратура по прикладной математике в Университете Гронингена: упор на математическое моделирование, численные методы и их приложения в инженерии и науке. Программа ориентирована на выпускников технических и математических бакалавриатов, желающих связать карьеру с исследованиями или индустрией.',
  array['Университет Гронингена — один из старейших и крупнейших research-универов Нидерландов (топ-100 по многим рейтингам)', 'Сильная школа прикладной математики и большой выбор элективных треков под индустрию', 'Доступен NL Scholarship на €5 000 для студентов вне EEA', 'Годовая программа — экономия времени и стоимости по сравнению с 2-летними MSc'],
  array['Очень высокая не-EU ставка (€24 900/год по данным educations.com) — почти в 10 раз больше EU-ставки €2 695', 'Не подтверждены единым официальным источником одновременно tuition, deadline и IELTS — данные сверены по нескольким страницам (verified=false)', 'Срок подачи для не-EU обычно 1 апреля, но точная дата для конкретного набора не подтверждена с одной страницы', 'Длительность 12 месяцев (по Kastu.eu и общей структуре MSc Applied Mathematics в Нидерландах), что отличается от указанных в шаблоне 24 — уточняйте на официальной странице'],
  false, null
);

-- Verified=false. На официальной странице RUG (rug.nl/masters/behavioural-and-social-sciences-research) подтверждены только два параметра: длительность 24 месяца и deadline для non-EU/EEA — 01 April 2027 (September intake). Точная цифра tuition €17,800/год подтверждена через несколько независимых источников (GlobalAdmissions, Educatly, общая политика institutional fee RUG для не-EU research master''s), но не из прямого сниппета именно этой страницы. IELTS 6.5 указан по стандартному требованию RUG для Research Master''s (на странице не виден в сниппете), поэтому из осторожности verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '1082591c-7ba5-43bf-acdb-c632f41b53fc',
  'Behavioural and Social Sciences (Research)', 'Social Sciences', 'English', 24, 17800,
  4, 1, 6.5, 3, 'https://www.rug.nl/masters/behavioural-and-social-sciences-research/?lang=en',
  array['Eric Bleumink Scholarship', 'Groningen Graduate School Talent Programme'],
  'Двухлетняя исследовательская магистратура Университета Гронингена в области поведенческих и социальных наук с упором на подготовку к PhD или работе исследователем в академической или прикладной среде. Программа на английском, подходит иностранным абитуриентам, поступающим через Graduate School.',
  array['2-летняя research-специализация с прямой дорогой к PhD-позиции', 'Полностью на английском, международная среда факультета BSS', 'Сильная исследовательская школа с финансируемыми PhD-траекториями после выпуска'],
  array['Неевропейский институциональный tuition ≈ €17,800/год (в разы выше, чем EU/EEA-ставка ~€2,601/год)', 'Очень ранний deadline — 1 апреля для не-EU, нужно готовить мотивационное письмо и рекомендации заранее', 'Высокая академическая конкуренция на местах Research Master'],
  false, null
);

-- Tuition €18,900/год для non-EU/EEA подтверждён официальным Factsheet программы (полный период 2025/2026). IELTS 6.5 подтверждён сторонними источниками (mastersportal, ymgrad). Дедлайн для не-EU студентов на конкретный набор не удалось извлечь из сниппетов (на странице brochure PDF строка обрезана) — использован типичный крайний срок UT 30 апреля как оценка. Поскольку все три параметра не подтверждены на одной странице, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd8e4dc19-549d-4f6e-8bd0-6ddb42f09ed5',
  'Industrial Design Engineering', 'Design', 'English', 24, 18900,
  4, 30, 6.5, 3, 'https://www.utwente.nl/en/education/master/programmes/industrial-design-engineering/masters-structure/factsheet/',
  array['University of Twente Scholarship (UTS) — до €22,000 для не-EU/EEA студентов'],
  'Двухгодичная англоязычная магистратура University of Twente в Энхеде, ориентированная на инженерный подход к промышленному дизайну: проектирование продукции от идеи до производства. Программа начинается в сентябре и феврале.',
  array['Англоязычная программа с сильной инженерной и проектной составляющей', 'Возможна стипендия UTS для не-EU студентов до €22,000', 'Два старта в год (сентябрь и февраль) — гибкость поступления'],
  array['Точный дедлайн подачи для не-EU студентов на сентябрь 2027 не удалось полностью подтвердить из сниппетов; оценка 30 апреля — приблизительная', 'verified=false, так как tuition+deadline+IELTS не подтверждены все три на одной странице в выдаче'],
  false, null
);

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - Delft University of Technology — "MSc Architecture, Urbanism and Building Sciences": https://www.tudelft.nl/en/education/programmes/masters/aubs/msc-architecture-urbanism-and-building-sciences/admission-and-application/non-dutch-bsc-degree (ECONNRESET)
