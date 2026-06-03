Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  resource :user_profile,
           only: [:show, :edit, :update],
           as: :my_profile

  resources :user_profiles, only: [:index, :show]

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
