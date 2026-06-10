class CalendarsController < ApplicationController
  def index
    @buddies = current_user.pairings.map { |p| p.partner_for(current_user) }

    entries = current_user.calendar&.calendar_entries&.order(:start_time) || CalendarEntry.none

    if params[:buddy_id].present?
      pairing = Pairing
        .where(user_id_1: current_user.id, user_id_2: params[:buddy_id])
        .or(Pairing.where(user_id_1: params[:buddy_id], user_id_2: current_user.id))
        .first
      entries = pairing ? entries.where(workout_plan_id: pairing.workout_plans.select(:id)) : CalendarEntry.none
    end

    @calendar_entries = entries
  end
end
