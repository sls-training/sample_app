require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  describe '#create' do
    context '未ログインの場合' do
      it '登録されないこと' do
        expect do
          post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
        end.not_to change(Micropost, :count)
      end

      it 'ログインページにリダイレクトされること' do
        post microposts_path, params: { micropost: { content: 'Lorem ipsum' } }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe '#destroy' do
    let(:testuser) { FactoryBot.create(:user, :michael) }

    before do
      @micropost = FactoryBot.create(:most_recent)
    end

    context '未ログインの場合' do
      it '削除されないこと' do
        expect { delete micropost_path(@micropost) }.not_to change(Micropost, :count)
      end

      it 'ログインページにリダイレクトされること' do
        delete micropost_path(@micropost)
        expect(response).to redirect_to login_path
      end
    end
  end
end
