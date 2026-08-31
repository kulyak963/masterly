-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Italy (it), поля: Computer Science, Artificial Intelligence, Data Science, Cybersecurity, Business Analytics, Robotics, Human-Computer Interaction, Computational Engineering, модель: claude-sonnet-5
-- Дата: 2026-08-29
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

-- verified=false: на known-странице mastersportal и на странице BBS не найдено одновременное подтверждение tuition+deadline+IELTS для NON-EU на одной и той же странице. Подтверждено только: программа существует (BBS Global MBA in AI and Manufacturing), тариф 35 000 евро (без разделения EU/non-EU, VAT включён), длительность ~1 год, формат — MBA. Дедлайн 30 апреля и IELTS 6.0 — лучшие оценки по косвенным данным, а не из одного источника.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'AI and Manufacturing', 'Artificial Intelligence', 'English', 12, 35000,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/395469/ai-and-manufacturing.html',
  array[]::text[],
  'Глобальная MBA-программа в Bologna Business School по искусственному интеллекту и производству, рассчитанная на 1 год очного обучения. Стоимость 35 000 евро указана единой ставкой без разделения на EU/non-EU.',
  array['Престижная школа — Bologna Business School при Университете Болоньи, степень от Unibo', 'Узкая нишевая специализация (AI + производство), востребованная в индустрии', 'Возможность получить стипендию (на портале заявлено 5 вариантов)'],
  array['Точная не-EU/не-EU стоимость и крайний срок подачи на одной странице не подтверждены — €35 000 указан как единый тариф, а IELTS-минимум не подтверждён с той же страницы', 'Длительность 12, а не 24 месяца — уточните, подходит ли формат MBA, а не классического MSc'],
  false, null
);

-- verified=false: на одной странице официально не подтверждены одновременно все три параметра (tuition + deadline + IELTS). Стоимость €14 800 и раунды дедлайнов взяты с официальной страницы unibo.it (код программы 5991). Разделения EU/non-EU в цене нет — это Professional Master с фиксированной оплатой для всех. IELTS 6.0 — типовое требование Bologna Business School, но явно не найдено в сниппете. Длительность 12 мес. подтверждена unibo.it и accessmasterstour; mastersportal указывает 24 мес. — это ошибка агрегатора.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Artificial Intelligence and Innovation Management', 'Artificial Intelligence', 'English', 12, 14800,
  5, 12, 6, 3, 'https://www.unibo.it/en/study/phd-professional-masters-specialisation-schools-and-other-programmes/professional-master/2025-2026/artificial-intelligence-and-innovation-management-2',
  array[]::text[],
  'Профессиональный магистерский курс Bologna Business School (Университет Болоньи) по ИИ и управлению инновациями. Программа на английском, длится один год (60 CFU), единая стоимость €14 800 для всех студентов.',
  array['Единая цена для EU и non-EU студентов — нет отдельной повышенной ставки для иностранцев', 'Преподавание полностью на английском в бизнес-школе старейшего университета Европы', 'Партнёрства с компаниями, стипендии и поддержка карьерных возможностей через BBS'],
  array['Длительность программы — 12 месяцев (а не 24, как ошибочно указано на mastersportal)', 'Требование IELTS 6.0 не подтверждено в сниппете официальной страницы unibo.it, взято по стандарту BBS', 'Дедлайны 2026–2027 цикла не найдены в источниках — использованы подтверждённые даты 2025–2026 (17 марта, 12 мая, 29 сентября 2025)'],
  false, null
);

-- verified=false: на странице mastersportal (studies/31151) в сниппете видно ''157 EUR / year. 157 EUR / year. Unknown'' — скорее всего это минимальный взнос для EU/ISEE-категории, а реальная non-EU стоимость не указана (''Unknown''). Длительность 24 месяца и формат MSc Full-time подтверждены unipage.net. IELTS упомянут как требуемый экзамен, но минимальный балл в источнике не указан. Дедлайн 30 апреля — типичный ориентир для non-EU заявок в итальянских вузах, но на этой странице не подтверждён. Поскольку tuition, deadline и language не подтверждены все три на одной странице для non-EU — verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Business Administration - International Management', 'Business Analytics', 'English', 24, 157,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/31151/business-administration-international-management.html',
  array['Invest Your Talent in Italy', 'University of Bologna international study grants', 'Erasmus+'],
  'Магистерская программа по международному менеджменту в Университете Болоньи (кампус Форли), 2 года очно на английском языке. Один из старейших университетов Европы, сильный бренд в области бизнеса и менеджмента.',
  array['Старейший университет Европы (с 1088 г.) с сильным международным брендом', 'Программа полностью на английском, длительность 2 года (120 ECTS)', 'Кампус в Форли с интернациональной средой и стипендиями для не-EU студентов'],
  array['На странице mastersportal стоимость для не-EU студентов помечена как ''Unknown'', реальная non-EU ставка может быть значительно выше показанных 157 EUR/год', 'Конкретный дедлайн и минимальный балл IELTS не подтверждены в найденных источниках — указаны ориентировочно'],
  false, null
);

-- Verified=false, так как за один раунд поиска не удалось найти одну страницу, которая одновременно подтверждает tuition+deadline+IELTS именно для не-ЕС студентов. Snippet mastersportal 69786 дал только общий заголовок (''requirements, tuition costs, deadlines and scholarships'') без конкретных чисел; вспомогательные источники (corsi.unibo.it/2cycle/ServiceManagement, unipage.net, study.eu) подтвердили длительность24 мес., формат MSc full-time в Римини и требования IELTS/TOEFL, но конкретные суммы и дедлайны на одной странице для не-ЕС не зафиксированы. Цифры в JSON — стандартные для Unibo: не-ЕС ~€6 400/год, дедлайн ~30 апреля (типичный последний раунд для не-ЕС), IELTS 6.0, GPA ≈3.0 — оценки, а не подтверждённые факты.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Business Administration - Service Management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/69786/business-administration-service-management.html',
  array['Unibo study grants and tuition fee waivers for international students', 'Invest Your Talent in Italy', 'Italian Government scholarships for foreign students'],
  'Двухгодичная англоязычная магистерская программа Университета Болоньи (кампус Римини) по бизнес-администрированию с уклоном в управление услугами — маркетинг, инновации и интернационализация сервисных компаний.',
  array['Полностью на английском языке — подходит для иностранцев', 'Престиж Университета Болоньи (старейший вуз Европы), сильный бренд в бизнес-образовании', 'Узкая специализация на service management — востребованное направление в экономике услуг', 'Возможность получить стипендии и освобождение от оплаты для не-ЕС студентов'],
  array['Данные по стоимости, срокам и IELTS для не-ЕС студентов не подтверждены единым источником в этой выдаче — цифры приведены по типичной практике Unibo, страница mastersportal показывала лишь общие заголовки без конкретных сумм', 'Оплата для не-ЕС студентов значительно выше, чем для граждан ЕС (типично ~€6 400/год против ~€3 200/год по внутренним тарифам)', 'Кампус расположен в Римини, а не в самой Болонье — нужно учитывать логистику'],
  false, null
);

-- Не удалось найти одну страницу, где одновременно подтверждены tuition, deadline и IELTS именно для не-ЕС абитуриентов. Дедлайн апреля (4/30) и IELTS 6.0 стандартны для международных магистратур Unibo и указаны на странице how-to-enrol (corsi.unibo.it). Стоимость 6 600 € — верхняя граница годового взноса для не-ЕС в Университете Болоньи, но для программы Business Administration and Sustainability отдельной публикации тарифа в результатах поиска не обнаружено, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Business Administration and Sustainability', 'Business Analytics', 'English', 24, 6600,
  4, 30, 6, 3, 'https://corsi.unibo.it/2cycle/BusinessAdministration-Forli/how-to-enrol',
  array[]::text[],
  'Двухгодичная магистерская программа Университета Болоньи (кампус Форли) на английском языке, сочетающая бизнес-администрирование с вопросами устойчивого развития.',
  array['Программа на английском в одном из старейших университетов мира (Unibo)', 'Специализация на устойчивом развитии — сильный тренд для карьеры в ESG и sustainability-консалтинге'],
  array['Полная сумма взноса для не-ЕС/ЕЭЗ студентов подтверждена лишь косвенно (по тарифной сетке Unibo ~2 925–6 600 €/год), точная цифра для конкретной программы не найдена на одной странице с дедлайном и IELTS'],
  false, null
);

-- verified=false: на mastersportal указаны tuition €15 200/год и формат part-time, но страница не разделяет ставки EU/non-EU, а IELTS и GPA — стандартные требования агрегатора, не подтверждены именно для non-EU. Поэтому параметры выставлены приблизительно, источник — mastersportal и distancelearningportal.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Business Analytics and Data Science', 'Data Science', 'English', 24, 15200,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/395650/business-analytics-and-data-science.html',
  array['Unibo Action 1 tuition fee waiver + study grant of €6,500 (for non-EU applicants)'],
  'Executive Master in Business Analytics and Data Science в Университете Болоньи — это 24-месячная партизанская (part-time) гибридная программа (онлайн + очно) для работающих специалистов, с обучением на английском языке и стоимостью около €15 200/год.',
  array['Один из старейших и престижных университетов мира (Alma Mater Studiorum)', 'Гибридный формат удобен для работающих специалистов'],
  array['Подтверждена только общая годовая стоимость €15 200 из агрегатора; отдельная разбивка EU/non-EU на той же странице не найдена', 'Партизанский формат — программа Executive Master, рассчитана на работающих, что не подходит выпускникам бакалавриата', 'Точные IELTS и GPA для не-граждан ЕС в результатах поиска не подтверждены (значения приблизительные, со страницы mastersportal без явного указания non-EU)'],
  false, null
);

-- Подтверждено по официальной странице BBS (bbs.unibo.it) и mastersportal.com: tuition 13 800 EUR/год (non-EU = non-resident единый тариф для BBS-магистратур), IELTS 6.5, deadline Round 1 — 27/04/2026. Длительность уточнена до 12 месяцев (program = 1-год full-time магистр).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Business Management Asian Markets', 'Business Analytics', 'English', 12, 13800,
  4, 27, 6.5, 3, 'https://www.bbs.unibo.it/en/master-fulltime/master-in-business-management-global-and-emerging-markets/',
  array['Unibo Action 2 study grants (~€11,000 gross)', 'BBS partial tuition waivers by round'],
  'Один год магистратуры в Bologna Business School (Университет Болоньи) с фокусом на азиатские рынки: стратегия, маркетинг, интернационализация и бизнес-культура Азии. Программа full-time, на английском, в Болонье.',
  array['Престижная бизнес-школа при старейшем университете Европы', 'Сильная специализация на азиатских рынках (Китай, Индия, ЮВА)', 'Английский язык обучения, международная среда'],
  array['Стоимость 13 800 EUR/год для не-ЕС студентов — выше среднего по итальянским госпрограммам', 'Длительность 1 год (12 месяцев), а не 24 — корректировка против шаблона; несколько раундов подачи, первый — 27 апреля 2026', 'IELTS требуется 6.5, не 6.0'],
  true, current_date
);

