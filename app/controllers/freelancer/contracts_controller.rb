class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
    authorize @job
  end

  def accept
    @job = Job.find(params[:id])
    authorize @job

    # render :show if @job.state == "contracted"

    @job.state = "contracted"
    @job.contracted_at = Time.zone.today
    @job.save

    currency = CurrencyRate.where('currency = ?', @job.currency).first
    currency_rate = currency.nil? ?  1 : currency.rate


    fees = @job.company.plan.fee_schema['company_fees']

    if @job.company.waived_jobs.positive?
      logger.debug "Waived job"
      plan_fees = 0
      @job.company.waived_jobs -= 1
      @job.company.save
    else
      plan_tax = @job.company.canada_country? ? 1 + (Subscription::CANADA_SALES_TAX_PERCENT/100) : 1
      plan_fees =  fees.to_f / 100 * @job.contract_price.to_f  * plan_tax
    end
    @job.company_plan_fees = plan_fees
    @job.save

    # Send notice emails
    FreelancerMailer.notice_work_order_accepted(current_user, @job.company, @job).deliver_later
    CompanyMailer.notice_work_order_accepted(@job.company, current_user, @job).deliver_later

    render :show
  end
end
