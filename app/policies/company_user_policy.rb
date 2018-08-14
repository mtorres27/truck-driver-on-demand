class CompanyUserPolicy < ApplicationPolicy

  def index?
    company_admin? || company_manager? || company_owner?
  end

  def show?
    company_admin? || company_manager? || company_owner?
  end

  def new?
    company_owner?
  end

  def edit?
    company_owner?
  end

  def create?
    company_owner?
  end

  def update?
    company_owner?
  end

  def enable?
    company_owner?
  end

  def disable?
    company_owner?
  end

  def destroy?
    company_owner?
  end

  private

  def company_owner?
    return false unless company_user?
    record.company == user.company && user.company_owner?
  end

  def company_manager?
    return false unless company_user?
    record.company == user.company && user.company_manager?
  end

  def company_admin?
    return false unless company_user?
    record.company == user.company && user.company_admin?
  end
end
