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

require 'rails_helper'

describe Job, type: :model do
  describe "validations" do
    context "when published" do
      subject { build(:job, creation_step: "wicked_finish", state: "published") }
      it { is_expected.to validate_presence_of(:job_function) }
      it { is_expected.to validate_presence_of(:freelancer_type) }
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_presence_of(:summary) }
      it { is_expected.to validate_presence_of(:address) }
      it { is_expected.to validate_presence_of(:currency) }
      it { is_expected.to validate_presence_of(:country) }
      it { is_expected.to validate_numericality_of(:duration).only_integer.is_greater_than_or_equal_to(1) }
    end
  end

  describe "triggers" do
    describe "accept_applicant" do
      let(:company) { create(:company) }
      let(:job) { build(:job,
                        state_province: 'ON',
                        address: 'Toronto',
                        country: 'ca',
                        company: company,
                        contract_price: 200,
                        pay_type: 'variable',
                        variable_pay_type: 'daily',
                        overtime_rate: 20,
                        payment_terms: 10,
                        creator: company.owner) }
      let!(:accepted_applicant) { create(:applicant, job: job, company: company, freelancer: create(:freelancer)) }
      let!(:declined_applicant) { create(:applicant, job: job, company: company, freelancer: create(:freelancer)) }

      it "sets the accepted applicant's state to accepted" do
        job.update(accepted_applicant_id: accepted_applicant.id, enforce_contract_creation: true)
        expect(accepted_applicant.reload.state).to eq('accepted')
      end

      it "sets the declined applicant's state to declined" do
        job.update(accepted_applicant_id: accepted_applicant.id, enforce_contract_creation: true)
        expect(declined_applicant.reload.state).to eq('declined')
      end

      it "sends an email to declined applicants" do
        expect { job.update(accepted_applicant_id: accepted_applicant.id, enforce_contract_creation: true) }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end

      it "sends a notification to declined applicants" do
        expect { job.update(accepted_applicant_id: accepted_applicant.id, enforce_contract_creation: true) }.to change(Notification, :count).by(1)
      end
    end
  end

  describe "city_state_country" do
    let(:company) { create(:company) }
    let(:job) { build(:job, state_province: 'ON', address: 'Toronto', country: 'ca', company: company) }

    it "returns location with state" do
      expect(job.city_state_country).to eq("Toronto, Ontario, CA")
    end
  end
end
