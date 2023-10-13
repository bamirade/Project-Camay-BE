class SellersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :find_user, only: %i[avatar_update cover_update works1_update works2_update works3_update works4_update avatar_destroy cover_destroy works1_destroy works2_destroy works3_destroy works4_destroy update_bio]
  before_action :set_image_type, only: %i[avatar_update cover_update works1_update works2_update works3_update works4_update]

  include ActiveStorage::SetCurrent

  def index
    sellers = User.where(user_type: 'Seller', status: true).includes(:seller).all
    seller_data = sellers.map do |seller|
      if seller.seller.present?
        avatar_url = seller.seller.avatar.attached? ? url_for(seller.seller.avatar) : nil
        {
          username: seller.username,
          city: seller.city,
          avatar_url: avatar_url,
          rating: seller.seller.seller_rating
        }
      else
        {
          username: seller.username,
          city: seller.city,
          avatar_url: nil,
          rating: 0.0
        }
      end
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
    update_image(:avatar)
  end

  def cover_update
    update_image(:cover)
  end

  def works1_update
    update_image(:works1)
  end

  def works2_update
    update_image(:works2)
  end

  def works3_update
    update_image(:works3)
  end

  def works4_update
    update_image(:works4)
  end

  def avatar_destroy
    destroy_image(:avatar, 'Seller avatar')
  end

  def cover_destroy
    destroy_image(:cover, 'Seller cover')
  end

  def works1_destroy
    destroy_image(:works1, 'Seller works 1')
  end

  def works2_destroy
    destroy_image(:works2, 'Seller works 2')
  end

  def works3_destroy
    destroy_image(:works3, 'Seller works 3')
  end

  def works4_destroy
    destroy_image(:works4, 'Seller works 4')
  end

  def update_bio
    seller = @user&.seller

    if seller
      if seller.update(bio_params)
        render json: { message: 'Bio updated successfully' }
      else
        render json: { errors: seller.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Seller not found for this user' }, status: :not_found
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def set_image_type
    @image_type = action_name.to_sym
  end

  def update_image(image_param)
    if params[:user][image_param]
      begin
        webp_io = @user.convert_to_webp(params[:user][image_param].tempfile, @image_type.to_s)
      rescue => e
        render json: { error: "Error converting image to WebP: #{e.message}" }, status: :unprocessable_entity
        return
      end
    end

    if @user.seller.update_attribute(image_param, webp_io)
      render json: { user: @user.seller.send(image_param).url }, status: :ok
    else
      render json: { errors: @user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def destroy_image(image_param, success_message)
    if @user.seller.send(image_param).attached?
      @user.seller.send(image_param).purge
      render json: { message: "#{success_message} deleted successfully" }, status: :no_content
    else
      render json: { errors: @user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def bio_params
    params.require(:user).require(:seller).permit(:bio)
  end
end
