require 'rails_helper'

RSpec.describe 'ログアウトテスト', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  context 'ログアウトボタンを押した場合' do
    before do
      post login_path, params: { session: { email: testuser.email, password: testuser.password } }
    end

    subject do
      delete logout_path
    end

    it 'ログアウトできること' do
      subject
      redirect_to root_path
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(login_path)
      expect(response.body).not_to include(logout_path)
      expect(response.body).not_to include(user_path(testuser))
    end
  end
end
