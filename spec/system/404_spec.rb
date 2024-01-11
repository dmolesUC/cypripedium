# frozen_string_literal: true
require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'Getting a 404 for RecordNotFound', type: :system do
  before do
  end
  context 'visiting a work that does not exist' do
    it 'has a 404 page' do
      visit('/concern/works/s7526c41m?locale=pt-BR')
      expect(page).to have_content('does not exist')
      expect(page).to have_content('You may have mistyped the address or the page may have moved.')
    end
  end

  context 'visiting a route with no content' do
    it 'has a 404 page' do
      visit('/bla/bla/bla')
      expect(page).to have_content('does not exist')
      expect(page).to have_content('You may have mistyped the address or the page may have moved.')
    end
  end
end
