module StripeTool
  def self.update_company_info(company: company, customer: customer, subscription: subscription)
    period = subscription.plan.interval == "month" ? 1.month : 1.year
    company.expires_at = (company.expires_at && company.expires_at > Date.today ? company.expires_at : Date.today) + period
    company.stripe_customer_id = customer.id
    company.is_active = true
    company.last_4_digits = customer.sources.data[0].last4
    company.card_brand = customer.sources.data[0].brand
    company.exp_month = customer.sources.data[0].exp_month
    company.exp_year = customer.sources.data[0].exp_year
    company.save
  end

  def self.create_customer(email: email, stripe_token: stripe_token)
    Stripe::Customer.create(
      email: email,
      source: stripe_token
    )
  end

  def self.create_charge(customer_id: customer_id, amount: amount, description: description)
    Stripe::Charge.create(
      customer: customer_id,
      amount: amount,
      description: description,
      currency: 'usd'
    )
  end

  def self.subscribe(customer: customer, plan_id: plan_id, is_new: is_new)
    customer.subscriptions.create(
      plan: plan_id,
      trial_period_days: is_new ? 90 : 0
    )
  end

  def self.get_plans
    stripe_list = Stripe::Plan.all
    stripe_list[:data]
  end

  def self.create_invoice(customer_id: customer_id, subscription: subscription)
    invoice_item = Stripe::InvoiceItem.create(
      customer: customer_id,
      amount: subscription.plan.amount,
      currency: "usd",
      description: subscription.plan.name,
    )
    invoice = Stripe::Invoice.create(
      customer: customer_id
    )
    # invoice.pay
  end

  def self.connect
  end
end
