# db/seeds.rb
CalendarEntry.destroy_all
Calendar.destroy_all
WorkoutPlanExercise.destroy_all
DirectMessage.destroy_all
DirectChat.destroy_all
WorkoutPlan.destroy_all
Pairing.destroy_all
Request.destroy_all
UserProfile.destroy_all
User.destroy_all
Exercise.destroy_all

users = [
  # --- Original community users ---
  {
    email: "carl@example.com",
    admin: true,
    password: "password123",
    profile: {
      name: "Carl Rivera",
      birthdate: Date.new(1995, 4, 12),
      gender: "male",
      address: "Kastanienallee 12, 10435 Berlin",
      experience: "intermediate",
      goal: "gain_muscle",
      bio: "Gym rat turned fitness mentor. I love compound lifts and never skip leg day. Looking for a training partner who matches my energy and wants to push their limits."
    }
  },
  {
    email: "sam@example.com",
    password: "password123",
    profile: {
      name: "Sam Chen",
      birthdate: Date.new(1998, 9, 27),
      gender: "female",
      address: "Schönhauser Allee 78, 10439 Berlin",
      experience: "beginner",
      goal: "lose_weight",
      bio: "Just starting my fitness journey and looking for someone patient and motivating. I prefer morning workouts and enjoy mixing cardio with light strength training."
    }
  },
  {
    email: "jordan@example.com",
    password: "password123",
    profile: {
      name: "Jordan Blake",
      birthdate: Date.new(1993, 7, 3),
      gender: "non-binary",
      address: "Bergmannstraße 34, 10961 Berlin",
      experience: "advanced",
      goal: "compete",
      bio: "Competitive CrossFit athlete training for regional qualifiers. I need a partner who can keep up with high-intensity sessions and is serious about performance."
    }
  },
  {
    email: "maria@example.com",
    password: "password123",
    profile: {
      name: "Maria Santos",
      birthdate: Date.new(2000, 11, 18),
      gender: "female",
      address: "Hauptstraße 9, 14532 Kleinmachnow",
      experience: "beginner",
      goal: "general_fitness",
      bio: "Student trying to build healthy habits. I like group classes and outdoor workouts. Ideally looking for a buddy around my age to make fitness fun and social."
    }
  },
  {
    email: "tom@example.com",
    password: "password123",
    profile: {
      name: "Tom Nguyen",
      birthdate: Date.new(1990, 2, 28),
      gender: "male",
      address: "Karl-Marx-Straße 55, 12043 Berlin",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Marathon runner and triathlon finisher. I train six days a week and take recovery seriously. Looking for someone who shares the same dedication to endurance sports."
    }
  },
  {
    email: "priya@example.com",
    password: "password123",
    profile: {
      name: "Priya Patel",
      birthdate: Date.new(1997, 6, 14),
      gender: "female",
      address: "Potsdamer Platz 10, 10785 Berlin",
      experience: "intermediate",
      goal: "lose_weight",
      bio: "Yoga practitioner who recently got into strength training. I'm consistent, punctual, and love tracking progress. Would love a supportive partner for evening gym sessions."
    }
  },
  {
    email: "marcus@example.com",
    password: "password123",
    profile: {
      name: "Marcus Hill",
      birthdate: Date.new(1988, 3, 9),
      gender: "male",
      address: "Brunnenstraße 120, 13355 Berlin",
      experience: "beginner",
      goal: "rehabilitate",
      bio: "Coming back to fitness after a knee injury. My physio has cleared me for low-impact training. Looking for a patient gym buddy who understands the importance of form over intensity."
    }
  },
  {
    email: "adriano@example.com",
    password: "password123",
    profile: {
      name: "Adriano Terrazas",
      birthdate: Date.new(1996, 8, 22),
      gender: "other",
      address: "Rudower Chaussee 3, 12489 Berlin",
      experience: "intermediate",
      goal: "general_fitness",
      bio: "Software developer by day, gym enthusiast by night. I like variety in my workouts and enjoy trying new exercises. Looking for a chill but consistent training partner."
    }
  },
  {
    email: "leila@example.com",
    password: "password123",
    profile: {
      name: "Leila Hassan",
      birthdate: Date.new(1994, 1, 5),
      gender: "female",
      address: "Rosenthaler Straße 44, 10178 Berlin",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Powerlifting enthusiast with a background in sports science. I take programming seriously and believe in progressive overload. Looking for a strong training partner who wants to grow."
    }
  },
  {
    email: "ryan@example.com",
    password: "password123",
    profile: {
      name: "Ryan Kowalski",
      birthdate: Date.new(2001, 5, 30),
      gender: "male",
      address: "Friedrich-Ebert-Straße 21, 14469 Potsdam",
      experience: "beginner",
      goal: "improve_endurance",
      bio: "University student and casual cyclist looking to build a proper fitness base. I'm energetic and eager to learn. Happy to train in Potsdam or commute to Berlin for the right partner."
    }
  },

  # --- Celebrity Athletes ---

  # ⚽ Soccer
  {
    email: "messi@example.com",
    password: "password123",
    profile: {
      name: "Lionel Messi",
      birthdate: Date.new(1987, 6, 24),
      gender: "male",
      address: "Collins Avenue 1, Miami Beach, FL 33139, USA",
      experience: "advanced",
      goal: "compete",
      bio: "Eight-time Ballon d'Or winner and World Cup champion. Now competing in MLS with Inter Miami, I still train with the same hunger I had as a kid in Rosario. Looking for serious training partners who understand elite performance."
    }
  },
  {
    email: "ronaldo@example.com",
    password: "password123",
    profile: {
      name: "Cristiano Ronaldo",
      birthdate: Date.new(1985, 2, 5),
      gender: "male",
      address: "King Fahd Road 1, Riyadh 12271, Saudi Arabia",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Five-time Champions League winner and five-time Ballon d'Or recipient. Discipline and dedication define my training philosophy. I wake at 6am every day — if you want to train with the best, you need to match that commitment."
    }
  },
  {
    email: "mbappe@example.com",
    password: "password123",
    profile: {
      name: "Kylian Mbappé",
      birthdate: Date.new(1998, 12, 20),
      gender: "male",
      address: "Paseo de la Castellana 100, 28046 Madrid, Spain",
      experience: "advanced",
      goal: "compete",
      bio: "World Cup champion at 19, now at Real Madrid. Speed and technical precision are my trademarks. My training sessions are as intense as match day — looking for someone who can keep up with the pace work."
    }
  },
  {
    email: "neymar@example.com",
    password: "password123",
    profile: {
      name: "Neymar Jr",
      birthdate: Date.new(1992, 2, 5),
      gender: "male",
      address: "Avenida Brigadeiro Faria Lima 1000, São Paulo 01310-100, Brazil",
      experience: "advanced",
      goal: "rehabilitate",
      bio: "Brazilian superstar currently recovering from a serious knee injury. Using this period to rebuild from the ground up — rehab, core strength, and staying sharp mentally. Looking for a knowledgeable, patient partner."
    }
  },
  {
    email: "vinicius@example.com",
    password: "password123",
    profile: {
      name: "Vinicius Jr",
      birthdate: Date.new(2000, 7, 12),
      gender: "male",
      address: "Avenida de la Ciudad de Barcelona 12, 28007 Madrid, Spain",
      experience: "advanced",
      goal: "compete",
      bio: "Ballon d'Or 2024 winner and Real Madrid winger. I bring flair and explosiveness to every session — dribbling drills, sprint intervals, and creativity define my training. Come and match my energy."
    }
  },
  {
    email: "haaland@example.com",
    password: "password123",
    profile: {
      name: "Erling Haaland",
      birthdate: Date.new(2000, 7, 21),
      gender: "male",
      address: "Deansgate 1, Manchester M3 2BW, UK",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Premier League record breaker with Manchester City. I eat, sleep, and breathe football. My gym sessions are as serious as my matches — looking for someone who treats strength training like a competition."
    }
  },
  {
    email: "alexia@example.com",
    password: "password123",
    profile: {
      name: "Alexia Putellas",
      birthdate: Date.new(1994, 2, 4),
      gender: "female",
      address: "Travessera de Les Corts 89, 08028 Barcelona, Spain",
      experience: "advanced",
      goal: "compete",
      bio: "Two-time Ballon d'Or Féminin winner and Barcelona Femení captain. My game is built on technical mastery and intelligence. Looking for a motivated partner to push technical and physical limits in Barcelona."
    }
  },
  {
    email: "samkerr@example.com",
    password: "password123",
    profile: {
      name: "Sam Kerr",
      birthdate: Date.new(1993, 9, 10),
      gender: "female",
      address: "Fulham Road 1, London SW6 1HS, UK",
      experience: "advanced",
      goal: "compete",
      bio: "Chelsea FC and Australian Matildas striker — one of the best forwards in the world. I train hard and recover harder. Looking for a dedicated gym partner who understands what it takes to compete at the highest level."
    }
  },
  {
    email: "hegerberg@example.com",
    password: "password123",
    profile: {
      name: "Ada Hegerberg",
      birthdate: Date.new(1995, 7, 10),
      gender: "female",
      address: "Avenue de l'Hippodrome 1, 69008 Lyon, France",
      experience: "advanced",
      goal: "compete",
      bio: "First-ever Ballon d'Or Féminin winner and Lyon striker. After overcoming a serious ACL injury I came back stronger than ever. Recovery is just as important as training — looking for a smart and committed partner."
    }
  },
  {
    email: "pedri@example.com",
    password: "password123",
    profile: {
      name: "Pedri González",
      birthdate: Date.new(2002, 11, 25),
      gender: "male",
      address: "Carrer d'Arístides Maillol 12, 08028 Barcelona, Spain",
      experience: "advanced",
      goal: "compete",
      bio: "Barcelona and Spain midfielder — one of football's brightest young talents. I play with vision and elegance; gym sessions focus on agility and injury prevention. Looking for a consistent partner in Barcelona."
    }
  },

  # 🏀 NBA / WNBA
  {
    email: "lebron@example.com",
    password: "password123",
    profile: {
      name: "LeBron James",
      birthdate: Date.new(1984, 12, 30),
      gender: "male",
      address: "Wilshire Blvd 1000, Los Angeles, CA 90017, USA",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Four-time NBA champion and the all-time scoring leader. At 40, I'm proof that longevity is earned through relentless work and smart recovery. Always looking to learn and compete — the grind never stops."
    }
  },
  {
    email: "curry@example.com",
    password: "password123",
    profile: {
      name: "Stephen Curry",
      birthdate: Date.new(1988, 3, 14),
      gender: "male",
      address: "Atherton Avenue 10, Atherton, CA 94027, USA",
      experience: "advanced",
      goal: "compete",
      bio: "Four-time NBA champion and the greatest shooter in history. I work equally hard on conditioning and footwork as I do on my jumper. Looking for a training partner who appreciates the craft of skill-based performance."
    }
  },
  {
    email: "giannis@example.com",
    password: "password123",
    profile: {
      name: "Giannis Antetokounmpo",
      birthdate: Date.new(1994, 12, 6),
      gender: "male",
      address: "Wisconsin Avenue 1200, Milwaukee, WI 53202, USA",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "The Greek Freak. Two-time MVP and NBA champion. From the streets of Athens to the top of the NBA — my work ethic is unmatched. Hard work beats talent when talent doesn't work hard. Let's train together."
    }
  },
  {
    email: "luka@example.com",
    password: "password123",
    profile: {
      name: "Luka Dončić",
      birthdate: Date.new(1999, 2, 28),
      gender: "male",
      address: "Dallas Parkway 2500, Dallas, TX 75201, USA",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Slovenian superstar and NBA champion with the Dallas Mavericks. My game is built on IQ and skill, but I'm investing seriously in conditioning this season. Looking for a partner to level up together."
    }
  },
  {
    email: "jokic@example.com",
    password: "password123",
    profile: {
      name: "Nikola Jokić",
      birthdate: Date.new(1995, 2, 19),
      gender: "male",
      address: "Lawrence Street 1000, Denver, CO 80202, USA",
      experience: "advanced",
      goal: "general_fitness",
      bio: "Three-time NBA MVP and two-time champion from Sombor, Serbia. I may not look the most athletic, but I am the most efficient. Looking for a relaxed but consistent training partner — horses in between sessions optional."
    }
  },
  {
    email: "embiid@example.com",
    password: "password123",
    profile: {
      name: "Joel Embiid",
      birthdate: Date.new(1994, 3, 16),
      gender: "male",
      address: "Broad Street 3601, Philadelphia, PA 19148, USA",
      experience: "advanced",
      goal: "rehabilitate",
      bio: "NBA MVP and Olympic gold medalist (France). Born in Yaoundé, Cameroon — I didn't start basketball until I was 16. Managing chronic knee issues now, so smart training and injury prevention are my priority."
    }
  },
  {
    email: "ajawilson@example.com",
    password: "password123",
    profile: {
      name: "A'ja Wilson",
      birthdate: Date.new(1996, 8, 8),
      gender: "female",
      address: "Paradise Road 1, Las Vegas, NV 89101, USA",
      experience: "advanced",
      goal: "compete",
      bio: "Three-time WNBA champion and four-time MVP — arguably the greatest player in women's basketball. I train with ferocity and compete with joy. Looking for a partner who brings that same fire every single session."
    }
  },
  {
    email: "bstewart@example.com",
    password: "password123",
    profile: {
      name: "Breanna Stewart",
      birthdate: Date.new(1994, 8, 27),
      gender: "female",
      address: "8th Avenue 1, New York, NY 10019, USA",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Two-time WNBA champion from Syracuse. After recovering from a serious Achilles injury I came back even stronger. Resilience and intelligent programming define my training — let's get to work."
    }
  },

  # 🎾 Tennis
  {
    email: "djokovic@example.com",
    password: "password123",
    profile: {
      name: "Novak Djokovic",
      birthdate: Date.new(1987, 5, 22),
      gender: "male",
      address: "Emirate Hills, Dubai, UAE",
      experience: "advanced",
      goal: "compete",
      bio: "24-time Grand Slam champion and Olympic gold medalist from Belgrade, Serbia. My fitness is mental as much as physical — nutrition, mindfulness, and precision training. Looking for partners who value every aspect of performance."
    }
  },
  {
    email: "alcaraz@example.com",
    password: "password123",
    profile: {
      name: "Carlos Alcaraz",
      birthdate: Date.new(2003, 5, 5),
      gender: "male",
      address: "Gran Vía 10, 28013 Madrid, Spain",
      experience: "advanced",
      goal: "compete",
      bio: "Four-time Grand Slam champion at 21 from Murcia, Spain. I play with explosive energy and never stop running. My training sessions are as intense as my matches — looking for someone who can keep up."
    }
  },
  {
    email: "swiatek@example.com",
    password: "password123",
    profile: {
      name: "Iga Świątek",
      birthdate: Date.new(2001, 5, 31),
      gender: "female",
      address: "Marszałkowska 1, 00-624 Warsaw, Poland",
      experience: "advanced",
      goal: "compete",
      bio: "Five-time Roland Garros champion and long-reigning world No. 1 from Warsaw, Poland. Mental strength and physical consistency are my pillars. I train with focus and purpose — looking for a partner who does the same."
    }
  },
  {
    email: "gauff@example.com",
    password: "password123",
    profile: {
      name: "Coco Gauff",
      birthdate: Date.new(2004, 3, 13),
      gender: "female",
      address: "Brickell Avenue 1450, Miami, FL 33131, USA",
      experience: "advanced",
      goal: "compete",
      bio: "US Open champion and rising star from Delray Beach, Florida. At 20 I'm just getting started. I combine powerful groundstrokes with a fierce gym routine. Looking for a driven training partner who's here to grow."
    }
  },
  {
    email: "nadal@example.com",
    password: "password123",
    profile: {
      name: "Rafael Nadal",
      birthdate: Date.new(1986, 6, 3),
      gender: "male",
      address: "Avinguda de Jaume I, 07500 Manacor, Mallorca, Spain",
      experience: "advanced",
      goal: "rehabilitate",
      bio: "22-time Grand Slam champion and greatest clay-court player of all time from Manacor. After years of battling injuries I've learned that smart recovery is part of the training. Looking for a seasoned and patient partner."
    }
  },
  {
    email: "raducanu@example.com",
    password: "password123",
    profile: {
      name: "Emma Raducanu",
      birthdate: Date.new(2002, 11, 13),
      gender: "female",
      address: "Bromley High Street 10, London BR1 1EU, UK",
      experience: "advanced",
      goal: "compete",
      bio: "US Open 2021 champion — the first qualifier in history to win a Grand Slam. Born in Toronto, raised in London. I'm rebuilding with a fresh team and new hunger. Looking for a motivated training partner in London."
    }
  },

  # 🏃 Track & Field
  {
    email: "noahlyles@example.com",
    password: "password123",
    profile: {
      name: "Noah Lyles",
      birthdate: Date.new(1997, 7, 18),
      gender: "male",
      address: "Olympic Blvd 2000, Gainesville, FL 32601, USA",
      experience: "advanced",
      goal: "compete",
      bio: "Olympic 100m champion at Paris 2024 and three-time 200m World Champion from Gainesville, Florida. Speed is my art form. I bring energy to every session and I compete in everything I do. Let's move fast."
    }
  },
  {
    email: "kipyegon@example.com",
    password: "password123",
    profile: {
      name: "Faith Kipyegon",
      birthdate: Date.new(1994, 1, 10),
      gender: "female",
      address: "Nandi Hills Road 1, Eldoret, Kenya",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Three-time Olympic 1500m champion and the greatest female middle-distance runner of all time from Nandi, Kenya. My endurance is built on high-altitude training and relentless dedication. Looking for runners at my level."
    }
  },
  {
    email: "jacobs@example.com",
    password: "password123",
    profile: {
      name: "Marcell Jacobs",
      birthdate: Date.new(1994, 9, 26),
      gender: "male",
      address: "Via Dante 1, 25015 Desenzano del Garda, Italy",
      experience: "advanced",
      goal: "compete",
      bio: "Olympic 100m and relay champion at Tokyo 2020. Born in El Paso, Texas — racing for Italy. Explosive start mechanics and sprint conditioning are my focus. Cerco un compagno di allenamento serio."
    }
  },
  {
    email: "fraserpryce@example.com",
    password: "password123",
    profile: {
      name: "Shelly-Ann Fraser-Pryce",
      birthdate: Date.new(1986, 12, 27),
      gender: "female",
      address: "Constant Spring Road 1, Kingston, Jamaica",
      experience: "advanced",
      goal: "compete",
      bio: "Five-time 100m World Champion and two-time Olympic gold medalist from Kingston, Jamaica. After becoming a mother I returned to win more titles — proof that determination has no ceiling. Looking for elite-level training partners."
    }
  },
  {
    email: "hodgkinson@example.com",
    password: "password123",
    profile: {
      name: "Keely Hodgkinson",
      birthdate: Date.new(2002, 3, 3),
      gender: "female",
      address: "Leigh Road 1, Leigh, Greater Manchester WN7 1AA, UK",
      experience: "advanced",
      goal: "compete",
      bio: "Olympic 800m champion at Paris 2024 and European record holder. At 22 from Greater Manchester I'm one of the most exciting middle-distance runners of my generation. Looking for a serious partner in the UK."
    }
  },

  # 🥊 Boxing / MMA
  {
    email: "canelo@example.com",
    password: "password123",
    profile: {
      name: "Canelo Álvarez",
      birthdate: Date.new(1990, 7, 18),
      gender: "male",
      address: "Paseo Degollado 10, Guadalajara, Jalisco 44100, Mexico",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Undisputed super-middleweight champion from Guadalajara, Mexico. I've fought and beaten the best in the world. My training is brutal but scientific — only serious athletes who respect the craft need apply."
    }
  },
  {
    email: "usyk@example.com",
    password: "password123",
    profile: {
      name: "Oleksandr Usyk",
      birthdate: Date.new(1987, 1, 17),
      gender: "male",
      address: "Khreshchatyk Street 1, Kyiv, Ukraine",
      experience: "advanced",
      goal: "compete",
      bio: "Undisputed heavyweight champion and Olympic gold medalist from Kyiv, Ukraine. Former undisputed cruiserweight too — I've done it all. Training keeps me sharp even in the most difficult of times. Strength of body and spirit."
    }
  },
  {
    email: "adesanya@example.com",
    password: "password123",
    profile: {
      name: "Israel Adesanya",
      birthdate: Date.new(1989, 7, 22),
      gender: "male",
      address: "Ponsonby Road 1, Auckland 1011, New Zealand",
      experience: "advanced",
      goal: "compete",
      bio: "Former UFC Middleweight Champion known as The Last Stylebender. Born in Lagos, Nigeria — raised in Auckland, NZ. Kickboxing, MMA, and performance art define me. Looking for fighters and athletes who think outside the gym."
    }
  },

  # 🏊 Swimming
  {
    email: "marchand@example.com",
    password: "password123",
    profile: {
      name: "Léon Marchand",
      birthdate: Date.new(2002, 5, 17),
      gender: "male",
      address: "Allée Paul Sabatier 1, 31400 Toulouse, France",
      experience: "advanced",
      goal: "compete",
      bio: "Four-time Olympic gold medalist at Paris 2024 who broke Michael Phelps's world records. From Toulouse, France — 22 years old and already a legend. Training partner needed for pool and dryland sessions."
    }
  },
  {
    email: "ledecky@example.com",
    password: "password123",
    profile: {
      name: "Katie Ledecky",
      birthdate: Date.new(1997, 3, 17),
      gender: "female",
      address: "El Camino Real 1, Palo Alto, CA 94301, USA",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Most decorated female swimmer in history with 9 Olympic gold medals. From Bethesda, Maryland — I've been rewriting record books since I was 15. Endurance, consistency, and volume are the pillars of my training."
    }
  },
  {
    email: "peaty@example.com",
    password: "password123",
    profile: {
      name: "Adam Peaty",
      birthdate: Date.new(1994, 12, 28),
      gender: "male",
      address: "Stafford Street 1, Uttoxeter ST14 7DL, UK",
      experience: "advanced",
      goal: "compete",
      bio: "First man to break 57 seconds in the 100m breaststroke and three-time World Champion from Uttoxeter, UK. After battling personal challenges I'm back and stronger. I train with intensity and coach with compassion."
    }
  },
  {
    email: "dressel@example.com",
    password: "password123",
    profile: {
      name: "Caeleb Dressel",
      birthdate: Date.new(1996, 8, 16),
      gender: "male",
      address: "University Avenue 1, Gainesville, FL 32601, USA",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Seven-time Olympic gold medalist in swimming from Green Cove Springs, Florida. Power and precision in the water — but my dryland strength training is where it all starts. Looking for a gym partner as focused as I am."
    }
  },

  # 🏉 Rugby
  {
    email: "dupont@example.com",
    password: "password123",
    profile: {
      name: "Antoine Dupont",
      birthdate: Date.new(1996, 11, 15),
      gender: "male",
      address: "Rue de la Paix 1, 31000 Toulouse, France",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Widely considered the best rugby player in the world — scrum-half for Toulouse and France, and Olympic sevens gold medalist at Paris 2024. My fitness combines explosive power with elite aerobic capacity. Cherche un partenaire sérieux."
    }
  },
  {
    email: "mounga@example.com",
    password: "password123",
    profile: {
      name: "Richie Mo'unga",
      birthdate: Date.new(1994, 5, 25),
      gender: "male",
      address: "Cashel Street 1, Christchurch 8011, New Zealand",
      experience: "advanced",
      goal: "compete",
      bio: "All Blacks fly-half and one of the best playmakers in world rugby. From Christchurch, NZ — I combine game intelligence with serious athletic conditioning. Looking for a partner for strength and conditioning sessions."
    }
  },

  # 🏏 Cricket
  {
    email: "kohli@example.com",
    password: "password123",
    profile: {
      name: "Virat Kohli",
      birthdate: Date.new(1988, 11, 5),
      gender: "male",
      address: "Juhu Beach Road 1, Mumbai 400049, India",
      experience: "advanced",
      goal: "general_fitness",
      bio: "Arguably the greatest cricket batsman of all time and former India captain from Delhi. I transformed Indian cricket's fitness culture — I take the gym as seriously as batting practice. Fitness is non-negotiable for me."
    }
  },
  {
    email: "bumrah@example.com",
    password: "password123",
    profile: {
      name: "Jasprit Bumrah",
      birthdate: Date.new(1993, 12, 6),
      gender: "male",
      address: "Sindhu Bhavan Road 1, Ahmedabad 380059, India",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "ICC World's No. 1 Test bowler from Ahmedabad, India. My unconventional action requires a very specific strength and conditioning routine to stay injury-free. Looking for a dedicated partner who understands athletic longevity."
    }
  },

  # 🤸 Gymnastics
  {
    email: "biles@example.com",
    password: "password123",
    profile: {
      name: "Simone Biles",
      birthdate: Date.new(1997, 3, 14),
      gender: "female",
      address: "Memorial Drive 1, Spring, TX 77373, USA",
      experience: "advanced",
      goal: "compete",
      bio: "The greatest gymnast of all time with 40 World Championship medals and 7 Olympic medals. From Spring, Texas. I also advocate strongly for mental health in sport — training smart is always part of the deal."
    }
  },
  {
    email: "yulo@example.com",
    password: "password123",
    profile: {
      name: "Carlos Yulo",
      birthdate: Date.new(2000, 2, 9),
      gender: "male",
      address: "Taft Avenue 1, Manila 1004, Philippines",
      experience: "advanced",
      goal: "compete",
      bio: "Two-time Olympic gold medalist at Paris 2024 — the first Filipino to win Olympic gymnastics gold. From Manila, I train with incredible precision and explosive power. Looking for partners who appreciate elite gymnastics conditioning."
    }
  },

  # 🏈 American Football
  {
    email: "mahomes@example.com",
    password: "password123",
    profile: {
      name: "Patrick Mahomes",
      birthdate: Date.new(1995, 9, 17),
      gender: "male",
      address: "Arrowhead Drive 1, Kansas City, MO 64129, USA",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Three-time Super Bowl champion and two-time NFL MVP from Tyler, Texas. The most dynamic quarterback in NFL history. Off-season I go hard in the gym to stay at peak performance — looking for someone who matches my competitive edge."
    }
  },
  {
    email: "kelce@example.com",
    password: "password123",
    profile: {
      name: "Travis Kelce",
      birthdate: Date.new(1989, 10, 5),
      gender: "male",
      address: "Leawood Drive 1, Leawood, KS 66206, USA",
      experience: "advanced",
      goal: "general_fitness",
      bio: "Three-time Super Bowl champion and the greatest tight end in NFL history from Cleveland Heights, Ohio. Known for my personality as much as my performance. Looking for an energetic, fun, but serious training partner."
    }
  },

  # ⚾ Baseball
  {
    email: "ohtani@example.com",
    password: "password123",
    profile: {
      name: "Shohei Ohtani",
      birthdate: Date.new(1994, 7, 5),
      gender: "male",
      address: "Chick Hearn Court 1111, Los Angeles, CA 90015, USA",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "The most complete player in baseball history — dominant as both a pitcher and a hitter. From Oshu, Japan, I do things no one thought possible in modern baseball. My training balances pitching mechanics with serious hitting power."
    }
  },

  # 🚴 Cycling
  {
    email: "pogacar@example.com",
    password: "password123",
    profile: {
      name: "Tadej Pogačar",
      birthdate: Date.new(1998, 9, 21),
      gender: "male",
      address: "Prešernova cesta 1, 1000 Ljubljana, Slovenia",
      experience: "advanced",
      goal: "improve_endurance",
      bio: "Three-time Tour de France winner and arguably the greatest cyclist of his generation from Komenda, Slovenia. I ride with joy and train with obsession. Looking for endurance athletes who share my love for going long and hard."
    }
  },

  # ⛳ Golf
  {
    email: "rahm@example.com",
    password: "password123",
    profile: {
      name: "Jon Rahm",
      birthdate: Date.new(1994, 11, 10),
      gender: "male",
      address: "Paseo de Gràcia 1, 08007 Barcelona, Spain",
      experience: "advanced",
      goal: "general_fitness",
      bio: "2023 Masters champion and former World No. 1 golfer from Barrika, Basque Country. Golf is a power sport and I train like one — rotational strength, hip mobility, and explosive conditioning. Looking for a partner in Barcelona."
    }
  },

  # 🏐 Volleyball
  {
    email: "wilfredoleon@example.com",
    password: "password123",
    profile: {
      name: "Wilfredo León",
      birthdate: Date.new(1993, 7, 1),
      gender: "male",
      address: "Plac Defilad 1, 00-901 Warsaw, Poland",
      experience: "advanced",
      goal: "gain_muscle",
      bio: "Born in Cuba — legend in Poland and Italy. Widely regarded as the best volleyball player of his generation. My vertical and serve power are built through years of dedicated strength training. Szukam partnera treningowego w Warszawie."
    }
  },

  # 👋 Dan
  {
    email: "dan@example.com",
    password: "password123",
    profile: {
      name: "Dan Smith",
      birthdate: Date.new(1991, 4, 17),
      gender: "male",
      address: "Oxford Street 1, London W1D 2HT, UK",
      experience: "intermediate",
      goal: "general_fitness",
      bio: "All-round fitness enthusiast and certified personal trainer from London. I love mixing strength training with HIIT and functional movement. Whether you're a beginner or an athlete, I'm here to help and grow together."
    }
  }
]

