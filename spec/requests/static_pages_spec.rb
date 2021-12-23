require 'rails_helper'

RSpec.describe 'ViewPageTest', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'Home' do
    before do
      get root_path
    end

    it 'Homeページの取得' do
      expect(response).to have_http_status(:ok)
    end

    it 'タイトルがbase_titleの内容である' do
      expect(response.body).to include(base_title)
    end

    it 'タイトルがbase_titleの内容ではない' do
      expect(response.body).not_to include(" | #{base_title} ")
    end
  end

  describe 'Help' do
    before do
      get help_path
    end

    it 'Helpページの取得' do
      expect(response).to have_http_status(:ok)
    end

    it 'タイトルが「Help + | {base_title}」の内容である' do
      expect(response.body).to include("Help | #{base_title}")
    end
  end

  describe 'About' do
    before do
      get about_path
    end

    it 'Aboutページの取得' do
      expect(response).to have_http_status(:ok)
    end

    it 'タイトルが「About + | {base_title}」の内容である' do
      expect(response.body).to include("About | #{base_title}")
    end
  end

  describe 'Contact' do
    before do
      get contact_path
    end

    it 'Contactページの取得' do
      expect(response).to have_http_status(:ok)
    end

    it 'タイトルが「Contact + | {base_title}」の内容である' do
      expect(response.body).to include("Contact | #{base_title}")
    end
  end
end
