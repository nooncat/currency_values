require 'rails_helper'

feature 'home page', type: :feature do
  before { WebMock.disable_net_connect!(allow_localhost: true) }
  let!(:rate) { create :rate, from: 'USD', to: 'RUB', value: 65.555555 }

  scenario 'update rate value on page right after rate updated on server', js: true do
    visit(root_path)
    expect(page).to have_content 'USD/RUB: 65.555555'

    rate.update(value: '36.234234')
    expect(page).to have_content 'USD/RUB: 36.234234'
  end
end
