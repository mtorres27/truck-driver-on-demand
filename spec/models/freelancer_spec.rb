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
    describe "before save" do
      describe "set_name" do
        let(:freelancer) { build(:freelancer, first_name: "Jane", last_name: "Doe", registration_step: "job_info")}

        it "sets the full name" do
          expect(freelancer.name).to be_nil
          freelancer.save
          expect(freelancer.name).to eq("Jane Doe")
        end
      end

      describe "set_default_step" do
        it "sets default step to personal" do
          freelancer = create(:freelancer)
          expect(freelancer.registration_step).to eq("personal")
        end
      end
    end

    describe "after create" do
      describe "after update" do
        let(:freelancer) { create(:freelancer) }
        let(:freelancer_params) {
          {
            registration_step: "wicked_finish"
          }
        }
        context "when registration is completed" do
          it "calls send_welcome_email" do
            expect(freelancer).to receive(:send_welcome_email)
            freelancer.update(freelancer_params)
          end
        end

        context "when the freelancer is not confirmed" do
          it "sends the confirmation mail" do
            expect { freelancer.update(freelancer_params) }.to change(ActionMailer::Base.deliveries, :count).by(1)
          end
        end

        context "when the freelancer is confirmed" do
          it "does not send the confirmation mail" do
            freelancer.confirm
            expect { freelancer.update(freelancer_params) }.to change(ActionMailer::Base.deliveries, :count).by(0)
          end
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

    describe "after_save" do
      describe "add_to_hubspot" do
        before { allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true) }

        context "when registration is completed and profile form is filled" do
          it "creates or update a hubspot contact" do
            expect(Hubspot::Contact).to receive(:createOrUpdate).with(
              "test@test.com",
              firstname: "John",
              lastname: "Doe",
              lifecyclestage: "customer",
              im_an: "AV Freelancer",
            )
            create(:freelancer, registration_step: 'wicked_finish', email: "test@test.com", name: "John Doe")
          end
        end

        context "when registration is not completed" do
          it "does not creates or update a hubspot contact" do
            expect(Hubspot::Contact).not_to receive(:createOrUpdate)
            create(:freelancer, registration_step: 'job_info', email: "test@test.com", name: "John Doe", bio: nil)
          end
        end
      end

      context "when a freelancer completes all the steps" do
        let!(:freelancer) { create(:freelancer) }
        let(:freelancer_params) {
          {
            registration_step: "wicked_finish",
            bio: "my bio",
            tagline: "my tagline",
            avatar: fixture_file_upload(Rails.root.join("spec", "fixtures", "image.png"), "image/png")
          }
        }
        context "when registration is completed" do
          it "calls send_welcome_email" do
            expect(freelancer).to receive(:send_welcome_email)
            freelancer.update(freelancer_params)
          end
        end

        context "when the freelancer is not confirmed" do
          it "sends the confirmation mail" do
            expect { freelancer.update(freelancer_params) }.to change(ActionMailer::Base.deliveries, :count).by(1)
          end
        end

        context "when the freelancer is confirmed" do
          it "does not send the confirmation mail" do
            freelancer.confirm
            expect { freelancer.update(freelancer_params) }.to change(ActionMailer::Base.deliveries, :count).by(0)
          end
        end
      end

      context "when freelancer confirms their email" do
        let(:email) { Faker::Internet.unique.email }
        let!(:invite) { create(:friend_invite, email: email, name: 'Example', freelancer: inviter) }
        let!(:freelancer) { create(:freelancer, email: email) }

        before(:each) do
          allow(FreelancerMailer).to receive(:notice_credit_earned).and_return(double('Mailer', deliver_later: true))
        end

        describe "add_credit_to_inviters" do
          let(:inviter) { create(:freelancer, avj_credit: nil) }

          it "sets friend invite to accepted" do
            freelancer.confirm
            expect(inviter.friend_invites.last).to be_accepted
          end

          it "sends an email to the inviter" do
            expect(FreelancerMailer).to receive(:notice_credit_earned)
            freelancer.confirm
          end

          context "when inviter has nil avj_credit" do
            let(:inviter) { create(:freelancer, avj_credit: nil) }

            it "sets avj credit of inviter to 20" do
              freelancer.confirm
              inviter.reload
              expect(inviter.avj_credit).to eq(20)
            end
          end

          context "when inviter has not nil avj_credit" do
            context "when inviter avj credit + 20 is less than 200" do
              let(:inviter) { create(:freelancer, avj_credit: 50) }

              it "adds 50 to the current avj credit of the inviter" do
                freelancer.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(70)
              end
            end

            context "when inviter avj credit + 20 is greater than 200" do
              let(:inviter) { create(:freelancer, avj_credit: 190) }

              it "sets avj credit of the inviter to 200" do
                freelancer.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(200)
              end
            end

            context "when inviter avj_credit is already 200" do
              let(:inviter) { create(:freelancer, avj_credit: 200) }

              it "does not change freelancers avj credit" do
                freelancer.confirm
                inviter.reload
                expect(inviter.avj_credit).to eq(200)
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

  describe "validations" do
    describe "step personal information" do
      subject { create(:freelancer, registration_step: "job_info") }

      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:country) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe "step job_info" do
      subject { create(:freelancer, registration_step: "profile") }

      it { is_expected.to validate_presence_of(:job_types) }
    end

    describe "step profile" do
      subject { create(:freelancer, registration_step: "wicked_finish") }

      it { is_expected.to validate_presence_of(:bio) }
      it { is_expected.to validate_presence_of(:avatar) }
      it { is_expected.to validate_presence_of(:tagline) }
    end
  end

end
