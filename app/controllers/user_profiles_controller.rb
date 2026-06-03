class UserProfilesController < ApplicationController
  def show
    @profile = current_user.user_profile
  end

  def edit
    @profile = current_user.user_profile
  end

  def update
    @profile = current_user.user_profile

    if @profile.update(profile_params)
      redirect_to user_profile_path,
                  notice: "Profile updated."
    else
      render :edit,
             status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(
      :name,
      :birthdate,
      :gender,
      :photo
    )
  end
end
