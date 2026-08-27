-- Вторая партия по Венгрии — на этот раз с реальной проверкой "из первых
-- рук": Денис сам учится в Corvinus University of Budapest (MSc Innovation
-- and Entrepreneurship) и подтвердил свою настоящую стоимость обучения.
--
-- Важный урок отсюда на будущее (актуально для всех следующих стран):
-- официальная страница программы показала tuition HUF 990,000/семестр
-- (≈€4 900–5 000/год по текущему курсу) — а по факту Денис как студент не
-- из ЕС платит €7 400/год. Разница — это классическая вилка "цена для
-- граждан ЕС / цена для не-ЕС", которая на многих сайтах вузов не
-- расписана явно на одной странице. Для всех новых стран нужно отдельно
-- проверять: это одна цена на всех, или есть более высокая ставка для
-- не-ЕС (наша аудитория — почти всегда не-ЕС).
--
-- Это же самое, скорее всего, происходит и с Pázmány Péter Catholic
-- University ниже (€3200/семестр с сайта, отдельно не проверено) —
-- реальная цена для не-ЕС может быть заметно выше. Помечено verified=false
-- именно поэтому, хотя сама цифра настоящая, не выдуманная.

begin;

-- ELTE уже мог быть добавлен первым SQL-файлом (2026-08-27) — эта строка
-- безопасна в любом порядке запуска благодаря on conflict.
insert into universities (id, name, country, city, website, ranking_qs) values
  ('6b80088f-1578-4aa9-a976-6dae07a23cfb', 'Eötvös Loránd University (ELTE)', 'hu', 'Budapest', 'https://www.elte.hu', null)
on conflict (id) do nothing;

insert into universities (id, name, country, city, website, ranking_qs) values
  ('a0917ff2-15d3-4d1d-87bd-e01624092c78', 'Corvinus University of Budapest', 'hu', 'Budapest', 'https://www.uni-corvinus.hu', null),
  ('20a61470-e445-428c-bf50-6480106a8b1c', 'Pázmány Péter Catholic University', 'hu', 'Budapest', 'https://itk.ppke.hu', null)
on conflict (id) do nothing;

-- Источник: подтверждено самим Денисом (студент программы) — реальная
-- стоимость для НЕ-ЕС студента, €7400/год. Официальная страница
-- (corvinus-university.dreamapply.com/courses/course/99) показывает
-- HUF 990,000/семестр — это, судя по всему, ставка для граждан ЕС/ЕЭЗ,
-- не наша целевая аудитория. IELTS с той же официальной страницы: жёсткого
-- порога нет — вместо этого вступительный письменный экзамен (тест на
-- английском, логику, анализ данных), поэтому ielts_min = null (это не
-- "не нашли", это реально "нет фиксированного порога"). Дедлайн 15 января —
-- не с этой конкретной страницы (там "not available for applying at the
-- moment"), а общий дедлайн цикла Stipendium Hungaricum 2026/27, который
-- нашёлся отдельно в поиске раньше — Corvinus в этой программе участвует,
-- но для самостоятельной (не по стипендии) подачи дедлайн может быть другим,
-- обычно более поздним — стоит уточнить.
-- Поле "Business Analytics" — ближайшее из имеющихся 8 категорий, не
-- идеальное совпадение (программа скорее про инновации/предпринимательство,
-- не аналитику как таковую) — стоит иметь в виду при показе пользователю.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  'a0917ff2-15d3-4d1d-87bd-e01624092c78',
  'MSc Innovation and Entrepreneurship', 'Business Analytics', 'English', 24, 7400,
  1, 15, null, 3,
  'https://corvinus-university.dreamapply.com/courses/course/99-msc-innovation-and-entrepreneurship',
  array[]::text[],
  'Магистратура по инновациям и предпринимательству в ведущем экономическом университете Венгрии. Приём — через письменный вступительный экзамен (языковые навыки, количественный анализ, логика), без формального порога IELTS. На второй год — выбор из четырёх специализаций.',
  array['Аккредитации AMBA/AACSB/MAB — топ-уровень для бизнес-школ', 'Нет жёсткого порога IELTS — экзамен сам оценивает уровень английского', 'Доступ к стартап-программам и сети финансирования университета'],
  array['Дедлайн 15 января — это общий срок цикла Stipendium Hungaricum, а не дедлайн именно этой программы (там сейчас "not available for applying at the moment") — для самостоятельной подачи без стипендии срок может быть другим', '«Business Analytics» — не точное совпадение с профилем программы, скорее общий бизнес/инновации'],
  true, current_date
);

