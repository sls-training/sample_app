require 'rails_helper'

RSpec.describe 'SiteLayoutTest', type: :request do
  describe 'LayoutTest' do
    before do
      get root_path
    end

    it 'Homeページの取得' do
      expect(response).to have_http_status(:ok)
    end

    it '各ページへのリンクが存在するか' do
      expect(response.body).to include(root_path)
      expect(response.body).to include(help_path)
      expect(response.body).to include(about_path)
      expect(response.body).to include(contact_path)
      get contact_path
      expect(response.body).to include full_title('Contact')
      get signup_path
      expect(response.body).to include full_title('Sign up')
    end
  end
end
