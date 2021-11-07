Rails.application.routes.draw do
  use_doorkeeper
  devise_for :accounts

  root to: 'accounts#index'

  resources :accounts, only: %w[edit update]
end
