FactoryGirl.define do
  factory :company do
    email Faker::Internet.unique.email
    name Faker::Name.unique.name
  end
end
