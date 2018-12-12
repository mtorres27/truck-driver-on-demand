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
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :integer
#  invitations_count      :integer          default(0)
#  enabled                :boolean          default(TRUE)
#  role                   :string
#  phone_number           :string
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
  end

  describe "#name_initials" do
    subject { create(:freelancer, first_name: "John", last_name: "Doe").name_initials }
    it { is_expected.to eq("JD") }
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
