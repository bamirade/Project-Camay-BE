class Seller < ApplicationRecord
  belongs_to :user
  has_many :commissions
  has_many :commission_types


  validates :bio, length: { maximum: 101 }

  after_initialize :set_defaults

  has_one_attached :avatar
  has_one_attached :cover
  has_one_attached :works1
  has_one_attached :works2
  has_one_attached :works3
  has_one_attached :works4

  def set_defaults
    self.bio ||= ''
    self.portfolio ||= ''
    self.seller_rating ||= update_seller_rating
  end

  def update_seller_rating
    valid_ratings = commissions.where.not(rating: nil).pluck(:rating)
    self.seller_rating = valid_ratings.empty? ? 0.0 : (valid_ratings.sum.to_f / valid_ratings.size).round(2)
    save
  end
end
