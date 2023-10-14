FactoryBot.define do
  factory :commission do
    price { Faker::Number.decimal(l_digits: 2) }
    stage { %w(Pending InProgress Completed).sample }
    rating { Faker::Number.between(from: 1, to: 5) }
    description { Faker::Lorem.sentence }
    buyer
    seller
    commission_type
  end
end
