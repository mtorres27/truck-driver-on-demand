require 'rails_helper'

describe Freelancer::ContractsController, type: :controller  do
  describe 'GET accept' do
    login_freelancer
    let(:freelancer) { subject.current_user }
    let(:company) { create :company, plan: create(:plan) }
    let(:job) { create(:job,
                       project: create(:project, company: company),
                       company: company,
                       address: 'Toronto',
                       state_province: 'ON',
                       country: 'ca',
                       applicable_sales_tax: 13,
                       company_plan_fees: 9,
                       currency: 'cad' ) }
    let!(:applicant) { create :applicant, company: company, job: job, freelancer: freelancer, state: "quoting" }

    it 'sets the job state to contracted' do
      get :accept, params: { id: job.id }
      expect(job.reload.state).to eq('contracted')
    end

    it 'sets job contracted_at' do
      get :accept, params: { id: job.id }
      expect(job.reload.contracted_at).to be_present
    end

    it 'sets job company_plan_fees' do
      get :accept, params: { id: job.id }
      expect(job.reload.contracted_at).to be_present
    end

    it 'sends emails to company and freelancer' do
      expect { get :accept, params: { id: job.id } }.to change { ActionMailer::Base.deliveries.count }.by(2)
    end

    it 'sends notification to company' do
      expect { get :accept, params: { id: job.id } }.to change { Notification.count }.by(1)
    end

  end
end
