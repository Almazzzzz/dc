Rails.application.routes.draw do

  resources   :payments do
    get       '/donate' => 'payments#donate'
  end

  resources   :polls
  match       '/polls/:id/voting' => 'polls#voting', via: [:get], :as => :voting_poll
  post        '/votes' => 'votes#create', via: [:post], :as => :new_votes

  resources   :comments

  resources   :posts
  match       'posts/category' => 'posts#set_category', via: [:post], :as => :set_category

  resources		:profiles, only: [:show, :edit, :update ]
  resources 	:flats
  resources   :chat_messages

  devise_for 	:users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  #devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources   :users do
    resources :emails, only: [:index, :show, :new, :create, :destroy]
  end

  match 		  '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup

  root 			  'welcome#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount ActionCable.server => '/cable'

  # Routes for custom error pages
  match "/404", to: "errors#not_found", via: :all
  match "/422", to: "errors#unacceptable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

end
