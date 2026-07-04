Rails.application.routes.draw do
  # Landing page dos convidados
  root "uploads#new"
  post "fotos", to: "uploads#create", as: :photos_upload
  get "obrigado", to: "uploads#thanks", as: :thanks

  # Área de administração
  namespace :admin do
    root "photos#index"
    get "entrar", to: "sessions#new", as: :login
    post "entrar", to: "sessions#create"
    delete "sair", to: "sessions#destroy", as: :logout
    resources :photos, only: [ :index, :show, :destroy ]
    get "qr", to: "qr_codes#show", as: :qr
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end
