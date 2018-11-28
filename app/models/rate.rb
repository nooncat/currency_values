class Rate < ActiveRecord::Base
  validates :from, presence: true
  validates :to, presence: true
  validates :value,
            presence: true,
            numericality: { greater_than: 0, less_than: 1_000_000_000 }
end
