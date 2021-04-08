Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
end

  root to: 'pages#home'

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end
  get 'about', to: 'pages#about'
  get 'settings', to: 'pages#settings'
  get 'rules', to: 'pages#rules'
  get 'contact', to: 'pages#contact'
  get 'dashboard', to: 'pages#dashboard'
  get 'confidentialite', to: 'pages#confidentialite'
  get 'store_outcome', to: 'forecasts#store_outcome', defaults: {format: :json}
  get 'store_outcome_b2e', to: 'forecasts#store_outcome_b2e', defaults: {format: :json}
  get 'store_outcome_under', to: 'forecasts#store_outcome_under', defaults: {format: :json}
  get 'store_outcome_striker1', to: 'forecasts#store_outcome_striker1', defaults: {format: :json}
  get 'confirm_pending', to: 'forecasts#confirm_pending', defaults: {format: :json}
  get '/sitemap.xml.gz', to: redirect("https://s3-eu-west-3.amazonaws.com/storpesitemap/sitemap.xml.gz")
  post "/friends/add" => "friends/add"
  post "/friends/reject" => "friends/reject"
  post "/friends/remove" => "friends/remove"
  get "/friends/search" => "friends/search"
  post "/friends/search" => "friends/search"

  resources :pages, only: [:show]
  resources :articles
  resources :matches, only: [:index] do
    resources :forecasts, only: [:new, :create, :show, :confirm_pending]
  end
  resources :forecasts, only: [:destroy]
  resources :seasons, only: [:show]
  resources :player_seasons
  resources :friends, only: [:index, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
