# == Schema Information
#
# Table name: companies
#
#  id                        :integer          not null, primary key
#  token                     :string
#  name                      :string
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
#  header_color              :string           default("FF6C38")
#  country                   :string
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
#  header_source             :string           default("default")
#  sales_tax_number          :string
#  line2                     :string
#  city                      :string
#  state                     :string
#  postal_code               :string
#  job_types                 :citext
#  manufacturer_tags         :citext
#  plan_id                   :integer
#  is_trial_applicable       :boolean          default(TRUE)
#  waived_jobs               :integer          default(0)
#  registration_step         :string
#  saved_freelancers_ids     :citext
#
# Indexes
#
#  index_companies_on_disabled              (disabled)
#  index_companies_on_job_markets           (job_markets)
#  index_companies_on_manufacturer_tags     (manufacturer_tags)
#  index_companies_on_name                  (name)
#  index_companies_on_plan_id               (plan_id)
#  index_companies_on_technical_skill_tags  (technical_skill_tags)
#  index_on_companies_loc                   (st_geographyfromtext((((('SRID=4326;POINT('::text || lng) || ' '::text) || lat) || ')'::text)))
#
# Foreign Keys
#
#  fk_rails_...  (plan_id => plans.id)
#

require 'rails_helper'

describe Company, type: :model do
  describe "hooks" do
    describe "after save" do
      describe "add_to_hubspot" do
        before { allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true) }

        context "when registration is completed and profile form is filled" do
          it "creates or update a hubspot contact" do
            expect(Hubspot::Contact).to receive(:createOrUpdate)
            create(:company, name: "Acme", registration_step: 'wicked_finish' )
          end
        end

        context "when registration is not completed" do
          it "does not creates or update a hubspot contact" do
            expect(Hubspot::Contact).not_to receive(:createOrUpdate)
            create(:company, name: "Acme", registration_step: 'job_info' )
          end
        end
      end

      describe "send_confirmation_email" do
        let(:company) { create(:company) }
        let(:company_params) { { registration_step: "wicked_finish" } }

        context "when registration is completed" do
          it "calls send_confirmation_email" do
            expect(company).to receive(:send_confirmation_email)
            company.update(company_params)
          end
        end

        context "when the company user is confirmed" do
          it "does not send the confirmation mail" do
            company.owner.confirm
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
