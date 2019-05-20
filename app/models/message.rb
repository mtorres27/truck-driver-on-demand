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
#  job_id          :integer
#
# Indexes
#
#  index_messages_on_authorable_type_and_authorable_id  (authorable_type,authorable_id)
#  index_messages_on_job_id                             (job_id)
#  index_messages_on_receivable_type_and_receivable_id  (receivable_type,receivable_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#

class Message < ApplicationRecord
  include AttachmentUploader[:attachment]

  belongs_to :authorable, polymorphic: true, counter_cache: true
  belongs_to :receivable, polymorphic: true, counter_cache: true
  belongs_to :job, optional: true

  validate :must_have_body_or_attachment

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

  def send_email_notifications
    if authorable.is_a?(Company)
      CompanyMailer.notice_message_sent(authorable, receivable, self).deliver_later
      Notification.create(title: authorable.name, body: "You have a new message", authorable: authorable, receivable: receivable, url: Rails.application.routes.url_helpers.freelancer_company_messages_url(authorable))
      FreelancerMailer.notice_message_received(authorable, receivable, self).deliver_later
    elsif authorable.is_a?(Freelancer)
      FreelancerMailer.notice_message_sent(receivable, authorable, self).deliver_later
      receivable.company_users.each do |company_user|
        Notification.create(title: authorable.first_name_and_initial, body: "You have a new message", authorable: authorable, receivable: company_user, url: Rails.application.routes.url_helpers.company_freelancer_messages_url(authorable))
        CompanyMailer.notice_message_received(company_user, authorable, self).deliver_later
      end
    end
  end

  def self.messages_for(company, freelancer)
    company_messages = company.messages.where(receivable_id: freelancer.id)
    freelancer_messages = freelancer.messages.where(receivable_id: company.id)
    (company_messages + freelancer_messages).sort_by(&:created_at)
  end
end
