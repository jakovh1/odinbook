Rails.application.routes.draw do
  resources :chats, param: :uuid, except: [ :new, :edit, :destroy ] do
    resources :messages, only: [ :create ]
  end

  resources :notifications, only: [ :index ]

  root "posts#index"

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :users, only: [ :index ] do
    # routing for uploading an avatar
    member do
      patch :avatar, to: "users#update_avatar"
    end
  end

  resources :follows, only: [ :update, :create, :destroy ]

  resources :posts, except: [ :edit, :show, :update ] do
    resources :comments, only: [ :create, :new ]
  end

  resources :comments, only: [ :destroy ]

  post "follow/:followee_id", to: "follows#create", as: :create_follow_request

  # Like and Unlike routes
  post "posts/:uuid/like", to: "posts#like", as: :like
  delete "posts/:uuid/dislike", to: "posts#dislike", as: :dislike

  patch "notifications/:id/update", to: "notifications#update", as: :notification_update
  get "/:username/post/:uuid", to: "posts#show", as: :user_post

  # User show route
  get "/:username", to: "users#show", as: :profile, constraints: { id: /[^notifications]/ }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
