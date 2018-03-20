# == Schema Information
#
# Table name: quotes
#
#  id                     :integer          not null, primary key
#  company_id             :integer          not null
#  applicant_id           :integer          not null
#  state                  :string           default("pending"), not null
#  amount                 :decimal(10, 2)   not null
#  pay_type               :string           default("fixed"), not null
#  attachment_data        :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  number_of_hours        :integer
#  hourly_rate            :integer
#  number_of_days         :integer
#  daily_rate             :integer
#  author_type            :string           default("freelancer")
#  accepted_by_freelancer :boolean          default(FALSE)
#  paid_by_company        :boolean          default(FALSE)
#  paid_at                :datetime
#  platform_fees_amount   :decimal(10, 2)
#  tax_amount             :decimal(10, 2)
#  total_amount           :decimal(10, 2)
#  applicable_sales_tax   :integer
#  avj_fees               :decimal(10, 2)
#  stripe_fees            :decimal(10, 2)
#  net_avj_fees           :decimal(10, 2)
#

class Quote < ApplicationRecord
  extend Enumerize
  include AttachmentUploader[:attachment]

  belongs_to :company
  belongs_to :applicant, counter_cache: true

  validates :amount, numericality: true, sane_price: true, allow_blank: true
  validates :daily_rate, numericality: true, sane_price: true, allow_blank: true
  validates :hourly_rate, numericality: true, sane_price: true, allow_blank: true


  audited

  enumerize :pay_type, in: [ :fixed, :hourly, :daily ], predicates: true
  enumerize :state, in: [ :pending, :declined, :accepted ], predicates: true

  def accept!
    self.state = :accepted
    self.accepted_at = Time.zone.today
    save
  end

  def decline!
    self.state = :declined
    save
  end
end
