# == Schema Information
#
# Table name: jobs
#
#  id                        :integer          not null, primary key
#  project_id                :integer
#  title                     :string           not null
#  summary                   :text             not null
#  scope_of_work             :text
#  budget                    :decimal(10, 2)   not null
#  job_function              :string           not null
#  starts_on                 :date             not null
#  ends_on                   :date
#  duration                  :integer          not null
#  pay_type                  :string
#  freelancer_type           :string           not null
#  keywords                  :text
#  invite_only               :boolean          default("false"), not null
#  scope_is_public           :boolean          default("true"), not null
#  budget_is_public          :boolean          default("true"), not null
#  working_days              :text
#  working_times             :string
#  contract_price            :decimal(10, 2)
#  contract_paid             :decimal(10, 2)
#  payment_schedule          :text
#  reporting_frequency       :string
#  require_photos_on_updates :boolean          default("false"), not null
#  require_checkin           :boolean          default("false"), not null
#  require_uniform           :boolean          default("false"), not null
#  addendums                 :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryGirl.define do
  factory :job do
    project nil
    title "MyString"
    summary "MyText"
    scope_of_work "MyText"
    budget "9.99"
    job_function "MyString"
    starts_on "2017-04-27 14:24:45"
    ends_on "2017-04-27 14:24:45"
    duration 1
    pay_type "MyString"
    freelancer_type "MyString"
    keywords "MyText"
    invite_only false
    scope_is_public false
    budget_is_public false
    working_days "MyText"
    working_times "MyString"
    contract_price "9.99"
    payment_schedule "MyText"
    reporting_frequency "MyString"
    require_photos_on_updates false
    require_checkin false
    require_uniform false
    addendums "MyText"
  end
end
