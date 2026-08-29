'use client'
import { useState } from 'react'
import { bg0, bg1, bg2, line, t1, t2, t3, gold, blue, red, grn, purp, sans, mono } from '@/lib/theme'

/**
 * Платная фича «Гайд: Stipendium Hungaricum» — появляется в NAV дашборда,
 * только если у пользователя в profile.countries есть 'hu' (см.
 * app/dashboard/page.tsx). В проекте пока нет платёжного процессора и флага
 * pro/free (см. CLAUDE.md, «Бизнес-модель») — поэтому весь платный контент
 * ниже свободного тизера показан заблюренным с кнопкой-заглушкой:
 * реальной оплаты не подключено, просто честное сообщение об этом.
 * Когда появится процессор — здесь нужно будет принять проп isPro и убрать
 * блюр для pro-пользователей.
 *
 * Фактура и источники — see docs/stipendium-hungaricum.md (полный
 * ресёрч, собран 2026-08-29 вручную через WebSearch/WebFetch).
 */

function Mono({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return <span style={{ fontFamily: mono, fontSize: 10, letterSpacing: '0.11em', color: t3, ...style }}>{children}</span>
}

function SectionTitle({ children }: { children: React.ReactNode }) {
  return (
    <div style={{ fontFamily: sans, fontSize: 16, fontWeight: 600, color: t1, marginBottom: 12, letterSpacing: '-.01em' }}>
      {children}
    </div>
  )
}

function Card({ children, style = {} }: { children: React.ReactNode; style?: React.CSSProperties }) {
  return (
    <div style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: 20, marginBottom: 16, ...style }}>
      {children}
    </div>
  )
}

const STAT_CHIPS = [
  { l: 'КВОТА ДЛЯ РОССИИ', v: '200', sub: 'мест / год' },
  { l: 'ПРОХОДНОЙ БАЛЛ', v: '56/100', sub: 'вступительный экзамен' },
  { l: 'СТИПЕНДИЯ', v: '43 700', sub: 'HUF / мес' },
  { l: 'ОБУЧЕНИЕ', v: '100%', sub: 'покрывается' },
]

const FINANCE_ROWS = [
  { l: 'Обучение', v: '100% — вуз получает оплату напрямую от Tempus, студент не платит' },
  { l: 'Стипендия (bachelor/master)', v: '43 700 HUF/мес' },
  { l: 'Стипендия (doctoral)', v: '140 000–163 000 HUF/мес, зависит от года обучения' },
  { l: 'Проживание', v: 'место в общежитии бесплатно, либо доплата ≈40 000 HUF/мес' },
  { l: 'Медстраховка', v: 'полная, на весь период обучения' },
]

const REQUIREMENTS = [
  { t: 'Возраст', d: '18+ на 31 августа года начала обучения. Верхнего предела нет на уровне самой программы, но Минобрнауки РФ как «отправляющая сторона» вправе устанавливать своё ограничение.' },
  { t: 'GPA', d: 'Фиксированного минимального балла аттестата/диплома нет — отбор идёт через вступительный экзамен вуза (минимум 56/100), а не порог среднего балла на входе.' },
  { t: 'Языковой сертификат', d: 'IELTS ≥ 6.0, TOEFL iBT 65–72, Cambridge B2 First, Duolingo ≥ 95 — точный порог зависит от конкретной программы.' },
  { t: 'Профильность диплома', d: 'Бакалавриат по смежному направлению + обычно не менее 30 ECTS релевантных профильных кредитов в предыдущем образовании.' },
  { t: 'Статус на момент подачи', d: 'Не в академическом отпуске. Спорный момент — см. «Частые ошибки» ниже.' },
]

