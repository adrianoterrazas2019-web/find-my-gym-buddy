class WorkoutPlansController < ApplicationController
  def index
    if params[:pairing_id]
      @pairing = current_user.pairings.find(params[:pairing_id])
      @workout_plans = @pairing.workout_plans
    else
      @pairings = current_user.pairings.includes(:workout_plans)
    end
  end
end
