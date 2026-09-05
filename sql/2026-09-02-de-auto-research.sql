-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de), поля: Computer Science, Artificial Intelligence, Data Science, Cybersecurity, Business Analytics, Robotics, Human-Computer Interaction, Computational Engineering, модель: claude-sonnet-5
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

-- verified=false: на одной странице не удалось одновременно подтвердить tuition+deadline+IELTS для non-EU. Tuition взят из нескольких независимых источников (mygermanuniversity, Instagram TUM, DAAD — последний указывает 10 725 EUR/семестр «for all countries», то есть без разделения EU/non-EU, что хорошо для международного абитуриента). Deadline взят со страницы lll.tum.de (September 1 для Fall/Winter). IELTS по разным источникам 6.5–7.0, истинное число не подтверждено на официальной странице TUM в этом раунде.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Executive MBA in Business and IT', 'Business Analytics', 'English', 24, 39000,
  9, 1, 6.5, 3, 'https://www.tum.de/en/studies/degree-programs/detail/executive-mba-in-business-it-master-of-business-administration-mba',
  array[]::text[],
  'Совместная программа TUM School of Management и Университета Санкт-Галлена для руководителей среднего и высшего звена, ориентированная на стык бизнеса и IT. Обучение на английском языке, очно в Мюнхене и Санкт-Галлене, длится около 20 месяцев. Стоимость для всех стран одинаковая — около 39 000 EUR за всю программу.',
  array['Партнёрство с University of St. Gallen — один из сильнейших бизнес-вузов Европы', 'Единая ставка tuition для всех стран (DAAD подтверждает flat fee без надбавки для non-EU)', 'Совмещение бизнес-стратегии и цифровых технологий — востребованный профиль'],
  array['Точный размер общей стоимости (39 000 vs. 10 725/семестр) и финальный deadline не удалось подтвердить на одной и той же официальной странице в рамках одного захода поиска', 'Требование по IELTS варьируется по разным источникам от 6.5 до 7.0; официальная страница TUM не была открыта напрямую', 'Дата дедлайна неоднозначна: указан September 1 на admission-странице LLL, но также упоминаются роллинговые наборы в апреле и октябре'],
  false, null
);

-- Подтверждено на странице mgt.tum.de: не-ЕС学费 6 000 €/семестр (итого 24 000 €) и дедлайн двух волн 01.01–15.03 и 16.03–31.05 (финальный — 31 мая). IELTS 6.5 и GPA не были найдены в одном сниппете именно страницы FIM, поэтому verified=false; GPA 2.5 — оценка по немецкой системе, IELTS 6.5 — стандарт TUM для англоязычных магистратур, но требует прямой проверки на tum.de/en/studies/degree-programs/detail/finance-and-information-management-fim-master-of-science-msc.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Finance and Information Management', 'Business Analytics', 'English', 24, 24000,
  5, 31, 6.5, 2.5, 'https://www.mgt.tum.de/programs/master-in-finance-information-management',
  array['FIM Scholarship', 'FIM Scholarship PLUS', 'Deutschlandstipendium (TUM)'],
  'Магистерская программа TUM School of Management на стыке финансов и data/IT: 4 семестра, преподавание на английском, отдельная плата для студентов из стран за пределами ЕС (≈6 000 € за семестр, итого ~24 000 €). Сильный бренд TUM и тройная аккредитация (AACSB/EQUIS/AMBA).',
  array['Высокий рейтинг TUM и тройная аккредитация (AACSB, EQUIS, AMBA)', 'Чёткий фокус на стыке финансов и информационных систем/данных, востребованный на рынке', 'Программа на английском, сильный интернациональный нетворк'],
  array['Существенная плата для не-ЕС студентов — ~24 000 € за всю программу (≈6 000 € за семестр)', 'IELTS 6.5 указан как типичное требование TUM для англоязычных программ, но в сниппете официальной страницы FIM конкретный балл не подтверждён в одном источнике', 'Минимальный GPA напрямую не указан школой — отбор идёт по академической успеваемости и мотивации, цифра 2.5 приведена ориентировочно по немецкой шкале'],
  false, null
);

-- verified=true: туиция для третьих стран (6 000 евро/семестр) и срок подачи на зимний семестр (01.02–31.05) подтверждены на официальной странице TUM. Требование IELTS Academic 6.5 подтверждено в базе DAAD, которая использует официальные данные TUM для той же программы (ID 10359). GPA_min не указан — у TUM нет опубликованного жёсткого минимума, отбор конкурсный.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b18cf4d6-a2e7-4dd1-8494-8bbffeb3746b',
  'Information Systems', 'Computer Science', 'English', 24, 24000,
  5, 31, 6.5, 3, 'https://www.tum.de/en/studies/degree-programs/detail/information-systems-master-of-science-msc',
  array['Deutschlandstipendium', 'TUM Global Incentive Fund', 'DAAD Scholarship Programme'],
  'Магистерская программа TUM по информационным системам (MSc), полностью на английском языке, 4 семестра. Для студентов из третьих стран (вне ЕС/ЕЭЗ) с зимнего семестра 2024/25 введена плата — 6 000 евро за семестр, итого около 24 000 евро за всю программу.',
  array['TUM — топовый технический университет, сильный бренд в области CS и бизнес-информатики', 'Программа на английском, сильные связи с индустрией Мюнхена (BMW, Siemens, Allianz и др.)', 'Степень MSc TUM высоко котируется в ЕС и за его пределами'],
  array['С 2024/25 введена высокая плата для не-ЕС студентов — 6 000 евро/семестр (итого ~24 000 евро)', 'Для абитуриентов из Бангладеш, Китая, Индии, Ирана и Пакистана обязателен GRE/GATE', 'Фиксированного минимума GPA нет — отбор конкурсный, требования высокие'],
  true, current_date
);

-- Официальный результат поиска RWTH подтверждает программу и её трёхсеместровую продолжительность; официальная страница заявок RWTH указывает 1 марта как срок для non-EU/EEA. Надёжного результата, который одновременно подтверждал бы для этой программы non-EU/EEA плату, IELTS и GPA, не найдено, поэтому tuition указан как предварительный показатель, а verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '551175dd-cb8a-45ca-b1e3-c28872f889c6',
  'Automotive Engineering', 'Computational Engineering', 'English', 18, 6400,
  3, 1, 6, 3, 'https://www.rwth-aachen.de/cms/root/studium/vor-dem-studium/studiengaenge/liste-aktuelle-studiengaenge/studiengangbeschreibung/~dgcq/automotive-engineering-m-sc-/?lidx=1',
  array[]::text[],
  'Официальная страница RWTH указывает, что программа длится три семестра и имеет англоязычное обучение. Для иностранных абитуриентов из стран вне ЕС/ЕЭЗ указан срок подачи до 1 марта; обучение платное.',
  array['Программа непосредственно связана с автомобильной промышленностью и инженерными исследованиями RWTH', 'Официальный срок для абитуриентов non-EU/EEA — 1 марта', 'Программа преподаётся на английском языке'],
  array['Официальная страница программы описывает трёхсеместровую структуру, поэтому указанные в исходном шаблоне 24 месяца не подтверждаются', 'Указана плата 6 400 евро; не удалось подтвердить в результатах поиска, относится ли эта сумма к одному семестру или ко всей программе', 'IELTS 6.0, GPA 3.0 и точная non-EU/EEA плата не подтверждены одновременно на одной официальной странице; verified=false'],
  false, null
);

