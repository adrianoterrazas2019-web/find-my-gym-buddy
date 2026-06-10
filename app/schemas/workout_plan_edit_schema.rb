class WorkoutPlanEditSchema < RubyLLM::Schema
  string :title, description: "Plan title — keep the current value if the user did not ask to change it. Don't use markdown."
  string :description, description: "Plan description — keep the current value if the user did not ask to change it. Don't use markdown."
  array :exercise_updates, description: "Include only exercises whose parameters need to change" do
    object do
      integer :workout_plan_exercise_id, description: "ID of the WorkoutPlanExercise record to update"
      integer :n_sets, description: "Number of sets"
      integer :n_repetitions, description: "Number of repetitions per set"
      integer :rest_in_s, description: "Rest in seconds between sets"
    end
  end
end
