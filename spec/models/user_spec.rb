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

  describe '#convert_to_webp' do
    let(:user) { create(:user) }
    let(:image_type) { 'avatar' }

    it 'converts an image to WebP format' do
      image_path = Rails.root.join('spec', 'fixtures', 'sample_image.jpg')
      avatar_io = Rack::Test::UploadedFile.new(image_path, 'image/jpeg')

      webp_io = user.convert_to_webp(avatar_io, image_type)

      expect(webp_io).to be_a(Hash)
      expect(webp_io[:io]).to be_a(File)
      expect(webp_io[:filename]).to match(/\A#{image_type}_\d+_\d+\.webp\z/)
      expect(webp_io[:content_type]).to eq('image/webp')

    ensure
      webp_io[:io].close if webp_io[:io]
      File.delete(webp_io[:io].path) if File.exist?(webp_io[:io].path)
    end

    it 'raises an error when conversion fails' do
      invalid_image_path = Rails.root.join('spec', 'fixtures', 'invalid_image.txt')
      invalid_avatar_io = Rack::Test::UploadedFile.new(invalid_image_path, 'text/plain')

      expect { user.convert_to_webp(invalid_avatar_io, image_type) }.to raise_error(StandardError)
    end
  end

end
