require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'confirmation_email' do
    let(:user) { create(:user) }

    it 'sends a confirmation email' do
      email = UserMailer.confirmation_email(user)
      expect(email.subject).to eq('Confirm Your Email')
      expect(email.to).to eq([user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body).to include('Please confirm your account')
    end
  end

  describe 'approval_email' do
    let(:user) { create(:user) }

    it 'sends an approval email' do
      email = UserMailer.approval_email(user)
      expect(email.subject).to eq('Account Approved')
      expect(email.to).to eq([user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body).to include('Your Account has been approved')
    end
  end
end
