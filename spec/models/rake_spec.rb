require 'rails_helper'

describe Rate do
  describe 'validations' do
    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }

    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value).is_greater_than(0).is_less_than(1_000_000_000) }
  end
end