CELEBRITY_CLOUDINARY_URLS = {
  # ⚽ Soccer
  "messi@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/lionel_messi.jpg",
  "ronaldo@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/cristiano_ronaldo.jpg",
  "mbappe@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/kylian_mbappe.jpg",
  "neymar@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/neymar.jpg",
  "vinicius@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/vinicius_junior.jpg",
  "haaland@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/erling_haaland.jpg",
  "alexia@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/alexia_putellas.jpg",
  "samkerr@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/sam_kerr.jpg",
  "hegerberg@example.com"    => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/ada_hegerberg.jpg",
  "pedri@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/pedri_gonzalez.jpg",
  # 🏀 NBA / WNBA
  "lebron@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/lebron_james.jpg",
  "curry@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/stephen_curry.jpg",
  "giannis@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/giannis_antetokounmpo.jpg",
  "luka@example.com"         => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/luka_doncic.jpg",
  "jokic@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/nikola_jokic.jpg",
  "embiid@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/joel_embiid.jpg",
  "ajawilson@example.com"    => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/aja_wilson.jpg",
  "bstewart@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/breanna_stewart.jpg",
  # 🎾 Tennis
  "djokovic@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/novak_djokovic.jpg",
  "alcaraz@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/carlos_alcaraz.jpg",
  "swiatek@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/iga_swiatek.jpg",
  "gauff@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/coco_gauff.jpg",
  "nadal@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/rafael_nadal.jpg",
  "raducanu@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/emma_raducanu.jpg",
  # 🏃 Track & Field
  "noahlyles@example.com"    => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/noah_lyles.jpg",
  "kipyegon@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/faith_kipyegon.jpg",
  "jacobs@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/marcell_jacobs.jpg",
  "fraserpryce@example.com"  => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/shelly_ann_fraser_pryce.jpg",
  "hodgkinson@example.com"   => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/keely_hodgkinson.jpg",
  # 🥊 Boxing / MMA
  "canelo@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/canelo_alvarez.png",
  "usyk@example.com"         => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/oleksandr_usyk.jpg",
  "adesanya@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/israel_adesanya.jpg",
  # 🏊 Swimming
  "marchand@example.com"     => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/leon_marchand.jpg",
  "ledecky@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/katie_ledecky.jpg",
  "peaty@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/adam_peaty.jpg",
  "dressel@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/caeleb_dressel.jpg",
  # 🏉 Rugby
  "dupont@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/antoine_dupont.jpg",
  "mounga@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/richie_mounga.jpg",
  # 🏏 Cricket
  "kohli@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/virat_kohli.jpg",
  "bumrah@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/jasprit_bumrah.jpg",
  # 🤸 Gymnastics
  "biles@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/simone_biles.jpg",
  "yulo@example.com"         => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/carlos_yulo.jpg",
  # 🏈 American Football
  "mahomes@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/patrick_mahomes.jpg",
  "kelce@example.com"        => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/travis_kelce.jpg",
  # ⚾ Baseball
  "ohtani@example.com"       => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/shohei_ohtani.jpg",
  # 🚴 Cycling
  "pogacar@example.com"      => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/tadej_pogacar.jpg",
  # ⛳ Golf
  "rahm@example.com"         => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/jon_rahm.jpg",
  # 🏐 Volleyball
  "wilfredoleon@example.com" => "https://res.cloudinary.com/dfwfflxnp/image/upload/celebrities/wilfredo_leon.jpg"
}.freeze

