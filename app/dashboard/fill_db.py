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
 
# ── программы для поиска ───────────────────────────────────
TARGETS = [
    {"country": "de", "country_name": "Германия",    "field": "Computer Science / AI"},
    {"country": "de", "country_name": "Германия",    "field": "Engineering"},
    {"country": "nl", "country_name": "Нидерланды",  "field": "Computer Science / AI"},
    {"country": "nl", "country_name": "Нидерланды",  "field": "Data Science"},
    {"country": "se", "country_name": "Швеция",      "field": "Computer Science / AI"},
    {"country": "fi", "country_name": "Финляндия",   "field": "Computer Science / AI"},
    {"country": "ch", "country_name": "Швейцария",   "field": "Computer Science / AI"},
    {"country": "fr", "country_name": "Франция",     "field": "Data Science"},
    {"country": "at", "country_name": "Австрия",     "field": "Computer Science"},
    {"country": "cz", "country_name": "Чехия",       "field": "Computer Science"},
]
 
PROMPT_TEMPLATE = """
Ты помогаешь заполнить базу данных магистерских программ для российских студентов.
 
Найди 3-5 лучших магистерских программ по направлению "{field}" в {country_name}.
Фокус на программах преподаваемых на английском языке.
 
Верни ТОЛЬКО валидный JSON массив (без markdown, без пояснений):
 
[
  {{
    "university_name": "название вуза",
    "university_city": "город",
    "university_website": "https://...",
    "ranking_qs": 100,
    "program_name": "название программы",
    "language": "English",
    "duration_months": 24,
    "tuition_eur": 0,
    "deadline_month": 1,
    "deadline_day": 15,
    "ielts_min": 6.5,
    "gpa_min": 3.5,
    "program_url": "https://...",
    "scholarships": ["DAAD", "Erasmus"],
    "summary": "2-3 предложения о программе на русском",
    "pros": ["плюс 1", "плюс 2", "плюс 3"],
    "cons": ["минус 1", "минус 2"],
    "acceptance_rate": 30,
    "avg_salary_after": 55000
  }}
]
 
Важно:
- tuition_eur = 0 если обучение бесплатное
- deadline_month/day = типичный дедлайн для поступления в осенний семестр
- acceptance_rate в процентах
- avg_salary_after в EUR/год
- scholarships = список доступных стипендий
"""
 
def main():
    print("🚀 Запускаем заполнение базы данных Masterly")
    
    client = Anthropic(
    api_key=ANTHROPIC_KEY,
    base_url="https://api.wellflow.dev"
)
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    
    total_programs = 0
    
    for target in TARGETS:
        print(f"\n📍 Ищем программы: {target['field']} в {target['country_name']}")
        
        try:
            # запрос к Claude
            message = client.messages.create(
                model="claude-opus-4-5",
                max_tokens=4000,
                messages=[{
                    "role": "user",
                    "content": PROMPT_TEMPLATE.format(
                        field=target["field"],
                        country_name=target["country_name"]
                    )
                }]
            )
            
            raw = message.content[0].text.strip()
            
            # убираем markdown если есть
            if raw.startswith("```"):
                raw = raw.split("```")[1]
                if raw.startswith("json"):
                    raw = raw[4:]
            raw = raw.strip()
            
            programs = json.loads(raw)
            print(f"   ✓ Найдено {len(programs)} программ")
            
            for prog in programs:
                # сохраняем вуз
                uni_data = {
                    "name": prog["university_name"],
                    "country": target["country"],
                    "city": prog.get("university_city", ""),
                    "website": prog.get("university_website", ""),
                    "ranking_qs": prog.get("ranking_qs"),
                }
                
                # проверяем есть ли уже такой вуз
                existing = supabase.table("universities").select("id").eq("name", uni_data["name"]).execute()
                
                if existing.data:
                    uni_id = existing.data[0]["id"]
                else:
                    uni_result = supabase.table("universities").insert(uni_data).execute()
                    uni_id = uni_result.data[0]["id"]
                    print(f"   🏛 Добавлен вуз: {uni_data['name']}")
                
                # сохраняем программу
                prog_data = {
                    "university_id": uni_id,
                    "name": prog["program_name"],
                    "field": target["field"],
                    "language": prog.get("language", "English"),
                    "duration_months": prog.get("duration_months", 24),
                    "tuition_eur": prog.get("tuition_eur", 0),
                    "deadline_month": prog.get("deadline_month", 1),
                    "deadline_day": prog.get("deadline_day", 15),
                    "ielts_min": prog.get("ielts_min", 6.5),
                    "gpa_min": prog.get("gpa_min"),
                    "url": prog.get("program_url", ""),
                    "scholarships": prog.get("scholarships", []),
                    "summary": prog.get("summary", ""),
                    "pros": prog.get("pros", []),
                    "cons": prog.get("cons", []),
                    "acceptance_rate": prog.get("acceptance_rate"),
                    "avg_salary_after": prog.get("avg_salary_after"),
                }
                
                supabase.table("programs").insert(prog_data).execute()
                print(f"   ✅ {prog['program_name']} @ {prog['university_name']}")
                total_programs += 1
            
            # пауза между запросами
            time.sleep(2)
            
        except json.JSONDecodeError as e:
            print(f"   ❌ Ошибка парсинга JSON: {e}")
            print(f"   Raw: {raw[:200]}")
        except Exception as e:
            print(f"   ❌ Ошибка: {e}")
            time.sleep(5)
    
    print(f"\n🎉 Готово! Добавлено программ: {total_programs}")
 
if __name__ == "__main__":
    main()
 