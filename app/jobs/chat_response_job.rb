class ChatResponseJob < ApplicationJob
  def perform(chat_id, content, user_id = nil)
    chat = Chat.find(chat_id)

    if chat.chattable_type == "Pairing"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(CreateWorkoutPlanTool.new(pairing: chat.chattable))
      chat.with_tool(ScheduleWorkoutPlanTool.new(pairing: chat.chattable))
    elsif chat.chattable_type == "WorkoutPlan"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(EditWorkoutPlanTool.new(workout_plan: chat.chattable))
      chat.with_tool(AddWorkoutPlanExerciseTool.new(workout_plan: chat.chattable))
      chat.with_tool(RemoveWorkoutPlanExerciseTool.new(workout_plan: chat.chattable))
    end

    # Note which messages exist before ask() so we can find the one it creates
    existing_ids = chat.messages.pluck(:id)
    user_assigned = false

    placeholder_removed = false
    chat.ask(content) do |chunk|
      # On the first chunk ruby_llm has already persisted the user message —
      # find it and stamp it with the sender's user_id so the name badge renders correctly.
      unless user_assigned
        if user_id
          new_user_msg = chat.messages
                             .where(role: "user")
                             .where.not(id: existing_ids)
                             .first
          new_user_msg&.update!(user_id: user_id)
        end
        user_assigned = true
      end

      if chunk.content && !chunk.content.empty?
        unless placeholder_removed
          Turbo::StreamsChannel.broadcast_remove_to("chat_#{chat_id}", target: "thinking_placeholder")
          placeholder_removed = true
        end
        message = chat.messages.order(:created_at).last
        message.broadcast_append_chunk(chunk.content)
      end
    end
  rescue RubyLLM::RateLimitError, RubyLLM::BadRequestError => e
    Rails.logger.error("ChatResponseJob #{e.class} for chat #{chat_id}: #{e.message}")
    Turbo::StreamsChannel.broadcast_remove_to("chat_#{chat_id}", target: "thinking_placeholder")
    user_message = if e.message.to_s.match?(/rate limit/i)
                     "AIrnold is taking a breather — the daily API limit has been reached. Try again in a few hours."
                   else
                     "Your message could not be processed. Try rephrasing your request."
                   end
    Turbo::StreamsChannel.broadcast_append_to(
      "chat_#{chat_id}",
      target: "messages",
      html: "<p>#{user_message}</p>"
    )
  ensure
    html = ApplicationController.render(
      partial: "messages/form",
      locals: { message: chat.messages.build, chat: chat, disabled: false }
    )
    Turbo::StreamsChannel.broadcast_replace_to("chat_#{chat_id}", target: "new_message", html: html)
  end
end
