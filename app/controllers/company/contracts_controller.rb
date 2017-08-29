class Company::ContractsController < Company::BaseController
  before_action :set_job

  def show
  end

  def edit
    build_payments
  end

  def update
    if @job.update(job_params)
      redirect_to company_job_contract_path(@job)
    else
      build_payments
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
        :addendums,
        :contract_price,
        :starts_on,
        :ends_on,
        :pay_type,
        :freelancer_type,
        :state,
        :reporting_frequency,
        :require_photos_on_updates,
        :require_checkin,
        :require_uniform,
        attachments_attributes: [:id, :file, :_destroy],
        payments_attributes: [:id, :description, :amount, :_destroy]
      )
    end

    def build_payments
      payments_to_build = [(3 - @job.payments.size), 1].max
      payments_to_build.times do
        @job.payments.build
      end
    end
end
