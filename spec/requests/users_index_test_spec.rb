require 'rails_helper'

RSpec.describe 'UsersPage', type: :request do
  let!(:testuser) { FactoryBot.create(:user, :michael) }
  let!(:adminuser) { FactoryBot.create(:admin) }
  let!(:other_user) { FactoryBot.create(:user, { name: 'Sterling Archer' }) }

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
        expect { delete user_path(adminuser) }.not_to change(User, :count)
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
        expect { delete user_path(adminuser) }.not_to change(User, :count)
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
        redirect_to users_path
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end

      it 'deleteリンクが表示されていること' do
        expect(response.body).to include('delete')
      end

      it '削除できること' do
        expect { delete user_path(other_user) }.to change(User, :count).by(-1)
      end
    end
  end

  describe 'ユーザー一覧' do
    context 'activeされていない場合' do
      it 'ユーザー一覧に表示されないこと' do
        not_activated_user = FactoryBot.create(:user, :john)
        log_in_as(testuser)
        get users_path
        expect(User.all).not_to include not_activated_user.name
      end

      it 'rootページにリダイレクトされること' do
        not_activated_user = FactoryBot.create(:user, :john)
        log_in_as(testuser)
        get user_path(not_activated_user)
        redirect_to root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
