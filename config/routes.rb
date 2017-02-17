# require 'sidekiq/web'

Rails.application.routes.draw do
  root 'app#home'

  get 'app' => 'app#home'
  get '/search' => 'app#search'
  get '/discover' => 'app#discover'
  get '/explore' => 'app#explore'

  devise_for :users,
                    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :feedbacks, :only => [:create]

  # mount Sidekiq::Web => '/sidekiq'
end
