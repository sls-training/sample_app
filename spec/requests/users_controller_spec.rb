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

  describe 'adminテスト' do
    let(:testuser) { FactoryBot.create(:user, :michael) }
    let(:other_user) { FactoryBot.create(:user, { name: 'Sterling Archer' }) }

    context 'Web経由でadmin属性変更のリクエストが送られた場合' do
      it 'admin属性が変更されないこと' do
        log_in_as(other_user)
        expect(testuser).not_to be_admin
        patch user_path(other_user), params: { user: { password: 'password', password_confirmation: 'password', admin: true } }
        testuser.reload
        expect(testuser).not_to be_admin
      end
    end
  end
end
