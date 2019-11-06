# frozen_string_literal: true

# == Schema Information
#
# Table name: change_orders
#
#  id              :bigint           not null, primary key
#  company_id      :bigint           not null
#  job_id          :bigint           not null
#  amount          :decimal(10, 2)   not null
#  body            :text             not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ChangeOrder < ApplicationRecord

  include AttachmentUploader[:attachment]

  belongs_to :company
  belongs_to :job

  audited

  validates :amount, numericality: true, sane_price: true

end
