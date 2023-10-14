require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe 'POST #create' do
    context 'with valid user parameters' do
      it 'creates a new user and sends a confirmation email' do
        user_attributes = FactoryBot.attributes_for(:user)
        expect do
          post :create, params: { user: user_attributes }
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(JSON.parse(response.body)).to include(
          'response' => 'User created successfully. Confirmation email sent.'
        )
      end
    end

    context 'with invalid user parameters' do
      it 'returns an error response' do
        user_attributes = FactoryBot.attributes_for(:user, email: 'invalid_email')
        post :create, params: { user: user_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'response' => 'User creation failed'
        )
      end
    end
  end

  describe 'POST #user_reconfirm' do
    context 'with a valid email address' do
      it 'sends a confirmation email to the user' do
        user = FactoryBot.create(:user, status: false)
        post :user_reconfirm, params: { email: user.email }

        expect(response).to have_http_status(:ok)
        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(JSON.parse(response.body)).to include(
          'message' => 'Confirmation email resent. Please check your email.'
        )
      end
    end

    context 'with an invalid email address' do
      it 'returns an error response' do
        post :user_reconfirm, params: { email: 'invalid_email' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'error' => 'Invalid email format'
        )
      end
    end

    context 'with a confirmed user' do
      it 'returns an error response' do
        user = FactoryBot.create(:user, status: true)
        post :user_reconfirm, params: { email: user.email }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include(
          'error' => 'User account is already confirmed'
        )
      end
    end

    context 'with an email that is not found' do
      it 'returns a not found response' do
        post :user_reconfirm, params: { email: 'non_existent_email@example.com' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)).to include(
          'error' => 'User not found'
        )
      end
    end
  end
end
