# == Schema Information
#
# Table name: job_favourites
#
#  id            :integer          not null, primary key
#  freelancer_id :integer
#  job_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :job_favourite do
    
  end
end
