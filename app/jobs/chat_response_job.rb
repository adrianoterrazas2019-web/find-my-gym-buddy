class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    if chat.chattable_type == "Pairing"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(CreateWorkoutPlanTool.new(pairing: chat.chattable))
    end

    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        message = chat.messages.order(:created_at).last
        # message.user = user
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
