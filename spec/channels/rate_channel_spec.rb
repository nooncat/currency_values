require 'rails_helper'

describe ::RateChannel do
  let!(:rate) { create :rate }
  before { stub_connection }

  it 'rejects when no rate_id' do
    subscribe
    expect(subscription).to be_rejected
  end

  it 'subscribes to stream when rate_id is provided' do
    subscribe(rate_id: rate.id)

    expect(subscription).to be_confirmed
    expect(streams).to include("rate:#{rate.to_gid_param}")
  end
end