-- Источник: официальная страница (apply.ppke.hu/courses/course/11) +
-- перекрёстный поиск (Mastersportal) сошлись на €3200/семестр — но, как и
-- с Corvinus выше, НЕ проверено, это цена для ЕС или для всех: после урока
-- с Corvinus (реальная не-ЕС цена оказалась в 1.5 раза выше официально
-- показанной) я больше не доверяю такой цифре без явного уточнения "для
-- не-ЕС". Дедлайн 15 января — общий срок Stipendium Hungaricum (программа
-- участвует в этой стипендии), не дедлайн конкретно этой программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '20a61470-e445-428c-bf50-6480106a8b1c',
  'MSc Computer Science Engineering', 'Computer Science', 'English', 24, 6400,
  1, 15, 6.0, 3,
  'https://apply.ppke.hu/courses/course/11-msc-computer-science-engineering',
  array[]::text[],
  'Магистратура по информатике и инженерии в католическом университете Будапешта — акцент на биоинженерию и информационные технологии на стыке дисциплин.',
  array['Сильная связка Computer Science + Bionics — не типичное сочетание для региона'],
  array['Стоимость (€3200/семестр) не проверена на предмет тарифа для не-ЕС студентов — по опыту с Corvinus, реальная цена может быть заметно выше', 'Дедлайн — общий срок Stipendium Hungaricum, не дедлайн конкретно этой программы для самостоятельной подачи'],
  false, null
);

-- Источник: https://apply.stipendiumhungaricum.hu/courses/course/4089-msc-data-science
-- — отдельная, более узкая специализация ELTE (тот же вуз, что уже мог
-- быть добавлен первым файлом с общей "Computer Science MSc (AI
-- specialization)"). Тюишн взят с общей страницы csmsc.elte.hu, не с этой
-- конкретной — не проверено, совпадает ли цена именно для этого трека, и
-- не проверено ЕС/не-ЕС различие (см. урок с Corvinus). Дедлайн 15 января —
-- общий срок Stipendium Hungaricum, не дедлайн конкретно этой программы.
insert into programs (
  university_id, name, field, language, duration_months, tuition_eur,
  deadline_month, deadline_day, ielts_min, gpa_min, url, scholarships,
  summary, pros, cons, verified, verified_at
) values (
  '6b80088f-1578-4aa9-a976-6dae07a23cfb',
  'MSc Data Science', 'Data Science', 'English', 24, 6400,
  1, 15, null, 3,
  'https://apply.stipendiumhungaricum.hu/courses/course/4089-msc-data-science',
  array[]::text[],
  'Отдельная программа по data science в ELTE (Будапешт) — для тех, у кого уже есть бакалавриат по информатике, электротехнике или математике (от 60 ECTS профильных предметов). Языковое требование — B2, без формального порога IELTS.',
  array['Требует не общий бакалавриат, а именно профильный по информатике/математике — выше качество набора студентов'],
  array['Тюишн взят с другой страницы того же вуза, не с этой конкретной программы, и не проверен на ЕС/не-ЕС различие', 'Дедлайн — общий срок Stipendium Hungaricum, не дедлайн конкретно этой программы'],
  false, null
);

commit;

-- Проверка: select p.name, u.name as university, p.tuition_eur, p.verified
-- from programs p join universities u on u.id = p.university_id
-- where u.country = 'hu';
