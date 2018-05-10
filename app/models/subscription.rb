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
#

class Subscription < ApplicationRecord
  CANADA_SALES_TAX_PERCENT = 13
end