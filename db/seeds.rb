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
