Rails.application.routes.draw do

  resources :movements 
  root 'welcome#index'
end
