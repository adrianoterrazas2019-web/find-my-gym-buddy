class CalendarEntry < ApplicationRecord
  belongs_to :calendar
  belongs_to :workout_plan, optional: true

  after_create_commit :broadcast_session_created
  after_update_commit :broadcast_session_updated
  after_destroy_commit :broadcast_session_destroyed

  private

  def broadcast_session_created
    return unless workout_plan_id
    broadcast_sessions_list(workout_plan_id)
  end

  def broadcast_session_updated
    prev_id = workout_plan_id_before_last_save
    curr_id = workout_plan_id

    broadcast_sessions_list(prev_id) if prev_id && prev_id != curr_id
    broadcast_sessions_list(curr_id) if curr_id
  end

  def broadcast_session_destroyed
    return unless workout_plan_id
    broadcast_sessions_list(workout_plan_id)
  end

  def broadcast_sessions_list(plan_id)
    user_id = calendar.user_id
    sessions = CalendarEntry
      .joins(:calendar)
      .where(calendars: { user_id: user_id }, workout_plan_id: plan_id)
      .order(:start_time)

    html = ApplicationController.render(
      partial: "workout_plans/sessions_list",
      locals: { sessions: sessions }
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      "workout_plan_#{plan_id}_user_#{user_id}_sessions",
      target: "sessions_list",
      html: html
    )
  end
end
