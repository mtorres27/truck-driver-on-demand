class Company::JobPaymentsController < Company::BaseController
  before_action :set_job
  before_action :set_payment, except: [:index]

  def index
    logger.debug "AVA-START"
    @taxes = TaxTool.new({
      "line1": "1040 Grant Rd #310",
      "city": "Mountain View",
      "region": "CA",
      "country": "US",
      "postalCode": "94040"
      }, {"line1": "100 Market Street",
      "city": "San Francisco",
      "region": "CA",
      "country": "US",
      "postalCode": "94105"
    })
    @taxes.add_line({description: 'M1', amount: 100});
    @taxes.add_line({description: 'M2', amount: 200});
    @taxes.add_line({description: 'M3', amount: 300});
    logger.debug @taxes.calculate_tax.inspect
    logger.debug "AVA-END"
    @payments = @job.payments.order(:created_at)
    @accepted_quote = @job.accepted_quote

    # balance = Stripe::Balance.retrieve(
    #   # :stripe_account => @job.freelancer.stripe_account_id
    # )
    # logger.debug balance.inspect
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

      total_amount = quote.amount * 100
      platform_fees = quote.platform_fees_amount * 100
      freelancer_amount = ((total_amount - platform_fees) * (@payment.amount * 100)) / total_amount
      logger.debug  freelancer_amount
      Stripe::Payout.create({
        amount: freelancer_amount.floor,
        currency: @job.currency
      },{
        stripe_account: freelancer.stripe_account_id
      })

      @payment.mark_as_paid!

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
