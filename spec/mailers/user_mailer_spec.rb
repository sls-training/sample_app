require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { FactoryBot.create(:user, :michael) }
    let(:mail) { UserMailer.account_activation(user) }

    context 'headers' do
      before do
        user.activation_token = User.new_token
      end

      it '件名が「Account activation」であること' do
        expect(mail.subject).to eq('Account activation')
      end

      it '宛先が「to@example.org」であること' do
        expect(mail.to).to eq([user.email])
      end

      it '送信元が「noreply@example.com」であること' do
        expect(mail.from).to eq(['noreply@example.com'])
      end
    end

    context 'body' do
      it 'メール本文にユーザーネームが含まれていること' do
        expect(mail.body.encoded).to match(user.name)
      end

      it 'メール本文に「user.activation_token」が含まれていること' do
        expect(mail.body.encoded).to match(user.activation_token)
      end

      it 'メール本文にユーザーのemailが含まれていること' do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end

  describe 'password_reset' do
    let(:user) { FactoryBot.create(:user, :michael) }
    let(:mail) { UserMailer.password_reset(user) }

    before do
      user.reset_token = User.new_token
    end

    context 'headers' do
      it '件名が「Password reset」であること' do
        expect(mail.subject).to eq('Password reset')
      end

      it '宛先が「to@example.org」であること' do
        expect(mail.to).to eq([user.email])
      end

      it '送信元が「noreply@example.com」であること' do
        expect(mail.from).to eq(['noreply@example.com'])
      end
    end

    context 'body' do
      it 'メール本文に「user.reset_token」が含まれていること' do
        expect(mail.body.encoded).to match(user.reset_token)
      end

      it 'メール本文にユーザーのemailが含まれていること' do
        expect(mail.body.encoded).to match(CGI.escape(user.email))
      end
    end
  end
end
