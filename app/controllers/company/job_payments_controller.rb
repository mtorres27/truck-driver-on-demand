class Company::JobPaymentsController < Company::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]

  def index
    # logger.debug @job.inspect
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote

    balance = Stripe::Balance.retrieve(
      # :stripe_account => @job.freelancer.stripe_account_id
    )
    logger.debug balance.inspect
  end

  def show
  end

  def print
    render layout: false
  end

  def mark_as_paid
    quote = @job.accepted_quote
    freelancer = @job.freelancer
    begin
      raise Exception.new('You didn\'t pay this work order yet!') if !quote.paid_by_company
      # logger.debug (@payment.total_amount - @payment.avj_fees)
      Stripe::Payout.create({
        amount: (@payment.total_amount - @payment.avj_fees).floor,
        currency: @job.currency
      },{
        stripe_account: freelancer.stripe_account_id
      })

      @payment.mark_as_paid!

      # Send notice email
      PaymentsMailer.notice_payout_freelancer(current_company, freelancer, @job, @payment).deliver

      if @job.payments.outstanding.empty?
        @job.update(state: :completed)
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
end
