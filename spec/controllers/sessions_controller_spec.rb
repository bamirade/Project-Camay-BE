require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #login' do
    context 'with valid credentials and an active user' do
      let(:user) { create(:user, status: true) }
      let(:valid_params) { { email: user.email, password: user.password } }

      it 'returns a valid token' do
        post :login, params: valid_params
        expect(response).to have_http_status(:ok)

        user_data = JSON.parse(response.body)
        expect(user_data).to have_key('token')
        expect(user_data).to have_key('user_type')
        expect(user_data['user_type']).to eq(user.user_type)
        expect(user_data).to have_key('username')
        expect(user_data['username']).to eq(user.username)
        expect(user_data).to have_key('id')
        expect(user_data['id']).to eq(user.id)
      end
    end

    context 'with incorrect password' do
      let(:user) { create(:user, status: true) }
      let(:invalid_params) { { email: user.email, password: 'wrong_password' } }

      it 'returns unauthorized status' do
        post :login, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Incorrect password' })
      end
    end

    context 'with an inactive user' do
      let(:user) { create(:user, status: false) }
      let(:inactive_params) { { email: user.email, password: user.password } }

      it 'returns forbidden status' do
        post :login, params: inactive_params
        expect(response).to have_http_status(:forbidden)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User account is currently inactive' })
      end
    end

    context 'with a non-existent user' do
      let(:non_existent_params) { { email: 'nonexistent@example.com', password: 'password' } }

      it 'returns not found status' do
        post :login, params: non_existent_params
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'User not found' })
      end
    end
  end
end
