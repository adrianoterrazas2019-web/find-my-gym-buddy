class ChatResponseJob < ApplicationJob
  def perform(chat_id, content, user_id = nil)
    chat = Chat.find(chat_id)
    Current.user = User.find_by(id: user_id) if user_id

    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.last
        message.broadcast_append_chunk(chunk.content)
      end
    end
  end
end
