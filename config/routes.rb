Rails.application.routes.draw do
  resource :screenshot, only: [:create], controller: :screenshot

  get "up", to: "rails/health#show", as: :rails_health_check
end
