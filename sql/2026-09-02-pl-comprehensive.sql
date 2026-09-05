-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Poland (pl) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- verified=false, потому что все три параметра (tuition+deadline+IELTS) НЕ подтверждены на одной и той же странице для non-EU студентов. Тариф 3500 EUR/семестр подтверждён на официальной странице https://www.international.agh.edu.pl/en/studies/fees (International Management, non-EU). IELTS напрямую не указан — mastersportal даёт только TOEFL iBT 72 (≈ IELTS 6.0). Дедлайн не подтверждён документально, взята распространённая дата для AGH —30 июня, требует уточнения на странице recruitment.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a6afb9f5-c1aa-458f-a4de-585f529b74a6',
  'International Management', 'Business Analytics', 'English', 24, 14000,
  6, 30, 6, 3, 'https://www.international.agh.edu.pl/en/studies/fees',
  array[]::text[],
  'Магистерская программа International Management в AGH University of Krakow (факультет менеджмента) на английском, 4 семестра. Стоимость для иностранных (non-EU) студентов — 3500 EUR за семестр (7000 EUR/год, ~14000 EUR за всю программу).',
  array['Стоимость указана на официальной странице AGH для иностранных студентов (3500 EUR/семестр)', 'Программа полностью на английском в техническом университете с сильной инженерной репутацией', 'Краков — крупный студенческий и деловой центр Польши, относительно низкие расходы на жизнь'],
  array['Конкретный дедлайн подачи документов и точный минимум IELTS не удалось подтвердить на той же официальной странице с тарифами (на mastersportal указан TOEFL iBT 72, что примерно соответствует IELTS 6.0; дедлайн для non-EU обычно около конца июня — оценка, точную дату нужно уточнять)', 'AGH — технический вуз, менеджмент там не самая сильная специализация по сравнению с экономическими университетами Польши', 'Источник тарифа — общая страница fees, а не карточка программы на старом URL (старая страница old.international.agh.edu.pl в выдаче недоступна)'],
  false, null
);

-- 2026-09-03, ручной дедуп-обзор перед --apply: программа "Computer
-- Science and Intelligent Systems: Artificial Intelligence and Data
-- Analysis" (в этом прогоне найдена дважды под двумя URL, обе версии
-- убраны отсюда) — дубль уже существующей в базе записи "AGH University
-- of Krakow — Computer Science and Intelligent Systems: AI and Data
-- Analysis" (то же самое чуть короче названное). normalizeName() не
-- поймал из-за расхождения в словах — на этот раз дубль не внутри
-- прогона, а против уже существующей строки, тот же класс ловушки, что
-- документирован для BME/Trento/TU Wien.

-- URL https://wtp.agh.edu.pl/en/node/116 подтверждён поиском как страница магистратуры AGH с этой программой. Стоимость 4200 EUR/год для non-residents подтверждена на mastersportal.com и qogentglobal.com, общая за 2 года = 8400 EUR. Однако дедлайн и IELTS не найдены на той же официальной странице программы, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a6afb9f5-c1aa-458f-a4de-585f529b74a6',
  'Mechatronic Engineering (Mechatronic Design)', 'Robotics', 'English', 24, 8400,
  7, 15, 6, 3, 'https://wtp.agh.edu.pl/en/node/116',
  array[]::text[],
  'Магистерская программа AGH University of Krakow по мехатронике (специализация Mechatronic Design) на английском языке, длительностью 2 года, ориентирована на проектирование мехатронных систем, робототехнику и автоматизацию.',
  array['Умеренная стоимость обучения для не-ЕС студентов (около 4200 EUR/год)', 'Полностью английский язык обучения', 'Сильная техническая база факультета Mechanical Engineering and Robotics AGH'],
  array['Точная дата дедлайна подачи для не-ЕС студентов не подтверждена на известной странице — указана оценка', 'Минимальный балл IELTS 6.0 не подтверждён напрямую на странице программы — взят стандарт AGH для англоязычных программ', 'Источники разнятся (4200 vs 4800 EUR/год), точную официальную цифру на 2025/26 нужно уточнять в приёмной комиссии'],
  false, null
);

-- Предупреждения при сборе:
-- - AGH University of Krakow / "Geo-Data Science (Master's Studies in English)": No JSON array found. stop_reason=end_turn, blocks=[thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result, thinking, server_tool_use, server_tool_use, web_search_tool_result, web_search_tool_result]. Text: (empty)
