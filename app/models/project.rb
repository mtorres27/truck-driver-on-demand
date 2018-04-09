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
  extend Enumerize

  belongs_to :company
  has_many :jobs, -> { order(updated_at: :desc) }, dependent: :destroy

  audited

  # enumerize :currency, in: [
  #   :cad,
  #   :euro,
  #   :ruble,
  #   :rupee,
  #   :usd,
  #   :yen,
  # ]

  def currency
    jobs.first.nil? ? nil : jobs.first.currency
  end

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

  def gpayments_sum_paid
    jobs.sum { |job| job.gpayments_sum_paid || 0 }
  end

  def gpayments_sum_oustanding
    jobs.sum { |job| job.gpayments_sum_outstanding || 0 }
  end

  def gpayments_sum_total
    jobs.sum { |job| job.gpayments_sum_total || 0 }
  end
end
