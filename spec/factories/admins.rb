# == Schema Information
#
# Table name: admins
#
#  id         :integer          not null, primary key
#  token      :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :admin do
    name { Faker::Name.unique.name }
  end
end
