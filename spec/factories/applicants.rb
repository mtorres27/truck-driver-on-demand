# frozen_string_literal: true

# == Schema Information
#
# Table name: applicants
#
#  id             :bigint           not null, primary key
#  company_id     :bigint           not null
#  job_id         :bigint           not null
#  driver_id      :bigint           not null
#  state          :string           default("quoting"), not null
#  quotes_count   :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  messages_count :integer          default(0), not null
#

FactoryBot.define do
  factory :applicant do
    job { nil }
    driver { nil }
  end
end
