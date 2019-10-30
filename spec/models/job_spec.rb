# frozen_string_literal: true

# == Schema Information
#
# Table name: jobs
#
#  id                   :integer          not null, primary key
#  company_id           :integer          not null
#  title                :string
#  state                :string           default("created"), not null
#  summary              :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  address              :string
#  lat                  :decimal(9, 6)
#  lng                  :decimal(9, 6)
#  formatted_address    :string
#  country              :string
#  job_markets          :citext
#  manufacturer_tags    :citext
#  state_province       :string
#  technical_skill_tags :text
#
# Indexes
#
#  index_jobs_on_company_id         (company_id)
#  index_jobs_on_manufacturer_tags  (manufacturer_tags)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#

require "rails_helper"

describe Job, type: :model do
  describe "validations" do
    context "when published" do
      subject { build(:job, state: "published") }
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:address) }
      it { is_expected.to validate_presence_of(:country) }
    end
  end

  describe "city_state_country" do
    let(:company) { create(:company) }
    let(:job) { build(:job, state_province: "ON", address: "Toronto", country: "ca", company: company) }

    it "returns location with state" do
      expect(job.city_state_country).to eq("Toronto, Ontario, CA")
    end
  end
end