-- verified=false: не удалось подтвердить tuition, deadline и IELTS одновременно на одной странице для non-EU. Источники: mastersportal.com/437312 (основной URL, не удалось извлечь детали в одном раунде), applyaz.com (стипендия Action 1), topuniversities.com (IELTS 5.5+ — противоречит типичному требованию 6.0), Facebook-пост о программах 2026 (дедлайн 07/07/2026 для Economics and Econometrics). Рекомендуется напрямую проверить corsi.unibo.it/2cycle/lmec/how-to-enrol для подтверждения всех трёх параметров.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Economics and Econometrics', 'Business Analytics', 'English', 24, 6400,
  7, 7, 6, 3, 'https://www.mastersportal.com/studies/437312/economics-and-econometrics.html',
  array['Unibo Action 1 tuition waiver + €11,000 for top non-EU students (per ApplyAZ source)'],
  'Двухгодичная магистратура LM-56 по экономике и эконометрике в Болонском университете на английском языке. Программа с сильной количественной подготовкой, подходит для иностранных студентов.',
  array['Старейший университет Европы с высокой академической репутацией', 'Английский язык обучения, подходит для не-итальяноязычных студентов', 'Доступны стипендии Unibo Action 1 с полным покрытием tuition + €11,000 для лучших не-EU кандидатов'],
  array['Точная сумма tuition для non-EU не подтверждена на одной странице — цифра €6,400 за 2 года приведена как оценка на основе типичных ставок Unibo для non-EU (€2,800–€3,200/год); проверьте на corsi.unibo.it', 'Срок IELTS 6.0 указан по типичному требованию Unibo для англоязычных магистратур; на TopUniversities показано 5.5+, что вызывает сомнение — уточняйте'],
  false, null
);

-- verified=false, потому что не удалось найти одну страницу, где одновременно подтверждены и non-EU стоимость, и дедлайн, и IELTS. На mastersportal.com (известный URL) указано 157 EUR/год, что выглядит как ошибка отображения или базовый тариф ЕС; topuniversities показывает 5 414 EUR; официальная страница unibo.it (https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5814) подтверждает программу и 24 месяца/120 ECTS, но деталей по тарифам и дедлайнам в сниппете нет. Использованы типичные значения Unibo для не-ЕС.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Food Animal Metabolism and Management in the Circular Economy', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5814',
  array['Invest Your Talent in Italy', 'Italian Government Scholarships for foreign students', 'Unibo action 1 and 2 regional scholarships (for non-EU students with limited income)'],
  'Двухлетняя магистратура Университета Болоньи (120 ECTS) на стыке зоотехнии, метаболизма сельскохозяйственных животных и циркулярной экономики. Программа на английском, ориентирована на интернациональных студентов, готовит специалистов по устойчивому животноводству.',
  array['Старейший университет Европы (Alma Mater Studiorum), высокий международный рейтинг', 'Полностью на английском, междисциплинарная программа с акцентом на устойчивое развитие и ИИ в агросекторе', 'Сильная исследовательская база и связи с агропромышленным сектором Италии (Emilia-Romagna)'],
  array['Точная стоимость для не-ЕС студентов на одной странице не подтверждена: mastersportal показывает 157 EUR/год (похоже на базовый ISEE-показатель для ЕС), а topuniversities — 5 414 EUR/год; использован типичный для не-ЕС диапазон Unibo ~6 400 EUR', 'Дедлайн 30 апреля — типичный срок для не-ЕС абитуриентов на второй цикл в Unibo, но на официальных страницах в выдаче конкретная дата не указана; в одной из соцсетей упоминалось ''open until September 2nd'' — возможно второй раунд для ЕС', 'verified=false: tuition+deadline+IELTS не подтверждены единым источником — IELTS 6.0 стандартен для Unibo, но не подтверждён на той же странице, что и остальные параметры'],
  false, null
);

-- Verified=false: tuition, deadline и IELTS не удалось подтвердить все три пункта для non-EU на одной официальной странице. Подтверждено: 24 месяца, английский язык обучения, программа существует и администрируется через MUNER (motorvalleyuniversity.com 2026/27 non-EU call) и unibo.it (corsi.unibo.it/2cycle/AutomotiveEngineering, дедлайн 30 сент. 2026 для общего цикла). Разнобой по学费 (2160 vs 6630 vs 3315 EUR) и IELTS (5.5 vs 6.0) между агрегаторами не позволяет выставить verified=true без риска ошибки.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Advanced Automotive Engineering', 'Computational Engineering', 'English', 24, 6630,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/183225/advanced-automotive-engineering.html',
  array['Invest Your Talent in Italy', 'Italian Government Scholarships for non-EU students', 'Unibo action 1&2 tuition fee waivers for international students'],
  'Двухгодичная магистратура на английском в Университете Болоньи (входит в консорциум MUNER — Motorvalley University of Emilia-Romagna) с сильным уклоном в автомобилестроение, электромобили и гоночные технологии; программа ориентирована на интернациональных студентов.',
  array['Преподавание полностью на английском, сильный инженерный бренд Болоньи и участие в MUNER (связи с Ferrari, Lamborghini, Ducati, Maserati)', 'Конкретная отраслевая специализация (автомобилестроение и e-mobility), хорошие перспективы трудоустройства в Моторной долине Эмилии-Романьи'],
  array['Точный размер платы для non-EU и финальный неевропейский дедлайн не удалось подтвердить единой страницей: mastersportal пишет ~2160 EUR/год, topuniversities — 6630 EUR/год, shiksha — 3315 EUR за 1-й год; IELTS в разных источниках 5.5/6.0, поэтому verified=false', 'Дедлайн взят как типичный апрельский для non-EU на итальянские магистратуры, но официальная страница MUNER для 2026/27 не показала даты в сниппете'],
  false, null
);

-- verified=false, так как не удалось найти одну официальную страницу, где одновременно подтверждены tuition, deadline и IELTS для non-EU. Tuition ~€2,800/год — оценка на основе Shiksha (€3,060 для international 1-й год) и обзора letstern о диапазоне €800–€3,500; цифра €18,904/год с Yocket выглядит завышенной и относится, вероятно, к другой программе/кампусу. Дедлайн 30 апреля — по аналогии с дедлайном стипендий Unibo Action 1&2 и общим окном марта–мая для магистратур; официальный call for applications на странице corsi.unibo.it/2cycle/AerospaceEngineering/how-to-enrol нужно открыть вручную. IELTS 5.5 — по Yocket, рекомендуется перепроверить на unibo.it. Главная официальная страница программы: unibo.it/en/study/second-cycle-degree/programme/2024/5723.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Aerospace Engineering', 'Computational Engineering', 'English', 24, 2800,
  4, 30, 5.5, 3, 'https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5723',
  array['Invest Your Talent in Italy', 'Unibo Action 1&2 regional scholarships (typically end of April)', 'Italian Government MAECI scholarships'],
  'Магистратура по аэрокосмической инженерии в Болонском университете (2 года, 120 ECTS) на английском языке с упором на авиастроение, двигателестроение и космические системы. Входит в топ-программы Италии по направлению, сильная инженерная школа с прямыми связями с авиационным кластером Эмилии-Романьи.',
  array['Английский язык обучения — не нужен итальянский', 'Престижный старейший университет Европы (с 1088 г.) и сильный инженерный факультет', 'Связи с промышленным аэрокосмическим кластером региона (Avio Aero, Leonardo, DEMA)'],
  array['Точная ставка tuition для non-EU на одной странице с дедлайном и IELTS в результатах поиска не подтверждена — цифра ~€2,800/год приведена по агрегаторам (Shiksha/letstern) и не подкреплена прямым официальным источником', 'Точный дедлайн 30 апреля для non-EU указан косвенно (через дедлайн стипендий Unibo Action и упоминания марта–мая для магистратур) — официальная страница corse enrolment не была подтверждена в выдаче', 'IELTS 5.5 по Yocket может быть ниже реальных требований конкретного факультета — проверьте на unibo.it перед подачей'],
  false, null
);

-- Tuition €6 434 подтверждён TopUniversities как годовая плата для иностранных студентов; ISEE-шкала €157+ подтверждена mastersportal и официальной страницей fees Unibo. Дедлайн 14 января для не-ЕС подтверждён Collegedunia (2026 intake), а также на странице how-to-enrol (разделение раундов). IELTS 6.0 — типовое требование Unibo для инженерных магистратур, но на официальной странице Automation Engineering конкретный балл не указан — взят из общей практики. verified=false, потому что IELTS-минимум не подтверждён на одной странице со стипендиями и фиксированной не-ЕС ставкой.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Automation Engineering', 'Robotics', 'English', 24, 6434,
  1, 14, 6, 3, 'https://corsi.unibo.it/2cycle/AutomationEngineering/how-to-enrol',
  array['Invest Your Talent in Italy (Italian Government scholarship for non-EU students)', 'Unibo Action 1&2 study grants for international students', 'Emilia-Romagna Region scholarships'],
  'Магистерская программа Automation Engineering в Болонском университете (Unibo) — двухлетняя (120 ECTS), полностью на английском языке, с сильной междисциплинарной базой по автоматике, вычислительной и электронной инженерии. Для не-ЕС студентов действует фиксированная максимальная ставка ~€6 434/год, для ЕС — ISEE-зависимая (от €157).',
  array['Престижный старейший университет Европы (с1088 г.) и один из лучших технических вузов Италии', 'Программа полностью на английском, без требования итальянского', 'Сильная индустриальная база региона Эмилия-Романья (Toyota, Bonfiglioli, автомобилестроение) и высокий спрос на инженеров-автоматчиков', 'Доступны стипендии региона Эмилия-Романья и государственные программы для не-ЕС студентов'],
  array['Фиксированная максимальная плата для не-ЕС (~€6 434/год) существенно выше ISEE-ставки для ЕС; IELTS 6.0 подтверждён только через сторонние источники, официальная страница Unibo указывает общие требования B2 без жёсткого балла', 'Конкретная дата дедлайна для не-ЕС (14 января) взята с Collegedunia на цикл 2026, официальная how-to-enrol страница подтверждает разделение на раунды ЕС/не-ЕС без единой точной цифры'],
  false, null
);

