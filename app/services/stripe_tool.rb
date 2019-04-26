module StripeTool

  def self.updown_subscription()

  end

  def self.create_customer(email:, stripe_token:)
    if stripe_token.present?
      Stripe::Customer.create(
        email: email,
        source: stripe_token
      )
    else
      Stripe::Customer.create(
        email: email
      )
    end
  end

  def self.create_charge(customer_id:, amount:, description:)
    Stripe::Charge.create(
      customer: customer_id,
      amount: amount,
      description: description,
      currency: 'usd'
    )
  end

  def self.subscribe(customer:, tax:, plan:)
    customer.subscriptions.create(
      plan: plan[:code],
      tax_percent: tax,
      trial_from_plan: true
    )
  end

  def self.get_plans
    stripe_list = Stripe::Plan.all
    stripe_list[:data]
  end

  def self.get_invoices(customer:)
    stripe_list = Stripe::Invoice.list(customer: customer)
    stripe_list[:data]
  end

  def self.get_invoice(invoice:)
    Stripe::Invoice.retrieve(invoice)
  end

  def self.create_invoice(customer_id:, subscription:)
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

  def self.cancel_subscription(company:)
    company.is_subscription_cancelled = true
    subscription = Stripe::Subscription.retrieve(company.stripe_subscription_id)
    period_end = self.get_cancel_period_end(subscription: subscription)
    # Rails.logger.debug period_end
    trialing = subscription.status == "trialing"
    self.cancel(subscription: subscription)
    if subscription.plan.amount > 0 && !trialing
      self.refund_customer(
        company: company,
        old_exp: company.billing_period_ends_at.to_time.to_i,
        plan_code: company.plan.code,
        plan_period: company.plan.period
        )
    end
    company.billing_period_ends_at = Time.at(period_end).to_date
    company.plan_id = nil
    company.subscription_status = "cancelled"
    company.save(validate: false)
  end

  def self.get_stripe_plan(id:)
    Stripe::Plan.retrieve(id)
  end

  def self.get_trial_period_end(company:)
    return unless company.stripe_subscription_id.present?
    subscription = Stripe::Subscription.retrieve(company.stripe_subscription_id)
    return unless subscription['trial_start'].present?
    Time.at(subscription['trial_start']) + 15.days
  end

  private

  def self.get_cancel_period_end(subscription:)
    if (subscription.status == 'trialing' || subscription.plan.amount > 0) && Time.at(subscription.current_period_start).to_date != Date.today && (subscription.current_period_end - Time.now.to_i) / 86_400 > 31
      period_end = Time.at(subscription.current_period_end).to_date
      period_end = period_end >> -1 while period_end > Date.today
      return (period_end >> 1).to_time.to_i
    end
    if Time.at(subscription.current_period_start).to_date == Date.today
      return Date.today.next_month.to_time.to_i
    end
    return subscription.current_period_end
  end

  def self.cancel(subscription:)
    if subscription.status == 'trialing' || subscription.plan.amount > 0
      subscription.prorate = true
      subscription.save
    end
    subscription.delete
  end

  def self.refund_customer(company:, old_exp:, plan_code:, plan_period:)
    customer = Stripe::Customer.retrieve(company.stripe_customer_id)
    charge = customer.charges.first
    # calculate months
    plan = Stripe::Plan.retrieve(plan_code)
    no_of_days = ((old_exp - Time.now.to_time.to_i)/1.day.second).to_i
    amount = no_of_days * (plan[:amount] / (plan_period == "yearly" ? 365 : 30))
    amount += amount * (Subscription::CANADA_SALES_TAX_PERCENT/100) if company.canada_country?
    # generate the refund
    if amount > 0
      Stripe::Refund.create(
          charge: charge.id,
          amount: amount.to_i)
      company_subscription = Subscription.where(['company_id = ?', company.id]).order("created_at DESC").first()
      if company_subscription.present?
        company_subscription.refund = amount/100
        company_subscription.is_active = false
        company_subscription.save
      end
    end
  end
end
