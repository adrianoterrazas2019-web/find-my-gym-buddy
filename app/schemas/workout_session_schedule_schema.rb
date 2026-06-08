class WorkoutSessionScheduleSchema < RubyLLM::Schema
  array :sessions, description: "One entry per scheduled occurrence of the workout session", min_items: 1 do
    object do
      string :start_time, description: "ISO 8601 start time for this occurrence"
      string :end_time,   description: "ISO 8601 end time for this occurrence"
      string :note,       description: "Brief note summarising what will be covered"
    end
  end
end
