FactoryBot.define do
  factory :commission do
    price { Faker::Number.decimal(l_digits: 2) }
    stage { %w(Pending InProgress Completed).sample }
    buyer
    seller
    commission_type
  end
end
