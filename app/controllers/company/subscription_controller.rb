class Company::SubscriptionController < Company::BaseController
  before_action :amount_to_be_charged, :set_description
  protect_from_forgery except: :webhook

  def cancel
    # logger.debug current_company.inspect
    StripeTool.cancel_subscription(company: current_company)
    redirect_to company_plans_path
  end

  def change_plan
    logger.debug current_company.inspect
    # StripeTool.cancel_subscription
  end

  def plans
    # logger.debug current_company.inspect
    @plans = StripeTool.get_plans
  end

  def reset_company
    current_company.created_at                = 3.months.ago-5.day #2.days.ago 3.months.ago-5.day
    current_company.billing_period_ends_at    = nil
    current_company.stripe_customer_id        = nil
    current_company.stripe_subscription_id    = nil
    current_company.stripe_plan_id            = nil
    current_company.subscription_cycle        = nil
    current_company.subscription_status       = nil
    current_company.is_subscription_cancelled = false
    current_company.last_4_digits             = nil
    current_company.card_brand                = nil
    current_company.exp_month                 = nil
    current_company.exp_year                  = nil
    current_company.save
    redirect_to company_plans_path
  end

  def subscription_checkout
    customer = StripeTool.create_customer(email: params[:stripeEmail],
                                          stripe_token: params[:stripeToken])
    subscription = StripeTool.subscribe(customer: customer,
                                        plan_id: params[:plan_id],
                                        is_new: current_company.stripe_customer_id ? false : true,
                                        registered_from: ((Time.now- current_company.created_at)/1.day).floor
                                        )
    # invoice = StripeTool.create_invoice(customer_id: customer.id, subscription: subscription)
    StripeTool.update_company_info(company: current_company, customer: customer, subscription: subscription)
    # logger.debug current_company.inspect
    # logger.debug customer.inspect
    logger.debug subscription.inspect
    flash[:notice] = "Successfully created a charge"
    redirect_to company_plans_path
  end

  def webhook
    begin
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      # Rails.logger.debug event_json.inspect
      case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'charge.failed'
          handle_failure_charge event_object
        when 'customer.subscription.deleted'
        when 'customer.subscription.updated'
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end
    render :json => {:status => 200}
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
