class WorkoutPlanExercise < ApplicationRecord
  belongs_to :workout_plan, touch: true
  belongs_to :exercise
end
