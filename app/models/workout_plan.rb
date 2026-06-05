class WorkoutPlan < ApplicationRecord
  belongs_to :pairing
  has_many :workout_plan_exercises, dependent: :destroy
  has_one :chat, as: :chattable, dependent: :destroy

  after_create { create_chat! }
end
