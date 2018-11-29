require 'rails_helper'

describe ::Rate do
  let(:object) { described_class }

  describe 'validations' do
    let!(:rate) { create(:rate) }

    it { should validate_presence_of(:from) }
    it { should validate_presence_of(:to) }
    it { should validate_uniqueness_of(:from).scoped_to(:to) }

    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value).is_greater_than(0).is_less_than(1_000_000_000) }
  end

  describe '.to_param' do
    let(:rate) { build(:rate) }

    it 'return string compared from from and to attributes' do
      expect(rate.to_param).to eq("#{rate.from}_#{rate.to}")
    end
  end

  describe '#find' do
    let!(:rate) { create(:rate) }

    it 'find rate when number passed' do
      expect(object.find(rate.id)).to eql(rate)
    end

    it 'find rate when to_param string passed' do
      expect(object.find(rate.to_param)).to eql(rate)
    end
  end

  describe '.upcase_from_and_to' do
    let(:rate) { build(:rate, from: 'usd', to: 'rub') }

    it 'upcase from and to attributes' do
      expect { rate.send(:upcase_from_and_to) }
        .to change(rate, :from)
        .from('usd').to('USD')
        .and change(rate, :to)
        .from('rub').to('RUB')
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      let(:rate) { build(:rate) }

      it 'calls Rate.upcase_from_and_to' do
        expect(rate).to receive(:upcase_from_and_to).once
        rate.save
      end
    end
  end
end
