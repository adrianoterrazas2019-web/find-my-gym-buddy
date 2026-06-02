class ApplicationController < ActionController::Base
<<<<<<< HEAD
=======
  before_action :authenticate_user!

  private

  def available_chat_models
    RubyLLM.models.chat_models.all
           .sort_by { |model| [model.provider.to_s, model.name.to_s] }
  end
>>>>>>> 3372a717391dc8a00e3786a229575baf3f635819
end
