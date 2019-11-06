# frozen_string_literal: true

# == Schema Information
#
# Table name: job_invites
#
#  id         :bigint           not null, primary key
#  job_id     :integer
#  driver_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :job_invite do
  end
end
