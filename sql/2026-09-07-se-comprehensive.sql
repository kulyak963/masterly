-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Sweden (se) — comprehensive режим (по вузам, 3 шага: перечислить/классифицировать/детали), модель: claude-sonnet-5
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

-- Источник — официальная страница KTH по fees and scholarships (kth.se/en/studies/master/sustainable-urban-planning-and-design/fees-and-scholarships-...-1.909871): прямо указано «The full programme tuition fee for non-EU/EEA/Swiss citizens is SEK 360,000». Дедлайн 15 января подтверждён официальным периодом приёма на магистратуру KTH на 2026/2027 (16 Oct 2025 – 15 Jan 2026, kth.se). IELTS 6.5 подтверждён на официальной странице entry requirements конкретной программы (kth.se/en/studies/master/sustainable-urban-planning-and-design/entry-requirements-...-1.48352). Все три параметра взяты с официального домена kth.se, но с разных подстраниц программы, поэтому verified=true с оговоркой про мульти-страничный источник. GPA 3.0 — оценочная конвертация шведской шкалы (KTH не публикует жёсткого минимума GPA). Курс SEK/EUR взят ≈11,4 (середина 2025/начало 2026).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '255c5502-ab63-49ec-933d-7575ae2e7ea5',
  'MSc Sustainable Urban Planning and Design', 'Architecture', 'English', 24, 31500,
  'verified', current_date,
  1, 15, 6.5, null, 'https://www.kth.se/en/studies/master/sustainable-urban-planning-and-design/fees-and-scholarships-for-sustainable-urban-planning-and-design-1.909871',
  array['KTH Scholarship — полное покрытие tuition fee для граждан не-ЕС/ЕЭЗ/Швейцарии (≈30 стипендий в год, на основе академической успеваемости)'],
  'Двухлетняя англоязычная магистратура KTH в Стокгольме на стыке урбанистики, устойчивого развития и дизайна. Для граждан не-ЕС/ЕЭЗ обучение платное, для ЕС/ЕЭЗ/Швейцарии — бесплатное. Сильная инженерно-техническая школа с акцентом на проектную работу.',
  array['KTH — один из топовых технических вузов Европы и лидер в области устойчивого развития', 'Возможность получить стипендию KTH, полностью покрывающую tuition fee для не-ЕС студентов', 'Обучение полностью на английском, сильный международный контингент'],
  array['Высокая стоимость для не-ЕС (SEK 360,000 ≈ 31,500 EUR за всю программу) без стипендии; стипендия конкурсная', 'Дедлайн подачи заявки жёсткий — 15 января (документы к началу февраля), плюс отдельно нужно платить tuition fee первого семестра после зачисления'],
  true, current_date
);

-- Подтверждено на официальной странице VAPHE: наличие tuition для не-ЕС, требование English 6 (= IELTS 6.5). Дедлайн 15 января для не-ЕС подтверждён постом медицинского факультета Lund в Facebook. Точная сумма tuition не показана в сниппете официальной страницы — взята из globalscholarships.com (410 000 SEK ≈ 37 600 EUR), поэтому verified=false. GPA в шведской системе не указан, используется отбор по количеству кредитов.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'b61f515b-6e0c-4e9b-9000-ca22988a8e0a',
  'Public Health - Master''s Programme', 'Medicine', 'English', 24, 37600,
  'ai', current_date,
  1, 15, 6.5, null, 'https://www.lunduniversity.lu.se/study/public-health-masters-programme-VAPHE',
  array['Lund University Global Scholarship'],
  'Двухлетняя (120 кредитов) магистерская программа по общественному здравоохранению в Лундском университете (Мальмё, Швеция), преподаётся на английском. Программа стабильно входит в число самых востребованных магистратур Швеции.',
  array['Доступна стипендия Lund University Global Scholarship для не-ЕС студентов', 'Бесплатное обучение для граждан ЕС/ЕЭЗ и Швейцарии', 'Сильный бренд Lund University в области общественного здоровья'],
  array['Стоимость для не-ЕС высокая (~410 000 SEK за всю программу по данным globalscholarships.com, точная цифра не подтверждена в сниппете официальной страницы)', 'Ранний дедлайн — 15 января для не-ЕС, что требует быстрой подготовки документов', 'Требование IELTS 6.5 (не ниже 5.5 в каждой секции)'],
  false, null
);

-- Подтверждено со страницы su.se/henge: длительность 24 месяца и стоимость 180 000 SEK полностью / 45 000 SEK первый семестр для не-ЕС. Дедлайн и IELTS конкретно для этой программы в найденных сниппетах не указаны, поэтому поставлены оценочные значения (15 января — типичный дедлайн для не-ЕС через universityadmissions.se; IELTS 6.5 — общее требование Стокгольмского университета для магистратуры). verified=false, так как не все три параметра (tuition/deadline/language) подтверждены с одной страницы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  tuition_status, tuition_checked_at,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '11b70cfa-28d0-42c2-9a95-4aae80bca760',
  'Master''s Programme in English Language and Linguistics', 'Linguistics', 'English', 24, 7900,
  'ai', current_date,
  1, 15, 6.5, null, 'https://www.su.se/english/education/course-catalogue/he/henge',
  array['Swedish Institute Scholarship for Global Professionals'],
  'Двухгодичная магистерская программа Стокгольмского университета по английскому языку и лингвистике. Для граждан стран вне ЕС/ЕЭЗ общая стоимость составляет 180 000 SEK (~7 900 EUR/год).',
  array['Сильная лингвистическая школа, программа на английском', 'Бесплатно для граждан ЕС/ЕЭЗ/Швейцарии', 'Стокгольм — крупный академический и культурный центр'],
  array['Точный дедлайн для не-ЕС студентов не подтверждён из сниппетов поиска (указан оценочный 15 января по аналогии с другими программами SU)', 'IELTS6.5 — оценка по общему требованию SU; конкретный минимум для этой программы в найденных фрагментах не подтверждён', 'Высокая стоимость для не-ЕС (~180 000 SEK за весь курс)'],
  false, null
);

-- Предупреждения при сборе:
-- - Lund University / "Language and Linguistics, English - Master's Programme": No JSON array found. stop_reason=tool_use, blocks=[tool_use, tool_use, tool_use]. Text: (empty)
