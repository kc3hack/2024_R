Rails.application.routes.draw do
  devise_for :users

  root to: 'shops#index'
  get 'shops/search' , to: "shops#search"
  resources :shops, only: [:show, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
