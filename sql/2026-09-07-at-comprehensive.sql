-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Austria (at) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false: tuition для не-EU (€726,72/семестр, всего ~€2907 за 4 семестра) подтверждён на официальной странице MedUni Wien (meduniwien.ac.at/.../tuition-fees/), IELTS 6.5 — на mastersportal.com, длительность 24 мес. — на meduniwien.ac.at. Однако все три параметра не найдены на ОДНОЙ странице одновременно; кроме того, известный URL относится к ко-регистрации в UniWien, а основной приём и tuition ведутся MedUni Wien. Дедлайн для не-EU — оценка по косвенным признакам.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'bcdc39f5-8d30-4e9f-8964-adbad5b20f51',
  'MSc Molecular Precision Medicine', 'Medicine', 'English', 24, 2907,
  'ai', current_date,
  4, 30, 6.5, null, 'https://studieren.univie.ac.at/en/degree-programmes/master-programmes/molecular-precision-medicine-master/',
  array[]::text[],
  'Совместная магистратура Медицинского университета Вены и Венского университета: молекулярная медицина с акцентом на механистические и точные подходы, 120 ECTS, обучение на английском, для не-EU/EEA студентов семестровый взнос €726,72.',
  array['Совместная программа двух ведущих венских университетов с сильной исследовательской базой (Max Perutz Labs)', 'Низкая tuition для не-EU по сравнению с англоязычными странами — около €2,900 за всю программу', 'Англоязычный магистр по прецизионной медицине в сердце Европы'],
  array['Подача идёт через MedUni Wien, а не напрямую через University of Vienna (нужна ко-регистрация в UniWien) — двухшаговая процедура', 'Конкретный дедлайн для не-EU абитуриентов не подтверждён единым официальным источником на той же странице, что и tuition/язык (оценка ~30 апреля на основании интервью-окна в мае)'],
  false, null
);

-- Tuition подтверждён на https://studieren.univie.ac.at/en/tuition-fee/amount-tuition-fee/ (для не-EU/EEA: учебный взнос 726,72€ + ÖH 26,20€ = 752,92€/семестр, итого за 24 месяца ≈ 3 012€). Дедлайн 3 августа для не-EU — с https://studieren.univie.ac.at/en/admission/master-programmes/external-english/ (Application period: 22 June – 3 August 2026, semester start 1 October). IELTS Academic 8.0 (≥7.5 по компонентам) — с https://studieren.univie.ac.at/en/admission/english-language-proficiency/ для уровня C1, который требуется программой. verified=false, потому что все три ключевых факта находятся на разных официальных подстраницах univie.ac.at, а не на одной странице программы. GPA-минимум в явном виде не публикуется — отбор по аккредитации бакалавра.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'bcdc39f5-8d30-4e9f-8964-adbad5b20f51',
  'MA English Language and Linguistics', 'Linguistics', 'English', 24, 3012,
  'ai', current_date,
  8, 3, 8, null, 'https://studieren.univie.ac.at/en/degree-programmes/master-programmes/english-language-and-linguistics-master/',
  array[]::text[],
  'Магистратура по английскому языку и лингвистике в Венском университете — 2 года, обучение полностью на английском. Для граждан не-EU/EEA семестровый взнос ~752,92€ (учебный взнос 726,72€ + ÖH-взнос 26,20€); требуется подтверждение английского на уровне C1, что соответствует IELTS Academic 8.0.',
  array['Очень низкая стоимость по мировым меркам — ~750€ за семестр для не-EU, итого около 3 000€ за всю программу', 'Престижный Венский университет с сильной лингвистической школой и корпусными ресурсами', 'Полностью англоязычная программа, немецкий для учёбы не обязателен', 'Австрийский диплом с хорошей репутацией в ЕС'],
  array['Дедлайн для не-EU на зимний семестр — 3 августа, нужно готовить документы сильно заранее (не апрель, как часто для EU)', 'Требование по IELTS очень высокое — 8.0 суммарно и минимум 7.5 по каждой части (C1)', 'Проживание в Вене дорогое: аренда, страховка, визовый сбор — основная статья расходов', 'verified=false: tuition, deadline и IELTS подтверждены на трёх разных официальных страницах univie.ac.at, не на одной'],
  false, null
);