const DOCS_TRACK_A = [
  { d: 'Диплом/аттестат с апостилем и переводом', where: 'апостиль — Минюст РФ или орган, выдавший документ; перевод — сертифицированный переводчик + нотариальное заверение' },
  { d: 'Транскрипт оценок', where: 'деканат / учебная часть вуза' },
  { d: 'Языковой сертификат', where: 'IELTS (British Council / IDP), TOEFL, Duolingo — сдавать заранее, результаты идут 2–5 дней' },
  { d: 'Мотивационное письмо и CV', where: 'пишется самостоятельно, формат Europass' },
  { d: 'Рекомендательные письма (обычно 2)', where: 'от преподавателей — запрашивать за 2+ месяца до дедлайна' },
  { d: 'Медицинская справка', where: 'по форме, публикуемой Tempus при открытии цикла — срок действия ограничен' },
  { d: 'Фото и копия загранпаспорта', where: 'паспортного формата, требования по пикселям — на портале DreamApply' },
]

const DOCS_TRACK_B = [
  { d: 'Отдельная форма заявления для Минобрнауки РФ', where: 'публикуется на сайте Минобрнауки при открытии цикла' },
  { d: 'Комплект документов, частично пересекающийся с треком А', where: 'отправляется на email mobility@ined.ru с темой «Stipendium Hungaricum program»' },
]

const TIMELINE = [
  { m: 'Ноябрь', t: 'Открытие конкурса на новый учебный цикл (call for applications)' },
  { m: 'До середины января', t: 'Дедлайн подачи в Tempus (DreamApply) — обычно 15 января' },
  { m: 'Параллельно', t: 'Дедлайн подачи пакета в Минобрнауки РФ — часто раньше дедлайна Tempus, уточнять в год подачи' },
  { m: 'Весна', t: 'Вступительные экзамены вузов для прошедших отбор Минобрнауки' },
  { m: 'Май–июнь', t: 'Результаты и предложения от вузов' },
  { m: 'Сентябрь', t: 'Начало учёбы' },
]

const MISTAKES = [
  'Подают документы только в Tempus, забыв параллельно отправить пакет в Минобрнауки РФ — без этого заявка не рассматривается вообще (два независимых трека, не один).',
  'Не уточняют актуальную трактовку Минобрнауки насчёт выпускного курса на конкретный год — правило спорное, официального единого ответа нет, письма Минобрнауки менялись год от года.',
  'Считают GPA решающим фактором и не готовятся ко вступительному экзамену — реального порога по среднему баллу нет, отбор идёт через экзамен (минимум 56/100).',
  'Не закладывают отдельный бюджет ≈50 000 ₽ на перевод, апостиль и нотариуса — это расходы сверх самой стипендии, часто становятся сюрпризом.',
  'Забывают об обязательном курсе венгерского языка — он идёт даже на англоязычных программах; не сдав его до 31 августа первого года, теряют 30 000 HUF/мес из стипендии.',
  'Не проверяют, участвует ли конкретная выбранная программа в Stipendium Hungaricum именно в текущем цикле — список ежегодно пересматривается, вуз в топе не гарантирует участие каждой его программы.',
  'Планируют работать полный день во время семестра — по правилам максимум 30 часов в неделю в учебный период (полный день — только вне семестра, до 90 дней в году).',
]

const STUDY_RULES = [
  'Минимум 18 кредитов/семестр в среднем (36 за два семестра) — при невыполнении стипендия прекращается немедленно.',
  'Обязательный курс венгерского языка — 2 семестра, сдать до 31 августа первого года, иначе минус 30 000 HUF/мес.',
  'Посещаемость — пропуски могут привести к полной потере стипендии на усмотрение вуза.',
  'Отлучки: до 10 рабочих дней — без согласования; 10–30 дней — нужно разрешение; 30+ дней — полная потеря стипендии и жилья.',
  'Смена программы/вуза/языка обучения — только один раз, только в первый год, только на границе семестров (дедлайны 1 декабря / 15 мая).',
  'Продление — максимум на 2 доп. семестра для bachelor/master.',
  'Неявка на программу — уведомить до 15 октября, иначе бан на подачу на 3 следующих цикла.',
]

