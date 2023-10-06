class SellersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  include ActiveStorage::SetCurrent

  def index
    sellers = User.where(user_type: 'Seller').includes(:seller).all
    seller_data = sellers.map do |seller|
      {
        username: seller.username,
        city: seller.city,
        avatar_url: seller.seller&.avatar&.service_url,
        rating: seller.seller&.seller_rating || 0.0
      }
    end
    render json: { data: seller_data }
  end


  def show
    username = params[:username]
    seller = User.find_by(username: username, user_type: 'Seller')

    if seller
      render json: {
        username: seller.username,
        bio: seller.seller.bio,
        rating: seller.seller.seller_rating,
        avatar_url: seller.seller.avatar.url,
        cover_url: seller.seller.cover.url
      }
    else
      render json: {error: 'Seller not found' }, status: :not_found
    end
  end


end
