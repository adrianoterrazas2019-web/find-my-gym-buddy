class CalendarEntry < ApplicationRecord
  belongs_to :calendar
  belongs_to :workout_plan, optional: true

  after_create_commit :broadcast_session_created
  after_update_commit :broadcast_session_updated

  private

  def broadcast_session_created
    return unless workout_plan_id
    broadcast_append_to "workout_plan_#{workout_plan_id}_sessions",
      target: "sessions_list",
      partial: "workout_plans/session",
      locals: { session: self }
  end

  def broadcast_session_updated
    prev_id = workout_plan_id_before_last_save
    curr_id = workout_plan_id

    if prev_id != curr_id
      if prev_id
        broadcast_remove_to "workout_plan_#{prev_id}_sessions",
          target: "calendar_entry_#{id}"
      end
      if curr_id
        broadcast_append_to "workout_plan_#{curr_id}_sessions",
          target: "sessions_list",
          partial: "workout_plans/session",
          locals: { session: self }
      end
    elsif curr_id
      broadcast_replace_to "workout_plan_#{curr_id}_sessions",
        target: "calendar_entry_#{id}",
        partial: "workout_plans/session",
        locals: { session: self }
    end
  end
end
