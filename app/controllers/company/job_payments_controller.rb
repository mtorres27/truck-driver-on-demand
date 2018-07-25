class Company::JobPaymentsController < Company::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]
  before_action :authorize_job

  def index
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote
    @connector = StripeAccount.new(@job.freelancer)

    if @accepted_quote.paid_by_company && !@job.funds_available && @job.stripe_balance_transaction_id.present?
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
    @avj_fees    = current_company.plan.fee_schema['avj_fees'] ? (@amount * current_company.plan.fee_schema['avj_fees'].to_f / 100) : 0
    @avj_t_fees  = current_company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax + @avj_t_fees
  end

  def print
    render layout: false
  end

  def mark_as_paid
    quote = @job.accepted_quote
    freelancer = @job.freelancer
    begin
      raise Exception.new('You didn\'t pay this work order yet!') if !quote.paid_by_company
      money = @payment.total_amount - @payment.avj_fees

      Stripe::Payout.create({
        amount: (money * 100).floor,
        currency: @job.currency
      },{
        stripe_account: freelancer.freelancer_profile.stripe_account_id
      })

      @payment.mark_as_paid!

      # Send notice email
      PaymentsMailer.notice_payout_freelancer(current_user, freelancer, @job, @payment).deliver_later

      if @job.payments.outstanding.empty?
        @job.update(state: :completed)
        FreelancerMailer.notice_job_complete_freelancer(current_user, freelancer, @job).deliver_later
        CompanyMailer.notice_job_complete_company(current_user, freelancer, @job).deliver_later
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