male_photo_index   = 1
female_photo_index = 1

users.each do |attrs|
  user    = User.create!(email: attrs[:email], password: attrs[:password], admin: attrs[:admin] || false)
  profile = user.create_user_profile!(attrs[:profile])

  gender = attrs[:profile][:gender]

  photo_url = if (cloudinary_url = CELEBRITY_CLOUDINARY_URLS[attrs[:email]])
    cloudinary_url
  elsif gender == "male"
    "https://randomuser.me/api/portraits/men/#{male_photo_index}.jpg".tap { male_photo_index += 1 }
  else
    "https://randomuser.me/api/portraits/women/#{female_photo_index}.jpg".tap { female_photo_index += 1 }
  end

  filename = "#{attrs[:profile][:name].downcase.gsub(' ', '_')}.jpg"
  begin
    profile.photo.attach(io: URI.open(photo_url), filename: filename, content_type: "image/jpeg")
  rescue => e
    puts "  ⚠ Could not attach photo for #{attrs[:profile][:name]}: #{e.message}"
  end
end

puts "Created #{User.count} users with profiles"

# --- Exercises ---

# CHEST
push_up           = Exercise.create!(title: "Push-Up",           description: "Classic bodyweight push exercise targeting chest, shoulders, and triceps.", target_muscle: "Chest",     equipment: "None",       difficulty: "Beginner")
incline_push_up   = Exercise.create!(title: "Incline Push-Up",   description: "Push-up variation using an elevated surface to reduce difficulty.",        target_muscle: "Chest",     equipment: "Bench/Wall", difficulty: "Beginner")
bench_press       = Exercise.create!(title: "Bench Press",        description: "Barbell press performed on a flat bench for chest strength.",              target_muscle: "Chest",     equipment: "Barbell",    difficulty: "Intermediate")