-- verified=false: на одной и той же странице не найдено одновременно non-EU tuition + deadline + IELTS. На mastersportal (271601) показана базовая цифра €157 (фиксированная часть Unibo), Shiksha даёт €3,825 как first-year fee без чёткой non-EU/EU разбивки, Unibo-страница программы отдельно сообщает что набор на 2026/27 прекращён. IELTS взят как типичное Unibo-требование B2 (≈6.0), но не подтверждён именно для non-EU на указанном URL.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Bioinformatics', 'Data Science', 'English', 24, 3825,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/271601/bioinformatics.html',
  array['Unibo Action1&2 — partial/tuition waivers + study grant for international students (ISEE-based)', 'Invest Your Talent in Italy'],
  'Магистратура по биоинформатике в Университете Болоньи (2 года, англоязычная) готовит специалистов на стыке вычислительных методов, статистики/ML и биологии. Важно: по данным самого сайта Unibo, набор на 2026/27 по этой программе закрыт, поэтому ориентируйтесь на цикл 2025/26 или уточняйте преемника.',
  array['Старейший университет Европы, сильный бренд и нетворкинг', 'Англоязычная программа с фокусом на Big Data, ML и статистике для биологии/медицины', 'Гибкая структура оплаты: фикс €157 + переменная часть по доходу/ISEE, есть стипендии Unibo, полностью или частично покрывающие tuition'],
  array['Конкретный non-EU тариф на одной странице с дедлайном и IELTS одновременно не подтверждён — €3,825 указан как общий first-year fee (источник Shiksha), реальная сумма для non-EU может отличаться', 'Итальянские вузы формально не используют GPA — оценка по учебному плану (transcript + matching курсов)', 'По странице Unibo набор на 2026/27 закрыт, нужно проверять текущий статус и преемственную программу'],
  false, null
);

-- verified=false: tuition, дедлайн и IELTS для non-EU не подтверждены на одной и той же официальной странице unibo.it. На найденных страницах unibo.it фигурируют: общий калькулятор tuition-fees (фикс €157,04 + переменная часть по ISEE/доходу, без отдельной публикации фиксированной non-EU ставки именно для этой программы), общая страница программы 2024/5701 без явного дедлайна non-EU, и упоминания сторонних порталов о дедлайнах (30 апреля / 21 ноября) и IELTS 6.0. Использованы значения по умолчанию (€6400, дедлайн 30 апреля, IELTS 6.0) как наиболее вероятные, но без полного подтверждения на единой странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Chemical Innovation and Regulation', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5701',
  array[]::text[],
  'Двухлетняя англоязычная магистратура Университета Болоньи по химическим инновациям и регулированию (теперь в версии «for Sustainability»), ориентированная на управление безопасностью химических веществ и устойчивое развитие.',
  array['Англоязычная программа в старейшем университете Европы с сильной инженерно-химической школой', 'Возможность собрать индивидуальный учебный план (study plan) и выбрать треки по инновациям или регулированию'],
  array['Не удалось подтвердить точную сумму tuition для non-EU на одной странице с дедлайном и языком: фигурируют €157,04 фиксированный взнос + переменная часть, зависящая от дохода (ISEE), а сторонние источники дают разные цифры (≈€3 200/год при доходных льготах, либо ~$4 170/год)', 'Дедлайн зависит от волны приёма — встречаются варианты «30 апреля» и более поздние (ноябрь) для non-EU по отдельным программам; для этой магистратуры точная дата non-EU-окна не подтверждена однозначно', 'Минимальный балл IELTS 6.0 (а не 6.5, как у отдельных стипендиальных треков Erasmus Mundus ChIR) — это базовое требование для non-EU'],
  false, null
);

-- verified=false: на единственной реально подтверждённой странице (mastersportal 370235) видна только EU-тарификация по ISEE (от 157 EUR/год) — отдельный non-EU тариф там не показан. Официальная страница unibo.it/cod.5900 подтверждает длительность 24 мес. и статус Laurea Magistrale, но дедлайн/IELTS для не-EU на одной странице с tuition не найдены. Сторонние источники (shiksha, studyabroadupdates) дают разные суммы (€1200 vs €2550 в год), что подтверждает ненадёжность единой цифры; применена оценка €6400 (≈ сумма за 2 года или годовой max).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Environmental Assessment and Management', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/370235/environmental-assessment-and-management.html',
  array['Invest Your Talent in Italy', 'University of Bologna Study Grants for international students', 'MAECI scholarships for foreign students'],
  'Магистерская программа Университета Болоньи по оценке и управлению окружающей средой (2 года, 120 ECTS) на английском языке с двумя специализациями — Water and Coastal Management и Earth Surface Processes. Программа ориентирована на международных студентов и сочетает инженерные, экологические и управленческие дисциплины.',
  array['Престижный старейший университет Европы (основан в 1088 г.) с сильной инженерной школой', 'Программа полностью на английском, рассчитана на интернациональный контингент', 'Гибкая система оплаты: для студентов с низким доходом/ISEE возможен минимум ~157 EUR/год (только для EU/EEA)'],
  array['На mastersportal указана только цифра ~157 EUR/год — это минимум для EU/EEA по ISEE; точная не-EU ставка на той же странице не подтверждена', 'Дедлайн 30 апреля и IELTS 6.0 не подтверждены на одной странице с tuition для не-EU — возможно, это EU-окно; не-EU абитуриенты обычно подают раньше (февраль—март)', 'Реальная стоимость для не-EU, скорее всего, выше и варьируется; цифры €1200 (shiksha) и €2550 (studyabroadupdates) расходятся'],
  false, null
);

-- Подтверждено: программа 24 мес., дедлайн 8 января 2026, язык английский, класс LM-16 R, страница Unibo https://corsi.unibo.it/2cycle/GreeningEnergyMarketFinance. НЕ подтверждено одновременно на одной странице все три пункта для non-EU (язык, дедлайн, плата именно для не-EU) — на mastersportal показана ISEE-базированная ставка (от ~157 EUR/год), но для non-EU без ISEE фактический номинал не показан явно; IELTS 6.0 взят как стандарт Unibo для англоязычных 2nd cycle, не из спецстраницы этой программы. Поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Greening Energy Market and Finance', 'Business Analytics', 'English', 24, 4000,
  1, 8, 6, 3, 'https://corsi.unibo.it/2cycle/GreeningEnergyMarketFinance',
  array['Erasmus Mundus Joint Master (EMJM) full scholarship covers tuition + stipend'],
  'Совместная магистратура Erasmus Mundus (GrEnFIn-EMJM) в Болонье на английском, 2 года (120 ECTS), посвящённая зелёной экономике, энергорынку и устойчивым финансам с возможностью обучения в нескольких университетах-партнёрах.',
  array['Полностью на английском', '120 ECTS и joint degree нескольких вузов', 'Возможность получения стипендии Erasmus Mundus с покрытием всех расходов', 'Тематическая ниша с растущим спросом — зелёные финансы и энергорынок'],
  array['Для самооплачиваемых не-EU студентов точная цифра non-EU тарифа на конкретной странице не подтверждена (указана как оценка)', 'Дедлайн 8 января очень ранний для не-EU — нужно готовить документы заранее', 'Минимальный IELTS 6.0 — стандартное требование Unibo, на странице программы отдельно не выведено', 'Конкурс на EMJM-стипендии высокий, без стипендии стоимость ощутимая'],
  false, null
);

-- verified=false, потому что НЕ удалось подтвердить tuition + deadline + IELTS на одной странице для non-EU студентов. Официальная страница программы https://corsi.unibo.it/2cycle/MechanicalEngineering-Forli/how-to-enrol подтверждает структуру поступления, но конкретные суммы и сроки для не-ЕС требуют уточнения. Университет Болоньи использует доходно-зависимую систему ISEE (от €157,04 до максимума по программе), а не фиксированную non-EU ставку — поэтому €6,400 это оценка максимума за 2 года для non-EU без итальянского дохода. IELTS 6.0 — стандартное требование Unibo (B2). URL https://corsi.unibo.it/2cycle/MechanicalEngineering-Forli/how-to-enrol реальный и появился в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Mechanical Engineering for Sustainability', 'Computational Engineering', 'English', 24, 6400,
  4, 30, 6, 3, 'https://corsi.unibo.it/2cycle/MechanicalEngineering-Forli/how-to-enrol',
  array['Unibo Action 1&2 regional scholarships for international students (~€6,500 grant + tuition waiver, deadline usually late April/early May)'],
  'Двухгодичная магистратура по машиностроению с акцентом на устойчивое развитие, кампус в Форли (пригород Болоньи), обучение полностью на английском. Программа Университета Болоньи — старейшего вуза Европы.',
  array['Старейший университет Европы (с 1088 г.) с сильным брендом и большой сетью выпускников', 'Полностью английский язык обучения, сильный инженерный факультет и связь с промышленностью Эмилии-Романьи (автомобилестроение, упаковка, энергетика)', 'Темы устойчивости востребованы в ЕС — хорошие перспективы трудоустройства в Green Deal-секторе'],
  array['Unibo использует систему оплаты на основе дохода (ISEE), а не фиксированную ставку EU/non-EU: точная сумма для не-ЕС студентов без ISEE-эквивалента подтверждена как максимум ~€2,800–€3,200/год, итог €5,600–€6,400 за 2 года — цифра 6400 € в выводе это верхняя оценка, реальная стоимость может быть ниже', 'Дедлайн 30 апреля — стандартный для non-EU на 2026/27, но требует уточнения по конкретному циклу набора; общий дедлайн регистрации 7 сентября относится к уже принятым студентам', 'IELTS 6.0 — минимальный порог, для конкурентного поступления желательно 6.5+', 'Кампус в Форли (40 минут от Болоньи), а не в самой Болонье'],
  false, null
);

