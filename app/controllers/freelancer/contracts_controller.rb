class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
    @accepted_quote = @job.accepted_quote
  end

  def accept
    @job = Job.find(params[:id])

    @job.state = "contracted"
    @job.contracted_at = Time.zone.today
    @job.save
    @accepted_quote = @job.accepted_quote

    # calculate avj fees
    plan = @job.company.plan
    currency_rate = CurrencyRate.where("currency = ?", @job.currency).first
    # logger.debug plan.inspect
    # logger.debug currency_rate.inspect
    # Get Amount in USD
    job_amout = @accepted_quote.amount * currency_rate.rate
    if job_amout > 2000
      fees = plan.fee_schema["above_2000"]
      # logger.debug fees
      @job.company_plan_fees = fees * currency_rate.rate
    else
      fees = plan.fee_schema["below_2000"]
      # logger.debug fees
      @job.company_plan_fees = fees * currency_rate.rate
    end
    @job.save

    # Send notice email
    PaymentsMailer.request_funds_company(@job.company, current_freelancer, @job).deliver
    PaymentsMailer.wait_for_funds_freelancer(@job.company, current_freelancer, @job).deliver
    render :show
  end
end