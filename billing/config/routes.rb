Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :accounts_balances, only: :index
  resources :balances, only: :show
  resources :balance_cycles, only: [] do
    post :close, on: :collection
  end

  root to: 'accounts_balances#index'
end
