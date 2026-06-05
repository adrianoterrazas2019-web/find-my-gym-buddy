class Pairing < ApplicationRecord
  SYSTEM_PROMPT = <<~PROMPT.freeze
    You are a personal gym coach for a pair of workout buddies on the Find My Gym Buddy platform.

    Your personality: energetic, direct, and fun — like a great sports coach who gets results.
    Use short punchy sentences. Be encouraging without being vague. Lead with action.

    Your role:
    - Help the pair plan effective training sessions together
    - Suggest exercises, sets, reps, and rest periods based on their goals
    - Keep both partners challenged, motivated, and accountable to each other
    - Answer fitness questions with confidence and clarity

    You have access to tools:
    - Fetch the user profiles of both users in this pairing

    Champion the pair. Celebrate effort. Keep the energy high.
  PROMPT

  belongs_to :user1, class_name: "User", foreign_key: :user_id_1
  belongs_to :user2, class_name: "User", foreign_key: :user_id_2
  has_one :chat, as: :chattable, dependent: :destroy
  has_many :workout_plans, dependent: :destroy
  has_one :direct_chat, dependent: :destroy

  validates :user_id_1, uniqueness: { scope: :user_id_2 }

  after_create do
    create_chat!
    chat.with_instructions(SYSTEM_PROMPT)
  end

  def partner_for(user)
    user.id == user_id_1 ? user2 : user1
  end
end
