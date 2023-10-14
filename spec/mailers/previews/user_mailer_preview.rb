# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def confirmation_email
    user = FactoryBot.build(:user)
    UserMailer.confirmation_email(user)
  end

  def approval_email
    user = FactoryBot.build(:user)
    UserMailer.approval_email(user)
  end

  def status_pending_email_seller
    seller = FactoryBot.build(:seller)
    buyer = FactoryBot.build(:buyer)
    commission = FactoryBot.build(:commission, seller: seller, buyer: buyer)
    UserMailer.status_pending_email_seller(commission)
  end

  def status_pending_email_buyer
    buyer = FactoryBot.build(:buyer)
    seller = FactoryBot.build(:seller)
    commission = FactoryBot.build(:commission, buyer: buyer, seller: seller)
    UserMailer.status_pending_email_buyer(commission)
  end

  def status_progress_email_buyer
    buyer = FactoryBot.build(:buyer)
    commission = FactoryBot.build(:commission, buyer: buyer, stage: 'InProgress')
    UserMailer.status_progress_email_buyer(commission)
  end

  def status_completed_email_seller
    seller = FactoryBot.build(:seller)
    commission = FactoryBot.build(:commission, seller: seller, stage: 'Completed')
    UserMailer.status_completed_email_seller(commission)
  end
end
