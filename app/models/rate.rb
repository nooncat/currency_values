class Rate < ActiveRecord::Base
  validates :from, presence: true
  validates :to, presence: true
  validates :from, uniqueness: { scope: :to }

  validates :value,
            presence: true,
            numericality: { greater_than: 0, less_than: 1_000_000_000 }
  validates :manual_value,
            numericality: { greater_than: 0, less_than: 1_000_000_000 },
            allow_nil: true

  validates_datetime :manual_value_till, after: -> { Time.zone.now }, allow_nil: true

  before_save :upcase_from_and_to
  after_commit :force_value,
               on: :update,
               if: -> { previous_changes[:manual_value].present? }
  after_commit :schedule_value_update,
               on: :update,
               if: -> { previous_changes[:manual_value_till].present? }
  after_commit :broadcast_changes, on: :update, if: -> { previous_changes[:value].present? }

  def self.find(param)
    if param.is_a?(Integer) || param.to_i.positive?
      super
    else
      params = param.split('_')
      find_by!(from: params[0], to: params[1])
    end
  end

  def to_param
    "#{from}_#{to}"
  end

  private

  def upcase_from_and_to
    from.upcase!
    to.upcase!
  end

  def broadcast_changes
    RateChannel.broadcast_to(self, value: value)
  end

  def force_value
    update(value: manual_value)
  end

  def schedule_value_update
    Rates::UpdateValuesWorker.remove_scheduled_job([[id]])
    Rates::UpdateValuesWorker.perform_at(manual_value_till, [id])
  end
end
