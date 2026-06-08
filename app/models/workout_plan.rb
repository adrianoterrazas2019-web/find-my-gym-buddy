class WorkoutPlan < ApplicationRecord
  belongs_to :pairing
  has_many :workout_plan_exercises, dependent: :destroy
  has_one :chat, as: :chattable, dependent: :destroy

  after_create { create_chat! }
  after_create_commit do
    broadcast_replace_to "pairing_#{pairing_id}_workout_plans",
      target: "workout_plans",
      partial: "workout_plans/workout_plans",
      locals: { workout_plans: pairing.workout_plans }
  end
end
