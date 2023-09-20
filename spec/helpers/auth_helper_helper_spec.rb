require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe AuthHelper do
  describe '.generate_token' do
    it 'generates a valid JWT token' do
      user = FactoryBot.create(:user)
      token = AuthHelper.generate_token(user.id, user.user_type)
      expect(token).not_to be_nil
    end
  end

  describe '.decode_token' do
    it 'decodes a valid JWT token' do
      user = FactoryBot.create(:user)
      token = AuthHelper.generate_token(user.id, user.user_type)
      decoded_payload = AuthHelper.decode_token(token)
      expect(decoded_payload).not_to be_nil
      expect(decoded_payload['user_id']).to eq(user.id)
      expect(decoded_payload['user_type']).to eq(user.user_type)
    end

    it 'returns nil for an expired token' do
      expired_token = 'expired_token_here'
      decoded_payload = AuthHelper.decode_token(expired_token)
      expect(decoded_payload).to be_nil
    end

    it 'returns nil for an invalid token' do
      invalid_token = 'invalid_token_here'
      decoded_payload = AuthHelper.decode_token(invalid_token)
      expect(decoded_payload).to be_nil
    end
  end
end
