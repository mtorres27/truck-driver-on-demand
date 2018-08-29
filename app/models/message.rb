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
#  checkin         :boolean          default(FALSE)
#  send_contract   :boolean          default(FALSE)
#  unread          :boolean          default(TRUE)
#  lat             :decimal(9, 6)
#  lng             :decimal(9, 6)
#
# Indexes
#
#  index_messages_on_authorable_type_and_authorable_id  (authorable_type,authorable_id)
#  index_messages_on_receivable_type_and_receivable_id  (receivable_type,receivable_id)
#

class Message < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :authorable, polymorphic: true, counter_cache: true
  belongs_to :receivable, polymorphic: true, counter_cache: true

  validate :must_have_body_or_attachment
  validate :must_have_coordinates_when_checkin

  attr_accessor :status, 
    :counter_type, 
    :counter, 
    :counter_hourly_rate, 
    :counter_daily_rate,
    :counter_number_of_hours,
    :counter_number_of_days

  audited

  def must_have_body_or_attachment
    if body.blank? && attachment_data.blank?
      errors.add(:base, "A body or an attachment is required")
    end
  end

  def must_have_coordinates_when_checkin
    if checkin && (lat.blank? || lng.blank?)
      errors.add(:base, "Message must have coordinates when checkin is marked")
    end
  end

  def send_email_notifications
    if authorable.is_a?(Company)
      CompanyMailer.notice_message_sent(authorable, receivable.freelancer, self).deliver_later
      FreelancerMailer.notice_message_received(authorable, receivable.freelancer, receivable, self).deliver_later
    elsif message.authorable.is_a?(Freelancer)
      FreelancerMailer.notice_message_sent(receivable.company, authorable, self).deliver_later
      CompanyMailer.notice_message_received(receivable.company, authorable, receivable, self).deliver_later
    end
  end
end
