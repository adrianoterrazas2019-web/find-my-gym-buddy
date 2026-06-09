class RemoveWorkoutPlanExerciseTool < RubyLLM::Tool
  description "Removes an exercise from the current workout plan by its ID. " \
              "Call this when the user asks to delete or remove an exercise."

  param :workout_plan_exercise_id, type: :integer,
        desc: "The ID of the WorkoutPlanExercise record to remove, as shown in the plan"

  def initialize(workout_plan:)
    @workout_plan = workout_plan
  end

  def execute(workout_plan_exercise_id:)
    Rails.logger.info("[RemoveWorkoutPlanExerciseTool] Executing workout_plan_id=#{@workout_plan.id} workout_plan_exercise_id=#{workout_plan_exercise_id}")

    wpe = WorkoutPlanExercise.find_by(id: workout_plan_exercise_id, workout_plan: @workout_plan)
    return "Exercise not found in this plan." unless wpe

    title = wpe.exercise.title
    wpe.destroy!
    # destroy does not trigger touch on the parent, so we broadcast manually
    @workout_plan.touch

    "Removed '#{title}' from the plan."
  rescue => e
    Rails.logger.error("[RemoveWorkoutPlanExerciseTool] Failed workout_plan_id=#{@workout_plan.id} workout_plan_exercise_id=#{workout_plan_exercise_id}: #{e.class}: #{e.message}\n#{e.backtrace&.first(10)&.join("\n")}")
    "Error removing exercise: #{e.message}"
  end
end
