class Company::ContractsController < Company::BaseController
  before_action :set_job

  def contract_pay
    begin
      quote = @job.accepted_quote
      freelancer = @job.freelancer

      amount = quote.amount * 100
      freelancer_amount = quote.amount * (1 - Rails.configuration.avj_fees) * 100
      platform_fees = (quote.amount * 100) - freelancer_amount
      charge = Stripe::Charge.create({
        amount: amount.floor,
        currency: @job.currency,
        source: params[:stripeToken],
        destination: {
          amount: freelancer_amount.floor,
          account: freelancer.stripe_account_id
        },
      })
      quote.paid_by_company = true
      quote.paid_at = DateTime.now
      quote.platform_fees_amount = platform_fees / 100
      quote.save
    rescue => e
      flash[:error] = e.message
    end

    redirect_to company_job_work_order_path, job_id: @job.id
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
      redirect_to company_job_path(@job), notice: "Work Order updated."
    else
      build_payments

      @errors = []
      @number_of_payments_error = false
      @job.errors.messages.each do |key, index|

        if key == :number_of_payments
          @number_of_payments_error = true
        else
          @errors << key.to_s.underscore.humanize.titlecase
        end
      end

      @combined_errors = @errors.join(",")

      if @number_of_payments_error
        @combined_errors << "Payments (At least 1 is required)"
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
