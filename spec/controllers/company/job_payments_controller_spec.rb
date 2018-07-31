require 'rails_helper'

describe Company::JobPaymentsController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }
  let(:job) { create(:job,
                     project: create(:project, company: company),
                     company: company,
                     address: 'Toronto',
                     state_province: 'ON',
                     country: 'ca',
                     applicable_sales_tax: 13,
                     company_plan_fees: 9 ) }
  let(:payment) { create :payment, job: job, company: company }
  let(:plan) { double("Plan") }

  describe 'GET #show' do

    before do
      allow(plan).to receive(:fee_schema).and_return({ 'company_fees' => 6 })
      allow(company).to receive(:plan).and_return(plan)
      get :show, params: { id: payment.id, job_id: job.id }
    end

    it 'defines @amount' do
      expect(assigns(:amount)).to be_present
    end

    it 'defines @tax' do
      expect(assigns(:tax)).to be_present
    end

    it 'defines @avj_fees' do
      expect(assigns(:avj_fees)).to be_present
    end

    it 'defines @avj_t_fees' do
      expect(assigns(:avj_t_fees)).to be_present
    end

    it 'defines @total' do
      expect(assigns(:total)).to be_present
    end
  end
end
