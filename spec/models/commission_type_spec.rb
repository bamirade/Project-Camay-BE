require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe CommissionType, type: :model do
  let(:seller) { create(:seller) }
  it "is valid with valid attributes" do
    commission_type = build(:commission_type, seller: seller)
    expect(commission_type).to be_valid
  end

  it "is not valid without a title" do
    commission_type = build(:commission_type, title: nil)
    expect(commission_type).not_to be_valid
  end

  it "is not valid without a price" do
    commission_type = build(:commission_type, price: nil)
    expect(commission_type).not_to be_valid
  end

  it "is not valid with a negative price" do
    commission_type = build(:commission_type, price: -10)
    expect(commission_type).not_to be_valid
  end

  it "is not valid without a seller" do
    commission_type = build(:commission_type, seller: nil)
    expect(commission_type).not_to be_valid
  end
end
