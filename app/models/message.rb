# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  job_id          :integer
#  authorable_type :string
#  authorable_id   :integer
#  message         :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :job
  belongs_to :authorable, polymorphic: true

  validates :job, presence: true
  validates :authorable, presence: true
  validate :must_have_body_or_attachment

  def must_have_body_or_attachment
    if body.blank? && attachment_data.blank?
      errors.add(:base, "A body or an attachment is required")
    end
  end
end
