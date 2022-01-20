require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user, name: 'Example User', email: 'user@example.com') }

  it '有効か' do
    expect(user).to be_valid
  end

  it 'nameが存在するか' do
    user.name = '     '
    expect(user).not_to be_valid
  end

  it 'emailが存在するか' do
    user.email = '     '
    expect(user).not_to be_valid
  end

  it 'nameの長さの上限が50文字' do
    user.name = 'a' * 51
    expect(user).not_to be_valid
  end

  it 'emailの長さの上限が255文字' do
    user.email = 'a' * 244 + '@example.com'
    expect(user).not_to be_valid
  end
end
