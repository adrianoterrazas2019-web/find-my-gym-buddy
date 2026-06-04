class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
    current_profile = current_user.user_profile

    profiles = UserProfile.where.not(user: current_user)
                          .filter_by(filter_params)
                          .includes(:user)
                          .to_a

    @scores = profiles.index_with { |p| current_profile&.pair_score_with(p) || 0 }

    profiles.select! { |p| @scores[p] >= filter_params[:min_score].to_i } if filter_params[:min_score].present?
    profiles.sort_by! { |p| -@scores[p] }

    @profiles = filter_params.values.all?(&:blank?) ? profiles.first(6) : profiles
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
      :address,
      :photo
    )
  end

  def filter_params
    params.permit(:location, :goal, :experience, :gender, :date, :min_score)
  end
end
