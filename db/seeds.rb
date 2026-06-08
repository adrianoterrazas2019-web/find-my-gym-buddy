# db/seeds.rb

UserProfile.destroy_all
User.destroy_all
Exercise.destroy_all

users = [
  {
    email: "alex@example.com",
    password: "password123",
    profile: {
      name: "Alex Rivera",
      birthdate: Date.new(1995, 4, 12),
      gender: "male",
      address: "Kastanienallee 12, 10435 Berlin",
      experience: "intermediate",
      goal: "gain_muscle"
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
      goal: "lose_weight"
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
      goal: "compete"
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
      goal: "general_fitness"
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
      goal: "improve_endurance"
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
      goal: "lose_weight"
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
      goal: "rehabilitate"
    }
  },
  {
    email: "casey@example.com",
    password: "password123",
    profile: {
      name: "Casey Morgan",
      birthdate: Date.new(1996, 8, 22),
      gender: "other",
      address: "Rudower Chaussee 3, 12489 Berlin",
      experience: "intermediate",
      goal: "general_fitness"
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
      goal: "gain_muscle"
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
      goal: "improve_endurance"
    }
  }
]

users.each do |attrs|
  user = User.create!(email: attrs[:email], password: attrs[:password])
  user.create_user_profile!(attrs[:profile])
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

alex   = User.find_by!(email: "alex@example.com")
sam    = User.find_by!(email: "sam@example.com")
jordan = User.find_by!(email: "jordan@example.com")
maria  = User.find_by!(email: "maria@example.com")
tom    = User.find_by!(email: "tom@example.com")
priya  = User.find_by!(email: "priya@example.com")
marcus = User.find_by!(email: "marcus@example.com")
casey  = User.find_by!(email: "casey@example.com")
leila  = User.find_by!(email: "leila@example.com")
ryan   = User.find_by!(email: "ryan@example.com")

