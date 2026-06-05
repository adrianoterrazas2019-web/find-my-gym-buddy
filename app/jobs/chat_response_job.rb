class ChatResponseJob < ApplicationJob
  def perform(chat_id, content, user = nil)
    chat = Chat.find(chat_id)

    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.last
        message.user = user
        message.broadcast_append_chunk(chunk.content)
      end
    end

    html = ApplicationController.render(
      partial: "messages/form",
      locals: { message: chat.messages.build, chat: chat, disabled: false }
    )
    Turbo::StreamsChannel.broadcast_replace_to("chat_#{chat_id}", target: "new_message", html: html)
  end
end
