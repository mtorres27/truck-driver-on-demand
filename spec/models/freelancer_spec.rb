# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  first_name             :string
#  last_name              :string
#  type                   :string
#  messages_count         :integer          default(0), not null
#  company_id             :integer
#  role                   :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#
# Indexes
#
#  index_users_on_company_id                         (company_id)
#  index_users_on_confirmation_token                 (confirmation_token) UNIQUE
#  index_users_on_email                              (email) UNIQUE
#  index_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_users_on_invitations_count                  (invitations_count)
#  index_users_on_invited_by_id                      (invited_by_id)
#  index_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_users_on_reset_password_token               (reset_password_token) UNIQUE
#

require 'rails_helper'

describe Freelancer, type: :model do
  describe "hooks" do
    describe "before validation" do
      describe "initialize_freelancer_profile" do
        context "when freelancer has a profile" do
          let!(:profile) { create(:freelancer_profile) }

          it "does not create a profile" do
            expect do
              create(:freelancer, freelancer_profile: profile)
            end.not_to change(FreelancerProfile, :count)
          end
        end

        context "when freelancer does not have a profile" do
          it "creates a profile" do
            expect { create(:freelancer) }.to change(FreelancerProfile, :count).by(1)
          end
        end
      end
    end

    describe "after create" do
      describe "check_for_invites" do
        let(:inviter) { create(:freelancer) }
        let(:email) { Faker::Internet.unique.email }
        let!(:invite) { create(:friend_invite, email: email, name: 'Example', freelancer: inviter) }
        let(:freelancer) { create(:freelancer, email: email) }

        it "adds 10 avj credit to invited freelancer" do
          expect(freelancer.freelancer_profile.avj_credit).to eq(10)
        end
      end
    end

    describe "after_save" do
      context "when freelancer confirms their email" do
        let(:email) { Faker::Internet.unique.email }
        let!(:invite) { create(:friend_invite, email: email, name: 'Example', freelancer: inviter) }
        let!(:freelancer) { create(:freelancer, email: email) }

        before(:each) do
          allow(FreelancerMailer).to receive(:notice_credit_earned).and_return(double('Mailer', deliver_later: true))
        end

        describe "add_credit_to_inviters" do
          let(:inviter) { create(:freelancer, freelancer_profile: create(:freelancer_profile, avj_credit: nil)) }

          it "sets friend invite to accepted" do
            freelancer.confirm
            expect(inviter.friend_invites.last).to be_accepted
          end

          it "sends an email to the inviter" do
            expect(FreelancerMailer).to receive(:notice_credit_earned)
            freelancer.confirm
          end

          context "when inviter has nil avj_credit" do
            let(:inviter) { create(:freelancer, freelancer_profile: create(:freelancer_profile, avj_credit: nil)) }

            it "sets avj credit of inviter to 20" do
              freelancer.confirm
              inviter.reload
              expect(inviter.freelancer_profile.avj_credit).to eq(20)
            end
          end

          context "when inviter has not nil avj_credit" do
            context "when inviter avj credit + 20 is less than 200" do
              let(:inviter) { create(:freelancer, freelancer_profile: create(:freelancer_profile, avj_credit: 50)) }

              it "adds 50 to the current avj credit of the inviter" do
                freelancer.confirm
                inviter.reload
                expect(inviter.freelancer_profile.avj_credit).to eq(70)
              end
            end

            context "when inviter avj credit + 20 is greater than 200" do
              let(:inviter) { create(:freelancer, freelancer_profile: create(:freelancer_profile, avj_credit: 190)) }

              it "sets avj credit of the inviter to 200" do
                freelancer.confirm
                inviter.reload
                expect(inviter.freelancer_profile.avj_credit).to eq(200)
              end
            end

            context "when inviter avj_credit is already 200" do
              let(:inviter) { create(:freelancer, freelancer_profile: create(:freelancer_profile, avj_credit: 200)) }

              it "does not change freelancers avj credit" do
                freelancer.confirm
                inviter.reload
                expect(inviter.freelancer_profile.avj_credit).to eq(200)
              end

              it "does not send the FreelancerMailer.notice_credit_earned mail" do
                expect(FreelancerMailer).not_to receive(:notice_credit_earned)
                freelancer.confirm
              end
            end
          end
        end
      end
    end
  end

  describe "#name_initials" do
    subject { create(:freelancer, first_name: "John", last_name: "Doe").name_initials }
    it { is_expected.to eq("JD") }
  end

  describe "#was_invited?" do
    context "when freelancer was not invited" do
      subject(:freelancer) { create(:freelancer) }
      it { is_expected.not_to be_was_invited }
    end

    context "when freelancer was invited" do
      let(:email) { Faker::Internet.unique.email }
      let!(:friend_invite) { create(:friend_invite, email: email, freelancer: create(:freelancer), accepted: true) }
      subject(:freelancer) { create(:freelancer, email: email) }

      it { is_expected.to be_was_invited }
    end
  end

  describe "#search" do
    let!(:freelancer_1) { create(:freelancer, last_name: "Doe") }
    let(:freelancer_2) { create(:freelancer) }
    let!(:profile) { create(:freelancer_profile, freelancer: freelancer_2, job_types: { system_integration: 1 }) }

    context "when searching by name (first_name or last_name)" do
      subject { described_class.search("Doe") }

      it { is_expected.to include(freelancer_1) }
      it { is_expected.not_to include(freelancer_2) }
    end

    context "when searching by job_types" do
      subject { described_class.search("system integration") }

      it { is_expected.to include(freelancer_2) }
      it { is_expected.not_to include(freelancer_1) }
    end

    context "when search does not match any criteria" do
      subject { described_class.search("acme") }

      it { is_expected.not_to include(freelancer_2) }
      it { is_expected.not_to include(freelancer_1) }
    end
  end

  describe "#name_or_email_search" do
    let!(:freelancer_1) { create(:freelancer, first_name: "Jane") }
    let!(:freelancer_2) { create(:freelancer, email: "john@doe.com") }

    context "when searching by name (first_name or last_name)" do
      subject { described_class.name_or_email_search("Jane") }

      it { is_expected.to include(freelancer_1) }
      it { is_expected.not_to include(freelancer_2) }
    end

    context "when searching by email" do
      subject { described_class.name_or_email_search("john@doe.com") }

      it { is_expected.to include(freelancer_2) }
      it { is_expected.not_to include(freelancer_1) }
    end

    context "when search does not match any criteria" do
      subject { described_class.name_or_email_search("system integration") }

      it { is_expected.not_to include(freelancer_1) }
      it { is_expected.not_to include(freelancer_2) }
    end
  end

end
