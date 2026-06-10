class MessagesController < ApplicationController
  before_action :set_chat

  def create
    content = params.dig(:message, :content)
    return unless content.present?

    @message = @chat.messages.create!(role: 'user', content: content, user_id: current_user.id)
    ChatResponseJob.perform_later(@chat.id)

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
