module StripeTool
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



  def self.get_plans
    stripe_list = Stripe::Plan.all
    stripe_list[:data]
  end

  def self.create_bank_account
  end

  def self.connect
  end
end
