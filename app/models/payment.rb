class Payment < ApplicationRecord
  belongs_to :job

  validates :job, presence: true
  validates :amount, presence: true, numericality: true, sane_price: true
end