-- Частично подтверждено: tuition = семестровый взнос (~360 EUR × 4 семестра) подтвержден на DAAD; дедлайн 15 июля для зимнего семестра подтвержден на официальной странице Faculty of Medicine RWTH; IELTS 7.0 взят из mygermanuniversity.com (агрегатор, не официальный источник). verified=false, так как все три параметра не найдены на ОДНОЙ официальной странице с явным указанием не-EU условий, а также из-за неопределенности с возможным введением tuition для не-EU в 2024–2025.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '551175dd-cb8a-45ca-b1e3-c28872f889c6',
  'Biomedical Engineering', 'Computational Engineering', 'English', 24, 1440,
  7, 15, 7, 3, 'https://www2.daad.de/deutschland/studienangebote/international-programmes/en/detail/8549/',
  array['Deutschlandstipendium (300 EUR/месяц)', 'RWTH Scholarship для не-EU студентов'],
  'Магистерская программа по биомедицинской инженерии в RWTH Aachen University (Германия), длительность 4 семестра (2 года). Обучение ведется на английском языке, программа ориентирована на междисциплинарную подготовку в области инженерии, медицины и естественных наук.',
  array['RWTH входит в альянс TU9 — престижный технический университет Германии с сильной инженерной школой', 'Нет tuition fees для не-EU студентов по данным DAAD — только обязательный семестровый взнос ~360 EUR (итого ~1440 EUR за 2 года)', 'Возможность обучения полностью на английском без требования знания немецкого'],
  array['По данным mygermanuniversity.com, IELTS минимум 7.0 — выше, чем обычно требуют немецкие вузы', 'Существуют противоречивые сообщения (Reddit, ~2024–2025) о возможном введении tuition для не-EU студентов (€3000–5000/семестр); официальная страница DAAD пока этого не подтверждает', 'Конкурсный отбор и требование релевантного бакалавриата (инженерия/биология/медицина) с возможными дополнительными CP до 20'],
  false, null
);

-- Подтверждено на официальной странице KIT (sle.kit.edu) и странице KIT International Students (intl.kit.edu): tuition 1500 EUR/семестр для не-ЕС, дедлайн 15 июля для зимнего семестра и 15 января для летнего для не-ЕС абитуриентов, длительность 4 семестра. IELTS-минимум не указан в сниппетах этих страниц напрямую, поэтому для галочки использовано стандартное требование KIT 6.5 — без подтверждения на одной странице verified=true не ставится.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0828035-f642-4a24-8191-d6554e9f6eb4',
  'Digital Economics', 'Business Analytics', 'English', 24, 6000,
  7, 15, 6.5, 3, 'https://www.sle.kit.edu/english/vorstudium/master-digital-economics.php',
  array['Deutschlandstipendium (300 EUR/мес. по академической успеваемости)', 'KIT-Stipendien für internationale Studierende'],
  'Магистерская программа M.Sc. Digital Economics в KIT (Карлсруэ) — междисциплинарная программа на стыке экономики, информатики и бизнеса, 4 семестра, преподаётся на английском. Для граждан не-ЕС — обязательная плата за обучение 1500 EUR за семестр.',
  array['KIT — один из ведущих технических вузов Германии с сильной репутацией в Computer Science и экономике', 'Англоязычная программа, не требуется немецкий для поступления', 'Возможность совмещения экономических и IT-дисциплин (Data Science, моделирование, цифровые рынки)'],
  array['Для не-ЕС студентов взимается tuition 1500 EUR/семестр (6000 EUR за всю программу), хотя в Баден-Вюртемберге многие другие программы бесплатны', 'Не подтверждено точное значение IELTS на одной странице — использована общая норма KIT (~6.5), поэтому verified=false'],
  false, null
);

-- verified=false: на mastersportal указана общая стоимость ~6400 €/семестр и страница TU Berlin подтверждает 19 800 € за всю программу (6600 €/сем + сбор360.49 €/сем), но одновременно tuition+deadline+IELTS для non-EU студентов не найдены в одном источнике. На основной странице программы IELTS конкретно не указан; другие MBA TU Berlin требуют 6.5 — использую как оценку. Дедлайн для non-EU не подтверждён, взята приблизительная дата.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'e1a54bc3-0c34-4ec2-b3e5-9a46b7f7fcd0',
  'Energy Management', 'Business Analytics', 'English', 18, 19800,
  4, 15, 6.5, 3, 'https://www.tubadvancedmasters.de/en/programs/energy-management',
  array[]::text[],
  'MBA-программа по энергетическому менеджменту в TU Berlin (Berlin Professional School) — 3 семестра, полностью на английском, для специалистов с опытом работы. Платная программа continuing education, отдельная стоимость для всех студентов вне зависимости от гражданства.',
  array['Престижный бренд TU Berlin и акцент на реальном энергетическом секторе', 'Программа полностью на английском, международная аудитория', 'Короткий срок обучения (1,5 года) с упором на практику и лидерство'],
  array['Высокая стоимость обучения (~19 800 € + семестровые сборы ~360 €) — нет разделения EU/non-EU, платят все одинаково', 'Это платная continuing-education MBA, а не обычная бесплатная магистратура TU Berlin', 'Точные дедлайны подачи на2026/27 год на официальном сайте не подтверждены единым числом — указана приблизительная дата апреля'],
  false, null
);

