require 'rails_helper'

describe Company::ContractsController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job, project: create(:project, company: company), company: company, address: 'Toronto', state_province: 'ON', country: 'ca' ) }
  let(:freelancer) { create(:freelancer) }
  let!(:applicant) { create(:applicant, company: company, job: job, freelancer: freelancer) }

  describe "PUT #update" do
    let(:parameters) { { enforce_contract_creation: true,
                         accepted_applicant_id: applicant.id,
                         contract_price: 150,
                         payment_terms: 15,
                         overtime_rate: 20,
                         starts_on: Date.today,
                         pay_type: 'variable',
                         variable_pay_type: 'hourly',
                         applicable_sales_tax: 0.13 } }

    it "sends a message to the freelancer" do
      expect { put :update, params: { job_id: job.id, job: parameters } }.to change { Message.count }.by(1)
    end

    it "sends an email" do
      expect { put :update, params: { job_id: job.id, job: parameters } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "sets job.contract_sent to true" do
      put :update, params: { job_id: job.id, job: parameters }
      expect(job.reload.contract_sent).to be_truthy
    end

    it "redirects to company_job" do
      put :update, params: { job_id: job.id, job: parameters }
      expect(response).to redirect_to(company_job_path(job))
    end
  end
end
