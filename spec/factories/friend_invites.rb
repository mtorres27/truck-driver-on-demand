# == Schema Information
#
# Table name: friend_invites
#
#  id            :integer          not null, primary key
#  email         :citext
#  name          :string
#  freelancer_id :integer
#  accepted      :boolean          default(FALSE)
#

FactoryBot.define do
  factory :friend_invite do
    email { Faker::Internet.unique.email }
    name { Faker::Name.unique.name }
  end
end
