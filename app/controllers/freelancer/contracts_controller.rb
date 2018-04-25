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

    currency = CurrencyRate.where('currency = ?', @job.currency).first
    currency_rate = currency.nil? ?  1 : currency.rate

    # Get Amount in USD
    job_amout = @accepted_quote.amount / currency_rate
    if @job.company.waived_jobs.positive?
      plan_fees = 0
      @job.company.waived_jobs = @job.company.waived_jobs - 1
      @job.company.save
    else
      plan = @job.company.plan
      if job_amout > 2000
        fees = plan.fee_schema['above_2000']
      else
        fees = plan.fee_schema['below_2000']
      end
      plan_tax = @job.company.country == 'ca' ? 1.13 : 1
      plan_fees = ( fees.to_i * currency_rate ) * plan_tax
    end
    @job.company_plan_fees = plan_fees
    @job.save

    # Send notice email
    PaymentsMailer.request_funds_company(@job.company, current_freelancer, @job).deliver_later
    PaymentsMailer.wait_for_funds_freelancer(@job.company, current_freelancer, @job).deliver_later
    render :show
  end
end