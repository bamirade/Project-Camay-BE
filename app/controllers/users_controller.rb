class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:confirm_email]
  before_action :find_user, only: [:update_password, :update_info]
  include ActiveStorage::SetCurrent

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && !user.status
      user.update_column(:status, true)
      user.update_column(:confirmation_token, nil)
      UserMailer.approval_email(user).deliver_now

      response.headers['Refresh'] = '5;url=http://project-camay-pgcd.onrender.com/login'
      render json: { message: "Email confirmed. Redirecting to login page..." }, status: :ok
    else
      render json: { error: "Invalid confirmation token" }, status: :unprocessable_entity
    end
  end

  def user_info
    user = current_user

    if user
      if user.user_type == 'Buyer'
        render json: { user_info: user }, status: :ok
      elsif user.user_type == 'Seller'
        seller_info = user.seller
        image_urls = { avatar_url: user.seller.avatar.url, cover_url: user.seller.cover.url, works1_url: user.seller.works1.url, works2_url: user.seller.works2.url, works3_url: user.seller.works3.url, works4_url: user.seller.works4.url }
        render json: { user_info: user, seller_info: seller_info, image_urls: image_urls  }, status: :ok
      else
        render json: { error: 'Invalid user type' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update_password
    if @user.update(user_password)
      render json: { message: 'Password successfully updated' }
    else
      render json: { error: 'Failed to update password', errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_info
    if valid_email?(user_params[:email]) && @user.update_columns(user_params.to_h)
      render json: { message: 'User information successfully updated' }
    else
      render json: { error: 'Failed to update user information', errors: ['Invalid email format'] }, status: :unprocessable_entity
    end
  end


  private

  def find_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :city, :contact_information)
  end

  def user_password
    params.require(:user).permit(:password)
  end

  def valid_email?(email)
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    email.match?(email_regex)
  end

end
