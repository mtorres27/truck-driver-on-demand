# frozen_string_literal: true

class JobPolicy < ApplicationPolicy

  def index?
    company_user? || driver? || admin?
  end

  def new?
    (company_user? && company_owner?)
  end

  def create?
    (company_user? && company_owner?) || driver?
  end

  def skip?
    (company_user? && company_owner?)
  end

  def invite_to_quote?
    company_user? && company_owner?
  end

  def show?
    (company_user? && company_owner?) || (driver? && job_published?) || admin?
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
    (company_user? && company_owner?) || driver?
  end

  def accept?
    (company_user? && company_owner?) || driver?
  end

  def decline?
    company_user? && company_owner?
  end

  def request_payout?
    driver?
  end

  def apply?
    driver?
  end

  def my_application?
    driver?
  end

  def driver_matches?
    (company_user? && company_owner? || admin?) && record.state == "published"
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

  def collaborators?
    company_user? && company_owner?
  end

  def add_collaborator?
    company_user? && company_owner?
  end

  def remove_collaborator?
    company_user? && company_owner?
  end

  def subscribe_collaborator?
    company_user? && company_owner?
  end

  def unsubscribe_collaborator?
    company_user? && company_owner?
  end

  private

  def company_owner?
    record.company&.id == user.company&.id
  end

  def driver_hired?
    record.driver&.id == user.id
  end

  def job_published?
    record.state == "published"
  end

end
