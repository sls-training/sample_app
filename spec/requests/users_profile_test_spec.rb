require 'rails_helper'
include ApplicationHelper

RSpec.describe 'UsersProfiles', type: :request do
  let(:testuser) { FactoryBot.create(:user, :michael) }

  before do
    40.times do
      testuser.microposts.create(content: Faker::Lorem.sentence(word_count: 5))
    end
    get user_path(testuser)
  end

  it 'ユーザーページが表示されていること' do
    expect(response).to have_http_status(:ok)
  end

  it 'タイトルにユーザー名が表示されていること' do
    assert_select 'title', full_title(testuser.name)
  end

  it 'h1にユーザー名が表示されていること' do
    assert_select 'h1', text: testuser.name
  end

  it 'h1の中にgravatarが表示されていること' do
    assert_select 'h1>img.gravatar'
  end

  it 'ユーザーのマイクロポスト数が表示されていること' do
    assert_match testuser.microposts.count.to_s, response.body
  end

  it '1度のみページネーションが表示されていること' do
    assert_select 'div.pagination', count: 1
  end

  it 'マイクロポストが表示されていること' do
    testuser.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
