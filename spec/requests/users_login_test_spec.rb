require 'rails_helper'

RSpec.describe 'LoginPage', type: :request do
  it 'ログインページにアクセスできること' do
    get login_path
    expect(response).to have_http_status(:ok)
  end

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
end
