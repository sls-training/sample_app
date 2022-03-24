require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user, :michael) }

  describe 'current_user' do
    before do
      remember(user)
    end

    context 'セッションがnilの場合' do
      it 'current_userは正しいユーザーを返すこと' do
        expect(user).to eq current_user
        expect(is_logged_in?).to be_truthy
      end
    end

    context 'ダイジェストの記憶が間違っている場合' do
      it 'current_userはnilを返すこと' do
        user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to eq nil
      end
    end
  end
end
