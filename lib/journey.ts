// Контент вкладки "Journey" — третий заход.
//
// История правок 2026-09-15 (все в один день):
//   1) Пронумерованный список 1-8 — отклонено: "не в виде цепочек
//      зависимых и параллельных задач, фигня, а не реальные задачи".
//   2) Скобка (параллельно) + цепочка (последовательно), задачи с полями
//      что/как/когда/зачем — отклонено: "всё равно не то, разработаем
//      новый UX". Показал 3 визуальных эскиза (доска блоков / путь со
//      станциями / дело-чек-лист) без привязки к реальным данным.
//   3) Денис выбрал ОБА эскиза "доска блоков" и "путь" — сделать оба,
//      с маленьким переключателем между ними — но: "блоки должны быть
//      с меньшими задачами... как можно меньше сложных задач целым
//      блоком, декомпозируем" + "убери плашки с вопросами зачем когда
//      как, сами вопросы не нужны".
// Отсюда текущая форма JourneyTask: одна задача = одно атомарное
// действие (не сборный "апостиль+перевод+сбор комплекта" одним блоком,
// а отдельные шаги), с коротким живым описанием БЕЗ подписанных полей
// "что/как/когда/зачем" — просто предложение, и отдельно compact `meta`
// (срок/стоимость) без лейбла.
//
// ВАЖНО — этот файл ИМПОРТИРУЕТСЯ ИЗ КЛИЕНТСКОГО КОМПОНЕНТА И ВЕСЬ ЕГО
// СОДЕРЖИМОЕ БЕСПЛАТНО. Никогда не импортировать сюда что-либо из
// lib/guides/*.ts (тот контент платный, отдаётся только через
// app/api/guide/[country]/route.ts после проверки profiles.is_pro на
// сервере).
//
// Апостиль/перевод ниже — САМОСТОЯТЕЛЬНО написанная (не импортированная)
// обобщённая версия того же процесса, который для Венгрии уже подробно
// расписан в lib/guides/hungary.ts (DOCS_TRACK_A) — реальный процесс
// (Рособрнадзор/Госуслуги/бюро переводов) от страны назначения не зависит.
// Обновляя стоимость/сроки — поправь оба файла, они не связаны кодом.

import { resolveAdmissionYear } from '@/lib/admissionYear'
import { MASTER_FIELDS } from '@/lib/masterFields'
import { hasGuideCoverage, GUIDE_COUNTRIES, GUIDE_COUNTRY_NAMES } from '@/lib/legal'
import { gold, blue, red, grn, purp, amb, t3 } from '@/lib/theme'

export interface JourneyTask {
  key: string
  title: string
  detail?: string   // одно короткое предложение, без подписанных полей
  meta?: string      // компактная метка сроков/стоимости, без лейбла типа "КОГДА:"
  urgent?: boolean
  locked?: boolean
  done?: boolean
}

export interface JourneyPhase {
  id: string
  title: string
  color: string
  status: 'blocker' | 'active' | 'parallel' | 'upcoming' | 'done' | 'locked'
  blockedBy?: string[]
  why: string
  proBadge?: boolean
  proNote?: string
  tasks: JourneyTask[]
}

// Рендер: 5 фаз идут "пучком" (параллельно), дальше цепочка друг за
// другом — см. header-комментарий выше.
export const PARALLEL_PHASE_IDS = ['research', 'ielts', 'profile', 'docs', 'schol']
export const SEQUENTIAL_CHAIN_IDS = ['apply', 'wait', 'final']