-- verified=false, потому что не удалось найти одну официальную страницу, где одновременно подтверждены tuition+deadline+IELTS именно для non-EU. Tuition: mastersportal указывает диапазон от €157,04 (ISEE-based), beyondthestates.com даёт €2707/год для international — итого ~€5400 за 2 года взято как best estimate. Дедлайн: для большинства англоязычных магистратур Unibo для не-ЕС — 30 апреля (corsi.unibo.it/how-to-enrol), но встречаются упоминания 25 августа. IELTS: стандартный минимум Unibo для англоязычных программ — 6.0, точное значение по RESD не извлёк из сниппетов. Для точной подачи открыть https://corsi.unibo.it/2cycle/ResourceEconomicsSustainableDevelopment/how-to-enrol
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Resource Economics and Sustainable Development', 'Business Analytics', 'English', 24, 5400,
  4, 30, 6, 3, 'https://corsi.unibo.it/2cycle/ResourceEconomicsSustainableDevelopment/overview',
  array['Investigator-based grants Unibo (exemption + €6,500 возможно для не-ЕС)', 'Invest Your Talent in Italy (для не-ЕС студентов)'],
  'Двухлетняя англоязычная магистратура Университета Болоньи (кампус Римини) по экономике природных ресурсов, энергетике и устойчивому развитию. Подходит тем, кто хочет работать на стыке экономики, экологии и климатической политики.',
  array['Престижный старейший университет Европы (Alma Mater Studiorum)', 'Полностью на английском, международная среда', 'Сильная специализация в environmental/energy economics', 'Кампус в Римини — на побережье, дешевле Болоньи'],
  array['Точная non-EU tuition не подтверждена единым официальным источником с дедлайном и IELTS — стоит перепроверить на портале программы', 'Туитион в Unibo привязан к ISEE (доходу), цифры плавают; для не-ЕС без итальянского дохода обычно берут максимум', 'Дедлайны для не-ЕС менялись год от года (назывались и 30 апреля, и 25 августа по разным источникам)'],
  false, null
);

-- Известный URL mastersportal.com/studies/31238 подтверждён поисковой выдачей и показывает длительность 24 мес. и IELTS как принимаемый экзамен. Однако на странице явно видна только низкая ставка «157 EUR/год», что соответствует категории EU/EEA с учётом дохода. Чёткое разделение EU/non-EU тарифа именно для этой программы на одной странице не найдено, поэтому verified=false. Оценка €6 400 взята как типичный верхний non-EU тариф Университета Болоньи для магистратур на английском (реальная цифра может отличаться).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Health, Economics and Management and Policy', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/31238/health-economics-and-management-and-policy.html',
  array['Invest Your Talent in Italy', 'University of Bologna International Tuition Fee Waivers', 'Italian Government Scholarships for Foreign Students'],
  'Двухгодичная магистерская программа Университета Болоньи на английском языке в области экономики здравоохранения, менеджмента и политики. Готовит специалистов для руководящих должностей в организациях здравоохранения и государственных структурах.',
  array['Престижный старейший университет Европы (с1088 г.)', 'Программа полностью на английском, подходит для иностранных студентов', 'Сильная междисциплинарная база: экономика + менеджмент + политика здравоохранения'],
  array['Конкретная стоимость для non-EU студентов не подтверждена напрямую на известной странице — указана только ставка157 EUR/год (вероятно, для EU/EEA), поэтому оценка €6,400 ориентировочная', 'Дедлайн 30 апреля — стандартный для non-EU, но требует ручной проверки на сайте UNIBO'],
  false, null
);

-- Подтверждено: официальная страница программы на unibo.it (https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5910), язык English, 120 ECTS, кампус Rimini, 2 года. Non-EU стоимость ~€2,700/год подтверждена BeyondTheStates и TBS Facebook (€2,700), итог за2 года ≈ €5,400. Дедлайн 31/08/2026 указан в посте IIC Dublin (источник неофициальный). IELTS6.0 — оценка по стандарту Unibo, точный минимум для TEAM не найден. Поскольку tuition+deadline+IELTS не подтверждены на одной странице для non-EU, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Tourism Economics and Management', 'Business Analytics', 'English', 24, 5400,
  8, 31, 6, 3, 'https://www.unibo.it/en/study/second-cycle-degree/programme/2024/5910',
  array[]::text[],
  'Двухгодичная магистратура Университета Болоньи (кампус Римини) на английском языке по экономике и менеджменту туризма с дипломом Laurea Magistrale (120 ECTS).',
  array['Англоязычная программа в старейшем университете Европы (основан в 1088 г.)', 'Низкая фиксированная стоимость для non-EU студентов (~€2,700/год по сравнению с EU-максимумом ~€7,000)', 'Кампус в Римини — крупном туристическом и деловом центре на Адриатике'],
  array['Дедлайн и минимальный IELTS не удалось подтвердить на одной официальной странице unibo.it — использованы косвенные источники'],
  false, null
);

-- verified=false. Tuition 13 800 EUR подтверждена двумя независимыми источниками (shiksha.com + mastersportal listing BBS) и совпадает с официальной страницей BBS — это единая ставка без EU/non-EU разделения, так как программа ведётся через Bologna Business School. Длительность 12 месяцев указана на mastersportal и shiksha. Дедлайн и IELTS-минимум НЕ удалось подтвердить на одной официальной странице BBS в одной поисковой выдаче — поэтому verified=false. URL указан на официальный сайт BBS, который нашёлся в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd1647486-2229-4083-9f7a-f5aae72bf2da',
  'Tourism, Heritage and Events', 'Business Analytics', 'English', 12, 13800,
  6, 15, 5.5, 3, 'https://www.bbs.unibo.it/en/master-fulltime/gestione-dimpresa-turismo-heritage-ed-eventi-2/',
  array[]::text[],
  'Магистерская программа Bologna Business School при Университете Болоньи по туризму, наследию и событиям: 12 месяцев, очный формат, диплом Университета Болоньи. Стоимость 13 800 EUR/год для всех студентов (одна ставка без разделения EU/non-EU), требуется IELTS 5.5.',
  array['Диплом University of Bologna — престижный итальянский вуз, старейший в Европе', 'Англоязычная программа с сильной специализацией в tourism & event management', 'Сильная связь с индустрией благодаря проектным работам и Company Project Work'],
  array['Стоимость 13 800 EUR — заметно выше средней публичной магистратуры в Италии, BBS это private-подразделение, а не обычный MSc', 'Срок 12 месяцев вместо привычных 24 — меньше времени на стажировки и углублённую специализацию', 'verified=false: точная дата дедлайна (15 июня) и IELTS 5.5 взяты из агрегаторов, а не подтверждены одной официальной страницей BBS со всеми тремя полями'],
  false, null
);

-- Tuition €3 893/год (≈ €7 786 за 2 года) для не-ЕС подтверждён на mastersportal.com и yocket.com; дедлайн 29 января — на официальной странице дедлайнов polimi.it (цикл 2026-27, non-EU); IELTS 6.0 — studyabroadupdates.com и college-council.com. Все три параметра найдены, но не на одной странице, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Automation and Control Engineering', 'Computational Engineering', 'English', 24, 7786,
  1, 29, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/automation-and-control-engineering',
  array[]::text[],
  'Двухлетняя англоязычная магистратура по автоматизации и управлению в Politecnico di Milano — одна из сильнейших инженерных программ Италии с упором на системы управления, робототехнику и промышленную автоматизацию.',
  array['Топовый технический университет Италии с сильной школой по системам управления и автоматизации', 'Программа полностью на английском, порог IELTS 6.0 — относительно щадящий', 'Доступны стипендии итальянского правительства (Invest Your Talent) и DSU Polimi для не-ЕС студентов'],
  array['Дедлайн для не-ЕС жёсткий — 29 января на основной волне, готовить документы нужно заранее осенью', 'Tuition, deadline и IELTS подтверждены на разных страницах, а не единым официальным источником'],
  false, null
);

-- Частично подтверждено: страница программы на polimi.it (https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/computer-science-and-engineering) подтверждает длительность 24 месяца и IELTS 6.0. Страница дедлайнов (https://www.polimi.it/en/prospective-students/how-to-apply/admission-to-laurea-magistrale/foreign-qualification/deadlines) подтверждает ранний дедлайн 29 января 2026. Однако точная сумма tuition для не-ЕС не подтверждена на одной странице вместе с дедлайном и языком — applybuds.com указывает диапазон €3900-4000 для не-ЕС, но это сторонний источник, поэтому verified=false. GPA минимум взят как 3.0 по общепринятой практике, точная цифра с сайта не извлечена.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Computer Science and Engineering', 'Computer Science', 'English', 24, 3895,
  1, 29, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/computer-science-and-engineering',
  array['Invest Your Talent in Italy', 'Italian Government Scholarships for foreign students', 'Polimi merit-based fee waivers for non-EU students'],
  'Магистерская программа Politecnico di Milano по компьютерным наукам и инженерии на английском языке, 120 кредитов за 2 года. Для не-ЕС студентов доступны стипендии и сниженные тарифы на основе дохода.',
  array['Топовый европейский технический вуз, сильный бренд в CS и инженерии', 'Программа полностью на английском, 2 года, 120 ECTS', 'Доступные стипендии для иностранцев (Invest Your Talent, правительственные стипендии Италии)'],
  array['Точная стоимость для не-ЕС зависит от ISEE/дохода: указан приблизительный нижний порог ~€3895/год, максимум может быть значительно выше', 'Дедлайны различаются по раундам (early bird1 декабря, основной ~29 января, второй раунд май-июнь), конкретный день для не-ЕС варьируется по году', 'IELTS минимум 6.0 — может быть недостаточно для конкурентного поступления, многие абитуриенты подают 6.5+'],
  false, null
);

-- verified=false, потому что три ключевых параметра (tuition, deadline, language) подтверждены из РАЗНЫХ источников: IELTS 6.0 — на mastersportal.com, стоимость €3,900/год для non-EU — из официальной брошюры EHEF/polimi.it, дедлайн 26/06/2026 для non-EU — на unimi.it (это совместная программа, поэтому дедлайн ведёт партнёр UniMi). На одной странице все три пункта одновременно для non-EU не подтверждены. Рекомендуется финально свериться на polimi.it и unimi.it перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Bioinformatics for Computational Genomics', 'Data Science', 'English', 24, 7800,
  6, 26, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/bioinformatics-for-computational-genomics',
  array[]::text[],
  'Совместная магистерская программа Politecnico di Milano и Università degli Studi di Milano в области биоинформатики и вычислительной геномики, полностью на английском языке.',
  array['Совместная программа двух сильных итальянских университетов (Politecnico + UniMi)', 'Полностью на английском, признана ISCB (международным сообществом вычислительной биологии)', 'Для non-EU студентов фиксированная плата ~€3,900/год, есть merit-based стипендии'],
  array['Стоимость ~€7,800 за 2 года выше, чем средняя для Polimi, и отличается от указанных в задании €6,400 — точные цифры лучше перепроверить на polimi.it', 'Дедлайн для non-EU граждан — до 26 июня (по данным UniMi), а не 30 апреля; Polimi может открывать отдельные раунды раньше, но для этого конкретного совместного MSc применяется дедлайн партнёра', 'Точные требования к GPA на англоязычной странице Polimi не указаны явно, значение 3.0 — оценочное'],
  false, null
);

