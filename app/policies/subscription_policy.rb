class SubscriptionPolicy < ApplicationPolicy

  def invoice?
    company_user? && company_owner?
  end

  private

  def company_owner?
    record.company&.company_user&.id == user.id
  end

end
