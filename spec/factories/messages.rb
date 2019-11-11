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

FactoryBot.define do
  factory :message do
    job { nil }
    authorable { nil }
    body { "MyText" }
    attachment_data { "MyText" }
  end
end
