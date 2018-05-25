# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  token                    :string
#  name                     :string
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
#  messages_count           :integer          default(0), not null
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
#  job_types                :citext
#  job_functions            :citext
#  manufacturer_tags        :citext
#  special_avj_fees         :decimal(10, 2)
#  avj_credit               :decimal(10, 2)
#  registration_step        :string
#  province                 :string
#

require 'rails_helper'

describe Freelancer, type: :model do
  describe "methods" do
    describe "#was_invited?" do
      context "when freelancer was not invited" do
        subject(:freelancer) { create(:freelancer) }
        it { is_expected.not_to be_was_invited }
      end

      context "when freelancer was invited" do
        let(:email) { Faker::Internet.unique.email }
        let!(:friend_invite) { create(:friend_invite, email: email, freelancer: create(:freelancer), accepted: true) }
        subject(:freelancer) { create(:freelancer, user: build(:user, email: email)) }

        it { is_expected.to be_was_invited }
      end
    end
  end

  describe "hooks" do
    describe "after create" do
      describe "add_to_hubspot" do
        it "creates or update a hubspot contact" do
          allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true)
          expect(Hubspot::Contact).to receive(:createOrUpdate).with(
            "test@test.com",
            firstname: "John",
            lastname: "Doe",
            lifecyclestage: "customer",
            im_an: "AV Freelancer",
          )
          create(:freelancer, name: "John Doe", user: build(:user, email: "test@test.com"))
        end
      end

      describe "check_for_invites" do
        let(:inviter) { create(:freelancer) }
        let(:email) { Faker::Internet.unique.email }
        let!(:invite) { create(:friend_invite, email: email, name: 'Example', freelancer: inviter) }

        it "adds 10 avj credit to invited freelancer" do
          freelancer = create(:freelancer, user: build(:user, email: email))
          expect(freelancer.avj_credit).to eq(10)
        end
      end
    end
  end
end
