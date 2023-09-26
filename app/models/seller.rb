class Seller < ApplicationRecord
  belongs_to :user

  after_initialize :set_defaults

  has_one_attached :avatar
  has_one_attached :cover

  def set_defaults
    self.bio ||= ''
    self.portfolio ||= ''
    self.seller_rating ||= 0.0
  end
end
