# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  amount     :decimal(10, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :payment do
    job nil
    amount "9.99"
    occurred_at "2017-05-10 11:41:35"
  end
end
