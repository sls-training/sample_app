require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    it 'Homeタイトルが「Ruby on Rails Tutorial Sample App」' do
      expect(full_title).to eq('Ruby on Rails Tutorial Sample App')
    end

    it 'Helpタイトルが「Help | Ruby on Rails Tutorial Sample App」' do
      expect(full_title('Help')).to eq('Help | Ruby on Rails Tutorial Sample App')
    end
  end
end
