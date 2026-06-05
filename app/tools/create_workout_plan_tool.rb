class CreateWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are a professional fitness coach creating a personalized workout plan for a gym pair.
    Based on the list of exercises below, generate:
    - A short, motivating title for the workout plan.
    - A description covering the session goals, target muscle groups, and overall difficulty.
    - The number of exercises to include (typically 4–8, suited to the pair's experience and goals).

    The list of exercises is:
  PROMPT

  desc "Creates a personalized workout plan for a gym pair by finding the most relevant exercises " \
       "via semantic search. Call this when the pair asks for a custom workout plan."

  params :user_request, desc: "Last relevant user messages with prompt about the desired workout plan"
  params :n_exercises, desc: "Number of exercises to include, estimated from the pair's experience and goals (typically 4–8)"

  def initialize(pairing:)
    @pairing = pairing
  end

  def execute(user_request:, n_exercises:)
    embedding = RubyLLM.embed(user_request, provider: :openai, assume_model_exists: true).vectors
    exercises = Exercise.nearest_neighbors(:embedding, embedding, distance: "cosine").first(n_exercises)

    chat = RubyLLM.chat
    plan_response = chat.with_schema(WorkoutPlanSchema).ask("#{TOOL_SYSTEM_PROMPT} #{exercises_as_str(exercises)}")

    plan = WorkoutPlan.new(plan_response)
    plan.pairing = @pairing
    plan.save!

    exercises.each do |exercise|
      exercise_response = chat.with_schema(WorkoutPlanExerciseSchema).ask(
        "For the exercise '#{exercise.title}' (#{exercise.difficulty}, targets #{exercise.target_muscle}), " \
        "recommend sets, repetitions, and rest in seconds suited to the plan '#{plan.title}'."
      )
      WorkoutPlanExercise.create!(
        workout_plan: plan,
        exercise: exercise,
        n_sets: exercise_response.n_sets,
        n_repetitions: exercise_response.n_repetitions,
        rest_in_s: exercise_response.rest_in_s
      )
    end

    "Workout plan '#{plan.title}' created with #{exercises.count} exercises: #{exercises.map(&:title).join(', ')}."
  end

  private

  def exercises_as_str(exercises)
    exercises.map do |e|
      "- #{e.title} (#{e.difficulty}, targets: #{e.target_muscle}, equipment: #{e.equipment}): #{e.description}"
    end.join("\n")
  end
end
