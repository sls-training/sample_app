require 'rails_helper'

RSpec.describe 'ログアウトテスト', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  context 'ログアウトボタンを押した場合' do
    subject { post login_path, params: { session: { email: testuser.email, password: testuser.password } } }

    it 'ログアウトできること' do
      # 最初にログインし、ログイン状態であるかの確認
      subject
      expect(is_logged_in?).to be_truthy

      # ログアウト処理、確認
      delete logout_path
      expect(is_logged_in?).not_to be_truthy

      # ルートページに移動し、それぞれのリンク表示の確認
      redirect_to root_path
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(login_path)
      expect(response.body).not_to include(logout_path)
      expect(response.body).not_to include(user_path(testuser))
    end
  end
end
