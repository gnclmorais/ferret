Rails.application.routes.draw do
  root 'home#index'

  #Map::Application.routes.draw do
    constraints Clearance::Constraints::SignedIn.new do
      root to: 'maps#index', as: :signed_in_root
    end

    constraints Clearance::Constraints::SignedOut.new do
      root to: 'maps#index'
    end
  #end

  resources :maps
  resources :pins, only: %i[create destroy]
  resources :search_places, only: %i[create]
end
