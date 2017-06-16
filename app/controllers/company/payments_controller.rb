class Company::PaymentsController < Company::BaseController
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
    @payment.mark_as_paid!
    redirect_to company_job_payment_path(@job, @payment), notice: "Payment has been marked as paid."
  end

  private

    def set_payment
      @payment = @job.payments.find(params[:id])
    end
end
