class ChatResponseJob < ApplicationJob
  def perform(chat_id, content, user_id = nil)
    chat = Chat.find(chat_id)

    Rails.logger.info("[ChatResponseJob] Starting chat_id=#{chat_id} " \
                      "chattable=#{chat.chattable_type}##{chat.chattable_id} " \
                      "message=#{content.truncate(120)}")

    if chat.chattable_type == "Pairing"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(CreateWorkoutPlanTool.new(pairing: chat.chattable))
      chat.with_tool(CheckCalendarAvailabilityTool.new(pairing: chat.chattable))
      chat.with_tool(ScheduleWorkoutPlanTool.new(pairing: chat.chattable))
    elsif chat.chattable_type == "WorkoutPlan"
      chat.with_instructions(chat.chattable.system_prompt)
      chat.with_tool(EditWorkoutPlanTool.new(workout_plan: chat.chattable))
      chat.with_tool(AddWorkoutPlanExerciseTool.new(workout_plan: chat.chattable))
      chat.with_tool(RemoveWorkoutPlanExerciseTool.new(workout_plan: chat.chattable))
      chat.with_tool(CheckCalendarAvailabilityTool.new(pairing: chat.chattable.pairing))
      chat.with_tool(ScheduleWorkoutPlanTool.new(pairing: chat.chattable.pairing))
    end

    # Note which messages exist before ask() so we can find the one it creates
    existing_ids = chat.messages.pluck(:id)
    user_assigned = false

    placeholder_removed = false
    chat.ask(content) do |chunk|
      # On the first chunk ruby_llm has already persisted the user message.
      # Stamp it with the sender's user_id using update_columns (skips callbacks)
      # so no mid-stream broadcast fires and interrupts the response.
      unless user_assigned
        if user_id
          new_user_msg = chat.messages
                             .where(role: "user")
                             .where.not(id: existing_ids)
                             .first
          if new_user_msg
            new_user_msg.update_columns(user_id: user_id)
            Turbo::StreamsChannel.broadcast_replace_to(
              "chat_#{chat_id}",
              target: "message_#{new_user_msg.id}",
              partial: "messages/user",
              locals: { message: new_user_msg }
            )
          end
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

    Rails.logger.info("[ChatResponseJob] Completed chat_id=#{chat_id}")
  rescue RubyLLM::RateLimitError => e
    log_job_error(chat_id, e)
    broadcast_error("chat_#{chat_id}", "AIrnie is taking a breather — the daily API limit has been reached. Try again in a few hours.")
  rescue RubyLLM::Error, RubyLLM::BadRequestError, StandardError => e
    log_job_error(chat_id, e)
    broadcast_error("chat_#{chat_id}", "Your message could not be processed. Try rephrasing your request.")
  ensure
    html = ApplicationController.render(
      partial: "messages/form",
      locals: { message: chat.messages.build, chat: chat, disabled: false }
    )
    Turbo::StreamsChannel.broadcast_replace_to("chat_#{chat_id}", target: "new_message", html: html)
  end

  private

  def log_job_error(chat_id, error)
    Rails.logger.error(
      "[ChatResponseJob] #{error.class} for chat_id=#{chat_id}: #{error.message}\n" \
      "#{error.backtrace&.first(10)&.join("\n")}"
    )
  end

  def broadcast_error(stream, message)
    Turbo::StreamsChannel.broadcast_remove_to(stream, target: "thinking_placeholder")
    Turbo::StreamsChannel.broadcast_append_to(stream, target: "messages", html: "<p>#{message}</p>")
  end
end
