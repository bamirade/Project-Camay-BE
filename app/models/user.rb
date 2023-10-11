class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, :user_type, :city, presence: true
  validates :contact_information, uniqueness: true

  attribute :status, :boolean, default: -> { false }

  before_create :generate_confirmation_token

  has_one :seller, dependent: :destroy
  has_one :buyer, dependent: :destroy

  after_create :create_user_type

  def convert_to_webp(avatar_io, image_type)
    webp_path = "#{Rails.root}/tmp/#{SecureRandom.uuid}.webp"

    begin
      WebP.encode(avatar_io.path, webp_path)
      webp_io = {io: File.open(webp_path), filename: "#{image_type}_#{id}_#{Time.now.to_i}.webp", content_type: 'image/webp'}
      return webp_io
    rescue => e
      File.delete(webp_path) if File.exist?(webp_path)
      raise e
    ensure
      File.delete(webp_path) if File.exist?(webp_path)
    end
  end

  private

  def create_user_type
    case self.user_type
    when 'Seller'
      create_seller
    when 'Buyer'
      create_buyer
    end
  end

  def generate_confirmation_token
    self.confirmation_token ||= SecureRandom.urlsafe_base64
  end
end
