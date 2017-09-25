class Company::ChargesController < Company::BaseController
  before_action :amount_to_be_charged, :set_description

  def plans
    @plans = StripeTool.get_plans
  end

  def subscription_checkout
    logger
    subscription = StripeTool.subscribe(email: params[:stripeEmail], plan_id: params[:plan_id], stripe_token: params[:stripeToken])

    flash[:notice] = "Successfully created a charge"
    redirect_to company_plans_path
  end


  def new

  end

  def thanks

  end

  def create

    # Amount in cents
    customer = StripeTool.create_customer(email: params[:stripeEmail],
                                          stripe_token: params[:stripeToken])

    charge = StripeTool.create_charge(customer_id: customer.id,
                                      amount: @amount,
                                      description: @description)
  redirect_to company_thanks_path
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_company_charge
  end

  private

    def amount_to_be_charged
      @amount = 15000
    end

    def set_description
      @description = "AVJunction Monthly Subscription"
    end
end
