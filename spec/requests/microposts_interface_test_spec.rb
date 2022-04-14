require 'rails_helper'

RSpec.describe 'MicropostsInterfaceTest', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael, email: 'hoge@example.com') }

  before do
    FactoryBot.send(:user_with_posts, posts_count: 35)
    @user = Micropost.first.user
    @user.password = 'password'
    log_in_as(@user)
    get root_path
  end

  it 'ページネーションのラッパータグがあること' do
    expect(response.body).to include('<div role="navigation" aria-label="Pagination" class="pagination">')
  end

  context '無効な送信の場合' do
    it '投稿されないこと' do
      expect { post microposts_path, params: { micropost: { content: '' } } }.not_to change(Micropost, :count)
    end
  end

  context '有効な送信の場合' do
    it '投稿されること' do
      content = 'This micropost really ties the room together'
      expect { post microposts_path, params: { micropost: { content: content } } }.to change(Micropost, :count).by(1)
    end

    it 'ホームページにリダイレクトされること' do
      content = 'This micropost really ties the room together'
      expect { post microposts_path, params: { micropost: { content: content } } }.to change(Micropost, :count).by(1)
      redirect_to root_path
      follow_redirect!
      expect(response).to have_http_status(:ok)
    end

    it '投稿したものがページに存在すること' do
      content = 'This micropost really ties the room together'
      expect { post microposts_path, params: { micropost: { content: content } } }.to change(Micropost, :count).by(1)
      redirect_to root_path
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(content)
    end
  end

  context '削除機能' do
    it 'deleteボタンが存在すること' do
      assert_select 'a', text: 'delete'
    end

    it '削除されること' do
      first_micropost = @user.microposts.paginate(page: 1).first
      expect { delete micropost_path(first_micropost) }.to change(Micropost, :count).by(-1)
    end
  end

  context '別のユーザーの場合' do
    it 'deleteボタンが表示されていないこと' do
      get user_path(testuser)
      assert_select 'a', text: 'delete', count: 0
    end
  end

  it '投稿数が"35 microposts"と表示されること' do
    assert_match '35 micropost', response.body
  end
end
