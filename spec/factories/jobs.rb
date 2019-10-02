# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  company_id           :integer          not null
#  title                :string
#  state                :string           default("created"), not null
#  summary              :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  address              :string
#  lat                  :decimal(9, 6)
#  lng                  :decimal(9, 6)
#  formatted_address    :string
#  country              :string
#  job_markets          :citext
#  manufacturer_tags    :citext
#  state_province       :string
#  technical_skill_tags :text
#
# Indexes
#
#  index_jobs_on_company_id         (company_id)
#  index_jobs_on_manufacturer_tags  (manufacturer_tags)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#

FactoryBot.define do
  factory :job do
    title { "MyString" }
    summary { "MyText" }
    address { "Address" }
    country { "ca" }
  end
end
