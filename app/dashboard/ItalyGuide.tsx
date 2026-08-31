'use client'
import { bg1, line, t1, t2, t3, gold, blue, red, grn, purp, sans, mono } from '@/lib/theme'
import ScholarshipLock from './ScholarshipLock'

/**
 * Платная фича «Гайд: стипендии и льготы в Италии» — появляется во вкладке
 * «Стипендии · PRO», если у пользователя в profile.countries есть 'it'.
 * Общий замок/блюр — в ScholarshipLock.tsx, общий с HungaryGuide.tsx.
 *
 * Написано максимально подробно, разжёвывая каждый термин (ISEE, CAF,
 * No-Tax Area и т.д.) — по просьбе Дениса, 2026-08-31. В отличие от
 * Венгрии, в Италии поступление в вуз и заявка на льготы/стипендию — два
 * ПОЛНОСТЬЮ отдельных процесса (обычные документы для поступления —
 * диплом/IELTS/CV — уже покрыты в общем плане Mastersly, не дублируются
 * здесь). Этот гайд — только про деньги: как получить скидку/стипендию
 * через итальянскую систему ISEE и региональные DSU-агентства.
 *
 * Фактура и источники — see docs/italy-scholarships.md (полный ресёрч,
 * собран 2026-08-31 вручную через WebSearch/WebFetch).
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

interface DocStep { name: string; what: string; where: string; next?: string; cost?: string }

function DocCard({ step, n }: { step: DocStep; n: number }) {
  return (
    <div style={{ display: 'flex', gap: 12, marginBottom: 18, paddingBottom: 18, borderBottom: `1px solid ${line}` }}>
      <div style={{
        width: 24, height: 24, borderRadius: '50%', background: `${gold}18`, border: `1px solid ${gold}40`,
        color: gold, fontFamily: mono, fontSize: 11, flexShrink: 0, display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>{n}</div>
      <div>
        <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 5 }}>{step.name}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 6 }}>{step.what}</div>
        <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.next ? 4 : 0 }}>
          <span style={{ color: blue, fontWeight: 600 }}>Где получить: </span>{step.where}
        </div>
        {step.next && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: step.cost ? 4 : 0 }}>
            <span style={{ color: gold, fontWeight: 600 }}>Что дальше: </span>{step.next}
          </div>
        )}
        {step.cost && (
          <div style={{ fontFamily: sans, fontSize: 12, color: t3, lineHeight: 1.6 }}>
            <span style={{ color: grn, fontWeight: 600 }}>Сколько ждать: </span>{step.cost}
          </div>
        )}
      </div>
    </div>
  )
}

const STAT_CHIPS = [
  { l: 'NO-TAX AREA', v: '€22 000', sub: 'ISEE и ниже = обучение бесплатно' },
  { l: 'MAECI', v: '€10 800', sub: 'госстипендия, 9 месяцев' },
  { l: 'DSU ПОРОГ', v: '€25–28к', sub: 'ISEE, зависит от региона' },
  { l: 'РЕГИОНОВ', v: '8', sub: 'у наших вузов — своё агентство' },
]

const LEVELS = [
  { l: '1. Национальный уровень', v: 'Государственные программы Италии — не привязаны к вузу или региону. Главные: MAECI (стипендия МИД Италии) и Invest Your Talent (только для избранных стран — Россия не входит).' },
  { l: '2. Региональный уровень — DSU', v: 'Diritto allo Studio Universitario — «право на образование». Это не стипендия одного вуза, а система соцподдержки по месту учёбы: стипендия + общежитие + питание + освобождение от налога, на основе дохода семьи (ISEE).' },
  { l: '3. Университетский уровень', v: '«No-Tax Area» — обязательное по закону освобождение от платы за обучение при низком ISEE (у каждого вуза свой порог, не ниже национального минимума), плюс собственные программы конкретных вузов.' },
]

// Документы именно для ISEE Parificato — не обычные документы для
// поступления (диплом/IELTS/CV — это отдельный процесс, уже покрыт в
// общем плане Mastersly). Максимально подробно, по просьбе Дениса.
const ISEE_DOCS: DocStep[] = [
  {
    name: '1. Справки о доходах каждого работающего члена семьи',
    what: 'ISEE считается по доходу ВСЕЙ семьи, а не только студента — итальянская система смотрит, сколько семья реально может заплатить. Нужна справка о доходах за родителей (и любых других членов семьи, кто живёт вместе и имеет доход).',
    where: 'справка 2-НДФЛ — в бухгалтерии по месту работы, либо через личный кабинет на сайте nalog.ru («Мои налоги» → справки о доходах) или на Госуслугах.',
    next: 'все справки нужно перевести на итальянский (см. пункт 5) — обычный перевод на английский тут не подойдёт, Италия требует именно итальянский язык для этих документов.',
  },
  {
    name: '2. Выписки по банковским счетам и вкладам',
    what: 'ISEE учитывает не только доход, но и накопления (имущество) семьи — 20% от суммы вкладов и счетов идёт в формулу расчёта (см. раздел «Что такое ISEE» ниже).',
    where: 'в приложении своего банка (обычно есть готовая справка «выписка об остатке на счёте») или в отделении банка лично.',
    next: 'нужна выписка на актуальную дату (обычно на 31 декабря прошлого года — это стандартная дата отсчёта для ISEE) по каждому счёту каждого члена семьи.',
  },
  {
    name: '3. Документы о недвижимости, если она есть в собственности семьи',
    what: 'Если у семьи есть квартира, дом или другая недвижимость — её оценочная стоимость тоже частично учитывается в ISEE (тоже 20% от стоимости, вместе с банковскими накоплениями).',
    where: 'выписка из ЕГРН (Единый государственный реестр недвижимости) — заказывается через Госуслуги или сайт Росреестра, приходит обычно за несколько дней.',
    next: 'если недвижимости нет — этот пункт просто пропускается, доход и вклады считаются без него.',
  },
  {
    name: '4. Справка о составе семьи',
    what: 'Документ, подтверждающий, кто именно входит в семью студента и сколько человек живёт вместе — это напрямую влияет на итоговую формулу (чем больше семья, тем ниже итоговый ISEE при том же доходе, см. таблицу коэффициентов ниже).',
    where: 'в паспортном столе по месту жительства, через МВД, либо запросить через Госуслуги.',
  },
  {
    name: '5. Перевод и легализация всех этих документов',
    what: 'Это самый важный и самый неочевидный шаг. Просто перевести справки самому недостаточно — по правилам Италии, документы, выданные за рубежом, должны быть переведены на итальянский язык через официальные итальянские дипломатические органы (то есть в идеале — заверены итальянским консульством), а не просто любым переводчиком с нотариусом, как для диплома в других странах.',
    where: 'узнавать точный порядок нужно у конкретного вуза/CAF (см. пункт 6) — некоторые принимают перевод через аккредитованное бюро переводов + консульскую легализацию, другие требуют именно консульский перевод. Это единственный шаг, где стоит написать напрямую в международный офис вуза и спросить актуальные правила именно для российских документов.',
    cost: 'самый долгий шаг во всём процессе — закладывай минимум 1–2 месяца на сбор, перевод и легализацию, лучше начинать за 3 месяца до дедлайна DSU (см. таймлайн ниже).',
  },
  {
    name: '6. Обращение в CAF (аккредитованный именно твоим вузом)',
    what: 'CAF (Centro di Assistenza Fiscale) — это итальянский налоговый консультационный центр. Важно: сам ISEE Parificato студент посчитать не может — это делает только CAF, официально аккредитованный конкретным вузом (у каждого вуза свой список, единого «одного окна» на всю Италию нет). Именно CAF берёт все документы, которые ты собрал(а) выше, считает итоговую цифру ISEE и сам отправляет готовый документ в вуз/DSU-агентство — тебе не нужно ничего отправлять самостоятельно на этом шаге.',
    where: 'список аккредитованных CAF конкретного вуза — на его официальном сайте, обычно в разделе «tasse e contributi» (налоги и взносы) или «international students» → «ISEE».',
    next: 'после того как CAF всё посчитал — жди подтверждение (обычно приходит на почту), и уже с готовым ISEE Parificato подавайся на DSU-стипендию своего региона (см. таблицу ниже).',
  },
]

const NO_TAX_AREA = [
  { u: 'Politecnico di Milano', v: '€22 000', note: 'порог не повышен, дальше скидка 10–80% до €30 000' },
  { u: 'Sapienza (Рим)', v: '≈€24 000', note: 'ступени скидок: 80% до €24к, 50% до €26к, 25% до €28к' },
  { u: 'University of Bologna', v: '€26 000–27 948', note: 'один из самых высоких порогов среди наших вузов' },
]

const DSU_TABLE = [
  { region: 'Lombardia', unis: 'Politecnico di Milano, Bocconi, University of Milan', agency: 'нет единого агентства — конкурс проводит каждый вуз сам', isee: '€26 517 (Polimi)', amount: '—' },
  { region: 'Lazio', unis: 'Sapienza', agency: 'LazioDiSCo', isee: '€27 949', amount: 'до €7 557/год' },
  { region: 'Emilia-Romagna', unis: 'University of Bologna', agency: 'ER.GO', isee: '€25 000', amount: '—' },
  { region: 'Trentino', unis: 'University of Trento', agency: 'Opera Universitaria di Trento', isee: '€26 000', amount: 'до €7 072/год' },
  { region: 'Liguria', unis: 'University of Genoa', agency: 'ALiSEO', isee: '€28 339', amount: 'до €7 172/год' },
  { region: 'Piemonte', unis: 'Politecnico di Torino', agency: 'EDISU Piemonte', isee: '€26 306', amount: '—' },
  { region: 'Toscana', unis: 'University of Florence, Sant’Anna', agency: 'DSU Toscana', isee: '€27 000', amount: '—' },
  { region: 'Veneto', unis: 'University of Padua', agency: 'ESU di Padova', isee: '€26 306', amount: '—' },
]

const TIMELINE = [
  { m: 'За 3 месяца до дедлайна', t: 'Начать собирать справки о доходах семьи и запустить перевод/легализацию — это самый долгий шаг' },
  { m: 'Июль–август', t: 'Открывается приём заявок на DSU в большинстве регионов' },
  { m: 'Август–сентябрь', t: 'Дедлайн подачи заявки на DSU (точная дата различается по региону — см. таблицу выше)' },
  { m: '26 марта (ежегодно)', t: 'Дедлайн подачи на MAECI — стипендию Правительства Италии (дата 2026/27 цикла, из года в год может немного сдвигаться)' },
  { m: 'Октябрь–ноябрь', t: 'Дедлайн оформления ISEE Parificato через CAF в некоторых вузах (уточнять у своего)' },
]

const NATIONAL = [
  {
    title: 'MAECI — стипендия Правительства Италии',
    color: grn,
    body: 'Администрирует Министерство иностранных дел Италии, подача через портал studyinitaly.esteri.it. Сумма — €10 800, тремя траншами за 9 месяцев. Дедлайн подачи обычно конец марта.',
    note: '✓ Россия подтверждена в списке стран — дважды перепроверено, включая прямую страницу посольства Италии в Москве, которая явно приглашает российских студентов подавать заявки.',
    noteColor: grn,
  },
  {
    title: 'Invest Your Talent in Italy',
    color: red,
    body: 'Совместная программа МИД Италии и итальянского бизнеса — 250 магистерских программ по инженерии, IT, менеджменту в конкретном списке вузов (включая Politecnico di Milano, Politecnico di Torino, Florence, Padua, Trento, Genoa из нашей базы).',
    note: '✕ Россия НЕ входит в список стран-участниц. Программа целенаправленно ориентирована на другой список (Индия, Китай, Бразилия, Турция, Казахстан и другие) — эту стипендию не стоит рассматривать при подаче из России.',
    noteColor: red,
  },
]

const UNI_SPECIAL = [
  { u: 'Sant’Anna (Пиза)', v: 'Программа «Allievi» — после конкурсного экзамена лучшие студенты получают полностью бесплатное обучение + проживание + питание + гранты на исследования, для России наравне со всеми остальными странами. Одна из двух школ в Европе с такой моделью.' },
  { u: 'Bocconi', v: 'ISU Bocconi Scholarship — need-based (по нуждаемости, не по оценкам), финансируется регионом Ломбардия. Полное освобождение от платы + €1 000–4 000/год + одно бесплатное питание в день. Подавать каждый год заново, окно подачи — конец мая — конец июня.' },
  { u: 'Politecnico di Torino', v: 'Плата для не-ЕС студентов считается не по итальянскому ISEE, а по ВВП по паритету покупательной способности страны происхождения — чем ниже показатель страны, тем ниже фиксированная плата.' },
]

const CAVEATS = [
  'Пороги ISEE и суммы стипендий обновляются каждый год — цифры в этом гайде для цикла 2026/27, для следующего года их нужно перепроверить заново.',
  'No-Tax Area пороги собраны только для 3 из 11 вузов (Politecnico di Milano, Sapienza, Bologna) — для остальных нужно уточнять на сайте конкретного вуза.',
  'Точная сумма DSU-стипендии известна не для всех 8 регионов — где указан прочерк, нужно уточнять у регионального агентства напрямую.',
  'Списки стран для MAECI и Invest Your Talent могут меняться год от года — перепроверять на studyinitaly.esteri.it непосредственно перед подачей.',
]

const SOURCES = [
  { n: 'studyinitaly.esteri.it — MAECI', u: 'https://studyinitaly.esteri.it/' },
  { n: 'investyourtalentapplication.esteri.it', u: 'https://investyourtalentapplication.esteri.it/SitoIYT/EN/invest-your-talent-in-italy' },
  { n: 'laziodisco.it — DSU Lazio', u: 'https://laziodisco.it/' },
  { n: 'er-go.it — DSU Emilia-Romagna', u: 'https://www.er-go.it/' },
  { n: 'unige.it — ISEE Parificato', u: 'https://unige.it/en/tasse-e-benefici/isee/parificato' },
  { n: 'polimi.it — No-Tax Area', u: 'https://www.polimi.it/en/students/tuition-fees-scholarships-and-financial-aid/tuition-fees/no-tax-area' },
]

export default function ItalyGuide({ programs = [], isPro = false }: { programs?: any[]; isPro?: boolean }) {
  const itPrograms = programs.filter(p => p.university?.country === 'it')

  return (
    <div style={{ maxWidth: 880 }}>
      <div style={{ marginBottom: 24 }}>
        <Mono style={{ display: 'block', marginBottom: 10 }}>ГАЙД · ИТАЛИЯ</Mono>
        <div style={{ fontFamily: sans, fontSize: 26, fontWeight: 700, color: t1, letterSpacing: '-.02em', marginBottom: 8 }}>
          Стипендии и льготы в Италии от А до Я
        </div>
        <p style={{ fontFamily: sans, fontSize: 13, color: t2, lineHeight: 1.6, maxWidth: 620 }}>
          В Италии нет одной «стипендии для всех» — есть три независимых системы (страна, регион,
          вуз), которые можно и нужно комбинировать. Полный разбор: что такое ISEE и как его
          получить, где какое региональное агентство, какие программы реально доступны из России.
          {itPrograms.length > 0 && <> В нашей базе сейчас {itPrograms.length} программ в Италии.</>}
        </p>
      </div>

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
        <SectionTitle>Три уровня льгот — и как они складываются</SectionTitle>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          {LEVELS.map(l => (
            <div key={l.l}>
              <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 3 }}>{l.l}</div>
              <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{l.v}</div>
            </div>
          ))}
        </div>
      </Card>

      <ScholarshipLock isPro={isPro}>
        <Card>
          <SectionTitle>Что такое ISEE — ключ ко всей системе</SectionTitle>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 12 }}>
            <b style={{ color: t1 }}>ISEE</b> (Indicatore della Situazione Economica Equivalente) —
            официальный итальянский показатель благосостояния семьи. Почти все льготы и стипендии в
            Италии рассчитываются именно от него — чем он ниже, тем больше скидок и выплат.
          </p>
          <div style={{ background: `${gold}0D`, border: `1px solid ${gold}30`, borderRadius: 6, padding: 14, marginBottom: 12, fontFamily: mono, fontSize: 12, color: t1, textAlign: 'center' }}>
            ISEE = [ Доход семьи + 20% × Имущество ] / Коэффициент по составу семьи
          </div>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 8 }}>
            Коэффициент растёт с числом членов семьи (значит, при том же доходе итоговый ISEE у
            большой семьи ниже, чем у маленькой):
          </p>
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', marginBottom: 12 }}>
            {[['1 человек', '1,00'], ['2', '1,57'], ['3', '2,04'], ['4', '2,46'], ['5', '2,85']].map(([n, v]) => (
              <div key={n} style={{ padding: '6px 10px', borderRadius: 6, border: `1px solid ${line}`, fontFamily: mono, fontSize: 11 }}>
                <span style={{ color: t3 }}>{n}: </span><span style={{ color: t1 }}>{v}</span>
              </div>
            ))}
          </div>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>
            Если семья студента живёт и получает доход <b style={{ color: t1 }}>не в Италии</b> (обычный
            случай для России) — обычный ISEE оформить нельзя. Вместо него нужна специальная версия —{' '}
            <b style={{ color: t1 }}>ISEE Parificato</b> («приравненный ISEE») — считается по той же
            формуле, но доходы и имущество за рубежом пересчитываются в евро.
          </p>
        </Card>

        <Card>
          <SectionTitle>Документы для ISEE Parificato — что нужно и где получить</SectionTitle>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 18 }}>
            Это отдельные документы от тех, что нужны для самого поступления (диплом, IELTS, CV —
            это уже покрыто в общем плане поступления) — здесь речь только про документы,
            подтверждающие доход и имущество семьи, нужные для расчёта скидки/стипендии.
          </p>
          {ISEE_DOCS.map((d, i) => <DocCard key={d.name} step={d} n={i + 1} />)}
        </Card>

        <Card>
          <SectionTitle>No-Tax Area — освобождение от платы за обучение</SectionTitle>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 14 }}>
            По итальянскому закону вузы ОБЯЗАНЫ полностью освобождать от платы за обучение студентов
            с ISEE ниже национального минимума (€22 000 на 2026/27). Каждый вуз вправе поднять свой
            порог выше — многие так и делают:
          </p>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
            {NO_TAX_AREA.map((r, i) => (
              <div key={r.u} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < NO_TAX_AREA.length - 1 ? `1px solid ${line}` : 'none' }}>
                <div style={{ fontFamily: sans, fontSize: 12, color: t1, width: 170, flexShrink: 0 }}>{r.u}</div>
                <div style={{ fontFamily: mono, fontSize: 12, color: grn, width: 130, flexShrink: 0 }}>{r.v}</div>
                <div style={{ fontFamily: sans, fontSize: 11, color: t3 }}>{r.note}</div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <SectionTitle>DSU по регионам — где какой вуз и какое агентство</SectionTitle>
          <p style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 14 }}>
            Пороги — на цикл 2026/27, для будущих циклов нужно перепроверять.
          </p>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
            {DSU_TABLE.map((r, i) => (
              <div key={r.region} style={{ padding: '12px 0', borderBottom: i < DSU_TABLE.length - 1 ? `1px solid ${line}` : 'none' }}>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 10, marginBottom: 3 }}>
                  <span style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1 }}>{r.region}</span>
                  <span style={{ fontFamily: mono, fontSize: 11, color: gold }}>{r.agency}</span>
                </div>
                <div style={{ fontFamily: sans, fontSize: 11, color: t3, marginBottom: 3 }}>{r.unis}</div>
                <div style={{ fontFamily: sans, fontSize: 11, color: t2 }}>
                  ISEE-порог: <span style={{ color: grn }}>{r.isee}</span> · стипендия: <span style={{ color: grn }}>{r.amount}</span>
                </div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <SectionTitle>Таймлайн подачи</SectionTitle>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
            {TIMELINE.map((row, i) => (
              <div key={row.m} style={{ display: 'flex', gap: 14, padding: '10px 0', borderBottom: i < TIMELINE.length - 1 ? `1px solid ${line}` : 'none' }}>
                <div style={{ fontFamily: mono, fontSize: 11, color: gold, width: 170, flexShrink: 0 }}>{row.m}</div>
                <div style={{ fontFamily: sans, fontSize: 12, color: t2 }}>{row.t}</div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <SectionTitle>Национальные программы</SectionTitle>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {NATIONAL.map(n => (
              <div key={n.title}>
                <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: t1, marginBottom: 4 }}>{n.title}</div>
                <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6, marginBottom: 6 }}>{n.body}</div>
                <div style={{ fontFamily: sans, fontSize: 12, color: n.noteColor, lineHeight: 1.6, fontWeight: 500 }}>{n.note}</div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <SectionTitle>Особые программы конкретных вузов</SectionTitle>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {UNI_SPECIAL.map(u => (
              <div key={u.u}>
                <div style={{ fontFamily: sans, fontSize: 13, fontWeight: 600, color: purp, marginBottom: 3 }}>{u.u}</div>
                <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.6 }}>{u.v}</div>
              </div>
            ))}
          </div>
        </Card>

        <Card>
          <SectionTitle>Что перепроверить перед подачей</SectionTitle>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
            {CAVEATS.map((m, i) => (
              <div key={i} style={{ display: 'flex', gap: 10 }}>
                <div style={{ color: red, fontFamily: mono, fontSize: 11, flexShrink: 0 }}>⚠</div>
                <div style={{ fontFamily: sans, fontSize: 12, color: t2, lineHeight: 1.5 }}>{m}</div>
              </div>
            ))}
          </div>
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
      </ScholarshipLock>
    </div>
  )
}
