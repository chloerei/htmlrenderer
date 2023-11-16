Rails.application.routes.draw do
  resources :images, only: [:create]

  get "up", to: "rails/health#show", as: :rails_health_check
end
