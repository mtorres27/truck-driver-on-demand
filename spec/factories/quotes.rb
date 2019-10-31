# frozen_string_literal: true

# == Schema Information
#
# Table name: quotes
#
#  id                     :integer          not null, primary key
#  company_id             :integer          not null
#  applicant_id           :integer          not null
#  state                  :string           default("pending"), not null
#  attachment_data        :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  author_type            :string           default("freelancer")
#  accepted_by_freelancer :boolean          default(FALSE)
#  paid_by_company        :boolean          default(FALSE)
#  paid_at                :datetime
#  platform_fees_amount   :decimal(10, 2)
#  tax_amount             :decimal(10, 2)
#  total_amount           :decimal(10, 2)
#  applicable_sales_tax   :integer
#  avj_fees               :decimal(10, 2)
#  stripe_fees            :decimal(10, 2)
#  net_avj_fees           :decimal(10, 2)
#  accepted_at            :datetime
#  avj_credit             :decimal(10, 2)
#  plan_fee               :decimal(10, 2)   default(0.0)
#
# Indexes
#
#  index_quotes_on_applicant_id  (applicant_id)
#  index_quotes_on_company_id    (company_id)
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#  fk_rails_...  (company_id => companies.id)
#

FactoryBot.define do
  factory :quote do
    applicant { nil }
    amount { "9.99" }
  end
end
