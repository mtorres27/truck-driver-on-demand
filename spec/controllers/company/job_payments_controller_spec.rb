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
                     company_plan_fees: 9,
                     currency: 'cad' ) }
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

  describe 'POST #mark_as_paid' do
    let!(:currency_rate) { create :currency_rate, currency: 'cad' }
    let(:freelancer) { create :freelancer }
    let!(:job_past_total_amount) { job.total_amount }

    before do
      allow(plan).to receive(:fee_schema).and_return({ 'company_fees' => 6, 'freelancer_fees' => 4 })
      allow_any_instance_of(Company).to receive(:plan).and_return(plan)
      allow_any_instance_of(Job).to receive(:freelancer).and_return(freelancer)
      allow(Stripe::Charge).to receive(:create).and_return({ id: 1, balance_transaction: 1 })
      allow(Stripe::BalanceTransaction).to receive(:retrieve).and_return({ status: 'status' })
      post :mark_as_paid, params: { id: payment.id, job_id: job.id }
      payment.reload
      job.reload
    end

    it 'defines fields on payment' do
      expect(payment.company_fees).to be_present
      expect(payment.total_company_fees).to be_present
      expect(payment.freelancer_fees).to be_present
      expect(payment.total_freelancer_fees).to be_present
      expect(payment.transaction_fees).to be_present
      expect(payment.total_amount).to be_present
      expect(payment.stripe_charge_id).to be_present
      expect(payment.stripe_balance_transaction_id).to be_present
      expect(payment.avj_credit).to be_present
      expect(payment.company_avj_fees_rate).to be_present
      expect(payment.freelancer_avj_fees_rate).to be_present
    end

    it 'marks payment as paid' do
      expect(payment.paid_on).to be_present
    end

    it 'updates the job total amount' do
      expect(job.total_amount).not_to eq(job_past_total_amount)
    end
  end
end
