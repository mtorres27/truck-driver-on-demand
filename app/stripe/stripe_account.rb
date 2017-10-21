class StripeAccount < Struct.new( :freelancer )
  ALLOWED = [ 'US', 'CA', 'FR' ]
  COUNTRIES = [
    { name: 'Austria', code: 'AT' },
    { name: 'Australia', code: 'AU' },
    { name: 'Belgium', code: 'BE' },
    { name: 'Canada', code: 'CA' },
    { name: 'Switzerland', code: 'CH' },
    { name: 'Germany', code: 'DE' },
    { name: 'Denmark', code: 'DK' },
    { name: 'Spain', code: 'ES' },
    { name: 'Finland', code: 'FI' },
    { name: 'France', code: 'FR' },
    { name: 'Hong Kong', code: 'HK' },
    { name: 'Italy', code: 'IT' },
    { name: 'Japan', code: 'JP' },
    { name: 'Luxembourg', code: 'LU' },
    { name: 'Netherlands', code: 'NL' },
    { name: 'Norway', code: 'NO' },
    { name: 'New Zealand', code: 'NZ' },
    { name: 'Portugal', code: 'PT' },
    { name: 'Sweden', code: 'SE' },
    { name: 'Singapore', code: 'SG' },
    { name: 'United Kingdom', code: 'GB' },
    { name: 'United States', code: 'US' },
    { name: 'Ireland', code: 'IE' }
  ]

  def create_account!( type, country, tos_accepted, ip )
    return nil unless tos_accepted
    return nil unless country.upcase.in?( COUNTRIES.map { |c| c[:code] } )

    begin
      @account = Stripe::Account.create(
        type: "custom",
        country: country,
        email: freelancer.email,
        tos_acceptance: {
          ip: ip,
          date: Time.now.to_i
        },
        legal_entity: {
          type: type,
        }
      )
    rescue StandardError => ex
      Rails.logger.debug "WHAT!!!!" # TODO: improve
      Rails.logger.debug ex.inspect
    end

    if @account
      freelancer.update_attributes(
        currency: @account.default_currency,
        stripe_account_id: @account.id,
        stripe_account_status: account_status
      )
    end

    @account
  end

  def update_account!(params: nil)
    if params
      if params[:legal_entity]
        # update legal_entity hash from the params
        params[:legal_entity].entries.each do |key, value|
          if [ :address, :dob, :personal_address ].include? key.to_sym
            value.entries.each do |akey, avalue|
              next if avalue.blank?
              # Rails.logger.error "#{akey} - #{avalue.inspect}"
              account.legal_entity[key] ||= {}
              account.legal_entity[key][akey] = avalue
            end
          else
            next if value.blank?
            # Rails.logger.error "#{key} - #{value.inspect}"
            account.legal_entity[key] = value
          end
        end
        account.save
      end
    end

    freelancer.update_attributes(
      stripe_account_status: account_status
    )
  end

  def needs?( field )
    freelancer.stripe_account_status['fields_needed'].grep( Regexp.new( /#{field}/i ) ).any?
  end

  def account_status
    {
      details_submitted: account.details_submitted,
      charges_enabled: account.charges_enabled,
      fields_needed: account.verification.fields_needed,
      due_by: account.verification.due_by
    }
  end

  def account
    @account ||= Stripe::Account.retrieve( freelancer.stripe_account_id )
  end

  def legal_entity
    account.legal_entity
  end
end
