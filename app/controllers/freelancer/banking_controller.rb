class Freelancer::BankingController < Freelancer::BaseController
  def index
    @country_spec = Stripe::CountrySpec.retrieve(current_freelancer.country)
    # logger.debug @country_spec
    logger.debug current_freelancer.stripe_account_status.inspect
  end

  def connect
    empty_val = 0

    unless params.has_key?(:tos)
      empty_val = 1
      flash[:error] = 'Please Accept the terms'
      redirect_back(fallback_location: 'default') && return
    end

    type = params[:account][:type]
    data = params[:account][type]
    params[:account][type].each do |key, value|
      if value.nil? || value.empty?
        empty_val += 1
        flash[:error] = 'Please fill all the fields'
      end
    end
    (redirect_back(fallback_location: 'default') && return) if empty_val.positive?

    connector = StripeAccount.new(current_freelancer)
    if current_freelancer.stripe_account_id.empty?
      account = connector.create_account!(
        type, current_freelancer.country, params[:tos] == 'on', request.remote_ip
      )
    else
      account = connector.account
    end
    if account
      account_info = prepare_info(account, params[:account][type])
      flash[:notice] = 'Custom Stripe account Updated!'
    else
      flash[:error] = 'Unable to create Stripe account!'
    end
    unless empty_val.zero?
      redirect_to freelancer_profile_stripe_banking_path
    end
  end

  def prepare_info(account, params)
    if params[:legal_entity]
      params[:legal_entity].each do |key, value|
        if [ :address, :dob, :personal_address ].include? key.to_sym
          value.each do |akey, avalue|
            next if avalue.blank?
            # Rails.logger.error "1-#{key}-#{akey} - #{avalue.inspect}"
            account.legal_entity[key] ||= {}
            account.legal_entity[key][akey] = avalue
          end
        else
          next if value.blank? || key == 'verification'
          # Rails.logger.error "2-#{key} - #{value.inspect}"
          account.legal_entity[key] = value
        end
      end
      account.save
    end
  end
end
