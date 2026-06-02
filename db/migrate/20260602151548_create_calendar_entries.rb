class CreateCalendarEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :calendar_entries do |t|
      t.references :calendar, null: false, foreign_key: true
      t.datetime :datetime
      t.string :title
      t.string :location
      t.string :entry_type
      t.text :note

      t.timestamps
    end
  end
end
