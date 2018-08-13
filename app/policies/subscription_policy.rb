class SubscriptionPolicy < ApplicationPolicy

  def invoice?
    company_user? && company_owner?
  end

  private

  def company_owner?
    record.company&.owner.company_owner?
  end

end
