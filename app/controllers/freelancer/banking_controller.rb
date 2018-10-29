class Freelancer::BankingController < Freelancer::BaseController
  DOC_TYPES = ['image/jpeg', 'image/jpg', 'image/png']
  def index
    authorize current_user
    @connector = StripeAccount.new(current_user)
    # logger.debug @connector.account.inspect
  end

  def identity
    authorize current_user
    @country_spec = Stripe::CountrySpec.retrieve(current_user.freelancer_profile.country)
    @post_data = flash[:data]
    flash.delete(:data)
  end

  def connect
    authorize current_user
    logger.debug current_user.inspect
    @post_data ||= {}
    type = params[:account][:type]
    @post_data['type'] = type
    if flash[:error].nil? || flash[:error].empty?
      flash[:error] = 'Please fill all the fields' if params[:account][type][:legal_entity][:verification].nil? || params[:account][type][:legal_entity][:verification][:document].nil?
      params[:account][type][:legal_entity].each do |key, value|
        if [ :address, :dob, :personal_address, :verification ].include? key.to_sym
          value.each do |akey, avalue|
            flash[:error] = 'Please fill all the fields' if avalue.nil?
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
      connector = StripeAccount.new(current_user)
      if current_user.freelancer_profile.stripe_account_id.blank?
        account = connector.create_account!(
          type, current_user.freelancer_profile.country, params[:tos] == 'on', request.remote_ip
        )
      else
        account = connector.account
      end

      if account
        account_info, result = prepare_info(account, params[:account][type])
        flash[:error] = "Unable to create  account! #{result[:error]}" if result[:error]
        flash[:notice] = 'Your account is Updated! ' unless result[:error]
      else
        flash[:error] = 'Unable to create Stripe account! '
      end
    end
    redirect_to freelancer_profile_stripe_banking_info_path if flash[:error].nil?
    redirect_to freelancer_profile_stripe_banking_path, flash: {data: @post_data} unless flash[:error].nil?
  end

  def prepare_info(account, params)
    return unless params[:legal_entity]
    begin
      authorize current_user
      params[:legal_entity].each do |key, value|
        if [ :address, :dob, :personal_address, :verification ].include? key.to_sym
          value.each do |akey, avalue|
            next if avalue.blank?
            if akey['document']
              file_ext = File.extname(avalue.original_filename)
              filename = Digest::SHA1.hexdigest(Time.now.to_s)
              file_path = Rails.root.join('public', 'uploads/stripe', filename+file_ext)
              File.open(file_path, 'wb') do |file|
                file.write(avalue.read)
              end
              unless `file --b --mime-type #{file_path}`.strip.in?(DOC_TYPES)
                raise StandardError.new(" Wrong file type, accepted file types are [#{DOC_TYPES.join(", ")}]")
              end
              stripe_upload = stripe_upload(filename+file_ext)
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
    authorize current_user
    Stripe::FileUpload.create(
      purpose: 'identity_document',
      file: File.new(Rails.root.join('public', 'uploads/stripe', filename))
    )
  end

  def bank_account
    authorize current_user
    redirect_to freelancer_profile_stripe_banking_info_path if current_user.freelancer_profile.stripe_account_id.blank?
    @country_spec = Stripe::CountrySpec.retrieve(current_user.freelancer_profile.country)
    @connector = StripeAccount.new(current_user)
  end

  def add_bank_account
    authorize current_user
    btok = params[:bank][:btok]
    if btok.nil? || btok.empty?
      flash[:error] = 'Something wrong happened, please try again!'
      redirect_to freelancer_profile_stripe_bank_account_path
    else
      connector = StripeAccount.new(current_user)
      connector.add_bank_account(btok)
      flash[:notice] = 'Your bank account has been added to your account...'
      redirect_to freelancer_profile_stripe_banking_info_path
    end
  end
end
