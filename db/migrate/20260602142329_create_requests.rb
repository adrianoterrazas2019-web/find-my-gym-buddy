class CreateRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :requests do |t|
      t.bigint :sender_id, null: false
      t.bigint :recipient_id, null: false
      t.string :status, null: false, default: "pending"
      t.text :message

      t.timestamps
    end

    add_index :requests, :sender_id
    add_index :requests, :recipient_id
    add_foreign_key :requests, :users, column: :sender_id
    add_foreign_key :requests, :users, column: :recipient_id
  end
end
