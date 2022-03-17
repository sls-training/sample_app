require 'rails_helper'

RSpec.describe 'LoginPage', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  describe 'GET Login Test' do
    it 'ログインページにアクセスできること' do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST Login Test' do
    context '無効なデータが送信された場合' do
      subject { post login_path, params: { session: { email: '', password: '' } } }

      it 'フラッシュメッセージが表示されること' do
        get login_path
        subject
        expect(response).to have_http_status(:ok)
        expect(flash[:danger]).to be_truthy
      end

      it '別のページ(Home)にフラッシュメッセージが表示されていないこと' do
        get root_path
        expect(flash[:danger]).to be_falsey
      end
    end

    context '有効なデータが送信された場合' do
      subject { post login_path, params: { session: { email: testuser.email, password: testuser.password } } }

      it 'ログイン用リンクが非表示になっていること' do
        get login_path
        subject
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include(login_path)
      end

      it 'ログアウト用、プロフィール用リンクが表示されていること' do
        get login_path
        subject
        follow_redirect!
        expect(response.body).to include(logout_path)
        expect(response.body).to include(user_path(testuser))
      end

      it 'ログイン状態であること' do
        subject
        expect(is_logged_in?).to be_truthy
      end
    end
  end
end
