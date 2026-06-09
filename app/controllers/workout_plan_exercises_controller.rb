class WorkoutPlanExercisesController < ApplicationController
  before_action :find_workout_plan
  before_action :find_exercise, only: [:edit, :update, :destroy]

  def new
    @workout_plan_exercise = @workout_plan.workout_plan_exercises.new
    @exercises = Exercise.order(:title)
  end

  def create
    @workout_plan_exercise = @workout_plan.workout_plan_exercises.new(workout_plan_exercise_params)
    if @workout_plan_exercise.save
      redirect_to @workout_plan, notice: "Exercise added."
    else
      @exercises = Exercise.order(:title)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @exercises = Exercise.order(:title)
  end

  def update
    if @workout_plan_exercise.update(workout_plan_exercise_params)
      redirect_to @workout_plan, notice: "Exercise updated."
    else
      @exercises = Exercise.order(:title)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout_plan_exercise.destroy
    redirect_to @workout_plan, notice: "Exercise removed."
  end

  private

  def find_workout_plan
    @workout_plan = WorkoutPlan.find_by(id: params[:workout_plan_id])
    unless @workout_plan && current_user.pairings.exists?(@workout_plan.pairing_id)
      redirect_to root_path, alert: "Not authorized."
    end
  end

  def find_exercise
    @workout_plan_exercise = @workout_plan.workout_plan_exercises.find(params[:id])
  end

  def workout_plan_exercise_params
    params.require(:workout_plan_exercise).permit(:exercise_id, :n_sets, :n_repetitions, :rest_in_s)
  end
end
