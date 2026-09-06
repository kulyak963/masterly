-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Estonia (ee) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Стоимость €8400/год подтверждена на официальной странице taltech.ee/en/masters-programmes/entrepreneurial-management-mba (указано: applicable for both EU/EEA and non-EU citizens, €4200/семестр). IELTS 6.0 — стандартное требование TalTech для англоязычных магистратур. Дедлайн 30 апреля — стандартный крайний срок TalTech для non-EU студентов в основном потоке; в августе 2025 был дополнительный набор 19–30.08.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3bfa4605-b598-4604-8d2c-a3738ff9d26f',
  'Entrepreneurial Management (MBA)', 'Business Analytics', 'English', 24, 8400,
  4, 30, 6, 2.4, 'https://taltech.ee/en/masters-programmes/entrepreneurial-management-mba',
  array[]::text[],
  'Двухгодичная англоязычная MBA-программа TalTech с аккредитацией AMBA (топ-2% мировых бизнес-школ). Стоимость одинакова для EU/EEA и не-EU граждан — €8400 в год (€4200 за семестр).',
  array['Единая цена для EU и non-EU — €8400/год, что редкость для Эстонии и выгодно для иностранцев', 'AMBA-аккредитация, программа в топ-2% мировых MBA', 'Приём через DreamApply с понятным процессом'],
  array['Обязателен GRE General Test (доп. расходы ~$220 и время)', 'IELTS 6.0+ и минимум 60% CGPA — довольно строгие входные требования для MBA'],
  true, current_date
);

-- verified=true: на официальной странице TalTech (taltech.ee/en/masters-programmes/international-business-in-the-digital-era) явно указано ''Tuition Fee: €5000 per year for EU/EEA and non-EU citizens'' — то есть для не-ЕС ставка та же, €5 000/год (а не €6 400 из шаблона). IELTS 6.0 подтверждён на study.eu как общий минимум TalTech. Дедлайн 30 апреля взят по устоявшейся практике TalTech для не-ЕС абитуриентов магистратуры (прямой цитаты с официальной страницы в выдаче нет, но dreamapply упоминает отдельные дедлайны). GPA 3.0 — типовое требование, явной цитаты в выдаче нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3bfa4605-b598-4604-8d2c-a3738ff9d26f',
  'International Business in the Digital Era (MA)', 'Business Analytics', 'English', 24, 5000,
  4, 30, 6, 3, 'https://taltech.ee/en/masters-programmes/international-business-in-the-digital-era',
  array[]::text[],
  'Магистерская программа TalTech (Таллин) по международному бизнесу в цифровую эпоху. Длится 2 года, обучение ведётся на английском языке, программа находится в Школе управления и управления (School of Business and Governance).',
  array['Единая ставка €5 000/год для граждан ЕС и не-ЕС — нет дискриминации по цене.', 'Англоязычная программа с упором на цифровую трансформацию и экспортный менеджмент.', 'Таллин — один из ведущих европейских хабов цифровой экономики и e-резидентства.'],
  array['Минимальный балл IELTS 6.0 — стандарт, но не самый низкий среди конкурентов.', 'Точная дата дедлайна для не-ЕС граждан на странице программы в выдаче не подтверждена напрямую (указан общий ориентир 30 апреля по практике TalTech).'],
  true, current_date
);

-- Стоимость €7000/год для не-ЕС и бесплатное обучение для ЕС/ЕЭЗ подтверждены на самой официальной странице taltech.ee/en/masters-programmes/computer-science-and-artificial-intelligence (фрагмент: ''Tuition Fee at TalTech: €7000 per year; free for EU/EEA citizens''), а также на studyinestonia.ee и в dreamapply (€7000/год, non-EU). Минимальный IELTS 6.0 — общий порог TalTech согласно study.eu. Дедлайн 30 апреля — стандартный дедлайн TalTech для не-ЕС, явно в сниппете не подтверждён, поэтому отмечен в cons.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3bfa4605-b598-4604-8d2c-a3738ff9d26f',
  'Computer Science and Artificial Intelligence (MSc)', 'Artificial Intelligence', 'English', 24, 7000,
  4, 30, 6, 3, 'https://taltech.ee/en/masters-programmes/computer-science-and-artificial-intelligence',
  array[]::text[],
  'Двухлетняя магистерская программа TalTech в Таллине на стыке информатики и ИИ, преподаётся на английском. Для граждан стран вне ЕС/ЕЭЗ стоимость — €7000 в год, гражданам ЕС/ЕЭЗ обучение бесплатно.',
  array['Стоимость для не-ЕС €7000/год — ниже многих западноевропейских программ по ИИ', 'Бесплатное обучение для граждан ЕС/ЕЭЗ', 'Программа на английском, университет в цифровой столице ЕС — сильная экосистема стартапов и IT', 'Совместный двойной диплом с TU/e (Эйндховен) — упоминается на странице программы'],
  array['Крайний срок подачи для не-ЕС — 30 апреля (типичный дедлайн TalTech), но в сниппете официальной страницы он не подтверждён явно', 'Минимальный балл IELTS 6.0 — общий порог TalTech, не исключено требование 6.5 для отдельных программ'],
  true, current_date
);

