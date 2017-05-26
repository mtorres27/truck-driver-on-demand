class Company::Postings::PaymentsController < Company::BaseController
  before_action :set_job

  def index
    @payments = @job.payments.order(:created_at)
  end

  def request_quote
  end

  def select
  end
end
