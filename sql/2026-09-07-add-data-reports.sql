-- Фаза 4, задача 4.3 (план после аудита продукта 2026-09-07).
-- "Здесь ошибка" на карточке программы — самый дешёвый источник
-- верификации: пользователь уже сходил на сайт вуза и заметил
-- расхождение, отчёт разбираем вручную.

create table if not exists data_reports (
  id uuid primary key default gen_random_uuid(),
  program_id uuid references programs(id) on delete set null,
  message text not null,
  reporter_email text,
  created_at timestamptz not null default now(),
  resolved boolean not null default false
);

create index if not exists data_reports_program_id_idx on data_reports(program_id);
create index if not exists data_reports_created_at_idx on data_reports(created_at desc);
