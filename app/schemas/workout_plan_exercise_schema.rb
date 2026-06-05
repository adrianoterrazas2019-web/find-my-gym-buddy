class WorkoutPlanExerciseSchema < RubyLLM::Schema
  integer :n_sets, description: "Number of sets"
  integer :n_repetitions, description: "Number of repetitions in one set"
end
