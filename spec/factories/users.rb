FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
    user_type { ['Seller', 'Buyer'].sample }
    city { Faker::Address.city }
    status { false }

    after(:create) do |user|
      case user.user_type
      when 'Seller'
        create(:seller, user: user)
      when 'Buyer'
        create(:buyer, user: user)
      end
    end
  end
end
