FactoryGirl.define do
  factory :rate, class: ::Rate do
    from  { Faker::Currency.code }
    to    { Faker::Currency.code }
    value { Faker::Number.decimal(2, 6) }
  end
end
