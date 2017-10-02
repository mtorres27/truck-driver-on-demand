module StripeTool
  def self.update_company_info(company: company, customer: customer, subscription: subscription)
    company.billing_period_ends_at    = Time.at(subscription.current_period_end).to_datetime
    company.stripe_customer_id        = customer.id
    company.stripe_subscription_id    = subscription.id
    company.stripe_plan_id            = subscription.plan.id
    company.subscription_cycle        = subscription.plan.interval
    company.subscription_status       = subscription.status
    company.is_subscription_cancelled = false
    company.last_4_digits             = customer.sources.data[0].last4
    company.card_brand                = customer.sources.data[0].brand
    company.exp_month                 = customer.sources.data[0].exp_month
    company.exp_year                  = customer.sources.data[0].exp_year
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

  def self.subscribe(customer: customer, plan_id: plan_id, is_new: is_new, registered_from: registered_from)
    customer.subscriptions.create(
      plan: plan_id,
      trial_period_days: (90-registered_from > 0) ? 90-registered_from : 0
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

  def self.cancel_subscription(company: company)
    company.is_subscription_cancelled = true
    subscription = Stripe::Subscription.retrieve(company.stripe_subscription_id)
    period_end = self.get_cancel_period_end(subscription: subscription)
    if subscription.plan.interval == 'month'
      self.cancel_month(subscription: subscription, period_end: period_end)
    else
      self.cancel_year(subscription: subscription, period_end: period_end)
      self.refund_customer(customer: company.stripe_customer_id, old_exp: company.billing_period_ends_at.to_time.to_i, new_exp: period_end)
    end
    company.billing_period_ends_at = Time.at(period_end).to_date
    company.save
  end

  private

    def self.get_cancel_period_end(subscription: subscription)
      if (subscription.status == 'trialing' || subscription.plan.interval != 'month') && Time.at(subscription.current_period_start).to_date != Date.today && (subscription.current_period_end - Time.now.to_i) / 86_400 > 31
        period_end = Time.at(subscription.current_period_end).to_date
        period_end = period_end >> -1 while period_end >= Date.today
        return (period_end >> 1).to_time.to_i
      end
      if Time.at(subscription.current_period_start).to_date == Date.today
        return Date.today.next_month.to_time.to_i
      end
      return subscription.current_period_end
    end

    def self.cancel_month(subscription: subscription, period_end: period_end)
      if subscription.status == 'trialing'
        subscription.trial_end = period_end
        subscription.prorate = false
        subscription.save
      end
      subscription.delete(
        at_period_end: true
      )
    end

    def self.refund_customer(customer: customer, old_exp: old_exp, new_exp: new_exp)
      Rails.logger.debug old_exp
      Rails.logger.debug new_exp
      # calculate months
      monthly_plan = Stripe::Plan.retrieve("avj_monthly")
      no_of_month = ((old_exp - new_exp - 1.day.second)/1.month.second).to_i
      amount = no_of_month * monthly_plan.amount
      # generate the refund
      charge = Stripe::Charge.create(
        amount: amount,
        currency:  'usd',
        customer: customer,
        description: 'Refund for unused period in the annual plan.'
      )
      Stripe::Refund.create(
        charge: charge.id
      )
    end

    def self.cancel_year(subscription: subscription, period_end: period_end)
      subscription.trial_end = period_end
      subscription.prorate = false
      subscription.save

      subscription.delete(
        at_period_end: false
      )
      # Refund the rest of period
    end
end