# BACK
pull_up           = Exercise.create!(title: "Pull-Up",            description: "Upper body pulling exercise using a bar.",                                 target_muscle: "Back",      equipment: "Pull-Up Bar", difficulty: "Intermediate")
australian_row    = Exercise.create!(title: "Australian Row",      description: "Horizontal bodyweight row performed under a low bar.",                    target_muscle: "Back",      equipment: "Low Bar",    difficulty: "Beginner")
one_arm_row       = Exercise.create!(title: "One-Arm Dumbbell Row", description: "Unilateral rowing movement for back strength.",                         target_muscle: "Back",      equipment: "Dumbbell",   difficulty: "Beginner")

# LEGS
air_squat         = Exercise.create!(title: "Air Squat",          description: "Bodyweight squat for general lower body strength.",                       target_muscle: "Legs",      equipment: "None",       difficulty: "Beginner")
walking_lunge     = Exercise.create!(title: "Walking Lunge",      description: "Dynamic lunge movement for legs and balance.",                            target_muscle: "Legs",      equipment: "None",       difficulty: "Beginner")
bulgarian_squat   = Exercise.create!(title: "Bulgarian Split Squat", description: "Single-leg squat with rear foot elevated.",                           target_muscle: "Legs",      equipment: "Bench",      difficulty: "Intermediate")
romanian_deadlift = Exercise.create!(title: "Romanian Deadlift",  description: "Hip hinge movement targeting hamstrings and glutes.",                     target_muscle: "Hamstrings", equipment: "Barbell",   difficulty: "Intermediate")

