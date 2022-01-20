require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user, name: 'Example User', email: 'user@example.com') }

  it 'is valid' do
    expect(user).to be_valid
  end
end
