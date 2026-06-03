Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

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
end
