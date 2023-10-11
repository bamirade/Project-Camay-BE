class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user!

  def current_user
    @current_user ||= authenticate_user_with_role
  end

  def authenticate_user_with_role
    token = authenticate_with_http_token { |t| t }
    return nil unless token

    payload = AuthHelper.decode_token(token)
    return nil unless payload

    user_type = payload['user_type']
    user_id = payload['user_id']

    case user_type
    when 'Buyer'
      Buyer.find_by(user_id: user_id)&.user
    when 'Seller'
      Seller.find_by(user_id: user_id)&.user
    else
      nil
    end
  end

  def authenticate_user!
    render_unauthorized unless current_user
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
