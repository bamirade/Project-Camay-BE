class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(user_params)

    if user.save
      UserMailer.confirmation_email(user).deliver_now
      render json: { user: user, response: @response } , status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :user_type, :city)
  end

end
