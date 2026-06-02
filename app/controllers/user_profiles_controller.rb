class UserProfilesController < ApplicationController
  def show
    @user_profile = UserProfile.find(params[:id])
  end
end
