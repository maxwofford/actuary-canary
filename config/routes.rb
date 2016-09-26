Rails.application.routes.draw do
  root "options#index"

  # Non-RESTful endpoints for triggering updates
  get "/stocks/update", to: "stocks#update", as: :stocks_update
  get "/options/update", to: "options#update", as: :options_update
end
