class Company::Postings::ContractsController < Company::BaseController
  before_action :set_job

  def show
  end

  def edit
    build_payments
  end

  def update
    if @job.update(job_params)
      redirect_to company_postings_job_contract_path(@job), notice: "Contract updated."
    else
      build_payments
      render :edit
    end
  end


  private

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
