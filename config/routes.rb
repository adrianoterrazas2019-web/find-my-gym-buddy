Rails.application.routes.draw do
  get "calendars/index"
  resources :user_profiles, only: [:show]
  devise_for :users
  resources :chats do
    resources :messages, only: [ :create ]
  end
  resources :models, only: [ :index, :show ] do
    collection do
      post :refresh
    end
  end
  resources :calendars, only: [:index]
  resources :calendar_entries, only: [:new, :create, :edit, :update, :destroy]
  root "pages#home"
end
