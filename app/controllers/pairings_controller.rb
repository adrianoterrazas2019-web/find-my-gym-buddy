class PairingsController < ApplicationController
  before_action :set_pairing, only: [ :show, :destroy ]

  def index
    @pairings = current_user.pairings
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
    @pairing = current_user.pairings.find(params[:id])
  end
end
