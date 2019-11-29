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
#  login_code             :string
#  city                   :string
#

require "rails_helper"

describe CompanyUser, type: :model do
  describe "validations" do
    it { is_expected.to validate_acceptance_of(:accept_terms_of_service) }
    it { is_expected.to validate_acceptance_of(:accept_privacy_policy) }
    it { is_expected.to validate_acceptance_of(:accept_code_of_conduct) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:company) }
  end

  describe "before_validation" do
    describe "initialize_company" do
      context "when company user does not have a company" do
        it "creates a new company" do
          expect { create(:company_user, company: nil) }.to change(Company, :count).by(1)
        end
      end

      context "when company user has a company" do
        let(:company) { create(:company) }

        it "does not create a new company" do
          expect { create(:company_user, company: company) }.to change(Company, :count)
        end
      end
    end
  end
end
