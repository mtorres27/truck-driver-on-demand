# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  title      :string           not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_pages_on_slug  (slug)
#

FactoryBot.define do
  factory :page do
    slug { "MyString" }
    title { "MyString" }
    body { "MyText" }
  end
end
