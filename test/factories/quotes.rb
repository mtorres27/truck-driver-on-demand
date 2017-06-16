# == Schema Information
#
# Table name: quotes
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  applicant_id    :integer          not null
#  state           :string           default("pending"), not null
#  amount          :decimal(10, 2)   not null
#  pay_type        :string           default("fixed"), not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :quote do
    applicant nil
    amount "9.99"
  end
end
