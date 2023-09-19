module AuthHelper
  SECRET_KEY = ENV['SECRET_KEY_BASE']
  EXPIRATION_TIME = 168.hours.to_i

  def self.generate_token(user_id, user_type)
    expiration_time = Time.now.to_i + EXPIRATION_TIME
    payload = { user_id: user_id, user_type: user_type, exp: expiration_time }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode_token(token)
    begin
      decoded_token = JWT.decode(token, SECRET_KEY, algorithm: 'HS256').first
      decoded_token if decoded_token['exp'] >= Time.now.to_i
    rescue JWT::DecodeError, JWT::ExpiredSignature
      nil
    end
  end
end
