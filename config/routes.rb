Rails.application.routes.draw do
  devise_for :users
  root 'pages#home', as: :pages_home

  get '/options', to: 'options#index'
  get '/options/create', to: 'options#create'

  # Non-RESTful endpoints for triggering updates
  get '/stocks/update', to: 'stocks#update', as: :stocks_update
  get '/options/update', to: 'options#update', as: :options_update
end