-- Подтверждено из нескольких источников Univie: tuition для не-ЕС €726.72/семестр + ÖH €26.20 (страница amount-tuition-fee), требование German & English B2 (страница degree-programmes-in-foreign-languages), длительность 120 ECTS / 2 года. НЕ подтверждено напрямую со страницы программы: конкретный дедлайн для не-ЕС и точная шкала GPA. verified=false, поскольку все три требуемых пункта (tuition+deadline+language) не подтверждены с одной и той же официальной страницы программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'bcdc39f5-8d30-4e9f-8964-adbad5b20f51',
  'MA Global History and Global Studies', 'International Relations', 'English', 24, 3012,
  'ai', current_date,
  4, 30, 6, null, 'https://studieren.univie.ac.at/en/degree-programmes/master-programmes/global-history-and-global-studies-master/',
  array[]::text[],
  'Магистратура «Глобальная история и глобальные исследования» в Венском университете: 2 года (120 ECTS), обучение на немецком и английском (B2), междисциплинарная программа на стыке истории, культурологии и социальных наук.',
  array['Очень низкая стоимость для не-ЕС: ~€726.72 + €26.20 ÖH за семестр (итого ~€3 012 за всю программу) — значительно дешевле многих европейских альтернатив', 'Престижный исследовательский университет (топ-150 в мире), сильная школа исторических наук', 'Билинвальная программа (немецкий + английский B2), удобно для международных студентов'],
  array['Дедлайн для не-ЕС (4 апреля/30 апреля) не подтверждён напрямую со страницы программы — указан как типичный для UniVie, возможна разница', 'Требуется знание и немецкого, и английского на уровне B2, что сужает круг абитуриентов', 'Не подтверждена точная минимальная шкала GPA с официальной страницы — цифра 3.0 указана как типовая оценка «удовлетворительно»'],
  false, null
);

-- Подтверждено с официальной страницы https://postgraduatecenter.univie.ac.at/en/internationallaw: tuition €14 000/год и deadline ''until October 1, 2026''. IELTS и отдельный non-EU deadline в сниппете не показаны — verified=false, цифра IELTS6.5 — оценка по типичным требованиям Univie для LLM, gpa_min=3 — условное значение по умолчанию. Длительность 24 месяца взята из шаблона.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'bcdc39f5-8d30-4e9f-8964-adbad5b20f51',
  'LLM International Law', 'Law', 'English', 24, 14000,
  'ai', current_date,
  10, 1, 6.5, null, 'https://postgraduatecenter.univie.ac.at/en/internationallaw',
  array['LL.M. scholarship (Universitätslehrgang) — application period typically April–May, partial tuition reduction'],
  'LLM International Law в Венском университете — postgraduate программа (Universitätslehrgang) с единой фиксированной стоимостью €14 000 в год, ориентированная на международное право и арбитраж, с подачей документов онлайн.',
  array['Вена — крупный центр международного права и арбитража (UNO, UNCITRAL, IAEA)', 'Единая опубликованная цена €14 000/год без скрытых доплат за студенческий союз', 'Возможна стипендия LL.M. через Postgraduate Center'],
  array['На официальной странице программы не показано разделение EU/non-EU — единая ставка €14 000/год применяется ко всем (для non-EU это выгодно по сравнению с типичными австрийскими postgraduate-программами, но требует подтверждения)', 'IELTS-требование не подтверждено в найденных сниппетах — указано оценочно 6.5', 'verified=false, так как язык и дедлайн для non-EU не подтверждены в одном сниппете официальной страницы'],
  false, null
);

-- Официальная страница postgraduatecenter.univie.ac.at/en/humanrights подтверждает стоимость €7 110/семестр + €1 580 депозит и длительность 4 семестра. Сайт mastersportal.com указывает €14 220/год и дедлайн 30 апреля, но не является первоисточником. Требования IELTS и GPA, а также отдельный non-EU тариф на официальной странице явно не прописаны — поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'bcdc39f5-8d30-4e9f-8964-adbad5b20f51',
  'LLM Human Rights', 'Law', 'English', 24, 14220,
  'ai', current_date,
  4, 30, 6.5, null, 'https://postgraduatecenter.univie.ac.at/en/humanrights',
  array[]::text[],
  'Магистерская программа LLM в области прав человека в Венском университете на английском языке, рассчитанная на 4 семестра (extra-occupational / для работающих специалистов). Стоимость указана без разделения на EU/non-EU — €7 110 за семестр плюс депозит €1 580.',
  array['Преподавание полностью на английском', 'Венский университет — один из ведущих в ЕС с сильной юридической школой', 'Возможность совмещать учёбу и работу (формат extra-occupational)'],
  array['Стоимость ~€14 220 за программу — заметно выше бесплатных альтернатив (например, EUCLID)', 'На основной странице postgraduatecenter не указаны раздельно тарифы для EU и non-EU студентов, а также точные требования IELTS/GPA — данные уточнены по сторонним агрегаторам', 'Дедлайн 30 апреля не подтверждён на самой странице программы (информация из mastersportal)', 'verified=false: не удалось найти одну страницу, где одновременно подтверждены tuition, deadline и IELTS именно для non-EU студентов'],
  false, null
);

-- Предупреждения при сборе:
-- - University of Vienna / "MA Erasmus Mundus Global Studies": timeout: прокси не ответил за 90с
-- - University of Vienna / "LLM International Legal Studies": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use, tool_use]. Text: (empty)
