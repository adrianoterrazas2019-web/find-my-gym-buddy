class AddChatsToExistingWorkoutPlans < ActiveRecord::Migration[8.1]
  def up
    WorkoutPlan.find_each do |workout_plan|
      workout_plan.create_chat! unless workout_plan.chat
    end
  end

  def down
    Chat.where(chattable_type: "WorkoutPlan").destroy_all
  end
end