# SHOULDERS
pike_push_up      = Exercise.create!(title: "Pike Push-Up",       description: "Bodyweight shoulder press variation.",                                    target_muscle: "Shoulders", equipment: "None",       difficulty: "Intermediate")
db_shoulder_press = Exercise.create!(title: "Dumbbell Shoulder Press", description: "Overhead pressing movement for shoulder strength.",                  target_muscle: "Shoulders", equipment: "Dumbbells",  difficulty: "Beginner")

# ARMS
bicep_curl        = Exercise.create!(title: "Bicep Curl",         description: "Isolation movement for biceps.",                                          target_muscle: "Biceps",    equipment: "Dumbbells",  difficulty: "Beginner")
tricep_dips       = Exercise.create!(title: "Tricep Dips",        description: "Bodyweight pushing exercise targeting triceps.",                          target_muscle: "Triceps",   equipment: "Bench",      difficulty: "Beginner")

# CORE
plank             = Exercise.create!(title: "Plank",              description: "Isometric core stability exercise.",                                      target_muscle: "Core",      equipment: "None",       difficulty: "Beginner")
leg_raises        = Exercise.create!(title: "Leg Raises",         description: "Core exercise targeting lower abs.",                                      target_muscle: "Core",      equipment: "None",       difficulty: "Beginner")
russian_twist     = Exercise.create!(title: "Russian Twist",      description: "Rotational core exercise for obliques.",                                  target_muscle: "Core",      equipment: "None",       difficulty: "Beginner")

