class CalendarEntry < ApplicationRecord
  belongs_to :calendar
  belongs_to :workout_plan, optional: true
end
