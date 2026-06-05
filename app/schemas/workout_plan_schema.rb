class WorkoutPlanSchema < RubyLLM::Schema
  string :title, description: "Title of the workout plan"
  text :description, description: "Workout plan description with goals, target muscles and difficulty"
  integer :n_exercises, description: "Number of exercises suited to the pair's experience and goals (typically 4–8)"
end
