class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm Your Email')
  end

  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Approved')
  end

  def status_pending_email_seller(commission)
    @commission = commission
    mail(to: @commission.seller.user.email, subject: 'You Have a Pending Commission')
  end

  def status_pending_email_buyer(commission)
    @commission = commission
    mail(to: @commission.buyer.user.email, subject: 'Your Commission is Pending')
  end

  def status_progress_email_buyer(commission)
    @commission = commission
    mail(to: @commission.buyer.user.email, subject: 'Your Commission Request was Accepted by the Artist')
  end

  def status_completed_email_seller(commission)
    @commission = commission
    mail(to: @commission.seller.user.email, subject: 'Your Commission was Marked as Completed by the Buyer')
  end
end
