// Убирает из pros/cons служебные оговорки исследовательской кухни ("не
// подтверждено", "требует проверки", "по данным сторонних источников" и
// т.п.) — они должны объяснять, почему verified=false, а не выглядеть как
// минус самой программы. По умолчанию dry-run, --apply для реальной записи.
import { readFileSync } from 'node:fs';
import { createClient } from '@supabase/supabase-js';
const envText = readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
const env = Object.fromEntries(envText.split('\n').filter((l) => l.includes('=')).map((l) => { const i = l.indexOf('='); return [l.slice(0, i), l.slice(i + 1)] }))
const db = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY);
const APPLY = process.argv.includes('--apply');

const LEAK = /не подтвержд|не удалось (найти|подтвердить)|не попал[аи] в выдачу|требует проверки|требует уточнени|в сниппете|по данным сторонних|сторонн(их|ими) источник|выдач[аеи] поиска|официальн(ая|ой) страниц[аеы].*(не|отсутств)|не публикует|не разделён|не разделен|не указан[оа]? (на|в) (официальн|стран)|не факт[, ]|уточнить у приёмной|не факт что|используем? единственн|использована единственная|деление eu\/non-eu|разделение (тариф|тюишн)|тюишн[а-я]* (не|явно не)|verified\s*=\s*false|с разных страниц|разных страниц официального/i;

const all = [];
for (let from = 0; ; from += 1000) {
  const { data } = await db.from('programs').select('id,name,pros,cons,summary').range(from, from + 999);
  if (!data?.length) break; all.push(...data); if (data.length < 1000) break;
}
console.log('всего программ:', all.length);

let changedPrograms = 0, removedCons = 0, removedPros = 0;
const updates = [];
for (const p of all) {
  const cons = p.cons ?? [];
  const pros = p.pros ?? [];
  const newCons = cons.filter(c => !LEAK.test(c));
  const newPros = pros.filter(c => !LEAK.test(c));
  if (newCons.length !== cons.length || newPros.length !== pros.length) {
    changedPrograms++;
    removedCons += cons.length - newCons.length;
    removedPros += pros.length - newPros.length;
    updates.push({ id: p.id, name: p.name, cons: newCons, pros: newPros, removedFromCons: cons.filter(c => LEAK.test(c)) });
  }
}
console.log(`программ с изменениями: ${changedPrograms}`);
console.log(`убрано записей из cons: ${removedCons}, из pros: ${removedPros}`);
console.log('\nПримеры удаляемого (первые 5):');
updates.slice(0, 5).forEach(u => {
  console.log(`\n• ${u.name}`);
  u.removedFromCons.forEach(c => console.log(`    - "${c.slice(0, 150)}"`));
});

if (!APPLY) {
  console.log('\nDRY RUN. Запусти с --apply для реальной записи.');
} else {
  console.log('\nЗаписываю...');
  let done = 0;
  for (const u of updates) {
    const { error } = await db.from('programs').update({ cons: u.cons, pros: u.pros }).eq('id', u.id);
    if (error) console.error('ОШИБКА', u.name, error.message);
    else done++;
  }
  console.log(`обновлено программ: ${done}/${updates.length}`);
}
