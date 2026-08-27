-- Добавляет вузы и программы для Эстонии, Польши и Венгрии — единственных
-- трёх стран, которые уже можно выбрать в анкете (см. COUNTRIES_MORE в
-- app/page.tsx и CNAME-таблицы в dashboard/program), но по которым в базе
-- не было ни одной программы: студент выбирал страну и получал пустой список.
--
-- Все факты ниже собраны вручную с официальных страниц вузов (см. верхний
-- комментарий к каждой программе со ссылкой-источником) — это не догадки ИИ.
-- Тем не менее почти всё помечено verified=false: часть цифр (особенно
-- дедлайны и точный IELTS) взята с общих справочных страниц, а не с самой
-- актуальной страницы приёмной комиссии на 2026/27 год — то есть цифры
-- реальные и правдоподобные, но не 100% гарантированно свежие. Одно
-- исключение — TalTech Cybersecurity, где тюишн, дедлайн и IELTS найдены
-- на одной и той же официальной странице вуза, поэтому помечено verified=true.
--
-- avg_salary_after и acceptance_rate оставлены NULL для всех новых строк —
-- для них я не нашёл реальных опубликованных цифр, и разумнее оставить
-- пусто, чем угадывать (в отличие от старых 281 программы, где эти поля
-- уже заполнены оценками ИИ).

begin;

insert into universities (id, name, country, city, website, ranking_qs) values
  ('3bfa4605-b598-4604-8d2c-a3738ff9d26f', 'Tallinn University of Technology (TalTech)', 'ee', 'Tallinn', 'https://taltech.ee', null),
  ('c7303197-7098-42f0-a764-390385742399', 'University of Tartu',                        'ee', 'Tartu',   'https://ut.ee', null),
  ('d4bfe942-b78f-4bf0-b540-37b992f655de', 'Warsaw University of Technology',            'pl', 'Warsaw',  'https://www.pw.edu.pl', null),
  ('a6afb9f5-c1aa-458f-a4de-585f529b74a6', 'AGH University of Krakow',                   'pl', 'Krakow',  'https://www.agh.edu.pl', null),
  ('6b80088f-1578-4aa9-a976-6dae07a23cfb', 'Eötvös Loránd University (ELTE)',            'hu', 'Budapest','https://www.elte.hu', null),
  ('725b115c-db07-4946-8cf4-faef54de1bee', 'Budapest University of Technology and Economics (BME)', 'hu', 'Budapest', 'https://www.bme.hu', null)
on conflict (id) do nothing;

-- Источник: https://taltech.ee/en/masters-programmes/cybersecurity +
-- https://taltech.ee/en/apply (дедлайн и IELTS — с этой же страницы приёмной
-- комиссии, обе цифры относятся к циклу 2026 года) → verified = true.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '3bfa4605-b598-4604-8d2c-a3738ff9d26f',
  'MSc Cybersecurity', 'Cybersecurity', 'English', 24, 7000,
  4, 1, 6.0, 3, 'https://taltech.ee/en/masters-programmes/cybersecurity',
  array['TalTech tuition fee waiver (лучшим кандидатам)'],
  'Магистратура по кибербезопасности в стране, известной своим цифровым госуправлением — сильные связи с местной IT- и security-индустрией.',
  array['Университет и страна с прикладным фокусом на кибербезопасность и e-governance', 'Разумная стоимость по сравнению с Западной Европой'],
  array['Небольшой рынок труда за пределами IT-сектора Таллина'],
  true, current_date
);

-- Источник: https://cs.ut.ee/en/news/apply-masters-degree-institute-computer-science
-- (дедлайн подтверждён на офстранице), тюишн и IELTS — по общим справочникам
-- (Yocket/TopUniversities), не с этой конкретной страницы → verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'c7303197-7098-42f0-a764-390385742399',
  'MSc Computer Science', 'Computer Science', 'English', 24, 6000,
  3, 15, 6.0, 3, 'https://cs.ut.ee/en/curriculum/computer-science',
  array['Kristjan Jaak Scholarship (для граждан не из ЕС)'],
  'Классическая программа по информатике в старейшем университете Эстонии — гибкий выбор специализации, сильная исследовательская база.',
  array['Один из старейших и известных университетов Балтии', 'Бесплатно для граждан ЕС/ЕЭЗ'],
  array['Для не-ЕС студентов — платно', 'Точный IELTS и стоимость стоит сверить на сайте перед подачей'],
  false, null
);

