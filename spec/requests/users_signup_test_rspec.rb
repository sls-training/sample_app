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
      ActionMailer::Base.deliveries.clear
    end

    it 'ユーザーが追加されること' do
      get signup_path
      expect { subject }.to change(User, :count).by(1)
    end

    it '配信されたメッセージが1つであること' do
      subject
      expect(ActionMailer::Base.deliveries.size).to eq 1
    end

    it '登録時点ではactiveになっていないこと' do
      subject
      expect(User.last).not_to be_activated
    end

    it 'ユーザーページが表示されること' do
      get signup_path
      subject
      redirect_to User.last
      follow_redirect!
      render_template :show
    end

    it 'フラッシュメッセージが表示されること' do
      get signup_path
      subject
      redirect_to User.last
      follow_redirect!
      render_template :show
      expect(flash[:info]).to be_truthy
    end
  end
end
