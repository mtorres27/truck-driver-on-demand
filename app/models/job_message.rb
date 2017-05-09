# == Schema Information
#
# Table name: job_messages
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

class JobMessage < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :job
  belongs_to :authorable, polymorphic: true

  validate :must_have_message_or_attachment

  def must_have_message_or_attachment
    if message.blank? && attachment_data.blank?
      errors.add(:base, "A message or an attachment is required")
    end
  end
end
