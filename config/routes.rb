Rails.application.routes.draw do

  root to: 'homepage#show'
  
  devise_for :users, controllers: {sessions: "users/sessions" }
  
  resources :sessions, only: [:new, :create, :destroy]

  get  '/signout',        to: 'users#signout'
  get  '/resetdb',        to: 'resetdb#resetdb'
  post '/resetdb_commit', to: 'resetdb#resetdb_commit'
  
  resources :logs, only: [:index, :show]
  resources :forbiddens

  resources :assigneds
  resources :relations

  resources :users
  

  
end
