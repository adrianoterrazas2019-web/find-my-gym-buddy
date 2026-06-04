class CreateWorkoutPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_plans do |t|
      t.references :pairing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
