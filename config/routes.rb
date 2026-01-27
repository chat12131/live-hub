Rails.application.routes.draw do
  get 'mypage', to: 'users#show'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  resources :artists do
    collection do
      get :favorites
      get :list
    end
    resources :members, only: [:index, :destroy]
    member do
      post 'toggle_favorite'
    end
  end
  resources :live_schedules do
    collection do
      get :planned
      get :records
    end
    resources :venues, only: [:new, :create]
  end
  resources :goods do
    collection do
      get :list
    end
    resources :categories, only: [:new, :create]
  end
  get 'statistics', to: 'statistics#index'
  get 'statistics/live', to: 'statistics#live'
  get 'statistics/goods', to: 'statistics#goods'
  get 'statistics/artists', to: 'statistics#artists'
  root 'home#index'
end
