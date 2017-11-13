class Company::JobsController < Company::BaseController
  before_action :set_job, only: [:show, :edit, :update, :destroy, :contract, :edit_contract, :update_contract]

  def job_countries
    country = params[:country]
    specs = Stripe::CountrySpec.retrieve(country.upcase)
    render partial: "job_currencies", locals: { currencies: specs.supported_bank_account_currencies } if specs.supported_bank_account_currencies
  end

  def new
    @job = Job.new(project_id: params[:project_id])

    @currencies = [
      ["Canadian Dollars", "cad"],
      ["Euro", "euro"],
      ["Ruble", "ruble"],
      ["Rupee", "rupee"],
      ["US Dollars", "usd"],
      ["Yen", "yen"]
    ]
  end

  def create
    @job = Job.new(job_params)
    @job.company = current_company

    validate_ownership
    if @job.errors.size > 0
      render :new
      return
    end

    @job.published = true if job_params[:published]

    if @job.save
      redirect_to company_job_path(@job)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    validate_ownership
    if @job.errors.size > 0
      render :edit
      return
    end

    if @job.update(job_params)
      if params.dig(:job, :send_contract).presence
        @m = Message.new
        @m.authorable = @job.company
        @m.receivable = @job.freelancer
        @m.send_contract = true
        @m.body = "Hi #{@job.freelancer}! This is a note to let you know that we've just sent a contract to you. <a href='/freelancer/jobs/#{@job.id}/work_order'>Click here</a> to view it!"
        @m.save
      end

      redirect_to company_job_path(@job)
    else
      render :edit
    end
  end


  def destroy
    @job.destroy
    redirect_to company_projects_path, notice: "Job removed."
  end


  private

    def set_job
      @job = current_company.jobs.find(params[:id])
    end

    def validate_ownership
      unless job_params[:project_id].present? && current_company.projects.find(job_params[:project_id])
        @job.errors[:project_id] << "Invalid project selected"
      end
    end

    def job_params
      params.require(:job).permit(
        :project_id,
        :title,
        :summary,
        :scope_of_work,
        :budget,
        :country,
        :currency,
        :job_function,
        :pay_type,
        :starts_on,
        :duration,
        :freelancer_type,
        :invite_only,
        :scope_is_public,
        :budget_is_public,
        :state,
        :address,
        attachments_attributes: [:id, :file, :_destroy],
        keywords: [
          :flat_panel_displays,
          :video_walls,
          :structured_cabling,
          :rack_work,
          :cable_pull,
          :cable_termination,
          :projectors,
          :troubleshooting,
          :service_and_repair,
          :av_programming,
          :interactive_displays,
          :audio,
          :video_conferencing,
          :video_processors,
          :stagehand,
          :lighting,
          :camera,
          :general_labor,
          :installation,
          :rental
        ],
      )
    end
end
