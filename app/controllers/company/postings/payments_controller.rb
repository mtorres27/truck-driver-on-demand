class Company::Postings::PaymentsController < Company::BaseController
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
    redirect_to company_postings_job_payments_path(@job), notice: "Payment has been marked as paid."
  end

  private

    def set_payment
      @payment = @job.payments.find(params[:id])
    end
end
