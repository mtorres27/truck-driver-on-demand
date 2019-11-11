# frozen_string_literal: true

# == Schema Information
#
# Table name: job_favourites
#
#  id         :bigint           not null, primary key
#  driver_id  :integer
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :job_favourite do
  end
end
