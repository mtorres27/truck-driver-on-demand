# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  file_data  :string
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  title      :string
#

FactoryGirl.define do
  factory :attachment do
    
  end
end
