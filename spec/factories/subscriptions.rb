# == Schema Information
#
# Table name: subscriptions
#
#  id                     :integer          not null, primary key
#  company_id             :integer
#  plan_id                :integer
#  stripe_subscription_id :string
#  is_active              :boolean
#  ends_at                :date
#  billing_perios_ends_at :date
#  amount                 :decimal(, )
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  refund                 :decimal(10, 2)   default(0.0)
#  tax                    :decimal(10, 2)   default(0.0)
#  description            :string
#  stripe_invoice_id      :string
#  stripe_invoice_date    :datetime
#

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
