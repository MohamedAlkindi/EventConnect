import random
from datetime import datetime, timedelta

# Yemeni cities
cities = [
    "Sana'a",
    "Aden",
    "Al Mukalla",
    "Taiz",
    "Al Hudaydah",
    "Ibb",
    "Dhamar",
    "Zinjibar",
    "Sayun",
    "Al Bayda"
]

# Event categories with corresponding events and image links
events_by_category = {
    "Music": [
        {
            "name": "Yemen Traditional Music Festival",
            "description": "Experience the rich musical heritage of Yemen with traditional instruments and performances.",
            "image": "https://images.unsplash.com/photo-1514525253161-7a46d19cd819"
        },
        {
            "name": "Oud Night Concert",
            "description": "An evening celebrating the magical sounds of the Oud with Yemen's finest musicians.",
            "image": "https://images.unsplash.com/photo-1511735111819-9a3f7709049c"
        }
    ],
    "Art": [
        {
            "name": "Yemen Contemporary Art Exhibition",
            "description": "Showcasing the works of emerging Yemeni artists exploring modern themes through traditional techniques.",
            "image": "https://images.unsplash.com/photo-1531913764164-f85c52e6e654"
        },
        {
            "name": "Traditional Crafts Workshop",
            "description": "Learn the art of traditional Yemeni crafts including pottery and textile weaving.",
            "image": "https://images.unsplash.com/photo-1528732807373-ba0a29568f58"
        }
    ],
    "Sports": [
        {
            "name": "Yemen Football Championship",
            "description": "Annual football tournament bringing together teams from across Yemen.",
            "image": "https://images.unsplash.com/photo-1579952363873-27f3bade9f55"
        },
        {
            "name": "Desert Marathon",
            "description": "A challenging marathon through Yemen's beautiful desert landscape.",
            "image": "https://images.unsplash.com/photo-1552674605-db6ffd4facb5"
        }
    ],
    "Food": [
        {
            "name": "Yemeni Food Festival",
            "description": "Celebrate the diverse flavors of Yemeni cuisine with traditional dishes and cooking demonstrations.",
            "image": "https://images.unsplash.com/photo-1555939594-58d7cb561ad1"
        },
        {
            "name": "Coffee Origins Exhibition",
            "description": "Discover Yemen's rich coffee heritage and taste various local coffee varieties.",
            "image": "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085"
        }
    ],
    "Business": [
        {
            "name": "Yemen Tech Summit",
            "description": "Annual technology conference bringing together entrepreneurs and tech enthusiasts.",
            "image": "https://images.unsplash.com/photo-1515187029135-18ee286d815b"
        },
        {
            "name": "Start-up Weekend Yemen",
            "description": "48-hour event where entrepreneurs develop their business ideas with mentors.",
            "image": "https://images.unsplash.com/photo-1556761175-4b46a572b786"
        }
    ],
    "Technology": [
        {
            "name": "Code Yemen Conference",
            "description": "Learn about the latest programming technologies and network with tech professionals.",
            "image": "https://images.unsplash.com/photo-1504384764586-bb4cdc1707b0"
        },
        {
            "name": "Digital Innovation Workshop",
            "description": "Hands-on workshop exploring digital technologies and their applications.",
            "image": "https://images.unsplash.com/photo-1488590528505-98d2b5aba04b"
        }
    ],
    "Education": [
        {
            "name": "Yemen Education Fair",
            "description": "Annual education exhibition showcasing universities and educational opportunities.",
            "image": "https://images.unsplash.com/photo-1523050854058-8df90110c9f1"
        },
        {
            "name": "Youth Leadership Conference",
            "description": "Empowering young leaders through workshops and networking opportunities.",
            "image": "https://images.unsplash.com/photo-1552664730-d307ca884978"
        }
    ]
}

# Gender restrictions
gender_restrictions = ["Males Only", "Females Only", "No Restrictions"]

# Generate random future date
def get_random_future_date():
    days_ahead = random.randint(1, 180)  # Generate date within next 6 months
    future_date = datetime.now() + timedelta(days=days_ahead)
    return future_date.strftime("%Y-%m-%d %H:%M:00")

# Generate SQL insert statements
def generate_insert_statements(num_events=20):
    insert_statements = []
    used_names = set()
    
    for event_id in range(1, num_events + 1):
        # Select random category and event
        category = random.choice(list(events_by_category.keys()))
        event_template = random.choice(events_by_category[category])
        
        # Ensure unique names by adding city if necessary
        base_name = event_template["name"]
        city = random.choice(cities)
        name = f"{base_name} - {city}"
        while name in used_names:
            city = random.choice(cities)
            name = f"{base_name} - {city}"
        used_names.add(name)
        
        # Generate other random values
        date_time = get_random_future_date()
        gender_restriction = random.choice(gender_restrictions)
        
        # Create SQL insert statement
        insert_sql = f"""INSERT INTO Event (EventID, Name, Category, Picture, Location, DateAndTime, Description, GenderRestriction)
VALUES ({event_id}, '{name}', '{category}', '{event_template["image"]}', '{city}', '{date_time}', '{event_template["description"]}', '{gender_restriction}');"""
        
        insert_statements.append(insert_sql)
    
    return insert_statements

# Generate and print insert statements
if __name__ == "__main__":
    statements = generate_insert_statements(20)  # Generate 20 events
    print("-- Event Insert Statements")
    print("BEGIN TRANSACTION;")
    for statement in statements:
        print(statement)
    print("COMMIT;")
