-- Новая колонка для реальных отзывов студентов (не путать с pros/cons —
-- те собираются из официальных источников вместе с остальными фактами о
-- программе; student_sentiment — отдельно, что говорят сами студенты на
-- форумах/агрегаторах отзывов, честно помечено null если ничего
-- существенного не нашлось, без выдумывания).
--
-- Собирается инструментом scripts/research-reviews.mjs, который должен
-- быть запущен ПОСЛЕ этой миграции (ссылается на эти три колонки).

alter table programs
  add column if not exists student_sentiment text,
  add column if not exists student_sentiment_sources text[],
  add column if not exists student_sentiment_updated_at timestamptz;
