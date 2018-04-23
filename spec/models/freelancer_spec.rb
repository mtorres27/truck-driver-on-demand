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

describe Freelancer, type: :model do
  context 'triggers' do
    describe 'friend invites after creation' do
      let(:freelancer_one) { create(:freelancer, avj_credit: nil) }
      let(:freelancer_two) { create(:freelancer, avj_credit: nil) }
      let(:email) { Faker::Internet.unique.email }

      before(:each) do
        FriendInvite.create!(email: email, name: 'Example', freelancer: freelancer_one)
        FriendInvite.create!(email: email, name: 'Example', freelancer: freelancer_two)
      end

      it 'adds credit after creation if has been invited' do
        freelancer = create(:freelancer, email: email)
        expect(freelancer.avj_credit).to eq(20)
        expect(freelancer_one.friend_invites.last.accepted).to be_truthy
        freelancer_one.reload
        expect(freelancer_one.avj_credit).to eq(50)
        expect(freelancer_two.friend_invites.last.accepted).to be_truthy
        freelancer_two.reload
        expect(freelancer_two.avj_credit).to eq(50)
      end
    end
  end
end
