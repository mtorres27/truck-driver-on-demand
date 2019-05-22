class CompanyUserPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    company_owner? || is_current_user?
  end

  def edit?
    company_owner? || is_current_user?
  end

  def update?
    company_owner? || is_current_user?
  end

  def new?
    company_owner? && has_available_user_slots?
  end

  def create?
    company_owner? && has_available_user_slots?
  end

  def destroy?
    company_owner?
  end

  def enable?
    company_owner?
  end

  def disable?
    company_owner?
  end

  private

  def company_owner?
    user.role == "Owner" && record.company == user.company
  end

  def is_current_user?
    record.id == user.id
  end

  def has_available_user_slots?
    return false unless user.company_user?
    user.company.has_available_user_slots?
  end

end
