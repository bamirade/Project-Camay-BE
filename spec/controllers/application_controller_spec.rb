require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  describe 'authentication' do
    it 'returns unauthorized for missing token' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for invalid token' do
      request.headers['Authorization'] = 'invalid_token'
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'assigns current_user for valid Buyer token' do
      buyer = FactoryBot.create(:buyer)
      valid_token = AuthHelper.generate_token(buyer.user_id, 'Buyer')
      request.headers['Authorization'] = "Bearer #{valid_token}"
      get :index
      expect(assigns(:current_user)).to eq(buyer.user)
    end

    it 'assigns current_user for valid Seller token' do
      seller = FactoryBot.create(:seller)
      valid_token = AuthHelper.generate_token(seller.user_id, 'Seller')
      request.headers['Authorization'] = "Bearer #{valid_token}"
      get :index
      expect(assigns(:current_user)).to eq(seller.user)
    end

    it 'returns unauthorized for unknown user_type' do
      valid_token = AuthHelper.generate_token(1, 'UnknownType')
      request.headers['Authorization'] = "Bearer #{valid_token}"
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
