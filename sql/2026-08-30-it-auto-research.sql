-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it), поля: Computer Science, Artificial Intelligence, Data Science, Cybersecurity, Business Analytics, Robotics, Human-Computer Interaction, Computational Engineering, модель: claude-sonnet-5
-- Дата: 2026-08-30
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

-- verified=false: не удалось подтвердить все три параметра (tuition+deadline+IELTS) для не-ЕС на одной странице. Известный URL mastersportal 437305 и официальная страница corsi.unibo.it/2cycle/AppliedEconomicsMarkets — реальные. Стоимость €3060/год взята из mastersportal-выдачи (соответствует non-EU flat fee Unibo для англоязычных программ), но в сниппете не уточнено, относится ли она именно к не-ЕС. Дедлайн 30 апреля — оценка по типичному non-EU циклу Unibo (март–апрель), прямого подтверждения в выдаче для LMAEM не получено. IELTS 6.0 — стандартный минимум Unibo. Стипендии (Invest Your Talent, Unibo Action 1, MAECI) упомянуты в смежной выдаче, но не для конкретно этого набора — список оставлен пустым.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Applied Economics and Markets', 'Business Analytics', 'English', 24, 3060,
  4, 30, 6, 3, 'https://corsi.unibo.it/2cycle/AppliedEconomicsMarkets',
  array[]::text[],
  'Двухгодичная магистратура Университета Болоньи полностью на английском языке: эконометрика, количественные методы и анализ рынков; выпускники востребованы в бизнесе и госсекторе.',
  array['Старейший университет Европы с сильным брендом и широкой сетью выпускников', 'Программа полностью на английском, акцент на математике и эконометрике', 'Возможности стажировок и международной мобильности во втором году'],
  array['Точная сумма для не-ЕС не подтверждена на одной странице; €3060/год — цифра из каталога, официальный портал использует ISEE-based расчёт для граждан ЕС', 'Дедлайн 30 апреля — типичный для Unibo, но в выдаче не подтверждён именно для этого набора; требует проверки на странице программы', 'IELTS 6.0 — минимальный порог Unibo; для конкурентных абитуриентов желателен 6.5'],
  false, null
);

-- Подтверждено с официальной страницы POLIMI GSoM (gsom.polimi.it): стоимость €25,000 для non-EU, IELTS 6.5 (TopUniversities). НО: это программа Graduate School of Management (бизнес-школа MIP), а не инженерный факультет Politecnico; длительность 12 мес., а не 24. Дедлайн rolling (не фиксированная дата) — подача рекомендуется минимум за 3 месяца до старта (январь), поэтому verified=false: tuition и language подтверждены, но единая дата deadline на одной странице отсутствует.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'International Master in Sustainability Management', 'Business Analytics', 'English', 12, 25000,
  9, 30, 6.5, 3, 'https://www.gsom.polimi.it/en/course/international-master-sustainability-management-csr/',
  array['Reduced fee of €13,000 available for students who qualify'],
  '12-месячная программа магистратуры в области устойчивого развития от POLIMI Graduate School of Management (MIP) в Милане, ориентированная на менеджеров и специалистов, желающих интегрировать ESG-стратегии в бизнес.',
  array['Программа от ведущей бизнес-школы MIP/POLIMI GSoM с сильной репутацией в Европе', 'Полностью на английском, расположение в Милане — деловой столице Италии', 'Возможность получения сниженной стоимости обучения (€13,000) при соответствии условиям'],
  array['Высокая стоимость для non-EU студентов — €25,000 за всю программу (не покрывается типичными стипендиями Politecnico)', 'Набор по rolling admissions (нет единого жёсткого дедлайна — non-EU рекомендуется подавать за 3 месяца до старта, приблизительный ориентир конец сентября)', 'Это НЕ 24-месячная программа инженерного профиля основного Politecnico di Milano — это 12-месячная программа бизнес-школы GSoM/MIP'],
  false, null
);

