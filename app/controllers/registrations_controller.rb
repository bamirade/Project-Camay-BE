class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(user_params)

    if user.save
      UserMailer.confirmation_email(user).deliver_now
      render json: { user: user, response: 'User created successfully. Confirmation email sent.' }, status: :created
    else
      render json: { error: user.errors.full_messages[0], response: 'User creation failed' }, status: :unprocessable_entity
    end
  end

  def user_reconfirm
    email = params[:email].to_s.strip

    unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: { error: 'Invalid email format' }, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: email)

    if user
      if user.status
        render json: { error: 'User account is already confirmed' }, status: :unprocessable_entity
      else
        new_confirmation_token = SecureRandom.urlsafe_base64
        user.update_column(:confirmation_token, new_confirmation_token)
        UserMailer.confirmation_email(user).deliver_now
        render json: { message: 'Confirmation email resent. Please check your email.' }, status: :ok
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :user_type, :city)
  end

end