Request.create!([
  { sender: alex,   recipient: sam,    status: :accepted, message: "Hey Sam! Would love to train together — our goals seem compatible." },
  { sender: alex,   recipient: leila,  status: :accepted, message: "Hi Leila! Fellow muscle-gainer here. Want to team up?" },
  { sender: jordan, recipient: tom,    status: :accepted, message: "Tom, advanced lifters need advanced partners. Let's do this." },
  { sender: priya,  recipient: casey,  status: :accepted, message: "Casey, I think we'd push each other well. Interested?" },
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

pairing_alex_sam    = Pairing.create!(user1: alex,   user2: sam,   pair_score: pair_score(alex,   sam))
pairing_alex_leila  = Pairing.create!(user1: alex,   user2: leila, pair_score: pair_score(alex,   leila))
pairing_jordan_tom  = Pairing.create!(user1: jordan, user2: tom,   pair_score: pair_score(jordan, tom))
pairing_priya_casey = Pairing.create!(user1: priya,  user2: casey, pair_score: pair_score(priya,  casey))

puts "Created #{Pairing.count} pairings"

# --- WorkoutPlans ---

# Alex & Sam — beginner-friendly plans
plan1 = WorkoutPlan.create!(
  pairing: pairing_alex_sam,
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
  pairing: pairing_alex_sam,
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

# Alex & Leila — muscle-building focus
plan3 = WorkoutPlan.create!(
  pairing: pairing_alex_leila,
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
  pairing: pairing_alex_leila,
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

# Priya & Casey — general fitness
plan6 = WorkoutPlan.create!(
  pairing: pairing_priya_casey,
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

cal_alex   = Calendar.create!(user: alex)
cal_sam    = Calendar.create!(user: sam)
cal_leila  = Calendar.create!(user: leila)
cal_jordan = Calendar.create!(user: jordan)
cal_tom    = Calendar.create!(user: tom)
cal_priya  = Calendar.create!(user: priya)
cal_casey  = Calendar.create!(user: casey)

# Alex & Sam — Beginner Full Body Blast / Cardio & Core
[cal_alex, cal_sam].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    title: "Full Body Blast with Partner",
    entry_type: "workout",
    location: "FitBase Berlin, Kastanienallee",
    start_time: Time.zone.local(2026, 6, 3, 7, 0),
    end_time:   Time.zone.local(2026, 6, 3, 8, 0),
    note: "Beginner Full Body Blast — push-ups, squats, lunges, plank."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Cardio & Core Session",
    entry_type: "workout",
    location: "Volkspark Friedrichshain, Berlin",
    start_time: Time.zone.local(2026, 6, 5, 18, 0),
    end_time:   Time.zone.local(2026, 6, 5, 19, 0),
    note: "Running + jump rope + leg raises + plank."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Full Body Blast with Partner",
    entry_type: "workout",
    location: "FitBase Berlin, Kastanienallee",
    start_time: Time.zone.local(2026, 6, 7, 7, 0),
    end_time:   Time.zone.local(2026, 6, 7, 8, 0),
    note: "Beginner Full Body Blast — push-ups, squats, lunges, plank."
  )
end

# Alex & Leila — Muscle Builder / Upper Body Strength
[cal_alex, cal_leila].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    title: "Muscle Builder Session",
    entry_type: "workout",
    location: "Olympia Gym Berlin, Mitte",
    start_time: Time.zone.local(2026, 6, 4, 19, 0),
    end_time:   Time.zone.local(2026, 6, 4, 20, 30),
    note: "Bench press, pull-ups, Romanian deadlift, bicep curls, tricep dips."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Upper Body Strength",
    entry_type: "workout",
    location: "Olympia Gym Berlin, Mitte",
    start_time: Time.zone.local(2026, 6, 6, 19, 0),
    end_time:   Time.zone.local(2026, 6, 6, 20, 30),
    note: "Incline push-up, Australian row, pike push-up, one-arm row, shoulder press."
  )
end

# Jordan & Tom — Advanced Endurance Circuit
[cal_jordan, cal_tom].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    title: "Advanced Endurance Circuit",
    entry_type: "workout",
    location: "Tempelhof Airfield, Berlin",
    start_time: Time.zone.local(2026, 6, 3, 6, 0),
    end_time:   Time.zone.local(2026, 6, 3, 7, 30),
    note: "Burpees, kettlebell swings, 30-min run, jump rope, Bulgarian squats."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Recovery Run",
    entry_type: "workout",
    location: "Tiergarten, Berlin",
    start_time: Time.zone.local(2026, 6, 5, 6, 0),
    end_time:   Time.zone.local(2026, 6, 5, 7, 0),
    note: "Easy-pace run to aid recovery between circuit sessions."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "Advanced Endurance Circuit",
    entry_type: "workout",
    location: "Tempelhof Airfield, Berlin",
    start_time: Time.zone.local(2026, 6, 7, 6, 0),
    end_time:   Time.zone.local(2026, 6, 7, 7, 30),
    note: "Burpees, kettlebell swings, 30-min run, jump rope, Bulgarian squats."
  )
end

# Priya & Casey — General Fitness Starter
[cal_priya, cal_casey].each do |cal|
  CalendarEntry.create!(
    calendar: cal,
    title: "General Fitness Session",
    entry_type: "workout",
    location: "SportPark Mitte, Berlin",
    start_time: Time.zone.local(2026, 6, 4, 18, 30),
    end_time:   Time.zone.local(2026, 6, 4, 19, 30),
    note: "Air squats, walking lunges, shoulder press, plank, one-arm row."
  )
  CalendarEntry.create!(
    calendar: cal,
    title: "General Fitness Session",
    entry_type: "workout",
    location: "SportPark Mitte, Berlin",
    start_time: Time.zone.local(2026, 6, 6, 18, 30),
    end_time:   Time.zone.local(2026, 6, 6, 19, 30),
    note: "Air squats, walking lunges, shoulder press, plank, one-arm row."
  )
end

puts "Created #{Calendar.count} calendars with #{CalendarEntry.count} entries"