-- verified=false: на одной странице не найдены одновременно tuition+deadline+IELTS для не-ЕС. Tuition ~€3000/год взят с официальной UniGe и Educatly (диапазон 0–3000 €), URL mastersportal указан в задании. Срок и IELTS приведены как наиболее вероятные (апрельский дедлайн для не-ЕС и IELTS 6.0 как общий стандарт UniGe), но требуют прямой проверки на https://corsi.unige.it/en/corsi/11970 и https://unige.it/en/internazionale/procedura-prevalutazione-lauree-magistrali-inglese-solo-studenti-non-eu-residenti-all
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7f7a886b-711e-40a3-85ac-d208bec0313b',
  'Electronic Engineering', 'Computational Engineering', 'English', 24, 3000,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/466507/electronic-engineering.html',
  array['Invest Your Talent in Italy', 'UniGe regional scholarships (based on ISEE/equivalent)'],
  'Магистерская программа по электронной инженерии в Университете Генуи (Италия) на английском языке, 2 года. Ориентирована на проектирование электронных систем, встроенных устройств и микроэлектроники; обучение на английском.',
  array['Невысокая стоимость для иностранцев (~€3 000/год — это верхняя граница ISEE-бэнда, часто можно получить скидку/освобождение по доходу)', 'Обучение полностью на английском; программа в крупном инженерном портовом городе с сильной электронной/кораблестроительной отраслью'],
  array['Точный невзнос tuition/deadline/IELTS для не-ЕС студентов не удалось подтвердить единым официальным источником: на странице программы указано «между 0 и 3000 € в год», поэтому выше — оценка по верхней планке для не-ЕС без льгот; IELTS 6.0 — стандартное требование UniGe, но подтверждения именно для этой программы в выдаче нет', 'Дедлайн для не-ЕС варьируется по годам (для 2026/27 — 26 ноября 2025 для заявки и старт зачисления с 4 мая 2026), 30 апреля — типичный крайний срок, но требует уточнения на текущий цикл'],
  false, null
);

-- Verified=false: на известной странице mastersportal указана стоимость €2,601/год, но не ясно, EU это или не-EU тариф, а чёткого разграничения EU/не-EU в выдаче не найдено. Дедлайн: официальная страница Polito для абитуриентов с не-итальянским дипломом на 2026/27 упоминает продлённый дедлайн до 20 апреля из-за технических проблем, исходные дедлайны для инженерных магистратур — начало апреля (сообщения в соцсетях указывают 12 апреля). IELTS5.5 — типичный минимум Polito для англоязычных магистратур, но конкретно для Automotive Engineering на одной странице с tuition и deadline не подтверждён. Поскольку tuition+deadline+language не подтверждены для не-EU на одной и той же странице, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '5b0df094-b9f9-40df-bbd9-83de0d015214',
  'Automotive Engineering', 'Computational Engineering', 'English', 24, 5202,
  4, 20, 5.5, 3, 'https://www.mastersportal.com/studies/16171/automotive-engineering.html',
  array['Invest Your Talent in Italy', 'Politecnico di Torino fee waivers based on merit and country of origin', 'Italian Government scholarships for foreign students'],
  'Магистерская программа Automotive Engineering (M.Sc.) в Politecnico di Torino — 2 года, преподавание на английском, расположена в Турине (столице итальянского автопрома). Сильная инженерная школа с прямым выходом на Fiat/Stellantis, Ferrari и других.',
  array['Англоязычная программа в автомобильной столице Европы', 'Сильная инженерная репутация и связи с итальянским автопромом (Stellantis, Ferrari, Iveco)'],
  array['На mastersportal указана ставка €2,601/год — это, скорее всего, EU/EEA-тариф; для не-EU студентов реальная годовая плата обычно выше (зависит от страны происхождения, до ~€3,500/год), точные цифры для не-EU на одной странице не подтверждены'],
  false, null
);

-- Официальная страница apply.unipd.it подтверждает tuition €2950/год, но указанный там дедлайн 15 Nov 2026 относится только к EU и non-EU, проживающим в Италии. Для non-EU из-за рубежа дедлайны иные (первая волна обычно 2 февраля, дополнительные — позже). IELTS 6.0 и GPA 3.0 — стандартные требования университета, но не подтверждены на той же странице. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Electrical Engineering', 'Computational Engineering', 'English', 24, 2950,
  2, 2, 6, 3, 'https://apply.unipd.it/courses/course/237-electrical-engineering?search=2356248',
  array['Invest Your Talent in Italy', 'University of Padua scholarships for international students (based on merit and income)'],
  'Магистерская программа по электротехнике в Университете Падуи на английском языке, 2 года, направлена на подготовку специалистов для решения сложных инженерных задач проектирования.',
  array['Один из старейших и престижных технических университетов Италии', 'Единая ставка оплаты для EU и non-EU студентов — €2950/год', 'Программа полностью на английском языке'],
  array['Для non-EU студентов, проживающих за рубежом, дедлайн первой волны (2 февраля) уже прошёл на 2026/2027; доступны дополнительные волны позже', 'Точный минимальный IELTS и GPA не указаны на одной странице с tuition для non-EU категории — требуют уточнения', 'Стипендии конкурентные и зависят от дохода семьи'],
  false, null
);

