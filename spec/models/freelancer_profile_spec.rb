# == Schema Information
#
# Table name: freelancer_profiles
#
#  id                       :integer          not null, primary key
#  token                    :string
#  avatar_data              :text
#  address                  :string
#  formatted_address        :string
#  area                     :string
#  lat                      :decimal(9, 6)
#  lng                      :decimal(9, 6)
#  pay_unit_time_preference :string
#  pay_per_unit_time        :string
#  tagline                  :string
#  bio                      :text
#  job_markets              :citext
#  years_of_experience      :integer          default(0), not null
#  profile_views            :integer          default(0), not null
#  projects_completed       :integer          default(0), not null
#  available                :boolean          default(TRUE), not null
#  disabled                 :boolean          default(TRUE), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  freelancer_reviews_count :integer          default(0), not null
#  technical_skill_tags     :citext
#  profile_header_data      :text
#  verified                 :boolean          default(FALSE)
#  header_color             :string           default("FF6C38")
#  country                  :string
#  freelancer_team_size     :string
#  freelancer_type          :string
#  header_source            :string           default("color")
#  stripe_account_id        :string
#  stripe_account_status    :text
#  currency                 :string
#  sales_tax_number         :string
#  line2                    :string
#  state                    :string
#  postal_code              :string
#  service_areas            :string
#  city                     :string
#  phone_number             :string
#  profile_score            :integer
#  valid_driver             :boolean
#  own_tools                :boolean
#  company_name             :string
#  special_avj_fees         :decimal(10, 2)
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#  avj_credit               :decimal(10, 2)
#  registration_step        :string
#  freelancer_id            :integer
#
# Indexes
#
#  index_freelancer_profiles_on_area                  (area)
#  index_freelancer_profiles_on_available             (available)
#  index_freelancer_profiles_on_disabled              (disabled)
#  index_freelancer_profiles_on_freelancer_id         (freelancer_id)
#  index_freelancer_profiles_on_job_functions         (job_functions)
#  index_freelancer_profiles_on_job_markets           (job_markets)
#  index_freelancer_profiles_on_manufacturer_tags     (manufacturer_tags)
#  index_freelancer_profiles_on_technical_skill_tags  (technical_skill_tags)
#  index_on_freelancer_profiles_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#  index_on_freelancers_loc                           (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#

require 'rails_helper'

describe FreelancerProfile, type: :model do
  describe "hooks" do
    describe "set_default_step" do
      let(:freelancer_profile) { create(:freelancer_profile) }
      it "sets default step to personal" do
        expect(freelancer_profile.registration_step).to eq("personal")
      end
    end

    describe "after update" do
      let(:freelancer_profile) { create(:freelancer_profile, freelancer: create(:freelancer)) }
      let(:params) { { registration_step: "wicked_finish" } }

      context "when registration is completed" do
        it "calls send_welcome_email" do
          expect(freelancer_profile).to receive(:send_welcome_email)
          freelancer_profile.update(params)
        end
      end

      context "when the freelancer is not confirmed" do
        it "sends the confirmation mail" do
          expect { freelancer_profile.update(params) }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context "when the freelancer is confirmed" do
        it "does not send the confirmation mail" do
          freelancer_profile.freelancer.confirm
          expect { freelancer_profile.update(params) }.to change(ActionMailer::Base.deliveries, :count).by(0)
        end
      end
    end

    describe "after_save" do
      describe "add_to_hubspot" do
        before { allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true) }

        context "when registration is completed and profile form is filled" do
          let(:freelancer) { create(:freelancer, email: "test@test.com", first_name: "John" , last_name: "Doe") }

          it "creates or update a hubspot contact" do
            expect(Hubspot::Contact).to receive(:createOrUpdate).with(
                "test@test.com",
                firstname: "John",
                lastname: "Doe",
                lifecyclestage: "customer",
                im_an: "AV Freelancer",
            )
            freelancer.freelancer_profile.update(registration_step: "wicked_finish")
          end
        end

        context "when registration is not completed" do
          it "does not creates or update a hubspot contact" do
            expect(Hubspot::Contact).not_to receive(:createOrUpdate)
            create(:freelancer_profile, registration_step: 'job_info', freelancer: create(:freelancer, email: "test@test.com", first_name: "John" , last_name: "Doe"))
          end
        end
      end
    end
  end

  describe "validations" do
    describe "step personal information" do
      subject { create(:freelancer_profile, registration_step: "job_info") }

      it { is_expected.to validate_presence_of(:country) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe "step job_info" do
      subject { create(:freelancer_profile, registration_step: "profile") }

      it { is_expected.to validate_presence_of(:job_types) }
    end

    describe "step profile" do
      subject { create(:freelancer_profile, registration_step: "wicked_finish", freelancer: create(:freelancer)) }

      it { is_expected.to validate_presence_of(:bio) }
      it { is_expected.to validate_presence_of(:avatar) }
      it { is_expected.to validate_presence_of(:tagline) }
    end
  end
end
