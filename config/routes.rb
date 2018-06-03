Rails.application.routes.draw do
  root 'maps#index'

  resource :session, controller: 'sessions'
  resources :users, controller: 'users'

  resources :maps
  resources :pins, only: %i[create destroy]
  resources :search_places, only: %i[create]
  resources :tagged_pins, only: %i[create destroy]

  # resource :legal, only: %i[privacy terms]
  get '/legal/privacy' => 'legal#privacy'
  get '/legal/terms' => 'legal#terms'
end
