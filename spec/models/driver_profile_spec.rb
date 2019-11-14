# frozen_string_literal: true

# == Schema Information
#
# Table name: driver_profiles
#
#  id                     :bigint           not null, primary key
#  token                  :string
#  avatar_data            :text
#  tagline                :string
#  bio                    :text
#  years_of_experience    :integer          default(0), not null
#  profile_views          :integer          default(0), not null
#  available              :boolean          default(TRUE), not null
#  disabled               :boolean          default(TRUE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  driver_reviews_count   :integer          default(0), not null
#  verified               :boolean          default(FALSE)
#  driver_type            :string
#  postal_code            :string
#  service_areas          :string
#  city                   :string
#  profile_score          :integer
#  registration_step      :string
#  driver_id              :integer
#  requested_verification :boolean          default(FALSE)
#  license_class          :string
#  province               :string
#  transmission_and_speed :citext
#  freight_type           :citext
#  other_skills           :citext
#  vehicle_type           :citext
#  truck_type             :citext
#  trailer_type           :citext
#

require "rails_helper"

describe DriverProfile, type: :model do
  describe "hooks" do
    describe "set_default_step" do
      let(:driver_profile) { create(:driver_profile) }
      it "sets default step to personal" do
        expect(driver_profile.registration_step).to eq("personal")
      end
    end

    describe "after update" do
      let(:driver_profile) { create(:driver_profile, driver: create(:driver)) }
      let(:params) { { registration_step: "wicked_finish" } }

      context "when registration is completed" do
        it "calls send_welcome_email" do
          expect(driver_profile).to receive(:send_welcome_email)
          driver_profile.update(params)
        end
      end

      context "when the driver is not confirmed" do
        it "sends the confirmation mail" do
          expect { driver_profile.update(params) }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context "when the driver is confirmed" do
        it "does not send the confirmation mail" do
          driver_profile.driver.confirm
          expect { driver_profile.update(params) }.to change(ActionMailer::Base.deliveries, :count).by(0)
        end
      end
    end
  end
end