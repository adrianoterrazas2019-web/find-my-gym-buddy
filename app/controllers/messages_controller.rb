class MessagesController < ApplicationController
  before_action :set_chat

  def create
    @message = @chat.messages.build
    content = params.dig(:message, :content)
    return unless content.present?

    ChatResponseJob.perform_later(@chat.id, content, current_user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @chat }
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end
end
