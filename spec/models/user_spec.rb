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

  it '有効なメールアドレスの受け入れ' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} is valid"
    end
  end

  it '無効なメールアドレスの拒否' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid, "#{invalid_address.inspect} is invalid"
    end
  end
end
