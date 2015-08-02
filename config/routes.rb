Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :users, only: [:index, :show] do
    member do
      get :drum
      get :guitar
    end
  end
end
