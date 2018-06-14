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
# Indexes
#
#  index_applicants_on_company_id     (company_id)
#  index_applicants_on_freelancer_id  (freelancer_id)
#  index_applicants_on_job_id         (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (freelancer_id => users.id)
#  fk_rails_...  (job_id => jobs.id)
#

FactoryBot.define do
  factory :applicant do
    job nil
    freelancer nil
    quote "9.99"
    accepted ""
  end
end
