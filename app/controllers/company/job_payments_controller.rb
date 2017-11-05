class Company::JobPaymentsController < Company::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]

  def index
    @payments = @job.payments.order(:created_at)
  end

  def show
  end

  def print
    render layout: false
  end

  def mark_as_paid

    transfer = Stripe::Transfer.create({
      :amount => @payment.amount.floor*100,
      :currency => @job.currency,
      :destination => 'acct_1BGHo1CiF2EX0r79', #freelancer.stripe_account_id
      :transfer_group => "{WO-"+ (@job.id.to_s.rjust(5, '0')) +"}",
    })

    @payment.mark_as_paid!

    if @job.payments.outstanding.empty?
      @job.update(state: :completed)
      redirect_to company_job_review_path(@job)
    else
      redirect_to company_job_payments_path(@job)
    end
  end

  private

    def set_job
      @job = current_company.jobs.includes(:payments).find(params[:job_id])
    end

    def set_payment
      @payment = @job.payments.find(params[:id])
    end
end