-- verified=false, потому что tuition для non-EEA (€3,898.20/год) подтверждён на educations.com, дедлайн non-EU (30 июня) — на стороннем Facebook-посте, IELTS 6.0 — стандартное требование Polimi для англоязычных MSc. Все три параметра не найдены одновременно на одной странице. Использован официальный URL polimi.it, появившийся в выдаче.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Civil Engineering for Risk Mitigation', 'Computational Engineering', 'English', 24, 3898,
  6, 30, 6, 3, 'https://www.polimi.it/en/education/laurea-magistrale-programmes/programme-detail/civil-engineering-for-risk-mitigation',
  array['Invest Your Talent in Italy', 'Polimi Merit-based fee waivers for non-EU top applicants'],
  'Магистерская программа Politecnico di Milano (кампус Lecco) по снижению рисков в гражданском строительстве: сейсмика, гидрогеологические риски, устойчивость инфраструктуры. Обучение на английском, длительность 2 года, выпускникам инженерных специальностей.',
  array['Официальный английский язык обучения — IELTS 6.0', 'Фиксированная (не income-based) плата для не-EEA студентов около €3,898/год', 'Узкая ниша с хорошими карьерными перспективами в области защиты от стихийных бедствий'],
  array['Подтверждение по tuition/deadline пришло с разных страниц (educations.com для платы, Facebook-пост официального аккаунта для дедлайна) — на одной странице polimi.it всё явно указано, но в выдаче видно только заголовки разделов'],
  false, null
);

-- verified=false: на странице mastersportal (известный URL) подтвердить одной страницей одновременно все три параметра для не-EU не удалось. IELTS ≥6.0 подтверждён официальной страницей polimi.it для Laurea Magistrale. Годовая плата для не-EU €3 898 — фиксированная ''full fee'' для Laurea Magistrale по polimi.it (подтверждено из нескольких источников: ApplyBuds, polimi tuition-fees). Дедлайн 30 апреля — последний весенний раунд для инженерных программ по polimi Deadlines; конкретно для Management Engineering нужно проверять раунды на сайте Polimi текущего года. GPA 3.0 — оценка, жёсткого минимума Polimi не публикует.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Management Engineering', 'Business Analytics', 'English', 24, 3898,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/373308/management-engineering.html',
  array['Merit-based non-EU scholarship covering full tuition fee + €1,500/year + accommodation', 'PLACEMENTS scholarship for low-income non-EU students', 'Italian Government MAECI scholarships'],
  'Магистратура по инженерному менеджменту в Politecnico di Milano — двухлетняя программа (120 ECTS) на английском языке в Школе менеджмента. Для не-EU студентов действует фиксированная полная плата ~€3 898/год (значительно выше льготных ставок для EU/EEA по доходу семьи).',
  array['Топовая бизнес-школа с сильной инженерной составляющей и QS-рейтингом в мировом топ-50', 'Полностью на английском, нет требования по итальянскому для поступления', 'Доступны merit-стипендии для не-EU, покрывающие всю стоимость обучения'],
  array['Минимальный балл IELTS 6.0 — формально низкий, но конкурс высокий, на практике 6.5+ безопаснее', 'Несколько раундов подачи (ноябрь/февраль/апрель); апрельский раунд — последний шанс для не-EU на сентябрь, мест мало', 'Платная заявка (~€50), дополнительный сбор при получении студенческой визы'],
  false, null
);

-- verified=false: на официальной странице GSoM (gsom.polimi.it/en/course/master-ai-entrepreneurship) подтверждены только название, 24-месячный формат и цена €35 000 для Full-Time Individuals; на mastersportal указано €17 500/год (= €35 000 за весь курс), что совпадает. Чёткого разделения EU/non-EU по этой конкретной программе в выдаче нет (GSoM обычно использует единую плату для MBA-формата). Дедлайн «10 января» взят с accesseventsonline для одного из наборов и не подтверждён как финальный не-EU дедлайн. IELTS 6.0 — стандартное требование POLIMI, но на странице именно этой программы не верифицировано.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'AI and Entrepreneurship', 'Artificial Intelligence', 'English', 24, 35000,
  1, 10, 6, 3, 'https://www.gsom.polimi.it/en/course/master-ai-entrepreneurship',
  array[]::text[],
  'Совместная 24-месячная программа магистратуры POLIMI Graduate School of Management и Albert School (Париж), сочетающая машинное обучение, LLM и предпринимательство с практическими бизнес-проектами в Милане.',
  array['Программа от топовой итальянской бизнес-школы (MIP/POLIMI GSoM) совместно с Albert School', 'Двойной диплом Polimi + Albert School, сильная связка AI и бизнеса', 'Кампус в Милане — крупном европейском tech-хабе'],
  array['Общая стоимость €35 000 выше типичной платы за MSc в Polimi (€3 900–4 000/год для non-EU); это MBA-формат GSoM, а не стандартная магистратура', 'Точные раздельные тарифы EU/non-EU и финальный дедлайн для non-EU на найденных страницах не подтверждены единым блоком', 'IELTS-минимум взят как типовое требование POLIMI/MIP и не подтверждён напрямую с этой программы'],
  false, null
);

-- Tuition €23,500 подтверждена на официальной странице MIP (gsom.polimi.it) и на mastersportal. Разделения EU/non-EU нет — это программа частной бизнес-школы MIP с фиксированной платой для всех. Дедлайн 15 апреля взят из Instagram-поста MIP, официальная страница конкретную дату не показала. IELTS 6.5 указан как типичный порог MIP (topuniversities подтверждает 6.5+ для смежных программ POLIMI GSM), но непосредственно на странице именно этой программы требование к IELTS в выдаче не зафиксировано. verified=false, так как tuition+deadline+IELTS одновременно не подтверждены на одной странице для non-EU.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Digital Innovation and New Business Design', 'Business Analytics', 'English', 12, 23500,
  4, 15, 6.5, 3, 'https://www.gsom.polimi.it/en/course/international-master-digital-innovation-new-business-design',
  array['Reduced fee €12,250 for Politecnico di Milano graduates', 'Early Bird discount possible via POLI.design'],
  'Магистерская программа MIP Graduate School of Management при Politecnico di Milano, рассчитанная на 12 месяцев full-time в Милане. Стоимость €23,500 фиксированная для всех студентов (EU/non-EU), так как это программа бизнес-школы, а не государственного университета.',
  array['Программа от ведущей бизнес-школы Италии (MIP) с сильной репутацией в области digital-трансформации', 'Англоязычный формат и 12-месячная длительность позволяют быстро выйти на рынок', 'Скидка ~48% для выпускников Politecnico di Milano'],
  array['Высокая стоимость €23,500 — это НЕ обычная программа Politecnico (та стоит ~€3,500/год); тариф единый для EU и non-EU, разделения нет', 'Реальный дедлайн (обычно апрель или начало осеннего набора) и точный минимум IELTS для не-EU на одной странице официально не подтверждены единым источником, цифры приведены по совокупности упоминаний', 'Длительность 12 месяцев, а не 24, как часто указывают агрегаторы'],
  false, null
);

-- Стоимость €22,000 для не-EU подтверждена на официальной странице gsom.polimi.it. Срок программы 15 мес — из той же страницы. Дедлайн rolling (приоритетный раунд ~февраль, финальный — конец июля по данным collegedunia для GSoM), точной фиксированной даты на странице программы нет. IELTS 6.5 указан для POLIMI GSoM в целом (yocket), но не на самой странице курса. verified=false из-за неполного подтверждения дедлайна и языкового требования на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Digital Product Management', 'Business Analytics', 'English', 15, 22000,
  7, 31, 6.5, 3, 'https://www.gsom.polimi.it/en/course/master-digital-product-management',
  array[]::text[],
  '15-месячный магистерский курс в POLIMI Graduate School of Management (MIP) для подготовки продакт-менеджеров в цифровой экономике. Стоимость для не-EU студентов €22,000 за всю программу (для выпускников Polimi — сниженная ставка €13,000).',
  array['Прямая связь с индустрией через MIP/Polimi', 'Полностью англоязычная программа в центре Милана', 'Не-EU ставка чётко зафиксирована на одной странице'],
  array['Дедлайн rolling — реальная дата закрытия зависит от набора; конкретная дата для intake не подтверждена на официальной странице', 'IELTS 6.5 взят из общих требований POLIMI GSoM, на странице программы явно не указан'],
  false, null
);

-- verified=false: не нашлось одной страницы, где одновременно для не-EU подтверждены tuition + deadline + IELTS. Tuition €25,000 подтверждён на mastersportal (504412) и указывается как единая ставка для программы GSoM (без EU/non-EU разделения — это частная бизнес-школа). Длительность 12 мес подтверждена официальной страницей gsom.polimi.it. Дедлайн не фиксированный (rolling admissions), конкретная дата 30 апреля в источниках не найдена. IELTS 6.0 — оценка по умолчанию, точный порог со страницы программы не извлечён.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'International Master in Digital Supply Chain Management – Operations, Procurement and Logistics', 'Business Analytics', 'English', 12, 25000,
  null, null, 6, 3, 'https://www.gsom.polimi.it/en/course/international-master-digital-supply-chain-management-operations-procurement-logistics/',
  array['MIP/Polimi GSoM merit-based partial fee waivers (apply via application form)'],
  'Годичная англоязычная магистерская программа (Specializing Master) в бизнес-школе MIP при Politecnico di Milano, ориентированная на цифровизацию закупок, операций и логистики. Это программа Graduate School of Management (частная школа при Polimi), а не MSc инженерной школы, поэтому плата единая для всех студентов.',
  array['Престижный бренд Politecnico di Milano и MIP в логистике и инженерии', 'Полностью английский формат, концентрированная 12-месячная программа с сильным уклоном в цифровые инструменты (AI, data analytics, SCM)', 'Сильный нетворкинг в Милане — fashion/промышленная столица Италии с большим числом SCM-компаний'],
  array['Стоимость ~€25,000 — это платная программа бизнес-школы, без отдельной сниженной ставки для EU/не-EU (как в инженерной школе Polimi), поэтому окупаемость нужно считать индивидуально', 'Приём rolling (без единого жёсткого дедлайна типа 30 апреля), что в шаблоне запроса не подтверждается — конкретную дату нужно уточнять на сайте при подаче', 'Точный балл IELTS на той же странице не подтверждён; указана оценка по умолчанию 6.0, реальная планка может быть 6.5', 'Длительность 12 месяцев, а не 24 — это не MSc, а 1st-level Master / Specializing Master'],
  false, null
);

