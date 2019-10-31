# frozen_string_literal: true

# == Schema Information
#
# Table name: job_invites
#
#  id            :integer          not null, primary key
#  job_id        :integer
#  freelancer_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :job_invite do
  end
end
