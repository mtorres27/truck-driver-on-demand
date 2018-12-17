# == Schema Information
#
# Table name: jobs
#
#  id                                     :integer          not null, primary key
#  company_id                             :integer          not null
#  project_id                             :integer
#  title                                  :string
#  state                                  :string           default("created"), not null
#  summary                                :text
#  scope_of_work                          :text
#  budget                                 :decimal(10, 2)
#  job_function                           :string
#  starts_on                              :date
#  ends_on                                :date
#  duration                               :integer
#  pay_type                               :string
#  freelancer_type                        :string
#  technical_skill_tags                   :text
#  invite_only                            :boolean          default(FALSE), not null
#  scope_is_public                        :boolean          default(TRUE), not null
#  budget_is_public                       :boolean          default(FALSE), not null
#  working_days                           :text             default([]), not null, is an Array
#  working_time                           :string
#  contract_price                         :decimal(10, 2)
#  payment_schedule                       :jsonb            not null
#  reporting_frequency                    :string
#  require_photos_on_updates              :boolean          default(FALSE), not null
#  require_checkin                        :boolean          default(FALSE), not null
#  require_uniform                        :boolean          default(FALSE), not null
#  addendums                              :text
#  applicants_count                       :integer          default(0), not null
#  messages_count                         :integer          default(0), not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  currency                               :string
#  address                                :string
#  lat                                    :decimal(9, 6)
#  lng                                    :decimal(9, 6)
#  formatted_address                      :string
#  contract_sent                          :boolean          default(FALSE)
#  opt_out_of_freelance_service_agreement :boolean          default(FALSE)
#  country                                :string
#  scope_file_data                        :text
#  applicable_sales_tax                   :decimal(10, 2)
#  stripe_charge_id                       :string
#  stripe_balance_transaction_id          :string
#  funds_available_on                     :integer
#  funds_available                        :boolean          default(FALSE)
#  job_type                               :citext
#  job_market                             :citext
#  manufacturer_tags                      :citext
#  company_plan_fees                      :decimal(10, 2)   default(0.0)
#  contracted_at                          :datetime
#  state_province                         :string
#  creation_step                          :string
#  plan_fee                               :decimal(10, 2)   default(0.0)
#  paid_by_company                        :boolean          default(FALSE)
#  total_amount                           :decimal(10, 2)
#  tax_amount                             :decimal(10, 2)
#  stripe_fees                            :decimal(10, 2)
#  amount_subtotal                        :decimal(10, 2)
#  variable_pay_type                      :string
#  overtime_rate                          :decimal(10, 2)
#  payment_terms                          :integer
#  expired                                :boolean          default(FALSE)
#  fee_schema                             :json
#  creator_id                             :integer
#
# Indexes
#
#  index_jobs_on_company_id         (company_id)
#  index_jobs_on_creator_id         (creator_id)
#  index_jobs_on_manufacturer_tags  (manufacturer_tags)
#  index_jobs_on_project_id         (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (project_id => projects.id)
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
