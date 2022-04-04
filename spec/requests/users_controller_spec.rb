require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'Signup' do
    it 'Signupページの取得' do
      get signup_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Index' do
    it 'ログインしていなければログインページにリダイレクト' do
      get users_path
      redirect_to login_path
    end
  end
end