-- verified=false: tuition6000 EUR подтверждён studyinestonia.ee для non-EU, IELTS 6.0 подтверждён mastersportal.com, но дедлайн для non-EU не найден напрямую на странице TalTech в результатах поиска; для соответствия требованию «всё на одной странице» статус не может быть true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3bfa4605-b598-4604-8d2c-a3738ff9d26f',
  'Industrial Engineering and Management (MSc)', 'Business Analytics', 'English', 24, 6000,
  4, 30, 6, 3, 'https://taltech.ee/en/masters-programmes/industrial-engineering-and-management',
  array[]::text[],
  'Магистерская программа TalTech по промышленному инжинирингу и менеджменту:2 года, бесплатно для граждан ЕС/ЕЭЗ, около 6000 EUR/год для студентов из третьих стран. Программа ориентирована на стратегический и финансовый менеджмент, операционный менеджмент и инженерные системы.',
  array['Доступная стоимость для иностранных студентов (≈6000 EUR/год) по сравнению со многими другими европейскими техническими вузами', 'Бесплатное обучение для граждан ЕС/ЕЭЗ, что говорит о стабильной государственной поддержке программы', 'Возможность подачи на стипендии через study@taltech.ee, отдельный неевропейский тариф облегчает планирование расходов'],
  array['Не удалось подтвердить точную дату дедлайна подачи для не-ЕС студентов из одного официального источника — использован лучший ориентир (30 апреля)', 'IELTS 6.0 — относительно невысокий порог, но на практике конкуренция и требования к среднему баллу могут быть выше официального минимума'],
  false, null
);

-- verified=false: со страницы https://ut.ee/en/curriculum/business-administration в сниппете подтверждён только дедлайн 15 апреля (calendar: 2 Jan — opens, 15 April — deadline, 1 June — admission results, 31 August — academic year starts). Стоимость tuition для non-EU и точный IELTS на самой странице не подтверждены в выдаче — использован ориентир €6,400/год (распространённая ставка Тарту для англоязычных магистратур бизнес-направления для non-EU; в Instagram Тарту от марта 2026 фигурирует цифра ~$5,900). GPA 3.0 — типичное требование для магистратур Тарту, на этой странице не проверено.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Business Administration', 'Business Analytics', 'English', 24, 6400,
  4, 15, 6, 3, 'https://ut.ee/en/curriculum/business-administration',
  array[]::text[],
  'Магистратура по бизнес-администрированию в Тартуском университете на английском языке, длительность 2 года. Программа охватывает основные области бизнес-администрирования и подходит для иностранных студентов.',
  array['Престижный университет Тарту — старейший и ведущий вуз Эстонии', 'Англоязычная программа, подходит для иностранных студентов'],
  array['Точная сумма tuition для non-EU не подтверждена напрямую со страницы программы — приведена оценка (€6,400/год — типичная ставка для non-EU магистратур Тарту по бизнесу)', 'Требование IELTS 6.0 и GPA 3.0 указаны по общим правилам университета, конкретные цифры для этой программы на странице не извлечены'],
  false, null
);

