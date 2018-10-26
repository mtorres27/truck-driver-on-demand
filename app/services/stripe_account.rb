class StripeAccount < Struct.new( :freelancer )
  COUNTRIES = [
    { name: 'Australia', code: 'AU', bank: ['BSB', 'Account Number'] },
    { name: 'Austria', code: 'AT', bank: ['IBAN'] },
    { name: 'Belgium', code: 'BE', bank: ['IBAN'] },
    { name: 'Canada', code: 'CA', bank: ['Transit Number', 'Institution Number', 'Account Number'] },
    { name: 'Denmark', code: 'DK', bank: ['IBAN'] },
    { name: 'Finland', code: 'FI', bank: ['IBAN'] },
    { name: 'France', code: 'FR', bank: ['IBAN'] },
    { name: 'Germany', code: 'DE', bank: ['IBAN'] },
    { name: 'Hong Kong', code: 'HK', bank: ['Clearing Code', 'Branch Code', 'Account Number'] },
    { name: 'Ireland', code: 'IE', bank: ['IBAN'] },
    { name: 'Italy', code: 'IT', bank: ['IBAN'] },
    { name: 'Japan', code: 'JP', bank: ['Bank Name', 'Branch Name', 'Bank Code', 'Branch Code', 'Account Number', 'Account Owner Name'] },
    { name: 'Luxembourg', code: 'LU', bank: ['IBAN'] },
    { name: 'Netherlands', code: 'NL', bank: ['IBAN'] },
    { name: 'New Zealand', code: 'NZ', bank: ['Routing Number', 'Account Number'] },
    { name: 'Norway', code: 'NO', bank: ['IBAN'] },
    { name: 'Portugal', code: 'PT', bank: ['IBAN'] },
    { name: 'Singapore', code: 'SG', bank: ['Bank Code', 'Branch Code', 'Account Number'] },
    { name: 'Spain', code: 'ES', bank: ['IBAN'] },
    { name: 'Sweden', code: 'SE', bank: ['IBAN'] },
    { name: 'Switzerland', code: 'CH', bank: ['IBAN'] },
    { name: 'United Kingdom', code: 'GB', bank: ['Sort Code', 'Account Number'] },
    { name: 'United States', code: 'US', bank: ['Routing Number', 'Account Number'] },
  ]

  def create_account!( type, country, tos_accepted, ip )
    return nil unless tos_accepted
    return nil unless country.upcase.in?(COUNTRIES.map { |c| c[:code] })

    begin
      @account = Stripe::Account.create(
        type: 'custom',
        country: country,
        email: freelancer.email,
        tos_acceptance: {
          ip: ip,
          date: Time.now.to_i
        },
        legal_entity: {
          type: type,
        },
        payout_schedule: {
          delay_days: 7,
          interval: 'daily'
        }
      )
    rescue StandardError => ex
      Rails.logger.debug 'WHAT!!!!' # TODO: improve
      Rails.logger.debug ex.inspect
    end

    if @account
      freelancer.freelancer_profile.update_attributes(
        currency: @account.default_currency,
        stripe_account_id: @account.id,
        stripe_account_status: account_status(@account)
      )
    end

    @account
  end

  def update_account!(params: nil)
    if params
      if params[:legal_entity]
        begin
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
          account.payout_schedule.interval = 'manual'
          account.save
          return [account, { success: 'true' }]
        rescue StandardError => ex
          Rails.logger.debug ex.inspect
          return [nil, { error: 'Sorry, No Data returned. Message: ssssss' }]
        end
      end
    end

    freelancer.freelancer_profile.update_attributes(
      stripe_account_status: account_status
    )
  end

  def add_bank_account(token)
    account = Stripe::Account.retrieve(freelancer.freelancer_profile.stripe_account_id)
    account.external_accounts.create(external_account: token)
  end

  def needs?(field)
    freelancer.freelancer_profile.stripe_account_status['fields_needed'].grep(Regexp.new(/#{field}/i)).any?
  end

  def account_status(account)
    {
      details_submitted: account.details_submitted,
      charges_enabled: account.charges_enabled,
      fields_needed: account.verification.fields_needed,
      due_by: account.verification.due_by
    }
  end

  def account
    freelancer.freelancer_profile.stripe_account_id ? Stripe::Account.retrieve(freelancer.freelancer_profile.stripe_account_id) : nil
  end

  def legal_entity
    account.legal_entity
  end

  def country
    COUNTRIES.find { |hash| hash[:code] == freelancer.freelancer_profile.country.upcase }
  end

  def verified?
    return false if freelancer.freelancer_profile.stripe_account_id.nil? || freelancer.freelancer_profile.stripe_account_id.empty?
    account = Stripe::Account.retrieve(freelancer.freelancer_profile.stripe_account_id)
    account.legal_entity.verification.status == 'verified'
  end
end
