Rails.application.routes.draw do

  root to: 'users#show'
  
  devise_for :users, controllers: {sessions: "users/sessions" }

  resources :sessions, only: [:new, :create, :destroy]
  get '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'


  
  resources :logs
  resources :forbiddens
  resources :assigneds
  resources :relations

  resources :users
  

  
end
