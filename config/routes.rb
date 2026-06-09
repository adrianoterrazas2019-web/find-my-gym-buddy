Rails.application.routes.draw do

  resources :calendar_entries

  devise_for :users, controllers: { registrations: "registrations" }
  resources :users do
    resources :requests, only: [:create]
  end
  resources :requests, only: [:index, :update]
  resources :pairings, only: [:index, :show, :create, :destroy] do
    resources :workout_plans, only: [:index, :new, :create]
    resources :direct_messages, only: [:create]
  end
  resources :workout_plans, only: [:index, :show, :edit, :update, :destroy] do
    resources :workout_plan_exercises, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :user_profiles, only: [:show, :edit, :update, :index]

  resources :chats do
    member do
      delete :clear
    end
    resources :messages, only: [:create]
  end

  resources :models, only: [:index, :show] do
    collection do
      post :refresh
    end
  end
  resources :calendars, only: [:index]
  root "pages#home"

  # Test-only: sign in without going through the browser form so system tests
  # don't depend on Turbo intercepting the Devise session form correctly.
  if Rails.env.test?
    get "/test_sign_in/:user_id", to: "test_sessions#create", as: :test_sign_in
  end

  authenticate :user, ->(user) { user.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end
end
