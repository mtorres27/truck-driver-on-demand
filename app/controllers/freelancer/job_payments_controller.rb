class Freelancer::JobPaymentsController < Freelancer::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]

  def index
    # @job = Job.find(params[:job_id])
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote
  end

  def show
  end

  def print
    render layout: false
  end

  def request_payout
    # payment = Payment.find(params[:payment_id])
    @payment.issued_on = Date.today
    @payment.save
    redirect_to freelancer_job_payments_path(job_id: @job.id)
  end

  private
    def set_job
      @job = current_freelancer.jobs.includes(:payments).find(params[:job_id])
    end

    def set_payment
      @payment = @job.payments.find(params[:id])
    end
end
