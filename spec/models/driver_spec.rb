# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
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
#  company_id             :bigint
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string
#  invited_by_id          :bigint
#  invitations_count      :integer          default(0)
#  phone_number           :string
#  role                   :string
#  enabled                :boolean          default(TRUE)
#

require "rails_helper"

describe Driver, type: :model do
  describe "hooks" do
    describe "before validation" do
      describe "initialize_driver_profile" do
        context "when driver has a profile" do
          let!(:profile) { create(:driver_profile) }

          it "does not create a profile" do
            expect do
              create(:driver, driver_profile: profile)
            end.not_to change(DriverProfile, :count)
          end
        end

        context "when driver does not have a profile" do
          it "creates a profile" do
            expect { create(:driver) }.to change(DriverProfile, :count).by(1)
          end
        end
      end
    end
  end

  describe "#name_initials" do
    subject { create(:driver, first_name: "John", last_name: "Doe").name_initials }
    it { is_expected.to eq("JD") }
  end

  describe "#search" do
    let!(:driver_1) { create(:driver, last_name: "Doe") }
    let(:driver_2) { create(:driver) }
    let!(:profile) { create(:driver_profile, driver: driver_2) }

    context "when searching by name (first_name or last_name)" do
      subject { described_class.search("Doe") }

      it { is_expected.to include(driver_1) }
      it { is_expected.not_to include(driver_2) }
    end

    context "when search does not match any criteria" do
      subject { described_class.search("acme") }

      it { is_expected.not_to include(driver_2) }
      it { is_expected.not_to include(driver_1) }
    end
  end

  describe "#name_or_email_search" do
    let!(:driver_1) { create(:driver, first_name: "Jane") }
    let!(:driver_2) { create(:driver, email: "john@doe.com") }

    context "when searching by name (first_name or last_name)" do
      subject { described_class.name_or_email_search("Jane") }

      it { is_expected.to include(driver_1) }
      it { is_expected.not_to include(driver_2) }
    end

    context "when searching by email" do
      subject { described_class.name_or_email_search("john@doe.com") }

      it { is_expected.to include(driver_2) }
      it { is_expected.not_to include(driver_1) }
    end

    context "when search does not match any criteria" do
      subject { described_class.name_or_email_search("system integration") }

      it { is_expected.not_to include(driver_1) }
      it { is_expected.not_to include(driver_2) }
    end
  end
end
