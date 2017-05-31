# == Schema Information
#
# Table name: quotes
#
#  id              :integer          not null, primary key
#  applicant_id    :integer          not null
#  amount          :decimal(10, 2)   not null
#  pay_type        :string           default("fixed"), not null
#  rejected        :boolean          default("false"), not null
#  body            :text
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