-- verified=false, потому что на одной и той же странице не удалось одновременно подтвердить все три поля (tuition+deadline+IELTS) для не-ЕС студентов. Подтверждено: tuition €2,739/год (источники educations.com, Yocket, shiksha.com — все ссылаются на один и тот же показатель для EU и non-EU); IELTS 6.0 (Yocket). Не подтверждено точное значение: конкретный день дедлайна для не-ЕС абитуриентов — применена типовая для Padua оценка (март) на основе упоминания Call 1 для EU и non-EU. GPA 3.0 — типовое требование, точная цифра не подтверждена. Официальная страница: apply.unipd.it/courses/course/50-energy-engineering.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Energy Engineering', 'Computational Engineering', 'English', 24, 2739,
  3, 7, 6, 3, 'https://apply.unipd.it/courses/course/50-energy-engineering',
  array['Padua International Excellence Scholarship (up to full tuition waiver + €8,000/year stipend for selected international students)'],
  'Магистратура по энергетическому инженерингу в Университете Падуи на английском языке, 2 года очной формы. Стоимость около €2,739 в год по системе, основанной на доходе (ISEE); для иностранных студентов доступны стипендии и освобождения от оплаты.',
  array['Английский язык обучения, программа полностью международная', 'Университет Падуи входит в топ итальянских вузов, сильная инженерная школа', 'Низкая базовая стоимость обучения и возможность получения стипендии, покрывающей обучение'],
  array['Точная дата дедлайна для не-ЕС студентов на конкретной странице не подтверждена в выдаче — оценка приблизительная', 'Университет Падуи использует систему tuition, привязанную к ISEE/доходу; для не-ЕС студентов фиксированной ставки нет — фактическая сумма может варьироваться'],
  false, null
);

-- Verified=false, потому что не все три параметра (tuition+deadline+IELTS) подтверждены на одной и той же странице для non-EU. Tuition €2,950/год подтверждён на официальной apply.unipd.it/courses/course/22-environmental-engineering. Дедлайн 18 июля для non-EU указан агрегатором beyondthestates.com, IELTS 6.0 — стандартное требование Университета Падуи, но не извлечён из одной официальной страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Environmental Engineering', 'Computational Engineering', 'English', 24, 2950,
  7, 18, 6, 3, 'https://apply.unipd.it/courses/course/22-environmental-engineering',
  array['Invest Your Talent in Italy', 'University of Padova International Excellence Scholarship (full tuition waiver + €8,000/year allowance)', 'DSU regional scholarship (income-based, can reduce fees significantly)'],
  'Магистратура по экологической инженерии в Университете Падуи на английском языке, длительность 2 года. Программа для иностранных (non-EU) студентов с подтверждённой стоимостью около €2,950 в год и стандартными стипендиями.',
  array['Официальная страница apply.unipd.it подтверждает единую ставку tuition €2,950/год для non-EU (без двойной EU/non-EU ставки)', 'Полностью английская программа в топовом итальянском университете', 'Доступны стипендии с полным покрытием tuition + €8,000 в год'],
  array['Точный дедлайн для non-EU (~18 июля) взят со стороннего агрегатора beyondthestates.com, на apply.unipd.it для конкретного года нужно перепроверить; минимальный GPA формально не указан на официальной странице — оценка 3.0 поставлена как разумная оценка по умолчанию'],
  false, null
);

-- Деджлайн 30 апреля и IELTS 6.0 — типичные значения для non-EU 2-го цикла Университета Падуи, но на странице apply.unipd.it/courses/course/93-cybersecurity указан тариф €2,950/год без явного разделения EU/non-EU (там же есть оговорка ''Only for EU and equated applicants'' для части потоков). Один источник с tuition+deadline+IELTS одновременно для non-EU не найден в одной выдаче, поэтому verified=false. Точную non-EU ставку и финальный дедлайн нужно проверить на apply.unipd.it (course 93) и unipd.it/en/contribuzione-studentesca.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Cybersecurity', 'Cybersecurity', 'English', 24, 2950,
  4, 30, 6, 3, 'https://apply.unipd.it/courses/course/93-cybersecurity',
  array['Padua International Excellence Scholarship (full tuition waiver + €8,000 allowance)'],
  'Магистратура по кибербезопасности в Университете Падуи — 2 года (120 ECTS), на английском. Программа охватывает теорию и практику: криптографию, сетевую безопасность, киберразведку, право и международные отношения. Университет входит в топ старейших и сильных технических вузов Италии.',
  array['Годовая плата для non-EU около €2,950 (ниже, чем у многих топовых программ Европы)', 'Полная стипендия Padova International Excellence покрывает tuition + €8,000 в год', 'Англоязычная программа, IELTS 6.0 — относительно мягкий порог'],
  array['€2,950/год — это базовая ставка; фактическая плата для non-EU может быть выше после расчёта по ISEE/доходу (на странице для non-EU отдельный тариф не показан, цифра подтверждена как EU-rate, для non-EU может отличаться)', 'Минимальный GPA 3.0/4.0 — формального минимума на официальной странице нет, конкуренция высокая'],
  false, null
);

