Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'rates#index'

  mount ActionCable.server => '/cable'

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq'
  end
end
