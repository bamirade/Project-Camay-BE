FactoryBot.define do
  factory :seller do
    user
    bio { Faker::Lorem.paragraph }
    portfolio { Faker::Lorem.sentence }
    seller_rating { Faker::Number.decimal(l_digits: 1, r_digits: 1) }
  end
end
