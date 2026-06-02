class UserProfilesController < ApplicationController
  def show
    @user_profile = UserProfile.first
  end
end
