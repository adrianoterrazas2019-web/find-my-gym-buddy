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
      address: "123 Main St, Austin, TX",
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
      address: "456 Oak Ave, Austin, TX",
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
      address: "789 Pine Rd, Austin, TX",
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
      address: "22 Sunset Blvd, Los Angeles, CA",
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
      address: "55 Harbor Dr, Los Angeles, CA",
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
      address: "10 Broadway, New York, NY",
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
      address: "300 Park Ave, New York, NY",
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
      address: "88 Lake Shore Dr, Chicago, IL",
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
      address: "200 Elm St, Austin, TX",
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
      address: "44 Maple Ave, Chicago, IL",
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

exercises = [
  # CHEST
  {
    title: "Push-Up",
    description: "Classic bodyweight push exercise targeting chest, shoulders, and triceps.",
    target_muscle: "Chest",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Incline Push-Up",
    description: "Push-up variation using an elevated surface to reduce difficulty.",
    target_muscle: "Chest",
    equipment: "Bench/Wall",
    difficulty: "Beginner"
  },
  {
    title: "Bench Press",
    description: "Barbell press performed on a flat bench for chest strength.",
    target_muscle: "Chest",
    equipment: "Barbell",
    difficulty: "Intermediate"
  },

  # BACK
  {
    title: "Pull-Up",
    description: "Upper body pulling exercise using a bar.",
    target_muscle: "Back",
    equipment: "Pull-Up Bar",
    difficulty: "Intermediate"
  },
  {
    title: "Australian Row",
    description: "Horizontal bodyweight row performed under a low bar.",
    target_muscle: "Back",
    equipment: "Low Bar",
    difficulty: "Beginner"
  },
  {
    title: "One-Arm Dumbbell Row",
    description: "Unilateral rowing movement for back strength.",
    target_muscle: "Back",
    equipment: "Dumbbell",
    difficulty: "Beginner"
  },

  # LEGS
  {
    title: "Air Squat",
    description: "Bodyweight squat for general lower body strength.",
    target_muscle: "Legs",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Walking Lunge",
    description: "Dynamic lunge movement for legs and balance.",
    target_muscle: "Legs",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Bulgarian Split Squat",
    description: "Single-leg squat with rear foot elevated.",
    target_muscle: "Legs",
    equipment: "Bench",
    difficulty: "Intermediate"
  },
  {
    title: "Romanian Deadlift",
    description: "Hip hinge movement targeting hamstrings and glutes.",
    target_muscle: "Hamstrings",
    equipment: "Barbell",
    difficulty: "Intermediate"
  },

  # SHOULDERS
  {
    title: "Pike Push-Up",
    description: "Bodyweight shoulder press variation.",
    target_muscle: "Shoulders",
    equipment: "None",
    difficulty: "Intermediate"
  },
  {
    title: "Dumbbell Shoulder Press",
    description: "Overhead pressing movement for shoulder strength.",
    target_muscle: "Shoulders",
    equipment: "Dumbbells",
    difficulty: "Beginner"
  },

  # ARMS
  {
    title: "Bicep Curl",
    description: "Isolation movement for biceps.",
    target_muscle: "Biceps",
    equipment: "Dumbbells",
    difficulty: "Beginner"
  },
  {
    title: "Tricep Dips",
    description: "Bodyweight pushing exercise targeting triceps.",
    target_muscle: "Triceps",
    equipment: "Bench",
    difficulty: "Beginner"
  },

  # CORE
  {
    title: "Plank",
    description: "Isometric core stability exercise.",
    target_muscle: "Core",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Leg Raises",
    description: "Core exercise targeting lower abs.",
    target_muscle: "Core",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Russian Twist",
    description: "Rotational core exercise for obliques.",
    target_muscle: "Core",
    equipment: "None",
    difficulty: "Beginner"
  },

  # FULL BODY
  {
    title: "Burpee",
    description: "Full body explosive cardio and strength movement.",
    target_muscle: "Full Body",
    equipment: "None",
    difficulty: "Intermediate"
  },
  {
    title: "Kettlebell Swing",
    description: "Hip hinge explosive movement for full body power.",
    target_muscle: "Full Body",
    equipment: "Kettlebell",
    difficulty: "Intermediate"
  },

  # CARDIO
  {
    title: "Running",
    description: "Steady-state cardiovascular endurance training.",
    target_muscle: "Cardio",
    equipment: "None",
    difficulty: "Beginner"
  },
  {
    title: "Jump Rope",
    description: "High intensity cardio using a skipping rope.",
    target_muscle: "Cardio",
    equipment: "Jump Rope",
    difficulty: "Beginner"
  }
]
Exercise.create!(exercises)

