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

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
