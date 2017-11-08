Rails.application.routes.draw do
  resources :maps
  resources :pins, only: %i[create destroy]

  resources :search_places, only: %i[create]
end