puts "Created #{Exercise.count} exercises"

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

push_up            = Exercise.find_by!(title: "Push-Up")
incline_push_up    = Exercise.find_by!(title: "Incline Push-Up")
bench_press        = Exercise.find_by!(title: "Bench Press")
pull_up            = Exercise.find_by!(title: "Pull-Up")
australian_row     = Exercise.find_by!(title: "Australian Row")
one_arm_row        = Exercise.find_by!(title: "One-Arm Dumbbell Row")
air_squat          = Exercise.find_by!(title: "Air Squat")
walking_lunge      = Exercise.find_by!(title: "Walking Lunge")
bulgarian_squat    = Exercise.find_by!(title: "Bulgarian Split Squat")
romanian_deadlift  = Exercise.find_by!(title: "Romanian Deadlift")
pike_push_up       = Exercise.find_by!(title: "Pike Push-Up")
db_shoulder_press  = Exercise.find_by!(title: "Dumbbell Shoulder Press")
bicep_curl         = Exercise.find_by!(title: "Bicep Curl")
tricep_dips        = Exercise.find_by!(title: "Tricep Dips")
plank              = Exercise.find_by!(title: "Plank")
leg_raises         = Exercise.find_by!(title: "Leg Raises")
russian_twist      = Exercise.find_by!(title: "Russian Twist")
burpee             = Exercise.find_by!(title: "Burpee")
kettlebell_swing   = Exercise.find_by!(title: "Kettlebell Swing")
running            = Exercise.find_by!(title: "Running")
jump_rope          = Exercise.find_by!(title: "Jump Rope")

# Alex & Sam — beginner-friendly plans
plan1 = WorkoutPlan.create!(
  pairing: pairing_alex_sam,
  title: "Beginner Full Body Blast",
  description: "A bodyweight circuit to build a foundation in all major muscle groups."
)
[push_up, air_squat, walking_lunge, plank, russian_twist].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan1, exercise: ex)
end

plan2 = WorkoutPlan.create!(
  pairing: pairing_alex_sam,
  title: "Cardio & Core",
  description: "Light cardio paired with core work — great for fat loss and stamina."
)
[running, jump_rope, leg_raises, plank].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan2, exercise: ex)
end

# Alex & Leila — muscle-building focus
plan3 = WorkoutPlan.create!(
  pairing: pairing_alex_leila,
  title: "Muscle Builder Program",
  description: "Compound lifts and isolation work to maximise hypertrophy."
)
[bench_press, pull_up, romanian_deadlift, bicep_curl, tricep_dips].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan3, exercise: ex)
end

plan4 = WorkoutPlan.create!(
  pairing: pairing_alex_leila,
  title: "Upper Body Strength",
  description: "Focused upper-body session hitting chest, back, and shoulders."
)
[incline_push_up, australian_row, pike_push_up, one_arm_row, db_shoulder_press].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan4, exercise: ex)
end

# Jordan & Tom — advanced endurance and strength
plan5 = WorkoutPlan.create!(
  pairing: pairing_jordan_tom,
  title: "Advanced Endurance Circuit",
  description: "High-intensity circuit designed to build aerobic capacity and functional strength."
)
[burpee, kettlebell_swing, running, jump_rope, bulgarian_squat].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan5, exercise: ex)
end

# Priya & Casey — general fitness
plan6 = WorkoutPlan.create!(
  pairing: pairing_priya_casey,
  title: "General Fitness Starter",
  description: "A balanced mix of strength and cardio movements suitable for intermediate athletes."
)
[air_squat, walking_lunge, db_shoulder_press, plank, one_arm_row].each do |ex|
  WorkoutPlanExercise.create!(workout_plan: plan6, exercise: ex)
end

puts "Created #{WorkoutPlan.count} workout plans with #{WorkoutPlanExercise.count} exercises"
