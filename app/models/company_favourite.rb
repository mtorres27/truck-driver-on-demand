# == Schema Information
#
# Table name: company_favourites
#
#  id            :integer          not null, primary key
#  freelancer_id :integer
#  company_id    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CompanyFavourite < ApplicationRecord
  belongs_to :freelancer
  belongs_to :company
end
