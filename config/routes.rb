Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'rates#index'

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
end
