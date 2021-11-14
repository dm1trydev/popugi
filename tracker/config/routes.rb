Rails.application.routes.draw do
  root to: 'tasks#index'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :tasks, only: %i[index show new create] do
    post :pour_millet_into_a_bowl, on: :member

    collection do
      post :catch_birds
      get :my
    end
  end
end
