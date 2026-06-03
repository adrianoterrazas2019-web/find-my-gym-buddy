Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  resources :users do
    resources :requests, only: [:create]
  end
  resources :requests, only: [:index, :update]
  resources :pairings, only: [:index, :show, :destroy]

  resource :user_profiles, only: [:show, :edit, :update, :index]

  resources :chats do
    resources :messages, only: [:create]
  end

  resources :models, only: [:index, :show] do
    collection do
      post :refresh
    end
  end
  resources :calendars, only: [:index]
  resources :calendar_entries, only: [:new, :create, :edit, :update, :destroy]
  root "pages#home"

  # Test-only: sign in without going through the browser form so system tests
  # don't depend on Turbo intercepting the Devise session form correctly.
  if Rails.env.test?
    get "/test_sign_in/:user_id", to: "test_sessions#create", as: :test_sign_in
  end
end
