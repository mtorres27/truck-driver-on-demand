# == Schema Information
#
# Table name: change_orders
#
#  id              :integer          not null, primary key
#  job_id          :integer          not null
#  amount          :decimal(10, 2)   not null
#  body            :text             not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :change_order do
    job nil
    amount "9.99"
    description "MyText"
  end
end
