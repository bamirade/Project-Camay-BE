class CommissionsController < ApplicationController
  before_action :find_buyer, only: [:create]
  before_action :find_commission_type, only: [:create]

  def create
    @commission = Commission.new(
      buyer: @buyer,
      seller: @commission_type.seller,
      commission_type: @commission_type,
      price: @commission_type.price,
      stage: "Pending",
      description: params[:description]
    )

    if @commission.save
      render json: { success: true, message: "Commission created successfully", commission: @commission }
      UserMailer.status_pending_email_seller(@commission).deliver_now
      UserMailer.status_pending_email_buyer(@commission).deliver_now
    else
      render json: { success: false, errors: @commission.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def seller_commissions
    if current_user && current_user.user_type == 'Seller'
      commissions = current_user.seller.commissions
      commission_data = commissions.map do |commission|
        {
          commission_id: commission.id,
          buyer_username: commission.buyer.user.username,
          title: commission.commission_type.title,
          price: commission.price,
          stage: commission.stage,
          description: commission.description || "",
          rating: commission.rating || ""
        }
      end

      render json: { commissions: commission_data }, status: :ok
    else
      render json: { error: 'You are not authorized to view this information.' }, status: :unauthorized
    end
  end


  def buyer_commissions
    if current_user && current_user.user_type == 'Buyer'
      commissions = current_user.buyer.commissions
      commission_data = commissions.map do |commission|
        {
          commission_id: commission.id,
          seller_username: commission.seller.user.username,
          title: commission.commission_type.title,
          price: commission.price,
          stage: commission.stage,
          description: commission.description || "",
          rating: commission.rating || nil
        }
      end

      render json: { commissions: commission_data }, status: :ok
    else
      render json: { error: 'You are not authorized to view this information.' }, status: :unauthorized
    end
  end

  def update_progress
    @commission = Commission.find_by(id: params[:id])

    if @commission.stage == "Pending" && current_user.user_type == 'Seller'
      if @commission.update(stage: "InProgress")
        UserMailer.status_progress_email_buyer(@commission).deliver_now
        render json: { message: "Commission updated successfully" }
      else
        render json: { errors: @commission.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Commission stage must be 'Pending' for update" }, status: :unprocessable_entity
    end
  end


  def update_complete
    @commission = Commission.find_by(id: params[:id])

    if @commission.stage == "InProgress" && current_user.user_type == 'Buyer'
      if @commission.update(stage: "Completed")
        UserMailer.status_completed_email_seller(@commission).deliver_now
        render json: { message: "Commission updated successfully" }
      else
        render json: { errors: @commission.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Commission stage must be 'InProgress' for update" }, status: :unprocessable_entity
    end
  end

  def rate
    @commission = Commission.find_by(id: params[:id])

    if @commission.stage == "Completed" && current_user.user_type == 'Buyer'
      if params[:rating].to_i >= 1 && params[:rating].to_i <= 5
        if @commission.update(rating: params[:rating])
          @commission.seller.update_seller_rating
          render json: { message: "Commission rated successfully" }
        else
          render json: { errors: @commission.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Rating must be greater than 1" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Commission stage must be 'Completed' for update" }, status: :unprocessable_entity
    end
  end



  private

  def find_buyer
    @buyer = Buyer.find_by(user: current_user)
  end

  def find_commission_type
    @commission_type = CommissionType.find(params[:commission_type_id])
  end
end
