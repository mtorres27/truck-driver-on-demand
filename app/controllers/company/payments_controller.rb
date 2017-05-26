class Company::PaymentsController < Company::BaseController

  def index
    @payments = current_company.payments.order(:created_at)
  end

  def request_quote
  end

  def select
  end
end
