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

class CompanyInstall < ApplicationRecord
end
