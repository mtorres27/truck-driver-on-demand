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
    describe "after create" do
      describe "add_to_hubspot" do
        it "creates or update a hubspot contact" do
          allow(Rails.application.secrets).to receive(:enabled_hubspot).and_return(true)
          expect(Hubspot::Contact).to receive(:createOrUpdate).with(
            "test@test.com",
            company: "Acme",
            firstname: "John",
            lastname: "Doe",
            lifecyclestage: "customer",
            im_an: "AV Company",
          )
          create(:company, contact_name: "John Doe", name: "Acme", user: build(:user, email: "test@test.com"))
        end
      end
    end
  end

  describe "city_state_country" do
    context "when state is missing" do
      let(:company) { create :company, state: nil, city: 'Toronto', country: 'ca' }

      it "returns location without state" do
        expect(company.city_state_country).to eq("Toronto, CA")
      end
    end
    context "when all is present" do
      let(:company) { create :company, state: 'Ontario', city: 'Toronto', country: 'ca' }

      it "returns location with state" do
        expect(company.city_state_country).to eq("Toronto, Ontario, CA")
      end
    end
  end
end
