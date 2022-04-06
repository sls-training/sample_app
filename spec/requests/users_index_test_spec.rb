require 'rails_helper'

RSpec.describe 'UsersPage', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }
  let(:adminuser) { FactoryBot.create(:admin) }
  let(:other_user) { FactoryBot.create(:user, { name: 'Sterling Archer' }) }

  describe 'ページネーションテスト' do
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

  describe 'DELETEテスト' do
    context '未ログインの場合' do

      it '削除されないこと' do
        # expect { delete(user_path(adminuser)) }.to change(User, :count).by(0)
        delete user_path(adminuser)
        expect(User.count).to eq 0
      end

      it 'ログイン画面にリダイレクトされること' do
        delete user_path(adminuser)
        expect(response).to redirect_to login_path
      end
    end

    context '一般アカウントでログインした場合' do
      before do
        log_in_as(other_user)
      end

      it '削除されないこと' do
        expect { delete(user_path(adminuser)) }.to change(User, :count).by(0)
      end

      it 'ホーム画面にリダイレクトされること' do
        delete user_path(adminuser)
        redirect_to root_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      it 'deleteリンクが表示されていないこと' do
        expect(response.body).not_to include('delete')
      end
    end

    context 'adminアカウントでログインした場合' do
      before do
        log_in_as(adminuser)
      end

      it 'deleteリンクが表示されていること' do
        expect(response.body).to include('delete')
      end

      it '削除できること' do
        expect { delete(user_path(other_user)) }.to change(User, :count).by(-1)
      end
    end
  end
end
