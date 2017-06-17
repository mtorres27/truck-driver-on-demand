# == Schema Information
#
# Table name: quotes
#
#  id              :integer          not null, primary key
#  company_id      :integer          not null
#  applicant_id    :integer          not null
#  state           :string           default("pending"), not null
#  amount          :decimal(10, 2)   not null
#  pay_type        :string           default("fixed"), not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Quote < ApplicationRecord
  extend Enumerize
  include AttachmentUploader[:attachment]

  belongs_to :company
  belongs_to :applicant, counter_cache: true

  validates :amount, numericality: true, sane_price: true

  audited

  enumerize :pay_type, in: [ :fixed, :hourly ], predicates: true
  enumerize :state, in: [ :pending, :declined, :accepted ], predicates: true

  def accept!
    self.state = :accepted
    save
  end

  def decline!
    self.state = :declined
    save
  end
end
