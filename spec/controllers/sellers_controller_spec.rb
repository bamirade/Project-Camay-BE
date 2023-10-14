require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe SellersController, type: :controller do
  let(:user) { create(:user, user_type: 'Seller', status: true) }
  let(:seller) { user.seller }

  describe 'GET #index' do
    it 'returns a JSON response with a list of sellers' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to start_with('application/json')
      expect(json_response[:data]).to be_an(Array)
    end
  end

  describe 'GET #show' do
    context 'when the seller exists' do
      it 'returns a JSON response with seller details' do
        get :show, params: { username: user.username }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to start_with('application/json')
        expect(json_response[:username]).to eq(user.username)
      end
    end

    context 'when the seller does not exist' do
      it 'returns a JSON response with an error message' do
        get :show, params: { username: 'nonexistent_username' }
        expect(response).to have_http_status(:not_found)
        expect(json_response[:error]).to eq('Seller not found')
      end
    end
  end

  describe 'PATCH #avatar_update' do
    before { authenticate_user(user) }

    it 'uploads an avatar image' do
      image_file = fixture_file_upload('spec/fixtures/sample_image.jpg', 'image/jpeg')
      patch :avatar_update, params: { id: user.id, user: { avatar: image_file } }

      expect(response).to have_http_status(:ok)
      expect(response.body).to match(/"user":"http:\/\/test\.host\/rails\/active_storage\/disk\/.*\/avatar_update_\d+_\d+\.webp"/)
    end
  end

  [:cover_update, :works1_update, :works2_update, :works3_update, :works4_update].each do |action|
    describe "PATCH ##{action}" do
      before { authenticate_user(user) }

      it "uploads an image for #{action.to_s.humanize}" do
        image_file = fixture_file_upload('spec/fixtures/sample_image.jpg', 'image/jpeg')
        attribute = case action
        when :cover_update
          :cover
        when :works1_update
          :works1
        when :works2_update
          :works2
        when :works3_update
          :works3
        when :works4_update
          :works4
        end
        patch action, params: { id: user.id, user: { attribute => image_file } }

        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/"user":"http:\/\/test\.host\/rails\/active_storage\/disk\/.*\/#{action}_\d+_\d+\.webp"/)
      end
    end
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def authenticate_user(user)
    token = AuthHelper.generate_token(user.id, user.user_type)
    request.headers['Authorization'] = "Token #{token}"
  end
end
