module StripeTool
  CANADA_SALES_TAX = 0.13

  def self.update_company_info_with_subscription(company: company, customer: customer, subscription: subscription, plan: plan)
    company.billing_period_ends_at    = Time.at(subscription.current_period_end).to_datetime
    company.stripe_customer_id        = customer.id
    company.stripe_subscription_id    = subscription.id
    company.stripe_plan_id            = subscription.plan.id
    company.plan_id                   = plan[:id]
    company.subscription_cycle        = subscription.plan.interval
    company.subscription_status       = subscription.status
    company.is_subscription_cancelled = false
    company.is_trial_applicable       = false if plan[:trial_period].positive?
    if customer.sources.data.any?
      company.last_4_digits             = customer.sources.data[0].last4
      company.card_brand                = customer.sources.data[0].brand
      company.exp_month                 = customer.sources.data[0].exp_month
      company.exp_year                  = customer.sources.data[0].exp_year
    end
    company.save
    # subscription
    Subscription.where(company_id: company.id).update_all(is_active: false)
    company_subscription = Subscription.new
    company_subscription.company_id = company.id
    company_subscription.plan_id = plan.id
    company_subscription.description = "Subscription to #{plan.name} plan."
    company_subscription.stripe_subscription_id = subscription.id
    company_subscription.is_active = true
    company_subscription.ends_at = company.billing_period_ends_at
    company_subscription.amount = plan.subscription_fee
    company_subscription.tax = plan.subscription_fee * CANADA_SALES_TAX if company.canada_country?
    company_subscription.save

  end

  def self.update_company_card_info(company: company, last_4_digits: last_4_digits, card_brand: card_brand, exp_month: exp_month, exp_year: exp_year)
    company.last_4_digits             = last_4_digits
    company.card_brand                = card_brand
    company.exp_month                 = exp_month
    company.exp_year                  = exp_year
    company.save
  end

  def self.updown_subscription()

  end

  def self.create_customer(email: email, stripe_token: stripe_token)
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

  def self.create_charge(customer_id: customer_id, amount: amount, description: description)
    Stripe::Charge.create(
      customer: customer_id,
      amount: amount,
      description: description,
      currency: 'usd'
    )
  end

  def self.subscribe(customer: customer, tax: tax, plan: plan, is_new: is_new)
    customer.subscriptions.create(
      plan: plan[:code],
      trial_period_days: (is_new) ? plan[:trial_period] : 0,
      tax_percent: tax
    )
  end

  def self.get_plans
    stripe_list = Stripe::Plan.all
    stripe_list[:data]
  end

  def self.get_invoices(customer: customer)
    stripe_list = Stripe::Invoice.list(customer: customer)
    stripe_list[:data]
  end

  def self.get_invoice(invoice: invoice)
    Stripe::Invoice.retrieve(invoice)
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
    # Rails.logger.debug period_end
    self.cancel(subscription: subscription, period_end: period_end)
    if subscription.plan.amount > 0
      self.refund_customer(
        company: company,
        old_exp: company.billing_period_ends_at.to_time.to_i
        )
    end
    company.billing_period_ends_at = Time.at(period_end).to_date
    company.plan_id = nil
    company.subscription_status = "cancelled"
    company.save
  end

  def self.get_stripe_plan (id: id)
    Stripe::Plan.retrieve(id)
  end

  private

    def self.get_cancel_period_end(subscription: subscription)
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

    def self.cancel(subscription: subscription, period_end: period_end)
      cancel_at_period_end = subscription.status == 'past_due' ? false : true
      if subscription.status == 'trialing' || subscription.plan.amount > 0
        subscription.trial_end = period_end
        subscription.prorate = false
        subscription.save
      end
      subscription.delete(
        at_period_end: cancel_at_period_end
      )
    end

    def self.refund_customer(company: company, old_exp: old_exp)
      # calculate months
      professional_plan = Stripe::Plan.retrieve('avj_professional')
      no_of_month = ((old_exp - Time.now.to_time.to_i)/1.month.second).to_i
      amount = no_of_month * professional_plan[:amount] / 12
      amount += amount * CANADA_SALES_TAX if company.canada_country?
      # generate the refund
      if amount > 0
        charge = Stripe::Charge.create(
          amount: amount.round,
          currency:  'usd',
          customer: company.stripe_customer_id,
          description: 'Refund for unused period in the professional plan.'
        )
        Stripe::Refund.create(
          charge: charge.id
        )
        company_subscription = Subscription.where(['company_id = ?', company.id]).order("created_at DESC").first()
        if company_subscription.present?
          company_subscription.refund = amount/100
          company_subscription.is_active = false
          company_subscription.save
        end
      end
    end
end
