# frozen_string_literal: true

# == Schema Information
#
# Table name: certifications
#
#  id               :integer          not null, primary key
#  freelancer_id    :integer
#  certificate      :text
#  name             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  thumbnail        :text
#  certificate_data :text
#  cert_type        :string
#

FactoryBot.define do
  factory :certification do
  end
end