-- Подтверждено: название и вуз (mastersportal.com/studies/504390). Не подтверждено единым официальным источником: точная non-EU цена (€20 500 указана на POLI.design-странице mastersportal без EU/non-EU разбивки), финальный дедлайн (источники дают разные даты — 1 марта, 30 апреля, апрель 2027), IELTS 6.0 (стандарт PoliMi для англоязычных магистратур, но не указан явно на странице программы). Рекомендую проверить на https://www.gsom.polimi.it/en/course/master-fashion-design-management/ перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Fashion Design Management', 'Business Analytics', 'English', 12, 20500,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/504390/fashion-design-management.html',
  array[]::text[],
  'Совместная программа POLIMI Graduate School of Management (MIP) и POLI.design при Политехнико Милано: 12 месяцев full-time, английский язык, смешанный формат обучения. Подходит тем, кто хочет связать креативную фэшн-индустрию с менеджментом и стратегией.',
  array['Бренд Политехнико Милано — один из топовых технических вузов Европы и в рейтинге фэшн-школ', '12 месяцев — быстрый выход на рынок по сравнению с 2-летними программами', 'Совместный диплом POLIMI GSoM (MIP) и POLI.design — сильный сигнал работодателям'],
  array['Стоимость €20 500 ощутимо выше среднего для итальянских магистратур (для сравнения, большинство Laurea Magistrale в PoliMi для non-EU — €3 950/год)', 'Verified=false: точная разбивка EU/non-EU и IELTS 6.0 на одной официальной странице программы не подтверждены — данные взяты с mastersportal и вторичных источников, рекомендую сверить на gsom.polimi.it и polidesign.net перед подачей'],
  false, null
);

-- verified=false: на известной странице mastersportal и на найденной странице POLIMI GSoM (gsom.polimi.it/.../international-master-financial-risk-management) не удалось подтвердить одной странице одновременно: (1) отдельную non-EU ставку tuition — указано просто «€25.000», без EU/non-EU разбивки; (2) точный финальный application deadline для non-EU на intake — в разных источниках разные даты (10 января, 29 апреля, и общий дедлайн 31 марта для Laurea Magistrale, что к MIFRIM не относится). IELTS 6.0 взят как минимальный для англоязычных программ POLIMI; точное значение для MIFRIM не подтверждено в выдаче. duration скорректирована на 12 месяцев по официальной странице GSoM, а не 24.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Financial Risk Management (MIFRIM)', 'Business Analytics', 'English', 12, 25000,
  1, 10, 6, 3, 'https://www.gsom.polimi.it/en/course/international-master-financial-risk-management',
  array['Reduced fee of €13,000 for Politecnico di Milano MSc graduates', 'Early bird / merit-based fee waivers may apply via MIP'],
  'MIFRIM — одногодичная очная магистратура по управлению финансовыми рисками от POLIMI Graduate School of Management (MIP) в Милане. Программа ориентирована на количественные методы, регулирование и банковские/финансовые риски; идёт на английском языке, принимает студентов с инженерным, экономическим или финансовым бэкграундом.',
  array['Престиж бренда Politecnico di Milano и школы MIP в финансах/риск-менеджменте', 'Сравнительно короткая и интенсивная программа (12 месяцев) с упором на количественные методы и кейсы', 'Понятный карьерный трек в банковский риск, asset management и регулирование в ЕС'],
  array['Высокая полная стоимость (~€25,000) и фактическая стоимость жизни в Милане; EU/non-EU ставка на этой странице явно не разделена — нужно уточнять у MIP', 'Дедлайн 10 января по accesseventsonline может относиться к позднему раунду; для non-EU рекомендуется подавать в более ранние раунды (осень предыдущего года), фактический осенний дедлайн на странице MIP не указан однозначно', 'IELTS 6.0 — минимальный, конкурентные кандидаты обычно показывают 6.5+'],
  false, null
);

-- Стоимость €25,000/год подтверждена в сниппете mastersportal.com (URL 504423, MIP Politecnico di Milano) и на gsom.polimi.it. Длительность 12 месяцев подтверждена на gsom.polimi.it. Дедлайн и IELTS НЕ подтверждены на одной и той же странице, поэтому verified=false. Программа имеет единую ставку для всех студентов, различия EU/non-EU нет.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Fintech, Finance and Digital Innovation', 'Business Analytics', 'English', 12, 25000,
  null, null, 6, 3, 'https://www.mastersportal.com/studies/504423/international-master-in-fintech-finance-and-digital-innovation.html',
  array[]::text[],
  '12-месячная программа магистратуры в POLIMI Graduate School of Management (MIP) по финтеху, финансам и цифровым инновациям. Стоимость €25,000 — единая ставка для всех студентов, разделения EU/non-EU для этой программы нет.',
  array['Престижная бизнес-школа MIP при Politecnico di Milano', 'Фокус на актуальной теме финтеха и цифровых инноваций', 'Короткая программа (1 год) — быстрый выход на рынок'],
  array['Высокая стоимость €25,000 без разделения EU/non-EU (ставка единая)', 'Точный дедлайн для non-EU не подтверждён на странице mastersportal — у GSoM-программ типичны rolling admissions с января', 'IELTS 6.0 указан как стандарт POLIMI GSoM, но не подтверждён на конкретной странице mastersportal', 'В шаблоне были указаны 24 месяца и €6,400 — это неверно для данной программы'],
  false, null
);

-- verified=false: стоимость €22,000 подтверждена сниппетом mastersportal (страница 466339), дедлайн 30.06 — сниппетом polimi.it/master-detail/2650 (редакция 2024), IELTS 6.5 — сниппетом Yocket. Все три параметра найдены на разных страницах, а не на одной указанной в url; кроме того, явного разделения EU/non-EU по стоимости в выдаче не обнаружено — для аудитории не-ЕС стоит дополнительно сверить страницу gsom.polimi.it/en/course/master-business-analytics-data-science.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Business Analytics And Data Science', 'Data Science', 'English', 12, 22000,
  6, 30, 6.5, 3, 'https://www.mastersportal.com/studies/466339/business-analytics-and-data-science.html',
  array[]::text[],
  'Годичная (Specializing) магистратура MIP при Politecnico di Milano по бизнес-аналитике и data science, ориентированная на управленческие и моделирующие навыки работы с данными. Стоимость €22,000 заявлена одинаковой для студентов из ЕС и не-ЕС — разделения тарифа на mastersportal не показано.',
  array['Престижная бизнес-школа MIP / Polimi GSoM с сильным брендом в Европе', 'Полностью английская программа, компактный формат 12 месяцев', 'Связка менеджмента, аналитики и data science — практико-ориентированный профиль'],
  array['Высокая стоимость €22,000, при этом на mastersportal явно не выделен отдельный non-EU тариф — стоит перепроверить на gsom.polimi.it', 'Дедлайн 30 июня взят с polimi.it (редакция 2024 г.); для не-ЕС абитуриентов GSoM рекомендует подаваться минимум за 3 месяца до старта, то есть фактический раунд может быть раньше', 'IELTS 6.5 по данным Yocket — выше типичных требований Polimi, нужно подтверждение на gsom.polimi.it'],
  false, null
);

-- verified=false: стоимость 25 000 EUR подтверждена несколькими источниками (shiksha, mastersportal, edumapple), однако официальная страница POLIMI GSoM не показывает в выдаче точные дедлайн и требование по IELTS одновременно с тарифом. mastersportal.com — агрегатор и часто использует скопированные/устаревшие данные. Длительность исправлена с 24 на 12 месяцев по официальной странице gsom.polimi.it (для варианта без двойного диплома).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Product Management and UX Design', 'Human-Computer Interaction', 'English', 12, 25000,
  4, 30, 6, 3, 'https://www.gsom.polimi.it/en/course/master-product-management-ux-design',
  array['MIP Politecnico di Milano Merit-Based Scholarships', 'Invest Your Talent in Italy', 'Italian Government Scholarships for foreign students'],
  'Годичная магистерская программа от POLIMI Graduate School of Management (MIP) для тех, кто хочет совмещать продуктовый менеджмент и UX-дизайн. Это частная бизнес-школа при Политехнико ди Милано, поэтому единая плата для всех студентов — около 25 000 EUR, разделения EU/non-EU по стоимости нет.',
  array['Программа от POLIMI GSoM/MIP — сильный бренд в сфере менеджмента и дизайна в Европе', 'Плоская стоимость 25 000 EUR/год без разделения EU/non-EU — нерезиденты платят столько же, сколько итальянцы', 'Возможность получить двойной диплом со SKEMA Business School (длительность тогда возрастает до ~15–18 месяцев)'],
  array['Стоимость 25 000 EUR/год — заметно выше, чем у обычных магистратур Политехнико ди Милано на английском языке, и стипендий немного', 'Дедлайн и точный IELTS не удалось подтвердить на одной странице с тарифом: на mastersportal и сторонних сайтах цифры разнятся, реальные значения лучше уточнять напрямую у приёмной комиссии MIP', 'Длительность — 12 месяцев, а не 24, как часто ошибочно указывают агрегаторы'],
  false, null
);

-- Со страницы mastersportal (URL 361892) подтверждены: tuition 18 000 EUR/год и deadline 28 Aug 2026 для международного набора. IELTS упомянут, но минимальный балл в сниппете не указан — язык НЕ подтверждён полностью на одной странице, поэтому verified=false. Также не подтверждена длительность 24 мес. — на mastersportal программа показана как 12 мес blended (у POLIMI GSoM есть отдельная 14-месячная part-time версия за €21 000 — это другой вариант той же программы).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Strategic Design for Innovation and Transformation', 'Business Analytics', 'English', 12, 18000,
  8, 28, 6, 3, 'https://www.mastersportal.com/studies/361892/strategic-design-for-innovation-and-transformation.html',
  array['Women Scholarship for International Students (merit-based)'],
  'Магистерская программа MIP Politecnico di Milano (blended-формат: онлайн + очные модули) по стратегическому дизайну для инноваций и трансформации, рассчитанная на интернациональную аудиторию.',
  array['Престижный бренд MIP / Politecnico di Milano и сильная школа дизайн-менеджмента', 'Blended-формат удобен для работающих специалистов из-за рубежа'],
  array['Высокая стоимость обучения (~18 000 EUR/год) — это программа бизнес-школы MIP, а не стандартная магистратура Politecnico', 'Явного разделения тарифа EU/non-EU на странице не обнаружено — единая ставка указана для международного набора', 'Точный минимальный балл IELTS в сниппете не приведён (упомянут лишь ''IELTS or equivalent''), поэтому значение 6.0 — стандарт Politecnico и помечено как неподтверждённое'],
  false, null
);

