class Company::JobPaymentsController < Company::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]
  before_action :authorize_job

  def index
    @payments = @job.payments.order(:created_at)
    @connector = StripeAccount.new(@job.freelancer)
  end

  def show
    @amount      = @payment.amount
    @tax         = @job.applicable_sales_tax * @payment.amount / 100
    @avj_fees    = @job.company_plan_fees == 0 ? 0 : current_company.plan.fee_schema['company_fees'] ? (@amount * current_company.plan.fee_schema['company_fees'].to_f / 100) : 0
    @avj_t_fees  = current_company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax + @avj_t_fees
  end

  def print
    @amount      = @payment.amount
    @tax         = @job.applicable_sales_tax * @payment.amount / 100
    @avj_fees    = @job.company_plan_fees == 0 ? 0 : current_company.plan.fee_schema['company_fees'] ? (@amount * current_company.plan.fee_schema['company_fees'].to_f / 100) : 0
    @avj_t_fees  = current_company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax + @avj_t_fees
    render layout: false
  end

  def mark_as_paid
    freelancer             = @job.freelancer
    currency_rate          = CurrencyExchange.get_currency_rate(@job.currency)
    amount                 = @payment.amount
    tax                    = @job.applicable_sales_tax * @payment.amount / 100
    company_fees_rate      = @job.company_plan_fees.zero? ? 0 : current_company.plan.fee_schema['company_fees'].to_f
    freelancer_fees_rate   = current_company.plan.fee_schema['freelancer_fees'].to_f
    company_fees           = @job.company_plan_fees.zero? ? 0 : company_fees_rate != 0 ? (amount * company_fees_rate.to_f / 100) : 0
    company_t_fees         = current_company.country == 'ca' ? company_fees * 1.13 : company_fees
    freelancer_fees        = (amount * freelancer_fees_rate.to_f / 100)
    freelancer_t_fees      = @job.freelancer.freelancer_profile.country == 'ca' ? freelancer_fees * 1.13 : freelancer_fees

    @payment.set_avj_credit(freelancer_t_fees)

    freelancer_t_fees = freelancer_t_fees - @payment.avj_credit
    application_fees  = company_t_fees + freelancer_t_fees
    total             = amount + tax + company_t_fees
    transaction_fees  = total * 0.029 + (0.3 * currency_rate)
    begin
      # NEW
      charge = Stripe::Charge.create({
                   amount: (total * 100).floor ,
                   currency: @job.currency,
                   source: params[:stripeToken],
                   description: "Invoice ##{@payment.id}",
                   statement_descriptor: "AV Junction-(##{@payment.id})",
                   application_fee: ((application_fees - transaction_fees) * 100).floor
               }, stripe_account: freelancer.freelancer_profile&.stripe_account_id)
      logger.debug charge.inspect
      balance_transaction = Stripe::BalanceTransaction.retrieve(charge[:balance_transaction], stripe_account: freelancer.freelancer_profile.stripe_account_id)
      logger.debug balance_transaction.inspect
      if balance_transaction[:status] == 'pending'
        @payment.funds_available_on = balance_transaction[:available_on]
      else
        @payment.funds_available = true
      end
      # Calculations
      @payment.company_fees                   = company_fees
      @payment.total_company_fees             = company_t_fees
      @payment.freelancer_fees                = freelancer_fees
      @payment.total_freelancer_fees          = freelancer_t_fees
      @payment.transaction_fees               = total * 0.029 + (0.3 * currency_rate)
      @payment.total_amount                   = total
      @payment.freelancer_avj_fees_rate       = freelancer_fees_rate
      @payment.company_avj_fees_rate          = company_fees_rate

      @payment.stripe_charge_id               = charge[:id]
      @payment.stripe_balance_transaction_id  = charge[:balance_transaction]
      @payment.save

      @payment.mark_as_paid!

      @job.update_attribute(:total_amount, @job.total_amount.to_f + @payment.total_amount)

      # Send notice email
      PaymentsMailer.notice_payout_freelancer(current_company, freelancer, @job, @payment).deliver_later
      #
      if @job.pay_type == "fixed" && @job.payments.outstanding.empty?
        @job.update(state: :completed)
        FreelancerMailer.notice_job_complete_freelancer(current_company, freelancer, @job).deliver_later
        CompanyMailer.notice_job_complete_company(current_company, freelancer, @job).deliver_later
        redirect_to company_job_review_path(@job)
      else
        redirect_to company_job_payments_path(@job)
      end
    rescue Exception => e
      flash[:error] = e.message
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

  def authorize_job
    authorize @job
  end
end
