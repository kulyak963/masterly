# Стипендии и льготы в Италии — полный гайд (собрано 2026-08-31)

> Собрано вручную через WebSearch/WebFetch (не через `scripts/research-*.mjs`
> — разовая тематическая задача, не бьётся лимитами прокси, тот же подход,
> что и с гайдом по Stipendium Hungaricum). По каждой цифре указан источник;
> где цифра встретилась только у сторонних агрегаторов (educations.com,
> scholarships-порталы и т.п.), это явно отмечено — такие цифры нужно
> перепроверять перед показом пользователю, особенно ближе к новому циклу
> 2027/28, когда пороги ISEE и суммы обычно пересматриваются.

## 1. Три независимых уровня — и как они складываются

В Италии нет одной «стипендии для иностранцев» — есть **три независимых
системы**, которые можно (и часто нужно) комбинировать:

1. **Национальный уровень** — государственные программы Италии, не привязаны
   к конкретному вузу или региону: **MAECI** (стипендии МИД Италии) и
   **Invest Your Talent in Italy** (совместная программа с итальянским
   бизнесом). Подаются отдельно от поступления в вуз.
2. **Региональный уровень — DSU** (Diritto allo Studio Universitario,
   «право на университетское образование»). Это НЕ стипендия одного вуза, а
   государственная система соцподдержки студентов по месту учёбы,
   управляемая либо региональным агентством (ER.GO, LazioDiSCo, EDISU и
   т.д.), либо — в Ломбардии — напрямую самим вузом. Даёт стипендию +
   общежитие + питание + освобождение от налога на право на образование,
   на основе **ISEE** (см. раздел 2).
3. **Университетский уровень** — «No-Tax Area» (обязательное по
   национальному закону освобождение от платы за обучение при низком ISEE,
   с правом вуза поднять порог выше) плюс собственные программы конкретных
   вузов (у Bocconi — ISU Bocconi, у Sant'Anna — полный фри-райд «Allievi»,
   у многих технических вузов — таблица платы по стране происхождения).

Это можно комбинировать: студент с низким ISEE может одновременно получить
освобождение от платы за обучение (No-Tax Area, вуз), стипендию + общежитие
(DSU, регион) и, если повезёт пройти отбор, ещё и MAECI или Invest Your
Talent (страна).

## 2. ISEE и ISEE Parificato — ключ ко всей системе

**ISEE** (Indicatore della Situazione Economica Equivalente) — официальный
итальянский индикатор благосостояния семьи. Практически все льготы и
стипендии в Италии завязаны именно на него.

### Формула

```
ISEE = [ Доход семьи + 20% × Имущество (движимое + недвижимое) ] / N
```

где **N** — коэффициент по составу семьи (шкала эквивалентности):

| Членов семьи | Коэффициент N |
|---|---|
| 1 | 1,00 |
| 2 | 1,57 |
| 3 | 2,04 |
| 4 | 2,46 |
| 5 | 2,85 |
| каждый следующий | +0,35 |

