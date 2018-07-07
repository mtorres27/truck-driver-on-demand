class NotificationPolicy < ApplicationPolicy

  def index?
    company_user?
  end

end
