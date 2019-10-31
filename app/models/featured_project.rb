# frozen_string_literal: true

# == Schema Information
#
# Table name: featured_projects
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  file_data  :string
#

class FeaturedProject < ApplicationRecord

  belongs_to :company
  include FeaturedProjectUploader[:file]

end
