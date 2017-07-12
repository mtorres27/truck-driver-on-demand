# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  authorable_type :string
#  authorable_id   :integer          not null
#  receivable_type :string
#  receivable_id   :integer          not null
#  body            :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Message < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :authorable, polymorphic: true, counter_cache: true
  belongs_to :receivable, polymorphic: true, counter_cache: true

  validate :must_have_body_or_attachment

  audited

  def must_have_body_or_attachment
    if body.blank? && attachment_data.blank?
      errors.add(:base, "A body or an attachment is required")
    end
  end
end
