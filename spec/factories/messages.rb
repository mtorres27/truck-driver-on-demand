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

FactoryBot.define do
  factory :message do
    job nil
    authorable nil
    body "MyText"
    attachment_data "MyText"
  end
end
