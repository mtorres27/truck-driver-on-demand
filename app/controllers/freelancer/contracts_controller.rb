class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
    authorize @job
    @accepted_quote = @job.accepted_quote
  end

  def accept
    @job = Job.find(params[:id])
    authorize @job

    # render :show if @job.state == "contracted"

    @job.state = "contracted"
    @job.contracted_at = Time.zone.today
    @job.save
    @accepted_quote = @job.accepted_quote

    currency = CurrencyRate.where('currency = ?', @job.currency).first
    currency_rate = currency.nil? ?  1 : currency.rate

    # Get Amount in USD
    job_amount = @accepted_quote.amount / currency_rate

    fees = @job.company.plan.fee_schema['company_fees']
      # if job_amout > 2000
      #   fees = plan.
      # else
      #   fees = plan.fee_schema['below_2000']
      # end

    if @job.company.waived_jobs.positive?
      logger.debug "Waived job"
      plan_fees = 0
      @job.company.waived_jobs -= 1
      @job.company.save
    else
      plan_tax = @job.company.canada_country? ? 1 + (Subscription::CANADA_SALES_TAX_PERCENT/100) : 1
      plan_fees =  fees.to_f / 100 * job_amount.to_f  * plan_tax
      logger.debug "Paid job"
      logger.debug fees.to_i
      logger.debug job_amount.to_f
      logger.debug (fees.to_f / 100)
      logger.debug ( fees.to_i / 100 * job_amount.to_f )
      logger.debug ( fees.to_i / 100 * job_amount.to_f ) * plan_tax
      logger.debug plan_fees
    end
    @job.company_plan_fees = plan_fees
    @job.save

    @accepted_quote.plan_fee = plan_fees
    @accepted_quote.save

    # Send notice email
    PaymentsMailer.request_funds_company(@job.company, current_user, @job).deliver_later
    PaymentsMailer.wait_for_funds_freelancer(@job.company, current_user, @job).deliver_later
    render :show
  end
end
