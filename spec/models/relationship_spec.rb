require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:test_user) { FactoryBot.create(:user, :michael) }
  let(:other_user) { FactoryBot.create(:user, :michael, name: 'archer', email: 'archer@example.com') }
  let(:relationship) { Relationship.new(follower_id: test_user.id, followed_id: other_user.id) }

  it '有効であること' do
    expect(relationship).to be_valid
  end

  it 'follower_idが必要なこと' do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end

  it 'followed_idが必要なこと' do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end

  describe 'フォロー＆フォロー解除' do
    context 'まだフォローしていない場合' do
      it 'フォローしていないこと' do
        expect(test_user.following?(other_user)).to be_falsy
      end

      it 'フォローできること' do
        test_user.follow(other_user)
        expect(test_user.following?(other_user)).to be_truthy
      end
    end

    context 'フォローしている場合' do
      before do
        test_user.follow(other_user)
        expect(test_user.following?(other_user)).to be_truthy
      end

      it 'フォロー解除できること' do
        test_user.unfollow(other_user)
        expect(test_user.following?(other_user)).to be_falsey
      end
    end
  end
end
