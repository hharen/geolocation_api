Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :geolocation_objects, only: :create
  get 'geolocation_objects', to: 'geolocation_objects#object'
  delete 'geolocation_objects', to: 'geolocation_objects#destroy'
end
