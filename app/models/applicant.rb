# == Schema Information
#
# Table name: applicants
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  quote         :decimal(10, 2)   not null
#  accepted      :boolean          default("false"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Applicant < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer
end
