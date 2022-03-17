require 'rails_helper'

RSpec.describe 'Sessions', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end
end