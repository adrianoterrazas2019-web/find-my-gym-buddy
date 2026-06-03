class TestSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    sign_in User.find(params[:user_id])
    redirect_to root_path
  end
end
