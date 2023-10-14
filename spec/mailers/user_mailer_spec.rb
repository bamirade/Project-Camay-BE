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
      expect(email.body.encoded).to include('Welcome to Project:CAMAY!')
    end
  end

  describe 'approval_email' do
    let(:user) { create(:user) }

    it 'sends an approval email' do
      email = UserMailer.approval_email(user)
      expect(email.subject).to eq('Account Approved')
      expect(email.to).to eq([user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body.encoded).to include('Your Account has been approved')
    end
  end

  describe 'status_pending_email_seller' do
    let(:seller) { create(:seller) }
    let(:buyer) { create(:buyer) }
    let(:commission) { create(:commission, seller: seller, buyer: buyer) }

    it 'sends a status pending email to the seller' do
      email = UserMailer.status_pending_email_seller(commission)
      expect(email.subject).to eq('You Have a Pending Commission')
      expect(email.to).to eq([seller.user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body.encoded).to include('You have a pending commission.')
    end
  end

  describe 'status_pending_email_buyer' do
    let(:buyer) { create(:buyer) }
    let(:seller) { create(:seller) }
    let(:commission) { create(:commission, buyer: buyer, seller: seller) }

    it 'sends a status pending email to the buyer' do
      email = UserMailer.status_pending_email_buyer(commission)
      expect(email.subject).to eq('Your Commission is Pending')
      expect(email.to).to eq([buyer.user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body.encoded).to include('Your Commission is Pending')
    end
  end

  describe 'status_progress_email_buyer' do
    let(:buyer) { create(:buyer) }
    let(:commission) { create(:commission, buyer: buyer, stage: 'InProgress') }

    it 'sends a status progress email to the buyer' do
      email = UserMailer.status_progress_email_buyer(commission)
      expect(email.subject).to eq('Your Commission Request was Accepted by the Artist')
      expect(email.to).to eq([buyer.user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body.encoded).to include('Your commission request has been accepted by the artist.')
    end
  end

  describe 'status_completed_email_seller' do
    let(:seller) { create(:seller) }
    let(:commission) { create(:commission, seller: seller, stage: 'Completed') }

    it 'sends a status completed email to the seller' do
      email = UserMailer.status_completed_email_seller(commission)
      expect(email.subject).to eq('Your Commission was Marked as Completed by the Buyer')
      expect(email.to).to eq([seller.user.email])
      expect(email.from).to eq([ENV['GMAIL_USERNAME']])
      expect(email.body.encoded).to include('Your Commission was Marked as Completed by the Buyer')
    end
  end
end