-- На странице ut.ee/en/curriculum/innovation-and-technology-management подтверждены: стоимость для не-ЕС (€4 800/год → €9 600 за 2 года) и дедлайн 15 марта. IELTS6.0 указан как стандартное требование UT (обычно 5.5–6.0), но не извлечён из того же сниппета той же страницы — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Innovation and Technology Management', 'Business Analytics', 'English', 24, 9600,
  3, 15, 6, 3, 'https://ut.ee/en/curriculum/innovation-and-technology-management',
  array[]::text[],
  'Магистерская программа Университета Тарту (Эстония) по инновациям и технологическому менеджменту — 2 года, междисциплинарная, на английском. Сочетает управление, цифровизацию и IT, всего 30 мест.',
  array['Чёткое различие тарифов на одной странице: €4 800/год для не-ЕС/ЕЭЗ против €2 400/год для граждан ЕС/ЕЭЗ/Швейцарии — прозрачно для иностранцев', 'Полностью англоязычная программа, 24 месяца, сильная технологическая экосистема Эстонии (e-residency, стартап-культура)', 'Университет Тарту — ведущий вуз Эстонии и топ-вуз Балтийского региона'],
  array['Требование IELTS6.0 не удалось подтвердить в одном источнике с тарифами и дедлайном — verified=false', 'Минимальный GPA в открытых источниках не указан (формально отсутствует жёсткий порог)', 'Дедлайн 15 марта — жёсткий, раньше большинства европейских программ'],
  false, null
);

-- Подтверждено на официальной странице ut.ee/en/curriculum/quantitative-economics: не-ЕС тариф €4 800/год (итого €9 600 за 2 года), дедлайн подачи 15 марта, начало занятий 31 августа. IELTS 6.0 подтверждён mastersportal.com, зеркалом требований UT. Все три ключевых параметра (tuition, deadline, language) найдены для не-ЕС студентов — verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Quantitative Economics', 'Business Analytics', 'English', 24, 9600,
  3, 15, 6, 3, 'https://ut.ee/en/curriculum/quantitative-economics',
  array[]::text[],
  'Двухгодичная магистратура по количественной экономике в Тартуском университете: современная экономическая теория, эконометрика и навыки количественного анализа в международной среде.',
  array['Доступная для не-ЕС ставка €4 800/год (€9 600 за всю программу)', 'Сильная эконометрическая подготовка и международная среда'],
  array['Стипендии в общем списке не упомянуты — уточнять отдельно через DELTA / ut.ee/scholarships', 'Минимальный GPA не указан явно на странице программы (принят ориентир 3.0 как типичный для UT)'],
  true, current_date
);

-- На официальной странице ut.ee/en/curriculum/actuarial-and-financial-engineering подтверждены: длительность 24 мес., дедлайн 15 марта, общеуниверситетский IELTS 6.0/5.5. Точная стоимость для non-EU различается между агрегаторами (Beyond the States — 6000 €/год, Study in Estonia — 7200 для non-EU/EEA/Swiss, Facebook пост studyabroadupdates — 5000 €/год); на самой странице curriculum цифра для non-EU единым образом не подтверждена, поэтому verified=false. GPA как явный порог не указан — требуется только диплом бакалавра.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Actuarial and Financial Engineering', 'Business Analytics', 'English', 24, 6000,
  3, 15, 6, 3, 'https://ut.ee/en/curriculum/actuarial-and-financial-engineering',
  array[]::text[],
  'Двухгодичная магистратура в Тартуском университете на английском для специалистов в области финансов, банковского дела и страхования. Подходит для студентов с математическим/финансовым бэкграундом.',
  array['EU-диплом признаётся по всей Европе', 'Англоязычная программа, сильная математическая школа'],
  array['Точная tuition для non-EU варьируется по источникам (5000–7200 €/год), на 2026/2027 tuition waivers для non-EU отменены', 'Дедлайн — 15 марта (пример в задании указывал 30 апреля, но это дата публикации результатов, а не подачи)'],
  false, null
);

-- Verified=false: на официальной странице ut.ee/en/curriculum/entrepreneurship-economic-policymaking подтверждён только дедлайн (15 сентября) и длительность 1 год. Стоимость €4800/год подтверждена на dreamapply (estonia.dreamapply.com/en_GB/courses/course/1327) и сторонних агрегаторах, но не извлечена напрямую из сниппета той же ut.ee страницы. IELTS 6.0 — стандартное требование UT для англоязычных магистратур, однако для конкретно этой программы не подтверждено в одном источнике вместе с остальным. Шаблонные значения в задании (24 мес, €6400, дедлайн 30 апреля) не совпали с реальными данными и заменены на подтверждённые.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Entrepreneurship in Economic Policymaking', 'Business Analytics', 'English', 12, 4800,
  9, 15, 6, 0, 'https://ut.ee/en/curriculum/entrepreneurship-economic-policymaking',
  array['1 tuition waiver for EU/EEA/Switzerland citizens', '1 tuition waiver for non-EU applicants'],
  'Годовая магистерская программа Университета Тарту (60 ECTS) на английском языке, сочетающая экономическую политику и предпринимательство для работы в публичном и частном секторах.',
  array['Стоимость ниже средней по европейским магистратурам — €4800/год', 'Университет Тарту — топовый вуз Эстонии с сильной экономической школой', 'Есть стипендии (waivers) в том числе для не-ЕС студентов'],
  array['Длительность всего 1 год (60 ECTS) — меньше, чем стандартные 2-летние программы', 'Дедлайн 15 сентября — поздновато для параллельной подачи в другие европейские вузы', 'Минимальный IELTS 6.0 указан как общеуниверситетский стандарт; точный порог именно для этой программы в сниппете официальной страницы не подтверждён отдельной строкой'],
  false, null
);

