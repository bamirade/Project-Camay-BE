class CommissionType < ApplicationRecord
  belongs_to :seller
  has_many :commissions

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :seller, presence: true
end
