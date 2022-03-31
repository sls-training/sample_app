require 'rails_helper'

RSpec.describe 'EditPage', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  describe 'GET EDIT TEST' do
    it '編集ページにアクセスできること' do
      get edit_user_path(testuser)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH EDIT TEST' do
    context '無効な値の場合' do
      subject { patch user_path(testuser), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } } }

      it 'editページが再描写されること' do
        get edit_user_path(testuser)
        subject
        redirect_to edit_user_path(testuser)
        expect(response).to have_http_status(:ok)
      end

      it '「The form contains 4 errors」が表示されていること' do
        get edit_user_path(testuser)
        subject
        redirect_to edit_user_path(testuser)
        expect(response.body).to include('The form contains 4 errors')
      end
    end
  end
end
