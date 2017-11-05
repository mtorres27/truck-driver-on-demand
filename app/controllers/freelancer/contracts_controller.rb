class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
  end

  def accept
    @job = Job.find(params[:id])

    @job.state = "contracted"
    @job.save
    @accepted_quote = @job.accepted_quote

    render :show
  end
end