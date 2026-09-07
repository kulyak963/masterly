-- Журнал входящих вебхуков от Lava.top (оплата Mastersly PRO). Нужен не
-- для логики (is_pro включается сразу в profiles), а для поддержки —
-- когда покупатель напишет "заплатил, а доступа нет", можно посмотреть,
-- пришёл ли вебхук вообще, каким email он был помечен и нашёлся ли по
-- нему профиль, вместо гадания вслепую.
--
-- НЕ применено в Supabase — выполнить вручную через SQL Editor (тот же
-- паттерн, что у is_pro и quiz-колонок).

create table if not exists payment_events (
  id uuid primary key default gen_random_uuid(),
  provider text not null default 'lava_top',
  event_type text,
  contract_id text,
  buyer_email text,
  amount numeric,
  currency text,
  status text,
  matched_user_id uuid,
  raw_payload jsonb,
  created_at timestamptz not null default now()
);

create index if not exists payment_events_buyer_email_idx on payment_events (buyer_email);
create index if not exists payment_events_contract_id_idx on payment_events (contract_id);
