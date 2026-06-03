class AddChattableToChats < ActiveRecord::Migration[8.1]
  def change
    add_reference :chats, :chattable, polymorphic: true, null: true
  end
end