// ── Портфолио для заявки — единственная часть фазы "Профиль", которая
// реально зависит от направления (запрос Дениса: "зачем там всем подряд
// github... продумай что бы он реально соответствовал направлению").
const PORTFOLIO_CLUSTERS = {
  tech: { task: 'Собрать GitHub с 2-3 читаемыми проектами', detail: 'у каждого — README на английском: что делает, как запустить.', noWorkAdvice: 'Без опыта работы GitHub — твоё главное доказательство навыков.', sopHint: 'упоминай конкретные проекты и код (ссылку на GitHub), не общие слова про «интерес к технологиям».' },
  creative: { task: 'Собрать портфолио на Behance, 10-15 работ', detail: 'у каждой работы — 2-3 предложения о замысле, не просто картинка.', noWorkAdvice: 'Без опыта работы портфолио — твой главный аргумент, для творческих направлений его смотрят раньше диплома.', sopHint: 'ссылайся на конкретные работы из портфолио и объясняй замысел, а не просто прикладывай его.' },
  business: { task: 'Заполнить LinkedIn на английском', detail: 'с описанием реальных задач и результатов, не просто копия CV.', noWorkAdvice: 'Без опыта работы многие Business-программы почти наверняка потребуют GMAT — уточни заранее.', sopHint: 'приводи конкретные бизнес-кейсы или цифры из опыта, не общие фразы про «лидерские качества».' },
  research: { task: 'Описать исследовательский опыт с методиками', detail: 'конкретные методики и результат, не «работал в лаборатории».', noWorkAdvice: 'Без опыта работы даже курсовой проект с реальной методикой — твой главный аргумент.', sopHint: 'упоминай конкретную лабораторию, методику или публикацию, если есть — комиссия ищет это первым делом.' },
  writing: { task: 'Собрать портфолио текстов, 3-5 лучших', detail: 'в один PDF или Google Doc, со ссылками, если публиковались онлайн.', noWorkAdvice: 'Без опыта работы портфолио текстов важнее самого CV для этого направления.', sopHint: 'ссылайся на конкретные опубликованные тексты, а не просто «люблю писать».' },
  academic: { task: 'Переписать практику академическим языком', detail: 'что конкретно делал(а) и какой был результат, не должностная инструкция.', noWorkAdvice: 'Без опыта работы стажировка/практика — единственный способ связать теорию с реальными задачами.', sopHint: 'описывай конкретные задачи стажировки/практики, а не должностные обязанности общими словами.' },
  generic: { task: 'Собрать 2-3 примера опыта по направлению', detail: 'то, что реально относится к программе, а не всё резюме подряд.', noWorkAdvice: 'Без опыта работы собери максимум конкретики из учёбы — курсовые, проекты, олимпиады.', sopHint: 'приводи конкретные примеры из своего опыта, подходящие именно направлению программы.' },
} as const

const FIELD_TO_PORTFOLIO_CLUSTER: Record<string, keyof typeof PORTFOLIO_CLUSTERS> = {
  'Computer Science':'tech', 'Artificial Intelligence':'tech', 'Data Science':'tech',
  'Cybersecurity':'tech', 'Robotics':'tech', 'Human-Computer Interaction':'tech',
  'Computational Engineering':'tech',
  'Design':'creative', 'Architecture':'creative',
  'Economics':'business', 'Finance':'business', 'Management':'business',
  'Marketing':'business', 'Business Analytics':'business',
  'Biotechnology':'research', 'Natural Sciences':'research', 'Medicine':'research', 'Psychology':'research',
  'Journalism':'writing', 'Linguistics':'writing',
  'Law':'academic', 'Social Sciences':'academic', 'International Relations':'academic', 'Education':'academic',
}

export function portfolioFor(masterField?: string) {
  const otherText = masterField?.startsWith('other:') ? masterField.slice(6).trim().toLowerCase() : null
  const matchedOther = otherText
    ? MASTER_FIELDS.find(f => f.l.toLowerCase() === otherText || f.v.toLowerCase() === otherText)?.v
    : null
  const field = otherText ? (matchedOther || '') : (masterField || '')
  return PORTFOLIO_CLUSTERS[FIELD_TO_PORTFOLIO_CLUSTER[field] || 'generic']
}