-- verified=false, потому что на одной странице не подтверждены одновременно три параметра для non-EU: tuition частично подтверждён (€2,739/год по educations.com и mastersportal), IELTS подтверждён косвенно (B2 CEFR по topuniversities ≈ IELTS 6.0), а дедлайн для non-EU residing abroad (~2 мая) взят из вторичных источников и не из официального блока apply.unipd.it в выдаче. Итоговая сумма €5,478 = €2,739 × 2 года — это отображаемая годовая ставка, для non-EU без waiver реальная цифра может быть иной.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Management Engineering', 'Business Analytics', 'English', 24, 5478,
  5, 2, 6, 3, 'https://apply.unipd.it/courses/course/185-management-engineering',
  array['Padua International Excellence Scholarship', 'Fee waivers for non-EU students based on merit/need'],
  'Магистратура Management Engineering в Университете Падуи — двухгодичная англоязычная программа инженерно-управленческого профиля, готовит специалистов по анализу, проектированию и управлению сложными производственными и сервисными системами.',
  array['Англоязычная программа в топовом итальянском вузе с 800-летней историей', 'Низкая стоимость обучения (около €2,739/год) и доступны стипендии/освобождения от оплаты для иностранцев', 'Признанный бренд University of Padua, сильная инженерная школа'],
  array['Точный дедлайн для non-EU не подтверждён на одной официальной странице — указанная дата 2 мая взята из постов приёмной комиссии DTG в соцсетях, а не из официального раздела', 'Чёткое разделение тарифа EU/non-EU на публичных страницах не найдено — €2,739/год это отображаемая ставка, реальная non-EU плата может быть выше после отказа в fee waiver', 'Минимальный GPA 3.0/4.0 указан по косвенным источникам (Facebook студентов), на apply.unipd.it явного GPA-порога не извлёк'],
  false, null
);

-- Tuition 2950 €/год и non-EU дедлайн 7 марта подтверждены на официальной странице apply.unipd.it. IELTS 6.0 — оценочное значение (стандарт Unipd), конкретной цитаты с этой же страницы не получено, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3db8dca3-5380-4cae-8011-4c206ad2a24e',
  'Mathematical Engineering - Financial Engineering', 'Business Analytics', 'English', 24, 2950,
  3, 7, 6, 3, 'https://apply.unipd.it/courses/course/23-mathematical-engineering---study-track-financial-engineering',
  array['Invest Your Talent in Italy', 'University of Padua reserved places with reduced fees'],
  'Двухгодичная магистерская программа Университета Падуи по математическому инжинирингу со специализацией Financial Engineering. Стоимость — 2950 евро/год, отдельный дедлайн для non-EU абитуриентов.',
  array['Официальный официальный дедлайн для non-EU студентов — 7 марта 2026 г. подтверждён на сайте приёмной комиссии', 'Стоимость 2950 €/год указана прямо на apply.unipd.it — это конечная цифра, а не диапазон', 'Программа ведётся на английском, IELTS 6.0 — типичный минимум для инженерных магистратур Падуи'],
  array['Минимальный балл IELTS 6.0 не удалось подтвердить цитатой с той же официальной страницы — значение приведено как типичное для программ Unipd', 'На mastersportal дедлайны показаны устаревшие («Call two: 2 March - 2 May»), доверять надо apply.unipd.it, а не агрегаторам'],
  false, null
);

-- Предупреждения при сборе:
-- - University of Trento / "Computer Science": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, text]. Text: [{
  "program_name": "Computer Science",
  "duration_months": 24,
  "tuition_eur": 6000,
  "deadline_month": 3,
  "deadline_day": 4,
  "ielts_min": 6.0,
  "gpa_min": 3.0,
  "url": "https://corsi.unitn.it/en/computer-science-master/enrollment/admission-non-europeans",
  "scholarships": ["Invest Your Talent in Italy", "UniTrento need-based scholarships for non-EU citizens", "Italian Government MAECI scholarships"],
  "summary_ru": "Магистерская программа по компьютерным наукам Университета Тренто 
