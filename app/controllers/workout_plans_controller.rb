class WorkoutPlansController < ApplicationController
  before_action :find_workout_plan, only: [:show, :edit, :update, :destroy]

  def index
    if params[:pairing_id]
      @pairing = current_user.pairings.find(params[:pairing_id])
      @workout_plans = @pairing.workout_plans
    else
      @pairings = current_user.pairings.includes(:workout_plans)
    end
  end

  def show
    @workout_plan_exercises = @workout_plan.workout_plan_exercises.includes(:exercise)
    @chat = @workout_plan.chat
    @message = @chat.messages.build
  end

  def new
    @pairing = current_user.pairings.find(params[:pairing_id])
    @workout_plan = @pairing.workout_plans.new
  end

  def create
    @pairing = current_user.pairings.find(params[:pairing_id])
    @workout_plan = @pairing.workout_plans.new(workout_plan_params)
    if @workout_plan.save
      redirect_to @workout_plan, notice: "Workout plan created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workout_plan.update(workout_plan_params)
      redirect_to @workout_plan, notice: "Workout plan updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_plan.destroy
    redirect_to workout_plans_path, notice: "Workout plan deleted."
  end

  private

  def find_workout_plan
    @workout_plan = WorkoutPlan.find_by(id: params[:id])
    unless @workout_plan && current_user.pairings.exists?(@workout_plan.pairing_id)
      redirect_to root_path, alert: "Not authorized."
    end
  end

  def workout_plan_params
    params.require(:workout_plan).permit(:title, :description)
  end
end
