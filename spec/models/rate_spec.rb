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

    it do
      should validate_numericality_of(:manual_value)
        .is_greater_than(0).is_less_than(1_000_000_000)
        .allow_nil
    end

    it 'validates that manual_value_till is after current time' do
      expect(build(:rate, manual_value_till: nil)).to be_valid
      expect(build(:rate, manual_value_till: Time.current + 1.minute)).to be_valid
      expect(build(:rate, manual_value_till: Time.current)).not_to be_valid
    end
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

  describe '.broadcast_changes' do
    let(:rate) { create :rate }
    let(:new_value) { 33.333333 }

    it 'translate new value to RateChannel' do
      expect(RateChannel).to receive(:broadcast_to).with(rate, value: new_value).once
      rate.update(value: new_value)
    end
  end

  describe '.force_value' do
    let(:value) { 22.222222 }
    let(:rate) { create :rate, value: value }
    let(:new_manual_value) { 33.333333 }

    it 'change value to manual_value' do
      expect { rate.update(manual_value: new_manual_value) }
        .to change(rate, :value)
        .from(value)
        .to(new_manual_value)
    end
  end

  describe '.schedule_value_update' do
    let(:rate) { create :rate }
    let(:new_manual_value_till) { Time.zone.now.change(usec: 0) + 1.hour }

    it 'remove previous scheduled job and schedule new one' do
      expect(Rates::UpdateValuesWorker).to receive(:remove_scheduled_job).with([[rate.id]]).once
      expect(Rates::UpdateValuesWorker)
        .to receive(:perform_at).with(new_manual_value_till, [rate.id]).once
      rate.update(manual_value_till: new_manual_value_till)
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      let(:rate) { build(:rate) }

      it 'calls .upcase_from_and_to' do
        expect(rate).to receive(:upcase_from_and_to).once
        rate.save
      end
    end

    describe 'after_commit' do
      let(:rate) { create(:rate) }
      let(:new_value) { 33.333333 }
      let(:new_manual_value) { 44.444444 }
      let(:new_manual_value_till) { Time.now + 1.hour }

      it 'calls .broadcast_changes when value changed' do
        expect(rate).to receive(:broadcast_changes).once
        rate.update(value: new_value)
      end

      it 'calls .force_value when manual_value changed' do
        expect(rate).to receive(:force_value).once
        rate.update(manual_value: new_manual_value)
      end

      it 'calls .schedule_value_update when manual_value_till changed' do
        expect(rate).to receive(:schedule_value_update).once
        rate.update(manual_value_till: new_manual_value_till)
      end
    end
  end
end
