class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.string :title
      t.text :description
      t.string :target_muscle
      t.string :equipment
      t.string :difficulty

      t.timestamps
    end
  end
end
