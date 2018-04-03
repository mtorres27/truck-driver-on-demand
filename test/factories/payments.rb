# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  job_id          :integer          not null
#  description     :string           not null
#  amount          :decimal(10, 2)   not null
#  issued_on       :date
#  paid_on         :date
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :payment do
    job nil
    amount "9.99"
    occurred_at "2017-05-10 11:41:35"
  end
end