Источник: [businessonline.it — scala di equivalenza](https://www.businessonline.it/articoli/che-cose-la-scala-di-equivalenza-isee-spiegazione-semplice-e-completa.html),
подтверждено по нескольким независимым итальянским финансовым источникам
(fenalca.it, fiscoetasse.com).

### ISEE Parificato — версия для семей за границей

Если семья студента живёт и получает доход **не в Италии** (обычный случай
для абитуриента из России), обычный ISEE оформить нельзя — вместо него
нужен **ISEE Parificato** («приравненный ISEE», иногда обозначается ISEE-U
или ISEEUP). Расчёт по той же формуле, но доходы и имущество за рубежом
пересчитываются в евро по среднему курсу за отчётный год.

**Процесс получения** (единообразен почти во всех вузах, подтверждено на
[Genoa](https://unige.it/en/tasse-e-benefici/isee/parificato),
[Trento](https://infostudenti.unitn.it/en/equivalent-isee-24-25),
[Padua](https://www.esu.pd.it)):

1. Собрать документы о доходах и имуществе семьи (справки о доходах,
   выписки по счетам, документы о недвижимости) — по каждому члену семьи.
2. Документы должны быть выданы компетентным органом страны происхождения
   и **переведены на итальянский через итальянское консульство/дипучреждение**
   (легализация/апостиль + официальный перевод).
3. Обратиться в **CAF** (Centro di Assistenza Fiscale — аккредитованный при
   конкретном вузе налоговый консультационный центр — у каждого вуза свой
   список аккредитованных CAF, единого «одного окна» нет).
4. CAF считает ISEE Parificato и сам передаёт готовый документ в вуз/DSU-агентство.
5. **Дедлайн обычно конец октября — начало ноября** (для DSU-заявок часто
   раньше, август-сентябрь — см. таблицу по регионам ниже).

**Важно:** оформление ISEE Parificato — это не быстрый процесс (сбор
документов из России, перевод, легализация), стоит начинать за несколько
месяцев до дедлайна, а не после получения оффера.

## 3. No-Tax Area — национальный минимум и разница по вузам

По итальянскому закону вузы обязаны **полностью освобождать от платы за
обучение** студентов с ISEE ниже национального порога — на 2026/27 это
**€22 000** (источник: несколько независимых итальянских финансовых
изданий, включая [studenti.it](https://www.studenti.it/fasce-isee-universita-2026-guida-al-calcolo-delle-tasse-universitarie-e-alla-no-tax-area.html)).
Каждый вуз имеет право поднять свой порог выше национального минимума — и
большинство наших вузов это делают:

| Вуз | No-Tax Area порог ISEE 2026/27 | Что дальше |
|---|---|---|
| Politecnico di Milano | €22 000 (не поднят) | частичная скидка 10-80% до €30 000 |
| Sapienza (Рим) | ~€24 000, ступени скидок до €28 000+ | 80% скидка €22 001–24 000, 50% — €24 001–26 000, 25% — €26 001–28 000 |
| University of Bologna | €26 000–27 948 | ступенчатые скидки выше порога |

Источники: [polimi.it/en/.../no-tax-area](https://www.polimi.it/en/students/tuition-fees-scholarships-and-financial-aid/tuition-fees/no-tax-area),
[startupitalia.eu — Sapienza](https://startupitalia.eu/education/scuola/la-sapienza-taglia-le-tasse-per-42-mila-studenti-come-usufruire-degli-sconti/),
[forlitoday.it — Bologna](https://www.forlitoday.it/cronaca/universita-bologna-no-tax-area-esonero-totale-contribuzioni-isee-fino-27-mila-euro.html).
**Не проверены прямыми официальными страницами**, а через новостные
источники со ссылкой на официальные данные — для остальных 8 наших вузов
конкретный порог не собран, стоит уточнять на сайте вуза перед показом
пользователю.

**Отдельная система у технических вузов Турина и части других** —
Politecnico di Torino считает плату для non-EU студентов не по ISEE, а по
**ВВП по ППС страны происхождения** (чем беднее страна по паритету
покупательной способности — тем ниже фиксированная плата), с отдельным
диапазоном min/max в приложении 2 регламента вуза. Точные суммы по
конкретным странам не удалось извлечь из выдачи — см.
[polito.it — Tuition Fee Regulations](https://www.polito.it/sites/default/files/2025-11/ENGL_2026_%20Regolamento%20contribuz_iscritti.pdf).

## 4. DSU по регионам — где какой вуз и какое агентство

Каждый регион Италии, где находится вуз из нашей базы, обслуживается
отдельным агентством с собственным порогом ISEE/ISPE (ISPE — аналогичный
показатель по имуществу отдельно) и собственными суммами. Все пороги ниже
— на цикл **2026/2027**.

| Регион | Вуз(ы) в нашей базе | Агентство | ISEE порог | ISPE порог | Макс. стипендия/год |
|---|---|---|---|---|---|
| Lombardia | Politecnico di Milano, Bocconi, University of Milan | **Нет единого агентства** — управляют сами вузы (Regional Law 33/2004) | Polimi: €26 516,70 | Polimi: €57 645,03 | не собрано единой цифрой |
| Lazio | Sapienza | **LazioDiSCo** | €27 948,60 (полная сумма снижается уже с €18 893,25) | — | до €7 557 |
| Emilia-Romagna | University of Bologna | **ER.GO** | €25 000 | — | не собрано |
| Trentino (авт. провинция) | University of Trento | **Opera Universitaria di Trento** | €26 000 | €52 000 | до €7 072,10 (покрывает до 100% платы за обучение) |
| Liguria | University of Genoa | **ALiSEO** | €28 339 | €61 608 | до €7 172 |
| Piemonte | Politecnico di Torino | **EDISU Piemonte** | €26 306,25 | €57 187,53 | не собрано |
| Toscana | University of Florence, Sant'Anna (Пиза) | **DSU Toscana / ARDSU** | €27 000 | €60 000 | не собрано |
| Veneto | University of Padua | **ESU di Padova** | €26 306,25 | €43 125,94 | не собрано |

Источники по каждой строке (все — WebSearch-сводки с указанием
первоисточника, не проверены прямым WebFetch официальной страницы):
[LazioDiSCo](https://laziodisco.it/bando-diritto-allo-studio-2026-2027/faq-studenti-internazionali/),
[ER.GO](https://www.er-go.it/cosa-fare-per/bandi-di-concorso/importi-pagamenti-e-revoche/importi),
[Opera Universitaria Trento](https://www.operauni.tn.it/wp-content/uploads/Bando-in-pillole_2026-2027.pdf),
[ALiSEO](https://www.aliseo.liguria.it/benefici-economici-universitari/borsa-di-studio-universitaria/),
[EDISU Piemonte](https://www.edisu.piemonte.it/sites/default/files/documentazione/bandi-di-concorso/),
[DSU Toscana](https://www.dsu.toscana.it/),
[ESU Padova / unipd.it](https://www.unipd.it/borse-studio-regionali).

**Общее для всех регионов**: приём заявок обычно **август-сентябрь** для
уже зачисленных студентов, дедлайн для иностранцев с ISEE Parificato часто
чуть позже (октябрь-ноябрь) из-за времени на оформление документа. Заявка
подаётся онлайн на сайте регионального агентства (или вуза для Ломбардии),
для non-EU без SPID/CIE — через отдельную регистрацию временного кода
доступа (подтверждено для EDISU Piemonte).

**Ломбардия — исключение из общей схемы.** Нет единого регионального
агентства (в отличие от остальных 7 регионов) — DSU-конкурс проводит
каждый вуз сам, по своим срокам и (местами) чуть другим правилам, в рамках
регионального закона №33/2004. Для Bocconi это называется **ISU Bocconi
Scholarship** (см. раздел 6).

## 5. Национальные программы

### MAECI (стипендии Правительства Италии)

- Администратор: Министерство иностранных дел Италии (MAECI), подача через
  портал [studyinitaly.esteri.it](https://studyinitaly.esteri.it/)
- Сумма: **€10 800**, тремя траншами за 9 месяцев (магистратура/PhD/AFAM)
- Дедлайн подачи для цикла 2026/27 — **26 марта 2026, 14:00 по итальянскому
  времени** (для будущих циклов ориентироваться на март)
- **Россия — подтверждено, входит в список принимающих стран.** Дважды
  перепроверено: (1) прямой поисковой сводкой по официальному списку
  eligible countries, (2) страницей **посольства Италии в Москве**
  ([ambmosca.esteri.it](https://ambmosca.esteri.it/it/news/dall_ambasciata/2025/05/borse-di-studio-del-maeci-per-lanno-accademica-2025-2026/)),
  которая прямо приглашает молодых студентов из России подавать заявки и
  даёт контакты посольства (Denezhny Pereulok 5, Москва,
  +7 495 796-96-91, embitaly.mosca@esteri.it).
- Покрывает только обучение на территории Италии.

### Invest Your Talent in Italy

- Совместная программа MAECI + ICE (итальянское торговое агентство) +
  Uni-Italia — 250 магистерских программ в области инженерии, IT,
  менеджмента и экономики в конкретном списке вузов.
- Из вузов нашей базы участвуют: **Politecnico di Milano, Politecnico di
  Torino, University of Florence, University of Padua, University of
  Trento, University of Genoa** (полный список включает ещё Brescia,
  Tor Vergata, Parma, Ca' Foscari, Tuscia, Camerino, Modena e Reggio
  Emilia, Milano-Bicocca, Cassino, Verona, Salento, Calabria, Pisa,
  Bergamo, Siena, Iuav Venezia).
- **⚠️ Россия НЕ входит в список eligible countries.** Подтверждено дважды
  независимо: официальный список на 2026/27 — Аргентина, Армения,
  Азербайджан, Бангладеш, Бразилия, Чили, Колумбия, Египет, Эфиопия, Гана,
  Индия, Индонезия, Иран, Казахстан, Мексика, Монголия, Парагвай, Перу,
  Китай, Тунис, Турция, Уругвай, Вьетнам. Программа целенаправленно
  ориентирована на конкретный список стран Global South — России и вообще
  большинства стран СНГ там нет. **Это единственная программа в этом
  гайде, которую нельзя рекомендовать российским пользователям Mastersly.**

## 6. Особые университетские программы

- **Sant'Anna School of Advanced Studies (Пиза) — "Allievi"**: топовые
  студенты (отбор через открытый конкурсный экзамен) получают **полностью
  бесплатное** обучение + проживание + питание + гранты на исследования и
  поездки, для EU и non-EU одинаково. Это одна из всего двух школ в Европе
  (вторая — Scuola Normale Superiore, тоже в Пизе), где высшее образование
  полностью бесплатно для лучших студентов независимо от происхождения.
  Источник: [santannapisa.it — "Only Normale and Sant'Anna..."](https://www.santannapisa.it/en/news/only-normale-and-santanna-pisa-offer-completely-free-higher-education-europe-german).
- **Bocconi — ISU Bocconi Scholarship**: need-based (не merit), финансируется
  за счёт средств региона Ломбардия, доступна EU и non-EU. Покрывает полное
  освобождение от платы + стипендию €1 000–4 000/год (зависит от статуса
  «резидент/приезжающий/иногородний») + одно бесплатное питание в день.
  Подача для новых студентов — **25 мая – 25 июня**, предварительный
  рейтинг — середина октября. Продление — только на 1 год, каждый год
  нужно подавать заново.
- **Politecnico di Torino**: плата для non-EU студентов не по итальянскому
  ISEE, а по фиксированной шкале, привязанной к ВВП по ППС страны
  происхождения — чем ниже показатель страны, тем ниже плата.

## 7. Практический пример расчёта (иллюстративный)

Условная семья из России: студент + 2 родителя (3 человека), совокупный
годовой доход семьи ≈ €18 000 в пересчёте на евро, имущество (квартира)
оценочно ≈ €40 000.

```
N (3 человека) = 2,04
ISEE = [ 18 000 + 0,20 × 40 000 ] / 2,04
     = [ 18 000 + 8 000 ] / 2,04
     = 26 000 / 2,04
     ≈ €12 745
```

При таком ISEE студент почти наверняка попадёт в No-Tax Area (порог
€22 000–27 000 в зависимости от вуза) и с высокой вероятностью получит
полную региональную DSU-стипендию (пороги DSU везде выше — €25 000–28 000)
— то есть теоретически может учиться бесплатно и получать стипендию +
общежитие. **Это иллюстративный расчёт с условными цифрами, не готовая
рекомендация** — реальный ISEE Parificato считает аккредитованный CAF по
официальным документам, а не эта формула «на бумаге».

## 8. Что нельзя утверждать без дополнительной проверки

- **Пороги ISEE/ISPE и суммы стипендий** — обновляются каждый год (иногда
  и в течение года); цифры в этом файле — для цикла 2026/27, для 2027/28
  нужно перепроверять заново.
- **No-Tax Area пороги по вузам** — собраны только для 3 из 11 вузов
  (Politecnico di Milano, Sapienza, Bologna) через новостные источники, не
  через прямые официальные страницы вузов — нужно доверификация для
  остальных 8, особенно если функция появится в продукте.
- **Точная сумма DSU-стипендии** — собрана не для всех 8 регионов (только
  для Lazio, Trento, Liguria); для Lombardia/Emilia-Romagna/Piemonte/
  Toscana/Veneto нужен отдельный заход.
- **Конкретные суммы для non-EU по стране происхождения в Politecnico di
  Torino** — не удалось извлечь таблицу из PDF регламента в выдаче поиска,
  только общий принцип (привязка к ВВП по ППС).
- Всё, что касается MAECI/Invest Your Talent — **дедлайны и списки стран
  каждый год могут меняться**; проверять на studyinitaly.esteri.it и
  investyourtalentapplication.esteri.it непосредственно перед сезоном
  подачи.

## 9. Источники (сводный список)

1. [studyinitaly.esteri.it](https://studyinitaly.esteri.it/) — портал MAECI
2. [ambmosca.esteri.it — MAECI для России](https://ambmosca.esteri.it/it/news/dall_ambasciata/2025/05/borse-di-studio-del-maeci-per-lanno-accademica-2025-2026/)
3. [investyourtalentapplication.esteri.it](https://investyourtalentapplication.esteri.it/SitoIYT/EN/invest-your-talent-in-italy)
4. [laziodisco.it](https://laziodisco.it/)
5. [er-go.it](https://www.er-go.it/)
6. [operauni.tn.it](https://www.operauni.tn.it/)
7. [aliseo.liguria.it](https://www.aliseo.liguria.it/)
8. [edisu.piemonte.it](https://www.edisu.piemonte.it/)
9. [dsu.toscana.it](https://www.dsu.toscana.it/)
10. [esu.pd.it](https://www.esu.pd.it/) / [unipd.it/borse-studio-regionali](https://www.unipd.it/borse-studio-regionali)
11. [polimi.it — No-Tax Area](https://www.polimi.it/en/students/tuition-fees-scholarships-and-financial-aid/tuition-fees/no-tax-area)
12. [unibocconi.it — ISU Bocconi](https://www.unibocconi.it/en/current-students/funding/isu-bocconi-scholarship-years-subsequent-first-and-phd-ay-2026-27)
13. [santannapisa.it — free education](https://www.santannapisa.it/en/news/only-normale-and-santanna-pisa-offer-completely-free-higher-education-europe-german)
14. [polito.it — Tuition Fee Regulations](https://www.polito.it/sites/default/files/2025-11/ENGL_2026_%20Regolamento%20contribuz_iscritti.pdf)
15. [unige.it — ISEE Parificato](https://unige.it/en/tasse-e-benefici/isee/parificato)
16. [infostudenti.unitn.it — Equivalent ISEE](https://infostudenti.unitn.it/en/equivalent-isee-24-25)
17. [businessonline.it — scala di equivalenza ISEE](https://www.businessonline.it/articoli/che-cose-la-scala-di-equivalenza-isee-spiegazione-semplice-e-completa.html)

## 10. Рекомендации по использованию в продукте (не реализовано)

По аналогии с гайдом по Stipendium Hungaricum, это готовый материал для
такой же платной вкладки «Италия · PRO» — появлялась бы, если у
пользователя в стране выбрана Италия, с тем же честным подходом (заглушка
вместо оплаты, реальный процессор ещё не подключён). Разница с Венгрией:
здесь система сложнее (3 уровня + 8 разных региональных агентств вместо
одной программы), поэтому в UI разумно не пытаться впихнуть всё сразу, а
сделать так:

- Блок «твой регион» — раз пользователь уже выбрал конкретные программы/
  вузы, можно автоматически показывать только релевантную строку из
  таблицы DSU (по вузу программы), а не всю таблицу целиком.
- ISEE-калькулятор — можно сделать интерактивным (ввод дохода, состава
  семьи → расчёт по формуле из раздела 2), с чёткой пометкой «это
  ориентировочный расчёт, не официальный ISEE Parificato».
- Explicitly показывать предупреждение про Invest Your Talent — раз
  Россия не входит в список, эту программу вообще не стоит рекламировать
  российским пользователям, только упомянуть как «недоступно для вашей
  страны» если кто-то о ней спросит.

Решение по реализации — за Денисом, как и с Венгрией.
