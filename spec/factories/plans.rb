# == Schema Information
#
# Table name: plans
#
#  id               :integer          not null, primary key
#  name             :string
#  code             :string
#  trial_period     :integer
#  subscription_fee :decimal(10, 2)
#  fee_schema       :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  description      :text
#  period           :string           default("yearly")
#

FactoryBot.define do
  factory :plan do
    name "MyString"
    code "MyString"
    trial_period 1
    subscription_fee "9.99"
    fee_schema ""
  end
end
