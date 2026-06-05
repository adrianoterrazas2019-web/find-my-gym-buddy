class WorkoutPlanSchema < RubyLLM::Schema
  string :title, description: "Title of the workout plan"
  text :description, description: "Workout plan description with goals, target muscles and difficulty"
end
