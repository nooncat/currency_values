Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'rates#index'

  mount ActionCable.server => '/cable'

  namespace :admin do
    mount Sidekiq::Web => '/sidekiq'

    root 'rates#edit_index'

    resources :rates, only: [:update]
  end
end
