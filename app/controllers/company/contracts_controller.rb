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

    if params.dig(:job, :send_contract) == "true"
      @send_contract = true
    else
      @send_contract = false
    end

    if @job.update(job_params)
      if @send_contract
        @m = Message.new
        @m.authorable = @job.company
        @m.receivable = @job.freelancer
        @m.send_contract = true
        @m.body = "Hi #{@job.freelancer.first_name_and_initial}! This is a note to let you know that we've just sent a work order to you. <a href='/freelancer/jobs/#{@job.id}/work_order'>Click here</a> to view it!"
        @m.save
        FreelancerMailer.notice_work_order_received(current_company, @job.freelancer, @job).deliver_later

        @job.messages << @m

        # TODO: Add bit of code here that sets something in the table to denote being sent?
        @job.contract_sent = true
        @job.save

      end
      redirect_to company_job_path(@job), notice: "Work Order updated." if !@job.contracted?
    else

      @errors = []
      @number_of_payments_error = false
      @total_of_payments_error = false
      @job.errors.messages.each do |key, index|

        if key == :number_of_payments
          @number_of_payments_error = true
        elsif key == :total_of_payments
          @total_of_payments_error = true
        else
          @errors << key.to_s.underscore.humanize.titlecase
        end
      end

      @combined_errors = @errors.join(",")

      if @number_of_payments_error
        @combined_errors << "Payments (At least 1 is required)"
      elsif @total_of_payments_error
        @combined_errors << "Wrong payments amount!"
      end

      flash[:error] = "Unable to save: the following fields need to be filled out: " + @combined_errors + ". If any of the fields aren't visible on the contract page, you might need to provide additional information in the job details page."
      render :edit
    end
  end


  private

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
      :send_contract,
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
      attachments_attributes: [:id, :file, :title, :_destroy],
      payments_attributes: [:id, :description, :company_id, :amount, :_destroy]
    )
  end
end