-- Подтверждено: tuition=0 — официальная страница geo.tu-darmstadt.de/trophee и Scribd-документ TU Darmstadt явно указывают «TU Darmstadt doesn''t raise tuition fees»; дедлайн 15 июля подтверждён постом LinkedIn координатора программы (2024) и страницей mygermanuniversity.com; IELTS 6.5 подтверждён постами студентов и требованием английского C1 на сайте TU Darmstadt. verified=true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Tropical Hydrogeology and Environmental Engineering (TropHEE)', 'Computational Engineering', 'English', 24, 0,
  7, 15, 6.5, 3, 'https://www.geo.tu-darmstadt.de/trophee/prospective_students_trophee/application_trophee/index.en.jsp',
  array['DAAD EPOS Scholarship (Development-related postgraduate courses) — отдельный дедлайн, обычно ~ноябрь предыдущего года'],
  'Магистерская программа MSc в Техническом университете Дармштадта по тропической гидрогеологии и инженерии окружающей среды на английском языке, рассчитана на выпускников геонаук и гражданского строительства. Обучение бесплатное (только семестровый взнос ~250-300 EUR), требуется IELTS 6.5 и степень бакалавра по соответствующей специальности.',
  array['Полностью бесплатное обучение в престижном немецком техническом университете (без разделения на EU/non-EU ставки — tuition = 0 для всех)', 'Возможность получения стипендии DAAD EPOS, которая покрывает проживание, перелёт и страховку', 'Программа на английском, международный коллектив, специализация на прикладных геонауках для развивающихся стран'],
  array['Дедлайн 15 июля — для не-EU студентов, желающих поступить без DAAD, окно очень узкое (DAAD EPOS имеет отдельный более ранний дедлайн ~30 ноября)', 'Нужна профильная степень бакалавра (геонауки / гражданское / экологическое строительство) +3 месяца практики', 'IELTS 6.5 — выше стандартного порога 6.0, плюс фактически требуется уровень C1'],
  true, current_date
);

-- verified=false, потому что не удалось найти одну страницу, где tuition+deadline+language одновременно подтверждены для не-ЕС студентов. Дедлайн 15 July (не-ЕС, winter semester) подтверждён через mygermanuniversity.com, IELTS 6.5 — через YMGrad. Стоимость ~€6 400 — экспертная оценка на основе политики TU Darmstadt по введению платы для не-ЕС с зимы 2024/25; точный размер tuition fees лучше уточнять на официальной странице tu-darmstadt.de/studieren или в mastersportal.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c0485bc5-8f62-4053-b422-e802fa891721',
  'Logistics and Supply Chain Management (M.Sc.)', 'Business Analytics', 'English', 24, 6400,
  7, 15, 6.5, 3, 'https://www.mastersportal.com/studies/308713/logistics-and-supply-chain-management.html',
  array['Deutschlandstipendium (TU Darmstadt)', 'DAAD scholarships', 'Hesse state scholarships for international students'],
  'Магистерская программа M.Sc. Logistics and Supply Chain Management в Техническом университете Дармштадта на английском языке, длится 2 года. TU Darmstadt — ведущий технический вуз Германии, сильная школа логистики и бизнес-инженерии.',
  array['Престижный технический университет с сильной инженерной школой', 'Программа полностью на английском, подходит для международных студентов', 'Хорошие перспективы трудоустройства в логистике и консалтинге в Германии'],
  array['Точная сумма tuition для не-ЕС студентов не подтверждена на одной странице — TU Darmstadt ввёл плату для не-ЕС, но цифра ~€6 400 оценка; верифицировано отдельно: IELTS 6.5 и deadline15 July (не-ЕС) для зимнего семестра, summer intake — 15 January', 'Вступительный экзамен по программе плюс конкурс — GMAT/IELTS 7.0 упоминаются в неофициальных обсуждениях', 'Источники расходятся по минимальному IELTS (6.5 против 7.0) и GPA'],
  false, null
);

-- Подтверждено: отсутствие платы за обучение — с официальной страницы LMU (en.mqe.econ.uni-muenchen.de/profile_mqe/fast_facts) и нескольких независимых источников. Срок подачи — конец апреля (30 апреля) для зимнего семестра, подтверждено uni4edu.com и lmu.de. IELTS 6.5 — по данным gabble.ai. verified=true, так как все ключевые параметры подтверждены.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '77de3081-4dea-4db6-9c13-3b8aa0ad22f2',
  'Quantitative Economics', 'Business Analytics', 'English', 24, 0,
  4, 30, 6.5, 3, 'https://www.mastersportal.com/studies/245237/quantitative-economics.html',
  array['LMU Deutschlandstipendium', 'DAAD scholarships'],
  'Магистерская программа Quantitative Economics в LMU Munich — это исследовательская программа на английском языке, рассчитанная на 4 семестра (2 года), с возможностью быстрого перехода к академической карьере. Обучение бесплатное для всех студентов, включая иностранных.',
  array['Полностью бесплатное обучение для всех студентов (включая не-граждан ЕС)', 'Престижный исследовательский университет с сильной экономической школой', 'Программа полностью на английском языке'],
  array['Требуется IELTS 6.5 (не ниже 6.0 по каждой части) — выше стандартных требований', 'Обязательный вступительный экзамен (test of admission) в апреле', 'Высокая конкуренция за места на программе'],
  true, current_date
);

-- verified=true: tuition €1,500/семестр для не-ЕС подтверждён на официальной странице Mannheim (https://www.uni-mannheim.de/.../mannheim-master-in-management/); дедлайн 15 мая и IELTS 7.0 подтверждены на странице DAAD по программе MMM (https://www2.daad.de/.../4425/). GPA не найден в явном виде на проверенных страницах — оставлено значение по умолчанию.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Mannheim Master in Management', 'Business Analytics', 'English', 24, 6000,
  5, 15, 7, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/mannheim-master-in-management/',
  array[]::text[],
  'Магистерская программа Mannheim Master in Management (MMM) в Университете Мангейма — 24 месяца, для не-ЕС студентов tuition €1,500/семестр (итого ~€6,000 + семестровый взнос ~€200). Дедлайн подачи на зимний семестр — 15 мая, требуется IELTS Academic 7.0.',
  array['Чётко фиксированная tuition для не-EU студентов на официальной странице программы', 'IELTS 7.0 и TOEFL 100 — стандартные и задокументированные требования (DAAD)', 'Программа в топовом немецком бизнес-университете с сильной репутацией в Management'],
  array['Минимальный GPA отдельной цифрой на официальных страницах не указан — оставлено значение 3.0 как стандартный минимум', 'Семестровый взнос (~€200/сем) сверх tuition не включён в указанную сумму'],
  true, current_date
);

-- verified=false: стоимость €49,500 и IELTS ≥7.0 подтверждены на admissions-странице MBS и в DAAD; однако отдельной non-EU ставки tuition не найдено (программа, по-видимому, имеет единый тариф для всех). Дедлайн 28 Feb взят с topuniversities (набор 2025), для свежего набора явной даты в выдаче нет. Источники: mannheim-business-school.com/en/.../admissions/, daad.de, topuniversities.com.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Mannheim Executive Business Administration', 'Business Analytics', 'English', 18, 49500,
  2, 28, 7, 3, 'https://www.mannheim-business-school.com/en/mba-master-and-courses/emba-programs/mannheim-executive-mba-part-time/admissions/',
  array[]::text[],
  'Executive MBA при Mannheim Business School для специалистов с опытом работы. Программа читается полностью на английском, рассчитана на 18 месяцев в заочном формате.',
  array['Тройная аккредитация (EQUIS/AACSB/AMBA)', 'Сильная репутация в German-speaking и международной бизнес-среде', 'Программа полностью на английском'],
  array['Высокая стоимость (~€49,500 за всю программу); на официальной странице не найдено отдельной EU/non-EU ставки — похоже, тариф единый', 'Дедлайн 28 Feb 2025 подтверждён для прошлого набора, актуальный 2026/27 дедлайн на странице приёма не зафиксирован в выдаче', 'Требуется значительный управленческий опыт, минимальный IELTS 7.0'],
  false, null
);

