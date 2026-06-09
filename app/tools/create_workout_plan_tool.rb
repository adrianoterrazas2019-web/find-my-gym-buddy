class CreateWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, a professional fitness coach creating a personalized workout plan for a gym pair.

    Based on the user's request, their profiles, and the exercises listed below, generate:
    - Title: if the user requested a specific title, use it EXACTLY as stated. Otherwise create a short, motivating title.
    - Description: cover the session goals, target muscle groups, overall difficulty, and how it suits the pair's experience and goals.

    Calibrate sets, reps, and rest to match the requested intensity and each user's experience:
    - High intensity / hardcore: 4–5 sets, higher reps, short rest (30–60s)
    - Moderate: 3–4 sets, moderate reps, 60–90s rest
    - Low intensity / restorative / chill: 2–3 sets, lower reps, long rest (90–120s)
    Beginners need fewer sets and more rest than advanced athletes.
  PROMPT

  description "Creates a personalized workout plan for a gym pair by finding the most relevant exercises " \
              "via semantic search. Call this when the pair asks for a custom workout plan."

  param :user_request, desc: "The user's full request for the workout plan, including any specified title, " \
                             "desired intensity (e.g. 'hardcore', 'chill', 'restorative'), focus areas, " \
                             "and constraints. Preserve the user's exact wording, especially any requested title."
  param :n_exercises, type: :integer, desc: "Number of exercises to include, " \
                                            "estimated from the pair's experience and goals (typically 4–8)"

  def initialize(pairing:)
    @pairing = pairing
  end

  def execute(user_request:, n_exercises:)
    Rails.logger.info("[CreateWorkoutPlanTool] Executing pairing_id=#{@pairing.id} n_exercises=#{n_exercises} request=#{user_request.truncate(120)}")

    embedding = RubyLLM.embed(user_request, provider: :openai, assume_model_exists: true).vectors
    exercises = Exercise.nearest_neighbors(:embedding, embedding, distance: "cosine").first(n_exercises)

    Rails.logger.info("[CreateWorkoutPlanTool] Found #{exercises.size} exercises, calling LLM for plan schema")
    chat = RubyLLM.chat

    plan_prompt = <<~PROMPT
      #{TOOL_SYSTEM_PROMPT}

      User request: "#{user_request}"

      User profiles:
      #{profiles_as_str}

      Available exercises:
      #{exercises_as_str(exercises)}
    PROMPT

    plan_response = chat.with_schema(WorkoutPlanSchema).ask(plan_prompt)

    plan = WorkoutPlan.new(plan_response.content)
    plan.pairing = @pairing
    plan.save!

    Rails.logger.info("[CreateWorkoutPlanTool] Plan '#{plan.title}' saved (id=#{plan.id}), building #{exercises.size} exercises")
    exercises.each_with_index do |exercise, i|
      Rails.logger.info("[CreateWorkoutPlanTool] Exercise #{i + 1}/#{exercises.size}: #{exercise.title}")
      exercise_response = chat.with_schema(WorkoutPlanExerciseSchema).ask(
        "Exercise: #{exercise.title} (#{exercise.difficulty}, targets #{exercise.target_muscle})\n\n" \
        "Plan: #{plan.title} — #{plan.description}\n" \
        "User request: \"#{user_request}\"\n" \
        "User profiles:\n#{profiles_as_str}\n\n" \
        "Recommend sets, reps, and rest in seconds that match the requested intensity and the users' experience level."
      )
      WorkoutPlanExercise.create!(
        workout_plan: plan,
        exercise: exercise,
        n_sets: exercise_response.content["n_sets"],
        n_repetitions: exercise_response.content["n_repetitions"],
        rest_in_s: exercise_response.content["rest_in_s"]
      )
    end

    "Workout plan '#{plan.title}' saved with #{exercises.count} exercises."
  rescue => e
    Rails.logger.error("[CreateWorkoutPlanTool] Failed pairing_id=#{@pairing.id}: #{e.class}: #{e.message}\n#{e.backtrace&.first(10)&.join("\n")}")
    "Error creating workout plan: #{e.message}"
  end

  private

  def profiles_as_str
    [@pairing.user1, @pairing.user2].filter_map do |user|
      p = user.user_profile
      next unless p
      age = ((Date.today - p.birthdate) / 365.25).to_i
      "- #{p.name}, #{age}yo, #{p.gender}. Goal: #{p.goal}. Experience: #{p.experience}."
    end.join("\n").presence || "No profiles available."
  end

  def exercises_as_str(exercises)
    exercises.map do |e|
      "- #{e.title} (#{e.difficulty}, targets: #{e.target_muscle}, equipment: #{e.equipment}): #{e.description}"
    end.join("\n")
  end
end
