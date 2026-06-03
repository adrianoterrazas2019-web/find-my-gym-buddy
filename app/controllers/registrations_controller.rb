class RegistrationsController < Devise::RegistrationsController
  def new
    super do |resource|
      resource.build_user_profile
      @user = resource
    end
  end
end
