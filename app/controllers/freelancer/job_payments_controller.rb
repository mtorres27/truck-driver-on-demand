class Freelancer::JobPaymentsController < Freelancer::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index, :create_payment]
  before_action :authorize_job

  def index
    # @job = Job.find(params[:job_id])
    @payments = @job.payments.order(:created_at)
    @connector = StripeAccount.new(current_user)
  end

  def show
    @amount      = @payment.amount
    @tax         = @job.applicable_sales_tax * @payment.amount / 100
    @avj_fees    = @job.company.plan.fee_schema['freelancer_fees'] ? (@amount * @job.company.plan.fee_schema['freelancer_fees'].to_f / 100) : 0
    @avj_t_fees  = @job.company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax - @avj_t_fees
  end

  def print
    @amount      = @payment.amount
    @tax         = @job.applicable_sales_tax * @payment.amount / 100
    @avj_fees    = @job.company.plan.fee_schema['freelancer_fees'] ? (@amount * @job.company.plan.fee_schema['freelancer_fees'].to_f / 100) : 0
    @avj_t_fees  = @job.company.country == 'ca' ? @avj_fees * 1.13 : @avj_fees
    @total       = @amount + @tax - @avj_t_fees
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

  def create_payment
    @payment = @job.payments.build(payment_params)
    @payment.issued_on = Date.today
    @payment.tax_amount = @payment.amount * (@job.applicable_sales_tax/100)
    @payment.total_amount = @payment.amount + @payment.tax_amount
    if @payment.save
      redirect_to freelancer_job_payments_path(@job)
    else
      flash[:error] = @payment.errors.full_messages.to_sentence
      redirect_to :back
    end
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

  def payment_params
    params.require(:payment).permit(
      :company_id,
      :description,
      :amount,
      :time_unit_amount,
      :overtime_hours_amount
    )
  end
end
