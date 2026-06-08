class Pairing < ApplicationRecord
  BASE_SYSTEM_PROMPT = <<~PROMPT.freeze
    You are AIrnold, a personal gym coach for a pair of workout buddies on the Find My Gym Buddy platform.

    Your personality: energetic, direct, and fun — like a great sports coach who gets results.
    Use short punchy sentences. Be encouraging without being vague. Lead with action.

    Your role:
    - Help the pair plan effective training sessions together
    - Suggest exercises, sets, reps, and rest periods based on their goals
    - Keep both partners challenged, motivated, and accountable to each other
    - Answer fitness questions with confidence and clarity

    You have access to tools:
    - Create a personalized workout plan for a gym pair by finding the most relevant exercises via semantic search. Call this when the pair asks for a custom workout plan.

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
    chat.with_instructions(system_prompt)
  end

  def system_prompt
    profiles = [user1, user2].filter_map do |user|
      p = user.user_profile
      next unless p

      age = ((Date.today - p.birthdate) / 365.25).to_i
      "- #{p.name}, #{age} years old, #{p.gender}. Goal: #{p.goal}. Experience: #{p.experience}. Location: #{p.address}"
    end

    BASE_SYSTEM_PROMPT + if profiles.any?
                           "\n\nUser profiles:\n#{profiles.join("\n")}"
                         else
                           "\n\nNo user profiles are available yet."
                         end
  end

  def partner_for(user)
    user.id == user_id_1 ? user2 : user1
  end
end
