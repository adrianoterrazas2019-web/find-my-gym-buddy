class PairingsController < ApplicationController
  before_action :set_pairing, only: [ :show, :destroy ]

  def index
    @pairings = current_user.pairings
  end

  def show
    @chat = @pairing.chat
    @message = Message.new(chat: @chat)
    @partner = @pairing.partner_for(current_user)

    current_calendar = current_user.calendar
    partner_calendar = @partner.calendar

    @calendar_entries = CalendarEntry
                        .where(calendar: [current_calendar, partner_calendar].compact)
                        .order(:start_time)
    @workout_plans = @pairing.workout_plans
    @direct_chat = @pairing.direct_chat || @pairing.create_direct_chat!
    @direct_message = DirectMessage.new
  end

  def destroy
    @pairing.destroy!
    redirect_to pairings_path, notice: "Pairing removed.", status: :see_other
  end

  private

  def set_pairing
    @pairing = Pairing.find(params[:id])

    unless [@pairing.user_id_1, @pairing.user_id_2].include?(current_user.id)
      redirect_to root_path, alert: "Not authorized."
    end
  end
end
