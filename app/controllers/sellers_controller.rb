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
        cover_url: seller.seller.cover.url,
        works1_url: seller.seller.works1.url,
        works2_url: seller.seller.works2.url,
        works3_url: seller.seller.works3.url,
        works4_url: seller.seller.works4.url
      }
    else
      render json: {error: 'Seller not found' }, status: :not_found
    end
  end

  def avatar_update
    user = User.find(params[:id])

    if update_avatar[:avatar]
      begin
        webp_io = user.convert_to_webp(update_avatar[:avatar].tempfile)
      rescue => e
        render json: { error: "Error converting image to WebP: #{e.message}" }, status: :unprocessable_entity
        return
      end
    end

    if user.seller.update_attribute(:avatar, webp_io)
      render json: { user: user.seller.avatar.url }, status: :ok
    else
      render json: { errors: user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def cover_update
    user = User.find(params[:id])

    if update_cover[:cover]
      begin
        webp_io = user.convert_to_webp(update_cover[:cover].tempfile)
      rescue => e
        render json: { error: "Error converting image to WebP: #{e.message}" }, status: :unprocessable_entity
        return
      end
    end

    if user.seller.update_attribute(:cover, webp_io)
      render json: { user: user.seller.cover.url }, status: :ok
    else
      render json: { errors: user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def avatar_destroy
    user = User.find(params[:id])

    if user.seller.avatar.attached?
      user.seller.avatar.purge
      render json: { message: "Seller avatar deleted successfully" }, status: :no_content
    else
      render json: { errors: user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def cover_destroy
    user = User.find(params[:id])

    if user.seller.cover.attached?
      user.seller.cover.purge
      render json: { message: "Seller cover deleted successfully" }, status: :no_content
    else
      render json: { errors: user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  private

  def update_avatar
    params.require(:user).permit(:avatar)
  end

  def update_cover
    params.require(:user).permit(:cover)
  end

end
