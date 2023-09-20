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
end
