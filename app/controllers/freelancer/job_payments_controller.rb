class Freelancer::JobPaymentsController < Freelancer::BaseController
  def index
    @job = Job.find(params[:job_id])
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote
  end

  def request_payout
    payment = Payment.find(params[:payment_id])
    if payment # TODO: check if authorized freelancer
      payment.issued_on = Date.today
      payment.save
    end

    redirect_to freelancer_job_payments_path
  end
end
