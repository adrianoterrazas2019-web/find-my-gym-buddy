class AddTitleAndDescriptionToWorkoutPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :workout_plans, :title, :string
    add_column :workout_plans, :description, :text
  end
end
