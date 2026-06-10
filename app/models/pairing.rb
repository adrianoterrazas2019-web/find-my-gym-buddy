class Pairing < ApplicationRecord
  INTRO_MESSAGE = "Hey! I'm AIrnie — your personal gym coach. " \
                  "Tell me what you want to train and I'll build a plan. " \
                  "Need to check your schedules? I've got you. " \
                  "Ready to book sessions? Just say the word. Let's go!"

  BASE_SYSTEM_PROMPT = <<~PROMPT.freeze
    You are AIrnie, a personal gym coach for a pair of workout buddies on the Find My Gym Buddy platform.

    Your personality: energetic, direct, and fun — like a great sports coach who gets results.
    Use short punchy sentences. Be encouraging without being vague. Lead with action.
    Never use markdown: no asterisks, no headers, no backticks, no bullet points. Plain text only.

    Your role:
    - Help the pair plan effective training sessions together
    - Suggest exercises, sets, reps, and rest periods based on their goals and experience
    - Keep both partners challenged, motivated, and accountable to each other
    - Answer fitness questions with confidence and clarity

    You have access to tools:
    - Create a personalized workout plan for a gym pair by finding the most relevant exercises via semantic search. Call this when the pair asks for a custom workout plan. Pass the user's FULL request as user_request — including any specified title (e.g. "Unicorn Workout"), desired intensity (e.g. "hardcore", "chill", "restorative"), and any other preferences. Do not paraphrase or summarise: pass the user's exact words.
    - Check both users' calendar availability. Call this when the user asks about free slots, shared availability, or scheduling conflicts — before committing to any dates.
    - Schedule a workout plan by adding it to both users' calendars. Call this when the pair asks to schedule or add a workout plan to their calendars. Call schedule_workout_plan exactly once per user request — never more than once, even if the message could be interpreted as eager or repeated.

    Champion the pair. Celebrate effort. Keep the energy high.

    After creating a workout plan, confirm it in 2–3 sentences only. Name the plan and say one thing that makes it a great fit for this pair, then fire them up to get started.
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
    chat.messages.create!(role: "assistant", content: INTRO_MESSAGE)
  end

  def system_prompt
    today = Time.current.strftime("%A, %B %-d, %Y")
    profiles = [user1, user2].filter_map do |user|
      p = user.user_profile
      next unless p

      age = ((Date.today - p.birthdate) / 365.25).to_i
      "- #{p.name}, #{age} years old, #{p.gender}. Goal: #{p.goal}. Experience: #{p.experience}. Location: #{p.address}"
    end

    date_instruction = "\n\nToday is #{today}. When calling the schedule_workout_plan tool, " \
                       "always convert relative dates (e.g. \"next Sunday\", \"every Saturday in July\") " \
                       "to explicit calendar dates (e.g. \"Sunday, June 14, 2026\") in the user_request parameter."

    plans_section = if workout_plans.any?
                      plans_list = workout_plans.map { |wp| "- [ID: #{wp.id}] #{wp.title}" }.join("\n")
                      "\n\nAvailable workout plans:\n#{plans_list}"
                    else
                      "\n\nNo workout plans have been created yet."
                    end

    profiles_section = if profiles.any?
                         "\n\nUser profiles:\n#{profiles.join("\n")}"
                       else
                         "\n\nNo user profiles are available yet."
                       end

    BASE_SYSTEM_PROMPT + date_instruction + plans_section + profiles_section
  end

  def partner_for(user)
    user.id == user_id_1 ? user2 : user1
  end
end