const SOURCES = [
  { n: 'stipendiumhungaricum.hu', u: 'https://stipendiumhungaricum.hu/' },
  { n: 'stipendiumhungaricum.hu/apply', u: 'https://stipendiumhungaricum.hu/apply/' },
  { n: 'stipendiumhungaricum.hu/about', u: 'https://stipendiumhungaricum.hu/about/' },
  { n: 'utmn.ru — разбор процесса для РФ', u: 'https://www.utmn.ru/international/studentam/mobility/stipendii-dlya-obucheniya-za-rubezhom/1248825/' },
  { n: 't-j.ru — личный опыт и детали процесса', u: 'https://t-j.ru/study-in-budapest/' },
  { n: 'uniduna.hu — правила во время обучения', u: 'https://www.uniduna.hu/en/scholarships/stipendium-hungaricum/rules-to-keep-in-mind' },
]

export default function HungaryGuide({ programs = [] }: { programs?: any[] }) {
  const [unlockMsg, setUnlockMsg] = useState(false)
  const huPrograms = programs.filter(p => p.university?.country === 'hu')
  const shPrograms = huPrograms.filter(p => (p.scholarships || []).some((s: string) => s.includes('Stipendium')))

  return (
    <div style={{ padding: '36px 40px', maxWidth: 880 }}>
      {/* hero */}
      <div style={{ marginBottom: 24 }}>
        <Mono style={{ display: 'block', marginBottom: 10 }}>ГАЙД · ВЕНГРИЯ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Stipendium Hungaricum от А до Я
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          Полное пошаговое руководство по главной стипендии для учёбы в Венгрии: кто и как подаёт,
          какие документы нужны и где их получить, дедлайны, частые ошибки и правила во время учёбы.
          {shPrograms.length > 0 && <> В нашей базе сейчас {shPrograms.length} программ в Венгрии с этой стипендией.</>}
        </p>
      </div>

      {/* free stat chips */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4,1fr)', gap: 10, marginBottom: 24 }}>
        {STAT_CHIPS.map(c => (
          <div key={c.l} style={{ background: bg1, border: `1px solid ${line}`, borderRadius: 8, padding: '14px 12px' }}>
            <Mono style={{ display: 'block', marginBottom: 6 }}>{c.l}</Mono>
            <div style={{ fontFamily: sans, fontSize: 20, fontWeight: 700, color: t1, letterSpacing: '-.02em' }}>{c.v}</div>
            <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{c.sub}</div>
          </div>
        ))}
      </div>

      {/* free section — hook */}
      <Card>
        <SectionTitle>Что покрывает стипендия</SectionTitle>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
          {FINANCE_ROWS.map(r => (
            <div key={r.l} style={{ display: 'flex', gap: 14, paddingBottom: 10, borderBottom: `1px solid ${line}` }}>
              <div style={{ fontFamily: sans, fontSize: 12, color: t2, width: 190, flexShrink: 0 }}>{r.l}</div>
              <div style={{ fontFamily: sans, fontSize: 13, color: t1 }}>{r.v}</div>
            </div>
          ))}
        </div>
      </Card>

      {/* locked content */}
      <div style={{ position: 'relative' }}>
        <div style={{ filter: 'blur(5px)', userSelect: 'none', pointerEvents: 'none', maxHeight: 620, overflow: 'hidden' }}>
          <Card>
            <SectionTitle>Требования к кандидату</SectionTitle>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
              {REQUIREMENTS.map(r => (
                <div key={r.t}>
                  <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{r.t}</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{r.d}</div>
                </div>
              ))}
            </div>
          </Card>

          <Card>
            <SectionTitle>Два трека подачи — для России отдельно</SectionTitle>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16 }}>
              <div>
                <Mono style={{ display: 'block', marginBottom: 8, color: blue }}>ТРЕК А · TEMPUS</Mono>
                {DOCS_TRACK_A.map(d => (
                  <div key={d.d} style={{ marginBottom: 10 }}>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t1, marginBottom: 2 }}>{d.d}</div>
                    <div style={{ fontFamily: sans, fontSize: 11, color: t3, lineHeight: 1.4 }}>{d.where}</div>
                  </div>
                ))}
              </div>
              <div>
                <Mono style={{ display: 'block', marginBottom: 8, color: gold }}>ТРЕК Б · МИНОБРНАУКИ РФ</Mono>
                {DOCS_TRACK_B.map(d => (
                  <div key={d.d} style={{ marginBottom: 10 }}>
                    <div style={{ fontFamily: sans, fontSize: 12, color: t1, marginBottom: 2 }}>{d.d}</div>
                    <div style={{ fontFamily: sans, fontSize: 11, color: t3, lineHeight: 1.4 }}>{d.where}</div>
                  </div>
                ))}
              </div>
            </div>
          </Card>

          <Card>
            <SectionTitle>Таймлайн подачи</SectionTitle>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
              {TIMELINE.map((row, i) => (
                <div key={row.m} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < TIMELINE.length - 1 ? `1px solid ${line}` : 'none' }}>
                  <div style={{ fontFamily: mono, fontSize: 11, color: gold, width: 140, flexShrink: 0 }}>{row.m}</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2 }}>{row.t}</div>
                </div>
              ))}
            </div>
          </Card>

          <Card>
            <SectionTitle>Частые ошибки</SectionTitle>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {MISTAKES.map((m, i) => (
                <div key={i} style={{ display: 'flex', gap: 10 }}>
                  <div style={{ color: red, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>✕</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
                </div>
              ))}
            </div>
          </Card>

          <Card>
            <SectionTitle>Правила во время обучения</SectionTitle>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
              {STUDY_RULES.map((m, i) => (
                <div key={i} style={{ display: 'flex', gap: 10 }}>
                  <div style={{ color: grn, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>→</div>
                  <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
                </div>
              ))}
            </div>
          </Card>

          <Card>
            <SectionTitle>Работа во время учёбы</SectionTitle>
            <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>
              До 30 часов в неделю в учебный период; полный рабочий день — до 90 дней в году вне
              семестра. Нужен венгерский налоговый номер (adóazonosító jel), работодатель обязан
              зарегистрировать трудоустройство в NAV.
            </p>
          </Card>

          <Card style={{ marginBottom: 0 }}>
            <SectionTitle>Источники</SectionTitle>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 6 }}>
              {SOURCES.map(s => (
                <a key={s.u} href={s.u} target="_blank" rel="noopener noreferrer"
                  style={{ fontFamily: sans, fontSize: 12, color: blue, textDecoration: 'none' }}>
                  {s.n}
                </a>
              ))}
            </div>
          </Card>
        </div>

        {/* fade + lock */}
        <div style={{
          position: 'absolute', inset: 0, top: 40,
          background: `linear-gradient(180deg, transparent 0%, ${bg0} 70%)`,
          display: 'flex', alignItems: 'flex-end', justifyContent: 'center', paddingBottom: 20,
        }}>
          <div style={{
            background: bg2, border: `1px solid ${line}`, borderRadius: 10, padding: '24px 28px',
            textAlign: 'center', maxWidth: 380, boxShadow: '0 20px 48px rgba(0,0,0,.55)',
          }}>
            <div style={{ fontFamily: mono, fontSize: 20, marginBottom: 10 }}>🔒</div>
            <div style={{ fontFamily: sans, fontSize: 15, fontWeight: 600, color: t1, marginBottom: 6 }}>
              Полный гайд — платная фича
            </div>
            <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5, marginBottom: 16 }}>
              Требования, документы по обоим трекам, таймлайн, частые ошибки и правила во время
              учёбы — разово, без подписки.
            </p>
            <button onClick={() => setUnlockMsg(true)} style={{
              width: '100%', padding: '11px', borderRadius: 8, border: 'none',
              background: gold, color: bg0, fontFamily: sans, fontSize: 13, fontWeight: 600,
              cursor: 'pointer', letterSpacing: '-.01em', marginBottom: unlockMsg ? 10 : 0,
            }}>
              Разблокировать
            </button>
            {unlockMsg && (
              <p style={{ fontFamily: sans, fontSize: 11, color: t3, lineHeight: 1.5 }}>
                Оплата пока не подключена — эта часть продукта в разработке. Скоро можно будет
                разблокировать гайд разовым платежом.
              </p>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
