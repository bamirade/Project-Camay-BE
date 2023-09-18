class Seller < ApplicationRecord
  belongs_to :user

  after_initialize :set_defaults

  def set_defaults
    self.bio ||= ''
    self.portfolio ||= ''
    self.seller_rating ||= 0.0
  end
end
