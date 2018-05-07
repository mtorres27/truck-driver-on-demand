FactoryBot.define do
  factory :subscription do
    company_id 1
    plan_id 1
    stripe_subscription_id "MyString"
    is_active false
    ends_at "2018-03-11"
    billing_perios_ends_at "2018-03-11"
    amount "9.99"
  end
end
