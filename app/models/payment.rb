# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  job_id          :integer          not null
#  description     :string           not null
#  amount          :decimal(10, 2)   not null
#  issued_on       :date
#  paid_on         :date
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Payment < ApplicationRecord
  belongs_to :job
  belongs_to :company

  validates :amount, numericality: true, sane_price: true

  audited

  scope :outstanding, -> { where(paid_on: nil) }
  scope :paid, -> { where.not(paid_on: nil) }

  def mark_as_paid!
    update(paid_on: Time.zone.now.to_date)
  end
end
