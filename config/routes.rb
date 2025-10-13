Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  get "about", to: "about#index"

  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  get  "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "profile/:id", to: "profiles#new", as: "view_profile"
  get "profile/:id/edit", to: "profiles#edit", as: "edit_profile"
  patch "profile/:id", to: "profiles#update", as: "update_profile"

  get "password/reset", to: "password_resets#new", as: "forgot_password"
  post "password/reset", to: "password_resets#create", as: "create_password"
  get "password/reset/edit", to: "password_resets#edit", as: "edit_password"
  patch "password/reset/edit", to: "password_resets#update", as: "update_password"

  resources :products

  get "bookings", to: "bookings#new", as: "new_booking"
  post "bookings", to: "bookings#create", as: "create_booking"
  get "bookings/my", to: "bookings#index", as: "list_bookings"
  get "bookings/:id", to: "bookings#show", as: "view_booking"
  delete "bookings/:id", to: "bookings#destroy", as: "delete_booking"

  root to: "main#index"
end
