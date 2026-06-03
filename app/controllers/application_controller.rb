class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters,
                if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        user_profile_attributes: [
          :name,
          :birthdate,
          :gender,
          :show_name,
          :show_gender
        ]
      ]
    )
  end

  def after_sign_up_path_for(resource)
    edit_my_profile_path
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  private

  def available_chat_models
    RubyLLM.models.chat_models.all
           .sort_by { |model| [model.provider.to_s, model.name.to_s] }
  end
end
