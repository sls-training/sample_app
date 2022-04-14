require 'rails_helper'

RSpec.describe 'MicropostsInterfaceTest', type: :system do
  before do
    FactoryBot.send(:user_with_posts, posts_count: 35)
    @user = Micropost.first.user
    @user.password = 'password'
    log_in_as(@user)
    get root_path
    expect(response).to have_http_status(:ok)
  end

  it 'ページネーションのラッパータグがあること' do
    expect(page).to have_selector('div', class: 'pagination')
  end

  context '無効な送信の場合' do
    it '投稿されないこと' do
      expect { fill_in 'micropost_content', with: '' }.not_to change(Micropost, :count)
    end
  end

  context '有効な送信の場合' do
    it '投稿されること' do
      expect { fill_in 'micropost_content', with: 'This micropost really ties the room together' }.to change(Micropost, :count).by(1)
      expect(page).to have_content(content)
    end
  end

  context '削除機能' do
    it 'deleteボタンが存在すること' do
      expect(page).to have_link 'delete'
    end

    it '削除されること' do
      expect { click_link 'delete', href: micropost_path(@user.micropost.first) }.to change(Micropost, :count).by(-1)
    end
  end
end
