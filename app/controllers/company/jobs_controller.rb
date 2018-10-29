class Company::JobsController < Company::BaseController
  before_action :set_job, except: [:job_countries, :new, :create]
  before_action :authorize_job, except: [:job_countries, :new, :create]

  def avj_invoice

  end

  def print_avj_invoice

  end

  def show
    redirect_to company_job_job_build_path(@job.creation_step, job_id: @job.id) unless @job.creation_completed?
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

      if params.dig(:job, :state) == 'published'
        flash[:notice] = "This job has been published."
        get_matches
        @freelancers.each do |freelancer|
          Notification.create(title: @job.title, body: "New job in your area", authorable: @job.company, receivable: freelancer, url: freelancer_job_url(@job))
          JobNotificationMailer.notify_job_posting(freelancer, @job).deliver_later
        end
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

  def freelancer_matches
    get_matches
  end

  def mark_as_finished
    @job.update(state: :completed)
    Notification.create(title: @job.title, body: "This job has been completed", authorable: @job.company, receivable: @job.freelancer, url: freelancer_job_review_url(@job))
    FreelancerMailer.notice_job_complete_freelancer(current_company, @job.freelancer, @job).deliver_later
    CompanyMailer.notice_job_complete_company(current_company, @job.freelancer, @job).deliver_later
    redirect_to company_job_review_path(@job)
  end

  private

  def unsubscribed_redirect?
    false
  end

  def set_job
    @job = current_company.jobs.find(params[:id])
  end

  def authorize_job
    authorize @job
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
      :scope_file,
      :budget,
      :country,
      :currency,
      :job_type,
      :job_market,
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
      :state_province,
      attachments_attributes: [:id, :file, :title, :_destroy],
      technical_skill_tags:  I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags:  I18n.t("enumerize.manufacturer_tags").keys,
    )
  end
end
