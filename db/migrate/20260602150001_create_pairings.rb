class CreatePairings < ActiveRecord::Migration[8.1]
  def change
    create_table :pairings do |t|
      t.bigint :user_id_1, null: false
      t.bigint :user_id_2, null: false
      t.timestamps
    end

    add_index :pairings, :user_id_1
    add_index :pairings, :user_id_2
    add_index :pairings, [ :user_id_1, :user_id_2 ], unique: true
    add_foreign_key :pairings, :users, column: :user_id_1
    add_foreign_key :pairings, :users, column: :user_id_2
  end
end
