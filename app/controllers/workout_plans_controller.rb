class WorkoutPlansController < ApplicationController
  def index
    if params[:pairing_id]
      @pairing = current_user.pairings.find(params[:pairing_id])
      @workout_plans = @pairing.workout_plans
    else
      @pairings = current_user.pairings.includes(:workout_plans)
    end
  end

  def show
    @workout_plan = WorkoutPlan.joins(:pairing)
                               .where(pairings: { id: current_user.pairings })
                               .find(params[:id])
    @workout_plan_exercises = @workout_plan.workout_plan_exercises.includes(:exercise)
  end
end
