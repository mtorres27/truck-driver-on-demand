# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  email                     :citext           not null
#  name                      :string           not null
#  contact_name              :string           not null
#  address                   :string
#  formatted_address         :string
#  area                      :string
#  lat                       :decimal(9, 6)
#  lng                       :decimal(9, 6)
#  hq_country                :string
#  description               :string
#  avatar_data               :text
#  disabled                  :boolean          default(TRUE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  messages_count            :integer          default(0), not null
#  company_reviews_count     :integer          default(0), not null
#  profile_header_data       :text
#  contract_preference       :string           default(NULL)
#  job_markets               :citext
#  technical_skill_tags      :citext
#  profile_views             :integer          default(0), not null
#  website                   :string
#  phone_number              :string
#  number_of_offices         :integer          default(0)
#  number_of_employees       :string
#  established_in            :integer
#  encrypted_password        :string           default(""), not null
#  reset_password_token      :string
#  reset_password_sent_at    :datetime
#  remember_created_at       :datetime
#  sign_in_count             :integer          default(0), not null
#  current_sign_in_at        :datetime
#  last_sign_in_at           :datetime
#  current_sign_in_ip        :inet
#  last_sign_in_ip           :inet
#  stripe_customer_id        :string
#  stripe_subscription_id    :string
#  stripe_plan_id            :string
#  subscription_cycle        :string
#  is_subscription_cancelled :boolean          default(FALSE)
#  subscription_status       :string
#  billing_period_ends_at    :datetime
#  last_4_digits             :string
#  card_brand                :string
#  exp_month                 :string
#  exp_year                  :string
#  header_color              :string           default("FF6C38")
#  country                   :string
#  confirmation_token        :string
#  confirmed_at              :datetime
#  confirmation_sent_at      :datetime
#  header_source             :string           default("color")
#  province                  :string
#  sales_tax_number          :string
#  line2                     :string
#  city                      :string
#  state                     :string
#  postal_code               :string
#  job_types                 :citext
#  manufacturer_tags         :citext
#  plan_id                   :integer
#  is_trial_applicable       :boolean          default(TRUE)
#  waived_jobs               :integer          default(1)
#

require 'rails_helper'

describe Company, type: :model do
  describe "hooks" do
    describe "before save" do
      describe "set_name" do
        let(:company) { build(:company, first_name: "Jane", last_name: "Doe", registration_step: "job_info")}

        it "sets the full name" do
          expect(company.contact_name).to be_nil
          company.save
          expect(company.contact_name).to eq("Jane Doe")
        end
      end
    end

    describe "after save" do
      describe "add_to_hubspot" do
        before { allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true) }

        context "when registration is completed and profile form is filled" do
          it "creates or update a hubspot contact" do
            expect(Hubspot::Contact).to receive(:createOrUpdate).with(
              "test@test.com",
              company: "Acme",
              firstname: "John",
              lastname: "Doe",
              lifecyclestage: "customer",
              im_an: "AV Company",
            )
            create(:company, registration_step: 'wicked_finish', email: "test@test.com", contact_name: "John Doe", name: "Acme")
          end
        end

        context "when registration is not completed" do
          it "does not creates or update a hubspot contact" do
            expect(Hubspot::Contact).not_to receive(:createOrUpdate)
            create(:company, registration_step: 'job_info', email: "test@test.com", contact_name: "John Doe", name: "Acme")
          end
        end
      end

      describe "send_confirmation_email" do
        let(:company) { create(:company) }
        let(:company_params) {
          {
            registration_step: "wicked_finish"
          }
        }
        context "when registration is completed" do
          it "calls send_confirmation_email" do
            expect(company).to receive(:send_confirmation_email)
            company.update(company_params)
          end
        end

        context "when the company is not confirmed" do
          it "sends the confirmation mail" do
            expect { company.update(company_params) }.to change(ActionMailer::Base.deliveries, :count).by(1)
          end
        end

        context "when the company is confirmed" do
          it "does not send the confirmation mail" do
            company.confirm
            expect { company.update(company_params) }.to change(ActionMailer::Base.deliveries, :count).by(0)
          end
        end
      end
    end

    describe "before create" do
      describe "set_default_step" do
        it "sets default step to personal" do
          company = create(:company)
          expect(company.registration_step).to eq("personal")
        end
      end
    end
  end

  describe "validations" do
    describe "step personal information" do
      subject { create(:company, registration_step: "job_info") }

      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:country) }
      it { is_expected.to validate_presence_of(:city) }
    end

    describe "step job_info" do
      subject { create(:company, registration_step: "profile") }

      it { is_expected.to validate_presence_of(:job_types) }
    end

    describe "#registration_completed" do

      context "when registration step is wicked_finish" do
        subject { create(:company, registration_step: "wicked_finish") }

        it { is_expected.to be_registration_completed }
      end

      context "when registration step is personal" do
        subject { create(:company, registration_step: "personal") }

        it { is_expected.not_to be_registration_completed }
      end
    end
  end
end
