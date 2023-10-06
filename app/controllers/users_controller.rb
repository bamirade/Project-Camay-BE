class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:confirm_email]
  include ActiveStorage::SetCurrent

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && !user.status
      user.update_column(:status, true)
      user.update_column(:confirmation_token, nil)
      UserMailer.approval_email(user).deliver_now

      response.headers['Refresh'] = '5;url=http://localhost:5173/login'
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



end
