require 'rails_helper'

RSpec.describe 'SignUpPage', type: :request do
  let(:failure) { FactoryBot.attributes_for(:user, name: '', email: 'user@invalid', password: 'foo', password_confirmation: 'bar') }
  let(:success) { FactoryBot.attributes_for(:user, email: 'user@example.com', password: 'password', password_confirmation: 'password') }

  context '無効なデータが送信された場合' do
    subject { post users_path, params: { user: failure } }

    before do
      get signup_path
    end

    it 'ユーザーが追加されないこと' do
      expect { subject }.to change(User, :count).by(0)
    end

    it 'Signupページが表示されること' do
      subject
      expect(response).to render_template :new
    end
  end

  context '有効なデータが送信された場合' do
    subject { post users_path, params: { user: success } }

    before do
      get signup_path
    end

    it 'ユーザーが追加されること' do
      expect { subject }.to change(User, :count).by(1)
    end

    it 'ユーザーページが表示されること' do
      subject
      expect(response).to redirect_to User.last
      follow_redirect!
      expect(response).to render_template :show
    end

    it 'フラッシュメッセージが表示されること' do
      subject
      expect(response).to redirect_to User.last
      follow_redirect!
      expect(response).to render_template :show
      expect(response.body).to include('Welcome to the Sample App!')
    end
  end
end
