Rails.application.routes.draw do
  resources :efgs
  get "booklists/displayx(/:ind)" => "booklists#displayx"
  get "home/index" => "home#show"
  get "booklists/index2(/:ind)" => "booklists#index2"
  get "booklists/index3(/:ind)" => "booklists#index3"
  # root to: "home#index"

  resources :abcs
  resources :calibrelists
  resources :readinglists
  resources :kindlelists
  resources :booklists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "booklists#index"
end
