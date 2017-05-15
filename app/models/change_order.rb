# == Schema Information
#
# Table name: change_orders
#
#  id              :integer          not null, primary key
#  job_id          :integer
#  amount          :decimal(10, 2)   not null
#  body            :text             not null
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ChangeOrder < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :job

  validates :job, presence: true
  validates :amount, presence: true, numericality: true, sane_price: true
  validates :body, presence: true
end
