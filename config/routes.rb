Rails.application.routes.draw do
  get "user_profiles/show"
  root "pages#home"
end
