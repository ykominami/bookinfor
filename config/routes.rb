Rails.application.routes.draw do
  get "home/index" => "home#show"
  root to: "home#index"

  resources :abcs
  resources :calibrelists
  resources :readinglists
  resources :kindlelists
  resources :booklists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
