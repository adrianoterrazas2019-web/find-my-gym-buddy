class DirectMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pairing_and_chat

  def create # rubocop:disable Metrics/MethodLength
    @direct_chat = DirectChat.find(params[:direct_chat_id])
    @direct_message = @direct_chat.direct_messages.new(direct_message_params)
    @direct_message.user = current_user

    if @direct_message.save
      Turbo::StreamsChannel.broadcast_append_to(
        "direct_chat_#{@direct_chat.id}",
        target: "direct_messages",
        partial: "direct_messages/direct_message",
        locals: {
          direct_message: @direct_message,
          current_user: current_user
        }
      )
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to pairing_path(@pairing) }
      end
    end
  end

  private

  def set_pairing_and_chat
    @pairing = current_user.pairings.find(params[:pairing_id])
    @direct_chat = @pairing.direct_chat || @pairing.create_direct_chat!
  end

  def direct_message_params
    params.require(:direct_message).permit(:content)
  end
end
