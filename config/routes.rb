Rails.application.routes.draw do
  resource :pdf, only: [:create], controller: :pdf
  resource :screenshot, only: [:create], controller: :screenshot

  get "up", to: "rails/health#show", as: :rails_health_check
end
