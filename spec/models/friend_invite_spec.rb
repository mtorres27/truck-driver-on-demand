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

require 'rails_helper'

describe FriendInvite, type: :model do
  context 'validations' do
    let(:freelancer) { create(:freelancer) }
    let(:email) { Faker::Internet.unique.email }

    it 'is not valid when more than six invites sent to same email' do
      5.times do
        other_freelancer = create(:freelancer)
        FriendInvite.create!(email: email, name: 'Example', freelancer: other_freelancer)
      end
      expect(FriendInvite.new(email: email, name: 'Example', freelancer: freelancer)).to_not be_valid
    end

    it 'is not valid when freelancer has already invited same email' do
      FriendInvite.create!(email: email, name: 'Example', freelancer: freelancer)
      expect(FriendInvite.new(email: email, name: 'Example', freelancer: freelancer)).to_not be_valid
    end
  end
  context 'triggers' do
    let!(:freelancer) { create(:freelancer) }
    let(:email) { Faker::Internet.unique.email }

    it 'sends an invite email after creation' do
      expect { FriendInvite.create!(email: email, name: 'Example', freelancer: freelancer) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
