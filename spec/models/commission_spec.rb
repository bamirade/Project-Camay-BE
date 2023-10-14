require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe Commission, type: :model do
  let(:seller) { create(:seller) }
  let(:buyer) { create(:buyer) }
  let(:commission_type) { create(:commission_type) }

  it 'is valid with valid attributes' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: commission_type)
    expect(commission).to be_valid
  end

  it 'is not valid without a price' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: commission_type, price: nil)
    expect(commission).not_to be_valid
  end

  it 'is not valid with a non-positive price' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: commission_type, price: -10)
    expect(commission).not_to be_valid
  end

  it 'is not valid without a stage' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: commission_type, stage: nil)
    expect(commission).not_to be_valid
  end

  it 'is not valid with an invalid stage' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: commission_type, stage: 'Invalid')
    expect(commission).not_to be_valid
  end

  it 'is not valid without a buyer' do
    commission = build(:commission, seller: seller, commission_type: commission_type, buyer: nil)
    expect(commission).not_to be_valid
  end

  it 'is not valid without a seller' do
    commission = build(:commission, buyer: buyer, commission_type: commission_type, seller: nil)
    expect(commission).not_to be_valid
  end

  it 'is not valid without a commission type' do
    commission = build(:commission, buyer: buyer, seller: seller, commission_type: nil)
    expect(commission).not_to be_valid
  end
end
