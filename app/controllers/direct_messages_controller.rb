class DirectMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pairing_and_chat

  def create
    @direct_message = @direct_chat.direct_messages.build(
      content: params.dig(:direct_message, :content),
      user: current_user
    )

    if @direct_message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to pairings_path }
      end
    end
  end

  private

  def set_pairing_and_chat
    @pairing = current_user.pairings.find(params[:pairing_id])
    @direct_chat = @pairing.direct_chat || @pairing.create_direct_chat!
  end
end
