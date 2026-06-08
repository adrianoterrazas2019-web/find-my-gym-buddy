class WorkoutSessionScheduleSchema < RubyLLM::Schema
  string :start_time, description: "ISO 8601 start time for the workout session"
  string :end_time, description: "ISO 8601 end time for the workout session"
  string :note, description: "Brief note summarising what will be covered in this session"
end
