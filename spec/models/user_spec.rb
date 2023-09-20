require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    user = create(:user)
    expect(user).to be_valid
  end

  it "is invalid without a username" do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
  end

  it "is invalid without a unique email" do
    email = Faker::Internet.unique.email
    create(:user, email: email)
    user = build(:user, email: email)
    expect(user).not_to be_valid
  end

  it "is invalid with an invalid email format" do
    user = build(:user, email: "invalid_email")
    expect(user).not_to be_valid
  end

  it "is invalid without a password" do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end

  it "is invalid without a user_type" do
    user = build(:user, user_type: nil)
    expect(user).not_to be_valid
  end

  it "is invalid without a city" do
    user = build(:user, city: nil)
    expect(user).not_to be_valid
  end

  it "creates a seller when user_type is 'Seller'" do
    user = create(:user, user_type: "Seller")
    expect(user.seller).to be_a(Seller)
  end

  it "creates a buyer when user_type is 'Buyer'" do
    user = create(:user, user_type: "Buyer")
    expect(user.buyer).to be_a(Buyer)
  end
end
