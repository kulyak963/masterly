-- Германия, второй проход (MastersPortal-методика) — новые вузы,
-- отсутствовавшие в базе (по списку топ-11 вузов из задания).
-- Websites/QS-рейтинги (QS World University Rankings 2026, опубликовано
-- июнь 2025) проверены точечным WebSearch перед вставкой — тот же паттерн,
-- что и для 4 новых вузов Италии (2026-08-29, см. CLAUDE.md).
--
-- Остальные 7 из 11 вузов списка уже были в базе под этими именами —
-- переиспользуются существующие university_id, новых записей не создаём:
--   Technical University of Munich, RWTH Aachen University,
--   Karlsruhe Institute of Technology, Technical University of Berlin,
--   Ludwig Maximilian University of Munich, University of Mannheim,
--   WHU – Otto Beisheim School of Management
-- ВАЖНО: в базе уже ЕСТЬ дубли "Technical University of Munich" /
-- "Technische Universität München" и "University of Hamburg" /
-- "Universität Hamburg" от более раннего (агентского) прохода — не
-- трогаем их в этом заходе (задача явно просила не чистить старые 41
-- записи), но специально используем именно английские названия ниже,
-- чтобы не создать ТРЕТИЙ дубль.

insert into universities (id, name, country, city, website, ranking_qs) values
  ('c0485bc5-8f62-4053-b422-e802fa891721', 'Technical University of Darmstadt', 'de', 'Darmstadt', 'https://www.tu-darmstadt.de', 241),
  ('7c350fc6-f2ec-4f89-a6c8-0c87880d5ace', 'Humboldt University of Berlin', 'de', 'Berlin', 'https://www.hu-berlin.de', 130),
  ('f1ccd8be-aa13-414e-9da8-a90333f3bfb8', 'Technical University of Dresden', 'de', 'Dresden', 'https://tu-dresden.de', 234),
  ('f8024d82-0fdb-4796-bbcc-8f85b3d89938', 'Free University of Berlin', 'de', 'Berlin', 'https://www.fu-berlin.de', 88)
on conflict (id) do nothing;
