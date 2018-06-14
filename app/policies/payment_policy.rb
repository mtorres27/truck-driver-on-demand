class PaymentPolicy < ApplicationPolicy

  def index?
    company_user?
  end

end
