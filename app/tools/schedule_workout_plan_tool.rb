class ScheduleWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, a professional fitness coach scheduling a gym session for a workout pair.
    Based on the workout plan and each user's upcoming calendar entries below, pick the best shared time slot.
    Choose a time when both users appear free. Estimate session duration from the number of exercises
    (roughly 10–15 minutes per exercise including rest, with a 5-minute warm-up buffer).
    Return ISO 8601 datetimes and a short note summarising the session.
  PROMPT

  description "Schedules a workout plan by creating calendar entries for both users in the pairing. " \
              "Call this when the pair wants to add a workout plan to their calendars."

  param :workout_plan_id, type: :integer, desc: "ID of the workout plan to schedule"
  param :user_request, desc: "User's scheduling preferences, e.g. preferred days or times"

  def initialize(pairing:)
    @pairing = pairing
  end

  def execute(workout_plan_id:, user_request:)
    plan = WorkoutPlan.find(workout_plan_id)

    prompt = <<~PROMPT
      #{TOOL_SYSTEM_PROMPT}

      Today is #{Time.current.iso8601}.

      #{plan_as_str(plan)}

      #{calendars_as_str}

      User preferences: #{user_request}
    PROMPT

    schedule_response = RubyLLM.chat.with_schema(WorkoutSessionScheduleSchema).ask(prompt)

    start_time = Time.parse(schedule_response.content["start_time"])
    end_time   = Time.parse(schedule_response.content["end_time"])
    note       = schedule_response.content["note"]

    [@pairing.user1, @pairing.user2].each do |user|
      CalendarEntry.create!(
        calendar: user.calendar,
        title: plan.title,
        entry_type: "workout",
        start_time: start_time,
        end_time: end_time,
        note: note
      )
    end

    "Workout session '#{plan.title}' scheduled for #{start_time.strftime('%A, %B %-d at %H:%M')} " \
    "– #{end_time.strftime('%H:%M')}."
  rescue => e
    "Error scheduling workout plan: #{e.message}"
  end

  private

  def plan_as_str(plan)
    exercises = plan.workout_plan_exercises.includes(:exercise).map do |wpe|
      "- #{wpe.exercise.title}: #{wpe.n_sets} sets × #{wpe.n_repetitions} reps, #{wpe.rest_in_s}s rest"
    end.join("\n")

    "Workout plan: #{plan.title}\nDescription: #{plan.description}\nExercises:\n#{exercises}"
  end

  def calendars_as_str
    [@pairing.user1, @pairing.user2].map.with_index(1) do |user, i|
      name = user.user_profile&.name || "User #{i}"
      entries = user.calendar
                    .calendar_entries
                    .where("start_time > ?", Time.current)
                    .order(:start_time)
                    .first(10)

      lines = entries.map { |e| "  - #{e.title}: #{e.start_time.iso8601} to #{e.end_time.iso8601}" }.join("\n")
      "#{name}'s upcoming calendar entries:\n#{lines.presence || '  (no upcoming entries)'}"
    end.join("\n\n")
  end
end
