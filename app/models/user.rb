class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :password, :user_type, :city, presence: true

  attribute :status, :boolean, default: -> { false }

  before_create :generate_confirmation_token

  has_one :seller, dependent: :destroy
  has_one :buyer, dependent: :destroy

  after_create :create_user_type

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
