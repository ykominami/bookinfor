Rails.application.routes.draw do
  resources :categories
  resources :readstatuses
  resources :shapes
  resources :bookstores
  resources :efgs
  get "booklists/displayx(/:ind)" => "booklists#displayx"
  get "booklists/finish(/:ind)" => "booklists#finish"
  get "home/index" => "home#show"
  get "booklists/index2(/:ind)" => "booklists#index2"
  get "booklists/index3(/:ind)" => "booklists#index3"
  # root to: "home#index"

  # get "kindlelists/show(/:id)" => "kindlelists#show"

  resources :abcs
  resources :efgs
  resources :calibrelists
  resources :readinglists
  resources :kindlelists, only: [:show, :index, :new, :edit]

  resources :booklists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "booklists#index"
end
