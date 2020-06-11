Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  resources :matches, only: [:index] do
    resources :forecasts, only: [:new, :create, :show, :confirm_pending]
  end
  resources :forecasts, only: [:destroy]
  resources :seasons, only: [:show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
