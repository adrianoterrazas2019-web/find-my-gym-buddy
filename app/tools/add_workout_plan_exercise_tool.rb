class AddWorkoutPlanExerciseTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, a professional fitness coach.
    Recommend sets, repetitions, and rest in seconds for the exercise below,
    suited to the workout plan context provided.

    Exercise:
  PROMPT

  description "Adds a new exercise to the current workout plan using semantic search to find the best match. " \
              "Call this when the user asks to add an exercise."

  param :user_request, desc: "Description of the exercise the user wants to add, e.g. 'add a chest press' " \
                             "or 'include something for legs'"

  def initialize(workout_plan:)
    @workout_plan = workout_plan
  end

  def execute(user_request:)
    embedding = RubyLLM.embed(user_request, provider: :openai, assume_model_exists: true).vectors
    exercise = Exercise.nearest_neighbors(:embedding, embedding, distance: "cosine").first

    return "No matching exercise found." unless exercise

    prompt = "#{TOOL_SYSTEM_PROMPT}#{exercise.title} (#{exercise.difficulty}, " \
             "targets #{exercise.target_muscle}, equipment: #{exercise.equipment}): #{exercise.description}\n\n" \
             "Plan context: #{@workout_plan.title} — #{@workout_plan.description}"

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
    "Error adding exercise: #{e.message}"
  end
end
