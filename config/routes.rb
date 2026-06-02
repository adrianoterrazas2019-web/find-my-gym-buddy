Rails.application.routes.draw do
  resources :user_profiles, only: [:show]
  devise_for :users
  resources :users do
    resources :requests, only: [:create]
  end
  resources :requests, only: [:index, :update]
  resources :chats do
    resources :messages, only: [ :create ]
  end
  resources :models, only: [ :index, :show ] do
    collection do
      post :refresh
    end
  end
  root "pages#home"
end
