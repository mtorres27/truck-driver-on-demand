# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  job_id          :integer
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

  validates :job, presence: true
  validates :amount, presence: true, numericality: true, sane_price: true

  def mark_as_paid!
    self.paid_on = Time.zone.now.to_date
    save
  end
end
