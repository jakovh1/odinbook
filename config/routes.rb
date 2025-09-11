Rails.application.routes.draw do
  resources :follows, only: [ :update, :create, :destroy ]
  post "follow/:followee_id", to: "follows#create", as: :create_follow_request

  devise_for :users

  resources :users, only: [ :index ] do
    resources :posts, only: [ :show ]
    resources :comments, only: [ :show ]
  end

  resources :posts, only: [ :index, :new, :destroy, :create ] do
    resources :comments, only: [ :create, :new ]
  end

  resources :comments, only: [ :destroy ]

  root "posts#index"

  # Like and Unlike routes
  post "posts/:id/like", to: "posts#like", as: :like
  delete "posts/:id/dislike", to: "posts#dislike", as: :dislike
  get "/:username", to: "users#show", as: :profile


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
