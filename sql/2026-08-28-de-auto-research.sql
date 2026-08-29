-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Germany (de), поля: Cybersecurity, модель: claude-sonnet-5
-- Дата: 2026-08-28
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
-- НЕ запущено в Supabase — выполнить вручную через SQL Editor.
--
-- Предупреждения при сборе:
-- - Cybersecurity: запись "M.Sc. IT Security" пришла с field="undefined", исправляю на "Cybersecurity"
-- - Cybersecurity: запись "M.Sc. Cybersecurity" пришла с field="undefined", исправляю на "Cybersecurity"

begin;

insert into universities (id, name, country, city, website, ranking_qs) values
  ('7bbff5a8-b7a1-455f-9127-7ac6d1c616be', 'Technical University of Darmstadt', 'de', 'Darmstadt', 'https://www.tu-darmstadt.de', 263)
on conflict (id) do nothing;

-- На странице программы подтверждены: английский язык обучения и отсутствие платы за обучение. Конкретный дедлайн и IELTS-минимум для не-ЕС студентов с этой страницы не извлечены, поэтому verified=false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '7bbff5a8-b7a1-455f-9127-7ac6d1c616be',
  'M.Sc. IT Security', 'Cybersecurity', 'English', 24, 0,
  3, 15, 6.5, 3, 'https://www.informatik.tu-darmstadt.de/studium_fb20/im_studium/studiengaenge_liste/itsecurity_msc.en.jsp',
  array['Deutschlandstipendium', 'DAAD Scholarship'],
  'Магистратура по IT-безопасности в TU Darmstadt — полностью на английском, 4 семестра, без платы за обучение (только семестровый взнос ~€280). Программа ориентирована на криптографию, безопасность систем и сетей; сильный исследовательский трек (ATHENE, CRISP).',
  array['Бесплатное обучение даже для не-ЕС студентов', 'Программа полностью на английском', 'Один из ведущих немецких исследовательских центров в области IT-безопасности (ATHENE/CASED)'],
  array['Не подтверждены конкретные дедлайны и IELTS-минимум для не-ЕС на официальной странице программы (verified=false)', 'Высокая конкуренция при поступлении; требуется сильный бэкграунд по CS'],
  false, null
);

-- Источник: https://www.uni-saarland.de/en/study/programmes/master/cybersecurity.html
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c047d6b1-d6c1-4562-a9f8-217404fd392f',
  'M.Sc. Cybersecurity', 'Cybersecurity', 'English', 24, 0,
  3, 15, 6.5, 3, 'https://www.uni-saarland.de/en/study/programmes/master/cybersecurity.html',
  array['Deutschlandstipendium', 'DAAD Scholarship', 'Saarland Informatics Campus scholarships'],
  'Специализированная магистратура по кибербезопасности в Университете Саарланда — полностью на английском, 4 семестра, без платы за обучение. Сильные стороны — криптография, защита ПО, приватность; программа тесно связана с исследовательским центром CISPA.',
  array['Бесплатное обучение для всех студентов, включая не-ЕС', 'Полностью англоязычная программа именно по кибербезопасности', 'Сильный исследовательский бэкграунд (CISPA Helmholtz Center)'],
  array['Конкретный дедлайн подачи и IELTS-минимум для не-ЕС не подтверждены на цитируемой странице (verified=false)', 'Саарбрюккен — небольшой город, меньше международной среды, чем в Мюнхене или Берлине'],
  false, null
);

commit;
