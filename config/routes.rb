Rails.application.routes.draw do
  resource :image, only: [:create]

  get "up", to: "rails/health#show", as: :rails_health_check
end