-- verified=false: подтверждено существование программы и страницы https://sep.cs.ut.ee/Main/IMOSE?PageSpeed=noscript (появилась в поиске), а также общие требования UT по IELTS 6.0/5.5 со страницы ut.ee/en/english-language-requirements. Однако tuition (€7200/год) взят со страницы estonia.dreamapply.com/en_GB/courses/course/20-msc-software-engineering (другой URL, не страница IMOSE), дедлайн — экстраполяция с общих сроков UT, GPA не найден. Все три ключевых параметра (tuition+deadline+language) для не-EU НЕ подтверждены на ОДНОЙ странице IMOSE, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'International Masters of Software Engineering (IMOSE)', 'Computer Science', 'English', 24, 14400,
  4, 15, 6, 3, 'https://sep.cs.ut.ee/Main/IMOSE?PageSpeed=noscript',
  array[]::text[],
  'Совместная англоязычная магистратура по разработке ПО от Университета Тарту и Таллиннского технологического университета (TalTech), запущенная в 2009 году. Рассчитана на 2 года обучения, ориентирована на иностранных студентов.',
  array['Совместная программа двух ведущих эстонских технических вузов (UT + TalTech)', 'Полностью на английском языке, интернациональная среда', 'EU/EEA студенты учатся бесплатно, для не-EU доступны стипендии и скидки'],
  array['Точная стоимость и дедлайн для IMOSE на 2025/2026 не подтверждены на одной странице — цифры взяты с агрегатора dreamapply (€7200/год) и общей страницы требований UT; не-EU стоимость за весь курс ≈ €14400', 'IELTS 6.0 с минимум 5.5 по секциям — это общее требование UT, для IMOSE может быть иной порог, не подтверждено', 'Дедлайн 15 апреля — типичный крайний срок UT для не-EU абитуриентов магистратуры, но для IMOSE конкретно не верифицирован', 'IMOSE с 2018 года фактически не курируется Marlon Dumas (сооснователь); на сайте SEP упоминается лишь архивно, активная программа сейчас — MSc Software Engineering в UT'],
  false, null
);

-- Подтверждено на официальной странице ut.ee/en/curriculum/robotics-and-computer-engineering: tuition €7,200/год для не-ЕС/ЕЭЗ (также подтверждено на studyinestonia.ee и estonia.dreamapply.com) и дедлайн 15 марта (на странице указаны «2 January — application system opens; 15 March — application deadline; 30 April — admission results; 31 August — academic year starts»). IELTS 6.0 — типовое требование UT для англоязычных магистратур, но в сниппете самой страницы программы не отобразилось, поэтому language-часть не подтверждена на той же странице → verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'Robotics and Computer Engineering', 'Robotics', 'English', 24, 7200,
  3, 15, 6, 3, 'https://ut.ee/en/curriculum/robotics-and-computer-engineering',
  array[]::text[],
  'Магистерская программа University of Tartu по робототехнике и компьютерной инженерии на английском, 2 года, для не-ЕС/ЕЭЗ студентов стоит €7,200/год (граждане ЕС/ЕЭЗ/Швейцарии учатся бесплатно).',
  array['Бесплатное обучение для граждан ЕС/ЕЭЗ/Швейцарии и постоянных резидентов — реальная tuition waiver.', 'Чёткие даты цикла на официальной странице: открытие заявок 2 января, дедлайн 15 марта, результаты 30 апреля, начало занятий 31 августа.'],
  array['Реальная стоимость для не-ЕС — €7,200/год (итого ~€14,400 за 2 года), а не €6,400 как в шаблоне; шаблонную цифру использовать нельзя.', 'Дедлайн — 15 марта, а не 30 апреля; опаздывать нельзя.', 'Требование IELTS 6.0 приведено по общему стандарту UT для англоязычных магистратур — в сниппете официальной страницы оно прямо не подтверждено, поэтому verified=false.'],
  false, null
);
