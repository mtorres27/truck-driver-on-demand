# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  authorable_type :string           not null
#  authorable_id   :bigint           not null
#  receivable_type :string           not null
#  receivable_id   :bigint           not null
#  body            :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  checkin         :boolean          default(FALSE)
#  send_contract   :boolean          default(FALSE)
#  unread          :boolean          default(TRUE)
#  job_id          :bigint
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
    errors.add(:base, "A body or an attachment is required") if body.blank? && attachment_data.blank?
  end

  def send_email_notifications
    if authorable.is_a?(Company)
      Notification.create(title: authorable.name,
                          body: "You have a new message",
                          authorable: authorable,
                          receivable: receivable,
                          url: Rails.application.routes.url_helpers.driver_company_messages_url(authorable))
      DriverMailer.notice_message_received(authorable, receivable, self).deliver_later
    elsif authorable.is_a?(Driver)
      Notification.create(title: authorable.first_name_and_initial,
                          body: "You have a new message",
                          authorable: authorable,
                          receivable: receivable,
                          url: Rails.application.routes.url_helpers.company_driver_messages_url(authorable))
      CompanyMailer.notice_message_received(receivable.company_user, authorable, self).deliver_later
    end
  end

  def self.messages_for(company, driver)
    company_messages = company.messages.where(receivable_id: driver.id)
    driver_messages = driver.messages.where(receivable_id: company.id)
    (company_messages + driver_messages).sort_by(&:created_at)
  end

  def self.connections(load_dates = false)
    connections = []
    Company.find_each do |company|
      company.drivers_for_messaging.each do |driver|
        next if driver.nil?

        first_message = messages_for(company, driver).first if load_dates
        connections << { company_id: company.id, company_name: company.name,
                         driver_id: driver.id, driver_name: driver.full_name,
                         date_conected: first_message&.created_at }
      end
    end
    connections.sort_by { |connection| connection[:date_conected] }.reverse
  end

end