# FULL BODY
burpee            = Exercise.create!(title: "Burpee",             description: "Full body explosive cardio and strength movement.",                       target_muscle: "Full Body", equipment: "None",       difficulty: "Intermediate")
kettlebell_swing  = Exercise.create!(title: "Kettlebell Swing",   description: "Hip hinge explosive movement for full body power.",                       target_muscle: "Full Body", equipment: "Kettlebell", difficulty: "Intermediate")

# CARDIO
running           = Exercise.create!(title: "Running",            description: "Steady-state cardiovascular endurance training.",                         target_muscle: "Cardio",    equipment: "None",       difficulty: "Beginner")
jump_rope         = Exercise.create!(title: "Jump Rope",          description: "High intensity cardio using a skipping rope.",                            target_muscle: "Cardio",    equipment: "Jump Rope",  difficulty: "Beginner")

# CHEST (additional)
dumbbell_fly      = Exercise.create!(title: "Dumbbell Fly",         description: "Wide arc movement lying on a bench to stretch and contract the chest.",   target_muscle: "Chest",     equipment: "Dumbbells",        difficulty: "Intermediate")
decline_push_up   = Exercise.create!(title: "Decline Push-Up",      description: "Push-up with feet elevated to increase difficulty and upper-chest load.", target_muscle: "Chest",     equipment: "Bench",            difficulty: "Intermediate")

# BACK (additional)
lat_pulldown      = Exercise.create!(title: "Lat Pulldown",          description: "Cable machine pulling exercise for lat width.",                          target_muscle: "Back",      equipment: "Cable Machine",    difficulty: "Beginner")
seated_cable_row  = Exercise.create!(title: "Seated Cable Row",      description: "Horizontal pulling movement on a cable machine for mid-back thickness.", target_muscle: "Back",      equipment: "Cable Machine",    difficulty: "Beginner")
inverted_row      = Exercise.create!(title: "Inverted Row",          description: "Bodyweight horizontal row using a low bar — scalable pulling exercise.", target_muscle: "Back",      equipment: "Barbell/Low Bar",  difficulty: "Beginner")
face_pull         = Exercise.create!(title: "Face Pull",             description: "Cable rear-delt exercise that also improves shoulder health.",           target_muscle: "Shoulders", equipment: "Cable Machine",    difficulty: "Beginner")

# LEGS (additional)
leg_press         = Exercise.create!(title: "Leg Press",             description: "Machine-based quad-dominant pushing movement.",                          target_muscle: "Legs",      equipment: "Leg Press Machine", difficulty: "Beginner")
goblet_squat      = Exercise.create!(title: "Goblet Squat",          description: "Front-loaded squat holding a kettlebell or dumbbell at chest height.",   target_muscle: "Legs",      equipment: "Kettlebell",       difficulty: "Beginner")
calf_raise        = Exercise.create!(title: "Calf Raise",            description: "Isolation exercise for the calves performed standing or seated.",        target_muscle: "Calves",    equipment: "None",             difficulty: "Beginner")
hip_thrust        = Exercise.create!(title: "Hip Thrust",            description: "Glute-dominant exercise with upper back resting on a bench.",            target_muscle: "Glutes",    equipment: "Barbell/Bench",    difficulty: "Intermediate")
nordic_curl       = Exercise.create!(title: "Nordic Hamstring Curl", description: "Advanced partner-assisted hamstring exercise performed on the floor.",   target_muscle: "Hamstrings", equipment: "Partner/Anchor",  difficulty: "Advanced")

# SHOULDERS (additional)
lateral_raise     = Exercise.create!(title: "Lateral Raise",         description: "Dumbbell arc movement to isolate the lateral deltoid.",                  target_muscle: "Shoulders", equipment: "Dumbbells",        difficulty: "Beginner")
front_raise       = Exercise.create!(title: "Front Raise",           description: "Forward dumbbell raise targeting the anterior deltoid.",                 target_muscle: "Shoulders", equipment: "Dumbbells",        difficulty: "Beginner")

# ARMS (additional)
hammer_curl       = Exercise.create!(title: "Hammer Curl",           description: "Neutral-grip curl targeting brachialis and brachioradialis.",            target_muscle: "Biceps",    equipment: "Dumbbells",        difficulty: "Beginner")
skull_crusher     = Exercise.create!(title: "Skull Crusher",         description: "Lying tricep extension with EZ bar or dumbbells.",                      target_muscle: "Triceps",   equipment: "EZ Bar",           difficulty: "Intermediate")

# CORE (additional)
mountain_climber  = Exercise.create!(title: "Mountain Climber",      description: "Dynamic plank variation driving knees to chest for core and cardio.",    target_muscle: "Core",      equipment: "None",             difficulty: "Intermediate")
hanging_knee_raise = Exercise.create!(title: "Hanging Knee Raise",   description: "Hanging ab exercise bringing knees to chest to target the lower abs.",  target_muscle: "Core",      equipment: "Pull-Up Bar",      difficulty: "Intermediate")

# FULL BODY (additional)
deadlift          = Exercise.create!(title: "Deadlift",              description: "Foundational barbell hip-hinge for total posterior chain strength.",     target_muscle: "Full Body", equipment: "Barbell",          difficulty: "Intermediate")
box_jump          = Exercise.create!(title: "Box Jump",              description: "Explosive plyometric jump onto a raised platform for power development.", target_muscle: "Full Body", equipment: "Plyo Box",         difficulty: "Intermediate")

