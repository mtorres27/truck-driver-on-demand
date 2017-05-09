# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  accepted      :boolean          default("false"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :applicant do
    job nil
    freelancer nil
    quote "9.99"
    accepted ""
  end
end
