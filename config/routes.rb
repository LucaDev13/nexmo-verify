Rails.application.routes.draw do
  devise_for :users
  resources :verifications, only: [:edit, :update]
  resources :pages
  root to: 'visitors#index'


end
