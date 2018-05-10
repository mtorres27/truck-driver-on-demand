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

require 'rails_helper'

describe FriendInvite, type: :model do
  context 'validations' do
    let(:freelancer) { create(:freelancer) }
    let(:email) { Faker::Internet.unique.email }

    it 'is not valid when more than five invites sent to same email' do
      freelancers = create_list(:freelancer, 5)
      freelancers.each do |f|
        create(:friend_invite, email: email, name: 'Example', freelancer: f)
      end
      expect(FriendInvite.new(email: email, name: 'Example', freelancer: freelancer)).to_not be_valid
    end

    it 'is not valid when freelancer has already invited same email' do
      FriendInvite.create!(email: email, name: 'Example', freelancer: freelancer)
      expect(build(:friend_invite, email: email, name: 'Example', freelancer: freelancer)).to_not be_valid
    end

    it 'is not valid when email has + operator' do
      expect(build(:friend_invite, email: 'example+1@example.com', name: 'Example', freelancer: freelancer)).to_not be_valid
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
