Rails.application.routes.draw do
  root 'home#index'

  resource :session, controller: 'sessions'
  resources :users, controller: 'users'

  resources :maps
  resources :pins, only: %i[create destroy]
  resources :search_places, only: %i[create]
  resources :tagged_pins, only: %i[create destroy]
end
