class PairingsController < ApplicationController
  before_action :set_pairing, only: [ :show, :destroy ]

  def index
    @pairings = current_user.pairings
  end

  def show
    @chat = @pairing.chat
    @message = @chat.messages.build
    @partner = @pairing.partner_for(current_user)
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
