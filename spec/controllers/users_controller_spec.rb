require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #confirm_email' do
    it 'confirms the user email' do
      user.update(confirmation_token: 'token', status: false)

      post :confirm_email, params: { token: 'token' }

      user.reload
      expect(user.status).to be_truthy
      expect(user.confirmation_token).to be_nil
      expect(response).to have_http_status(:ok)
    end

    it 'renders an error if the confirmation token is invalid' do
      post :confirm_email, params: { token: 'invalid_token' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #user_info' do
    context 'when user is authenticated' do
      before { authenticate_user(user) }

      it 'returns user information for a buyer' do
        get :user_info

        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('user_info')
      end

      it 'returns user information for a seller' do
        user.update(user_type: 'Seller')
        create(:seller, user: user)

        get :user_info

        expect(response).to have_http_status(:ok)
        expect(json_response).to have_key('user_info')
        expect(json_response).to have_key('seller_info')
        expect(json_response).to have_key('image_urls')
      end

      it 'renders an error if the user type is invalid' do
        user.update(user_type: 'InvalidType')

        get :user_info

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'renders an error if user is not authenticated' do
      get :user_info

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update_password' do
    before { authenticate_user(user) }

    it 'updates the user password' do
      new_password = 'new_password'
      user_params = { password: new_password }

      patch :update_password, params: { user: user_params }

      user.reload
      expect(user.authenticate(new_password)).to be_truthy
      expect(response).to have_http_status(:ok)
    end

    it 'renders an error if password update fails' do
      invalid_password = { password: '' }

      patch :update_password, params: { user: invalid_password }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key('error')
      expect(json_response).to have_key('errors')
    end
  end

  describe 'PATCH #update_info' do
    before { authenticate_user(user) }

    it 'updates user information' do
      new_email = 'new_email@example.com'
      user_params = { email: new_email }

      patch :update_info, params: { user: user_params }

      user.reload
      expect(user.email).to eq(new_email)
      expect(response).to have_http_status(:ok)
    end

    it 'renders an error if user information update fails' do
      invalid_info = { email: 'invalid_email', city: nil }

      patch :update_info, params: { user: invalid_info }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response).to have_key('error')
      expect(json_response).to have_key('errors')
    end
  end

  private

  def authenticate_user(user)
    token = AuthHelper.generate_token(user.id, user.user_type)
    request.headers['Authorization'] = "Token #{token}"
  end

  def json_response
    JSON.parse(response.body)
  end
end
