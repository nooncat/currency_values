require 'rails_helper'

describe ::Rates::ValuesFetcher do
  let(:first_rate) { create(:rate, from: 'AAA', to: 'BBB') }
  let(:second_rate) { create(:rate, from: 'XXX', to: 'YYY') }
  let(:object) { described_class.new([first_rate, second_rate]) }

  describe '.call' do
    it 'should return hash with rates values' do
      stub_request(:get, object.send(:url))
        .with(
          headers: {
            'Accept': '*/*',
            'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent': 'Ruby'
          }
        )
        .to_return(
          status: 200,
          body: {
            first_rate.to_param => 33.333333,
            second_rate.to_param => 44.444444
          }.to_json,
          headers: {}
        )
      expect(object.call).to eql 'AAA_BBB' => 33.333333, 'XXX_YYY' => 44.444444
    end
  end

  describe '#url' do
    subject { object.send(:url) }

    it { should eq 'https://free.currencyconverterapi.com/api/v6/convert?q=AAA_BBB,XXX_YYY&compact=ultra' }
  end

  describe '#currencies_param' do
    subject { object.send(:currencies_param) }

    it { should eq 'AAA_BBB,XXX_YYY' }
  end
end