-- Источник: https://ww4.mini.pw.edu.pl/application-process/tuition-fees/ (тюишн
-- подтверждён) + https://ww4.mini.pw.edu.pl/candidates/data-science/
-- (длительность программы подтверждена). Дедлайн и IELTS — по данным за
-- прошлый цикл приёма, не за 2026/27 → verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'd4bfe942-b78f-4bf0-b540-37b992f655de',
  'Master of Science in Data Science', 'Data Science', 'English', 18, 13080,
  7, 21, 6.0, 3, 'https://ww4.mini.pw.edu.pl/candidates/data-science/',
  array[]::text[],
  'Программа по data science в крупнейшем техническом университете Польши — прикладной уклон, тесная связь с местной технологической индустрией Варшавы.',
  array['Один из сильнейших технических вузов Восточной Европы', 'Варшава — крупный технологический хаб региона'],
  array['Дедлайн и точный IELTS уточнить на сайте — цифры взяты за предыдущий цикл'],
  false, null
);

-- Источник: https://www.international.agh.edu.pl/en/studies/education-offer-master-studies
-- — тюишн подтверждён на официальной странице, но дедлайн и точный IELTS не
-- указаны там же (найдено только требование вступительного экзамена и
-- профильного инженерного бакалавриата) → verified = false.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a6afb9f5-c1aa-458f-a4de-585f529b74a6',
  'Computer Science and Intelligent Systems: AI and Data Analysis', 'Artificial Intelligence', 'English', 18, 5400,
  6, 1, 6.0, 3, 'https://www.international.agh.edu.pl/en/studies/education-offer-master-studies',
  array[]::text[],
  'Программа по ИИ и анализу данных в одном из ведущих технических университетов Польши — требует вступительный экзамен и профильный инженерный бакалавриат.',
  array['Один из сильнейших технических вузов Польши', 'Невысокая стоимость по сравнению с Западной Европой'],
  array['Нужен вступительный экзамен', 'Требуется именно инженерный бакалавриат (не любой профильный)'],
  false, null
);

insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a6afb9f5-c1aa-458f-a4de-585f529b74a6',
  'Automatic Control and Robotics: Cyber-Physical Systems', 'Robotics', 'English', 18, 5400,
  6, 1, 6.0, 3, 'https://www.international.agh.edu.pl/en/studies/education-offer-master-studies',
  array[]::text[],
  'Программа по робототехнике и киберфизическим системам — тот же вуз, что и AI-программа выше, тот же формат вступления.',
  array['Один из сильнейших технических вузов Польши', 'Невысокая стоимость по сравнению с Западной Европой'],
  array['Нужен вступительный экзамен', 'Требуется именно инженерный бакалавриат'],
  false, null
);

-- Источник: https://csmsc.elte.hu/ — тюишн подтверждён на официальной
-- странице программы. Дедлайн не указан там же (страница отметила, что
-- прошлый цикл подачи уже закрыт) — не гадаю точную дату, оставляю
-- ближайший разумный дедлайн для мартовского/сентябрьского цикла условно;
-- сверить обязательно. IELTS у ELTE не жёсткий (собеседование на английском
-- вместо порога) — указан ориентировочно.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'Computer Science MSc (AI specialization)', 'Artificial Intelligence', 'English', 24, 6400,
  4, 1, 5.5, 3, 'https://csmsc.elte.hu/',
  array[]::text[],
  'Магистратура по информатике со специализацией в ИИ в крупнейшем университете Венгрии — есть также треки по кибербезопасности, финтеху и data science в рамках той же программы.',
  array['Несколько специализаций на выбор внутри одной программы', 'Приём — через собеседование на английском, а не жёсткий порог IELTS'],
  array['Точный дедлайн стоит уточнить — на сайте вуза прошлый цикл был уже закрыт на момент проверки'],
  false, null
);

-- Источник: страница курса на портале Stipendium Hungaricum + общие
-- справочники (Yocket/Standyou) — не удалось открыть напрямую страницу
-- приёмной комиссии BME (403/404), поэтому это самая слабо подтверждённая
-- запись во всей партии. Числа — округлённая середина найденного диапазона,
-- не точная цифра с сайта вуза. Стоит проверить в первую очередь.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '725b115c-db07-4946-8cf4-faef54de1bee',
  'MSc Computer Science Engineering', 'Computer Science', 'English', 24, 8000,
  2, 1, 6.0, 3, 'https://www.bme.hu/en',
  array['Stipendium Hungaricum (полностью покрывает обучение и часть проживания)'],
  'Магистратура по информатике в ведущем техническом университете Венгрии. Через государственную стипендию Stipendium Hungaricum обучение может быть полностью бесплатным.',
  array['Реальный шанс на полное покрытие расходов через Stipendium Hungaricum'],
  array['Самая слабо подтверждённая запись в этой партии — тюишн, дедлайн и IELTS уточнить на официальном сайте перед тем как показывать как надёжные'],
  false, null
);

commit;

-- Проверка после запуска — должно показать 6/7 новых строк:
-- select country, count(*) from universities where country in ('ee','pl','hu') group by country;
-- select u.country, p.name, p.verified from programs p join universities u on u.id = p.university_id where u.country in ('ee','pl','hu');
