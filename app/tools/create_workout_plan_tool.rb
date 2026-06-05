class CreateWorkoutPlanTool < RubyLLM::Tool
  desc "Creates a personalized workout plan for a gym pair by finding the most relevant exercises " \
       "via semantic search. Call this when the pair asks for a custom workout plan."

  params WorkoutPlanSchema

  def initialize(pairing:)
    @pairing = pairing
  end

  def execute(title:, description:, n_exercises:)
    embedding = RubyLLM.embed(description, provider: :openai, assume_model_exists: true).vectors
    exercises = Exercise.nearest_neighbors(:embedding, embedding, distance: "cosine").first(n_exercises)

    plan = WorkoutPlan.create!(pairing: @pairing, title: title, description: description)

    exercises.each do |exercise|
      sets, reps, rest = defaults_for(exercise.difficulty)
      WorkoutPlanExercise.create!(
        workout_plan: plan,
        exercise: exercise,
        n_sets: sets,
        n_repetitions: reps,
        rest_in_s: rest
      )
    end

    "Workout plan '#{plan.title}' created with #{exercises.count} exercises: #{exercises.map(&:title).join(', ')}."
  end

  private

  def defaults_for(difficulty)
    case difficulty
    when "Beginner"     then [3, 12,  60]
    when "Intermediate" then [4, 10,  90]
    when "Advanced"     then [5,  8, 120]
    else                     [3, 12,  60]
    end
  end
end
