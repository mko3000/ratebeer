# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'breweries#index'

  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  resources :places, only: [:index, :show]
  resources :ratings, only: [:index, :new, :create, :destroy]

  resource :session, only: [:new, :create, :destroy]

  # Custom routes
  get    'kaikki_bisset', to: 'beers#index'
  get    'signup',        to: 'users#new'
  get    'signin',        to: 'sessions#new'
  delete 'signout',       to: 'sessions#destroy'
  post   'places',        to: 'places#search'
  get    'beerlist',      to: 'beers#list'
  get    'brewerylist',   to: 'breweries#list'

  # Health check
  get 'up', to: 'rails/health#show', as: :rails_health_check

  # PWA routes (uncomment if needed)
  # get 'manifest',        to: 'rails/pwa#manifest',        as: :pwa_manifest
  # get 'service-worker',  to: 'rails/pwa#service_worker',  as: :pwa_service_worker
end
# rubocop:enable Metrics/BlockLength
