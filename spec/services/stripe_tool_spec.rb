require 'rails_helper'
require './app/services/stripe_tool'

describe StripeTool do
  describe '.update_company_info_with_subscription' do
    let!(:company) { create(:company) }
    let(:plan) { double('Plan', id: 1, interval: 'interval', name: 'Name', subscription_fee: 10) }
    let(:subscription) { double('Subscription', id: 1, current_period_end: DateTime.now.to_i, status: 'status', plan: plan) }
    let(:card_data) { double('Card Data', any?: [1]) }
    let(:card_info) { double('Card Info', last4: '1234', brand: 'Brand', exp_month: '10', exp_year: '20', any?: [1]) }
    let(:sources) { double('Sources', data: card_data) }
    let(:customer) { double('Customer', id: 1, sources: sources) }

    before(:each) do
      allow(plan).to receive(:[]).with(:id).and_return(1)
      allow(plan).to receive(:[]).with(:trial_period).and_return(1)
      allow(card_data).to receive(:[]).with(0).and_return(card_info)
      allow_any_instance_of(Company).to receive(:save).and_return(true)
    end

    it "updates the company's data" do
      expect_any_instance_of(Company).to receive(:save).once
      StripeTool.update_company_info_with_subscription(company: company, customer: customer, subscription: subscription, plan: plan)
    end

    it "creates a new subscription" do
      expect {
        StripeTool.update_company_info_with_subscription(company: company, customer: customer, subscription: subscription, plan: plan) }
          .to change{ Subscription.count }.by(1)
    end
  end

  describe '.cancel_subscription' do
    let!(:company) { create(:company, billing_period_ends_at: DateTime.now) }
    let(:plan) { double('Plan', id: 1, name: 'Name', amount: 10) }
    let(:subscription) { double('Subscription', id: 1, current_period_start: DateTime.now.to_i, status: 'status', plan: plan) }

    before(:each) do
      allow(Stripe::Subscription).to receive(:retrieve).and_return(subscription)
      allow(StripeTool).to receive(:get_cancel_period_end).and_return(1)
      allow(StripeTool).to receive(:cancel).and_return(true)
      allow(StripeTool).to receive(:refund_customer).and_return(true)
      allow_any_instance_of(Company).to receive(:save).and_return(true)
    end

    it "updates the company's data" do
      expect_any_instance_of(Company).to receive(:save).once
      StripeTool.cancel_subscription(company: company)
    end
  end
end
