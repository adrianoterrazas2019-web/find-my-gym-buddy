Rails.application.routes.draw do
  devise_for :users
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
