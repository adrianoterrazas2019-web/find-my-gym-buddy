class UpdateCalendarEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :calendar_entries, :start_time, :datetime
    add_column :calendar_entries, :end_time, :datetime

    remove_column :calendar_entries, :datetime, :datetime
  end
end
