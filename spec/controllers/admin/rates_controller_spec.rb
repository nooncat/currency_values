require 'rails_helper'

describe Admin::RatesController do
  render_views

  let!(:rate) { create(:rate) }

  describe "GET 'edit_index'" do
    it 'return http success' do
      get :edit_index
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH 'update'" do
    it 'return http success' do
      patch :update, params: { id: rate.id, rate: { manual_value: '12.345678' } }

      expect(response).to have_http_status(200)
      expect(rate.reload.manual_value).to eql(12.345678)
    end
  end
end
