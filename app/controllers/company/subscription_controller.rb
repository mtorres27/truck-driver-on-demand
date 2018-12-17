class Company::SubscriptionController < Company::BaseController
  include TaxHelper

  before_action :amount_to_be_charged, :set_description
  protect_from_forgery except: :webhook

  def cancel
    authorize current_company, :cancel_subscription?

    plan = current_company.plan
    StripeTool.cancel_subscription(company: current_company)
    SubscriptionMailer.notice_company_subscription_canceled(current_company, plan).deliver_later
    current_company.disable_all_users
    flash[:notice] = "You just cancelled your company subscription!"
    redirect_to company_plans_path
  end

  def invoices
    authorize current_company
    current_company.check_for_new_invoices
    @subscriptions = current_company.subscriptions.order('created_at DESC')
  end

  def invoice
    # raise exception if company is not the invoice owner
    @subscription = Subscription.find(params[:invoice])
    authorize @subscription
    if @subscription.nil? || @subscription.company_id != current_company.id
      flash[:error] = "You can't see this invoice!"
      redirect_to company_invoices_path
    end
  end

  def plans
    authorize current_company
    # redirect to profile edit if no province canadian company
    if current_company.canada_country? && current_company.state.nil?
      flash[:notice] = 'You must update your profile with the province!'
      redirect_to edit_company_profile_path
    end

    if current_company.canada_country?
      @plans = Plan.where(is_canadian: true)
    else
      @plans = Plan.where(is_canadian: false)
    end

    begin
      @subscription = Stripe::Subscription.retrieve(current_company.stripe_subscription_id) if current_company.stripe_subscription_id.present?
    rescue Stripe::InvalidRequestError => ex
      flash[:alert] = 'Please subscribe to one of the following plans'
    rescue Exception => ex
      flash[:error] = 'Something wrong happened!'
    end

  end

  def reset_company
    authorize current_company

    current_company.created_at                = 3.months.ago - 5.day
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
    current_company.plan_id                   = nil
    current_company.is_subscription_cancelled = true
    current_company.save
    flash[:notice] = "Your just reset your company Successfully"
    redirect_to company_plans_path
  end

  def update_card_info
    authorize current_company

    if params[:stripeToken]
      customer = Stripe::Customer.retrieve(current_company.stripe_customer_id)
      customer.source = params[:stripeToken]
      customer.save
      StripeTool.update_company_card_info(company: current_company,
                                          last_4_digits: customer.sources.data[0].last4,
                                          card_brand: customer.sources.data[0].brand,
                                          exp_month: customer.sources.data[0].exp_month,
                                          exp_year: customer.sources.data[0].exp_year)
    end
    flash[:notice] = 'Successfully updated your card. '
    redirect_to company_plans_path
  end

  def subscription_checkout
    authorize current_company

    plan = Plan.find_by(code: params[:plan_id])

    if current_company.stripe_customer_id.present?
      customer = Stripe::Customer.retrieve(current_company.stripe_customer_id)
    else
      customer = StripeTool.create_customer(email: params[:stripeEmail], stripe_token: params[:stripeToken])
    end

    subscription = StripeTool.subscribe(customer: customer,
                                        tax: current_company.canada_country? ? Subscription::CANADA_SALES_TAX_PERCENT : 0,
                                        plan: plan
                                        )
    StripeTool.update_company_info_with_subscription(company: current_company, customer: customer, subscription: subscription, plan: plan)

    SubscriptionMailer.notice_company_subscribed_to_plan(current_company, plan).deliver_later
    flash[:notice] = 'Successfully subscribed to "' + subscription.plan.nickname.upcase + '" Plan'
    redirect_to company_plans_path
  end

  def webhook
    begin
      authorize current_company
      event_json = JSON.parse(request.body.read)
      event_object = event_json['data']['object']
      case event_json['type']
        when 'invoice.payment_succeeded'
          handle_success_invoice event_object
        when 'invoice.payment_failed'
          handle_failure_invoice event_object
        when 'charge.failed'
          handle_failure_charge event_object
        when 'customer.subscription.deleted'
          # fully delete the sub
        when 'customer.subscription.updated'
      end
    rescue Exception => ex
      render :json => {:status => 422, :error => "Webhook call failed"}
      return
    end
    render :json => {:status => 200}
  end

  def new
    authorize current_company
  end

  def thanks
    authorize current_company
  end

  def create
    authorize current_company
    begin
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
  end

  private

  def amount_to_be_charged
    @amount = 15000
  end

  def set_description
    @description = "AVJunction Monthly Subscription"
  end

  def unsubscribed_redirect?
    false
  end
end