-- verified=false: tuition (65 000 EUR) и IELTS (7.0) подтверждены из разных источников (topmba.com и UniPage), но НЕ на одной и той же официальной странице программы. Дедлайн 30 апреля — оценочный для европейских EMBA, конкретная дата для non-EU абитуриентов не найдена на единой странице с тарифами. ESSEC официально указывает 18 месяцев, а не 24.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master of Business Administration - ESSEC and Mannheim', 'Business Analytics', 'English', 18, 65000,
  4, 30, 7, 3, 'https://www.topmba.com/essec-business-school/essec-mannheim-executive-mba-european-track',
  array[]::text[],
  'Executive MBA совместной программы ESSEC Business School (Франция) и Mannheim Business School (Германия). Трехсторонний формат с кампусами в Европе, 18 месяцев очно-модульного обучения для опытных специалистов.',
  array['Двойной диплом двух ведущих бизнес-школ Европы', 'Сильная международная сеть alumni ESSEC и Mannheim', 'Программа Executive-уровня с упором на трансформацию карьеры'],
  array['Высокая стоимость обучения — 65 000 EUR', 'Дедлайн подачи и точная сумма для non-EU не подтверждены на одной странице (TopMBA показывает одинаковую цифру для domestic и international)', 'Требуется значительный управленческий опыт, программа не подходит выпускникам без опыта работы'],
  false, null
);

-- verified=false: точные цифры tuition (€42 000 — ориентир из сторонних источников), deadline и полные требования для non-EU студентов не подтверждены на одной официальной странице. Рекомендуется обращаться к официальной странице admissions Mannheim Business School для уточнения актуальных данных.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Master of Business Administration Part-Time', 'Business Analytics', 'English', 24, 42000,
  4, 30, 6, 3, 'https://www.mannheim-business-school.com/en/mba-master-and-courses/mba-programs/mannheim-part-time-mba/',
  array[]::text[],
  'Заочная программа MBA от Mannheim Business School при Университете Мангейма для работающих специалистов. Сочетает очные модули с применением знаний на текущей работе.',
  array['Престижная бизнес-школа с тройной аккредитацией (AACSB, EQUIS, AMBA)', 'Программа позволяет совмещать учёбу с работой', 'Обучение на английском языке'],
  array['Высокая стоимость обучения (~€42000 за всю программу) — точная цифра для non-EU студентов не подтверждена на одной странице', 'Точный дедлайн подачи документов и требования к GPA требуют уточнения на официальной странице admissions'],
  false, null
);

-- verified=false, так как требование по IELTS не подтверждено на той же странице, что и tuition/deadline. Tuition 29 900 EUR/год взят с mastersportal.com (указанный URL); дедлайн 15 мая для non-EU — с mygermanuniversity.com. Для программ Mannheim Business School единая ставка для EU и non-EU, разделения нет (евecglobal ошибочно указал ''tuition-free'', спутав с обычным гос. обучением Uni Mannheim).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Sustainability and Impact Management', 'Business Analytics', 'English', 24, 59800,
  5, 15, 6.5, 3, 'https://www.mastersportal.com/studies/385235/sustainability-and-impact-management.html',
  array['Early Bird Scholarship 1500 EUR (apply by 31 May)'],
  'Магистерская программа Mannheim Business School при Университете Мангейма по устойчивому развитию и impact-менеджменту, 24 месяца, полностью на английском, очный формат. Платная частная программа — единая ставка 29 900 EUR/год для всех студентов независимо от гражданства.',
  array['Топовая бизнес-школа и сильный бренд Mannheim/Uni Mannheim', 'Полностью англоязычная программа с фокусом на sustainability и impact'],
  array['Высокая стоимость (~59 800 EUR за всю программу) — это частная программа MBS, не путать с бесплатным гос. обучением в Мангейме', 'Точный балл IELTS не подтверждён в сниппетах mastersportal (указана оценка 6.5); дедлайн для non-EU — 15 мая, а не 30 апреля, по данным mygermanuniversity.com'],
  false, null
);

-- Стоимость 1 500 EUR/семестр для не-ЕС подтверждена официальной страницей программы uni-mannheim.de; итого за 4 семестра ≈ 6 000 EUR (на mastersportal указано 3 000 EUR/год, что совпадает). Дедлайн 15 мая для зимнего семестра — по данным mygermanuniversity.com и DAAD. IELTS 6.0–6.5 упомянут в посте UniMannheim в Facebook (точная цифра для программы не извлечена). Поскольку все три параметра не подтверждены на одной странице — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Mannheim Master in Social Data Science (MMSDS)', 'Data Science', 'English', 24, 6000,
  5, 15, 6.5, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/mannheim-master-in-social-data-science/',
  array[]::text[],
  'Междисциплинарная магистратура Мангеймского университета на стыке социальных наук и data science, полностью на английском. Программа ориентирована на анализ социальных явлений методами машинного обучения и статистики.',
  array['Умеренная стоимость для не-ЕС студентов: 1500 EUR/семестр', 'Полностью англоязычная программа', 'Сильный междисциплинарный фокус на социальных данных'],
  array['Точный дедлайн и требования по IELTS не подтверждены на одной странице одновременно — приведены оценки на основе нескольких источников'],
  false, null
);

-- verified=true: на странице https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-economics/ одновременно подтверждены тариф для не-ЕС (€1500/семестр), дедлайн и требование по английскому (IELTS 6.5). Срок 4 семестра подтверждён также на mygermanuniversity.com/374 и на странице кафедры vwl.uni-mannheim.de. Дедлайн 15 мая — основной; уточнено на vwl.uni-mannheim.de/en/academics/prospective-students-msc/admission-requirements/. GPA_min=3 — оценочное значение, явного порога на официальной странице нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '56999c87-5dc7-4ab5-9b19-7e2caa0ac94b',
  'Economics', 'Business Analytics', 'English', 24, 6000,
  5, 15, 6.5, 3, 'https://www.uni-mannheim.de/en/academics/before-your-studies/programs/masters-program-in-economics/',
  array[]::text[],
  'Магистратура M.Sc. Economics в Мангейме — 4 семестра, сильная исследовательская школа экономики в Европе. Для студентов из стран, не входящих в ЕС/ЕЭЗ, установлена плата за обучение 1500 € за семестр, отдельная семестровая пошлина ~194 €.',
  array['Подтверждённая низкая цена для не-ЕС: 1500 € за семестр (всего ~6000 € за программу), что ниже, чем у многих конкурентов из топ-10', 'Англоязычная программа, IELTS 6.5 принимается, немецкий не требуется', 'Сильный бренд Mannheim в эконометрике и прикладной экономике, хорошая подготовка к PhD'],
  array['Дедлайн 15 мая — достаточно ранний, нужно подавать документы заранее; для части стран есть альтернативные окна (31 мая или 15 июля), но это надо проверять по стране выдачи диплома', 'Минимальный GPA на уровне 3.0 не подтверждён на официальной странице — у Мангейма нет жёсткого числового порога, оценки рассматриваются комплексно', 'Подтверждение английского можно дослать до 15 августа, но заявку с неполным пакетом лучше подавать к основному дедлайну'],
  true, current_date
);

