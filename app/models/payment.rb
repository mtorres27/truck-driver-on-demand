# == Schema Information
#
# Table name: payments
#
#  id          :integer          not null, primary key
#  job_id      :integer
#  description :string           not null
#  amount      :decimal(10, 2)   not null
#  due_on      :datetime
#  paid_on     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Payment < ApplicationRecord
  belongs_to :job

  validates :job, presence: true
  validates :amount, presence: true, numericality: true, sane_price: true
end
