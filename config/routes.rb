Rails.application.routes.draw do

  resources :movements 
  root 'movements#index'
end
