require 'rails_helper'

RSpec.describe 'EditPage', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  describe 'GET EDIT TEST' do
    context 'ログインしている場合' do
      before do
        post login_path, params: { session: { email: testuser.email, password: testuser.password } }
      end

      it '編集ページにアクセスできること' do
        get edit_user_path(testuser)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない場合' do
      it 'フラッシュメッセージが表示されていること' do
        get edit_user_path(testuser)
        expect(flash[:danger]).to be_truthy
      end

      it 'ログインページにリダイレクトされること' do
        get edit_user_path(testuser)
        redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PATCH EDIT TEST' do
    context '無効な値の場合' do
      subject { patch user_path(testuser), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } } }

      before do
        post login_path, params: { session: { email: testuser.email, password: testuser.password } }
      end

      it 'editページが再描写されること' do
        subject
        redirect_to edit_user_path(testuser)
        expect(response).to have_http_status(:ok)
      end

      it '「The form contains 4 errors」が表示されていること' do
        subject
        redirect_to edit_user_path(testuser)
        expect(response.body).to include('The form contains 4 errors')
      end
    end

    context '有効な値の場合' do
      subject do
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(testuser), params: { user: { name: @name, email: @email, password: '', password_confirmation: '' } }
      end

      before do
        post login_path, params: { session: { email: testuser.email, password: testuser.password } }
      end

      it 'flashメッセージが表示されていること' do
        subject
        redirect_to user_path(testuser)
        follow_redirect!
        expect(flash[:success]).to be_truthy
      end

      it 'プロフィールページにリダイレクトされること' do
        subject
        redirect_to user_path(testuser)
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      it '更新されること' do
        subject
        testuser.reload
        expect(testuser.name).to eq @name
        expect(testuser.email).to eq @email
      end
    end

    context 'ログインしていない場合' do
      it 'フラッシュメッセージが表示されていること' do
        patch user_path(testuser), params: { user: { name: testuser.name, email: testuser.email } }
        expect(flash[:danger]).to be_truthy
      end

      it 'ログインページにリダイレクトされること' do
        patch user_path(testuser), params: { user: { name: testuser.name, email: testuser.email } }
        redirect_to login_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
