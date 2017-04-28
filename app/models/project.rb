# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer
#  external_project_id :string
#  name                :string           not null
#  budget              :decimal(10, 2)   not null
#  starts_on           :date
#  duration            :integer
#  address             :string           not null
#  formatted_address   :string
#  area                :string
#  lat                 :decimal(9, 6)
#  lng                 :decimal(9, 6)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Project < ApplicationRecord
  include Geocodable

  belongs_to :company
  has_many :jobs, dependent: :destroy

  validates :name, presence: true
  validates :budget, presence: true, numericality: true
  validates :duration, numericality: { only_integer: true }, allow_blank: true

  def contract_value
    jobs.sum { |job| job.contract_price || 0 }
  end

  def contract_paid
    jobs.sum { |job| job.contract_paid || 0 }
  end
end
