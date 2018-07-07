class PlanPolicy < ApplicationPolicy

  def show?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

end
