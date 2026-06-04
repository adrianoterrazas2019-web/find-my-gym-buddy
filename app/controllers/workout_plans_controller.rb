class WorkoutPlansController < ApplicationController
  def index
    @pairing = current_user.pairings.find(params[:pairing_id])
    @workout_plans = @pairing.workout_plans
  end
end
