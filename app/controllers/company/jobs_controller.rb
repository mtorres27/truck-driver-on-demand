# frozen_string_literal: true

class Company::JobsController < Company::BaseController

  before_action :set_job, except: %i[job_countries new create index]
  before_action :authorize_job, except: %i[job_countries new create index]

  def index
    @jobs = current_company.jobs
    @jobs = @jobs.page(params[:page]).per(10)
  end

  def show
    if @job.state == "published"
      get_matches
      @repliers = @job.repliers
    else
      @drivers = Driver.none
      @repliers = Driver.none
    end
    @drivers = @drivers.page(params[:page]).per(10)
  end

  def new
    @job = current_company.jobs.new
  end

  def create
    @job = current_company.jobs.new(job_params)

    if @job.save
      if @job.state == "published"
        JobNotificationMailer.notify_job_posting_company(current_company, @job).deliver_later
        get_matches
        @drivers.each do |driver|
          JobNotificationMailer.notify_job_posting(driver, @job).deliver_later
        end
      end
      redirect_to company_jobs_path
    else
      render :new
    end
  end

  def edit; end

  def update
    unless @job.errors.empty?
      render :edit
      return
    end

    if @job.update(job_params)
      if @job.state == "published"
        flash[:notice] = "This job has been published."
        JobNotificationMailer.notify_job_posting_company(current_company, @job).deliver_later
        get_matches
        @drivers.each do |driver|
          JobNotificationMailer.notify_job_posting(driver, @job).deliver_later
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
      # rubocop:disable Metrics/LineLength
      job_markets: I18n.t("enumerize.system_integration_job_markets").keys + I18n.t("enumerize.live_events_staging_and_rental_job_markets").keys,
      # rubocop:enable Metrics/LineLength
      technical_skill_tags: I18n.t("enumerize.technical_skill_tags").keys,
      manufacturer_tags: I18n.t("enumerize.manufacturer_tags").keys,
    )
  end

end
