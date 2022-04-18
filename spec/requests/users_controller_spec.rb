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

  describe 'following/followers' do
    let(:test_user) { FactoryBot.create(:user, :michael) }

    context 'GET /users/{id}/following' do
      it '未ログインならログインページにリダイレクトすること' do
        get following_user_path(test_user)
        redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'GET /users/{id}/followers' do
      it '未ログインならログインページにリダイレクトすること' do
        get followers_user_path(test_user)
        redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
