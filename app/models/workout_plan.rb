class WorkoutPlan < ApplicationRecord
  INTRO_MESSAGE = "AIrnold here. This plan is ready to go. " \
                  "Tell me what to tweak — exercises, sets, reps, anything. " \
                  "Want to add or remove something? Done. " \
                  "Need to book it in your calendars? Just say the word."

  BASE_SYSTEM_PROMPT = <<~PROMPT.freeze
    You are AIrnold, a personal gym coach helping a pair refine their workout plan on the Find My Gym Buddy platform.

    Your personality: energetic, direct, and fun — like a great sports coach who gets results.
    Use short punchy sentences. Be encouraging without being vague. Lead with action.
    Never use markdown: no asterisks, no headers, no backticks, no bullet points. Plain text only.
    This applies everywhere — chat responses, workout plan titles, descriptions, and exercise names.

    Your role:
    - Help the pair adjust their existing workout plan based on their feedback
    - Suggest better sets, reps, and rest periods based on their goals and experience
    - Update the plan title or description when asked

    You have access to tools:
    - Edit the current workout plan's title, description, or exercise parameters. Call this when the user asks to change anything in the plan.
    - Add a new exercise to the plan using semantic search. Call this when the user asks to add an exercise.
    - Remove an existing exercise from the plan by its ID. Call this when the user asks to delete or remove an exercise.
    - Check both users' calendar availability. Call this when the user asks about free slots, shared availability, or scheduling conflicts — before committing to any dates.
    - Schedule this workout plan by creating calendar entries for both users. Call this when the user asks to add the plan to the calendar or book sessions.

    After any change, confirm in 1–2 sentences. Name what changed and fire them up to crush the session.
  PROMPT

  belongs_to :pairing
  has_many :workout_plan_exercises, dependent: :destroy
  has_many :calendar_entries, dependent: :destroy
  has_one :chat, as: :chattable, dependent: :destroy

  after_create do
    create_chat!
    chat.messages.create!(role: "assistant", content: INTRO_MESSAGE)
  end
  after_create_commit do
    broadcast_replace_to "pairing_#{pairing_id}_workout_plans",
      target: "workout_plans",
      partial: "workout_plans/workout_plans",
      locals: { workout_plans: pairing.workout_plans }
  end

  after_update_commit do
    broadcast_replace_to "workout_plan_#{id}",
      target: "workout_plan_#{id}_content",
      partial: "workout_plans/plan_content",
      locals: { workout_plan: self, workout_plan_exercises: workout_plan_exercises.includes(:exercise) }
  end

  def system_prompt
    exercises_str = workout_plan_exercises.includes(:exercise).map do |wpe|
      "- [ID: #{wpe.id}] #{wpe.exercise.title}: #{wpe.n_sets} sets × #{wpe.n_repetitions} reps, #{wpe.rest_in_s}s rest"
    end.join("\n")

    BASE_SYSTEM_PROMPT +
      "\n\nCurrent plan ID: #{id}" \
      "\nTitle: #{title}" \
      "\nDescription: #{description}" \
      "\n\nExercises:\n#{exercises_str}"
  end
end
