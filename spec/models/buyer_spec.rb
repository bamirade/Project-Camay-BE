require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe Buyer, type: :model do
  it "has a valid factory" do
    buyer = create(:buyer)
    expect(buyer).to be_valid
  end

  it "belongs to a user" do
    buyer = build(:buyer, user: nil)
    expect(buyer).not_to be_valid
  end
end
