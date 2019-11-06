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

describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:phone_number) }
  end

  describe "#name_initials" do
    subject { create(:user, first_name: "John", last_name: "Doe").name_initials }

    it { is_expected.to eq("JD") }
  end

  describe "#full_name" do
    subject { build(:user, first_name: "Jane", last_name: "Doe").full_name }

    it { is_expected.to eq("Jane Doe") }
  end

  describe "#first_name_and_initial" do
    subject { build(:user, first_name: "Jane", last_name: "Doe").first_name_and_initial }

    it { is_expected.to eq("Jane D") }
  end
end
