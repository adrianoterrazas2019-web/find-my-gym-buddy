class ChatResponseJob < ApplicationJob
  def perform(chat_id, content)
    chat = Chat.find(chat_id)

    if chat.chattable_type == "Pairing"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(CreateWorkoutPlanTool.new(pairing: chat.chattable))
    end

    placeholder_removed = false
    chat.ask(content) do |chunk|
      if chunk.content && !chunk.content.empty?
        unless placeholder_removed
          Turbo::StreamsChannel.broadcast_remove_to("chat_#{chat_id}", target: "thinking_placeholder")
          placeholder_removed = true
        end
        message = chat.messages.order(:created_at).last
        message.broadcast_append_chunk(chunk.content)
      end
    end
  rescue RubyLLM::BadRequestError
    Turbo::StreamsChannel.broadcast_remove_to("chat_#{chat_id}", target: "thinking_placeholder")
    Turbo::StreamsChannel.broadcast_append_to(
      "chat_#{chat_id}",
      target: "messages",
      html: "<p>Your message was blocked by the content filter. Try rephrasing — for example, use \"intense\" or \"advanced\" instead of \"hardcore\".</p>"
    )
  ensure
    html = ApplicationController.render(
      partial: "messages/form",
      locals: { message: chat.messages.build, chat: chat, disabled: false }
    )
    Turbo::StreamsChannel.broadcast_replace_to("chat_#{chat_id}", target: "new_message", html: html)
  end
end