# CARDIO (additional)
cycling           = Exercise.create!(title: "Cycling",               description: "Low-impact aerobic exercise on a bike — stationary or outdoor.",          target_muscle: "Cardio",    equipment: "Bike",             difficulty: "Beginner")
rowing_machine    = Exercise.create!(title: "Rowing Machine",        description: "Full-body cardio machine targeting legs, back, and arms in sequence.",    target_muscle: "Cardio",    equipment: "Rowing Machine",   difficulty: "Beginner")
high_knees        = Exercise.create!(title: "High Knees",            description: "Running on the spot with exaggerated knee drive for cardio and hip flex.", target_muscle: "Cardio",    equipment: "None",             difficulty: "Beginner")
jumping_jacks     = Exercise.create!(title: "Jumping Jacks",         description: "Classic full-body warm-up and light cardio movement.",                   target_muscle: "Cardio",    equipment: "None",             difficulty: "Beginner")
sprint_intervals  = Exercise.create!(title: "Sprint Intervals",      description: "Short all-out sprints alternated with recovery jogs to build speed.",     target_muscle: "Cardio",    equipment: "None",             difficulty: "Intermediate")
battle_ropes      = Exercise.create!(title: "Battle Ropes",          description: "High-intensity upper-body and cardio exercise using heavy ropes.",        target_muscle: "Cardio",    equipment: "Battle Ropes",     difficulty: "Intermediate")
stair_climber     = Exercise.create!(title: "Stair Climber",         description: "Continuous stair-stepping machine for glutes, quads, and cardio.",        target_muscle: "Cardio",    equipment: "Stair Climber",    difficulty: "Beginner")

# RECOVERY & STRETCHING
downward_dog      = Exercise.create!(title: "Downward Dog",          description: "Yoga pose that stretches the hamstrings, calves, and spine simultaneously.", target_muscle: "Flexibility", equipment: "Yoga Mat",        difficulty: "Beginner")
childs_pose       = Exercise.create!(title: "Child's Pose",          description: "Restorative yoga stretch decompressing the lower back and hips.",          target_muscle: "Flexibility", equipment: "Yoga Mat",        difficulty: "Beginner")
hip_flexor_stretch = Exercise.create!(title: "Hip Flexor Stretch",   description: "Kneeling lunge position to open tight hip flexors after sitting or squats.", target_muscle: "Flexibility", equipment: "None",           difficulty: "Beginner")
pigeon_pose       = Exercise.create!(title: "Pigeon Pose",           description: "Deep hip opener targeting the glutes and piriformis.",                     target_muscle: "Flexibility", equipment: "Yoga Mat",        difficulty: "Intermediate")
seated_hamstring  = Exercise.create!(title: "Seated Hamstring Stretch", description: "Sitting with legs extended, reaching forward to lengthen the hamstrings.", target_muscle: "Flexibility", equipment: "None",          difficulty: "Beginner")
cat_cow           = Exercise.create!(title: "Cat-Cow Stretch",       description: "Flowing spinal movement on all-fours to warm up and mobilise the back.",   target_muscle: "Flexibility", equipment: "Yoga Mat",        difficulty: "Beginner")
chest_opener      = Exercise.create!(title: "Chest Opener Stretch",  description: "Arms clasped behind the back, lifting to stretch the pecs and shoulders.", target_muscle: "Flexibility", equipment: "None",            difficulty: "Beginner")
spinal_twist      = Exercise.create!(title: "Seated Spinal Twist",   description: "Rotational stretch improving thoracic mobility and easing lower back pain.", target_muscle: "Flexibility", equipment: "None",           difficulty: "Beginner")
foam_roll_quads   = Exercise.create!(title: "Foam Roll — Quads",     description: "Self-myofascial release of the quadriceps to reduce soreness post-training.", target_muscle: "Flexibility", equipment: "Foam Roller",   difficulty: "Beginner")
foam_roll_back    = Exercise.create!(title: "Foam Roll — Upper Back", description: "Thoracic spine mobilisation using a foam roller to release tension.",     target_muscle: "Flexibility", equipment: "Foam Roller",     difficulty: "Beginner")

puts "Created #{Exercise.count} exercises"

# --- Exercise Embeddings ---

puts "Embedding exercises. This might take a while..."

Exercise.find_each do |exercise|
  text = "#{exercise.title}. #{exercise.description} Targets: #{exercise.target_muscle}. Equipment: #{exercise.equipment}. Difficulty: #{exercise.difficulty}."
  embedding = RubyLLM.embed(text, provider: :openai, assume_model_exists: true)
  exercise.update!(embedding: embedding.vectors)
end

puts "Embedded #{Exercise.count} exercises"

# --- Requests ---

carl    = User.find_by!(email: "carl@example.com")
sam     = User.find_by!(email: "sam@example.com")
jordan  = User.find_by!(email: "jordan@example.com")
maria   = User.find_by!(email: "maria@example.com")
tom     = User.find_by!(email: "tom@example.com")
priya   = User.find_by!(email: "priya@example.com")
marcus  = User.find_by!(email: "marcus@example.com")
adriano = User.find_by!(email: "adriano@example.com")
leila   = User.find_by!(email: "leila@example.com")
ryan    = User.find_by!(email: "ryan@example.com")

Request.create!([
  { sender: carl,   recipient: sam,    status: :accepted, message: "Hey Sam! Would love to train together — our goals seem compatible." },
  { sender: carl,   recipient: leila,  status: :accepted, message: "Hi Leila! Fellow muscle-gainer here. Want to team up?" },
  { sender: jordan, recipient: tom,    status: :accepted, message: "Tom, advanced lifters need advanced partners. Let's do this." },
  { sender: priya,  recipient: adriano, status: :accepted, message: "Adriano, I think we'd push each other well. Interested?" },
  { sender: marcus, recipient: ryan,   status: :pending,  message: "Ryan! Both of us are just starting out — let's learn together." },
  { sender: sam,    recipient: jordan, status: :denied,   message: "Jordan, would you be open to training with a beginner?" },
  { sender: tom,    recipient: maria,  status: :pending,  message: "Hey Maria, happy to help you build a solid foundation!" },
  { sender: leila,  recipient: priya,  status: :pending,  message: "Priya, I think I can help push your training to the next level." }
])

puts "Created #{Request.count} requests"

# --- Pairings ---

def pair_score(u1, u2)
  p1 = u1.user_profile
  p2 = u2.user_profile
  PairScoreCalculator.new(p1, p2).call if p1 && p2
end

pairing_carl_sam    = Pairing.create!(user1: carl,  user2: sam,   pair_score: pair_score(carl,  sam))
pairing_carl_leila  = Pairing.create!(user1: carl,  user2: leila, pair_score: pair_score(carl,  leila))
pairing_jordan_tom  = Pairing.create!(user1: jordan, user2: tom,   pair_score: pair_score(jordan, tom))
pairing_priya_adriano = Pairing.create!(user1: priya,  user2: adriano, pair_score: pair_score(priya,  adriano))

puts "Created #{Pairing.count} pairings"

# --- WorkoutPlans ---

