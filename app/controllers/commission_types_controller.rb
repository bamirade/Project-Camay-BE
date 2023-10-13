class CommissionTypesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:commissions]
  before_action :find_user, only: [:create, :my_commissions, :update_commissions, :delete_commissions]

  def create
    @commission_type = @seller.commission_types.new(commission_type_params)

    if @commission_type.save
      render json: @commission_type, status: :created
    else
      render json: @commission_type.errors, status: :unprocessable_entity
    end
  end

  def my_commissions
    if @seller.commission_types
      render json: @seller.commission_types
    else
      render json: @commission_type.error
    end
  end

  def update_commissions
    @commission_type = @seller.commission_types.find(params[:id])

    if @commission_type.update(commission_type_params)
      render json: @commission_type, status: :ok
    else
      render json: @commission_type.errors, status: :unprocessable_entity
    end
  end

  def delete_commissions
    @commission_type = @seller.commission_types.find(params[:id])
    if @commission_type.destroy
      render json: { message: "Commission deleted successfully" }, status: :no_content
    else
      render json: { error: "Failed to delete commission" }, status: :unprocessable_entity
    end
  end

  def commissions
    user = User.find_by(username: params[:username])
    if user
      seller = user.seller
      if seller && seller.commission_types.any?
        render json: seller.commission_types
      else
        render json: { error: "No commission types found for this user's seller" }, status: :not_found
      end
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def find_user
    @seller = Seller.find_by(user_id: current_user.id)
  end

  def commission_type_params
    params.require(:commission_type).permit(:title, :price)
  end
end
