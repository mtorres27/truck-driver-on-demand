require 'rails_helper'

describe User, type: :model do
  describe "hooks" do
    describe "after_save" do
      context "when freelancer confirms their email" do
        let(:email) { Faker::Internet.unique.email }
        let!(:invite) { create(:friend_invite, email: email, name: 'Example', freelancer: inviter) }
        let(:freelancer) { create(:freelancer, user: build(:user, email: email)) }

        before(:each) do
          allow(FreelancerMailer).to receive(:notice_credit_earned).and_return(double('Mailer', deliver_later: true))
        end

        describe "add_credit_to_inviters" do
          let(:inviter) { create(:freelancer, avj_credit: nil) }

          it "sets friend invite to accepted" do
            freelancer.user.confirm
            expect(inviter.friend_invites.last).to be_accepted
          end

          it "sends an email to the inviter" do
            expect(FreelancerMailer).to receive(:notice_credit_earned)
            freelancer.user.confirm
          end

          context "when inviter has nil avj_credit" do
            let(:inviter) { create(:freelancer, avj_credit: nil) }

            it "sets avj credit of inviter to 20" do
              freelancer.user.confirm
              inviter.reload
              expect(inviter.avj_credit).to eq(20)
            end
          end

          context "when inviter has not nil avj_credit" do
            context "when inviter avj credit + 20 is less than 200" do
              let(:inviter) { create(:freelancer, avj_credit: 50) }

              it "adds 50 to the current avj credit of the inviter" do
                freelancer.user.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(70)
              end
            end

            context "when inviter avj credit + 20 is greater than 200" do
              let(:inviter) { create(:freelancer, avj_credit: 190) }

              it "sets avj credit of the inviter to 400" do
                freelancer.user.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(200)
              end
            end

            context "when inviter avj_credit is already 200" do
              let(:inviter) { create(:freelancer, avj_credit: 200) }

              it "does not change freelancers avj credit" do
                freelancer.user.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(200)
              end

              it "does not send the FreelancerMailer.notice_credit_earned mail" do
                expect(FreelancerMailer).not_to receive(:notice_credit_earned)
                freelancer.user.confirm
              end
            end
          end
        end
      end
    end
  end
end