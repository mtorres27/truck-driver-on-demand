class Company::ContractsController < Company::BaseController
  before_action :set_job

  def contract_pay
    begin
      quote = @job.accepted_quote
      freelancer = @job.freelancer
      payments = @job.payments

      amount = (quote.amount * (1 + (@job.applicable_sales_tax / 100)))
      stripe_fees = amount * 0.029 + 0.3
      platform_fees = ((quote.amount * Rails.configuration.avj_fees) - stripe_fees)
      # TODO: calculate taxes on app fees
      freelancer_amount = quote.amount * (1 - Rails.configuration.avj_fees)

      charge = Stripe::Charge.create({
        amount: (amount * 100).floor ,
        currency: @job.currency,
        source: params[:stripeToken],
        application_fee: (platform_fees * 100).floor
        }, stripe_account: freelancer.stripe_account_id)

      quote.avj_fees = quote.amount * Rails.configuration.avj_fees
      quote.stripe_fees = stripe_fees
      quote.net_avj_fees = platform_fees
      quote.tax_amount = (quote.amount * (@job.applicable_sales_tax / 100))
      quote.total_amount = amount
      quote.paid_by_company = true
      quote.paid_at = DateTime.now
      quote.platform_fees_amount = platform_fees
      quote.save

      payments.each do |payment|
        payment.avj_fees = payment.amount * Rails.configuration.avj_fees
        payment.tax_amount = (payment.amount * (@job.applicable_sales_tax / 100))
        payment.total_amount = payment.amount * (1 + (@job.applicable_sales_tax / 100))
        payment.save
        # logger.debug payment.inspect
      end

      # Send notice email
      PaymentsMailer.notice_funds_freelancer(current_company, freelancer, @job).deliver
      # logger.debug quote.inspect

    rescue => e
      flash[:error] = e.message
    end

    redirect_to company_job_payments_path, job_id: @job.id
  end

  def show
    @accepted_quote = @job.accepted_quote
    # Should be deleted
    if @job.freelancer.stripe_account_id
      account = Stripe::Account.retrieve(@job.freelancer.stripe_account_id)
      account.payout_schedule.interval = 'manual'
      account.save
    else
      flash[:error] = "The freelancer identity is not verified yet!"
    end
  end

  def edit
    build_payments
  end

  def update

    redirect_to company_job_path(@job), notice: "You can't edit the work order after it's accepted by the freelancer!" if @job.contracted?

    if params.dig(:job, :send_contract) == "true"
      @send_contract = true
    else
      @send_contract = false
    end

    if @job.update(job_params)
      if @send_contract
        @m = Message.new
        @m.authorable = @job.company
        @m.receivable = @job.freelancer
        @m.send_contract = true
        @m.body = "Hi #{@job.freelancer.name}! This is a note to let you know that we've just sent a work order to you. <a href='/freelancer/jobs/#{@job.id}/work_order'>Click here</a> to view it!"
        @m.save

        @job.messages << @m

        # TODO: Add bit of code here that sets something in the table to denote being sent?
        @job.contract_sent = true
        @job.save
      end
      redirect_to company_job_path(@job), notice: "Work Order updated." if !@job.contracted?
    else
      build_payments

      @errors = []
      @number_of_payments_error = false
      @total_of_payments_error = false
      @job.errors.messages.each do |key, index|

        if key == :number_of_payments
          @number_of_payments_error = true
        elsif key == :total_of_payments
          @total_of_payments_error = true
        else
          @errors << key.to_s.underscore.humanize.titlecase
        end
      end

      @combined_errors = @errors.join(",")

      if @number_of_payments_error
        @combined_errors << "Payments (At least 1 is required)"
      elsif @total_of_payments_error
        @combined_errors << "Wrong payments amount!"
      end

      flash[:error] = "Unable to save: the following fields need to be filled out: " + @combined_errors + ". If any of the fields aren't visible on the contract page, you might need to provide additional information in the job details page."
      render :edit
    end
  end


  private

    def set_job
      @job = current_company.jobs.find(params[:job_id])
    end

    def job_params
      params.require(:job).permit(
        :scope_of_work,
        :scope_file,
        :addendums,
        :contract_price,
        :send_contract,
        :starts_on,
        :ends_on,
        :pay_type,
        :applicable_sales_tax,
        :freelancer_type,
        :working_time,
        :state,
        :reporting_frequency,
        :require_photos_on_updates,
        :require_checkin,
        :require_uniform,
        :opt_out_of_freelance_service_agreement,
        attachments_attributes: [:id, :file, :_destroy],
        payments_attributes: [:id, :description, :company_id, :amount, :_destroy]
      )
    end

    def build_payments
      payments_to_build = [(3 - @job.payments.size), 1].max
      payments_to_build.times do
        @job.payments.build
      end
    end
end