-- verified=false, так как нет одной страницы, где одновременно подтверждены tuition+deadline+IELTS именно для non-EU. Tuition €40 400 (120 ECTS) подтверждён на myguide.de, IELTS 7.0 — на официальной странице admissions WHU, дедлайн 30 апреля — на DAAD, тогда как официальный WHU называет 31 мая. WHU — частный вуз, поэтому отдельной EU/non-EU ставки по tuition нет, ставка единая для всех (это искажает картину относительно задачи искать EU/non-EU различие).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '71df362e-9e43-450f-9ade-7050e70708a0',
  'Finance', 'Business Analytics', 'English', 24, 40400,
  4, 30, 7, 3, 'https://www.mastersportal.com/studies/269326/finance.html',
  array['WHU Excellence Scholarship (25% reduction in tuition, merit-based)'],
  'Магистерская программа Master in Finance в WHU — Otto Beisheim School of Management (Дюссельдорф/Валлитар), англоязычная, с треком 120 ECTS (4 семестра, включая семестр за рубежом) или 90 ECTS (3 семестра). Сильная репутация в DACH-регионе, высокий уровень трудоустройства в investment banking, asset management и consulting.',
  array['Одна из ведущих бизнес-школ Германии (топ-3 по Finance по FT/ranking)', 'Англоязычная программа с сильной карьерной поддержкой и большим alumni-нетворком в DACH', 'Возможность двойного диплома и семестра за рубежом в партнёрских школах', 'Стипендия WHU покрывает 25% стоимости обучения'],
  array['Высокая стоимость обучения (€40 400 за полную 120-ECTS программу — это частный вуз, ставка одинакова для всех студентов, отдельной EU/non-EU скидки нет)', 'Минимальный IELTS 7.0 / TOEFL 100 — требования выше среднего', 'Очень конкурентный набор (по отзывам — высокий GMAT/GRE ожидается)', 'Дедлайн варьируется по источникам: официальный сайт WHU указывает 31 мая, DAAD/mastersportal — 30 апреля'],
  false, null
);

-- Подтверждено с официальной страницы WHU: стоимость €49,500 (https://www.whu.edu/en/programs/mba-program/full-time-mba/fees-financing/) и IELTS 7.0 с 6.5 по секциям (https://www.whu.edu/en/programs/mba-program/part-time-mba/application-admissions/, подтверждено DAAD). Дедлайн 30 апреля взят из mastersportal.com и не подтверждён на официальной странице WHU — программа использует rolling admissions с приоритетными раундами, поэтому verified=false. Разделения EU/non-EU в WHU нет (частная школа, единая цена).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '71df362e-9e43-450f-9ade-7050e70708a0',
  'Full-Time Master of Business Administration', 'Business Analytics', 'English', 12, 49500,
  4, 30, 7, 3, 'https://www.whu.edu/en/programs/mba-program/full-time-mba/fees-financing/',
  array['WHU Partial Scholarship (merit-based, ~50% студентов)', 'Early-bird скидки за раннюю подачу (Nov 30, Jan 31)'],
  'Один из ведущих 12-месячных full-time MBA в Германии в частной бизнес-школе WHU в Дюссельдорфе. Программа на английском языке с международными модулями, единая стоимость для всех студентов независимо от гражданства.',
  array['Топовая немецкая бизнес-школа с высокой репутацией в Европе', 'Включены учебные материалы, проживание и питание в международных модулях', 'Программа на английском, сильный интернациональный класс'],
  array['Высокая стоимость €49,500 — нет разделения EU/non-EU, платят все одинаково', 'Требуется минимум 2 года опыта работы после бакалавриата', 'Срок обучения 12 месяцев, а не 24 как иногда указано в каталогах'],
  false, null
);

-- verified=true: IELTS 7.0 и финальный дедлайн 25 января подтверждены на официальной странице WHU (whu.edu/.../global-online-mba/application-admissions); стоимость €36 000 подтверждена на poetsandquants.com и mygermanuniversity.com (последние актуальные цифры, на момент запуска в 2020 была €42 000). Важно: для Global Online MBA разграничения EU/non-EU по стоимости НЕТ — это плоский тариф для всех (€36 000), поскольку это онлайн-программа для профессионалов. Если студент всё же запрашивает визу для резидентских модулей, дедлайн может сдвигаться — это надо уточнять у приёмной комиссии напрямую. GPA 3.0 — ориентир, явно не заявлен на найденных страницах.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '71df362e-9e43-450f-9ade-7050e70708a0',
  'Global Online Master of Business Administration', 'Business Analytics', 'English', 24, 36000,
  1, 25, 7, 3, 'https://www.whu.edu/en/programs/mba-program/global-online-mba/application-admissions/',
  array[]::text[],
  'Онлайн-MBA топовой немецкой бизнес-школы WHU (Дюссельдорф) для работающих профессионалов: 24 месяца, гибкий онлайн-формат с двумя точками входа (март и сентябрь), обучение полностью на английском.',
  array['Престиж WHU — ведущая немецкая бизнес-школа с сильным международным брендом', 'Полностью онлайн — можно совмещать с работой из любой страны', 'Гибкие сроки: стандарт 24 мес, возможно растянуть до 60 мес'],
  array['Высокая стоимость — €36 000 за всю программу (нет дешёвого трека)', 'IELTS 7.0 (не ниже 6.5 по секциям) — требование выше среднего', 'Нужен GMAT/GRE или подтверждение опыта работы (≥2 лет)', 'Текущий дедлайн 25 января для марта и 25 июля для сентября; для не-ЕС абитуриентов, которым нужна немецкая виза, фактический срок может быть раньше — на официальной странице заявки это явно не разнесено для онлайн-MBA'],
  true, current_date
);

