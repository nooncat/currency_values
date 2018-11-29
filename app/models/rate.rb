class Rate < ActiveRecord::Base
  validates :from, presence: true
  validates :to, presence: true
  validates :from, uniqueness: { scope: :to }

  validates :value,
            presence: true,
            numericality: { greater_than: 0, less_than: 1_000_000_000 }

  before_save :upcase_from_and_to

  def self.find(param)
    if param.is_a?(Integer)
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
end
