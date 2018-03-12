class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
    @accepted_quote = @job.accepted_quote
  end

  def accept
    @job = Job.find(params[:id])

    @job.state = "contracted"
    @job.save
    @accepted_quote = @job.accepted_quote

    # calculate avj fees
    plan = @job.company.plan
    if @accepted_quote.amount > 2000
      fees = plan.fee_schema["above_2000"]
      @job.avj_fees = fees
    else
      fees = plan.fee_schema["below_2000"]
      @job.avj_fees = fees
    end
    @job.save

    # Send notice email
    PaymentsMailer.request_funds_company(@job.company, current_freelancer, @job).deliver

    render :show
  end
end