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
    title "MyString"
    summary "MyText"
    scope_of_work "MyText"
    budget "9.99"
    job_function "MyString"
    starts_on "2017-04-27 14:24:45"
    ends_on "2017-04-27 14:24:45"
    duration 1
    invite_only false
    scope_is_public false
    budget_is_public false
    contract_price "9.99"
    payment_schedule "MyText"
    require_photos_on_updates false
    require_checkin false
    require_uniform false
    addendums "MyText"
    freelancer_type "independent"
    address "Address"
    country "ca"
    currency "CAD"
    job_type "system_integration"
    job_market "house_of_worship"
  end
end
