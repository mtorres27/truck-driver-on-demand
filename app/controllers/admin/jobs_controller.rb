class Admin::JobsController < Admin::BaseController
  
    before_action :set_job, only: [:show, :edit, :update, :destroy, :enable, :disable, :login_as]

    def index
      @keywords = params.dig(:search, :keywords).presence
  
      @jobs = Job.order(:title)
      if @keywords
        @jobs = @jobs.search(@jobs)
      end
      @jobs = @jobs.page(params[:page])
    end
  
    def show
    end
  
    def edit
      @company = @job.company
    end
  
    def update
      if @job.update(job_params)
        redirect_to admin_job_path(@job), notice: "Job updated."
      else
        render :edit
      end
    end
  
    def destroy
      @job.destroy
      redirect_to admin_jobs_path, notice: "Jobs removed."
    end
  
    private
  
      def set_job
        @job = Job.find(params[:id])
      end
  
      def job_params
        params.require(:job).permit(
          :title,
          :state,
          :summary,
          :scope_of_work,
          :scope_file,
          :budget,
          :job_type,
          :job_market,
          :job_function,
          :starts_on,
          :ends_on,
          :duration,
          :pay_type,
          :freelancer_type,
          :invite_only,
          :scope_is_public,
          :budget_is_public,
          :contract_price,
          :payment_schedule,
          :reporting_frequency,
          :require_photos_on_updates,
          :require_checkin,
          :require_uniform,
          technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
          manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
        )
      end
  end
  