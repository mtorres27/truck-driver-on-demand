class Freelancer::BankingController < Freelancer::BaseController
  DOC_TYPES = ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf']
  def index
    @connector = StripeAccount.new(current_freelancer)
    logger.debug @connector.account.inspect
    # logger.debug 321
  end

  def identity
    @country_spec = Stripe::CountrySpec.retrieve(current_freelancer.country)
    @post_data = flash[:data]
    flash.delete(:data)
  end

  def connect
    logger.debug current_freelancer.inspect
    @post_data ||= {}
    type = params[:account][:type]
    @post_data['type'] = type
    if flash[:error].nil? || flash[:error].empty?
      params[:account][type][:legal_entity].each do |key, value|
        if [ :address, :dob, :personal_address, :verification ].include? key.to_sym
          value.each do |akey, avalue|
            flash[:error] = 'Please fill all the fields' if avalue.nil? || (!akey['document'] && avalue.empty?)
            @post_data['legal_entity.'+key+'.'+akey] ||= {}
            @post_data['legal_entity.'+key+'.'+akey] = avalue unless akey['document']
          end
        else
          flash[:error] = 'Please fill all the fields' if value.nil? || value.empty?
          @post_data['legal_entity.'+key] ||= {}
          @post_data['legal_entity.'+key] = value unless key['document']
        end
      end
    end

    flash[:error] = 'Please Accept the terms' unless params.has_key?(:tos)

    if flash[:error].nil? || flash[:error].empty?
      connector = StripeAccount.new(current_freelancer)
      if current_freelancer.stripe_account_id.nil?
        account = connector.create_account!(
          type, current_freelancer.country, params[:tos] == 'on', request.remote_ip
        )
      else
        account = connector.account
      end
      if account
        account_info, result = prepare_info(account, params[:account][type])
        flash[:error] = "Unable to create  account!#{result[:error]}" if result[:error]
        flash[:notice] = 'Your account is Updated!' unless result[:error]
      else
        flash[:error] = 'Unable to create Stripe account!'
      end
    end
    redirect_to freelancer_profile_stripe_banking_info_path if flash[:error].nil?
    redirect_to freelancer_profile_stripe_banking_path, flash: {data: @post_data} unless flash[:error].nil?
  end

  def prepare_info(account, params)
    return unless params[:legal_entity]
    begin
      params[:legal_entity].each do |key, value|
        if [ :address, :dob, :personal_address, :verification ].include? key.to_sym
          value.each do |akey, avalue|
            next if avalue.blank?
            if akey['document']
              filename = Digest::SHA1.hexdigest(Time.now.to_s)
              file_path = Rails.root.join('public', 'uploads/stripe', filename)
              File.open(file_path, 'wb') do |file|
                file.write(avalue.read)
              end
              unless `file --b --mime-type #{file_path}`.strip.in?(DOC_TYPES)
                raise StandardError.new("Wrong file type, accepted file types are [#{DOC_TYPES.join(", ")}]")
              end
              stripe_upload = stripe_upload(filename)
              account.legal_entity[key] ||= {}
              account.legal_entity[key][akey] = stripe_upload.id
            else
              account.legal_entity[key] ||= {}
              account.legal_entity[key][akey] = avalue
            end
          end
        else
          next if value.blank? || key == 'verification'
          account.legal_entity[key] = value
        end
      end
      account.save
      return [account, { success: 'true' }]
    rescue StandardError => ex
      Rails.logger.debug ex.inspect
      return [nil, { error: ex }]
    end
  end

  def stripe_upload(filename)
    Stripe::FileUpload.create(
      purpose: 'identity_document',
      file: File.new(Rails.root.join('public', 'uploads/stripe', filename))
    )
  end

  def bank_account
    redirect_to freelancer_profile_stripe_banking_info_path if !current_freelancer.stripe_account_id
    @country_spec = Stripe::CountrySpec.retrieve(current_freelancer.country)
    @connector = StripeAccount.new(current_freelancer)
  end

  def add_bank_account
    btok = params[:bank][:btok]
    if btok.nil? || btok.empty?
      flash[:error] = 'Something wrong happened, please try again!'
      redirect_to freelancer_profile_stripe_bank_account_path
    else
      connector = StripeAccount.new(current_freelancer)
      connector.add_bank_account(btok)
      flash[:notice] = 'Your bank account has been added to your account...'
      redirect_to freelancer_profile_stripe_banking_info_path
    end
  end
end
