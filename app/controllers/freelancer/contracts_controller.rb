class Freelancer::ContractsController < Freelancer::BaseController
  def show
    @job = Job.find(params[:job_id])
  end


  def accept
    @job = Job.find(params[:id])

    @job.state = "contracted"
    @job.save
    
    render :show
  end
end