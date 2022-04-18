require 'rails_helper'

RSpec.describe 'MicropostsInterfaceTest', type: :request do
  let(:test_user) { FactoryBot.create(:user, :michael) }
  let(:other) { FactoryBot.create(:user, name: 'lana') }
  let(:other2) { FactoryBot.create(:user, name: 'malory') }
  let(:other3) { FactoryBot.create(:user, name: 'archer') }

  before do
    log_in_as(test_user)
    test_user.follow(other2)
    test_user.follow(other3)
    other2.follow(test_user)
    other.follow(test_user)
  end

  context 'following page' do
    it 'followingの数とフォローしているユーザへのリンクが表示されていること' do
      get following_user_path(test_user)
      expect(test_user.following).not_to be_empty
      assert_match test_user.following.count.to_s, response.body
      test_user.following.each do |test_user|
        assert_select 'a[href=?]', user_path(test_user)
      end
    end
  end

  context 'followers page' do
    it 'followersの数とフォローしているユーザへのリンクが表示されていること' do
      get followers_user_path(test_user)
      expect(test_user.following).not_to be_empty
      assert_match test_user.followers.count.to_s, response.body
      test_user.followers.each do |test_user|
        #assert_select 'a[href=?]', user_path(test_user)
      end
    end
  end
end
