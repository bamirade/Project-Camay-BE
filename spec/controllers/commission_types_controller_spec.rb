require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe CommissionTypesController, type: :controller do
  let(:user) { create(:user, user_type: 'Seller') }
  let(:seller) { user.seller }
  let(:commission_type) { create(:commission_type, seller: seller) }

  describe 'POST #create' do
    context 'when a valid commission type is provided' do
      it 'creates a new commission type' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        post :create, params: { commission_type: { title: 'New Commission', price: 20.0 } }

        expect(response).to have_http_status(:created)
      end
    end

    context 'when an invalid commission type is provided' do
      it 'returns unprocessable entity status' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        post :create, params: { commission_type: { title: '', price: -5.0 } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when not authenticated as a seller' do
      it 'returns unauthorized status' do
        post :create, params: { commission_type: { title: 'New Commission', price: 20.0 } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #my_commissions' do
    context 'when the seller has commissions' do
      it 'returns a list of commissions' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        get :my_commissions

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the seller has no commissions' do
      it 'returns an empty list' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        get :my_commissions

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when not authenticated as a seller' do
      it 'returns unauthorized status' do
        get :my_commissions

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update_commissions' do
    context 'when not authenticated as a seller' do
      it 'returns unauthorized status' do
        put :update_commissions, params: { id: commission_type.id, commission_type: { title: 'Updated Commission' } }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #delete_commissions' do

    context 'when not authenticated as a seller' do
      it 'returns unauthorized status' do
        delete :delete_commissions, params: { id: commission_type.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #commissions' do
    context 'when requesting commissions for an existing seller' do
      it 'returns a list of commissions' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        get :commissions, params: { username: user.username }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when requesting commissions for a non-existing seller' do
      it 'returns not found status' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        get :commissions, params: { username: 'nonexistent_user' }

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the seller has no commissions' do
      it 'returns an empty list' do
        request.headers['Authorization'] = "Bearer #{AuthHelper.generate_token(user.id, 'Seller')}"
        seller.commission_types.destroy_all
        get :commissions, params: { username: user.username }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
