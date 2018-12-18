class Company::ContractsController < Company::BaseController
  before_action :set_job
  before_action :authorize_job

  def show
    # Should be deleted
    if @job.freelancer.freelancer_profile&.stripe_account_id
      # account = Stripe::Account.retrieve(@job.freelancer.freelancer_profile&.stripe_account_id)
      # account.payout_schedule.interval = 'manual'
      # account.save
    else
      flash[:error] = "The freelancer identity is not verified yet!"
    end
  end

  def edit
  end

  def update
    redirect_to company_job_path(@job), notice: "You can't edit the work order after it's accepted by the freelancer!" if @job.contracted?

    if @job.update(job_params)
      @m = Message.new
      @m.authorable = @job.company
      @m.receivable = @job.freelancer
      @m.send_contract = true
      @m.body = "Hi #{@job.freelancer.first_name_and_initial}! This is a note to let you know that we've just sent a work order to you. <a href='/freelancer/jobs/#{@job.id}/work_order'>Click here</a> to view it!"
      @m.save
      Notification.create(title: @job.title, body: "You received a work order", authorable: @job.company, receivable: @job.freelancer, url: freelancer_job_work_order_url(@job))
      FreelancerMailer.notice_work_order_received(current_company, @job.freelancer, @job).deliver_later

      @job.messages << @m

      @job.contract_sent = true
      @job.save

      redirect_to company_job_path(@job), notice: "Work Order updated." if !@job.contracted?
    else
      @errors = []
      @job.errors.messages.each do |key, index|
        @errors << key.to_s.underscore.humanize.titlecase
      end

      @combined_errors = @errors.join(",")

      flash[:error] = "Unable to save: the following fields need to be filled out: " + @combined_errors + ". If any of the fields aren't visible on the contract page, you might need to provide additional information in the job details page."
      render :edit
    end
  end


  private

  def unsubscribed_redirect?
    false
  end

  def set_job
    @job = current_user.company.jobs.find(params[:job_id])
  end

  def authorize_job
    authorize @job
  end

  def job_params
    params.require(:job).permit(
      :enforce_contract_creation,
      :accepted_applicant_id,
      :scope_of_work,
      :scope_file,
      :addendums,
      :contract_price,
      :payment_terms,
      :overtime_rate,
      :starts_on,
      :ends_on,
      :pay_type,
      :variable_pay_type,
      :applicable_sales_tax,
      :freelancer_type,
      :working_time,
      :state,
      :reporting_frequency,
      :require_photos_on_updates,
      :require_checkin,
      :require_uniform,
      :opt_out_of_freelance_service_agreement,
      attachments_attributes: [:id, :file, :title, :_destroy]
    )
  end
end
