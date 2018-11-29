require 'rails_helper'

describe ::Rates::ValuesUpdater do
  describe '.call' do
    let!(:rate) { create(:rate, from: 'USD', to: 'RUB', value: 65.123456) }
    let(:received_data) { { 'USD_RUB' => 67.654321 } }

    it 'update rate with received data' do
      expect do
        described_class.new(received_data).call
        rate.reload
      end
        .to change(rate, :value).from(65.123456).to(67.654321)
    end
  end
end
