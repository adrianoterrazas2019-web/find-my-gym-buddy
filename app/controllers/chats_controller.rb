class ChatsController < ApplicationController
  CHATABLE_TYPES = {
    "Pairing" => Pairing,
    "WorkoutPlan" => WorkoutPlan
  }.freeze
  before_action :set_chat, only: %i[show destroy clear]

  def index
    @chats = Chat.order(created_at: :desc)
  end

  def new
    @chat = Chat.new
    @selected_model = params[:model]
    @chat_models = available_chat_models
  end

  def create
    prompt = params.dig(:chat, :prompt)
    return unless prompt.present?

    chatable_class = CHATABLE_TYPES[params.dig(:chat, :chatable_type)]
    chatable = chatable_class.find(params.dig(:chat, :chatable_id)) if chatable_class
    @chat = Chat.create!(model: params.dig(:chat, :model).presence, chatable: chatable)
    ChatResponseJob.perform_later(@chat.id, prompt)

    redirect_to @chat, notice: "Chat was successfully created."
  end

  def show
    @message = @chat.messages.build
  end

  def clear
    @chat.messages.destroy_all
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    @chat.destroy!
    redirect_to chats_path, notice: "Chat was successfully destroyed.", status: :see_other
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
    if @chat.chattable.is_a?(Pairing)
      unless current_user.pairings.exists?(@chat.chattable_id)
        redirect_to root_path, alert: "Not authorized"
      end
    end
  end
end
