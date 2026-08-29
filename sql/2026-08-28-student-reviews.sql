-- Автоматически собрано инструментом scripts/research-reviews.mjs
-- Дата: 2026-08-28, модель: claude-sonnet-5
--
-- Отзывы реальных студентов (Reddit/форумы + сайты-агрегаторы), НЕ
-- официальные факты с сайта вуза. student_sentiment=null означает, что
-- по этой конкретной программе не нашлось ничего существенного — это
-- честный результат, не ошибка сбора.
--
-- Требует, чтобы миграция sql/2026-08-28-add-student-sentiment-column.sql
-- уже была применена. НЕ запущено в Supabase — выполнить вручную.

begin;

-- Ничего существенного не найдено — student_sentiment оставлен null, а не выдуман.
update programs set
  student_sentiment = null,
  student_sentiment_sources = array[]::text[],
  student_sentiment_updated_at = current_date
where id = '5378653f-50f2-437d-90ce-95a328083a99';

commit;
