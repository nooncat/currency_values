class BaseWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'
end
