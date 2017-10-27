
class WebhooksController < Freelancer::BaseController
  skip_before_action :verify_authenticity_token
  def stripe
    # If the request has a 'user_id' key, then this is a webhook
    # event sent regarding a connected user, and not to a webhook
    # handler setup on the application owner's account.
    # So, use the user_id to look up a connected user on our end.
    freelancer = params[:freelancer_id] && Freelancer.find_by( stripe_account_id: params[:freelancer_id] )

    args = [params[:id], nil].compact # freelancer.try(:secret_key)

    begin
      event = Stripe::Event.retrieve( *args )
    rescue Stripe::InvalidRequestError
      render nothing: true, status: 200
      return
    rescue Stripe::AuthenticationError
      # If we get an authentication error, and the event belongs to
      # a user, that means the account deauthorized
      # our application. We can't look up and verify the event
      # because the event belongs to the connected account, and we're
      # no longer authorized to access their account!
      if freelancer && freelancer.connected?
        connector = StripeConnect.new( freelancer )
        connector.deauthorized
      end

      render nothing: true, status: 200
      return
    end

    # Here we're actually done, but if you wanted to handle
    # other events (charges or invoice payment failures, etc)
    # then this is how you would do it.
    case event.try(:type)

    when 'account.updated'
      # This webhook is used for standalone and managed
      # accounts. It will notify you about new information
      # required for the account to remain in good standing.
      if user && user.connected?
        # we don't actually need to pass the event here
        # we'll request the account details directly inside
        # the manager
        user.manager.update_account!
      end

    #   https://stripe.com/docs/api#event_types
    when 'charge.succeeded'
      Rails.logger.info "**** STRIPE EVENT **** #{event.type} **** #{event.id}"
    when 'invoice.payment_succeeded'
      Rails.logger.info "**** STRIPE EVENT **** #{event.type} **** #{event.id}"
    when 'invoice.payment_failed'
      Rails.logger.info "**** STRIPE EVENT **** #{event.type} **** #{event.id}"

    end

    render nothing: true, status: 200
  end
end
