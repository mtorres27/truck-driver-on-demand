class JobPolicy < ApplicationPolicy

  def index?
    company_user? || freelancer? || admin?
  end

  def new?
    (company_user? && company_owner? && company_subscribed_to_plan?)
  end

  def create?
    (company_user? && company_owner?) || freelancer?
  end

  def skip?
    (company_user? && company_owner?)
  end

  def invite_to_quote?
    company_user? && company_owner?
  end

  def show?
    (company_user? && company_owner?) || freelancer? || admin?
  end

  def edit?
    (company_user? && company_owner?) || admin?
  end

  def update?
    (company_user? && company_owner?) || admin?
  end

  def destroy?
    (company_user? && company_owner?) || admin?
  end

  def request_quote?
    company_user? && company_owner?
  end

  def ignore?
    company_user? && company_owner?
  end

  def contract_pay?
    company_user? && company_owner?
  end

  def mark_as_paid?
    company_user? && company_owner?
  end

  def print?
    (company_user? && company_owner?) || freelancer?
  end

  def accept?
    (company_user? && company_owner?) || freelancer?
  end

  def decline?
    company_user? && company_owner?
  end

  def request_payout?
    freelancer?
  end

  def apply?
    freelancer?
  end

  def my_application?
    freelancer?
  end

  def freelancer_matches?
    (company_user? && company_owner? || admin?) && record.state == 'published'
  end

  def contract_invoice?
    company_user? && company_owner?
  end

  def mark_as_finished?
    company_user? && company_owner?
  end

  def mark_as_expired?
    admin?
  end

  def unmark_as_expired?
    admin?
  end

  private

  def company_owner?
    record.company&.company_user&.id == user.id
  end

  def company_subscribed_to_plan?
    record.company&.plan.present?
  end

  def freelancer_hired?
    record.freelancer&.id == user.id
  end

end