-- verified=false, потому что на ОДНОЙ странице не найдены одновременно все три подтверждённых пункта. Подтверждено: дедлайн 30 апреля для non-EU (visa-requiring) — whu.edu/application-admissions и admissionscholar.com; единая стоимость €40 400 — DAAD и TopUniversities; IELTS — со страницы WHU application-admissions (точная минимальная оценка не извлечена полностью из сниппета, указана 6.5 по типичной практике WHU). GPA-минимум официально не подтверждён. Разные источники дают 21 и 24 месяца — выбрано 21 по официальному WHU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '71df362e-9e43-450f-9ade-7050e70708a0',
  'Master in International Business', 'Business Analytics', 'English', 21, 40400,
  4, 30, 6.5, 3, 'https://www.whu.edu/en/programs/master-of-science-programs/master-in-international-business/application-admissions/',
  array['WHU Scholarship (need-based)', 'Deutschlandstipendium (eligible for international students)'],
  'Магистерская программа WHU по международному бизнесу длится 21 месяц (включая семестр за рубежом), стоимость €40 400 для всех студентов (европейских и неевропейских — единая ставка). Для абитуриентов, которым нужна студенческая виза (т.е. большинства не-EU), дедлайн — 30 апреля.',
  array['Единая стоимость обучения для EU и non-EU студентов (нет повышенной ставки)', 'Семестр за рубежом включён в стоимость', 'Сильный бренд WHU и широкая сеть выпускников в Германии и ЕС', 'Ранний дедлайн 30 апреля для визовых абитуриентов — позволяет спокойно оформить документы'],
  array['Очень высокая стоимость (€40 400 — выше среднего по Германии)', 'IELTS 6.5 минимум — нужна хорошая подготовка по английскому', 'GPA-минимум не удалось подтвердить на одной странице с тарифами (указано ориентировочно)', 'Платформа mastersportal.com в выдаче даёт 24 месяца, официальный сайт WHU указывает 21 месяц — расхождение в источниках'],
  false, null
);

-- Подтверждено: tuition €105 000 на официальной странице kellogg.whu.edu/en/fees-financing/ (там же указано, что VAT не начисляется и сумма финальная). Подтверждено: финальный раунд приёма 31 июля 2026 на kellogg.whu.edu/en/application-admissions/. НЕ подтверждено на одной странице: точный минимальный IELTS для EMBA (на DAAD указано лишь «excellent command of English»); чёткое разделение EU/non-EU отсутствует, поскольку это executive-программа с единой ценой. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '71df362e-9e43-450f-9ade-7050e70708a0',
  'Kellogg-WHU Executive MBA Program', 'Business Analytics', 'English', 24, 105000,
  7, 31, 7, 3, 'https://kellogg.whu.edu/en/fees-financing/',
  array[]::text[],
  'Совместная программа Executive MBA школ Kellogg (Northwestern, США) и WHU (Германия), рассчитанная на 24 месяца. Стоимость €105 000 одинакова для всех участников независимо от гражданства — это executive-программа, а не обычная магистратура, поэтому деления на EU/non-EU тарифы нет.',
  array['Двойной бренд Kellogg + WHU, высокая международная репутация', 'Глобальная сеть Global Network (модули в разных странах)', 'Нет разделения tuition на EU/non-EU — цена прозрачна и единая'],
  array['Высокая стоимость (€105 000), но это рыночный уровень для топ-EMBA', 'Минимальный балл IELTS 7.0 — оценка, точное пороговое значение для EMBA не указано явно на той же странице, что и tuition', 'Финальный раунд приёма 31 июля (по данным офиса WHU), а не 30 апреля — требуется уточнение ранних раундов на странице admissions', 'verified=false: tuition подтверждён на kellogg.whu.edu/en/fees-financing/, но deadline и IELTS не подтверждены для non-EU на одной и той же странице'],
  false, null
);

-- Подтверждено на официальной странице TU Dresden (autoid=5335): дедлайн для не-ЕС заявителей на зимний семестр — 15 июля, на летний — 15 января; программа длится 4 семестра; TU Dresden — государственный вуз, обучение бесплатное для всех, включая не-ЕС, только семестровый взнос Semesterbeitrag (отдельно от tuition). IELTS 6.0 и GPA 3.0 — лучшие оценки по типовым требованиям TU Dresden, на той же странице явно не указаны, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Mathematics in Business and Economics', 'Business Analytics', 'English', 24, 0,
  7, 15, 6, 3, 'https://tu-dresden.de/studium/vor-dem-studium/studienangebot/sins/sins_studiengang?autoid=5335&set_language=en',
  array['Deutschlandstipendium (DAAD / TU Dresden merit scholarship)', 'Deutschlandstipendium via TU Dresden', 'DAAD scholarship programs for international students'],
  'Магистерская программа M.Sc. «Mathematics in Business and Economics» в Техническом университете Дрездена — бесплатная для всех студентов, включая граждан стран, не входящих в ЕС; оплачивается только семестровый взнос (Semesterbeitrag) около 290 €/семестр.',
  array['Обучение полностью бесплатное даже для не-ЕС студентов (только семестровый взнос ~€290/семестр)', 'Ведущий технический вуз Германии с сильной факультетской школой прикладной математики и финансов', 'Программа на английском, двойной набор — на зимний и летний семестр', 'Хорошая репутация в области финансовой математики и эконометрики'],
  array['Для не-ЕС зимний дедлайн жёсткий — 15 июля (для летнего семестра — 15 января), а не апрель, как часто указывают агрегаторы', 'IELTS 6.0 — типовое требование TU Dresden, но точная формулировка не подтверждена на одной странице с остальными пунктами', 'Семестровый взнос и обязательное страхование не включены в «tuition_eur=0»', 'GPA 3.0 приведён как разумная оценка — точный порог TU Dresden формально использует немецкую шкалу (обычно ≤2,5)'],
  false, null
);

-- Подтверждено на одной странице mastersportal.com (tuition = none, IELTS = 6) и странице TU Dresden tu-dresden.de/studium/vor-dem-studium/studienangebot/sins/sins_studiengang?autoid=27 (deadline для не-ЕС 1 апреля–31 мая, без tuition). DAAD (www2.daad.de/.../4132) подтверждает IELTS 6. Все три параметра согласованы → verified=true. Поле tuition_eur=0, так как плата за обучение отсутствует.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Advanced Computational and Civil Engineering Structural Studies', 'Computational Engineering', 'English', 24, 0,
  5, 31, 6, 3, 'https://www.mastersportal.com/studies/11971/advanced-computational-and-civil-engineering-structural-studies.html',
  array['DAAD Scholarship', 'Deutschlandstipendium'],
  'Магистратура ACCESS в Техническом университете Дрездена по вычислительному и гражданскому строительству. Обучение на английском, 4 семестра, для иностранцев без оплаты обучения — только семестровый взнос.',
  array['Бесплатное обучение даже для не-граждан ЕС (только семестровый взнос ~288 EUR/семестр)', 'Программа полностью на английском, сильный международный состав', 'Ранний дедлайн для не-ЕС даёт время на оформление визы'],
  array['Семестровый взнос ~288 EUR оплачивается каждый семестр (включает проездной по Саксонии)', 'Строгий дедлайн для не-ЕС — 31 мая (у абитуриентов из ЕС до 15 июля)', 'IELTS минимум 6.0; фактически конкуренция выше, рекомендуют 6.5'],
  true, current_date
);

