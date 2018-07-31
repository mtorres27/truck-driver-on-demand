require 'rails_helper'

describe Freelancer::JobPaymentsController, type: :controller  do
  login_freelancer
  let(:freelancer) { subject.current_user }
  let(:company) { create :company }
  let(:job) { create(:job,
                     project: create(:project, company: company),
                     company: company,
                     address: 'Toronto',
                     state_province: 'ON',
                     country: 'ca',
                     applicable_sales_tax: 13,
                     company_plan_fees: 9,
                     currency: 'cad' ) }
  let!(:applicant) { create :applicant, company: company, job: job, freelancer: freelancer, state: "accepted" }

  describe 'GET #show' do
    let(:payment) { create :payment, job: job, company: company }
    let(:plan) { double("Plan") }

    before do
      allow(plan).to receive(:fee_schema).and_return({ 'freelancer_fees' => 4 })
      allow_any_instance_of(Company).to receive(:plan).and_return(plan)
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

  describe 'POST #create_payment' do
    let!(:currency_rate) { create :currency_rate, currency: 'cad' }

    it 'creates a payment' do
      expect{ post :create_payment, params: { job_id: job.id, payment: { description: 'Description', company_id: company.id, amount: 500 } } }.to change{ Payment.count }.by(1)
    end

    it 'sets the right attributes to the payment' do
      post :create_payment, params: { job_id: job.id, payment: { description: 'Description', company_id: company.id, amount: 500 } }
      payment = Payment.last
      expect(payment.issued_on).to eq(Date.today)
      expect(payment.tax_amount).to be_present
      expect(payment.total_amount).to be_present
      expect(payment.avj_fees).to be_present
      expect(payment.avj_credit).to be_present
    end
  end
end
