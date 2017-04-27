# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :datetime
#  duration            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Project < ApplicationRecord

  belongs_to :company

  validates :name, presence: true
  validates :budget, presence: true, numericality: true
  validates :duration, numericality: { only_integer: true }, allow_blank: true

end
