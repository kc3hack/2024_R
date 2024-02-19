Rails.application.routes.draw do
  get 'shops/index'
  get 'shops/show'
  get 'shops/search' , to: "shops#search"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
