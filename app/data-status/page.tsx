import Link from 'next/link'
import { supabase } from '../../lib/supabase'
import { bg0, bg1, line, t1, t2, t3, gold, grn, red, sans, mono } from '@/lib/theme'
import { displayFont } from '@/lib/fonts'

// Публичная страница статуса данных (задача 4.1, план после аудита
// продукта 2026-09-07). Раньше "90% собрано ИИ, не проверено человеком"
// было слабостью, которую продукт не показывал сам — теперь показываем
// честно и на видном месте: это превращает "мы не всё проверили" в
// "мы прозрачны о том, что проверено и когда", а не в скрытую слабость,
// которую находит студент методом проб и ошибок.

export const revalidate = 3600

function StatCard({ label, value, sub, color = t1 }: { label: string; value: string; sub?: string; color?: string }) {
  return (
    <div style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: '18px 20px' }}>
      <div style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.1em', color: t3, marginBottom: 8 }}>{label}</div>
      <div style={{ fontFamily: displayFont.style.fontFamily, fontSize: 28, fontWeight: 800, color, letterSpacing: '-.02em' }}>{value}</div>
      {sub && <div style={{ fontFamily: sans, fontSize: 11, color: t3, marginTop: 4 }}>{sub}</div>}
    </div>
  )
}

function Bar({ pct, color }: { pct: number; color: string }) {
  return (
    <div style={{ height: 6, background: 'rgba(255,255,255,.06)', borderRadius: 3, overflow: 'hidden' }}>
      <div style={{ height: '100%', width: `${Math.min(100, Math.max(0, pct))}%`, background: color, borderRadius: 3 }} />
    </div>
  )
}

export default async function DataStatusPage() {
  const { count: total } = await supabase.from('programs').select('id', { count: 'exact', head: true })
  const { count: verifiedCount } = await supabase.from('programs').select('id', { count: 'exact', head: true }).eq('verified', true)
  const { count: tuitionVerified } = await supabase.from('programs').select('id', { count: 'exact', head: true }).eq('tuition_status', 'verified')
  const { count: tuitionUnknown } = await supabase.from('programs').select('id', { count: 'exact', head: true }).eq('tuition_status', 'unknown')
  const { count: urlChecked } = await supabase.from('programs').select('id', { count: 'exact', head: true }).not('url_status', 'is', null)
  const { count: urlAlive } = await supabase.from('programs').select('id', { count: 'exact', head: true }).gte('url_status', 200).lt('url_status', 400)
  const { count: universities } = await supabase.from('universities').select('id', { count: 'exact', head: true })
  const { data: countryRows } = await supabase.from('universities').select('country')
  const countries = new Set((countryRows ?? []).map((r: any) => r.country)).size
  const { data: latestCheck } = await supabase.from('programs').select('url_checked_at').not('url_checked_at', 'is', null).order('url_checked_at', { ascending: false }).limit(1).maybeSingle()

  const n = total ?? 0
  const pct = (x: number | null) => n ? Math.round(((x ?? 0) / n) * 100) : 0
  const lastChecked = latestCheck?.url_checked_at ? new Date(latestCheck.url_checked_at).toLocaleDateString('ru-RU', { day: 'numeric', month: 'long', year: 'numeric' }).replace(/\.$/, '') : '—'

  return (
    <div style={{ minHeight: '100vh', background: bg0, fontFamily: sans, color: t1, padding: '0 20px 80px' }}>
      <div style={{ maxWidth: 720, margin: '0 auto', paddingTop: 48 }}>
        <Link href="/" style={{ fontFamily: sans, fontWeight: 700, fontSize: 18, color: t1, textDecoration: 'none' }}>← Mastersly</Link>

        <div style={{ marginTop: 32, marginBottom: 32 }}>
          <div style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.12em', color: gold, marginBottom: 10 }}>СТАТУС ДАННЫХ</div>
          <h1 style={{ fontFamily: displayFont.style.fontFamily, fontWeight: 800, fontSize: 32, color: t1, letterSpacing: '-.02em', marginBottom: 12 }}>
            Что проверено, а что нет
          </h1>
          <p style={{ fontFamily: sans, fontSize: 14, color: t2, lineHeight: 1.7, maxWidth: 600 }}>
            Часть базы собрана и проверена вручную против официальных сайтов вузов, часть — собрана ИИ через
            веб-поиск, но не перепроверена человеком. Мы помечаем это на каждой карточке программы (⚠ Оценка ИИ /
            ✓ Проверено) — здесь то же самое, но в цифрах по всей базе, обновляется автоматически.
          </p>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2,1fr)', gap: 12, marginBottom: 32 }}>
          <StatCard label="ПРОГРАММ В БАЗЕ" value={String(n)} sub={`${universities ?? 0} вузов, ${countries} стран`} />
          <StatCard label="ПРОВЕРЕНО ЧЕЛОВЕКОМ" value={`${pct(verifiedCount)}%`} sub={`${verifiedCount ?? 0} из ${n} программ`} color={pct(verifiedCount) >= 50 ? grn : gold} />
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 20, marginBottom: 32 }}>
          <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
              <span style={{ fontFamily: sans, fontSize: 13, color: t1, fontWeight: 500 }}>Стоимость подтверждена официальным источником</span>
              <span style={{ fontFamily: mono, fontSize: 12, color: t2 }}>{pct(tuitionVerified)}%</span>
            </div>
            <Bar pct={pct(tuitionVerified)} color={grn} />
            <div style={{ fontFamily: sans, fontSize: 11, color: t3, marginTop: 4 }}>
              {tuitionUnknown ?? 0} программ честно помечены "стоимость уточняется" — там, где цена не найдена, мы не показываем цифру наугад.
            </div>
          </div>
          <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 6 }}>
              <span style={{ fontFamily: sans, fontSize: 13, color: t1, fontWeight: 500 }}>Ссылки на программы проверены и живы</span>
              <span style={{ fontFamily: mono, fontSize: 12, color: t2 }}>{urlChecked ? `${pct(urlAlive)}% из ${pct(urlChecked)}% проверенных` : '—'}</span>
            </div>
            <Bar pct={urlChecked ? Math.round(((urlAlive ?? 0) / urlChecked) * 100) : 0} color={blue_ok(pct(urlAlive))} />
            <div style={{ fontFamily: sans, fontSize: 11, color: t3, marginTop: 4 }}>
              Последняя проверка ссылок: {lastChecked}. Битые ссылки не скрываются — на карточке программы вместо
              них честное предупреждение и переход на сайт вуза напрямую.
            </div>
          </div>
        </div>

        <div style={{ padding: '16px 18px', borderRadius: 8, background: `${gold}0D`, border: `1px solid ${gold}30` }}>
          <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 6 }}>Нашёл ошибку?</div>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>
            Кнопка "здесь ошибка" на карточке каждой программы — самый быстрый способ для нас узнать, что
            цифра устарела. Каждый отчёт мы разбираем вручную.
          </p>
        </div>
      </div>
    </div>
  )
}

function blue_ok(pct: number) {
  return pct >= 85 ? grn : pct >= 60 ? gold : red
}
