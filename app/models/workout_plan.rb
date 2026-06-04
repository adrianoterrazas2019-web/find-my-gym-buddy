class WorkoutPlan < ApplicationRecord
  belongs_to :pairing
  has_many :workout_plan_exercises, dependent: :destroy
end