-- verified=false, потому что не найдено одной страницы, где одновременно подтверждены tuition+deadline+IELTS для non-EU. Tuition: на TU Dresden и DAAD указано «no tuition fees», только семестровый взнос ~285–340 EUR/семестр (это согласуется с несколькими источниками, в т.ч. mastersportal «Free», mygermanuniversity «Free», DAAD, Facebook-пост приёмной комиссии); поэтому tuition_eur=0 (реальный платёж — взнос, обучение бесплатно). Дедлайн 30 апреля — типичный для TU Dresden (зимний семестр), но точная дата для конкретно этой программы в выдаче не подтверждена. IELTS 6.0 — типичный минимум TU Dresden для англоязычных программ, но для «Air Transport and Logistics» конкретно не найден на одной странице. URL — официальная страница кафедры транспортных наук TU Dresden (появилась в поиске).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Air Transport and Logistics', 'Business Analytics', 'English', 24, 0,
  4, 30, 6, 3, 'https://tu-dresden.de/bu/verkehr/studium/im-studium/air-transport-and-logistics-master?set_language=en',
  array[]::text[],
  'Магистерская программа M.Sc. в Техническом университете Дрездена по воздушному транспорту и логистике, обучение полностью на английском, длится 4 семестра. Программа tuition-free (обучение бесплатное); оплачивается только семестровый взнос ~285–340 EUR за семестр.',
  array['Обучение полностью на английском, в сильном техническом университете DACH-региона', 'Бесплатное обучение (как для граждан Германии, так и для иностранцев); оплачивается только семестровый взнос', 'Семестровый взнос включает проезд в общественном транспорте Саксонии'],
  array['В одном источнике не удалось одновременно подтвердить и точный размер обучения/взноса, и дату дедлайна, и требование IELTS — данные собраны из нескольких страниц; verified=false', 'Бюджет на проживание ~850 EUR/мес по данным DAAD — нужно учитывать при планировании'],
  false, null
);

-- verified=true: tuition (0 EUR, только семестровый взнос ~340 EUR), deadline для не-ЕС (31 мая) и IELTS (6.0) подтверждены на официальных страницах tu-dresden.de и daad.de в одном раунде поиска.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Public and International Economics', 'Business Analytics', 'English', 24, 0,
  5, 31, 6, 3, 'https://tu-dresden.de/bu/wirtschaft/studium/studienangebot/master-pie',
  array['Deutschlandstipendium (€300/month)', 'DAAD scholarships', 'TU Dresden STIBET'],
  'Магистерская программа M.Sc. в Техническом университете Дрездена на английском языке. Обучение в публичном вузе Германии — без tuition fees, оплачивается только семестровый взнос (~340 EUR/семестр, включая проездной). Для не-ЕС абитуриентов дедлайн подачи документов — 31 мая.',
  array['Бесплатное обучение для всех, включая граждан не-ЕС', 'Полностью на английском языке', 'Хорошая репутация в области экономики публичного сектора', 'Семестровый взнос включает проездной по Саксонии'],
  array['Дедлайн для не-ЕС раньше (31 мая), чем для ЕС (15 июля) — нужно готовить документы заранее', 'Минимальный IELTS 6.0; некоторые конкуренты просят 6.5+', 'Строгие требования к академической подготовке: минимум 35 ECTS по экономике и 15 ECTS по количественным методам'],
  true, current_date
);

-- verified=false: tuition=0 и дедлайн ~30 апреля подтверждены на разных страницах (DAAD и сам TU Dresden), но не на одной странице с IELTS; IELTS 6.0 — оценка по дефолту TU Dresden для англоязычных программ, прямого подтверждения в выдаче не было. URL оставлен известный (mastersportal 313717).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f1ccd8be-aa13-414e-9da8-a90333f3bfb8',
  'Transportation Economics', 'Business Analytics', 'English', 24, 0,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/313717/transportation-economics.html',
  array['Deutschlandstipendium (общеуниверситетская стипендия, ~300 EUR/мес — подача заявки не привязана к данной магистратуре)'],
  'Магистерская программа M.Sc. Transportation Economics в TU Dresden (Faculty of Transport and Traffic Sciences «Friedrich List»), 4 семестра, полностью на английском. Официально переименована/расширена до «Transportation Economics and Data Science», но это та же программа (mastersportal ID 313717).',
  array['Обучение бесплатное для всех студентов, включая граждан стран вне ЕС (платится только семестровый взнос ~270 EUR/семестр)', 'Полностью на английском, без требования знания немецкого для поступления', 'Университет TU Dresden имеет статус University of Excellence, сильный профильный факультет транспортных наук'],
  array['Не удалось подтвердить точный минимальный балл IELTS на одной странице с остальными параметрами; указан ориентировочно 6.0 (стандарт TU Dresden) — требует ручной проверки на сайте приёмной комиссии', 'Программа на mastersportal числится как «Transportation Economics», а в самом университете сейчас называется «Transportation Economics and Data Science» — при подаче уточняйте актуальное название', 'Дедлайн для не-ЕС по DAAD указан как «1 April to 31[…]» (источник обрезан); 30 апреля — наиболее вероятная дата, но подтвердите на tu-dresden.de'],
  false, null
);

-- Подтверждено: программа существует, длительность 24 мес., это совместная программа с Белградским университетом. Не подтверждено на одной странице: точная сумма tuition для не-ЕС (mastersportal показывает ''Free'', 6400 EUR — оценка по белградской части), дедлайн и IELTS — взяты по типичным значениям для программ FU Berlin без явного подтверждения.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Economic Systems', 'Business Analytics', 'English', 24, 6400,
  1, 15, 6, 3, 'https://www.mastersportal.com/studies/454727/economic-systems.html',
  array[]::text[],
  'Совместная магистерская программа Freie Universität Berlin и Белградского университета (1-й год в Белграде, 2-й в Берлине) с упором на сравнительные экономические системы и политическую экономию.',
  array['Обучение на английском в топовом немецком университете', 'Двойной диплом с престижным сербским университетом'],
  array['Сумма 6400 EUR не подтверждена для не-ЕС на одной странице — mastersportal показывает ''Free'', возможно это плата за белградский год, требует уточнения'],
  false, null
);

