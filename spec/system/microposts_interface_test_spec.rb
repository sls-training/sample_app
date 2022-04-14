require 'rails_helper'

RSpec.describe 'MicropostsInterfaceTest', type: :system do
  before do
    FactoryBot.send(:user_with_posts, posts_count: 35)
    @user = Micropost.first.user
    @user.password = 'password'
    visit login_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
    visit root_path
  end

  it 'ページネーションのラッパータグがあること' do
    expect(page).to have_selector 'div.pagination'
  end

  context '無効な送信の場合' do
    it '投稿されないこと' do
      expect { fill_in 'micropost_content', with: '' }.not_to change(Micropost, :count)
    end
  end

  context '有効な送信の場合' do
    it '投稿されること' do
      expect do
        fill_in 'micropost_content', with: 'This micropost really ties the room together'
        click_button 'Post'
      end.to change(Micropost, :count).by(1)
      expect(page).to have_content 'This micropost really ties the room together'
    end
  end

  context '削除機能' do
    it 'deleteボタンが存在すること' do
      expect(page).to have_link 'delete'
    end

    it '削除されること' do
      fill_in 'micropost_content', with: 'This micropost really ties the room together'
      click_button 'Post'

      post = Micropost.first

      #binding.pry

      expect {
        find_link('delete', href: micropost_path(post)).click
      }.to change(Micropost, :count).by(-1)

      expect(page).not_to have_content 'This micropost really ties the room together'
    end
  end
end
