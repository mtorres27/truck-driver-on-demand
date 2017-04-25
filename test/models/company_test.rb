# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  tagline    :string
#  address    :string
#  logo_data  :text
#  disabled   :boolean          default("false"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CompanyTest < ActiveSupport::TestCase

  test "sign up with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with google" do
    auth_hash = Faker::Omniauth.unique.google.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with facebook" do
    auth_hash = Faker::Omniauth.unique.facebook.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

  test "sign up with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys
    company = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal auth_hash.dig(:info, :email)&.downcase, company.email
    assert_equal auth_hash.dig(:info, :name), company.name
  end

  test "sign in with linkedin" do
    auth_hash = Faker::Omniauth.unique.linkedin.deep_symbolize_keys

    existing = create(:company, email: auth_hash.dig(:info, :email)&.downcase)
    signed_in = Company.find_or_create_from_auth_hash(auth_hash)

    assert_equal existing.email, signed_in.email
  end

end
