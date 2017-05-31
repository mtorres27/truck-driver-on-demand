# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  job_id          :integer          not null
#  authorable_type :string
#  authorable_id   :integer          not null
#  body            :text
#  attachment_data :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :message do
    job nil
    authorable nil
    body "MyText"
    attachment_data "MyText"
  end
end
