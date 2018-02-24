Rails.application.routes.draw do

  resources :logs
  resources :forbiddens
  resources :assigneds
  resources :relations
  root 'application#welcome'

  resources :users

  
end
