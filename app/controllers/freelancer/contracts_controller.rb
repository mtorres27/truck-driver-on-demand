class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
    authorize @job
  end

  def accept
    @job = Job.find(params[:id])
    authorize @job

    @job.state = "contracted"
    @job.contracted_at = Time.zone.today
    @job.save

    currency = CurrencyRate.where('currency = ?', @job.currency).first
    currency_rate = currency.nil? ?  1 : currency.rate


    fees = @job.company.plan.fee_schema['company_fees']
    plan_tax = @job.company.canada_country? ? 1 + (Subscription::CANADA_SALES_TAX_PERCENT/100) : 1
    plan_fees =  fees.to_f / 100 * @job.contract_price.to_f  * plan_tax

    @job.company_plan_fees = plan_fees
    @job.save

    # Send notice emails
    FreelancerMailer.notice_work_order_accepted(current_user, @job.company, @job).deliver_later
    Notification.create(title: @job.title, body: "#{current_user.first_name_and_initial} accepted your work order", authorable: current_user, receivable: @job.company, url: company_job_url(@job))
    CompanyMailer.notice_work_order_accepted(@job.company, current_user, @job).deliver_later

    render :show
  end
end
