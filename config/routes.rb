Rails.application.routes.draw do

  devise_for :users
  resources :movements

  authenticated :user do
    root 'movements#index', :as => "authenticated_root"
  end

  root 'welcome#index'

  mount API => '/'
end