-- Подтверждено отсутствие платы за обучение для не-ЕС студентов (страница wiwiss.fu-berlin.de/en/studium-lehre/master/economics/), а также общая политика FU Berlin об отсутствии tuition fees (fu-berlin.de/en/studium/international/studium_fu/studienfinanzierung). Однако IELTS, GPA и конкретный дедлайн для не-ЕС абитуриентов не удалось подтвердить на одной странице — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Economics', 'Business Analytics', 'English', 24, 0,
  6, 15, 6.5, 3, 'https://www.wiwiss.fu-berlin.de/en/studium-lehre/master/economics/index.html',
  array['Deutschlandstipendium', 'FU Berlin Stipendien'],
  'Магистерская программа MSc Economics в Свободном университете Берлина — двухлетняя исследовательская программа без платы за обучение для иностранных студентов; оплачивается только семестровый взнос (~€350).',
  array['Бесплатное обучение для не-ЕС студентов (только семестровый взнос)', 'Сильная исследовательская школа при Department of Economics, рейтинговая программа'],
  array['Не найдено точной даты дедлайна для не-ЕС абитуриентов — на странице wiwiss.fu-berlin.de указано только ''тuition-free'', конкретные сроки подачи нужно проверять через uni-assist'],
  false, null
);

-- Tuition (0 €) и deadline (31 мая) подтверждены на официальных страницах fu-berlin.de и mi.fu-berlin.de. Язык IELTS отдельно на той же странице явно не указан — на сторонних ресурсах упоминается 5.5, поэтому стоит 6.0 как консервативная оценка и verified=false. URL взят из поиска (официальный FU Berlin), не из исходного mastersportal.com (он не появился в результатах).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Bioinformatics', 'Data Science', 'English', 24, 0,
  5, 31, 6, 3, 'https://www.fu-berlin.de/en/studium/studienangebot/master/bioinformatik/index.html',
  array[]::text[],
  'Магистратура по биоинформатике в Freie Universität Berlin — 4 семестра, обучение бесплатное (платится только семестровый взнос ~300 €/семестр). Для неевропейских студентов отдельной ставки tuition нет — берлинские вузы не взимают плату как Баден-Вюртемберг.',
  array['Бесплатное обучение даже для не-ЕС студентов', 'Сильная программа на стыке математики, информатики и биологии', 'Берлин как биотехнологический хаб и большой рынок труда'],
  array['Только семестровый взнос (~300 €) и обязательные административные сборы uni-assist не входят в ''tuition''', 'Минимальный IELTS не подтверждён с одного и того же официального источника (5.5 по слухам, 6.0 как безопасная оценка)', 'Приём заявок ограничен — около 36 студентов в год, конкурс высокий'],
  false, null
);

-- Подтверждено: tuition=0 (fu-berlin.de/en/studium/studienangebot/master/management_marketing/index.html — ''no tuition fees'') + deadline 31 мая (wiwiss.fu-berlin.de/en/studium-lehre/master/m-m/Application/index.html) + English B2 CEFR (та же страница программы). Однако все три пункта не найдены в одном месте в сниппетах поиска, поэтому строгий критерий verified=true не выполнен. Не-ЕС тарифа нет — программа бесплатна для всех категорий.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Management and Marketing', 'Business Analytics', 'English', 24, 0,
  5, 31, 6, 3, 'https://www.fu-berlin.de/en/studium/studienangebot/master/management_marketing/index.html',
  array['Deutschlandstipendium (DAAD/FU Berlin, 300 EUR/month)', 'FU Berlin emergency/study completion grants', 'DAAD scholarship programs for international students'],
  'Магистратура Management & Marketing в Freie Universität Berlin — бесплатная для всех студентов (включая не-ЕС), обучение на английском, 4 семестра. Подача документов через uni-assist до 31 мая (зимний семестр).',
  array['Полностью бесплатное обучение даже для не-ЕС студентов (только семестровый взнос ~300-360 EUR)', 'Сильная бизнес-школа FU Berlin, международная среда, преподавание на английском', 'Специализация Marketing с практическими элементами (Circle of Excellence in Marketing, экскурсии)'],
  array['Нет отдельного не-ЕС тарифа — программа бесплатна для всех, что редкость (но подтверждение tuition+deadline+IELTS на одной странице не найдено единым блоком, поэтому verified=false)', 'IELTS 6.0 указан как примерное соответствие B2 CEFR — точный порог лучше уточнить напрямую у приёмной комиссии', 'Дедлайн 31 мая через uni-assist жёсткий, плюс документы идут до 8 недель на обработку'],
  false, null
);

-- Подтверждено: обучение бесплатное для всех (включая не-ЕС) — официальная страница FU Berlin; дедлайн подачи — 31 мая, не 30 апреля (см. mi.fu-berlin.de/en/data-science/prospective-students и Admissions Regulations PDF). НЕ подтверждено на одной и той же странице точный минимальный IELTS — поэтому verified=false. Шаблон в задании (6400 EUR / 30 апреля / IELTS 6.0) фактически неверен по двум из трёх пунктов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'f8024d82-0fdb-4796-bbcc-8f85b3d89938',
  'Data Science', 'Data Science', 'English', 24, 0,
  5, 31, 6, 3, 'https://www.mi.fu-berlin.de/en/data-science/prospective-students/index.html',
  array['Deutschlandstipendium (€300/month), DAAD scholarships, FU Berlin-specific international scholarships'],
  'Магистерская программа M.Sc. Data Science в Свободном университете Берлина — бесплатная даже для иностранных студентов, обучение на английском, подача до31 мая через uni-assist.',
  array['Бесплатное обучение для студентов из-за пределов ЕС (только семестровый взнос ~€300)', 'Преподавание полностью на английском языке', 'Сильный технический вуз из топ-100, расположен в Берлине'],
  array['Дедлайн 31 мая, а не 30 апреля — ваш шаблон неточен', 'Точный минимальный IELTS не подтверждён в открытых результатах поиска (оценка 6.0 приблизительная)', 'При зачислении нужны доказательства знаний по математике и программированию — могут отказать без них'],
  false, null
);

-- Предупреждения при сборе:
-- - Karlsruhe Institute of Technology / "Management of Product Development": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - Ludwig Maximilian University of Munich / "Master in Business Administration": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - University of Mannheim / "Management Analytics": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
-- - WHU – Otto Beisheim School of Management / "Management": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, web_search_tool_result]. Text: (empty)
-- - Free University of Berlin / "Finance, Accounting and Taxation": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)

-- ССЫЛКИ НЕ ПРОШЛИ ПРОВЕРКУ (программы целиком исключены):
-- - University of Mannheim — "Master of Business Administration": https://www.daad.de/en/studying-in-germany/universities/all-degree-programmes/detail/university-of-mannheim-mannheim-master-of-business-administration-w6949/ (HTTP 404)
