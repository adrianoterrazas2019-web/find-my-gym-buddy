class AddWorkoutPlanIdToCalendarEntries < ActiveRecord::Migration[8.1]
  def change
    add_reference :calendar_entries, :workout_plan, null: true, foreign_key: true
  end
end
