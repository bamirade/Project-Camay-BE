require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe Seller, type: :model do
  it "has a valid factory" do
    seller = create(:seller)
    expect(seller).to be_valid
  end

  it "belongs to a user" do
    seller = build(:seller, user: nil)
    expect(seller).not_to be_valid
  end

  it "sets default values for bio, portfolio, and seller_rating" do
    seller = Seller.new
    expect(seller.bio).to eq('')
    expect(seller.portfolio).to eq('')
    expect(seller.seller_rating).to eq(0.0)
  end
end
