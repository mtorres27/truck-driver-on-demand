require 'rails_helper'

describe Company::SubscriptionController, type: :controller  do
  login_company
  let(:company) { subject.current_company }

  describe 'GET plans' do
    context 'when canadian company' do
      before(:each) do
        company.update_attribute(:country, 'ca')
      end

      it 'redirects to profile edit if no province' do
        company.update_attribute(:province, nil)
        get :plans
        expect(response).to redirect_to(edit_company_profile_path)
      end

      it 'responds with 200 when province exists' do
        company.update_attribute(:province, 'ON')
        get :plans
        expect(response.status).to eq(200)
      end
    end

    it 'assigns the existing plans to @plans' do
      create_list(:plan, 3)
      get :plans
      expect(assigns(:plans).count).to eq(3)
    end

    context 'when subscribed to a plan' do
      before(:each) do
        company.update_attribute(:stripe_subscription_id, 'example_id')
        allow(Stripe::Subscription).to receive(:retrieve).and_return('something')
      end

      it 'assigns @subscription' do
        get :plans
        expect(assigns(:subscription)).to be_present
      end
    end

  end

  describe 'GET invoices' do
    before(:each) do
      invoice_1 = { date: Date.today, lines: { data: [ { amount: 100 } ] } }
      invoice_2 = { date: Date.today, lines: { data: [ { amount: 100 } ] } }
      allow(StripeTool).to receive(:get_invoices).and_return([invoice_1, invoice_2])
      allow(Stripe::Invoice).to receive(:upcoming).and_return(invoice_1)
    end

    it 'assigns @invoices and @upcoming' do
      get :invoices
      expect(assigns(:invoices).count).to eq(2)
      expect(assigns(:upcoming)).to be_present
    end
  end

  describe 'GET invoice' do
    let(:invoice) { { id: 1, date: Date.today, tax_percent: 0.1, tax: 10, total: 100,
                     lines: { data: [
                         { amount: 100, description: 'desc',
                           plan: { name: 'plan', interval: 'interval' },
                           period: { start: 'start', end: 'end' } } ] } } }
    before(:each) do
      allow(StripeTool).to receive(:get_invoice).and_return(invoice)
    end

    it 'assigns @invoice' do
      get :invoice, params: { invoice: 1 }
      expect(assigns(:invoice)).to eq(invoice)
    end
  end

  describe 'POST subscription_checkout' do
    let(:plan) { create(:plan) }
    let(:customer) { double('Customer', id: 1) }
    let(:subscription) { double('Subscription', id: 1, current_period_end: Date.today, plan: plan) }

    before(:each) do
      allow(StripeTool).to receive(:create_customer).and_return(customer)
      allow(StripeTool).to receive(:subscribe).and_return(subscription)
      allow(StripeTool).to receive(:update_company_info_with_subscription).and_return(true)
    end

    it 'subscribes the company to the specified plan' do
      expect(StripeTool).to receive(:create_customer).with(email: company.email, stripe_token: 'token').once
      expect(StripeTool).to receive(:subscribe).with(customer: customer, tax: 0, plan: plan, is_new: company.is_trial_applicable).once
      expect(StripeTool).to receive(:update_company_info_with_subscription).with(company: company, customer: customer, subscription: subscription, plan: plan).once
      post :subscription_checkout, params: { plan_id: plan.code, stripeEmail: company.email, stripeToken: 'token' }
    end

    it 'sends an email to the company' do
      expect { post :subscription_checkout, params: { plan_id: plan.code, stripeEmail: company.email, stripeToken: 'token' } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'displays a flash message' do
      post :subscription_checkout, params: { plan_id: plan.code, stripeEmail: company.email, stripeToken: 'token' }
      expect(flash[:notice]).to be_present
    end
    it 'redirects to company plans' do
      post :subscription_checkout, params: { plan_id: plan.code, stripeEmail: company.email, stripeToken: 'token' }
      expect(response).to redirect_to(company_plans_path)
    end
  end

  describe 'GET cancel' do
    let(:plan) { create(:plan) }

    before(:each) do
      company.update_attribute(:plan, plan)
      allow(StripeTool).to receive(:cancel_subscription).and_return(true)
    end

    it 'cancels the companies subscription' do
      expect(StripeTool).to receive(:cancel_subscription).with(company: company).once
      get :cancel
    end

    it 'sends an email to the company' do
      expect { get :cancel }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'displays a flash message' do
      get :cancel
      expect(flash[:notice]).to be_present
    end

    it 'redirects to company plans' do
      get :cancel
      expect(response).to redirect_to(company_plans_path)
    end
  end
end
