class Commission < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
  belongs_to :commission_type

  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stage, presence: true, inclusion: { in: %w(Pending InProgress Completed) }
  validates :buyer, presence: true
  validates :seller, presence: true
  validates :commission_type, presence: true
end