# Carl & Sam — beginner-friendly plans
plan1 = WorkoutPlan.create!(
  pairing: pairing_carl_sam,
  title: "Beginner Full Body Blast",
  description: "A bodyweight circuit to build a foundation in all major muscle groups."
)
[
  [push_up,        3, 15, 60],
  [air_squat,      3, 20, 60],
  [walking_lunge,  3, 12, 60],
  [plank,          3, 45, 45],
  [russian_twist,  3, 20, 45]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan1, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

plan2 = WorkoutPlan.create!(
  pairing: pairing_carl_sam,
  title: "Cardio & Core",
  description: "Light cardio paired with core work — great for fat loss and stamina."
)
[
  [running,    1, 20, 120],
  [jump_rope,  3, 60,  60],
  [leg_raises, 3, 15,  45],
  [plank,      3, 45,  45]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan2, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

# Carl & Leila — muscle-building focus
plan3 = WorkoutPlan.create!(
  pairing: pairing_carl_leila,
  title: "Muscle Builder Program",
  description: "Compound lifts and isolation work to maximise hypertrophy."
)
[
  [bench_press,       4,  8, 120],
  [pull_up,           4,  6, 120],
  [romanian_deadlift, 3, 10,  90],
  [bicep_curl,        3, 12,  60],
  [tricep_dips,       3, 12,  60]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan3, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

plan4 = WorkoutPlan.create!(
  pairing: pairing_carl_leila,
  title: "Upper Body Strength",
  description: "Focused upper-body session hitting chest, back, and shoulders."
)
[
  [incline_push_up,   3, 15, 60],
  [australian_row,    3, 12, 60],
  [pike_push_up,      3, 10, 75],
  [one_arm_row,       3, 10, 60],
  [db_shoulder_press, 3, 12, 75]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan4, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

# Jordan & Tom — advanced endurance and strength
plan5 = WorkoutPlan.create!(
  pairing: pairing_jordan_tom,
  title: "Advanced Endurance Circuit",
  description: "High-intensity circuit designed to build aerobic capacity and functional strength."
)
[
  [burpee,           4, 10,  45],
  [kettlebell_swing, 4, 15,  60],
  [running,          1, 30, 180],
  [jump_rope,        3, 90,  60],
  [bulgarian_squat,  3, 10,  90]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan5, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

# Priya & adriano — general fitness
plan6 = WorkoutPlan.create!(
  pairing: pairing_priya_adriano,
  title: "General Fitness Starter",
  description: "A balanced mix of strength and cardio movements suitable for intermediate athletes."
)
[
  [air_squat,         3, 15, 60],
  [walking_lunge,     3, 12, 60],
  [db_shoulder_press, 3, 12, 75],
  [plank,             3, 40, 45],
  [one_arm_row,       3, 10, 60]
].each do |ex, sets, reps, rest|
  WorkoutPlanExercise.create!(workout_plan: plan6, exercise: ex, n_sets: sets, n_repetitions: reps, rest_in_s: rest)
end

puts "Created #{WorkoutPlan.count} workout plans with #{WorkoutPlanExercise.count} exercises"

# --- Calendars & Calendar Entries ---

# d0–d4 are the next 5 days from today so entries are always in the future.
d0 = Date.today + 1
d1 = Date.today + 2
d2 = Date.today + 3
d3 = Date.today + 4
d4 = Date.today + 5

cal_carl    = Calendar.create!(user: carl)
cal_sam     = Calendar.create!(user: sam)
cal_leila   = Calendar.create!(user: leila)
cal_jordan  = Calendar.create!(user: jordan)
cal_tom     = Calendar.create!(user: tom)
cal_priya   = Calendar.create!(user: priya)
cal_adriano = Calendar.create!(user: adriano)

# Carl & Sam — Beginner Full Body Blast / Cardio & Core
[cal_carl, cal_sam].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan1,
    title: "Full Body Blast with Partner",
    entry_type: "workout",
    location: "FitBase Berlin, Kastanienallee",
    start_time: d0.in_time_zone.change(hour: 7,  min: 0),
    end_time:   d0.in_time_zone.change(hour: 8,  min: 0),
    note: "Beginner Full Body Blast — push-ups, squats, lunges, plank."
  )
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan2,
    title: "Cardio & Core Session",
    entry_type: "workout",
    location: "Volkspark Friedrichshain, Berlin",
    start_time: d2.in_time_zone.change(hour: 18, min: 0),
    end_time:   d2.in_time_zone.change(hour: 19, min: 0),
    note: "Running + jump rope + leg raises + plank."
  )
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan1,
    title: "Full Body Blast with Partner",
    entry_type: "workout",
    location: "FitBase Berlin, Kastanienallee",
    start_time: d4.in_time_zone.change(hour: 7,  min: 0),
    end_time:   d4.in_time_zone.change(hour: 8,  min: 0),
    note: "Beginner Full Body Blast — push-ups, squats, lunges, plank."
  )
end

# Carl & Leila — Muscle Builder / Upper Body Strength
[cal_carl, cal_leila].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan3,
    title: "Muscle Builder Session",
    entry_type: "workout",
    location: "Olympia Gym Berlin, Mitte",
    start_time: d1.in_time_zone.change(hour: 19, min: 0),
    end_time:   d1.in_time_zone.change(hour: 20, min: 30),
    note: "Bench press, pull-ups, Romanian deadlift, bicep curls, tricep dips."
  )
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan4,
    title: "Upper Body Strength",
    entry_type: "workout",
    location: "Olympia Gym Berlin, Mitte",
    start_time: d3.in_time_zone.change(hour: 19, min: 0),
    end_time:   d3.in_time_zone.change(hour: 20, min: 30),
    note: "Incline push-up, Australian row, pike push-up, one-arm row, shoulder press."
  )
end

# Jordan & Tom — Advanced Endurance Circuit
[cal_jordan, cal_tom].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan5,
    title: "Advanced Endurance Circuit",
    entry_type: "workout",
    location: "Tempelhof Airfield, Berlin",
    start_time: d0.in_time_zone.change(hour: 6,  min: 0),
    end_time:   d0.in_time_zone.change(hour: 7,  min: 30),
    note: "Burpees, kettlebell swings, 30-min run, jump rope, Bulgarian squats."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Recovery Run",
    entry_type: "workout",
    location: "Tiergarten, Berlin",
    start_time: d2.in_time_zone.change(hour: 6,  min: 0),
    end_time:   d2.in_time_zone.change(hour: 7,  min: 0),
    note: "Easy-pace run to aid recovery between circuit sessions."
  )
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan5,
    title: "Advanced Endurance Circuit",
    entry_type: "workout",
    location: "Tempelhof Airfield, Berlin",
    start_time: d4.in_time_zone.change(hour: 6,  min: 0),
    end_time:   d4.in_time_zone.change(hour: 7,  min: 30),
    note: "Burpees, kettlebell swings, 30-min run, jump rope, Bulgarian squats."
  )
end

# Priya & adriano — General Fitness Starter
[cal_priya, cal_adriano].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan6,
    title: "General Fitness Session",
    entry_type: "workout",
    location: "SportPark Mitte, Berlin",
    start_time: d1.in_time_zone.change(hour: 18, min: 30),
    end_time:   d1.in_time_zone.change(hour: 19, min: 30),
    note: "Air squats, walking lunges, shoulder press, plank, one-arm row."
  )
  CalendarEntry.create!(
    calendar: cal,
    workout_plan: plan6,
    title: "General Fitness Session",
    entry_type: "workout",
    location: "SportPark Mitte, Berlin",
    start_time: d3.in_time_zone.change(hour: 18, min: 30),
    end_time:   d3.in_time_zone.change(hour: 19, min: 30),
    note: "Air squats, walking lunges, shoulder press, plank, one-arm row."
  )
end

puts "Created #{Calendar.count} calendars with #{CalendarEntry.count} entries"
