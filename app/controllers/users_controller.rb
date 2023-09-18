class UsersController < ApplicationController
  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && !user.status
      user.update_column(:status, true)
      user.update_column(:confirmation_token, nil)
      UserMailer.approval_email(user).deliver_now

      render json: { message: "Email confirmed. Redirecting to login page..." }, status: :ok
    else
      render json: { error: "Invalid confirmation token" }, status: :unprocessable_entity
    end
  end
end
