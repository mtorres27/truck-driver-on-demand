class Company::JobsController < Company::BaseController
  before_action :set_job, except: [:job_countries, :new, :create, :index]
  before_action :authorize_job, except: [:job_countries, :new, :create, :index]

  def index
    @jobs = current_company.jobs
  end

  def show
    get_matches
  end

  def new
    @job = current_company.jobs.new
  end

  def create
    @job = current_company.jobs.new(job_params)

    if @job.save
      if @job.state == 'published'
        flash[:notice] = "This job has been published."
        get_matches
        @freelancers.each do |freelancer|
          next if Notification.where(receivable: freelancer, url: freelancer_job_url(@job)).count > 0
          Notification.create(title: @job.title, body: "New job in your area", authorable: @job.company, receivable: freelancer, url: freelancer_job_url(@job))
          JobNotificationMailer.notify_job_posting(freelancer, @job).deliver_later
        end
      else
        flash[:notice] = "This job has been published."
      end
      redirect_to company_jobs_path
    else
      binding.pry
      flash[:error] = "Please provide valid information"
      render :new
    end
  end

  def edit
  end

  def update
    if @job.errors.size > 0
      render :edit
      return
    end

    if @job.update(job_params)
      if @job.state == 'published'
        flash[:notice] = "This job has been published."
        get_matches
        @freelancers.each do |freelancer|
          next if Notification.where(receivable: freelancer, url: freelancer_job_url(@job)).count > 0
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
    redirect_to company_jobs_path, notice: "Job removed."
  end

  def mark_as_finished
    @job.update(state: :completed)
    Notification.create(title: @job.title, body: "This job has been completed", authorable: @job.company, receivable: @job.freelancer, url: freelancer_job_review_url(@job))
    FreelancerMailer.notice_job_complete_freelancer(current_company, @job.freelancer, @job).deliver_later
    @job.collaborators_for_notifications.each do |collaborator|
      CompanyMailer.notice_job_complete_company(collaborator, @job.freelancer, @job).deliver_later
    end
    redirect_to company_job_review_path(@job)
  end

  def collaborators
    @collaborators = @job.job_collaborators
    @non_collaborators = current_company.company_users.where.not(id: @collaborators.map(&:user).map(&:id), enabled: false)
  end

  def add_collaborator
    @collaborator = current_company.company_users.find(params[:company_user_id])
    if @collaborator.present?
      @job.job_collaborators.create(user_id: @collaborator.id)
      CompanyMailer.notice_added_as_collaborator(@collaborator, @job).deliver_later
      Notification.create(title: @job.title, body: "You've been added as a collaborator", authorable: current_user, receivable: @collaborator, url: company_job_url(@job))
      flash[:notice] = "Collaborator added to this job."
    else
      flash[:error] = "You're trying to add a collaborator from outside of your company."
    end
    redirect_to collaborators_company_job_path(@job)
  end

  def remove_collaborator
    @collaborator = @job.job_collaborators.find_by(user_id: params[:company_user_id])
    if @collaborator.present? && @collaborator.destroy
      flash[:notice] = "Collaborator removed from this job."
    else
      flash[:error] = "An error occurred while trying to process your request."
    end
    redirect_to collaborators_company_job_path(@job)
  end

  def unsubscribe_collaborator
    @collaborator = @job.job_collaborators.find_by(user_id: params[:company_user_id])
    if @collaborator.present? && @collaborator.update_attribute(:receive_notifications, false)
      flash[:notice] = "Collaborator unsubscribed from notifications on this job."
    else
      flash[:error] = "An error occurred while trying to process your request."
    end
    redirect_to collaborators_company_job_path(@job)
  end

  def subscribe_collaborator
    @collaborator = @job.job_collaborators.find_by(user_id: params[:company_user_id])
    if @collaborator.present? && @collaborator.update_attribute(:receive_notifications, true)
      flash[:notice] = "Collaborator subscribed to notifications on this job."
    else
      flash[:error] = "An error occurred while trying to process your request."
    end
    redirect_to collaborators_company_job_path(@job)
  end

  private

  def set_job
    @job = current_company.jobs.find(params[:id])
  end

  def authorize_job
    authorize @job
  end

  def job_params
    params.require(:job).permit(
      :title,
      :summary,
      :country,
      :state,
      :address,
      :state_province,
      job_markets: I18n.t("enumerize.system_integration_job_markets").keys + I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys,
      technical_skill_tags: I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags: I18n.t("enumerize.manufacturer_tags").keys,
    )
  end
end
