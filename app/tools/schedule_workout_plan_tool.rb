class ScheduleWorkoutPlanTool < RubyLLM::Tool
  TOOL_SYSTEM_PROMPT = <<~PROMPT
    You are AIrnold, a professional fitness coach scheduling gym sessions for a workout pair.
    Based on the workout plan and each user's upcoming calendar entries below, determine all occurrences
    that match the user's scheduling preferences (e.g. "every Saturday evening until end of October").
    For each occurrence, pick a shared time slot when both users appear free.
    Estimate session duration from the number of exercises (roughly 10–15 minutes per exercise including
    rest, with a 5-minute warm-up buffer).
    Return an array of sessions, each with ISO 8601 datetimes and a short note summarising the session.
    Return every occurrence the user asked for — do not stop at one.
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

    sessions = schedule_response.content["sessions"]

    [@pairing.user1, @pairing.user2].each do |user|
      calendar = user.calendar || user.create_calendar
      sessions.each do |session|
        CalendarEntry.create!(
          calendar: calendar,
          title: plan.title,
          entry_type: "workout",
          start_time: Time.parse(session["start_time"]),
          end_time: Time.parse(session["end_time"]),
          note: session["note"]
        )
      end
    end

    first_start = Time.parse(sessions.first["start_time"])
    Turbo::StreamsChannel.broadcast_replace_to(
      "chat_#{@pairing.chat.id}",
      target: "pairing_calendar",
      html: "<turbo-frame id=\"pairing_calendar\" src=\"/pairings/#{@pairing.id}?start_date=#{first_start.strftime('%Y-%m-%d')}\"></turbo-frame>"
    )

    lines = sessions.map do |session|
      start_time = Time.parse(session["start_time"])
      end_time   = Time.parse(session["end_time"])
      "  - #{start_time.strftime('%A, %B %-d at %H:%M')} – #{end_time.strftime('%H:%M')}"
    end.join("\n")

    "#{sessions.size} session#{"s" if sessions.size != 1} of '#{plan.title}' added to both calendars:\n#{lines}"
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
      entries = user.calendar&.calendar_entries
                              &.where("start_time > ?", Time.current)
                              &.order(:start_time)
                              &.first(10) || []

      lines = entries.map { |e| "  - #{e.title}: #{e.start_time.iso8601} to #{e.end_time.iso8601}" }.join("\n")
      "#{name}'s upcoming calendar entries:\n#{lines.presence || '  (no upcoming entries)'}"
    end.join("\n\n")
  end
end
