require 'rails_helper'

RSpec.describe 'IndexPage', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  context 'ページネーションのテスト' do
    before do
      FactoryBot.create_list(:many_user, 30)
      log_in_as(testuser)
      get users_path
      expect(response).to have_http_status(:ok)
    end

    it 'ページネーションが表示されていること' do
      expect(response.body).to include('<div role="navigation" aria-label="Pagination" class="pagination">')
    end

    it '各ユーザーのリンクが表示されていること' do
      User.paginate(page: 1).each do |user|
        expect(response.body).to include("<a href=\"#{user_path(user)}\">")
      end
    end
  end
end
