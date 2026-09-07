-- Фаза 0, задача 0.2 (см. аудит продукта 2026-09-07 и план исправлений).
--
-- Корневая причина: scripts/research-programs.mjs писал
-- `tuition_eur: p.tuition_eur ?? 0` — "не найдено" тихо становилось
-- "бесплатно". Из-за этого ~96 программ показывали "Бесплатно", включая
-- страны, где не-ЕС студенты платят (Швеция, Дания, Норвегия, Австрия,
-- часть Германии). Тот же баг был и с gpa_min (`?? 3`).
--
-- Это исправлено в генераторе (0.1). Эта миграция даёт схеме способ
-- отличить "подтверждено", "оценка ИИ" и "неизвестно" — раньше всё это
-- было одним и тем же числом. Дальше 0.3 переберёт существующие записи
-- и снимет недоказанные нули, 0.4 научит интерфейс не путать null с 0.

-- tuition_eur больше не обязателен — "неизвестно" это NULL, а не 0.
alter table programs alter column tuition_eur drop not null;
alter table programs alter column tuition_eur drop default;

alter table programs add column if not exists tuition_status text
  not null default 'ai'
  check (tuition_status in ('verified','ai','unknown'));

alter table programs add column if not exists tuition_note text;
alter table programs add column if not exists tuition_checked_at timestamptz;

-- Здоровье ссылки на программу (см. задачу 0.6 — регулярная проверка).
alter table programs add column if not exists url_status int;
alter table programs add column if not exists url_checked_at timestamptz;

-- Для задачи 1.4 — скрывать MBA/Executive-программы от студентов без
-- опыта работы. Отдельная миграция не нужна, колонка дешёвая.
alter table programs add column if not exists requires_work_years int;

-- verified=true уже означало "тюишн+дедлайн+язык подтверждены на одной
-- официальной странице для не-ЕС студентов" — переносим это в
-- tuition_status для уже существующих записей.
update programs
  set tuition_status = 'verified', tuition_checked_at = verified_at
  where verified = true;
