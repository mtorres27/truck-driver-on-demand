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

    # Send notice email
    PaymentsMailer.request_funds_company(@job.company, current_freelancer, @job).deliver

    render :show
  end
end