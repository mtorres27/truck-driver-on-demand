# == Schema Information
#
# Table name: freelancers
#
#  id                       :integer          not null, primary key
#  token                    :string
#  email                    :citext           not null
#  name                     :string           not null
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
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :inet
#  last_sign_in_ip          :inet
#  header_color             :string           default("FF6C38")
#  country                  :string
#  confirmation_token       :string
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
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
#

require 'rails_helper'

describe Freelancer, type: :model do
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
            im_am: "AV Freelancer",
          )
          create(:freelancer, email: "test@test.com", name: "John Doe")
        end
      end

      describe "check_for_invites" do
        let(:freelancer_one) { create(:freelancer, avj_credit: nil) }
        let(:freelancer_two) { create(:freelancer, avj_credit: nil) }
        let(:email) { Faker::Internet.unique.email }
        let!(:invite_1) { create(:friend_invite, email: email, name: 'Example', freelancer: freelancer_one) }
        let!(:invite_2) { create(:friend_invite, email: email, name: 'Example', freelancer: freelancer_two) }

        it "adds credit to invitation that matches the email" do
          freelancer = create(:freelancer, email: email)
          expect(freelancer.avj_credit).to eq(20)
          expect(freelancer_one.friend_invites.last).to be_accepted
          freelancer_one.reload
          expect(freelancer_one.avj_credit).to eq(50)
          expect(freelancer_two.friend_invites.last).to be_accepted
          freelancer_two.reload
          expect(freelancer_two.avj_credit).to eq(50)
        end
      end
    end
  end
end
