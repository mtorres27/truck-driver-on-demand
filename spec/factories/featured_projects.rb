# frozen_string_literal: true

# == Schema Information
#
# Table name: featured_projects
#
#  id         :bigint           not null, primary key
#  company_id :integer
#  name       :string
#  file       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  file_data  :string
#

FactoryBot.define do
  factory :featured_project do
  end
end
