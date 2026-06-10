class WorkoutPlanSchema < RubyLLM::Schema
  string :title, description: "Title of the workout plan. If the user suggests a title, take it into account. Don't use markdown."
  string :description, description: "Workout plan description with goals, target muscles and difficulty. Don't user markdown."
end