export function buildJourney(p: any, programs: any[] = []): JourneyPhase[] {
  const ni = p.ielts < 6.5
  const countries: string[] = p.countries?.split(',').filter(Boolean) || []
  const wantsHu = countries.includes('hu')
  const wantsIt = countries.includes('it')
  const wantsDe = countries.includes('de')
  const wantsSe = countries.includes('se')
  const wantsNl = countries.includes('nl')
  const isPro = !!p.is_pro
  const admYear = resolveAdmissionYear(p.timeline)
  const guideCovered = hasGuideCoverage(countries)
  const guideCountryList = countries.filter(c => (GUIDE_COUNTRIES as readonly string[]).includes(c)).map(c => GUIDE_COUNTRY_NAMES[c]).join(', ')
  const pf = portfolioFor(p.master_field)

  const appliedList: JourneyTask[] = (programs || []).slice(0, 8).map((pr: any) => {
    const uni = pr.university?.name || pr._n || '?'
    const name = pr.name || pr._p || ''
    const dl = pr.deadline_month
      ? `дедлайн ${String(pr.deadline_day || 15).padStart(2, '0')}.${String(pr.deadline_month).padStart(2, '0')}`
      : 'дедлайн на сайте вуза'
    return {
      key: `apply.program.${pr.id}`,
      title: `${uni} — ${name}`,
      detail: 'полный пакет документов через портал приёмной комиссии этой программы — проверь список на её странице, иногда просят что-то дополнительно.',
      meta: dl,
    }
  })

  return [
    {
      id: 'research', title: 'Выбери направление и вузы',
      color: blue, status: 'active',
      why: 'Без структурированного шортлиста легко либо переоценить шансы, либо продать себя дешево.',
      tasks: [
        { key: 'research.shortlist', title: 'Составить шортлист из 7 программ', urgent: true, meta: 'первым делом',
          detail: '2 мечты + 3 реальных + 2 запасных — во вкладке «Программы», отфильтруй по своим странам и направлению.' },
        { key: 'research.requirements', title: 'Изучить требования каждой программы', meta: 'все 7 сразу',
          detail: 'точный тюишн, дедлайн, языковой минимум — на официальной странице admissions каждого вуза.' },
        { key: 'research.table', title: 'Составить таблицу дедлайнов', meta: 'обновлять по ходу',
          detail: 'дедлайны у разных вузов почти никогда не совпадают — легко пропустить самый ранний без таблицы.' },
        { key: 'research.cold-email', title: 'Написать научным руководителям', meta: 'за 3-4 мес. до дедлайна',
          detail: 'отдельное короткое письмо каждому — 5-7 предложений, почему интересна именно его тема — заметно повышает шанс на research-программах.' },
        { key: 'research.register', title: 'Завести аккаунт на порталах вузов', meta: 'сразу',
          detail: 'просто регистрация, не подача — некоторые порталы сами напоминают о недостающих документах.' },
      ],
    },
    {
      id: 'ielts', title: 'Сдай языковой экзамен',
      color: ni ? red : grn, status: ni ? 'blocker' : 'done',
      why: ni
        ? `${p.ielts ? `Текущий балл ${p.ielts} — ниже минимума 6.5.` : 'Сертификата ещё нет.'} Единственный по-настоящему жёсткий блокер.`
        : `Балл ${p.ielts} принят всеми вузами шортлиста — сверься отдельно, если среди них есть ETH Zurich или похожий.`,
      tasks: ni ? [
        { key: 'ielts.choose-exam', title: 'Выбрать между TOEFL iBT и Duolingo', urgent: true, meta: '≈230$ / ≈60$',
          detail: 'оба сдаются онлайн из России — сверься, что принимает каждая из 7 программ шортлиста.' },
        { key: 'ielts.register', title: 'Зарегистрироваться и оплатить', meta: 'ets.org / englishtest.duolingo.com' },
        { key: 'ielts.mock-test', title: 'Пройти диагностический mock test', meta: 'Cambridge One, бесплатно',
          detail: 'без реальной оценки уровня легко готовиться не туда.' },
        { key: 'ielts.prep', title: 'Готовиться по официальным материалам', meta: 'минимум 8 недель',
          detail: 'неофициальные советы из интернета не соответствуют формату экзамена.' },
        { key: 'ielts.book-date', title: 'Запланировать дату с запасом по баллу', meta: 'цель 7.0, не 6.5',
          detail: 'результат TOEFL готов за 4-8 дней, Duolingo — за 48 часов, так что запас есть на пересдачу.' },
      ] : [
        { key: 'ielts.done', title: `Языковой балл ${p.ielts} — засчитан`, done: true },
      ],
    },
    {
      id: 'profile', title: 'Усили профиль',
      color: purp, status: 'parallel',
      why: `GPA ${p.gpa} — ${p.gpa >= 4.0 ? 'выше среднего для Европы' : 'достаточно для большинства программ'}. ${p.work === 'no' ? pf.noWorkAdvice : 'Опыт работы усиливает заявку — распиши его конкретно в задаче ниже.'}`,
      tasks: [
        { key: 'profile.cv', title: 'Составить Academic CV', meta: 'Europass или Harvard формат',
          detail: 'не шаблон LinkedIn — он заточен под работодателей, не под приёмную комиссию.' },
        { key: 'profile.portfolio', title: pf.task, detail: pf.detail },
        { key: 'profile.mooc', title: 'Пройти профильный онлайн-курс', meta: 'необязательно',
          detail: 'ищи курс, который ведёт преподаватель именно целевого факультета — заметная деталь для комиссии.' },
        p.work === 'no'
          ? { key: 'profile.internship', title: 'Найти стажировку или research project',
              detail: 'даже неоплачиваемый и короткий опыт закрывает пробел в CV — комиссия смотрит не только на оценки.' }
          : { key: 'profile.experience', title: 'Описать опыт работы академическим языком', detail: 'конкретные задачи и измеримый результат, не список обязанностей.' },
      ],
    },
    {
      id: 'docs', title: 'Собери и легализуй документы',
      color: amb, status: 'active',
      why: 'Апостиль и перевод занимают недели — начинай сразу, не жди готовности остального.',
      tasks: [
        { key: 'docs.recommendations', title: 'Запросить рекомендательные письма', urgent: true, meta: 'за 2 мес. до дедлайна',
          detail: 'лично попроси 2-3 преподавателей, которые хорошо тебя знают — не по email первым сообщением.' },
        { key: 'docs.sop', title: 'Написать Statement of Purpose под каждый вуз', meta: 'не копия между вузами',
          detail: `почему именно эта программа — назови курс/лабораторию/профессора; ${pf.sopHint}` },
        { key: 'docs.passport-copy', title: 'Сделать копию загранпаспорта', meta: 'сразу',
          detail: 'скан главной страницы с фото — перевод не нужен, латиница уже есть.' },
        { key: 'docs.transcript', title: 'Получить диплом и транскрипт в деканате', meta: 'до апостиля',
          detail: 'письменное заявление на выдачу — без оригинала апостилировать нечего.' },
        { key: 'docs.apostille-apply', title: 'Подать на апостиль через Госуслуги', meta: 'раздел «Апостиль на документы об образовании»',
          detail: 'ставит Рособрнадзор — полностью онлайн, ехать в Москву не нужно.' },
        { key: 'docs.apostille-pay', title: 'Оплатить госпошлину за апостиль', meta: 'несколько сотен ₽' },
        { key: 'docs.apostille-receive', title: 'Получить апостилированные документы', meta: '3-5 рабочих дней',
          detail: 'некоторые страны вместо апостиля просят консульскую легализацию — уточни у вуза или в Реальность · PRO.' },
        { key: 'docs.find-translator', title: 'Найти бюро переводов в своём городе', meta: 'стандартная услуга' },
        { key: 'docs.order-translation', title: 'Заказать нотариальный перевод диплома, транскрипта и апостиля', meta: '1500-3000₽/документ, 2-3 недели',
          detail: 'обычно на английский — некоторые страны (например Италия) требуют перевод именно на свой язык, уточни заранее.' },
        { key: 'docs.assemble-package', title: 'Собрать финальный комплект документов', meta: 'оригинал + апостиль + перевод',
          detail: 'скреплённые вместе — именно так его загружают на портал вуза.' },
        { key: 'docs.financial', title: 'Собрать финансовые справки — если требуются', meta: '2-НДФЛ, банковская выписка',
          detail: 'не всегда нужны — зависит от визы/стипендии конкретной страны, уточни перед сбором.' },
        { key: 'docs.file-formats', title: 'Проверить форматы файлов на порталах', meta: 'перед загрузкой',
          detail: 'портал может не принять неправильный формат без объяснения.' },
      ],
    },
    {
      id: 'schol', title: 'Стипендии',
      color: gold, status: wantsHu ? 'active' : 'parallel',
      proBadge: true,
      proNote: guideCovered ? `Детали по стипендиям для твоих стран (${guideCountryList}) — в Реальность · PRO.` : undefined,
      why: wantsHu
        ? (isPro ? 'Stipendium Hungaricum закрывается 15 января — и это ДВЕ отдельные подачи, не одна.'
          : 'У выбранной страны есть важный дедлайн по стипендии — общая часть здесь бесплатна, детали и обе части подачи открой в Реальность · PRO.')
        : 'Подавать не обязательно, но может закрыть всю стоимость учёбы.',
      tasks: [
        ...(wantsSe ? [{ key: 'schol.se', title: 'SI Scholarship (Швеция)', meta: 'дедлайн 15 февраля' }] : []),
        ...(wantsNl ? [{ key: 'schol.nl', title: 'Holland Scholarship (Нидерланды)', meta: 'дедлайн 1 февраля' }] : []),
        { key: 'schol.erasmus', title: 'Проверить Erasmus Mundus', meta: 'общеевропейская',
          detail: 'покрывает обучение и проживание на некоторых совместных программах.' },
        ...(wantsHu ? (isPro ? [
          { key: 'schol.hu.tempus', title: 'Stipendium Hungaricum — подать в Tempus', urgent: true, meta: 'дедлайн 15 января' },
          { key: 'schol.hu.minobr', title: 'Stipendium Hungaricum — пакет в Минобрнауки РФ', urgent: true, meta: 'параллельно с Tempus' },
        ] : [{ key: 'schol.hu.locked', title: 'Важный дедлайн по стипендии — разблокируй Реальность · PRO', urgent: true, locked: true }]) : []),
        ...(wantsIt ? (isPro ? [
          { key: 'schol.it.isee', title: 'Начать оформление ISEE Parificato', meta: '1-2 месяца' },
          { key: 'schol.it.maeci', title: 'MAECI — подать на studyinitaly.esteri.it', meta: 'дедлайн 26 марта' },
        ] : [{ key: 'schol.it.locked', title: 'Важный дедлайн по стипендии — разблокируй Реальность · PRO', locked: true }]) : []),
        ...(!wantsDe && !wantsSe && !wantsNl && !wantsHu && !wantsIt ? [
          { key: 'schol.none', title: 'Проверить стипендии на сайте вуза', detail: 'у почти каждого вуза есть хотя бы своя внутренняя.' },
        ] : []),
      ],
    },
    {
      id: 'apply', title: 'Напиши и подай заявки',
      color: blue, status: 'locked',
      blockedBy: ['ielts', 'docs'],
      why: appliedList.length ? 'Подавай последовательно — начни с менее приоритетных для практики.' : 'План появится, как только добавишь программы в «Избранное».',
      tasks: appliedList.length ? appliedList : [{ key: 'apply.empty', title: 'Добавь программы в Избранное', detail: 'открой «Программы», нажми ♥ на каждой из своего шортлиста.' }],
    },
    {
      id: 'wait', title: 'Дождись решения',
      color: t3, status: 'locked',
      blockedBy: ['apply'],
      why: 'Сроки сильно различаются между вузами — пока ждёшь один ответ, продолжай готовить остальные заявки.',
      tasks: [
        { key: 'wait.keep-going', title: 'Продолжать готовить оставшиеся заявки', detail: 'не останавливайся после отправки первой.' },
        { key: 'wait.followup', title: 'Уточнить статус, если срок прошёл', meta: 'вежливый email', detail: 'только если заявленный вузом срок рассмотрения реально истёк.' },
        { key: 'wait.compare', title: 'Сравнивать офферы во вкладке «Заявки»', detail: 'первый пришедший не обязательно лучший.' },
      ],
    },
    {
      id: 'final', title: 'Оффер, виза и переезд', color: grn, status: 'locked',
      blockedBy: ['wait'],
      proNote: guideCovered ? `Точный процесс визы/оплаты для твоих стран (${guideCountryList}) — в Реальность · PRO.` : undefined,
      why: 'Не медли: места в общежитиях заканчиваются в первые дни, а виза может занять недели.',
      tasks: [
        { key: 'final.accept', title: 'Принять оффер', meta: 'обычно 4-6 недель на решение' },
        { key: 'final.visa-docs', title: 'Собрать документы на визу', meta: 'письмо о зачислении, финансы, страховка',
          detail: 'точный список различается по стране — см. Реальность · PRO.' },
        { key: 'final.visa-apply', title: 'Подать на студенческую визу', meta: 'за 2-3 месяца до семестра',
          detail: 'национальная виза D — общий процесс похож для стран Шенгена, детали по каждой разные.' },
        { key: 'final.payment', title: 'Оплатить обучение или депозит', detail: 'способ перевода из России отличается по стране — узнай заранее.' },
        { key: 'final.housing', title: 'Подать заявку на общежитие', meta: 'сразу после оффера',
          detail: 'места заканчиваются в первые дни — это надёжнее, чем частный съём без присутствия в стране.' },
        ...(wantsIt ? (isPro
          ? [{ key: 'final.it.dsu', title: 'DSU (Италия) — подать в региональное агентство', meta: 'август-сентябрь, после зачисления' }]
          : [{ key: 'final.it.locked', title: 'Важный дедлайн по стипендии — разблокируй Реальность · PRO', locked: true }]) : []),
        { key: 'final.registration', title: 'Зарегистрироваться по месту жительства', meta: 'первые 1-2 недели',
          detail: 'просрочка в некоторых странах — реальная административная проблема.' },
        { key: 'final.bank-sim', title: 'Открыть местный счёт и SIM-карту', meta: 'первые 1-2 недели' },
        { key: 'final.confirm-enrollment', title: 'Подтвердить зачисление в вузе', meta: 'ориентационная неделя' },
        { key: 'final.start', title: 'Начало учёбы', meta: `сентябрь ${admYear}` },
      ],
    },
  ]
}
