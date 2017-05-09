# == Schema Information
#
# Table name: quotes
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  amount       :decimal(10, 2)   not null
#  rejected     :boolean          default("false"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Quote < ApplicationRecord
  belongs_to :applicant

  validates :applicant, presence: true
  validates :amount, presence: true, numericality: true, sane_price: true
end
