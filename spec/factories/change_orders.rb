# == Schema Information
#
# Table name: change_orders
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  job_id          :integer          not null
#  amount          :decimal(10, 2)   not null
#  body            :text             not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_change_orders_on_company_id  (company_id)
#  index_change_orders_on_job_id      (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (job_id => jobs.id)
#

FactoryBot.define do
  factory :change_order do
    job { nil }
    amount { "9.99" }
    description { "MyText" }
  end
end
