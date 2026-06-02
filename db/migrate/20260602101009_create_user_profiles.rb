class CreateUserProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :user_profiles do |t|
      t.string :name
      t.date :birthdate
      t.string :address
      t.string :gender
      t.string :goal
      t.string :experience
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
