require 'rails_helper'

RSpec.describe 'PasswordResetsTest', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '#new' do
    before do
      get new_password_reset_path
      expect(response).to have_http_status(:ok)
    end

    it 'name属性が「password_reset[email]」のinputタグが存在すること' do
      get new_password_reset_path
      expect(response.body).to include('name="password_reset[email]"')
    end
  end

  describe '#create' do
    subject { post password_resets_path, params: { password_reset: { email: '' } } }

    context '無効なメールアドレスの場合' do
      it 'フラッシュメッセージ(danger)が表示されること' do
        subject
        expect(flash[:danger]).not_to be_empty
      end

      it '#newページが表示されていること' do
        subject
        expect(new_password_reset_path).to eq new_password_reset_path
      end
    end

    context '有効なメールアドレスの場合' do
      subject { post password_resets_path, params: { password_reset: { email: testuser.email } } }

      it 'フラッシュメッセージ(info)が表示されること' do
        subject
        expect(flash[:info]).not_to be_empty
      end

      it 'ダイジェストが変わっていること' do
        subject
        expect(testuser.reset_digest).not_to eq testuser.reload.reset_digest
      end

      it 'メールが1通送信されること' do
        expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it 'rootページにリダイレクトされること' do
        subject
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#edit' do
    before do
      post password_resets_path, params: { password_reset: { email: testuser.email } }
      @user = controller.instance_variable_get('@user')
    end

    context '無効なメールアドレスの場合' do
      it 'rootページにリダイレクトすること' do
        get edit_password_reset_path(@user.reset_token, email: '')
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context '無効なユーザーの場合' do
      it 'rootページにリダイレクトすること' do
        @user.toggle!(:activated)
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
        @user.toggle!(:activated)
      end
    end

    context 'メールアドレスは有効だがトークンが無効な場合' do
      it 'rootページにリダイレクトすること' do
        get edit_password_reset_path('wrong token', email: @user.email)
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end

    context 'メールアドレスとトークンが有効な場合' do
      it 'value属性が「user.email」の隠しフィールドが存在すること' do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response.body).to include("input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\"")
      end
    end

    context 'トークンの期限が切れていた場合' do
      it '#newにリダイレクトすること' do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        redirect_to new_password_reset_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#update' do
    before do
      post password_resets_path, params: { password_reset: { email: testuser.email } }
      @user = controller.instance_variable_get('@user')
    end

    context 'パスワードが一致しなかった場合' do
      it 'エラーメッセージを表示する' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: 'foobaz', password_confirmation: 'barquux' } }
        expect(response.body).to include('<div id="error_explanation">')
      end
    end

    context 'パスワードが空の場合' do
      it 'エラーメッセージを表示する' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: '', password_confirmation: '' } }
        expect(response.body).to include('<div id="error_explanation">')
      end
    end

    context '有効なパスワードの場合' do
      before do
        patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: 'foobaz', password_confirmation: 'foobaz' } }
      end

      it 'ログイン状態になること' do
        expect(is_logged_in?).to be_truthy
      end

      it 'フラッシュメッセージが表示されること' do
        expect(flash[:success]).not_to be_empty
      end

      it 'ユーザーページにリダイレクトされること' do
        redirect_to @user
      end
    end

    context '2時間以上経過した場合' do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
      end

      it '#newにリダイレクトされること' do
        redirect_to new_password_reset_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      it 'フラッシュメッセージが表示されること' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email, user: { password: 'foobaz', password_confirmation: 'foobaz' } }
        follow_redirect!
        expect(flash[:danger]).to include 'Password reset has expired.'
      end
    end
  end
end
