class AddWorkoutPlanExerciseTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnie, a professional fitness coach.
    Recommend sets, repetitions, and rest in seconds for the exercise below,
    suited to the workout plan context, user profiles, and intensity preferences.

    Calibrate to the requested intensity and each user's experience:
    - High intensity / hardcore: 4–5 sets, higher reps, short rest (30–60s)
    - Moderate: 3–4 sets, moderate reps, 60–90s rest
    - Low intensity / restorative / chill: 2–3 sets, lower reps, long rest (90–120s)
    Beginners need fewer sets and more rest than advanced athletes.
  PROMPT

  description "Adds a new exercise to the current workout plan using semantic search against the exercise database. " \
              "Call this when the user asks to add an exercise, or as the second step when replacing one. " \
              "The matched exercise name comes from the database — never invent or assume a name."

  param :user_request, desc: "Description of the exercise the user wants to add, including any intensity or " \
                             "style preferences, e.g. 'add a heavy chest press' or 'include something restorative for legs'"

  def initialize(workout_plan:)
    @workout_plan = workout_plan
  end

  def execute(user_request:)
    Rails.logger.info("[AddWorkoutPlanExerciseTool] Executing workout_plan_id=#{@workout_plan.id} request=#{user_request.truncate(120)}")

    embedding = RubyLLM.embed(user_request, provider: :openai, assume_model_exists: true).vectors
    exercise = Exercise.nearest_neighbors(:embedding, embedding, distance: "cosine").first

    return "No matching exercise found." unless exercise

    Rails.logger.info("[AddWorkoutPlanExerciseTool] Matched exercise '#{exercise.title}', calling LLM for parameters")
    prompt = <<~PROMPT
      #{TOOL_SYSTEM_PROMPT}

      Exercise: #{exercise.title} (#{exercise.difficulty}, targets #{exercise.target_muscle}, equipment: #{exercise.equipment}): #{exercise.description}

      Plan: #{@workout_plan.title} — #{@workout_plan.description}
      User request: "#{user_request}"
      User profiles:
      #{profiles_as_str}
    PROMPT

    response = RubyLLM.chat.with_schema(WorkoutPlanExerciseSchema).ask(prompt)

    WorkoutPlanExercise.create!(
      workout_plan: @workout_plan,
      exercise: exercise,
      n_sets: response.content["n_sets"],
      n_repetitions: response.content["n_repetitions"],
      rest_in_s: response.content["rest_in_s"]
    )

    "Added '#{exercise.title}' to the plan."
  rescue => e
    Rails.logger.error("[AddWorkoutPlanExerciseTool] Failed workout_plan_id=#{@workout_plan.id}: #{e.class}: #{e.message}\n#{e.backtrace&.first(10)&.join("\n")}")
    "Error adding exercise: #{e.message}"
  end

  private

  def profiles_as_str
    [@workout_plan.pairing.user1, @workout_plan.pairing.user2].filter_map do |user|
      p = user.user_profile
      next unless p
      age = ((Date.today - p.birthdate) / 365.25).to_i
      "- #{p.name}, #{age}yo, #{p.gender}. Goal: #{p.goal}. Experience: #{p.experience}."
    end.join("\n").presence || "No profiles available."
  end
end
