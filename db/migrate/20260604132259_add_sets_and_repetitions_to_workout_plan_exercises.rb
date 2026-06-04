class AddSeriesAndRepetitionsToWorkoutPlanExercises < ActiveRecord::Migration[8.1]
  def change
    add_column :workout_plan_exercises, :n_sets, :integer
    add_column :workout_plan_exercises, :n_repetitions, :integer
  end
end
