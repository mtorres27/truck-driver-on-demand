# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  company_id          :integer          not null
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
#  closed              :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Project < ApplicationRecord
  include Geocodable

  belongs_to :company
  has_many :jobs, -> { order(updated_at: :desc) }, dependent: :destroy

  validates :budget, numericality: true, sane_price: true
  validates :duration, numericality: { only_integer: true, greater_than: 0, less_than: 365 }, allow_blank: true

  audited

  def contract_value
    jobs.sum { |job| job.contract_price || 0 }
  end

  def payments_sum_paid
    jobs.sum { |job| job.payments_sum_paid || 0 }
  end

  def payments_sum_oustanding
    jobs.sum { |job| job.payments_sum_outstanding || 0 }
  end

  def payments_sum_total
    jobs.sum { |job| job.payments_sum_total || 0 }
  end

  scope :open, -> { where(closed: false) }
  scope :closed, -> { where(closed: true) }
end
