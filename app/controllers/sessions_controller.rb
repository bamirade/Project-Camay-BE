class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def login
    user = User.find_by(email: params[:email])

    if user
      if user.authenticate(params[:password])
        if user.status
          token = AuthHelper.generate_token(user.id, user.user_type)
          user_data = { token: token, user_type: user.user_type }

          # Check if the user is a seller and include seller-specific information
          if user.user_type == 'Seller'
            seller = user.seller
            user_data[:seller_info] = {
              bio: seller.bio,
              portfolio: seller.portfolio,
              seller_rating: seller.seller_rating,
              avatar_url: seller.avatar.url,
              cover_url: seller.cover.url
            }
          end

          render json: user_data, status: :ok
        else
          render json: { error: 'User account is currently inactive' }, status: :forbidden
        end
      else
        render json: { error: 'Incorrect password' }, status: :unauthorized
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
