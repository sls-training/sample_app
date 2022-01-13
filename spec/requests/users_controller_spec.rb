require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'Signup' do
    it 'Signupページの取得' do
      get signup_path
      expect(response).to have_http_status(:ok)
    end
  end
end
