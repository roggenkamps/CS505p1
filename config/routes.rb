Rails.application.routes.draw do

  root to: 'homepage#show'
  
  devise_for :users, controllers: {sessions: "users/sessions" }
  
  resources :sessions, only: [:new, :create, :destroy]

  get '/signout', to: 'users#signout'
  
  resources :logs, only: [:index, :show]
  resources :forbiddens

  resources :assigneds
  resources :relations

  resources :users
  

  
end
