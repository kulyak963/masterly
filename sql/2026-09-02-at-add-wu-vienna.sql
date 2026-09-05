-- Подготовительный шаг перед scripts/research-programs.mjs --comprehensive
-- для Австрии (2026-09-02). WU Vienna (Wirtschaftsuniversität Wien) не
-- было в базе, а --comprehensive обрабатывает ТОЛЬКО вузы, уже существующие
-- в таблице universities для страны (--only-university фильтрует по уже
-- загруженному списку) — новые вузы через comprehensive-режим не создаются.
-- Поэтому вуз добавлен вручную здесь, отдельным шагом, перед прогоном.
--
-- Источник: официальный сайт https://www.wu.ac.at подтверждён напрямую
-- (WebSearch, 2026-09-02). Один из ведущих бизнес-вузов Европы (QS WUR by
-- Subject 2026: Business & Management Studies #69 из 650, лучший показатель
-- по этому предмету среди австрийских вузов). Чистый overall QS World
-- University Ranking номер (в отличие от TU Wien/Uni Vienna/TU Graz/JKU,
-- у которых он уже есть в базе) не нашёлся в открытых источниках как
-- официальная цифра — оставлено null, а не оценка наугад.
--
-- "Vienna University of Economics" из исходного списка Дениса — это то же
-- самое, что WU Vienna (Wirtschaftsuniversität Wien = Vienna University of
-- Economics and Business), отдельной записи не создаём.

insert into universities (id, name, country, city, website, ranking_qs) values
  ('2154a38a-39ef-49c9-9ee8-7792ade37f6e', 'WU Vienna (Wirtschaftsuniversität Wien)', 'at', 'Vienna', 'https://www.wu.ac.at', null)
on conflict (id) do nothing;
