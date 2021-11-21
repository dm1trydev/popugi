Rails.application.routes.draw do
  root 'dashboard#index'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :dashboard, only: :index
end
