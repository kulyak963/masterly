"""
Masterly — заполнение базы данных вузов через Claude API
Запуск: python fill_db.py
"""
 
import os, json, time
from anthropic import Anthropic
from supabase import create_client
 
# ── настройки ──────────────────────────────────────────────
SUPABASE_URL = "https://sffbsxwpnspwttofhdxd.supabase.co"
SUPABASE_KEY = "sb_publishable_Ar_cfGVq4uNEW-dx-u87aw_Q9gYD3lJ"  # вставь свой anon key
ANTHROPIC_KEY = "wf_Gd7M6e38wdQroIb61O0kB5WSe9C7gdEzXkxIKQFLT8tCksuR" # вставь свой API key с console.anthropic.com
 
# ── 20 стран ──────────────────────────────────────────────
COUNTRIES = [
    ("de","Germany"),    ("nl","Netherlands"), ("se","Sweden"),
    ("fi","Finland"),    ("ch","Switzerland"), ("fr","France"),
    ("at","Austria"),    ("cz","Czech Republic"), ("dk","Denmark"),
    ("be","Belgium"),    ("ie","Ireland"),     ("it","Italy"),
    ("es","Spain"),      ("pt","Portugal"),    ("no","Norway"),
    ("pl","Poland"),     ("hu","Hungary"),     ("ee","Estonia"),
    ("lt","Lithuania"),  ("lv","Latvia"),
]

# ── 8 направлений (точно совпадают с БД) ──────────────────
FIELDS = [
    "Computer Science",
    "Artificial Intelligence",
    "Data Science",
    "Cybersecurity",
    "Business Analytics",
    "Robotics",
    "Human-Computer Interaction",
    "Computational Engineering",
]

# ── промпт: просим только то что Claude знает надёжно ─────
PROMPT = """Fill a database of English-taught master's programs in {field} in {country}.

Return 3-5 REAL programs you are highly confident about. Skip any program you are unsure of.

Return ONLY a JSON array, no markdown, no explanation:

[
  {{
    "university_name": "Official university name in English",
    "university_city": "City",
    "university_website": "https://university.edu",
    "ranking_qs": 150,
    "program_name": "Official program name",
    "duration_months": 24,
    "tuition_eur": 0,
    "deadline_month": 1,
    "deadline_day": 15,
    "ielts_min": 6.5,
    "program_url": "https://link-to-program-admissions-page",
    "scholarships": ["DAAD", "Erasmus+"],
    "summary": "2-3 предложения о программе на русском языке.",
    "pros": ["плюс 1", "плюс 2", "плюс 3"],
    "cons": ["минус 1", "минус 2"]
  }}
]

Rules:
- tuition_eur: 0 if free, annual EUR cost for non-EU if paid
- deadline_month/day: typical autumn intake deadline. Guess if unsure.
- ranking_qs: integer, null if truly unknown
- program_url: direct admissions link. Empty string "" if unsure — do NOT invent URLs
- scholarships: only major well-known ones (DAAD, SI, Holland Scholarship, Eiffel, Erasmus+)
- summary/pros/cons: in Russian
- Skip programs with no English-taught option
"""

def already_exists(supabase, country_code: str, field: str) -> bool:
    """Проверяем — есть ли уже хоть одна программа для этой комбинации."""
    result = (
        supabase.table("programs")
        .select("id", count="exact")
        .eq("field", field)
        .execute()
    )
    # ищем программы с нужной страной через join
    unis = (
        supabase.table("universities")
        .select("id")
        .eq("country", country_code)
        .execute()
    )
    if not unis.data:
        return False
    uni_ids = [u["id"] for u in unis.data]
    progs = (
        supabase.table("programs")
        .select("id", count="exact")
        .eq("field", field)
        .in_("university_id", uni_ids)
        .execute()
    )
    return (progs.count or 0) > 0

def save_program(supabase, country_code: str, field: str, prog: dict) -> bool:
    # вуз
    existing_uni = (
        supabase.table("universities")
        .select("id")
        .eq("name", prog["university_name"])
        .execute()
    )
    if existing_uni.data:
        uni_id = existing_uni.data[0]["id"]
    else:
        uni_res = supabase.table("universities").insert({
            "name":       prog["university_name"],
            "country":    country_code,
            "city":       prog.get("university_city", ""),
            "website":    prog.get("university_website", ""),
            "ranking_qs": prog.get("ranking_qs"),
        }).execute()
        uni_id = uni_res.data[0]["id"]

    # программа
    existing_prog = (
        supabase.table("programs")
        .select("id")
        .eq("name", prog["program_name"])
        .eq("university_id", uni_id)
        .execute()
    )
    if existing_prog.data:
        return False  # уже есть

    supabase.table("programs").insert({
        "university_id":  uni_id,
        "name":           prog["program_name"],
        "field":          field,
        "language":       "English",
        "duration_months":prog.get("duration_months", 24),
        "tuition_eur":    prog.get("tuition_eur", 0),
        "deadline_month": prog.get("deadline_month", 1),
        "deadline_day":   prog.get("deadline_day", 15),
        "ielts_min":      prog.get("ielts_min", 6.5),
        "gpa_min":        None,          # не просим — ненадёжно
        "url":            prog.get("program_url", ""),
        "scholarships":   prog.get("scholarships", []),
        "summary":        prog.get("summary", ""),
        "pros":           prog.get("pros", []),
        "cons":           prog.get("cons", []),
        "acceptance_rate":None,          # не просим — галлюцинация
        "avg_salary_after":None,         # не просим — галлюцинация
    }).execute()
    return True

def main():
    client   = Anthropic(api_key=ANTHROPIC_KEY)
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

    total   = 0
    skipped = 0

    for country_code, country_name in COUNTRIES:
        for field in FIELDS:

            # пропускаем если уже есть данные
            if already_exists(supabase, country_code, field):
                print(f"⏭  пропускаем: {field} / {country_name}")
                skipped += 1
                continue

            print(f"\n🔍 {field} в {country_name}")

            try:
                msg = client.messages.create(
                    model="claude-opus-4-5",
                    max_tokens=3000,
                    temperature=0.1,   # минимум фантазии
                    messages=[{
                        "role": "user",
                        "content": PROMPT.format(
                            field=field,
                            country=country_name
                        )
                    }]
                )

                raw = msg.content[0].text.strip()
                if raw.startswith("```"):
                    raw = raw.split("```")[1]
                    if raw.startswith("json"):
                        raw = raw[4:]
                raw = raw.strip()

                programs = json.loads(raw)
                print(f"   → {len(programs)} программ найдено")

                for prog in programs:
                    saved = save_program(supabase, country_code, field, prog)
                    status = "✅" if saved else "⏭ "
                    print(f"   {status} {prog.get('program_name','?')} @ {prog.get('university_name','?')}")
                    if saved:
                        total += 1

                time.sleep(3)  # пауза между запросами

            except json.JSONDecodeError as e:
                print(f"   ❌ JSON ошибка: {e}")
                print(f"   Raw: {raw[:300]}")
                time.sleep(5)
            except Exception as e:
                print(f"   ❌ Ошибка: {e}")
                time.sleep(10)

    print(f"\n✅ Готово. Добавлено: {total} | Пропущено: {skipped}")

if __name__ == "__main__":
    main()