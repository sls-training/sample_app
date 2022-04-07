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

    context 'bodyをレンダリングすること' do
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

  # describe 'password_reset' do
  #   let(:mail) { UserMailer.password_reset }

  #   it 'headersをレンダリングすること' do
  #     expect(mail.subject).to eq('Password reset')
  #     expect(mail.to).to eq(['to@example.org'])
  #     expect(mail.from).to eq(['from@example.com'])
  #   end

  #   it 'bodyをレンダリングすること' do
  #     expect(mail.body.encoded).to match('Hi')
  #   end
  # end
end
