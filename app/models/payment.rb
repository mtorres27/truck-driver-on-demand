# == Schema Information
#
# Table name: payments
#
#  id                            :integer          not null, primary key
#  company_id                    :integer          not null
#  job_id                        :integer          not null
#  description                   :string           not null
#  amount                        :decimal(10, 2)   not null
#  issued_on                     :date
#  paid_on                       :date
#  attachment_data               :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  tax_amount                    :decimal(10, 2)
#  total_amount                  :decimal(10, 2)
#  avj_fees                      :decimal(10, 2)
#  avj_credit                    :decimal(10, 2)
#  stripe_charge_id              :string
#  stripe_balance_transaction_id :string
#  funds_available_on            :integer
#  funds_available               :boolean          default(FALSE)
#  company_fees                  :decimal(10, 2)   default(0.0)
#  total_company_fees            :decimal(10, 2)   default(0.0)
#  freelancer_fees               :decimal(10, 2)   default(0.0)
#  total_freelancer_fees         :decimal(10, 2)   default(0.0)
#  transaction_fees              :decimal(10, 2)   default(0.0)
#
# Indexes
#
#  index_payments_on_company_id  (company_id)
#  index_payments_on_job_id      (job_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (job_id => jobs.id)
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
