class NotificationPolicy < ApplicationPolicy

  def show?
    belongs_to_user?
  end

  private

  def belongs_to_user?
    if record.receivable_type == "User"
      record.receivable_id == user.id
    elsif record.receivable_type == "Company"
      record.receivable_id == user.company&.id
    end
  end

end
