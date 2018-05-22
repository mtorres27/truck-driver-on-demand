# == Schema Information
#
# Table name: friend_invites
#
#  id            :integer          not null, primary key
#  email         :citext           not null
#  name          :string           not null
#  freelancer_id :integer          not null
#  accepted      :boolean          default(FALSE)
#

FactoryBot.define do
  factory :friend_invite do
    email { Faker::Internet.unique.email }
    name { Faker::Name.unique.name }
  end
end
