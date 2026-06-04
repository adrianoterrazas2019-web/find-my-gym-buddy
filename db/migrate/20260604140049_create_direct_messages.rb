class CreateDirectMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :direct_messages do |t|
      t.references :direct_chat, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
