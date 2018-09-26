class Admin::JobPaymentsController < Admin::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]
  before_action :authorize_job

  def index
    # logger.debug @job.inspect
    @payments = @job.payments.order(:created_at)
    @connector = StripeAccount.new(@job.freelancer)

    if @job.paid_by_company && !@job.funds_available && @job.stripe_balance_transaction_id.present?
      balance_transaction = Stripe::BalanceTransaction.retrieve(@job.stripe_balance_transaction_id, stripe_account: @job.freelancer.freelancer_profile.stripe_account_id)
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
    @avj_fees    = @job.company_plan_fees == 0 ? 0 : @job.fee_schema['company_fees'] ? (@amount * @job.fee_schema['company_fees'].to_f / 100) : 0
    @avj_t_fees  = @job.company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax + @avj_t_fees
  end

  private

  def set_job
    @job = Job.all.includes(:payments).find(params[:job_id])
  end

  def set_payment
    @payment = @job.payments.find(params[:id])
  end

  def authorize_job
    authorize @job
  end
end
