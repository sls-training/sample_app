require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:testuser) { FactoryBot.create(:user, :michael) }
  let(:micropost) { testuser.microposts.build(content: 'Lorem ipsum') }

  it '有効であること' do
    expect(micropost).to be_valid
  end

  it 'ユーザーIDが存在すること' do
    micropost.user_id = nil
    expect(micropost).not_to be_valid
  end

  it 'コンテンツが存在すること' do
    micropost.content = '   '
    expect(micropost).not_to be_valid
  end

  it 'コンテンツの文字数が最大140文字であること' do
    micropost.content = 'a' * 141
    expect(micropost).not_to be_valid
  end

  it '最新の投稿が最初に来ること' do
    FactoryBot.send(:user_with_posts)
    expect(FactoryBot.create(:most_recent)).to eq Micropost.first
  end

  it 'ユーザーが削除されたとき、関連するマイクロポストも削除されること' do
    post = FactoryBot.create(:most_recent)
    user = post.user
    expect { user.destroy }.to change(Micropost, :count).by(-1)
  end
end
