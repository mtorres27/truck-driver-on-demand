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
#  has_quote       :boolean          default(FALSE)
#  quote_id        :integer
#  lat             :decimal(9, 6)
#  lng             :decimal(9, 6)
#

FactoryBot.define do
  factory :message do
    job nil
    authorable nil
    body "MyText"
    attachment_data "MyText"
  end
end
