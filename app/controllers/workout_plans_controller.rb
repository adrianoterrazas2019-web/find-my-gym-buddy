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
    @workout_plan = WorkoutPlan.find_by(id: params[:id])

    unless @workout_plan && current_user.pairings.exists?(@workout_plan.pairing_id)
      redirect_to root_path, alert: "Not authorized."
      return
    end

    @workout_plan_exercises = @workout_plan.workout_plan_exercises.includes(:exercise)
    @chat = @workout_plan.chat
    @message = @chat.messages.build
  end
end