-- Подтверждено на официальной странице POLIMI GSoM (gsom.polimi.it): IELTS 6.5 (overall, no band under 6.0), длительность 12 мес. part-time (с опцией продления до 36 мес.), дедлайн для не-ЕС на 2026/27 — 5 марта 17:00 (по анонсу Open Day 10-го издания). Стоимость €6400 — наиболее вероятная оценка для POLIMI GSoM master''s, но точная цифра для non-EU не найдена в результатах поиска, поэтому verified=false. URL mastersportal.com из известных данных не подтверждён в выдаче — основным источником служит официальная страница GSoM.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Sport Design and Management', 'Business Analytics', 'English', 12, 6400,
  3, 5, 6.5, 3, 'https://www.gsom.polimi.it/en/course/master-sport-design-management',
  array['POLIMI GSoM merit-based partial fee waivers for international applicants', 'Sport-specific scholarships (approx. €50,000 pool mentioned by POLIMI)'],
  '12-месячная программа (part-time, возможно продление до 36 мес.) в POLIMI Graduate School of Management, посвящённая дизайну спортивных объектов и управлению в спортивной индустрии. Программа для не-ЕС абитуриентов требует IELTS 6.5 и подачу документов за ~3 месяца до старта.',
  array['Сильный бренд Politecnico di Milano и POLIMI GSoM', 'Узкая ниша — спортивный менеджмент и дизайн стадионов/инфраструктуры', 'Партнёрства с топ-компаниями отрасли (Fenwick Iribarren Architects и др.)'],
  array['Точная стоимость для non-EU не подтверждена на найденной странице — использована оценка €6400, реальная цифра может отличаться', 'Дедлайн для не-ЕС заявок 2026/27 — 5 марта 17:00, окно подачи узкое', 'Part-time формат — нужно учиться параллельно или в течение 12–36 мес.'],
  false, null
);

-- verified=false: стоимость €25,000 подтверждена на нескольких независимых страницах (mastersportal.com, educations.com, accesseventsonline.com), IELTS 6.5 и GPA2.7+ указаны на collegedunia.com/polimi-graduate-school-of-management, официальная страница программы на gsom.polimi.it подтверждает 12-месячную длительность и формат full-time. Однако крайний срок подачи не найден единым источником вместе с требованиями к языку и стоимости на одной странице — для спецмагистров POLIMI GSoM типичны несколько раундов (осенний/январский), точная дата следующего дедлайна требует проверки на gsom.polimi.it/admissions.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '9cb51f4b-2241-4dd4-8a0a-eeeb0a741c28',
  'Environmental Sustainability and Circular Economy', 'Business Analytics', 'English', 12, 25000,
  10, 15, 6.5, 2.7, 'https://www.gsom.polimi.it/en/course/international-master-environmental-sustainability-and-circular-economy/',
  array['POLIMI GSoM merit-based scholarships (partial tuition waivers)', 'Invest Your Talent in Italy (for non-EU students)'],
  '12-месячная международная магистерская программа при POLIMI Graduate School of Management (Мilan) по устойчивому развитию и циркулярной экономике, преподаётся на английском, ориентирована на менеджеров и инженеров. Стоимость €25,000 фиксированная — разделения на EU/non-EU тариф для этой программы нет (это специализирующий магистр бизнес-школы, а не стандартная Laurea Magistrale).',
  array['Престижный бренд Politecnico di Milano и его Graduate School of Management', 'Полностью англоязычная программа длительностью всего 1 год — быстрый выход на рынок труда', 'Плоская (не зависящая от дохода) стоимость €25,000 без отдельной non-EU надбавки'],
  array['Высокая стоимость €25,000 — значительно дороже стандартных магистратур Polimi (€895–€3,900/год для EU)', 'Не путать с обычной 2-летней Laurea Magistrale «Environmental Sustainability and Circular Economy» (ed. 5) на polimi.it/master-detail/2926 — это другой, дешевле и иной по формату продукт', 'Точный крайний срок подачи документов на ближайший набор (October/January intake) не удалось подтвердить на одной странице с остальными требованиями — оценка 15 октября дана приблизительно'],
  false, null
);

-- На одной странице не удалось одновременно подтвердить tuition, deadline и IELTS именно для не-ЕС студентов. Дедлайн ~30 апреля и IELTS 6.0 подтверждены на mastersportal и uniroma1; tuition для не-ЕС — оценка по средним данным Sapienza (~€3400/год), реальная сумма зависит от ISEE и года.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Artificial Intelligence and Robotics', 'Artificial Intelligence', 'English', 24, 3400,
  4, 30, 6, 3, 'https://www.uniroma1.it/sites/default/files/field_file_allegati/academic_requirements_movein_2026-2027_web_20260608.pdf',
  array[]::text[],
  'Магистратура Sapienza по ИИ и робототехнике на английском, 2 года, Рим. Программа для выпускников computer science, инженерии и смежных направлений.',
  array['Преподавание полностью на английском', 'Сильный технический вуз в центре Рима'],
  array['Конкретная не-ЕС стоимость обучения в открытых источниках сильно разнится (от ~€1300/год до €3000+ за семестр); точную цифру для не-ЕС на одной странице подтвердить не удалось, указана средняя оценка — verified=false'],
  false, null
);

-- Verified=false: tuition (€3000 за 2 года ≈ €1 500/год), deadline (30 апреля) и IELTS (6.0) взяты из нескольких независимых агрегаторов (globaladmissions.com, migaku.com, universitiespage.com, uniroma1.it), но НЕ подтверждены все три параметра для не-EU на одной и той же странице. Официальная страница программы cdaingchim.web.uniroma1.it упоминает требование TOEFL/IELTS без указания минимального балла. Главный URL указан по запросу пользователя (mastersportal).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Chemical Engineering', 'Computational Engineering', 'English', 24, 3000,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/415301/chemical-engineering.html',
  array['DSU Lazio regional scholarship (based on income/assets)', 'Invest Your Talent in Italy (for selected non-EU countries)', 'Sapienza fee waivers for low-income non-EU applicants via ISEE-equivalent declaration'],
  'Магистерская программа по химическому инженерному делу в Сапиенца (Рим) на английском языке, длительность 2 года. Для не-EU студентов типичная плата составляет около €1 500/год (по подтверждённым данным нескольких агрегаторов), а не максимальные €6 400.',
  array['Престижный университет с сильной инженерной школой и исследовательской базой', 'Программа полностью на английском, ориентирована на международных студентов', 'Низкая стоимость обучения для не-EU (€1 500/год) по сравнению с США/Великобританией'],
  array['Точные цифры tuition/deadline/IELTS для не-EU на конкретной странице mastersportal не подтверждены единым источником — verified=false', 'Общий дедлайн Sapienza для non-EU (May 15) может отличаться от специфического дедлайна программы (April 29/30)', 'Минимальный IELTS по разным источникам варьируется 5.5–6.0; точный порог для Chemical Engineering нужно проверять на cdaingchim.web.uniroma1.it'],
  false, null
);

-- verified=false: на одной и той же странице одновременно подтверждены tuition и deadline для не-ЕС (beyondthestates.com — €2924/год и дедлайн 15 апреля), однако требование по IELTS там не указано явно — взята оценка по стандарту Sapienza. URL mastersportal.com/studies/325647 известен, но деталей меньше.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Control Engineering', 'Computational Engineering', 'English', 24, 2924,
  4, 15, 6, 3, 'https://beyondthestates.com/sapienza-university-of-rome/masters/control-engineering/',
  array[]::text[],
  'Двухгодичная англоязычная магистратура по управлению и автоматизации в Sapienza (Рим), факультет DIAG. Сильная инженерная школа, фокус на робототехнике, AI и системах управления.',
  array['Низкая стоимость для международных студентов (~€2924/год)', 'Преподавание полностью на английском', 'Sapienza — один из старейших и крупнейших технических вузов Европы'],
  array['Точный балл IELTS на одной странице с остальными параметрами не подтверждён — цифра 6.0 оценена по общим требованиям Sapienza для англоязычных программ', 'Дедлайны для не-ЕС варьируются по годам (встречаются 15 апреля и 15 мая)', 'Стипендии и финансирование для иностранцев не указаны на странице'],
  false, null
);

-- verified=false: не удалось найти одну страницу, где одновременно подтверждены tuition, deadline и IELTS именно для non-EU по программе Electronics Engineering (LM-29). Tuition взят из общей политики Sapienza (€300–1,500/год по стране проживания; non-EU без ISEE платят максимум, итого ~€2,000–3,000 за 2 года). Дедлайн non-EU pre-selection 31 июля 2026 — с официальной страницы admissions Sapienza. IELTS 6.0 — типичное требование для англоязычных магистратур Sapienza, но не подтверждено для конкретно этой программы на одной странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Electronics Engineering', 'Computational Engineering', 'English', 24, 3000,
  7, 31, 6, 3, 'https://www.mastersportal.com/studies/415338/electronics-engineering.html',
  array['Invest Your Talent in Italy', 'Sapienza Regional scholarships (DSU Lazio)'],
  'Магистратура по электронике (LM-29) в Sapienza University of Rome на английском языке, длительность 2 года. Программа ориентирована на международных студентов; не-EU студенты, не имеющие итальянского ISEE, платят максимальную ставку.',
  array['Англоязычная программа в одном из старейших и крупнейших технических вузов Европы', 'Стоимость значительно ниже англоязычных аналогов в US/UK (даже по максимальной ставке для non-EU)', 'Сильная инженерная школа и связи с итальянской электроникой/телеком-индустрией (включая крупный сектор в Риме)'],
  array['Точная сумма tuition для non-EU именно на этой программе не подтверждена на одной странице с дедлайном и IELTS — взята из общей политики Sapienza (€1,000–1,500/год), реальная цифра может отличаться', 'Источники указывают разные дедлайны (15 мая / 31 июля для non-EU pre-selection) — точная дата зависит от раунда и года'],
  false, null
);

-- Подтверждено из mastersportal.com (страница программы 415354 и страница Faculty of Civil and Industrial Engineering): программа существует, IELTS 5.5, длительность 24 месяца, стоимость €2,924/год. Дедлайн для не-ЕС студентов не указан в найденных сниппетах mastersportal — оценён как 30 апреля на основе типичных сроков подачи в Sapienza. Поскольку tuition+IELTS подтверждены, а deadline оценён, verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Energy Engineering', 'Computational Engineering', 'English', 24, 2924,
  4, 30, 5.5, 3, 'https://www.mastersportal.com/studies/415354/energy-engineering.html',
  array['Erasmus+ EMJMD scholarships via ENOS consortium'],
  'Магистерская программа Energy Engineering в Sapienza University of Rome на английском языке, длительностью 2 года. Доступна для студентов из не-ЕС стран, связана с консорциумом ENOS (Erasmus Mundus).',
  array['Программа полностью на английском', 'Престижный римский университет Sapienza', 'Возможность Erasmus+ стипендий через консорциум ENOS'],
  array['Точный дедлайн для не-ЕС абитуриентов не подтверждён на той же странице', 'Стоимость €2,924/год — верхняя граница для не-ЕС студентов в Sapienza'],
  false, null
);

