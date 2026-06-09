class EditWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, updating an existing workout plan for a gym pair.
    Given the current plan state and the user's edit request, return:
    - The new title (copy the current value if the user did not ask to change it)
    - The new description (copy the current value if the user did not ask to change it)
    - Only the exercises that need parameter changes, identified by their workout_plan_exercise_id

    Current plan:
  PROMPT

  description "Edits the current workout plan's title, description, or exercise parameters " \
              "(sets, repetitions, rest). Call this when the user asks to change something in the plan."

  param :user_request, desc: "The user's edit instructions, e.g. 'increase sets for all exercises to 4' " \
                             "or 'rename the plan to Power Circuit'"

  def initialize(workout_plan:)
    @workout_plan = workout_plan
  end

  def execute(user_request:)
    prompt = "#{TOOL_SYSTEM_PROMPT}#{plan_as_str}\n\nUser request: #{user_request}"

    response = RubyLLM.chat.with_schema(WorkoutPlanEditSchema).ask(prompt)

    @workout_plan.update!(
      title: response.content["title"],
      description: response.content["description"]
    )

    (response.content["exercise_updates"] || []).each do |update|
      wpe = WorkoutPlanExercise.find_by(id: update["workout_plan_exercise_id"], workout_plan: @workout_plan)
      next unless wpe

      wpe.update!(
        n_sets: update["n_sets"],
        n_repetitions: update["n_repetitions"],
        rest_in_s: update["rest_in_s"]
      )
    end

    "Workout plan updated."
  rescue => e
    "Error editing workout plan: #{e.message}"
  end

  private

  def plan_as_str
    exercises = @workout_plan.workout_plan_exercises.includes(:exercise).map do |wpe|
      "- [ID: #{wpe.id}] #{wpe.exercise.title}: #{wpe.n_sets} sets × #{wpe.n_repetitions} reps, #{wpe.rest_in_s}s rest"
    end.join("\n")

    "Title: #{@workout_plan.title}\nDescription: #{@workout_plan.description}\n\nExercises:\n#{exercises}"
  end
end
