require 'rails_helper'

RSpec.describe 'SignUpTest', type: :request do
  # let(:params) { FactoryBot.build(:user, name: '', email: 'user@invalid', password: 'foo', password_confirmation: 'bar') }

  let(:params) do
    {
      name:                  '',
      email:                 'user@invalid',
      password:              'foo',
      password_confirmation: 'bar'
    }
  end

  before do
    get signup_path
  end

  describe '失敗時のテスト' do
    it 'postデータの受け取りができること' do
      post users_path, params: { user: params }
      # expect(response).to have_http_status(302)
    end
  end
end
