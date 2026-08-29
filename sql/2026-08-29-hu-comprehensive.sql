-- Автоматически собрано инструментом scripts/research-programs.mjs
-- Страна: Hungary (hu) — comprehensive режим (BME), модель: claude-sonnet-5
-- Дата: 2026-08-29
--
-- РУЧНАЯ ПРАВКА: из исходных 10 найденных для BME оставлены только 2 —
-- остальные 8 оказались дублями программ, уже добавленных на более
-- раннем (ручном, агентском) этапе сбора данных под другими названиями
-- ("MSc in Electrical Engineering" = "Electrical Engineer MSc",
-- "MSc in Vehicle Engineering" = "Vehicle Engineer MSc",
-- "MSc in Logistics Engineering" = "Logistics Engineer MSc",
-- "MSc in Land Surveying and Geoinformatics" = "Land Surveying and
-- Geographical Information Systems Engineering MSc",
-- "MSc in Construction IT Engineering" = "Construction Information
-- Technology Engineer MSc", "MSc Finance (Stipendium Hungaricum listing)"
-- = "Finance MSc", "MSc in Computer Engineering / Software Engineering"
-- предположительно то же самое, что "MSc Computer Science Engineering" —
-- BME так тщательно охвачен на раннем этапе, что почти всё совпало).
-- Плюс внутри самого этого прогона "Master in Regional and Environmental
-- Economics" и "MA Regional and Environmental Economic Studies" —
-- дубль одной и той же программы в двух формулировках, оставлена та,
-- у которой источник конкретнее (страница курса в каталоге Stipendium
-- Hungaricum).
--
-- НЕ запущено в Supabase — выполнить вручную через SQL Editor, или
-- node scripts/run-sql.mjs sql/<этот файл>.sql --apply

-- verified=false: страница https://epito.bme.hu/msc?language=en не была загружена напрямую (доступен только поиск). Стоимость 8 000 USD/год для не-ЕС студентов взята из официального поста BME в Facebook (unibme.official, 7 ноября 2025 г.) — это самый авторитетный найденный источник, но указан в USD, поэтому в EUR стоимость оценочная (≈ 7 400 EUR/год при курсе ~0,92). Дедлайн 15 мая 2026 для autumn intake подтверждён постом BME GPK от 8 апреля 2026 г. IELTS 6.0 — из того же ноябрьского поста BME (общее требование к English-taught MSc). Чтобы выставить verified=true, нужно увидеть на одной странице epito.bme.hu одновременно: tuition для non-EU в EUR, deadline и IELTS — этого сделать не удалось.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'MSc in Civil Engineering', 'Computational Engineering', 'English', 24, 7400,
  5, 15, 6, 3, 'https://epito.bme.hu/msc?language=en',
  array['Stipendium Hungaricum'],
  'Двухгодичная магистратура по гражданскому строительству в BME (Будапешт) на английском языке для иностранных студентов; один из старейших технических вузов Центральной Европы (основан в 1782 г.).',
  array['Престижный технический университет с 240-летней историей и сильной инженерной школой', 'Программа полностью на английском, 4 семестра', 'Стоимость заметно ниже, чем в Западной Европе; доступна стипендия Stipendium Hungaricum'],
  array['Точная стоимость для не-ЕС на самой странице программы не подтверждена — в официальных материалах BME указана в USD (8 000 USD/год, ≈ 7 400 EUR/год), EUR-эквивалент рассчитан по текущему курсу', 'Дедлайн 15 мая для осеннего набора 2026 жёсткий и требует ранней подготовки документов', 'Минимальный IELTS 6.0 — для некоторых англоязычных программ в ЕС требуется 6.5', 'ВАЖНО: возможно пересекается по смыслу с уже существующими у BME специализированными программами (Structural Engineer MSc, Infrastructural Engineer MSc) — Faculty of Civil Engineering в BME традиционно делит гражданское строительство на специализации; проверить перед показом, не одна ли это и та же программа под общим названием'],
  false, null
);

-- Удалось найти официальный каталог Stipendium Hungaricum для этой программы (apply.stipendiumhungaricum.hu/courses/course/1629), страницу BME по admission (bme.hu/en/application_and_admission) и агрегатор huneducation.com. Однако раздел tuition с разделением EU/non-EU на одной официальной странице в выдаче не подтвердился — поэтому verified=false. Tuition взят из стороннего агрегатора studyinhungarybd.com (EUR 2200/семестр = ~EUR 8800 за всю программу).
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'MA Regional and Environmental Economic Studies', 'Business Analytics', 'English', 24, 8800,
  11, 15, 6, 3, 'https://apply.stipendiumhungaricum.hu/courses/course/1629-ma-regional-and-environmental-economic-studies',
  array['Stipendium Hungaricum (full tuition + stipend + accommodation)'],
  'Магистерская программа BME по региональной и экологической экономике на английском, 4 семестра (2 года), 120 ECTS. Доступна через стипендию Stipendium Hungaricum для иностранных студентов.',
  array['Престижный технический университет BME', 'Англоязычная программа, подходит для не-ЕС студентов', 'Возможность получения стипендии Stipendium Hungaricum, покрывающей обучение'],
  array['Точная стоимость для self-financing студентов подтверждена только сторонним источником (EUR 2200/семестр = ~EUR 8800 за всю программу); страница курса на apply.stipendiumhungaricum.hu в сниппете поиска не раскрыла полный блок tuition/deadline/IELTS одновременно', 'Дедлайн SH может сдвигаться (обычно октябрь–декабрь для следующего учебного года) — точную дату нужно проверять на сайте посольства/партнёра'],
  false, null
);
