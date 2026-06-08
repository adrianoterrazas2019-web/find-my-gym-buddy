class AddRestInSToWorkoutPlanExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :workout_plan_exercises, :rest_in_s, :integer
  end
end
