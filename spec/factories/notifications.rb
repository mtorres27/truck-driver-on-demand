# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  authorable_type :string           not null
#  authorable_id   :bigint           not null
#  receivable_type :string           not null
#  receivable_id   :bigint           not null
#  body            :text
#  title           :text
#  read_at         :datetime
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :notification do
    title { "Title" }
    body { "Body" }
    url { "www.example.com" }
  end
end
