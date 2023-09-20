class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm Your Email')
  end

  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Approved')
  end
end
