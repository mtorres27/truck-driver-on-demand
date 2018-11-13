class SubscriptionPolicy < ApplicationPolicy

  def invoice?
    company_user? && company_owner?
  end

  private

  def company_owner?
    record.company&.id == user.company&.id
  end

end
