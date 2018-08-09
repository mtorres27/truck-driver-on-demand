class AuditPolicy < ApplicationPolicy

  def index?
    admin?
  end

end
