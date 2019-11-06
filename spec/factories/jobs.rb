# frozen_string_literal: true

# == Schema Information
#
# Table name: jobs
#
#  id                   :bigint           not null, primary key
#  company_id           :bigint           not null
#  title                :string
#  state                :string           default("created"), not null
#  summary              :text
#  technical_skill_tags :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  address              :string
#  lat                  :decimal(9, 6)
#  lng                  :decimal(9, 6)
#  formatted_address    :string
#  country              :string
#  job_markets          :citext
#  manufacturer_tags    :citext
#  state_province       :string
#

FactoryBot.define do
  factory :job do
    title { "MyString" }
    summary { "MyText" }
    address { "Address" }
    country { "ca" }
  end
end
