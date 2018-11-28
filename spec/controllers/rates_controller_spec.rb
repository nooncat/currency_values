require 'rails_helper'

describe RatesController do
  render_views

  let!(:rate) { create(:rate) }

  describe "GET 'index'" do
    it 'return http success' do
      get :index
      expect(response).to have_http_status(200)
    end
  end
end
