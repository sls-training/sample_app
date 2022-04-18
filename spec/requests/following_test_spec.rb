require 'rails_helper'

RSpec.describe 'MicropostsInterfaceTest', type: :request do
  let(:test_user) { FactoryBot.create(:user, :michael) }
  let(:test_user2) { FactoryBot.create(:user, name: 'lana') }
  let(:test_user3) { FactoryBot.create(:user, name: 'malory') }
  let(:test_user4) { FactoryBot.create(:user, name: 'archer') }

  before do
    log_in_as(test_user)
    test_user.follow(test_user3)
    test_user.follow(test_user4)
    test_user3.follow(test_user)
    test_user2.follow(test_user)
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
        assert_select 'a[href=?]', user_path(test_user)
      end
    end
  end

  describe 'create' do
    let(:other_user) { FactoryBot.create(:user, name: 'bob') }

    before do
      log_in_as(test_user)
    end

    it 'フォローしたら1件増えること' do
      expect { post relationships_path, params: { followed_id: other_user.id } }.to change(Relationship, :count).by(1)
    end

    it 'Ajaxでフォローできること' do
      expect { post relationships_path, xhr: true, params: { followed_id: other_user.id } }.to change(Relationship, :count).by(1)
    end

    it 'フォロー解除したら1件減ること' do
      test_user.follow(other_user)
      relationship = test_user.active_relationships.find_by(followed_id: other_user.id)
      expect { delete relationship_path(relationship) }.to change(Relationship, :count).by(-1)
    end

    it 'Ajaxでフォロー解除できること' do
      test_user.follow(other_user)
      relationship = test_user.active_relationships.find_by(followed_id: other_user.id)
      expect { delete relationship_path(relationship), xhr: true }.to change(Relationship, :count).by(-1)
    end
  end
end
