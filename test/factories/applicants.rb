# == Schema Information
#
# Table name: applicants
#
#  id             :integer          not null, primary key
#  company_id     :integer          not null
#  job_id         :integer          not null
#  freelancer_id  :integer          not null
#  state          :string           default("quoting"), not null
#  quotes_count   :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  messages_count :integer          default(0), not null
#

FactoryGirl.define do
  factory :applicant do
    job nil
    freelancer nil
    quote "9.99"
    accepted ""
  end
end
