# frozen_string_literal: true

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

  belongs_to :freelancer, class_name: "User", foreign_key: "freelancer_id"
  belongs_to :company

end
