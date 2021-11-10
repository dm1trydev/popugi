Rails.application.routes.draw do
  root to: 'tasks#index'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :tasks, only: %i[index show new create] do
    post :close, on: :member

    collection do
      post :assign_tasks, as: :assign
      get :my
    end
  end
end
