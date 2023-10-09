class Seller < ApplicationRecord
  belongs_to :user

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
    self.seller_rating ||= 0.0
  end

end
