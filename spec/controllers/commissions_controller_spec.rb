require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe CommissionsController, type: :controller do
  let(:buyer_user) { create(:user, user_type: 'Buyer') }
  let(:seller_user) { create(:user, user_type: 'Seller') }
  let(:buyer) { create(:buyer, user: buyer_user) }
  let(:seller) { create(:seller, user: seller_user) }
  let(:commission_type) { create(:commission_type, seller: seller) }

  before do
    @buyer_token = AuthHelper.generate_token(buyer_user.id, 'Buyer')
    @seller_token = AuthHelper.generate_token(seller_user.id, 'Seller')
  end

  describe 'POST #create for seller' do
    it 'creates a new commission for a buyer' do
      request.headers['Authorization'] = "Token #{@buyer_token}"

      post :create, params: { commission_type_id: commission_type.id, description: 'Sample description' }

      expect(response).to have_http_status(:ok)
      expect(json_response['success']).to be_truthy
    end
  end

  describe 'GET #seller_commissions' do
    it 'returns seller commissions for seller' do
      request.headers['Authorization'] = "Token #{@seller_token}"
      create(:commission, seller: seller, commission_type: commission_type)

      get :seller_commissions

      expect(response).to have_http_status(:ok)
      expect(json_response['commissions'].count).to eq(0)
    end

    it 'does not allow buyers to access seller commissions' do
      request.headers['Authorization'] = "Token #{@buyer_token}"

      get :seller_commissions

      expect(response).to have_http_status(:unauthorized)
      expect(json_response['error']).to eq('You are not authorized to view this information.')
    end
  end

  describe 'GET #buyer_commissions' do
    it 'returns buyer commissions for buyer' do
      request.headers['Authorization'] = "Token #{@buyer_token}"
      create(:commission, buyer: buyer, commission_type: commission_type)

      get :buyer_commissions

      expect(response).to have_http_status(:ok)
      expect(json_response['commissions'].count).to eq(0)
    end

    it 'does not allow sellers to access buyer commissions' do
      request.headers['Authorization'] = "Token #{@seller_token}"

      get :buyer_commissions

      expect(response).to have_http_status(:unauthorized)
      expect(json_response['error']).to eq('You are not authorized to view this information.')
    end
  end

  describe 'PATCH #update_progress' do
    it 'updates commission stage to InProgress for seller' do
      request.headers['Authorization'] = "Token #{@seller_token}"
      commission = create(:commission, seller: seller, commission_type: commission_type, stage: 'Pending')

      patch :update_progress, params: { id: commission.id }

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Commission updated successfully')
      expect(commission.reload.stage).to eq('InProgress')
    end

    it 'does not allow buyers to update commission stage to InProgress' do
      request.headers['Authorization'] = "Token #{@buyer_token}"
      commission = create(:commission, seller: seller, commission_type: commission_type, stage: 'Pending')

      patch :update_progress, params: { id: commission.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #update_complete' do
    it 'updates commission stage to Completed for buyer' do
      request.headers['Authorization'] = "Token #{@buyer_token}"
      commission = create(:commission, buyer: buyer, commission_type: commission_type, stage: 'InProgress')

      patch :update_complete, params: { id: commission.id }

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Commission updated successfully')
      expect(commission.reload.stage).to eq('Completed')
    end

    it 'does not allow sellers to update commission stage to Completed' do
      request.headers['Authorization'] = "Token #{@seller_token}"
      commission = create(:commission, buyer: buyer, commission_type: commission_type, stage: 'InProgress')

      patch :update_complete, params: { id: commission.id }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #rate' do
    it 'rates a completed commission for buyer' do
      request.headers['Authorization'] = "Token #{@buyer_token}"
      commission = create(:commission, buyer: buyer, commission_type: commission_type, stage: 'Completed')

      patch :rate, params: { id: commission.id, rating: 4 }

      expect(response).to have_http_status(:ok)
      expect(json_response['message']).to eq('Commission rated successfully')
      expect(commission.reload.rating).to eq(4)
    end

    it 'does not allow sellers to rate commissions' do
      request.headers['Authorization'] = "Token #{@seller_token}"
      commission = create(:commission, buyer: buyer, commission_type: commission_type, stage: 'Completed')

      patch :rate, params: { id: commission.id, rating: 4 }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
