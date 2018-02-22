# == Schema Information
#
# Table name: company_installs
#
#  id         :integer          not null, primary key
#  company_id :integer
#  year       :integer
#  installs   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :company_install do
    
  end
end
