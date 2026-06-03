class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    @profiles = UserProfile.where.not(user: current_user)
                           .filter_by(filter_params)
                           .includes(:user)
    @profiles = @profiles.limit(6) if filter_params.values.all?(&:blank?)
  end

  def show
    @profile = UserProfile.find(params[:id])
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
      :goal,
      :experience,
      :address
    )
  end

  def filter_params
    params.permit(:location, :goal, :experience, :gender, :date)
  end
end
