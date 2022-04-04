require 'rails_helper'

RSpec.describe 'SiteLayoutTest', type: :request do
  describe 'Homeページ' do
    before do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    context '未ログイン時' do
      it '各ページへのリンクが存在するか' do
        expect(response.body).to include(root_path)
        expect(response.body).to include(help_path)
        expect(response.body).to include(about_path)
        expect(response.body).to include(contact_path)
        expect(response.body).to include('http://news.railstutorial.org/')
        expect(response.body).to include(login_path)
        get contact_path
        expect(response.body).to include full_title('Contact')
        get signup_path
        expect(response.body).to include full_title('Sign up')
      end
    end

    context 'ログイン時' do
      let(:testuser) { FactoryBot.create(:user, :michael) }

      before do
        get login_path
        log_in_as(testuser)
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      it '各ページへのリンクが存在するか' do
        expect(response.body).to include(root_path)
        expect(response.body).to include(help_path)
        expect(response.body).to include(users_path)
        expect(response.body).to include('Account')
        expect(response.body).to include(user_path(testuser))
        expect(response.body).to include(edit_user_path(testuser))
        expect(response.body).to include(logout_path)
        expect(response.body).to include(about_path)
        expect(response.body).to include(contact_path)
        expect(response.body).to include('http://news.railstutorial.org/')
      end
    end
  end
end
