Rails.application.routes.draw do

  root to: 'homepage#show'
  
  devise_for :users, controllers: {sessions: "users/sessions" }
  
  resources :sessions, only: [:new, :create, :destroy]

#  get '/signin',  to: 'users/sessions#new'
  get '/signout', to: 'users#signout'


  
  resources :logs
  resources :forbiddens
  resources :assigneds
  resources :relations

  resources :users do
    collection do
      post :assign_roles
      get  :signout
      get  :signin
    end
  end
  

  
end
