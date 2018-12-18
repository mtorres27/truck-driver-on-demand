class ProjectPolicy < ApplicationPolicy

  def index?
    company_user?
  end

  def create?
    company_user? && company_owner?
  end

  def show?
    (company_user? && company_owner?) || admin?
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

  def enable?
    admin?
  end

  def disable?
    admin?
  end

  private

  def company_owner?
    record.company&.id == user.company&.id
  end

end
