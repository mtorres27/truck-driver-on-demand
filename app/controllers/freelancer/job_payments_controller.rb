class Freelancer::JobPaymentsController < Freelancer::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]
  before_action :authorize_job

  def index
    # @job = Job.find(params[:job_id])
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote
    @connector = StripeAccount.new(current_user)

    if @accepted_quote.paid_by_company && !@job.funds_available && @job.stripe_balance_transaction_id.present?
      balance_transaction = Stripe::BalanceTransaction.retrieve(@job.stripe_balance_transaction_id, stripe_account: @job.freelancer.stripe_account_id)
      if balance_transaction[:status] == 'pending'
        @job.funds_available_on = balance_transaction[:available_on]
      else
        @job.funds_available = true
      end
      @job.save
    end
  end

  def show
    @amount      = @payment.amount
    @tax         = @job.applicable_sales_tax * @payment.amount / 100
    @avj_fees    = @job.company.plan.fee_schema['freelancer_fees'] ? (@amount * @job.company.plan.fee_schema['freelancer_fees'].to_f / 100) : 0
    @avj_t_fees  = @job.company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax - @avj_t_fees
  end

  def print
    render layout: false
  end

  def request_payout
    # payment = Payment.find(params[:payment_id])
    @payment.issued_on = Date.today
    @payment.save
    # Send notice email
    PaymentsMailer.request_payout_company(@job.company, current_user, @job, @payment).deliver_later
    redirect_to freelancer_job_payments_path(job_id: @job.id)
  end

  private
  def set_job
    @job = current_user.jobs.includes(:payments).find(params[:job_id])
  end

  def set_payment
    @payment = @job.payments.find(params[:id])
  end

  def authorize_job
    authorize @job
  end
end