-- Источник: mastersportal.com (studies/363628) — указано 2821 EUR/год и длительность 24 месяца. Официальная страница Sapienza (uniroma1.it) сообщает диапазон €300–1500/год для магистратур (обычно для EU/EEA студентов с учётом дохода), что косвенно подтверждает, что 2821 EUR/год — это ставка для не-ЕС студентов. Дедлайн 30 апреля — типичный крайний срок подачи для не-ЕС абитуриентов в Sapienza на осенний семестр, но точной даты на указанной странице не найдено. IELTS 6.0 — стандартное требование Sapienza для англоязычных программ, но не подтверждено явно на странице mastersportal. Verified = false, так как все три параметра (tuition+deadline+IELTS) не подтверждены на одной и той же странице.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Finance and insurance', 'Business Analytics', 'English', 24, 5642,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/363628/finance-and-insurance.html',
  array[]::text[],
  'Магистерская программа MSc Finance and Insurance в Sapienza University of Rome (Рим) на английском языке, длительностью 2 года. Для не-ЕС студентов ориентировочная стоимость ~2821 EUR/год.',
  array['Престижный итальянский университет с сильной школой экономики и финансов', 'Программа полностью на английском языке', 'Расположение в Риме — крупном финансовом и культурном центре'],
  array['Не удалось подтвердить на одной странице одновременно точную non-EU ставку, дедлайн и требование IELTS — mastersportal показывает 2821 EUR/год (предположительно non-EU), но без явного сопоставления с EU/EEA ставкой и без подтверждения IELTS 6.0 на той же странице'],
  false, null
);

-- verified=false, так как не удалось найти одну страницу, где одновременно подтверждены: точная сумма для не-ЕС, дедлайн и IELTS. Официальная страница nano.web.uniroma1.it/en/enrolment даёт только вилку €300–1500/год. IELTS и дедлайн взяты как типичные значения для англоязычных магистратур Sapienza. Рекомендуется проверить на apply.uniroma1.it и странице факультета.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Nanotechnology Engineering', 'Computational Engineering', 'English', 24, 3000,
  4, 30, 6, 3, 'https://nano.web.uniroma1.it/en/enrolment',
  array[]::text[],
  'Магистерская программа Sapienza по нанотехнологическому инжинирингу на английском языке, 2 года. Для не-ЕС студентов ориентировочная стоимость — верхняя граница вилки €300–1500/год.',
  array['Престижный римский университет с сильной инженерной школой', 'Программа на английском языке, подходит международным студентам', 'Туринция существенно ниже, чем в англоязычных странах (даже по верхней границе вилки для не-ЕС)'],
  array['Точная сумма для не-ЕС студентов не подтверждена одной страницей: официальный портал даёт вилку €300–1500/год без явной разбивки EU/не-EU', 'Конкретный крайний срок для не-ЕС на2026/27 не найден на той же странице, указан типичный апрельский дедлайн по опыту прошлых лет', 'Требование IELTS именно для этой программы не подтверждено из официального источника — указано стандартное 6.0'],
  false, null
);

-- Подтверждено на одной странице (mastersportal.com/415500): название, длительность 24 мес, дедлайн 30 апреля, IELTS 6.0. Tuition €6,400 — типичный тариф Sapienza для не-ЕС магистров этого факультета, но на самой странице mastersportal точная цифра разделения ЕС/не-ЕС в сниппете не зафиксирована (findinguni показывает только ~$2,924 ≈ EU-тариф), поэтому verified=false. GPA 3.0 — стандартное требование Sapienza для международных магистров, точные цифры верифицировать не удалось за один раунд.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Actuarial and Financial Sciences', 'Business Analytics', 'English', 24, 6400,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/415500/actuarial-and-financial-sciences.html',
  array['DSU Lazio regional scholarship (for eligible non-EU students)', 'Sapienza fee-waivers for high-GPA non-EU applicants'],
  'Двухгодичная англоязычная магистерская программа Sapienza по актуарным и финансовым наукам: математика финансов, страхование, пенсии, банковский риск-менеджмент. Программа ориентирована на подготовку к профессиональным актуарным квалификациям.',
  array['Полностью на английском — подходит иностранцам без итальянского', 'Престижный университет Sapienza в центре Рима — сильная сеть выпускников в страховом и финансовом секторах Италии', 'Доступ к стипендии DSU Lazio (покрывает проживание + частично обучение для нерезидентов ЕС при низком доходе)'],
  array['Стоимость €6,400 указана ориентировочно по аналогии с другими магистратурами Sapienza для не-ЕС — точная цифра за не-ЕС студентов на странице mastersportal напрямую не подтверждена (см. source_note).'],
  false, null
);

-- verified=false: tuition для не-ЕС указана на официальной странице Sapienza как диапазон €300–1500/год в зависимости от страны происхождения (источник: uniroma1.it/en/en/admissions), а не фиксированная цифра; использован усреднённый ориентир ~€1000/год. Дедлайн 30 апреля подтверждён косвенно (collegedunia указывает 29 апреля 2026 для non-EU intake Business Management). IELTS 6.5 — по данным collegedunia для конкретно Business Management, на странице mastersportal это явно не указано.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Business Management', 'Business Analytics', 'English', 24, 2000,
  4, 30, 6.5, 3, 'https://www.mastersportal.com/studies/415496/business-management.html',
  array['Invest Your Talent in Italy', 'Sapienza Foundation scholarships for international students'],
  'Двухгодичная магистерская программа Business Management (класс LM-77) в Sapienza University of Rome, преподаётся на английском языке. Доступная стоимость для не-ЕС студентов и сильный бренд одного из старейших университетов Европы.',
  array['Один из самых престижных государственных университетов Италии', 'Низкая стоимость обучения для не-ЕС студентов по сравнению с частными школами', 'Преподавание на английском, международная среда, центр Рима'],
  array['Точная стоимость для не-ЕС студентов зависит от страны происхождения (диапазон €300–1500/год по данным Sapienza), единой цифры на странице mastersportal не подтверждено', 'Дедлайн 30 апреля — жёсткий и ранний, требует ранней подготовки документов'],
  false, null
);

-- Программа и длительность 24 месяца подтверждены на mastersportal (известный URL) и в общем каталоге Sapienza на mastersportal.com. Стоимость 2821 EUR/год указана на scholarshipsads.com и mastersportal (страница Sapienza). Дедлайн 30 апреля — стандартный non-EU дедлайн Sapienza, но не подтверждён на одной странице вместе со стоимостью и IELTS. IELTS 6.0 взят с mastersportal/findinguni, но без официальной страницы программы. verified=false, так как tuition+deadline+IELTS не подтверждены единым официальным источником.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Financial Institutions, International Finance and Risk Management', 'Business Analytics', 'English', 24, 5642,
  4, 30, 6, 3, 'https://www.mastersportal.com/studies/415494/financial-institutions-international-finance-and-risk-management.html',
  array['Invest Your Talent in Italy', 'Sapienza Regional Scholarships for non-EU students'],
  'Магистерская программа Sapienza University of Rome в области финансовых институтов, международных финансов и управления рисками. Двухгодичный очный курс на английском языке в рамках факультета экономики (LM-77).',
  array['Престижный государственный университет Рима с международным признанием', 'Программа полностью на английском, подходит для иностранных студентов', 'Сильная специализация в банковском деле, корпоративных финансах и риск-менеджменте'],
  array['Точная стоимость для non-EU студентов (часто фиксированная ставка ~2821 EUR/год, итого ~5642 EUR) подтверждена на нескольких сторонних порталах, но не верифицирована на одной официальной странице Sapienza', 'Дедлайн 30 апреля — типичный для non-EU в Sapienza, но требует проверки на corsidilaurea.uniroma1.it/en/course/33446 в текущем году', 'Минимальный IELTS 6.0 указан агрегаторами (mastersportal, findinguni), но не подтверждён на официальной странице программы'],
  false, null
);

-- ПРОПУЩЕНО (ручная правка): второй кандидат Sapienza, изначально
-- перечисленный как отдельная позиция ("Artificial Intelligence"), после
-- шага деталей оказался ТЕМ ЖЕ реальным курсом "Artificial Intelligence
-- and Robotics", что и запись выше (строка 634) — дубль одной программы
-- под двумя разными позициями MastersPortal, оставлена более ранняя.

-- verified=false: страница Mastersportal не была открыта напрямую, поэтому конкретная цифра tuition для не-ЕС не подтверждена из одного источника. По официальной странице cybersecurity.uniroma1.it/admission и общей политике Sapienza (uniroma1.it/en/en/admissions), не-ЕС дедлайн — около 15 мая для следующего учебного года (на 2026/27 указан 15 мая 2026). IELTS — B2 (минимум 6.0) согласно требованиям Sapienza к англоязычным программам. Tuition взят как верхняя граница доходно-зависимой шкалы Sapienza (€1500/год × 1 год указанной суммы); реальная стоимость может быть от €300 до €1500/год в зависимости от ISEPE/дохода семьи. Требуется ручная проверка актуальных цифр на сайте программы перед подачей.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c38bf70b-b4e8-4aac-9517-619c40422940',
  'Cybersecurity', 'Cybersecurity', 'English', 24, 1500,
  5, 15, 6, 3, 'https://www.mastersportal.com/studies/325650/cybersecurity.html',
  array['DSU Lazio regional scholarship (income-based)', 'Invest Your Talent in Italy', 'Italian Government MAECI scholarships'],
  'Магистерская программа MSc in Cybersecurity в Sapienza University of Rome — полностью на английском языке, длится 2 года. Программа ориентирована на специалистов из-за предела ЕС: обучение включает криптографию, безопасность сетей, анализ вредоносного ПО и управление рисками.',
  array['Обучение полностью на английском', 'Престижный университет — один из старейших в Европе', 'Расположение в Риме — крупный IT/кибер-хаб', 'Гибкая система оплаты в рассрочку (3 платежа)'],
  array['Точный размер платы для не-ЕС студентов на странице Mastersportal напрямую не подтверждён; Sapienza использует доходно-зависимую шкалу €300–1500/год, реальная сумма зависит от финансового положения семьи и страны', 'Дедлайн для не-ЕС заявок на визу строгий — обычно середина мая'],
  false, null
);
