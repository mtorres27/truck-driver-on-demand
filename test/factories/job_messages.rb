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

FactoryGirl.define do
  factory :job_message do
    job nil
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    authorable ""
    message "MyText"
    attachment_data "MyText"
  end
end
