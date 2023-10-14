FactoryBot.define do
  factory :commission_type do
    title { Faker::Lorem.word }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    seller
  end
end
