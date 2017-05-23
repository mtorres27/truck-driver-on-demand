# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  state         :string           default("interested"), not null
#  quotes_count  :integer          default("0"), not null
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
