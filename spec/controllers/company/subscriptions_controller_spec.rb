require 'rails_helper'

describe Company::SubscriptionController, type: :controller  do
  login_company
  let(:company) { subject.current_user.company }

  describe 'GET plans' do
    context 'when canadian company' do
      before(:each) do
        company.update_attribute(:country, 'ca')
      end

      it 'redirects to profile edit if no state' do
        company.update_attribute(:state, nil)
        get :plans
        expect(response).to redirect_to(edit_company_profile_path)
      end

      it 'responds with 200 when state exists' do
        company.update_attribute(:state, 'ON')
        get :plans
        expect(response.status).to eq(200)
      end
    end

    it 'assigns the existing plans to @plans' do
      create_list(:plan, 3)
      get :plans
      expect(assigns(:plans).count).to eq(4)
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
      create(:subscription, company_id: company.id)
    end

    it 'assigns @subscriptions' do
      get :invoices
      expect(assigns(:subscriptions).count).to eq(1)
    end
  end

  describe 'GET invoice' do
    context 'when invoice belongs to company' do
      let!(:subscription) { create(:subscription, company_id: company.id) }

      it 'assigns @subscription' do
        get :invoice, params: { invoice: subscription.id }
        expect(assigns(:subscription)).to eq(subscription)
      end
    end

    context 'when invoice does not belong to company' do
      let(:other_company) { create(:company) }
      let!(:subscription) { create(:subscription, company_id: other_company.id) }

      before(:each) do
        get :invoice, params: { invoice: subscription.id }
      end

      it 'be a 401 Unauthorized' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST subscription_checkout' do
    let(:plan) { create(:plan) }
    let(:customer) { double('Customer', id: 1) }
    let(:subscription) { double('Subscription', id: 1, current_period_end: Date.today, plan: plan) }

    before(:each) do
      company.update_columns(plan_id: nil)
      allow(StripeTool).to receive(:create_customer).and_return(customer)
      allow(StripeTool).to receive(:subscribe).and_return(subscription)
      allow(StripeTool).to receive(:update_company_info_with_subscription).and_return(true)
    end

    it 'subscribes the company to the specified plan' do
      expect(StripeTool).to receive(:create_customer).with(email: company.email, stripe_token: 'token').once
      expect(StripeTool).to receive(:subscribe).with(customer: customer, tax: 0, plan: plan, trial_period: company.trial_days_available).once
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
