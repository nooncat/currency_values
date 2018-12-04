class BaseWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'default'

  def self.remove_scheduled_job(args, at = nil) # rubocop:disable CyclomaticComplexity
    return true if defined?(Sidekiq::Testing) && Sidekiq::Testing.fake?

    Sidekiq::ScheduledSet.new.each do |job|
      next unless job.klass == name && job.args == args
      next unless at.nil? || job.at == at

      job.delete
    end

    true
  end
end
