Rails.application.routes.draw do
  root 'maps#index'

  get '/'      => 'home#index'
  get '/about' => 'home#about'

  resource :session, controller: 'sessions'
  resources :users, controller: 'users'

  resources :maps
  resources :books, only: %i[index show]
  resources :pins, only: %i[create update destroy]
  resources :search_places, only: %i[create]
  resources :tagged_pins, only: %i[create destroy]

  get '/legal/privacy' => 'legal#privacy'
  get '/legal/terms'   => 'legal#terms'
end
