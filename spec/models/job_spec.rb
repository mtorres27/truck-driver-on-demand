# == Schema Information
#
# Table name: jobs
#
#  id                                     :integer          not null, primary key
#  company_id                             :integer          not null
#  project_id                             :integer          not null
#  title                                  :string           not null
#  state                                  :string           default("created"), not null
#  summary                                :text             not null
#  scope_of_work                          :text
#  budget                                 :decimal(10, 2)   not null
#  job_function                           :string           not null
#  starts_on                              :date             not null
#  ends_on                                :date
#  duration                               :integer          not null
#  pay_type                               :string
#  freelancer_type                        :string           not null
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
#

require 'rails_helper'

describe Job, type: :model do
  describe "city_state_country" do
    let(:company) { create(:company) }
    let(:project) { create(:project, company: company) }
    let(:job) { build(:job, state_province: 'Ontario', address: 'Toronto', country: 'ca', company: company, project: project) }

    it "returns location with state" do
      expect(job.city_state_country).to eq("Toronto, Ontario, CA")
    end
  end
end
