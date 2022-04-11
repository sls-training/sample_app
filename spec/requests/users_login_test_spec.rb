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
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(logout_path)
        expect(response.body).to include(user_path(testuser))
      end

      it 'ログイン状態であること' do
        subject
        expect(is_logged_in?).to be_truthy
      end
    end
  end

  describe 'チェックボックスのテスト' do
    context 'チェックボックスにチェックがついている場合' do
      it 'Cookieに保存すること' do
        log_in_as(testuser)
        expect(cookies[:remember_token]).not_to eq nil
      end
    end

    context 'チェックボックスにチェックがついていない場合' do
      it 'Cookieに保存しないこと' do
        log_in_as(testuser, remember_me: '0')
        expect(cookies[:remember_token]).to eq nil
      end
    end
  end

  describe 'アカウントアクティベーション' do
    before do
      post users_path, params: { user: {
        name:                  'Example User',
        email:                 'user@example.com',
        password:              'password',
        password_confirmation: 'password'
      } }
      @user = controller.instance_variable_get('@user')
    end

    context '有効化トークンが正しい場合' do
      it 'activeになること' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it 'ユーザーページが表示されていること' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
        redirect_to user_path(@user)
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(is_logged_in?).to be_truthy
      end
    end

    context 'トークンは正しいがメールアドレスが無効な場合' do
      it 'ログインできないこと' do
        get edit_account_activation_path(@user.activation_token, email: 'wrong')
        expect(is_logged_in?).to be_falsey
      end
    end

    context '有効化トークンが不正な場合' do
      it 'ログインできないこと' do
        get edit_account_activation_path('invalid token', email: @user.email)
        expect(is_logged_in?).to be_falsey
      end
    end

    context '有効化していない場合' do
      it 'ログインできないこと' do
        log_in_as(@user)
        expect(is_logged_in?).to be_falsey
      end
    end
  end
end
