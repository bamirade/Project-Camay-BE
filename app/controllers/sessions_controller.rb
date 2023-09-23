class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def login
    user = User.find_by(email: params[:email])

    if user
      if user.authenticate(params[:password])
        if user.status
          token = AuthHelper.generate_token(user.id, user.user_type)
          render json: { token: token, user_type: user.user_type }, status: :ok
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
