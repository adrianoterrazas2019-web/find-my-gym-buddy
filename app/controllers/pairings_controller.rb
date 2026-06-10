class PairingsController < ApplicationController
  before_action :set_pairing, only: %i[show destroy]

  def index
    @pairings = current_user.pairings
  end

  def create
    # The request was already accepted by RequestsController#update.
    # This action only handles Pairing DB work.
    request = current_user.received_requests.accepted.find(params[:request_id])

    sender_profile    = request.sender.user_profile
    recipient_profile = request.recipient.user_profile
    score = if sender_profile && recipient_profile
              PairScoreCalculator.new(sender_profile, recipient_profile).call
            end

    Pairing.find_or_create_by!(
      user_id_1: request.sender_id,
      user_id_2: request.recipient_id
    ) { |p| p.pair_score = score }

    redirect_to pairings_path, notice: "Buddy added!"
  end

  def show
    @chat = @pairing.chat
    @message = Message.new(chat: @chat)
    @partner = @pairing.partner_for(current_user)
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
