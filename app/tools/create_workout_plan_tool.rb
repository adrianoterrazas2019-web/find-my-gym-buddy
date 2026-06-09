class CreateWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, a professional fitness coach creating a personalized workout plan for a gym pair.
    Based on the list of exercises below, generate:
    - A short, motivating title for the workout plan. If the user suggests a title, use it.
    - A description covering the session goals, target muscle groups, and overall difficulty.

    The list of exercises is:
  PROMPT

  description "Creates a personalized workout plan for a gym pair by finding the most relevant exercises " \
              "via semantic search. Call this when the pair asks for a custom workout plan."

  param :user_request, desc: "Last relevant user messages with prompt about the desired workout plan"
  param :n_exercises, type: :integer, desc: "Number of exercises to include," \
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
    plan_response = chat.with_schema(WorkoutPlanSchema).ask("#{TOOL_SYSTEM_PROMPT} #{exercises_as_str(exercises)}")

    plan = WorkoutPlan.new(plan_response.content)
    plan.pairing = @pairing
    plan.save!

    Rails.logger.info("[CreateWorkoutPlanTool] Plan '#{plan.title}' saved (id=#{plan.id}), building #{exercises.size} exercises")
    exercises.each_with_index do |exercise, i|
      Rails.logger.info("[CreateWorkoutPlanTool] Exercise #{i + 1}/#{exercises.size}: #{exercise.title}")
      exercise_response = chat.with_schema(WorkoutPlanExerciseSchema).ask(
        "For the exercise '#{exercise.title}' (#{exercise.difficulty}, targets #{exercise.target_muscle}), " \
        "recommend sets, repetitions, and rest in seconds suited to the plan '#{plan.title}'."
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

  def exercises_as_str(exercises)
    exercises.map do |e|
      "- #{e.title} (#{e.difficulty}, targets: #{e.target_muscle}, equipment: #{e.equipment}): #{e.description}"
    end.join("\n")
  end
end
